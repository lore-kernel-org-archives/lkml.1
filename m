Return-Path: <linux-kernel-owner+w=401wt.eu-S1758909AbXFJJjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbXFJJjQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 05:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbXFJJbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 05:31:33 -0400
Received: from www.osadl.org ([213.239.205.134]:43141 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754235AbXFJJbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 05:31:13 -0400
Message-Id: <20070610092447.186103784@inhelltoy.tec.linutronix.de>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 10 Jun 2007 09:44:21 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 22/23] x86_64: prep idle loop for dynticks
Content-Disposition: inline; filename=x86-64-prepare-idle-for-dyntick.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Chris Wright <chrisw@sous-sol.org>

Add tick_nohz_{stop,restart}_sched_tick to idle
loop in prepartion for turning on dynticks.  These
are just noops until NO_HZ is enabled in next patch.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/process.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.22-rc4-mm/arch/x86_64/kernel/process.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/x86_64/kernel/process.c	2007-06-10 10:44:36.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/x86_64/kernel/process.c	2007-06-10 10:44:40.000000000 +0200
@@ -37,6 +37,7 @@
 #include <linux/notifier.h>
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
+#include <linux/tick.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -207,6 +208,8 @@ void cpu_idle (void)
 			if (__get_cpu_var(cpu_idle_state))
 				__get_cpu_var(cpu_idle_state) = 0;
 
+			tick_nohz_stop_sched_tick();
+
 			check_pgt_cache();
 			rmb();
 			idle = pm_idle;
@@ -228,6 +231,7 @@ void cpu_idle (void)
 			__exit_idle();
 		}
 
+		tick_nohz_restart_sched_tick();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();

-- 

