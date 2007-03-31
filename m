Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbXCaIeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbXCaIeb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 04:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbXCaIeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 04:34:31 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:35679 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbXCaIe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 04:34:27 -0400
Message-Id: <20070331083358.409302000@sous-sol.org>
References: <20070331083149.997762000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Sat, 31 Mar 2007 01:31:54 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 4/5] x86_64: prep idle loop for dynticks
Content-Disposition: inline; filename=x86_64-dyntick-idle-updates.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add tick_nohz_{stop,restart}_sched_tick to idle
loop in prepartion for turning on dynticks.  These
are just noops until NO_HZ is enabled in next patch.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
---
 arch/x86_64/kernel/process.c |    3 +++
 1 file changed, 3 insertions(+)

--- linus-2.6.orig/arch/x86_64/kernel/process.c
+++ linus-2.6/arch/x86_64/kernel/process.c
@@ -36,6 +36,7 @@
 #include <linux/random.h>
 #include <linux/notifier.h>
 #include <linux/kprobes.h>
+#include <linux/tick.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -201,6 +202,7 @@ void cpu_idle (void)
 	current_thread_info()->status |= TS_POLLING;
 	/* endless idle loop with no priority at all */
 	while (1) {
+		tick_nohz_stop_sched_tick();
 		while (!need_resched()) {
 			void (*idle)(void);
 
@@ -227,6 +229,7 @@ void cpu_idle (void)
 			__exit_idle();
 		}
 
+		tick_nohz_restart_sched_tick();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();

--
