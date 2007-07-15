Return-Path: <linux-kernel-owner+w=401wt.eu-S1765395AbXGOQO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765395AbXGOQO0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762471AbXGOQF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:05:28 -0400
Received: from www.osadl.org ([213.239.205.134]:42604 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762505AbXGOQFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:05:13 -0400
Message-Id: <20070715155541.696217058@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:11:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 23/33] x86_64: apic change setup_APIC_timer calling
	convention
Content-Disposition: inline;
	filename=x86_64-apic-change-setup-calling-convention.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

setup_APIC_timer takes the file global calibration result as an argument.
Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/x86_64/kernel/apic.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.22-rc6-mm/arch/x86_64/kernel/apic.c
===================================================================
--- linux-2.6.22-rc6-mm.orig/arch/x86_64/kernel/apic.c	2007-07-15 17:41:16.000000000 +0200
+++ linux-2.6.22-rc6-mm/arch/x86_64/kernel/apic.c	2007-07-15 17:48:56.000000000 +0200
@@ -784,7 +784,7 @@ static void __setup_APIC_LVTT(unsigned i
 		apic_write(APIC_TMICT, clocks);
 }
 
-static void setup_APIC_timer(unsigned int clocks)
+static void setup_APIC_timer(void)
 {
 	unsigned long flags;
 	int irqen;
@@ -793,7 +793,7 @@ static void setup_APIC_timer(unsigned in
 
 	irqen = ! cpu_isset(smp_processor_id(),
 			    timer_interrupt_broadcast_ipi_mask);
-	__setup_APIC_LVTT(clocks, 0, irqen);
+	__setup_APIC_LVTT(calibration_result, 0, irqen);
 	/* Turn off PIT interrupt if we use APIC timer as main timer.
 	   Only works with the PM timer right now
 	   TBD fix it for HPET too. */
@@ -880,7 +880,7 @@ void __init setup_boot_APIC_clock (void)
 	/*
 	 * Now set up the timer for real.
 	 */
-	setup_APIC_timer(calibration_result);
+	setup_APIC_timer();
 
 	local_irq_enable();
 }
@@ -888,7 +888,7 @@ void __init setup_boot_APIC_clock (void)
 void __cpuinit setup_secondary_APIC_clock(void)
 {
 	local_irq_disable(); /* FIXME: Do we need this? --RR */
-	setup_APIC_timer(calibration_result);
+	setup_APIC_timer();
 	local_irq_enable();
 }
 

-- 

