Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbZKTTXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbZKTTXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 14:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbZKTTXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 14:23:42 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45022 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbZKTTXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 14:23:41 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Luming Yu <luming.yu@gmail.com>
Subject: [PATCH 1/2] hrtimer: correct a few numbers in comments and printk outputs
Date: Fri, 20 Nov 2009 20:23:39 +0100
Message-Id: <1258745020-28060-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Luming Yu <luming.yu@gmail.com>
---
 kernel/hrtimer.c           |    4 ++--
 kernel/time/tick-oneshot.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 3e1c36e..4443295 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1220,7 +1220,7 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
 static int force_clock_reprogram;
 
 /*
- * After 5 iteration's attempts, we consider that hrtimer_interrupt()
+ * After 4 iteration's attempts, we consider that hrtimer_interrupt()
  * is hanging, which could happen with something that slows the interrupt
  * such as the tracing. Then we force the clock reprogramming for each future
  * hrtimer interrupts to avoid infinite loops and use the min_delta_ns
@@ -1257,7 +1257,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 	dev->next_event.tv64 = KTIME_MAX;
 
  retry:
-	/* 5 retries is enough to notice a hang */
+	/* 4 retries is enough to notice a hang */
 	if (!(++nr_retries % 5))
 		hrtimer_interrupt_hanging(dev, ktime_sub(ktime_get(), now));
 
diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index a96c0e2..2dd23c3 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -39,7 +39,7 @@ int tick_dev_program_event(struct clock_event_device *dev, ktime_t expires,
 
 		/*
 		 * We tried 2 times to program the device with the given
-		 * min_delta_ns. If that's not working then we double it
+		 * min_delta_ns. If that's not working then we increase it
 		 * and emit a warning.
 		 */
 		if (++i > 2) {
@@ -52,7 +52,7 @@ int tick_dev_program_event(struct clock_event_device *dev, ktime_t expires,
 			printk(KERN_WARNING
 			       "CE: %s increasing min_delta_ns to %lu nsec\n",
 			       dev->name ? dev->name : "?",
-			       dev->min_delta_ns << 1);
+			       dev->min_delta_ns);
 
 			i = 0;
 		}
-- 
1.6.5.2

