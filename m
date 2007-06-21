Return-Path: <linux-kernel-owner+w=401wt.eu-S1757054AbXFUOxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbXFUOxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 10:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbXFUOxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 10:53:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839AbXFUOxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 10:53:12 -0400
Date: Thu, 21 Jun 2007 11:54:11 -0300
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de
Subject: [PATCH] Move functions declarations to header file
Message-ID: <20070621145411.GA26091@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Some interrupt entry points are currently defined in i8259.c
They probably belong in a header. Right now, their only user is
init_IRQ, justifying their declaration in-file. But when virtualization
comes in, we may be interested in using that functions in late
initializations.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>

-- 
Glauber de Oliveira Costa
Red Hat Inc.
"Free as in Freedom"

--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="irq.patch"

diff --git a/arch/x86_64/kernel/i8259.c b/arch/x86_64/kernel/i8259.c
index 4b32665..948cae6 100644
--- a/arch/x86_64/kernel/i8259.c
+++ b/arch/x86_64/kernel/i8259.c
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
diff --git a/include/asm-x86_64/hw_irq.h b/include/asm-x86_64/hw_irq.h
index 6153ae5..09dfc18 100644
--- a/include/asm-x86_64/hw_irq.h
+++ b/include/asm-x86_64/hw_irq.h
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

--XsQoSWH+UP9D9v3l--
