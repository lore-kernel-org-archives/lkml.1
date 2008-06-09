Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbYFIOsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbYFIOsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbYFIOse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:48:34 -0400
Received: from sacred.ru ([62.205.161.221]:48197 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789AbYFIOse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:48:34 -0400
Message-ID: <484D4228.40507@openvz.org>
Date: Mon, 09 Jun 2008 18:46:00 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] pidns: remove find_task_by_pid, unused for a long time
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 09 Jun 2008 18:48:14 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems to me that it was a mistake marking this function as
deprecated and scheduling it for removal, rather than resolutely
removing it after the last caller's death.

Anyway - better late, then never.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 Documentation/feature-removal-schedule.txt |   18 ------------------
 include/linux/pid.h                        |    2 +-
 include/linux/sched.h                      |    6 ------
 3 files changed, 1 insertions(+), 25 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 41013d4..44d515b 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -138,24 +138,6 @@ Who:	Kay Sievers <kay.sievers@suse.de>
 
 ---------------------------
 
-What:	find_task_by_pid
-When:	2.6.26
-Why:	With pid namespaces, calling this funciton will return the
-	wrong task when called from inside a namespace.
-
-	The best way to save a task pid and find a task by this
-	pid later, is to find this task's struct pid pointer (or get
-	it directly from the task) and call pid_task() later.
-
-	If someone really needs to get a task by its pid_t, then
-	he most likely needs the find_task_by_vpid() to get the
-	task from the same namespace as the current task is in, but
-	this may be not so in general.
-
-Who:	Pavel Emelyanov <xemul@openvz.org>
-
----------------------------
-
 What:	ACPI procfs interface
 When:	July 2008
 Why:	ACPI sysfs conversion should be finished by January 2008.
diff --git a/include/linux/pid.h b/include/linux/pid.h
index ff1b2a5..22921ac 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -107,7 +107,7 @@ extern struct pid_namespace init_pid_ns;
  * find_pid_ns() finds the pid in the namespace specified
  * find_vpid() finr the pid by its virtual id, i.e. in the current namespace
  *
- * see also find_task_by_pid() set in include/linux/sched.h
+ * see also find_task_by_vpid() set in include/linux/sched.h
  */
 extern struct pid *find_pid_ns(int nr, struct pid_namespace *ns);
 extern struct pid *find_vpid(int nr);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7c0443b..b3907c6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1707,8 +1707,6 @@ extern struct pid_namespace init_pid_ns;
  *      finds a task by its pid in the specified namespace
  * find_task_by_vpid():
  *      finds a task by its virtual pid
- * find_task_by_pid():
- *      finds a task by its global pid
  *
  * see also find_vpid() etc in include/linux/pid.h
  */
@@ -1716,10 +1714,6 @@ extern struct pid_namespace init_pid_ns;
 extern struct task_struct *find_task_by_pid_type_ns(int type, int pid,
 		struct pid_namespace *ns);
 
-static inline struct task_struct *__deprecated find_task_by_pid(pid_t nr)
-{
-	return find_task_by_pid_type_ns(PIDTYPE_PID, nr, &init_pid_ns);
-}
 extern struct task_struct *find_task_by_vpid(pid_t nr);
 extern struct task_struct *find_task_by_pid_ns(pid_t nr,
 		struct pid_namespace *ns);
-- 
1.5.3.4

