Return-Path: <linux-kernel-owner+w=401wt.eu-S1759084AbYE0UTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084AbYE0UTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 16:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758860AbYE0UT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 16:19:27 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63894 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758500AbYE0UT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 16:19:26 -0400
Date: Tue, 27 May 2008 21:19:09 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] x86: I/O APIC: Fix the name of the L-APIC IRQ handler
Message-ID: <Pine.LNX.4.55.0805271903270.18833@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The local APIC interrupt handler gets registered with
set_irq_chip_and_handler_name(), which results in
"local-APIC-edge-fasteoi" reported as the name of the handler.  Fix by
removing the type of the handler left over from before the generic
handlers were introduced.

 The 64-bit variation should get fixed with the upcoming merge.

 NB It should really use the "edge" handler and not the "fasteoi" one, but
that's a separate issue.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-lapic-chip-0
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c	2008-05-05 02:55:24.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c	2008-05-25 01:21:58.000000000 +0000
@@ -2037,7 +2037,7 @@ static void unmask_lapic_irq (unsigned i
 }
 
 static struct irq_chip lapic_chip __read_mostly = {
-	.name		= "local-APIC-edge",
+	.name		= "local-APIC",
 	.mask		= mask_lapic_irq,
 	.unmask		= unmask_lapic_irq,
 	.eoi		= ack_apic,
