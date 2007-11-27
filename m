Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbXK0MMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbXK0MMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 07:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbXK0MME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 07:12:04 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:46967 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbXK0MMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 07:12:01 -0500
Date: Tue, 27 Nov 2007 13:12:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>,
       kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>
Subject: [patch] timer cleanups
Message-ID: <20071127121240.GA2489@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Small cleanups to tick-related code. Wrong preempt count is followed
by BUG(), so it is hardly KERN_WARNING.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 1c0a7b8..6fa66f7 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -295,7 +295,7 @@ #endif
 			/* Check, if the timer was already in the past */
 			if (hrtimer_active(&ts->sched_timer))
 				goto out;
-		} else if(!tick_program_event(expires, 0))
+		} else if (!tick_program_event(expires, 0))
 				goto out;
 		/*
 		 * We are past the event already. So we crossed a
@@ -506,7 +506,7 @@ #endif /* NO_HZ */
  */
 #ifdef CONFIG_HIGH_RES_TIMERS
 /*
- * We rearm the timer until we get disabled by the idle code
+ * We rearm the timer until we get disabled by the idle code.
  * Called with interrupts disabled and timer->base->cpu_base->lock held.
  */
 static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
diff --git a/kernel/timer.c b/kernel/timer.c
index a05817c..adaa5d0 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -657,7 +655,7 @@ static inline void __run_timers(tvec_bas
 				int preempt_count = preempt_count();
 				fn(data);
 				if (preempt_count != preempt_count()) {
-					printk(KERN_WARNING "huh, entered %p "
+					printk(KERN_ERR "huh, entered %p "
 					       "with preempt_count %08x, exited"
 					       " with %08x?\n",

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
