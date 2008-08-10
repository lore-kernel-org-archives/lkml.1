Return-Path: <linux-kernel-owner+w=401wt.eu-S1758541AbYHJHvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541AbYHJHvm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 03:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbYHJHj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 03:39:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:7020 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105AbYHJHjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 03:39:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ce9J7REEEbqWeGhp+WrfAw7gNdH08I4ROLDcWtaPSpYY/FRbJFFgjNtJMolKFc4hTX
         F7iY1bIbqqlXrdGRhl2+9QGQ+LDhTDfrxBK08M4obvRkroyoDWRYcdCvpwvhCLVxrBWD
         Y0dG6Qz+2ZR/a7qoLB66bdQ/R6K4C3O6FfCAM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 39/43] x86_64: rename irq_desc/irq_desc_with_new
Date: Sun, 10 Aug 2008 00:36:28 -0700
Message-Id: <1218353792-3355-40-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218353792-3355-39-git-send-email-yhlu.kernel@gmail.com>
References: <1218353792-3355-1-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-2-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-3-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-4-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-5-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-6-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-7-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-8-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-9-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-10-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-11-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-12-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-13-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-14-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-15-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-16-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-17-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-18-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-19-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-20-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-21-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-22-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-23-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-24-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-25-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-26-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-27-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-28-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-29-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-30-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-31-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-32-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-33-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-34-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-35-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-36-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-37-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-38-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-39-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change name irq_desc() ==> irq_desc_with_new
	irq_desc_without_new() ==> irq_desc

So could only call that one time

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic_64.c |   18 ++++++++++++------
 arch/x86/kernel/irq_64.c     |    4 ++--
 arch/x86/kernel/irqinit_64.c |    3 ++-
 include/linux/irq.h          |    2 +-
 kernel/irq/chip.c            |   21 +++++++++++----------
 kernel/irq/handle.c          |   23 +++++------------------
 kernel/irq/manage.c          |   16 ++++++++--------
 7 files changed, 41 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 33a3060..4756d04 100644
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
index 2acb719..4ebf884 100644
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
diff --git a/include/linux/irq.h b/include/linux/irq.h
index ca97ad2..979ef9e 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -203,7 +203,7 @@ struct irq_desc {
 } ____cacheline_internodealigned_in_smp;
 
 extern struct irq_desc *irq_desc(unsigned int irq);
-extern struct irq_desc *irq_desc_without_new(unsigned int irq);
+extern struct irq_desc *irq_desc_with_new(unsigned int irq);
 
 #ifndef CONFIG_HAVE_SPARSE_IRQ
 
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 437b21d..04169d8 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -27,7 +27,8 @@ void dynamic_irq_init(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	desc = irq_desc(irq);
+	/* first time to use this irq_desc */
+	desc = irq_desc_with_new(irq);
 	if (!desc) {
 		WARN(1, KERN_ERR "Trying to initialize invalid IRQ%d\n", irq);
 		return;
@@ -60,7 +61,7 @@ void dynamic_irq_cleanup(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	desc = irq_desc_without_new(irq);
+	desc = irq_desc(irq);
 	if (!desc) {
 		WARN(1, KERN_ERR "Trying to cleanup invalid IRQ%d\n", irq);
 		return;
@@ -92,7 +93,7 @@ int set_irq_chip(unsigned int irq, struct irq_chip *chip)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	desc = irq_desc_without_new(irq);
+	desc = irq_desc(irq);
 	if (!desc) {
 		WARN(1, KERN_ERR "Trying to install chip for IRQ%d\n", irq);
 		return -EINVAL;
@@ -122,7 +123,7 @@ int set_irq_type(unsigned int irq, unsigned int type)
 	unsigned long flags;
 	int ret = -ENXIO;
 
-	desc = irq_desc_without_new(irq);
+	desc = irq_desc(irq);
 	if (!desc) {
 		printk(KERN_ERR "Trying to set irq type for IRQ%d\n", irq);
 		return -ENODEV;
@@ -149,7 +150,7 @@ int set_irq_data(unsigned int irq, void *data)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	desc = irq_desc_without_new(irq);
+	desc = irq_desc(irq);
 	if (!desc) {
 		printk(KERN_ERR
 		       "Trying to install controller data for IRQ%d\n", irq);
@@ -175,7 +176,7 @@ int set_irq_msi(unsigned int irq, struct msi_desc *entry)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	desc = irq_desc_without_new(irq);
+	desc = irq_desc(irq);
 	if (!desc) {
 		printk(KERN_ERR
 		       "Trying to install msi data for IRQ%d\n", irq);
@@ -202,7 +203,7 @@ int set_irq_chip_data(unsigned int irq, void *data)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	desc = irq_desc_without_new(irq);
+	desc = irq_desc(irq);
 	if (!desc) {
 		printk(KERN_ERR
 		       "Trying to install chip data for IRQ%d\n", irq);
@@ -575,7 +576,7 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	desc = irq_desc_without_new(irq);
+	desc = irq_desc(irq);
 	if (!desc) {
 		printk(KERN_ERR
 		       "Trying to install type control for IRQ%d\n", irq);
@@ -639,7 +640,7 @@ void __init set_irq_noprobe(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	desc = irq_desc_without_new(irq);
+	desc = irq_desc(irq);
 	if (!desc) {
 		printk(KERN_ERR "Trying to mark IRQ%d non-probeable\n", irq);
 
@@ -656,7 +657,7 @@ void __init set_irq_probe(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	desc = irq_desc_without_new(irq);
+	desc = irq_desc(irq);
 	if (!desc) {
 		printk(KERN_ERR "Trying to mark IRQ%d probeable\n", irq);
 
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index e4fd9ef..7703ba6 100644
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
+			printk(KERN_DEBUG "found new irq_desc for irq %d\n", desc->irq);
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
-			printk(KERN_DEBUG "1 found irq_desc for irq %d\n", desc->irq);
-			if (desc->next)
-				printk(KERN_DEBUG "1 found irq_desc for irq %d and next will be irq %d\n", desc->irq, desc->next->irq);
-			desc = desc->next;
-			count++;
-		}
-		printk(KERN_DEBUG "1 all preallocted %d\n", count);
-	}
+	printk(KERN_DEBUG "1 found new irq_desc for irq %d and pri will be irq %d\n", desc->irq, desc_pri->irq);
 
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
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index f491052..cb63117 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -31,7 +31,7 @@ cpumask_t irq_default_affinity = CPU_MASK_ALL;
  */
 void synchronize_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc_without_new(irq);
+	struct irq_desc *desc = irq_desc(irq);
 	unsigned int status;
 
 	if (!desc)
@@ -153,7 +153,7 @@ void disable_irq_nosync(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	desc = irq_desc_without_new(irq);
+	desc = irq_desc(irq);
 	if (!desc)
 		return;
 
@@ -182,7 +182,7 @@ void disable_irq(unsigned int irq)
 {
 	struct irq_desc *desc;
 
-	desc = irq_desc_without_new(irq);
+	desc = irq_desc(irq);
 	if (!desc)
 		return;
 
@@ -226,7 +226,7 @@ void enable_irq(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	desc = irq_desc_without_new(irq);
+	desc = irq_desc(irq);
 	if (!desc)
 		return;
 
@@ -304,7 +304,7 @@ int can_request_irq(unsigned int irq, unsigned long irqflags)
 	struct irq_desc *desc;
 	struct irqaction *action;
 
-	desc = irq_desc_without_new(irq);
+	desc = irq_desc(irq);
 	if (!desc)
 		return 0;
 
@@ -367,7 +367,7 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 	int shared = 0;
 	int ret;
 
-	desc = irq_desc_without_new(irq);
+	desc = irq_desc(irq);
 	if (!desc)
 		return -EINVAL;
 
@@ -523,7 +523,7 @@ void free_irq(unsigned int irq, void *dev_id)
 
 	WARN_ON(in_interrupt());
 
-	desc = irq_desc_without_new(irq);
+	desc = irq_desc(irq);
 	if (!desc)
 		return;
 
@@ -639,7 +639,7 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 	if ((irqflags & IRQF_SHARED) && !dev_id)
 		return -EINVAL;
 
-	desc = irq_desc_without_new(irq);
+	desc = irq_desc(irq);
 	if (!desc)
 		return -EINVAL;
 
-- 
1.5.4.5

