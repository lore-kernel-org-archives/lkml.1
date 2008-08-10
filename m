Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbYHJHum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbYHJHum (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 03:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755998AbYHJHjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 03:39:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:7020 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943AbYHJHjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 03:39:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=j7suZaTlqDEmU+IGUaeb67TV/HODvPYE62AT1EvSArMnnMV3aJBOKZ5RCRnhp66K/x
         j1SLVT4GPmtDa3QEou3xRSHen395KIA2rLH6fRYZHSJuBmHd4umaUAKeCf/LMuE66NAd
         s/gMHV754oeaVtzfgIP+mVhz9RIRLlLFZx0EU=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 36/43] remove >= nr_irqs checking with config_have_sparse_irq
Date: Sun, 10 Aug 2008 00:36:25 -0700
Message-Id: <1218353792-3355-37-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218353792-3355-36-git-send-email-yhlu.kernel@gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: fix checking about result irq_cfg_without_new, so could use msi again
v3: use irq_desc_without_new to check irq is valid

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic_64.c |    9 -------
 arch/x86/kernel/irq_64.c     |    2 +-
 kernel/irq/chip.c            |   49 +++++++++++++++++++++++------------------
 kernel/irq/manage.c          |   43 +++++++++++++++++++++++-------------
 4 files changed, 55 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index a2e3dda..1a45bf6 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -400,7 +400,6 @@ static inline void io_apic_sync(unsigned int apic)
 	struct irq_cfg *cfg;						\
 	struct irq_pin_list *entry;					\
 									\
-	BUG_ON(irq >= nr_irqs);						\
 	cfg = irq_cfg(irq);						\
 	entry = cfg->irq_2_pin;						\
 	for (;;) {							\
@@ -480,7 +479,6 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, u8 vector)
 	struct irq_cfg *cfg;
 	struct irq_pin_list *entry;
 
-	BUG_ON(irq >= nr_irqs);
 	cfg = irq_cfg(irq);
 	entry = cfg->irq_2_pin;
 	for (;;) {
@@ -549,7 +547,6 @@ static void add_pin_to_irq(unsigned int irq, int apic, int pin)
 	struct irq_cfg *cfg;
 	struct irq_pin_list *entry;
 
-	BUG_ON(irq >= nr_irqs);
 	/* first time to refer irq_cfg, so with new */
 	cfg = irq_cfg_with_new(irq);
 	entry = cfg->irq_2_pin;
@@ -841,7 +838,6 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin)
 				best_guess = irq;
 		}
 	}
-	BUG_ON(best_guess >= nr_irqs);
 	return best_guess;
 }
 
@@ -973,7 +969,6 @@ static int pin_2_irq(int idx, int apic, int pin)
 			irq += nr_ioapic_registers[i++];
 		irq += pin;
 	}
-	BUG_ON(irq >= nr_irqs);
 	return irq;
 }
 
@@ -995,7 +990,6 @@ static int __assign_irq_vector(int irq, cpumask_t mask)
 	int cpu;
 	struct irq_cfg *cfg;
 
-	BUG_ON((unsigned)irq >= nr_irqs);
 	cfg = irq_cfg(irq);
 
 	/* Only try and allocate irqs on cpus that are present */
@@ -1069,7 +1063,6 @@ static void __clear_irq_vector(int irq)
 	cpumask_t mask;
 	int cpu, vector;
 
-	BUG_ON((unsigned)irq >= nr_irqs);
 	cfg = irq_cfg(irq);
 	BUG_ON(!cfg->vector);
 
@@ -1921,8 +1914,6 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 		struct irq_desc *desc;
 		struct irq_cfg *cfg;
 		irq = __get_cpu_var(vector_irq)[vector];
-		if (irq >= nr_irqs)
-			continue;
 
 		desc = irq_desc(irq);
 		cfg = irq_cfg(irq);
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index ee5ee2d..edcbbb8 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -202,7 +202,7 @@ asmlinkage unsigned int do_IRQ(struct pt_regs *regs)
 	stack_overflow_check(regs);
 #endif
 
-	if (likely(irq < nr_irqs))
+	if (likely(irq_desc_without_new(irq)))
 		generic_handle_irq(irq);
 	else {
 		if (!disable_apic)
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 9b8ea26..bed6322 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -27,13 +27,13 @@ void dynamic_irq_init(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= nr_irqs) {
+	desc = irq_desc(irq);
+	if (!desc) {
 		WARN(1, KERN_ERR "Trying to initialize invalid IRQ%d\n", irq);
 		return;
 	}
 
 	/* Ensure we don't have left over values from a previous use of this irq */
-	desc = irq_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->status = IRQ_DISABLED;
 	desc->chip = &no_irq_chip;
@@ -60,12 +60,12 @@ void dynamic_irq_cleanup(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= nr_irqs) {
+	desc = irq_desc_without_new(irq);
+	if (!desc) {
 		WARN(1, KERN_ERR "Trying to cleanup invalid IRQ%d\n", irq);
 		return;
 	}
 
-	desc = irq_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
 	if (desc->action) {
 		spin_unlock_irqrestore(&desc->lock, flags);
@@ -92,7 +92,8 @@ int set_irq_chip(unsigned int irq, struct irq_chip *chip)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= nr_irqs) {
+	desc = irq_desc_without_new(irq);
+	if (!desc) {
 		WARN(1, KERN_ERR "Trying to install chip for IRQ%d\n", irq);
 		return -EINVAL;
 	}
@@ -121,12 +122,12 @@ int set_irq_type(unsigned int irq, unsigned int type)
 	unsigned long flags;
 	int ret = -ENXIO;
 
-	if (irq >= nr_irqs) {
+	desc = irq_desc_without_new(irq);
+	if (!desc) {
 		printk(KERN_ERR "Trying to set irq type for IRQ%d\n", irq);
 		return -ENODEV;
 	}
 
-	desc = irq_desc(irq);
 	if (desc->chip->set_type) {
 		spin_lock_irqsave(&desc->lock, flags);
 		ret = desc->chip->set_type(irq, type);
@@ -148,13 +149,13 @@ int set_irq_data(unsigned int irq, void *data)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= nr_irqs) {
+	desc = irq_desc_without_new(irq);
+	if (!desc) {
 		printk(KERN_ERR
 		       "Trying to install controller data for IRQ%d\n", irq);
 		return -EINVAL;
 	}
 
-	desc = irq_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->handler_data = data;
 	spin_unlock_irqrestore(&desc->lock, flags);
@@ -174,12 +175,13 @@ int set_irq_msi(unsigned int irq, struct msi_desc *entry)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= nr_irqs) {
+	desc = irq_desc_without_new(irq);
+	if (!desc) {
 		printk(KERN_ERR
 		       "Trying to install msi data for IRQ%d\n", irq);
 		return -EINVAL;
 	}
-	desc = irq_desc(irq);
+
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->msi_desc = entry;
 	if (entry)
@@ -200,8 +202,14 @@ int set_irq_chip_data(unsigned int irq, void *data)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	desc = irq_desc(irq);
-	if (irq >= nr_irqs || !desc->chip) {
+	desc = irq_desc_without_new(irq);
+	if (!desc) {
+		printk(KERN_ERR
+		       "Trying to install chip data for IRQ%d\n", irq);
+		return -EINVAL;
+	}
+
+	if (!desc->chip) {
 		printk(KERN_ERR "BUG: bad set_irq_chip_data(IRQ#%d)\n", irq);
 		return -EINVAL;
 	}
@@ -545,14 +553,13 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= nr_irqs) {
+	desc = irq_desc_without_new(irq);
+	if (!desc) {
 		printk(KERN_ERR
 		       "Trying to install type control for IRQ%d\n", irq);
 		return;
 	}
 
-	desc = irq_desc(irq);
-
 	if (!handle)
 		handle = handle_bad_irq;
 	else if (desc->chip == &no_irq_chip) {
@@ -610,14 +617,13 @@ void __init set_irq_noprobe(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= nr_irqs) {
+	desc = irq_desc_without_new(irq);
+	if (!desc) {
 		printk(KERN_ERR "Trying to mark IRQ%d non-probeable\n", irq);
 
 		return;
 	}
 
-	desc = irq_desc(irq);
-
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->status |= IRQ_NOPROBE;
 	spin_unlock_irqrestore(&desc->lock, flags);
@@ -628,14 +634,13 @@ void __init set_irq_probe(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= nr_irqs) {
+	desc = irq_desc_without_new(irq);
+	if (!desc) {
 		printk(KERN_ERR "Trying to mark IRQ%d probeable\n", irq);
 
 		return;
 	}
 
-	desc = irq_desc(irq);
-
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->status &= ~IRQ_NOPROBE;
 	spin_unlock_irqrestore(&desc->lock, flags);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index b7e30f2..f87277d 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -31,10 +31,10 @@ cpumask_t irq_default_affinity = CPU_MASK_ALL;
  */
 void synchronize_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc = irq_desc_without_new(irq);
 	unsigned int status;
 
-	if (irq >= nr_irqs)
+	if (!desc)
 		return;
 
 	do {
@@ -142,10 +142,11 @@ int irq_select_affinity(unsigned int irq)
  */
 void disable_irq_nosync(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= nr_irqs)
+	desc = irq_desc_without_new(irq);
+	if (!desc)
 		return;
 
 	spin_lock_irqsave(&desc->lock, flags);
@@ -171,9 +172,10 @@ EXPORT_SYMBOL(disable_irq_nosync);
  */
 void disable_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc;
 
-	if (irq >= nr_irqs)
+	desc = irq_desc_without_new(irq);
+	if (!desc)
 		return;
 
 	disable_irq_nosync(irq);
@@ -213,10 +215,11 @@ static void __enable_irq(struct irq_desc *desc, unsigned int irq)
  */
 void enable_irq(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc;
 	unsigned long flags;
 
-	if (irq >= nr_irqs)
+	desc = irq_desc_without_new(irq);
+	if (!desc)
 		return;
 
 	spin_lock_irqsave(&desc->lock, flags);
@@ -290,10 +293,14 @@ EXPORT_SYMBOL(set_irq_wake);
  */
 int can_request_irq(unsigned int irq, unsigned long irqflags)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc;
 	struct irqaction *action;
 
-	if (irq >= nr_irqs || desc->status & IRQ_NOREQUEST)
+	desc = irq_desc_without_new(irq);
+	if (!desc)
+		return 0;
+
+	if (desc->status & IRQ_NOREQUEST)
 		return 0;
 
 	action = desc->action;
@@ -345,14 +352,15 @@ static int __irq_set_trigger(struct irq_chip *chip, unsigned int irq,
  */
 int setup_irq(unsigned int irq, struct irqaction *new)
 {
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc;
 	struct irqaction *old, **p;
 	const char *old_name = NULL;
 	unsigned long flags;
 	int shared = 0;
 	int ret;
 
-	if (irq >= nr_irqs)
+	desc = irq_desc_without_new(irq);
+	if (!desc)
 		return -EINVAL;
 
 	if (desc->chip == &no_irq_chip)
@@ -506,10 +514,11 @@ void free_irq(unsigned int irq, void *dev_id)
 	unsigned long flags;
 
 	WARN_ON(in_interrupt());
-	if (irq >= nr_irqs)
+
+	desc = irq_desc_without_new(irq);
+	if (!desc)
 		return;
 
-	desc = irq_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
 	p = &desc->action;
 	for (;;) {
@@ -621,9 +630,11 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 	 */
 	if ((irqflags & IRQF_SHARED) && !dev_id)
 		return -EINVAL;
-	if (irq >= nr_irqs)
+
+	desc = irq_desc_without_new(irq);
+	if (!desc)
 		return -EINVAL;
-	desc = irq_desc(irq);
+
 	if (desc->status & IRQ_NOREQUEST)
 		return -EINVAL;
 	if (!handler)
-- 
1.5.4.5

