Return-Path: <linux-kernel-owner+w=401wt.eu-S932415AbYHHWIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbYHHWIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760948AbYHHVzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:55:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:58025 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762289AbYHHVzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:55:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=S02Pn9o4YB7hqWa1br5oxjG8G/WwbShTzlps/uvYOqj4dfn+4ngPpAca8sYfYZR362
         6pAqcFo2nPqBzRwAjeIyZXRRxYXi97sK6ddtJDouska8d/W8vY7dJkr++hCc8GZ7UDxh
         qGlqADRgEGCd23hkBRgbMUCFiUYip4HqtX/Mg=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 37/42] x86_64: introduce irq_desc_with_new
Date: Fri,  8 Aug 2008 14:52:43 -0700
Message-Id: <1218232368-31228-38-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-37-git-send-email-yhlu.kernel@gmail.com>
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-2-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-3-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-4-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-5-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-6-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-7-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-8-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-9-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-10-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-11-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-12-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-13-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-14-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-15-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-16-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-17-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-18-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-19-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-20-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-21-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-22-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-23-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-24-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-25-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-26-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-27-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-28-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-29-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-30-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-31-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-32-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-33-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-34-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-35-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-36-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-37-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So could only call that one time

Singed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic_64.c |   18 ++++++++++++------
 arch/x86/kernel/irq_64.c     |    4 ++--
 arch/x86/kernel/irqinit_64.c |    3 ++-
 fs/proc/proc_misc.c          |    2 +-
 include/linux/irq.h          |    2 +-
 kernel/irq/chip.c            |    5 +++++
 kernel/irq/handle.c          |   23 +++++------------------
 7 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 1466e4b..f8baf58 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -1117,7 +1117,12 @@ static void ioapic_register_intr(int irq, unsigned long trigger)
 {
 	struct irq_desc *desc;
 
-	desc = irq_desc(irq);
+	/* first time to use this irq_desc */
+	if (irq < 16)
+		desc = irq_desc(irq);
+	else
+		desc = irq_desc_with_new(irq);
+
 	if (trigger)
 		desc->status |= IRQ_LEVEL;
 	else
@@ -3086,8 +3091,6 @@ void __init setup_ioapic_dest(void)
 				continue;
 			irq = pin_2_irq(irq_entry, ioapic, pin);
 
-			desc = irq_desc(irq);
-
 			/* setup_IO_APIC_irqs could fail to get vector for some device
 			 * when you have too many devices, because at that time only boot
 			 * cpu is online.
@@ -3098,13 +3101,16 @@ void __init setup_ioapic_dest(void)
 						  irq_trigger(irq_entry),
 						  irq_polarity(irq_entry));
 #ifdef CONFIG_INTR_REMAP
-			else if (intr_remapping_enabled)
+			else if (intr_remapping_enabled) {
+				desc = irq_desc(irq);
 				set_ir_ioapic_affinity_irq(irq, desc, TARGET_CPUS);
+			}
 #endif
-			else
+			else {
+				desc = irq_desc(irq);
 				set_ioapic_affinity_irq(irq, desc, TARGET_CPUS);
+			}
 		}
-
 	}
 }
 #endif
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 42b2c12..7db6843 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -83,7 +83,7 @@ int show_interrupts(struct seq_file *p, void *v)
 
 	if (i < nr_irqs) {
 		unsigned any_count = 0;
-		struct irq_desc *desc = irq_desc_without_new(i);
+		struct irq_desc *desc = irq_desc(i);
 
 		if (!desc)
 			return 0;
@@ -206,7 +206,7 @@ asmlinkage unsigned int do_IRQ(struct pt_regs *regs)
 	stack_overflow_check(regs);
 #endif
 
-	desc = irq_desc_without_new(irq);
+	desc = irq_desc(irq);
 	if (likely(desc))
 		generic_handle_irq(irq, desc);
 	else {
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 4c55edf..45fca9d 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -143,7 +143,8 @@ static void __init init_ISA_irqs (void)
 	init_8259A(0);
 
 	for (i = 0; i < 16; i++) {
-		struct irq_desc *desc = irq_desc(i);
+		/* first time call this irq_desc */
+		struct irq_desc *desc = irq_desc_with_new(i);
 
 		desc->status = IRQ_DISABLED;
 		desc->action = NULL;
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index e16c20a..c9ee1f7 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -570,7 +570,7 @@ static int show_stat(struct seq_file *p, void *v)
 	/* sum again ? it could be updated? have another field in irq_desc?*/
 	for (j = 0; j < nr_irqs; j++) {
 		per_irq_sum = 0;
-		desc = irq_desc_without_new(j);
+		desc = irq_desc(j);
 
 		if (desc)
 			for_each_possible_cpu(i) {
diff --git a/include/linux/irq.h b/include/linux/irq.h
index d04182a..0d9578e 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -205,7 +205,7 @@ struct irq_desc {
 } ____cacheline_internodealigned_in_smp;
 
 extern struct irq_desc *irq_desc(unsigned int irq);
-extern struct irq_desc *irq_desc_without_new(unsigned int irq);
+extern struct irq_desc *irq_desc_with_new(unsigned int irq);
 
 #ifndef CONFIG_HAVE_SPARSE_IRQ
 
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index dcac270..bfd02f7 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -36,6 +36,11 @@ void dynamic_irq_init(unsigned int irq)
 
 	/* Ensure we don't have left over values from a previous use of this irq */
 	desc = irq_desc(irq);
+	if (!desc) {
+		/* first time to use this irq_desc */
+		desc = irq_desc_with_new(irq);
+		return;
+	}
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->status = IRQ_DISABLED;
 	desc->chip = &no_irq_chip;
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index e9b54a5..194d815 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -150,7 +150,7 @@ early_param("nr_irq_desc", parse_nr_irq_desc);
 struct irq_desc *irq_descX;
 DEFINE_DYN_ARRAY(irq_descX, sizeof(struct irq_desc), nr_irq_desc, PAGE_SIZE, init_work);
 
-struct irq_desc *irq_desc_without_new(unsigned int irq)
+struct irq_desc *irq_desc(unsigned int irq)
 {
 	struct irq_desc *desc;
 
@@ -168,7 +168,7 @@ struct irq_desc *irq_desc_without_new(unsigned int irq)
 	}
 	return NULL;
 }
-struct irq_desc *irq_desc(unsigned int irq)
+struct irq_desc *irq_desc_with_new(unsigned int irq)
 {
 	struct irq_desc *desc, *desc_pri;
 	int i;
@@ -185,6 +185,7 @@ struct irq_desc *irq_desc(unsigned int irq)
 
 		if (desc->irq == -1U) {
 			desc->irq = irq;
+			printk("found new irq_desc for irq %d\n", desc->irq);
 			return desc;
 		}
 		desc_pri = desc;
@@ -235,21 +236,7 @@ struct irq_desc *irq_desc(unsigned int irq)
 
 	desc->irq = irq;
 	desc_pri->next = desc;
-	{
-		/* double check if some one mess up the list */
-		struct irq_desc *desc;
-		int count = 0;
-
-		desc = &irq_descX[0];
-		while (desc) {
-			printk("1 found irq_desc for irq %d\n", desc->irq);
-			if (desc->next)
-				printk("1 found irq_desc for irq %d and next will be irq %d\n", desc->irq, desc->next->irq);
-			desc = desc->next;
-			count++;
-		}
-		printk("1 all preallocted %d\n", count);
-	}
+	printk("1 found new irq_desc for irq %d and pri will be irq %d\n", desc->irq, desc_pri->irq);
 
 	return desc;
 }
@@ -285,7 +272,7 @@ struct irq_desc *irq_desc(unsigned int irq)
 
 	return NULL;
 }
-struct irq_desc *irq_desc_without_new(unsigned int irq)
+struct irq_desc *irq_desc_with_new(unsigned int irq)
 {
 	return irq_desc(irq);
 }
-- 
1.5.4.5

