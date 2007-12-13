Return-Path: <linux-kernel-owner+w=401wt.eu-S1761278AbXLMJgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761278AbXLMJgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 04:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205AbXLMJgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 04:36:31 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:32438
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753605AbXLMJga convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 04:36:30 -0500
Message-Id: <47610B62.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 13 Dec 2007 09:37:22 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: move interrupts[] to .rodata/.init.data
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The array is never written, and on 64-bits it's not even being used
past initial boot.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/x86/kernel/entry_32.S  |    2 +-
 arch/x86/kernel/i8259_64.c  |    2 +-
 include/asm-x86/hw_irq_32.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.24-rc5/arch/x86/kernel/entry_32.S	2007-12-12 11:28:18.000000000 +0100
+++ 2.6.24-rc5-x86-interrupt-section/arch/x86/kernel/entry_32.S	2007-12-04 16:25:04.000000000 +0100
@@ -583,7 +583,7 @@ END(syscall_badsys)
  * Build the entry stubs and pointer table with
  * some assembler magic.
  */
-.data
+.section .rodata,"a"
 ENTRY(interrupt)
 .text
 
--- linux-2.6.24-rc5/arch/x86/kernel/i8259_64.c	2007-12-12 11:28:18.000000000 +0100
+++ 2.6.24-rc5-x86-interrupt-section/arch/x86/kernel/i8259_64.c	2007-12-04 16:25:04.000000000 +0100
@@ -76,7 +76,7 @@ BUILD_16_IRQS(0xc) BUILD_16_IRQS(0xd) BU
 	IRQ(x,c), IRQ(x,d), IRQ(x,e), IRQ(x,f)
 
 /* for the irq vectors */
-static void (*interrupt[NR_VECTORS - FIRST_EXTERNAL_VECTOR])(void) = {
+static void (*__initdata interrupt[NR_VECTORS - FIRST_EXTERNAL_VECTOR])(void) = {
 					  IRQLIST_16(0x2), IRQLIST_16(0x3),
 	IRQLIST_16(0x4), IRQLIST_16(0x5), IRQLIST_16(0x6), IRQLIST_16(0x7),
 	IRQLIST_16(0x8), IRQLIST_16(0x9), IRQLIST_16(0xa), IRQLIST_16(0xb),
--- linux-2.6.24-rc5/include/asm-x86/hw_irq_32.h	2007-12-12 11:29:30.000000000 +0100
+++ 2.6.24-rc5-x86-interrupt-section/include/asm-x86/hw_irq_32.h	2007-12-04 16:25:04.000000000 +0100
@@ -26,7 +26,7 @@
  * Interrupt entry/exit code at both C and assembly level
  */
 
-extern void (*interrupt[NR_IRQS])(void);
+extern void (*const interrupt[NR_IRQS])(void);
 
 #ifdef CONFIG_SMP
 fastcall void reschedule_interrupt(void);



