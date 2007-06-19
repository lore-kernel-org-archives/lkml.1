Return-Path: <linux-kernel-owner+w=401wt.eu-S933906AbXFSUMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933906AbXFSUMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761659AbXFSUMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:12:14 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:40301 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761233AbXFSUMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:12:12 -0400
Subject: [PATCH RT] Use raw spinlocks in NMI print sequencing.
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 19 Jun 2007 16:11:34 -0400
Message-Id: <1182283894.15228.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently NMI uses spinlocks to serialize the prints. We need these to
be raw spinlocks for PREEMPT_RT

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.21-rt9/arch/x86_64/kernel/nmi.c
===================================================================
--- linux-2.6.21-rt9.orig/arch/x86_64/kernel/nmi.c
+++ linux-2.6.21-rt9/arch/x86_64/kernel/nmi.c
@@ -949,7 +949,7 @@ int __kprobes nmi_watchdog_tick(struct p
 	}
 
 	if (cpu_isset(cpu, backtrace_mask)) {
-		static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
+		static DEFINE_RAW_SPINLOCK(lock);	/* Serialise the printks */
 
 		spin_lock(&lock);
 		printk("NMI backtrace for cpu %d\n", cpu);


