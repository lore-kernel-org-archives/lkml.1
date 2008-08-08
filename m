Return-Path: <linux-kernel-owner+w=401wt.eu-S1764990AbYHHWH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764990AbYHHWH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbYHHVzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:55:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:59965 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762240AbYHHVy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:54:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HCSiOzKbIjdJ8jdzpcR/uPlPlpyExcjauaCK4nYPwT4YYc1KUiw78Dzc1wvPR19I+F
         f3EgMWIpPjtkRhIj++T5/j3PT6IV7yfukd6szVPZq4xnQLXR27HHCHF/hV4hSIZejI83
         CdCI2/ujWuQjYprkc9rfaOuwGq5J1rfopzrUk=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 34/42] x86_64: add irq_desc in function in paramater
Date: Fri,  8 Aug 2008 14:52:40 -0700
Message-Id: <1218232368-31228-35-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-34-git-send-email-yhlu.kernel@gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So could remove some duplicated calling to irq_desc

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic_32.c |    6 ++-
 arch/x86/kernel/io_apic_64.c |   49 +++++++++++++------------------
 arch/x86/kernel/irq_32.c     |    3 +-
 arch/x86/kernel/irq_64.c     |    8 +++--
 drivers/mfd/tc6393xb.c       |    7 +++-
 drivers/parisc/dino.c        |    3 +-
 drivers/parisc/eisa.c        |    4 ++-
 drivers/parisc/gsc.c         |    3 +-
 drivers/parisc/superio.c     |    4 ++-
 include/linux/irq.h          |   30 +++++++++++++------
 init/main.c                  |    5 +++
 kernel/irq/chip.c            |   26 +++++++++++++++-
 kernel/irq/handle.c          |   65 +++++++++++++++++++++++++++++++++++++++--
 kernel/irq/manage.c          |    8 +++++
 kernel/irq/migration.c       |   15 +++++----
 15 files changed, 172 insertions(+), 64 deletions(-)

diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index cb18dbb..7cb3411 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -1975,7 +1975,8 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
 
 static void ack_ioapic_irq(unsigned int irq)
 {
-	move_native_irq(irq);
+	struct irq_desc *desc = irq_desc(irq);
+	move_native_irq(irq, desc);
 	ack_APIC_irq();
 }
 
@@ -1983,8 +1984,9 @@ static void ack_ioapic_quirk_irq(unsigned int irq)
 {
 	unsigned long v;
 	int i;
+	struct irq_desc *desc = irq_desc(irq);
 
-	move_native_irq(irq);
+	move_native_irq(irq, desc);
 /*
  * It appears there is an erratum which affects at least version 0x11
  * of I/O APIC (that's the 82093AA and cores integrated into various
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 36d6387..fc1c6ba 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -505,13 +505,12 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, u8 vector)
 	}
 }
 
-static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
+static void set_ioapic_affinity_irq(unsigned int irq, struct irq_desc *desc, cpumask_t mask)
 {
 	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned long flags;
 	unsigned int dest;
 	cpumask_t tmp;
-	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -528,7 +527,6 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
 	 */
 	dest = SET_APIC_LOGICAL_ID(dest);
 
-	desc = irq_desc(irq);
 	spin_lock_irqsave(&ioapic_lock, flags);
 	__target_IO_APIC_irq(irq, dest, cfg->vector);
 	desc->affinity = mask;
@@ -1874,7 +1872,7 @@ static void ir_irq_migration(struct work_struct *work)
 				continue;
 			}
 
-			desc->chip->set_affinity(irq, desc->pending_mask);
+			desc->chip->set_affinity(irq, desc, desc->pending_mask);
 			spin_unlock_irqrestore(&desc->lock, flags);
 		}
 	}
@@ -1883,10 +1881,8 @@ static void ir_irq_migration(struct work_struct *work)
 /*
  * Migrates the IRQ destination in the process context.
  */
-static void set_ir_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
+static void set_ir_ioapic_affinity_irq(unsigned int irq, struct irq_desc *desc, cpumask_t mask)
 {
-	struct irq_desc *desc = irq_desc(irq);
-
 	if (desc->status & IRQ_LEVEL) {
 		desc->status |= IRQ_MOVE_PENDING;
 		desc->pending_mask = mask;
@@ -1953,32 +1949,32 @@ static void irq_complete_move(unsigned int irq)
 static inline void irq_complete_move(unsigned int irq) {}
 #endif
 #ifdef CONFIG_INTR_REMAP
-static void ack_x2apic_level(unsigned int irq)
+static void ack_x2apic_level(unsigned int irq, struct irq_desc *desc)
 {
 	ack_x2APIC_irq();
 }
 
-static void ack_x2apic_edge(unsigned int irq)
+static void ack_x2apic_edge(unsigned int irq, struct irq_desc *desc)
 {
 	ack_x2APIC_irq();
 }
 #endif
 
-static void ack_apic_edge(unsigned int irq)
+static void ack_apic_edge(unsigned int irq, struct irq_desc *desc)
 {
 	irq_complete_move(irq);
-	move_native_irq(irq);
+	move_native_irq(irq, desc);
 	ack_APIC_irq();
 }
 
-static void ack_apic_level(unsigned int irq)
+static void ack_apic_level(unsigned int irq, struct irq_desc *desc)
 {
 	int do_unmask_irq = 0;
 
 	irq_complete_move(irq);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	/* If we are moving the irq we need to mask it */
-	if (unlikely(irq_desc(irq)->status & IRQ_MOVE_PENDING)) {
+	if (unlikely(desc->status & IRQ_MOVE_PENDING)) {
 		do_unmask_irq = 1;
 		mask_IO_APIC_irq(irq);
 	}
@@ -2019,7 +2015,7 @@ static void ack_apic_level(unsigned int irq)
 		 * and you can go talk to the chipset vendor about it.
 		 */
 		if (!io_apic_level_ack_pending(irq))
-			move_masked_irq(irq);
+			move_masked_irq(irq, desc);
 		unmask_IO_APIC_irq(irq);
 	}
 }
@@ -2104,7 +2100,7 @@ static void mask_lapic_irq(unsigned int irq)
 	apic_write(APIC_LVT0, v | APIC_LVT_MASKED);
 }
 
-static void ack_lapic_irq (unsigned int irq)
+static void ack_lapic_irq (unsigned int irq, struct irq_desc *desc)
 {
 	ack_APIC_irq();
 }
@@ -2594,13 +2590,12 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 }
 
 #ifdef CONFIG_SMP
-static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
+static void set_msi_irq_affinity(unsigned int irq, struct irq_desc *desc, cpumask_t mask)
 {
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
-	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -2621,7 +2616,6 @@ static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	write_msi_msg(irq, &msg);
-	desc = irq_desc(irq);
 	desc->affinity = mask;
 }
 
@@ -2630,13 +2624,12 @@ static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
  * Migrate the MSI irq to another cpumask. This migration is
  * done in the process context using interrupt-remapping hardware.
  */
-static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
+static void ir_set_msi_irq_affinity(unsigned int irq, struct irq_desc *desc, cpumask_t mask)
 {
 	struct irq_cfg *cfg;
 	unsigned int dest;
 	cpumask_t tmp, cleanup_mask;
 	struct irte irte;
-	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -2672,7 +2665,6 @@ static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 		cfg->move_in_progress = 0;
 	}
 
-	desc = irq_desc(irq);
 	desc->affinity = mask;
 }
 #endif
@@ -2853,13 +2845,12 @@ void arch_teardown_msi_irq(unsigned int irq)
 
 #ifdef CONFIG_DMAR
 #ifdef CONFIG_SMP
-static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
+static void dmar_msi_set_affinity(unsigned int irq, struct irq_desc *desc, cpumask_t mask)
 {
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
-	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -2880,7 +2871,6 @@ static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
-	desc = irq_desc(irq);
 	desc->affinity = mask;
 }
 #endif /* CONFIG_SMP */
@@ -2933,12 +2923,11 @@ static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
 	write_ht_irq_msg(irq, &msg);
 }
 
-static void set_ht_irq_affinity(unsigned int irq, cpumask_t mask)
+static void set_ht_irq_affinity(unsigned int irq, struct irq_desc *desc, cpumask_t mask)
 {
 	struct irq_cfg *cfg;
 	unsigned int dest;
 	cpumask_t tmp;
-	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -2952,7 +2941,6 @@ static void set_ht_irq_affinity(unsigned int irq, cpumask_t mask)
 	dest = cpu_mask_to_apicid(tmp);
 
 	target_ht_irq(irq, dest, cfg->vector);
-	desc = irq_desc(irq);
 	desc->affinity = mask;
 }
 #endif
@@ -3080,6 +3068,7 @@ void __init setup_ioapic_dest(void)
 {
 	int pin, ioapic, irq, irq_entry;
 	struct irq_cfg *cfg;
+	struct irq_desc *desc;
 
 	if (skip_ioapic_setup == 1)
 		return;
@@ -3091,6 +3080,8 @@ void __init setup_ioapic_dest(void)
 				continue;
 			irq = pin_2_irq(irq_entry, ioapic, pin);
 
+			desc = irq_desc(irq);
+
 			/* setup_IO_APIC_irqs could fail to get vector for some device
 			 * when you have too many devices, because at that time only boot
 			 * cpu is online.
@@ -3102,10 +3093,10 @@ void __init setup_ioapic_dest(void)
 						  irq_polarity(irq_entry));
 #ifdef CONFIG_INTR_REMAP
 			else if (intr_remapping_enabled)
-				set_ir_ioapic_affinity_irq(irq, TARGET_CPUS);
+				set_ir_ioapic_affinity_irq(irq, desc, TARGET_CPUS);
 #endif
 			else
-				set_ioapic_affinity_irq(irq, TARGET_CPUS);
+				set_ioapic_affinity_irq(irq, desc, TARGET_CPUS);
 		}
 
 	}
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 8ff73e7..7d93253 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -224,7 +224,7 @@ unsigned int do_IRQ(struct pt_regs *regs)
 	struct pt_regs *old_regs;
 	/* high bit used in ret_from_ code */
 	int overflow, irq = ~regs->orig_ax;
-	struct irq_desc *desc = irq_desc(irq);
+	struct irq_desc *desc;
 
 	if (unlikely((unsigned)irq >= nr_irqs)) {
 		printk(KERN_EMERG "%s: cannot handle IRQ %d\n",
@@ -232,6 +232,7 @@ unsigned int do_IRQ(struct pt_regs *regs)
 		BUG();
 	}
 
+	desc = irq_desc(irq);
 	old_regs = set_irq_regs(regs);
 	irq_enter();
 
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index b94faa1..007e4a2 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -189,6 +189,7 @@ u64 arch_irq_stat(void)
 asmlinkage unsigned int do_IRQ(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
+	struct irq_desc *desc;
 
 	/* high bit used in ret_from_ code  */
 	unsigned vector = ~regs->orig_ax;
@@ -202,8 +203,9 @@ asmlinkage unsigned int do_IRQ(struct pt_regs *regs)
 	stack_overflow_check(regs);
 #endif
 
-	if (likely(irq_desc_without_new(irq)))
-		generic_handle_irq(irq);
+	desc = irq_desc_without_new(irq);
+	if (likely(desc))
+		generic_handle_irq(irq, desc);
 	else {
 		if (!disable_apic)
 			ack_APIC_irq();
@@ -253,7 +255,7 @@ void fixup_irqs(cpumask_t map)
 			desc->chip->mask(irq);
 
 		if (desc->chip->set_affinity)
-			desc->chip->set_affinity(irq, mask);
+			desc->chip->set_affinity(irq, desc, mask);
 		else if (!(warned++))
 			set_affinity = 0;
 
diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index f4fd797..9ae9ec8 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -262,14 +262,17 @@ tc6393xb_irq(unsigned int irq, struct irq_desc *desc)
 	struct tc6393xb *tc6393xb = get_irq_data(irq);
 	unsigned int isr;
 	unsigned int i, irq_base;
+	struct irq_desc *descx;
 
 	irq_base = tc6393xb->irq_base;
 
 	while ((isr = ioread8(tc6393xb->scr + SCR_ISR) &
 				~ioread8(tc6393xb->scr + SCR_IMR)))
 		for (i = 0; i < TC6393XB_NR_IRQS; i++) {
-			if (isr & (1 << i))
-				generic_handle_irq(irq_base + i);
+			if (isr & (1 << i)) {
+				descx = irq_desc(irq_base + i);
+				generic_handle_irq(irq_base + i, descx);
+			}
 		}
 }
 
diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index 6bba8e9..7ae81e1 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -389,9 +389,10 @@ ilr_again:
 	do {
 		int local_irq = __ffs(mask);
 		int irq = dino_dev->global_irq[local_irq];
+		struct irq_desc *desc = irq_desc(irq);
 		DBG(KERN_DEBUG "%s(%d, %p) mask 0x%x\n",
 			__func__, irq, intr_dev, mask);
-		__do_IRQ(irq);
+		__do_IRQ(irq, desc);
 		mask &= ~(1 << local_irq);
 	} while (mask);
 
diff --git a/drivers/parisc/eisa.c b/drivers/parisc/eisa.c
index feb67d4..67142ee 100644
--- a/drivers/parisc/eisa.c
+++ b/drivers/parisc/eisa.c
@@ -202,6 +202,7 @@ static irqreturn_t eisa_irq(int wax_irq, void *intr_dev)
 {
 	int irq = gsc_readb(0xfc01f000); /* EISA supports 16 irqs */
 	unsigned long flags;
+	struct irq_desc *desc;
         
 	spin_lock_irqsave(&eisa_irq_lock, flags);
 	/* read IRR command */
@@ -233,7 +234,8 @@ static irqreturn_t eisa_irq(int wax_irq, void *intr_dev)
 	}
 	spin_unlock_irqrestore(&eisa_irq_lock, flags);
 
-	__do_IRQ(irq);
+	desc = irq_desc(irq);
+	__do_IRQ(irq, desc);
    
 	spin_lock_irqsave(&eisa_irq_lock, flags);
 	/* unmask */
diff --git a/drivers/parisc/gsc.c b/drivers/parisc/gsc.c
index f714f6a..3e1b6e5 100644
--- a/drivers/parisc/gsc.c
+++ b/drivers/parisc/gsc.c
@@ -87,7 +87,8 @@ irqreturn_t gsc_asic_intr(int gsc_asic_irq, void *dev)
 	do {
 		int local_irq = __ffs(irr);
 		unsigned int irq = gsc_asic->global_irq[local_irq];
-		__do_IRQ(irq);
+		struct irq_desc *desc = irq_desc(irq);
+		__do_IRQ(irq, desc);
 		irr &= ~(1 << local_irq);
 	} while (irr);
 
diff --git a/drivers/parisc/superio.c b/drivers/parisc/superio.c
index 67e552d..51749eb 100644
--- a/drivers/parisc/superio.c
+++ b/drivers/parisc/superio.c
@@ -99,6 +99,7 @@ superio_interrupt(int parent_irq, void *devp)
 {
 	u8 results;
 	u8 local_irq;
+	struct irq_desc *desc;
 
 	/* Poll the 8259 to see if there's an interrupt. */
 	outb (OCW3_POLL,IC_PIC1+0);
@@ -139,7 +140,8 @@ superio_interrupt(int parent_irq, void *devp)
 	}
 
 	/* Call the appropriate device's interrupt */
-	__do_IRQ(local_irq);
+	desc = irq_desc(local_irq);
+	__do_IRQ(local_irq, desc);
 
 	/* set EOI - forces a new interrupt if a lower priority device
 	 * still needs service.
diff --git a/include/linux/irq.h b/include/linux/irq.h
index a712287..d04182a 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -106,14 +106,26 @@ struct irq_chip {
 	void		(*enable)(unsigned int irq);
 	void		(*disable)(unsigned int irq);
 
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	void		(*ack)(unsigned int irq, struct irq_desc *desc);
+#else
 	void		(*ack)(unsigned int irq);
+#endif
 	void		(*mask)(unsigned int irq);
 	void		(*mask_ack)(unsigned int irq);
 	void		(*unmask)(unsigned int irq);
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	void		(*eoi)(unsigned int irq, struct irq_desc *desc);
+#else
 	void		(*eoi)(unsigned int irq);
+#endif
 
 	void		(*end)(unsigned int irq);
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	void		(*set_affinity)(unsigned int irq, struct irq_desc *desc, cpumask_t dest);
+#else
 	void		(*set_affinity)(unsigned int irq, cpumask_t dest);
+#endif
 	int		(*retrigger)(unsigned int irq);
 	int		(*set_type)(unsigned int irq, unsigned int flow_type);
 	int		(*set_wake)(unsigned int irq, unsigned int on);
@@ -240,8 +252,8 @@ extern int setup_irq(unsigned int irq, struct irqaction *new);
 #if defined(CONFIG_GENERIC_PENDING_IRQ) || defined(CONFIG_IRQBALANCE)
 
 void set_pending_irq(unsigned int irq, cpumask_t mask);
-void move_native_irq(int irq);
-void move_masked_irq(int irq);
+void move_native_irq(int irq, struct irq_desc *desc);
+void move_masked_irq(int irq, struct irq_desc *desc);
 
 #else /* CONFIG_GENERIC_PENDING_IRQ || CONFIG_IRQBALANCE */
 
@@ -249,11 +261,11 @@ static inline void move_irq(int irq)
 {
 }
 
-static inline void move_native_irq(int irq)
+static inline void move_native_irq(int irq, struct irq_desc *desc)
 {
 }
 
-static inline void move_masked_irq(int irq)
+static inline void move_masked_irq(int irq, struct irq_desc *desc)
 {
 }
 
@@ -265,7 +277,7 @@ static inline void set_pending_irq(unsigned int irq, cpumask_t mask)
 
 #else /* CONFIG_SMP */
 
-#define move_native_irq(x)
+#define move_native_irq(x, y)
 #define move_masked_irq(x)
 
 #endif /* CONFIG_SMP */
@@ -306,7 +318,7 @@ extern void handle_bad_irq(unsigned int irq, struct irq_desc *desc);
  * Monolithic do_IRQ implementation.
  */
 #ifndef CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ
-extern unsigned int __do_IRQ(unsigned int irq);
+extern unsigned int __do_IRQ(unsigned int irq, struct irq_desc *desc);
 #endif
 
 /*
@@ -315,17 +327,15 @@ extern unsigned int __do_IRQ(unsigned int irq);
  * irqchip-style controller then we call the ->handle_irq() handler,
  * and it calls __do_IRQ() if it's attached to an irqtype-style controller.
  */
-static inline void generic_handle_irq(unsigned int irq)
+static inline void generic_handle_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_desc(irq);
-
 #ifdef CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ
 	desc->handle_irq(irq, desc);
 #else
 	if (likely(desc->handle_irq))
 		desc->handle_irq(irq, desc);
 	else
-		__do_IRQ(irq);
+		__do_IRQ(irq, desc);
 #endif
 }
 
diff --git a/init/main.c b/init/main.c
index 3454b4a..a0ecfdf 100644
--- a/init/main.c
+++ b/init/main.c
@@ -593,6 +593,11 @@ void pre_alloc_dyn_array(void)
 		if (da->init_work)
 			da->init_work(da);
 	}
+#else
+	unsigned int i;
+
+	for (i = 0; i < NR_IRQS; i++)
+		irq_desc[i].irq = i;
 #endif
 }
 
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index fed5ce7..dcac270 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -310,7 +310,11 @@ static inline void mask_ack_irq(struct irq_desc *desc, int irq)
 		desc->chip->mask_ack(irq);
 	else {
 		desc->chip->mask(irq);
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+		desc->chip->ack(irq, desc);
+#else
 		desc->chip->ack(irq);
+#endif
 	}
 }
 
@@ -450,7 +454,11 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
 out:
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	desc->chip->eoi(irq, desc);
+#else
 	desc->chip->eoi(irq);
+#endif
 
 	spin_unlock(&desc->lock);
 }
@@ -493,7 +501,11 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 	kstat_irqs_this_cpu(desc)++;
 
 	/* Start handling the irq */
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	desc->chip->ack(irq, desc);
+#else
 	desc->chip->ack(irq);
+#endif
 
 	/* Mark the IRQ currently in progress.*/
 	desc->status |= IRQ_INPROGRESS;
@@ -547,15 +559,25 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 
 	kstat_irqs_this_cpu(desc)++;
 
-	if (desc->chip->ack)
+	if (desc->chip->ack) {
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+		desc->chip->ack(irq, desc);
+#else
 		desc->chip->ack(irq);
+#endif
+	}
 
 	action_ret = handle_IRQ_event(irq, desc->action);
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
-	if (desc->chip->eoi)
+	if (desc->chip->eoi) {
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+		desc->chip->eoi(irq, desc);
+#else
 		desc->chip->eoi(irq);
+#endif
+	}
 }
 
 void
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index e2cfbb6..e9b54a5 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -196,6 +196,21 @@ struct irq_desc *irq_desc(unsigned int irq)
 	 *  we run out of pre-allocate ones, allocate more
 	 */
 	printk(KERN_DEBUG "try to get more irq_desc %d\n", nr_irq_desc);
+	{
+		/* double check if some one mess up the list */
+		struct irq_desc *desc;
+		int count = 0;
+
+		desc = &irq_descX[0];
+		while (desc) {
+			printk("found irq_desc for irq %d\n", desc->irq);
+			if (desc->next)
+				printk("found irq_desc for irq %d and next will be irq %d\n", desc->irq, desc->next->irq);
+			desc = desc->next;
+			count++;
+		}
+		printk("all preallocted %d\n", count);
+	}
 
 	total_bytes = sizeof(struct irq_desc) * nr_irq_desc;
 	if (after_bootmem)
@@ -220,6 +235,21 @@ struct irq_desc *irq_desc(unsigned int irq)
 
 	desc->irq = irq;
 	desc_pri->next = desc;
+	{
+		/* double check if some one mess up the list */
+		struct irq_desc *desc;
+		int count = 0;
+
+		desc = &irq_descX[0];
+		while (desc) {
+			printk("1 found irq_desc for irq %d\n", desc->irq);
+			if (desc->next)
+				printk("1 found irq_desc for irq %d and next will be irq %d\n", desc->irq, desc->next->irq);
+			desc = desc->next;
+			count++;
+		}
+		printk("1 all preallocted %d\n", count);
+	}
 
 	return desc;
 }
@@ -265,6 +295,13 @@ struct irq_desc *irq_desc_without_new(unsigned int irq)
  * What should we do if we get a hw irq event on an illegal vector?
  * Each architecture has to answer this themself.
  */
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+static void ack_bad(unsigned int irq, struct irq_desc *desc)
+{
+	print_irq_desc(irq, desc);
+	ack_bad_irq(irq);
+}
+#else
 static void ack_bad(unsigned int irq)
 {
 	struct irq_desc *desc;
@@ -273,6 +310,7 @@ static void ack_bad(unsigned int irq)
 	print_irq_desc(irq, desc);
 	ack_bad_irq(irq);
 }
+#endif
 
 /*
  * NOP functions
@@ -281,6 +319,12 @@ static void noop(unsigned int irq)
 {
 }
 
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+static void noop_desc(unsigned int irq, struct irq_desc *desc)
+{
+}
+#endif
+
 static unsigned int noop_ret(unsigned int irq)
 {
 	return 0;
@@ -309,7 +353,11 @@ struct irq_chip dummy_irq_chip = {
 	.shutdown	= noop,
 	.enable		= noop,
 	.disable	= noop,
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	.ack		= noop_desc,
+#else
 	.ack		= noop,
+#endif
 	.mask		= noop,
 	.unmask		= noop,
 	.end		= noop,
@@ -365,9 +413,8 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
  * This is the original x86 implementation which is used for every
  * interrupt type.
  */
-unsigned int __do_IRQ(unsigned int irq)
+unsigned int __do_IRQ(unsigned int irq, struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_desc(irq);
 	struct irqaction *action;
 	unsigned int status;
 
@@ -378,8 +425,13 @@ unsigned int __do_IRQ(unsigned int irq)
 		/*
 		 * No locking required for CPU-local interrupts:
 		 */
-		if (desc->chip->ack)
+		if (desc->chip->ack) {
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+			desc->chip->ack(irq, desc);
+#else
 			desc->chip->ack(irq);
+#endif
+		}
 		if (likely(!(desc->status & IRQ_DISABLED))) {
 			action_ret = handle_IRQ_event(irq, desc->action);
 			if (!noirqdebug)
@@ -390,8 +442,13 @@ unsigned int __do_IRQ(unsigned int irq)
 	}
 
 	spin_lock(&desc->lock);
-	if (desc->chip->ack)
+	if (desc->chip->ack) {
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+		desc->chip->ack(irq, desc);
+#else
 		desc->chip->ack(irq);
+#endif
+	}
 	/*
 	 * REPLAY is when Linux resends an IRQ that was dropped earlier
 	 * WAITING is used by probe to mark irqs that are being tested
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index ad7294c..e4db607 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -95,7 +95,11 @@ int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
 		unsigned long flags;
 
 		spin_lock_irqsave(&desc->lock, flags);
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+		desc->chip->set_affinity(irq, desc, cpumask);
+#else
 		desc->chip->set_affinity(irq, cpumask);
+#endif
 		spin_unlock_irqrestore(&desc->lock, flags);
 	} else
 		set_pending_irq(irq, cpumask);
@@ -122,7 +126,11 @@ int irq_select_affinity(unsigned int irq)
 
 	desc = irq_desc(irq);
 	desc->affinity = mask;
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	desc->chip->set_affinity(irq, desc, mask);
+#else
 	desc->chip->set_affinity(irq, mask);
+#endif
 
 	set_balance_irq_affinity(irq, mask);
 	return 0;
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index 62a447c..ea1bda1 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -12,9 +12,8 @@ void set_pending_irq(unsigned int irq, cpumask_t mask)
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
 
-void move_masked_irq(int irq)
+void move_masked_irq(int irq, struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_desc(irq);
 	cpumask_t tmp;
 
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
@@ -53,15 +52,17 @@ void move_masked_irq(int irq)
 	 * masking the irqs.
 	 */
 	if (likely(!cpus_empty(tmp))) {
-		desc->chip->set_affinity(irq,tmp);
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+		desc->chip->set_affinity(irq, desc, tmp);
+#else
+		desc->chip->set_affinity(irq, tmp);
+#endif
 	}
 	cpus_clear(desc->pending_mask);
 }
 
-void move_native_irq(int irq)
+void move_native_irq(int irq, struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_desc(irq);
-
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
 
@@ -69,7 +70,7 @@ void move_native_irq(int irq)
 		return;
 
 	desc->chip->mask(irq);
-	move_masked_irq(irq);
+	move_masked_irq(irq, desc);
 	desc->chip->unmask(irq);
 }
 
-- 
1.5.4.5

