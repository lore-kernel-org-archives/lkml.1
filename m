Return-Path: <linux-kernel-owner+w=401wt.eu-S1765504AbXGOQOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765504AbXGOQOm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762346AbXGOQF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:05:29 -0400
Received: from www.osadl.org ([213.239.205.134]:42602 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761483AbXGOQFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:05:14 -0400
Message-Id: <20070715155541.786048135@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:11:07 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 25/33] x86_64: prepare idle loop for dynamic ticks
Content-Disposition: inline; filename=x86_64-prep-idle-loop-for-dynticks.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>

Add tick_nohz_{stop,restart}_sched_tick to idle loop in prepartion for turning
on dynticks.  These are just noops until NO_HZ is enabled.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---

 arch/x86_64/kernel/process.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.22-rc6-mm/arch/x86_64/kernel/process.c
===================================================================
--- linux-2.6.22-rc6-mm.orig/arch/x86_64/kernel/process.c	2007-07-15 17:01:24.000000000 +0200
+++ linux-2.6.22-rc6-mm/arch/x86_64/kernel/process.c	2007-07-15 17:42:36.000000000 +0200
@@ -37,6 +37,7 @@
 #include <linux/notifier.h>
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
+#include <linux/tick.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -208,6 +209,7 @@ void cpu_idle (void)
 				__get_cpu_var(cpu_idle_state) = 0;
 
 			check_pgt_cache();
+			tick_nohz_stop_sched_tick();
 			rmb();
 			idle = pm_idle;
 			if (!idle)
@@ -228,6 +230,7 @@ void cpu_idle (void)
 			__exit_idle();
 		}
 
+		tick_nohz_restart_sched_tick();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();

-- 

