Return-Path: <linux-kernel-owner+w=401wt.eu-S965519AbXAWWFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965519AbXAWWFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965525AbXAWWEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:04:51 -0500
Received: from www.osadl.org ([213.239.205.134]:35943 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965519AbXAWWBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:01:22 -0500
Message-Id: <20070123211209.084184000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:36 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 39/46] i386 prepare for dyntick
Content-Disposition: inline;
	filename=dynticks-i386-support-idle-handler-callbacks.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

Prepare i386 for dyntick: idle handler callbacks.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/process.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.20-rc4-mm1-bo/arch/i386/kernel/process.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/arch/i386/kernel/process.c
+++ linux-2.6.20-rc4-mm1-bo/arch/i386/kernel/process.c
@@ -38,6 +38,7 @@
 #include <linux/ptrace.h>
 #include <linux/random.h>
 #include <linux/personality.h>
+#include <linux/tick.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -211,6 +212,7 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
+		tick_nohz_stop_sched_tick();
 		while (!need_resched()) {
 			void (*idle)(void);
 
@@ -238,6 +240,7 @@ void cpu_idle(void)
 			idle();
 			__exit_idle();
 		}
+		tick_nohz_restart_sched_tick();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();

--

