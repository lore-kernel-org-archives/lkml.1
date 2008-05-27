Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbYE0UVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbYE0UVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 16:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759270AbYE0UUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 16:20:08 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63943 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759186AbYE0UUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 16:20:06 -0400
Date: Tue, 27 May 2008 21:19:40 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] x86: I/O APIC: Unmask the second-chance timer interrupt
Message-ID: <Pine.LNX.4.55.0805271931570.18833@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Unmask the timer interrupt line set up in the through-8259A mode
explicitly after setup_timer_IRQ0_pin() has set up the I/O APIC interrupt
redirection entry to let the two operations be unbound from each other.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-timer-8259-unmask-0
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c	2008-05-25 22:02:20.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c	2008-05-25 22:17:27.000000000 +0000
@@ -2185,6 +2185,7 @@ static inline void __init check_timer(vo
 		 * legacy devices should be connected to IO APIC #0
 		 */
 		setup_timer_IRQ0_pin(apic2, pin2, vector);
+		unmask_IO_APIC_irq(0);
 		enable_8259A_irq(0);
 		if (timer_irq_works()) {
 			printk("works.\n");
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c	2008-05-25 22:03:58.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c	2008-05-25 22:17:54.000000000 +0000
@@ -1691,6 +1691,7 @@ static inline void __init check_timer(vo
 		 * legacy devices should be connected to IO APIC #0
 		 */
 		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
+		unmask_IO_APIC_irq(0);
 		enable_8259A_irq(0);
 		if (timer_irq_works()) {
 			apic_printk(APIC_VERBOSE," works.\n");
