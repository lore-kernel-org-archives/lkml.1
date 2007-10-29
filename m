Return-Path: <linux-kernel-owner+w=401wt.eu-S1756359AbXJ2JLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359AbXJ2JLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 05:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbXJ2JLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 05:11:00 -0400
Received: from www.tglx.de ([62.245.132.106]:43353 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbXJ2JK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 05:10:59 -0400
Date: Mon, 29 Oct 2007 10:10:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [Git pull] hrtimer updates for 2.6.24
Message-ID: <alpine.LFD.0.9999.0710291000370.3186@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-hrt.git

the following small updates.

Thanks,

	tglx
--- 
Adrian Bunk (1):
      clockevents: unexport tick_nohz_get_sleep_length

Michael Ellerman (1):
      Quieten hrtimer printk: "Switched to high resolution mode .."

Vegard Nossum (1):
      timer_list: Fix printk format strings

 kernel/hrtimer.c         |    2 +-
 kernel/time/tick-sched.c |    2 --
 kernel/time/timer_list.c |    6 ++++--
 3 files changed, 5 insertions(+), 5 deletions(-)
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index b6d2ff7..22a2514 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -602,7 +602,7 @@ static int hrtimer_switch_to_hres(void)
 	/* "Retrigger" the interrupt to get things going */
 	retrigger_next_event(NULL);
 	local_irq_restore(flags);
-	printk(KERN_INFO "Switched to high resolution mode on CPU %d\n",
+	printk(KERN_DEBUG "Switched to high resolution mode on CPU %d\n",
 	       smp_processor_id());
 	return 1;
 }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 10a1347..5997456 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -320,8 +320,6 @@ ktime_t tick_nohz_get_sleep_length(void)
 	return ts->sleep_length;
 }
 
-EXPORT_SYMBOL_GPL(tick_nohz_get_sleep_length);
-
 /**
  * nohz_restart_sched_tick - restart the idle tick from the idle task
  *
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index fdb2e03..12c5f4c 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -129,7 +129,8 @@ static void print_cpu(struct seq_file *m, int cpu, u64 now)
 	struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
 	int i;
 
-	SEQ_printf(m, "\ncpu: %d\n", cpu);
+	SEQ_printf(m, "\n");
+	SEQ_printf(m, "cpu: %d\n", cpu);
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		SEQ_printf(m, " clock %d:\n", i);
 		print_base(m, cpu_base->clock_base + i, now);
@@ -184,7 +185,8 @@ print_tickdevice(struct seq_file *m, struct tick_device *td)
 {
 	struct clock_event_device *dev = td->evtdev;
 
-	SEQ_printf(m, "\nTick Device: mode:     %d\n", td->mode);
+	SEQ_printf(m, "\n");
+	SEQ_printf(m, "Tick Device: mode:     %d\n", td->mode);
 
 	SEQ_printf(m, "Clock Event Device: ");
 	if (!dev) {
