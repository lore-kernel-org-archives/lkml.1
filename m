Return-Path: <linux-kernel-owner+w=401wt.eu-S1761586AbXK2Hj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761586AbXK2Hj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 02:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759472AbXK2HiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 02:38:19 -0500
Received: from [222.73.24.84] ([222.73.24.84]:53877 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758574AbXK2HiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 02:38:17 -0500
Message-ID: <474E6BBD.3050604@cn.fujitsu.com>
Date: Thu, 29 Nov 2007 15:35:25 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Subject: [PATCH 3/6] timekeeping: rename timekeeping_is_continuous to timekeeping_valid_for_hres
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Function timekeeping_is_continuous() no longer checks flag
CLOCK_IS_CONTINUOUS, and it checks CLOCK_SOURCE_VALID_FOR_HRES
now. So rename the function accordingly.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 include/linux/time.h      |    2 +-
 kernel/time/tick-sched.c  |    2 +-
 kernel/time/timekeeping.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index b04136d..fa21fe5 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -120,7 +120,7 @@ extern void getboottime(struct timespec *ts);
 extern void monotonic_to_bootbased(struct timespec *ts);
 
 extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
-extern int timekeeping_is_continuous(void);
+extern int timekeeping_valid_for_hres(void);
 extern void update_wall_time(void);
 
 /**
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 27a2338..fb69787 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -654,7 +654,7 @@ int tick_check_oneshot_change(int allow_nohz)
 	if (ts->nohz_mode != NOHZ_MODE_INACTIVE)
 		return 0;
 
-	if (!timekeeping_is_continuous() || !tick_is_oneshot_available())
+	if (!timekeeping_valid_for_hres() || !tick_is_oneshot_available())
 		return 0;
 
 	if (!allow_nohz)
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e5e466b..e112dc4 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -211,9 +211,9 @@ static inline s64 __get_nsec_offset(void) { return 0; }
 #endif
 
 /**
- * timekeeping_is_continuous - check to see if timekeeping is free running
+ * timekeeping_valid_for_hres - Check if timekeeping is suitable for hres
  */
-int timekeeping_is_continuous(void)
+int timekeeping_valid_for_hres(void)
 {
 	unsigned long seq;
 	int ret;
-- 
1.5.3.rc7

