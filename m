Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab0BLN4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 08:56:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756355Ab0BLN4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 08:56:38 -0500
From: Mark Wielaard <mjw@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Wielaard <mjw@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] Fix some kernel/time.c checkpatch.pl style issues.
Date: Fri, 12 Feb 2010 14:55:20 +0100
Message-Id: <1265982920-9786-1-git-send-email-mjw@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some EXPORT_SYMBOL, spaces required after comma, open parenthesis,
inline placement and tab usage style issues pointed out by checkpatch.pl.

Signed-off-by: Mark Wielaard <mjw@redhat.com>
---
 kernel/time.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/kernel/time.c b/kernel/time.c
index 8047980..28d9b36 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -49,7 +49,6 @@
  * programs who obtain this value by using gettimeofday.
  */
 struct timezone sys_tz;
-
 EXPORT_SYMBOL(sys_tz);
 
 #ifdef __ARCH_WANT_SYS_TIME
@@ -65,7 +64,7 @@ SYSCALL_DEFINE1(time, time_t __user *, tloc)
 	time_t i = get_seconds();
 
 	if (tloc) {
-		if (put_user(i,tloc))
+		if (put_user(i, tloc))
 			return -EFAULT;
 	}
 	force_successful_syscall_return();
@@ -174,8 +173,7 @@ int do_sys_settimeofday(struct timespec *tv, struct timezone *tz)
 				warp_clock();
 		}
 	}
-	if (tv)
-	{
+	if (tv) {
 		/* SMP safe, again the code in arch/foo/time.c should
 		 * globally block out interrupts when it runs.
 		 */
@@ -214,7 +212,7 @@ SYSCALL_DEFINE1(adjtimex, struct timex __user *, txc_p)
 	 * structure. But bear in mind that the structures
 	 * may change
 	 */
-	if(copy_from_user(&txc, txc_p, sizeof(struct timex)))
+	if (copy_from_user(&txc, txc_p, sizeof(struct timex)))
 		return -EFAULT;
 	ret = do_adjtimex(&txc);
 	return copy_to_user(txc_p, &txc, sizeof(struct timex)) ? -EFAULT : ret;
@@ -240,7 +238,7 @@ EXPORT_SYMBOL(current_fs_time);
  * Avoid unnecessary multiplications/divisions in the
  * two most common HZ cases:
  */
-unsigned int inline jiffies_to_msecs(const unsigned long j)
+inline unsigned int jiffies_to_msecs(const unsigned long j)
 {
 #if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
 	return (MSEC_PER_SEC / HZ) * j;
@@ -256,7 +254,7 @@ unsigned int inline jiffies_to_msecs(const unsigned long j)
 }
 EXPORT_SYMBOL(jiffies_to_msecs);
 
-unsigned int inline jiffies_to_usecs(const unsigned long j)
+inline unsigned int jiffies_to_usecs(const unsigned long j)
 {
 #if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
 	return (USEC_PER_SEC / HZ) * j;
@@ -353,7 +351,6 @@ mktime(const unsigned int year0, const unsigned int mon0,
 	  )*60 + min /* now have minutes */
 	)*60 + sec; /* finally seconds */
 }
-
 EXPORT_SYMBOL(mktime);
 
 /**
@@ -523,7 +520,7 @@ timespec_to_jiffies(const struct timespec *value)
 	unsigned long sec = value->tv_sec;
 	long nsec = value->tv_nsec + TICK_NSEC - 1;
 
-	if (sec >= MAX_SEC_IN_JIFFIES){
+	if (sec >= MAX_SEC_IN_JIFFIES) {
 		sec = MAX_SEC_IN_JIFFIES;
 		nsec = 0;
 	}
@@ -566,7 +563,7 @@ timeval_to_jiffies(const struct timeval *value)
 	unsigned long sec = value->tv_sec;
 	long usec = value->tv_usec;
 
-	if (sec >= MAX_SEC_IN_JIFFIES){
+	if (sec >= MAX_SEC_IN_JIFFIES) {
 		sec = MAX_SEC_IN_JIFFIES;
 		usec = 0;
 	}
@@ -609,7 +606,7 @@ EXPORT_SYMBOL(jiffies_to_clock_t);
 
 unsigned long clock_t_to_jiffies(unsigned long x)
 {
-#if (HZ % USER_HZ)==0
+#if (HZ % USER_HZ) == 0
 	if (x >= ~0UL / (HZ / USER_HZ))
 		return ~0UL;
 	return x * (HZ / USER_HZ);
@@ -654,10 +651,10 @@ u64 nsec_to_clock_t(u64 x)
 	return div_u64(x * USER_HZ / 512, NSEC_PER_SEC / 512);
 #else
 	/*
-         * max relative error 5.7e-8 (1.8s per year) for USER_HZ <= 1024,
-         * overflow after 64.99 years.
-         * exact for HZ=60, 72, 90, 120, 144, 180, 300, 600, 900, ...
-         */
+	 * max relative error 5.7e-8 (1.8s per year) for USER_HZ <= 1024,
+	 * overflow after 64.99 years.
+	 * exact for HZ=60, 72, 90, 120, 144, 180, 300, 600, 900, ...
+	 */
 	return div_u64(x * 9, (9ull * NSEC_PER_SEC + (USER_HZ / 2)) / USER_HZ);
 #endif
 }
-- 
1.6.6

