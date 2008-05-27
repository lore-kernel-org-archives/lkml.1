Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbYE0UVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbYE0UVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 16:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758465AbYE0UUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 16:20:07 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63941 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759196AbYE0UUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 16:20:05 -0400
Date: Tue, 27 May 2008 21:19:45 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] x86: I/O APIC: Keep the timer IRQ masked during set-up
Message-ID: <Pine.LNX.4.55.0805271946390.18833@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Keep the timer interrupt line masked when reconfiguring its interrupt 
redirection entry in the I/O APIC.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-timer-extint-mask-0
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c	2008-05-25 22:17:27.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c	2008-05-25 22:24:53.000000000 +0000
@@ -1316,7 +1316,7 @@ static void __init setup_timer_IRQ0_pin(
 	 * to the first CPU.
 	 */
 	entry.dest_mode = INT_DEST_MODE;
-	entry.mask = 0;					/* unmask IRQ now */
+	entry.mask = 1;					/* mask IRQ now */
 	entry.dest.logical.logical_dest = cpu_mask_to_apicid(TARGET_CPUS);
 	entry.delivery_mode = INT_DELIVERY_MODE;
 	entry.polarity = 0;
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c	2008-05-25 22:17:54.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c	2008-05-25 22:26:43.000000000 +0000
@@ -911,7 +911,7 @@ static void __init setup_timer_IRQ0_pin(
 	 * to the first CPU.
 	 */
 	entry.dest_mode = INT_DEST_MODE;
-	entry.mask = 0;					/* unmask IRQ now */
+	entry.mask = 1;					/* mask IRQ now */
 	entry.dest = cpu_mask_to_apicid(TARGET_CPUS);
 	entry.delivery_mode = INT_DELIVERY_MODE;
 	entry.polarity = 0;
