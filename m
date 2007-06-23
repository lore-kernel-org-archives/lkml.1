Return-Path: <linux-kernel-owner+w=401wt.eu-S1761544AbXFWNas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761544AbXFWNas (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbXFWNWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:22:34 -0400
Received: from www.osadl.org ([213.239.205.134]:59342 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755421AbXFWNWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:22:20 -0400
Message-Id: <20070623124031.347138380@inhelltoy.tec.linutronix.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 23 Jun 2007 13:32:52 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch -mm 27/28] x86_64: prep idle loop for dynticks
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
--- linux-2.6.22-rc4-mm.orig/arch/x86_64/kernel/process.c	2007-06-23 14:38:54.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/x86_64/kernel/process.c	2007-06-23 14:39:00.000000000 +0200
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

