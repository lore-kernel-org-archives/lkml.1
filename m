Return-Path: <linux-kernel-owner+w=401wt.eu-S938068AbXGSNxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938068AbXGSNxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936063AbXGSNsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48606 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935534AbXGSNsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:40 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: gcosta@redhat.com, ak@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [10/48] x86_64: Move functions declarations to header file
Message-Id: <20070719134839.3A06E14E71@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Glauber de Oliveira Costa <gcosta@redhat.com>

Some interrupt entry points are currently defined in i8259.c They probably
belong in a header.  Right now, their only user is init_IRQ, justifying
their declaration in-file.  But when virtualization comes in, we may be
interested in using that functions in late initializations.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/i8259.c  |   18 ------------------
 include/asm-x86_64/hw_irq.h |   20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 18 deletions(-)

Index: linux/arch/x86_64/kernel/i8259.c
===================================================================
--- linux.orig/arch/x86_64/kernel/i8259.c
+++ linux/arch/x86_64/kernel/i8259.c
@@ -444,24 +444,6 @@ void __init init_ISA_irqs (void)
 	}
 }
 
-void apic_timer_interrupt(void);
-void spurious_interrupt(void);
-void error_interrupt(void);
-void reschedule_interrupt(void);
-void call_function_interrupt(void);
-void irq_move_cleanup_interrupt(void);
-void invalidate_interrupt0(void);
-void invalidate_interrupt1(void);
-void invalidate_interrupt2(void);
-void invalidate_interrupt3(void);
-void invalidate_interrupt4(void);
-void invalidate_interrupt5(void);
-void invalidate_interrupt6(void);
-void invalidate_interrupt7(void);
-void thermal_interrupt(void);
-void threshold_interrupt(void);
-void i8254_timer_resume(void);
-
 static void setup_timer_hardware(void)
 {
 	outb_p(0x34,0x43);		/* binary, mode 2, LSB/MSB, ch 0 */
Index: linux/include/asm-x86_64/hw_irq.h
===================================================================
--- linux.orig/include/asm-x86_64/hw_irq.h
+++ linux/include/asm-x86_64/hw_irq.h
@@ -95,6 +95,26 @@
 
 
 #ifndef __ASSEMBLY__
+
+/* Interrupt handlers registered during init_IRQ */
+void apic_timer_interrupt(void);
+void spurious_interrupt(void);
+void error_interrupt(void);
+void reschedule_interrupt(void);
+void call_function_interrupt(void);
+void irq_move_cleanup_interrupt(void);
+void invalidate_interrupt0(void);
+void invalidate_interrupt1(void);
+void invalidate_interrupt2(void);
+void invalidate_interrupt3(void);
+void invalidate_interrupt4(void);
+void invalidate_interrupt5(void);
+void invalidate_interrupt6(void);
+void invalidate_interrupt7(void);
+void thermal_interrupt(void);
+void threshold_interrupt(void);
+void i8254_timer_resume(void);
+
 typedef int vector_irq_t[NR_VECTORS];
 DECLARE_PER_CPU(vector_irq_t, vector_irq);
 extern void __setup_vector_irq(int cpu);
