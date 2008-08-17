Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbYHQGcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbYHQGcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 02:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYHQGck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 02:32:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:43715 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbYHQGcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 02:32:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=xxIi5yYPtM8o/oLhf9zynK0znDNtfO3FhQcKT6Wjvypy+NeCsh/KLNtqhim5s42B03
         w09lk/+vYkpYDBhczYADSdWZdfDpOhXZ81HktrVQVNt7DXyaY7278zs8y/Tkdl2Tm5hj
         MZS4h1bXLNPHcLFCNEHwhjVsf5IDEP272SU6o=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: remove first_free_entry/pin_map_size
Date: Sat, 16 Aug 2008 23:31:50 -0700
Message-Id: <1218954710-13223-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no user now

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/io_apic.c |    7 -------
 arch/x86/kernel/setup.c   |    4 ----
 include/asm-x86/irq.h     |    3 ---
 3 files changed, 14 deletions(-)

Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -72,13 +72,6 @@ int sis_apic_bug = -1;
 static DEFINE_SPINLOCK(ioapic_lock);
 static DEFINE_SPINLOCK(vector_lock);
 
-int first_free_entry;
-/*
- * Rough estimation of how many shared IRQs there are, can
- * be changed anytime.
- */
-int pin_map_size;
-
 /*
  * # of IRQ routing registers
  */
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -878,10 +878,6 @@ void __init setup_arch(char **cmdline_p)
 		nr_irqs = 32 * nr_cpu_ids + 224;
 	init_cpu_to_node();
 #endif
-#ifdef CONFIG_X86_IO_APIC
-	pin_map_size = nr_irqs * 2;
-	first_free_entry = nr_irqs;
-#endif
 
 	init_apic_mappings();
 	ioapic_init_mappings();
Index: linux-2.6/include/asm-x86/irq.h
===================================================================
--- linux-2.6.orig/include/asm-x86/irq.h
+++ linux-2.6/include/asm-x86/irq.h
@@ -10,9 +10,6 @@
 #include <asm/apicdef.h>
 #include <asm/irq_vectors.h>
 
-extern int pin_map_size;
-extern int first_free_entry;
-
 static inline int irq_canonicalize(int irq)
 {
 	return ((irq == 2) ? 9 : irq);
