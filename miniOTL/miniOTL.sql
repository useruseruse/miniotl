-- 사용자 테이블 생성
CREATE TABLE `User` (
                        `user_id` INT AUTO_INCREMENT PRIMARY KEY,
                        `email` VARCHAR(255) UNIQUE NOT NULL,
                        `first_name` VARCHAR(50) NOT NULL,
                        `last_name` VARCHAR(50) NOT NULL,
                        `major` VARCHAR(50) -- 이 컬럼은 외래키로 학과 테이블과 연결될 수 있습니다.
);

-- 학과 테이블 생성
CREATE TABLE `Department` (
                              `department_id` INT AUTO_INCREMENT PRIMARY KEY,
                              `name_kr` VARCHAR(100) NOT NULL,
                              `name_en` VARCHAR(100) NOT NULL,
                              `department_code` CHAR(3) UNIQUE NOT NULL
);

-- 교수 테이블 생성
CREATE TABLE `Professor` (
                             `professor_id` INT AUTO_INCREMENT PRIMARY KEY,
                             `name` VARCHAR(100) NOT NULL
    -- 여기서 교수와 학과의 관계는 다대다 관계이므로 연결 테이블이 필요합니다.
);

-- 교수와 학과의 연결 테이블
CREATE TABLE `Professor_Department` (
                                        `professor_id` INT,
                                        `department_id` INT,
                                        PRIMARY KEY (`professor_id`, `department_id`),
                                        FOREIGN KEY (`professor_id`) REFERENCES `Professor` (`professor_id`),
                                        FOREIGN KEY (`department_id`) REFERENCES `Department` (`department_id`)
);

-- 과목 테이블 생성
CREATE TABLE `Course` (
                          `course_id` INT AUTO_INCREMENT PRIMARY KEY,
                          `name_kr` VARCHAR(255) NOT NULL,
                          `name_en` VARCHAR(255) NOT NULL,
                          `course_code` VARCHAR(10) UNIQUE NOT NULL,
                          `department_id` INT,
                          `credits` INT NOT NULL,
    -- 강의와 실험은 별도의 컬럼이나 테이블로 관리될 수 있습니다.
                          FOREIGN KEY (`department_id`) REFERENCES `Department` (`department_id`)
);

-- 강의 테이블 생성
CREATE TABLE `Lecture` (
                           `lecture_id` INT AUTO_INCREMENT PRIMARY KEY,
                           `course_id` INT,
                           `professor_id` INT,
                           `semester_id` INT,
    -- 시간과 관련된 정보는 추가적으로 필요합니다.
                           FOREIGN KEY (`course_id`) REFERENCES `Course` (`course_id`),
                           FOREIGN KEY (`professor_id`) REFERENCES `Professor` (`professor_id`),
                           FOREIGN KEY (`semester_id`) REFERENCES `Semester` (`semester_id`)
);

-- 학기 테이블 생성
CREATE TABLE `Semester` (
                            `semester_id` INT AUTO_INCREMENT PRIMARY KEY,
                            `year` INT NOT NULL,
                            `term` ENUM('봄', '여름', '가을', '겨울') NOT NULL
);

-- 리뷰 테이블 생성
CREATE TABLE `Review` (
                          `review_id` INT AUTO_INCREMENT PRIMARY KEY,
                          `content` TEXT,
                          `grade` CHAR(1),
                          `relax` CHAR(1),
                          `lecture_quality` CHAR(1),
                          `user_id` INT,
                          `lecture_id` INT,
                          FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`),
                          FOREIGN KEY (`lecture_id`) REFERENCES `Lecture` (`lecture_id`)
);

-- 시간표 테이블 생성
CREATE TABLE `TimeTable` (
                             `timetable_id` INT AUTO_INCREMENT PRIMARY KEY,
                             `user_id` INT,
                             `semester_id` INT,
                             FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`),
                             FOREIGN KEY (`semester_id`) REFERENCES `Semester` (`semester_id`)
);

-- 시간표와 강의의 연결 테이블
CREATE TABLE `TimeTable_Lecture` (
                                     `timetable_id` INT,
                                     `lecture_id` INT,
                                     PRIMARY KEY (`timetable_id`, `lecture_id`),
                                     FOREIGN KEY (`timetable_id`) REFERENCES `TimeTable` (`timetable_id`),
                                     FOREIGN KEY (`lecture_id`) REFERENCES `Lecture` (`lecture_id`)
);
