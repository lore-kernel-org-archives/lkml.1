Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbXHNVeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbXHNVeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbXHNVXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:23:17 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38432 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753075AbXHNVXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:23:14 -0400
Date: Tue, 14 Aug 2007 23:23:05 +0200
From: Adrian Bunk <bunk@kernel.org>
To: John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6.23 patch] kernel/time/timekeeping.c: cleanups
Message-ID: <20070814212305.GJ18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- remove the no longer required __attribute__((weak)) of xtime_lock
- remove the following no longer used EXPORT_SYMBOL's:
  - xtime
  - xtime_lock

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

IMHO a 2.6.23 patch since it catches drivers still using xtime.

 include/linux/time.h      |    2 +-
 kernel/time/timekeeping.c |    5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

3fd949c027b3537f3a70fff2a0a9fca5049dd014 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index acc417b..8c0596e 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -24,9 +24,7 @@
  * This read-write spinlock protects us from races in SMP while
  * playing with xtime and avenrun.
  */
-__attribute__((weak)) __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
-
-EXPORT_SYMBOL(xtime_lock);
+__cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
 
 
 /*
@@ -47,7 +45,6 @@ EXPORT_SYMBOL(xtime_lock);
 struct timespec xtime __attribute__ ((aligned (16)));
 struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
 static unsigned long total_sleep_time;		/* seconds */
-EXPORT_SYMBOL(xtime);
 
 
 #ifdef CONFIG_NO_HZ
diff --git a/include/linux/time.h b/include/linux/time.h
index 6a5f503..b04136d 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -92,7 +92,7 @@ static inline struct timespec timespec_sub(struct timespec lhs,
 
 extern struct timespec xtime;
 extern struct timespec wall_to_monotonic;
-extern seqlock_t xtime_lock __attribute__((weak));
+extern seqlock_t xtime_lock;
 
 extern unsigned long read_persistent_clock(void);
 extern int update_persistent_clock(struct timespec now);

