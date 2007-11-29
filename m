Return-Path: <linux-kernel-owner+w=401wt.eu-S1760925AbXK2His@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925AbXK2His (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 02:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758920AbXK2HiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 02:38:04 -0500
Received: from [222.73.24.84] ([222.73.24.84]:49633 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758815AbXK2HiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 02:38:01 -0500
Message-ID: <474E6BC4.40001@cn.fujitsu.com>
Date: Thu, 29 Nov 2007 15:35:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       trivial@kernel.org
Subject: [PATCH 4/6] time: fix typo in comments
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix typo in comments.

BTW: I have to fix coding style in arch/ia64/kernel/time.c also,
otherwise checkpatch.pl will be complaining.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 arch/ia64/kernel/time.c   |   14 +++++++-------
 arch/x86/kernel/time_64.c |    2 +-
 include/linux/hrtimer.h   |    2 +-
 include/linux/jiffies.h   |    6 +++---
 kernel/time.c             |    4 ++--
 kernel/time/clockevents.c |    2 +-
 kernel/time/timekeeping.c |    2 +-
 7 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 2bb8421..5fc8c89 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -49,13 +49,13 @@ EXPORT_SYMBOL(last_cli_ip);
 #endif
 
 static struct clocksource clocksource_itc = {
-        .name           = "itc",
-        .rating         = 350,
-        .read           = itc_get_cycles,
-        .mask           = CLOCKSOURCE_MASK(64),
-        .mult           = 0, /*to be caluclated*/
-        .shift          = 16,
-        .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
+	.name           = "itc",
+	.rating         = 350,
+	.read           = itc_get_cycles,
+	.mask           = CLOCKSOURCE_MASK(64),
+	.mult           = 0, /*to be calculated*/
+	.shift          = 16,
+	.flags          = CLOCK_SOURCE_IS_CONTINUOUS,
 };
 static struct clocksource *itc_clocksource;
 
diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
index 368b194..2cc7570 100644
--- a/arch/x86/kernel/time_64.c
+++ b/arch/x86/kernel/time_64.c
@@ -235,7 +235,7 @@ static unsigned int __init tsc_calibrate_cpu_khz(void)
 		reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
 	}
 	local_irq_save(flags);
-	/* start meauring cycles, incrementing from 0 */
+	/* start measuring cycles, incrementing from 0 */
 	wrmsrl(MSR_K7_PERFCTR0 + i, 0);
 	wrmsrl(MSR_K7_EVNTSEL0 + i, 1 << 22 | 3 << 16 | 0x76);
 	rdtscl(tsc_start);
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 80c7e98..d42c6be 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -78,7 +78,7 @@ enum hrtimer_cb_mode {
  * as otherwise the timer could be removed before the softirq code finishes the
  * the handling of the timer.
  *
- * The HRTIMER_STATE_ENQUEUE bit is always or'ed to the current state to
+ * The HRTIMER_STATE_ENQUEUED bit is always or'ed to the current state to
  * preserve the HRTIMER_STATE_CALLBACK bit in the above scenario.
  *
  * All state transitions are protected by cpu_base->lock.
diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 8b08002..b071f46 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -36,7 +36,7 @@
 /* LATCH is used in the interval timer and ftape setup. */
 #define LATCH  ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
 
-/* Suppose we want to devide two numbers NOM and DEN: NOM/DEN, the we can
+/* Suppose we want to devide two numbers NOM and DEN: NOM/DEN, then we can
  * improve accuracy by shifting LSH bits, hence calculating:
  *     (NOM << LSH) / DEN
  * This however means trouble for large NOM, because (NOM << LSH) may no
@@ -154,7 +154,7 @@ extern unsigned long preset_lpj;
  * We want to do realistic conversions of time so we need to use the same
  * values the update wall clock code uses as the jiffies size.  This value
  * is: TICK_NSEC (which is defined in timex.h).  This
- * is a constant and is in nanoseconds.  We will used scaled math
+ * is a constant and is in nanoseconds.  We will use scaled math
  * with a set of scales defined here as SEC_JIFFIE_SC,  USEC_JIFFIE_SC and
  * NSEC_JIFFIE_SC.  Note that these defines contain nothing but
  * constants and so are computed at compile time.  SHIFT_HZ (computed in
@@ -198,7 +198,7 @@ extern unsigned long preset_lpj;
  * operator if the result is a long long AND at least one of the
  * operands is cast to long long (usually just prior to the "*" so as
  * not to confuse it into thinking it really has a 64-bit operand,
- * which, buy the way, it can do, but it take more code and at least 2
+ * which, buy the way, it can do, but it takes more code and at least 2
  * mpys).
 
  * We also need to be aware that one second in nanoseconds is only a
diff --git a/kernel/time.c b/kernel/time.c
index 09d3c45..c25f472 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -266,7 +266,7 @@ EXPORT_SYMBOL(jiffies_to_usecs);
  *
  * This function should be only used for timestamps returned by
  * current_kernel_time() or CURRENT_TIME, not with do_gettimeofday() because
- * it doesn't handle the better resolution of the later.
+ * it doesn't handle the better resolution of the latter.
  */
 struct timespec timespec_trunc(struct timespec t, unsigned gran)
 {
@@ -314,7 +314,7 @@ EXPORT_SYMBOL_GPL(getnstimeofday);
  * This algorithm was first published by Gauss (I think).
  *
  * WARNING: this function will overflow on 2106-02-07 06:28:16 on
- * machines were long is 32-bit! (However, as time_t is signed, we
+ * machines where long is 32-bit! (However, as time_t is signed, we
  * will already get problems at other places on 2038-01-19 03:14:08)
  */
 unsigned long
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 68fbe73..6e2b7ef 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -123,7 +123,7 @@ static void clockevents_do_notify(unsigned long reason, void *dev)
 }
 
 /*
- * Called after a notify add to make devices availble which were
+ * Called after a notify add to make devices available which were
  * released from the notifier call.
  */
 static void clockevents_notify_released(void)
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e112dc4..cd26cbe 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -372,7 +372,7 @@ static __always_inline int clocksource_bigadjust(s64 error, s64 *interval,
 	 * with losing too many ticks, otherwise we would overadjust and
 	 * produce an even larger error.  The smaller the adjustment the
 	 * faster we try to adjust for it, as lost ticks can do less harm
-	 * here.  This is tuned so that an error of about 1 msec is adusted
+	 * here.  This is tuned so that an error of about 1 msec is adjusted
 	 * within about 1 sec (or 2^20 nsec in 2^SHIFT_HZ ticks).
 	 */
 	error2 = clock->error >> (TICK_LENGTH_SHIFT + 22 - 2 * SHIFT_HZ);
-- 
1.5.3.rc7

