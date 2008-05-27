Return-Path: <linux-kernel-owner+w=401wt.eu-S1759248AbYE0UUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248AbYE0UUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 16:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758873AbYE0UTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 16:19:45 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63915 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759341AbYE0UTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 16:19:43 -0400
Date: Tue, 27 May 2008 21:19:22 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] x86: I/O APIC: Remove redundant 8259A {,un}masking
Message-ID: <Pine.LNX.4.55.0805271924290.18833@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 For a better control the masking and unmasking of the timer interrupt
line in the 8259A operating in the 'Virtual Wire' mode has been moved out
of setup_ExtINT_IRQ0_pin() now, so remove the redundant calls from the 
function.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-timer-extint-nomask-2
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c	2008-05-25 21:45:06.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c	2008-05-25 21:46:53.000000000 +0000
@@ -1310,8 +1310,6 @@ static void __init setup_ExtINT_IRQ0_pin
 
 	memset(&entry,0,sizeof(entry));
 
-	disable_8259A_irq(0);
-
 	/* mask LVT0 */
 	apic_write_around(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
 
@@ -1337,8 +1335,6 @@ static void __init setup_ExtINT_IRQ0_pin
 	 * Add it to the IO-APIC irq-routing table:
 	 */
 	ioapic_write_entry(apic, pin, entry);
-
-	enable_8259A_irq(0);
 }
 
 void __init print_IO_APIC(void)
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c	2008-05-18 00:24:43.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c	2008-05-25 21:46:53.000000000 +0000
@@ -906,8 +906,6 @@ static void __init setup_ExtINT_IRQ0_pin
 
 	memset(&entry, 0, sizeof(entry));
 
-	disable_8259A_irq(0);
-
 	/* mask LVT0 */
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
 
@@ -933,8 +931,6 @@ static void __init setup_ExtINT_IRQ0_pin
 	 * Add it to the IO-APIC irq-routing table:
 	 */
 	ioapic_write_entry(apic, pin, entry);
-
-	enable_8259A_irq(0);
 }
 
 void __apicdebuginit print_IO_APIC(void)
