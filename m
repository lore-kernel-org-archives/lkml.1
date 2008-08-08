Return-Path: <linux-kernel-owner+w=401wt.eu-S1763980AbYHHWKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763980AbYHHWKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762150AbYHHVzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:55:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:59965 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761570AbYHHVzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:55:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=c5E1uTiBwSRVkDcEYWFuA/Z4mGUJ6bXi1OIfa+7DX1+KmTvq1jzxPV4UBU6KzMC2PL
         mByDCMMhW6WQgT+Fj8lLVogxs/OysHx2fwXrCElbXBABsz5HRQeJbtz3OguRbDdFziaB
         vCQ5uYiKn1uKHrfkfmxX3G4BHL+8YdG5DTpHk=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 42/42] x86: put irq_2_iommu pointer into irq_desc
Date: Fri,  8 Aug 2008 14:52:48 -0700
Message-Id: <1218232368-31228-43-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-42-git-send-email-yhlu.kernel@gmail.com>
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
 <1218232368-31228-38-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-39-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-40-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-41-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-42-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

preallocate some irq_2_iommu, and use get_one_free_irq_2_iomm to get one
and link to irq_desc if needed.
---
 drivers/pci/intr_remapping.c |  213 ++++++++++++++++++++++++++++++++----------
 include/linux/irq.h          |    4 +
 2 files changed, 169 insertions(+), 48 deletions(-)

diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index a7302d5..78896b3 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -18,41 +18,136 @@ struct irq_2_iommu {
 	u8  irte_mask;
 };
 
-#ifdef CONFIG_HAVE_DYNA_ARRAY
-static struct irq_2_iommu *irq_2_iommu;
-DEFINE_DYN_ARRAY(irq_2_iommu, sizeof(struct irq_2_iommu), nr_irqs, PAGE_SIZE, NULL);
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+static struct irq_2_iommu *irq_2_iommuX;
+/* fill one page ? */
+static int nr_irq_2_iommu = 0x100;
+static int irq_2_iommu_index;
+DEFINE_DYN_ARRAY(irq_2_iommuX, sizeof(struct irq_2_iommu), nr_irq_2_iommu, PAGE_SIZE, NULL);
+
+extern void *__alloc_bootmem_nopanic(unsigned long size,
+				     unsigned long align,
+				     unsigned long goal);
+
+static struct irq_2_iommu *get_one_free_irq_2_iommu(int not_used)
+{
+        struct irq_2_iommu *iommu;
+	unsigned long total_bytes;
+
+        if (irq_2_iommu_index >= nr_irq_2_iommu) {
+		/*
+		 *  we run out of pre-allocate ones, allocate more
+		 */
+		printk(KERN_DEBUG "try to get more irq_2_iommu %d\n", nr_irq_2_iommu);
+
+		total_bytes = sizeof(struct irq_2_iommu)*nr_irq_2_iommu;
+
+		if (after_bootmem)
+			iommu = kzalloc(total_bytes, GFP_ATOMIC);
+		else
+			iommu = __alloc_bootmem_nopanic(total_bytes, PAGE_SIZE, 0);
+
+		if (!iommu)
+			panic("can not get more irq_2_iommu\n");
+
+		irq_2_iommuX = iommu;
+		irq_2_iommu_index = 0;
+	}
+
+	iommu = &irq_2_iommuX[irq_2_iommu_index];
+	irq_2_iommu_index++;
+	return iommu;
+}
+
+static struct irq_2_iommu *irq_2_iommu(unsigned int irq)
+{
+	struct irq_desc *desc;
+
+	desc = irq_desc(irq);
+
+	BUG_ON(!desc);
+
+	return desc->irq_2_iommu;
+}
+
+static struct irq_2_iommu *irq_2_iommu_with_new(unsigned int irq)
+{
+	struct irq_desc *desc;
+	struct irq_2_iommu *irq_iommu;
+
+	desc = irq_desc(irq);
+
+	BUG_ON(!desc);
+
+	irq_iommu = desc->irq_2_iommu;
+
+	if (!irq_iommu)
+		desc->irq_2_iommu = get_one_free_irq_2_iommu(irq);
+
+	return desc->irq_2_iommu;
+}
+
+#else /* !CONFIG_HAVE_SPARSE_IRQ */
+
+#ifdef CONFIG_HAVE_DYN_ARRAY
+static struct irq_2_iommu *irq_2_iommuX;
+DEFINE_DYN_ARRAY(irq_2_iommuX, sizeof(struct irq_2_iommu), nr_irqs, PAGE_SIZE, NULL);
 #else
-static struct irq_2_iommu irq_2_iommu[NR_IRQS];
+static struct irq_2_iommu irq_2_iommuX[NR_IRQS];
+#endif
+
+static struct irq_2_iommu *irq_2_iommu(unsigned int irq)
+{
+	if (irq <= nr_irqs)
+		return &irq_2_iommuX[irq];
+
+	return NULL;
+}
+static struct irq_2_iommu *irq_2_iommu_with_new(unsigned int irq)
+{
+	return irq_2_iommu(irq);
+}
 #endif
 
 static DEFINE_SPINLOCK(irq_2_ir_lock);
 
-int irq_remapped(int irq)
+static struct irq_2_iommu *valid_irq_2_iommu(unsigned int irq)
 {
-	if (irq > nr_irqs)
-		return 0;
+	struct irq_2_iommu *irq_iommu;
+
+	irq_iommu = irq_2_iommu(irq);
 
-	if (!irq_2_iommu[irq].iommu)
-		return 0;
+	if (!irq_iommu)
+		return NULL;
 
-	return 1;
+	if (!irq_iommu->iommu)
+		return NULL;
+
+	return irq_iommu;
+}
+
+int irq_remapped(int irq)
+{
+	return valid_irq_2_iommu(irq) != NULL;
 }
 
 int get_irte(int irq, struct irte *entry)
 {
 	int index;
+	struct irq_2_iommu *irq_iommu;
 
-	if (!entry || irq > nr_irqs)
+	if (!entry)
 		return -1;
 
 	spin_lock(&irq_2_ir_lock);
-	if (!irq_2_iommu[irq].iommu) {
+	irq_iommu = valid_irq_2_iommu(irq);
+	if (!irq_iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
 
-	index = irq_2_iommu[irq].irte_index + irq_2_iommu[irq].sub_handle;
-	*entry = *(irq_2_iommu[irq].iommu->ir_table->base + index);
+	index = irq_iommu->irte_index + irq_iommu->sub_handle;
+	*entry = *(irq_iommu->iommu->ir_table->base + index);
 
 	spin_unlock(&irq_2_ir_lock);
 	return 0;
@@ -61,6 +156,7 @@ int get_irte(int irq, struct irte *entry)
 int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 {
 	struct ir_table *table = iommu->ir_table;
+	struct irq_2_iommu *irq_iommu;
 	u16 index, start_index;
 	unsigned int mask = 0;
 	int i;
@@ -68,6 +164,12 @@ int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 	if (!count)
 		return -1;
 
+#ifndef	CONFIG_HAVE_SPARSE_IRQ
+	/* protect irq_2_iommu_with_new later */
+	if (irq >= nr_irqs)
+		return -1;
+#endif
+
 	/*
 	 * start the IRTE search from index 0.
 	 */
@@ -107,10 +209,11 @@ int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 	for (i = index; i < index + count; i++)
 		table->base[i].present = 1;
 
-	irq_2_iommu[irq].iommu = iommu;
-	irq_2_iommu[irq].irte_index =  index;
-	irq_2_iommu[irq].sub_handle = 0;
-	irq_2_iommu[irq].irte_mask = mask;
+	irq_iommu = irq_2_iommu_with_new(irq);
+	irq_iommu->iommu = iommu;
+	irq_iommu->irte_index =  index;
+	irq_iommu->sub_handle = 0;
+	irq_iommu->irte_mask = mask;
 
 	spin_unlock(&irq_2_ir_lock);
 
@@ -131,31 +234,36 @@ static void qi_flush_iec(struct intel_iommu *iommu, int index, int mask)
 int map_irq_to_irte_handle(int irq, u16 *sub_handle)
 {
 	int index;
+	struct irq_2_iommu *irq_iommu;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
+	irq_iommu = valid_irq_2_iommu(irq);
+	if (!irq_iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
 
-	*sub_handle = irq_2_iommu[irq].sub_handle;
-	index = irq_2_iommu[irq].irte_index;
+	*sub_handle = irq_iommu->sub_handle;
+	index = irq_iommu->irte_index;
 	spin_unlock(&irq_2_ir_lock);
 	return index;
 }
 
 int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 {
+	struct irq_2_iommu *irq_iommu;
+
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= nr_irqs || irq_2_iommu[irq].iommu) {
+	irq_iommu = valid_irq_2_iommu(irq);
+	if (!irq_iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
 
-	irq_2_iommu[irq].iommu = iommu;
-	irq_2_iommu[irq].irte_index = index;
-	irq_2_iommu[irq].sub_handle = subhandle;
-	irq_2_iommu[irq].irte_mask = 0;
+	irq_iommu->iommu = iommu;
+	irq_iommu->irte_index = index;
+	irq_iommu->sub_handle = subhandle;
+	irq_iommu->irte_mask = 0;
 
 	spin_unlock(&irq_2_ir_lock);
 
@@ -164,16 +272,19 @@ int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 
 int clear_irte_irq(int irq, struct intel_iommu *iommu, u16 index)
 {
+	struct irq_2_iommu *irq_iommu;
+
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
+	irq_iommu = valid_irq_2_iommu(irq);
+	if (!irq_iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
 
-	irq_2_iommu[irq].iommu = NULL;
-	irq_2_iommu[irq].irte_index = 0;
-	irq_2_iommu[irq].sub_handle = 0;
-	irq_2_iommu[irq].irte_mask = 0;
+	irq_iommu->iommu = NULL;
+	irq_iommu->irte_index = 0;
+	irq_iommu->sub_handle = 0;
+	irq_2_iommu(irq)->irte_mask = 0;
 
 	spin_unlock(&irq_2_ir_lock);
 
@@ -185,16 +296,18 @@ int modify_irte(int irq, struct irte *irte_modified)
 	int index;
 	struct irte *irte;
 	struct intel_iommu *iommu;
+	struct irq_2_iommu *irq_iommu;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
+	irq_iommu = valid_irq_2_iommu(irq);
+	if (!irq_iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
 
-	iommu = irq_2_iommu[irq].iommu;
+	iommu = irq_iommu->iommu;
 
-	index = irq_2_iommu[irq].irte_index + irq_2_iommu[irq].sub_handle;
+	index = irq_iommu->irte_index + irq_iommu->sub_handle;
 	irte = &iommu->ir_table->base[index];
 
 	set_64bit((unsigned long *)irte, irte_modified->low | (1 << 1));
@@ -210,18 +323,20 @@ int flush_irte(int irq)
 {
 	int index;
 	struct intel_iommu *iommu;
+	struct irq_2_iommu *irq_iommu;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
+	irq_iommu = valid_irq_2_iommu(irq);
+	if (!irq_iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
 
-	iommu = irq_2_iommu[irq].iommu;
+	iommu = irq_iommu->iommu;
 
-	index = irq_2_iommu[irq].irte_index + irq_2_iommu[irq].sub_handle;
+	index = irq_iommu->irte_index + irq_iommu->sub_handle;
 
-	qi_flush_iec(iommu, index, irq_2_iommu[irq].irte_mask);
+	qi_flush_iec(iommu, index, irq_iommu->irte_mask);
 	spin_unlock(&irq_2_ir_lock);
 
 	return 0;
@@ -253,28 +368,30 @@ int free_irte(int irq)
 	int index, i;
 	struct irte *irte;
 	struct intel_iommu *iommu;
+	struct irq_2_iommu *irq_iommu;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
+	irq_iommu = valid_irq_2_iommu(irq);
+	if (!irq_iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
 
-	iommu = irq_2_iommu[irq].iommu;
+	iommu = irq_iommu->iommu;
 
-	index = irq_2_iommu[irq].irte_index + irq_2_iommu[irq].sub_handle;
+	index = irq_iommu->irte_index + irq_iommu->sub_handle;
 	irte = &iommu->ir_table->base[index];
 
-	if (!irq_2_iommu[irq].sub_handle) {
-		for (i = 0; i < (1 << irq_2_iommu[irq].irte_mask); i++)
+	if (!irq_iommu->sub_handle) {
+		for (i = 0; i < (1 << irq_iommu->irte_mask); i++)
 			set_64bit((unsigned long *)irte, 0);
-		qi_flush_iec(iommu, index, irq_2_iommu[irq].irte_mask);
+		qi_flush_iec(iommu, index, irq_iommu->irte_mask);
 	}
 
-	irq_2_iommu[irq].iommu = NULL;
-	irq_2_iommu[irq].irte_index = 0;
-	irq_2_iommu[irq].sub_handle = 0;
-	irq_2_iommu[irq].irte_mask = 0;
+	irq_iommu->iommu = NULL;
+	irq_iommu->irte_index = 0;
+	irq_iommu->sub_handle = 0;
+	irq_iommu->irte_mask = 0;
 
 	spin_unlock(&irq_2_ir_lock);
 
diff --git a/include/linux/irq.h b/include/linux/irq.h
index d130119..2d57a2d 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -142,6 +142,7 @@ struct irq_chip {
 };
 
 struct timer_rand_state;
+struct irq_2_iommu;
 /**
  * struct irq_desc - interrupt descriptor
  *
@@ -177,6 +178,9 @@ struct irq_desc {
 	unsigned int		kstat_irqs[NR_CPUS];
 #endif
 	struct timer_rand_state *timer_rand_state;
+#if defined(CONFIG_INTR_REMAP) && defined(CONFIG_HAVE_SPARSE_IRQ)
+	struct irq_2_iommu	*irq_2_iommu;
+#endif
 	irq_flow_handler_t	handle_irq;
 	struct irq_chip		*chip;
 	struct msi_desc		*msi_desc;
-- 
1.5.4.5

