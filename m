Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbXKEDRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbXKEDRn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 22:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbXKEDRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 22:17:36 -0500
Received: from [222.73.24.84] ([222.73.24.84]:64087 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbXKEDRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 22:17:35 -0500
Message-ID: <472E8AE6.3010401@cn.fujitsu.com>
Date: Mon, 05 Nov 2007 11:15:50 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] POSIX TIMER: coding style: no space between asterisk
 and variable name
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here we delete the space between '*' and the following variable/function
name.

Signed-off-by Li Zefan <lizf@cn.fujitsu.com>

---
 include/linux/posix-timers.h |   16 ++++++++--------
 kernel/posix-timers.c        |    8 ++++----
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index a7dd38f..83adff7 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -67,19 +67,19 @@ struct k_itimer {
 struct k_clock {
 	int res;		/* in nanoseconds */
 	int (*clock_getres) (const clockid_t which_clock, struct timespec *tp);
-	int (*clock_set) (const clockid_t which_clock, struct timespec * tp);
-	int (*clock_get) (const clockid_t which_clock, struct timespec * tp);
+	int (*clock_set) (const clockid_t which_clock, struct timespec *tp);
+	int (*clock_get) (const clockid_t which_clock, struct timespec *tp);
 	int (*timer_create) (struct k_itimer *timer);
 	int (*nsleep) (const clockid_t which_clock, int flags,
 		       struct timespec *, struct timespec __user *);
 	long (*nsleep_restart) (struct restart_block *restart_block);
-	int (*timer_set) (struct k_itimer * timr, int flags,
-			  struct itimerspec * new_setting,
-			  struct itimerspec * old_setting);
-	int (*timer_del) (struct k_itimer * timr);
+	int (*timer_set) (struct k_itimer *timr, int flags,
+			  struct itimerspec *new_setting,
+			  struct itimerspec *old_setting);
+	int (*timer_del) (struct k_itimer *timr);
 #define TIMER_RETRY 1
-	void (*timer_get) (struct k_itimer * timr,
-			   struct itimerspec * cur_setting);
+	void (*timer_get) (struct k_itimer *timr,
+			   struct itimerspec *cur_setting);
 };
 
 void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock);
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index f1461f8..1c4c04c 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -398,7 +398,7 @@ static enum hrtimer_restart posix_timer_fn(struct hrtimer *timer)
 	return ret;
 }
 
-static struct task_struct * good_sigevent(sigevent_t * event)
+static struct task_struct *good_sigevent(sigevent_t *event)
 {
 	struct task_struct *rtn = current->group_leader;
 
@@ -427,7 +427,7 @@ void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock)
 }
 EXPORT_SYMBOL_GPL(register_posix_clock);
 
-static struct k_itimer * alloc_posix_timer(void)
+static struct k_itimer *alloc_posix_timer(void)
 {
 	struct k_itimer *tmr;
 	tmr = kmem_cache_zalloc(posix_timers_cache, GFP_KERNEL);
@@ -462,7 +462,7 @@ static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
 asmlinkage long
 sys_timer_create(const clockid_t which_clock,
 		 struct sigevent __user *timer_event_spec,
-		 timer_t __user * created_timer_id)
+		 timer_t __user *created_timer_id)
 {
 	int error = 0;
 	struct k_itimer *new_timer = NULL;
@@ -593,7 +593,7 @@ out:
  * the find to the timer lock.  To avoid a dead lock, the timer id MUST
  * be release with out holding the timer lock.
  */
-static struct k_itimer * lock_timer(timer_t timer_id, unsigned long *flags)
+static struct k_itimer *lock_timer(timer_t timer_id, unsigned long *flags)
 {
 	struct k_itimer *timr;
 	/*
-- 
1.5.3.rc7

