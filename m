Return-Path: <linux-kernel-owner+w=401wt.eu-S1764650AbXFTSwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764650AbXFTSwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764589AbXFTSwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:52:15 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:43558 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764376AbXFTSwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:52:13 -0400
Subject: [PATCH RT] have x86_64 nmi watchdog also count irq 0
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 Jun 2007 14:51:03 -0400
Message-Id: <1182365463.15228.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was getting false reports about NMI lockups on CPU 3.  For some reason
CPU 0,1 and 2 where using apic timer, and CPU 3 was using the irq 0
timer.

This patch makes the NMI watchdog count both the apic timer and the irq0
timer.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6-rt-test/arch/x86_64/kernel/nmi.c
===================================================================
--- linux-2.6-rt-test.orig/arch/x86_64/kernel/nmi.c
+++ linux-2.6-rt-test/arch/x86_64/kernel/nmi.c
@@ -938,7 +938,7 @@ int notrace __kprobes nmi_watchdog_tick(
 		touched = 1;
 	}
 
-	sum = read_pda(apic_timer_irqs);
+	sum = read_pda(apic_timer_irqs) + kstat_cpu(cpu).irqs[0];
 
 	if (__get_cpu_var(nmi_touch)) {
 		__get_cpu_var(nmi_touch) = 0;


