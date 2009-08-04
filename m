Return-Path: <linux-kernel-owner+w=401wt.eu-S932876AbZHDQFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876AbZHDQFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932767AbZHDQFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:05:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:58941 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373AbZHDQFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:05:33 -0400
Message-ID: <4A785C17.3030104@kernel.org>
Date: Tue, 04 Aug 2009 09:04:39 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: [PATCH] pci/intr_remapping: allocate irq_iommu on node
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


make it use node from irq_desc.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/intr_remapping.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/intr_remapping.c
===================================================================
--- linux-2.6.orig/drivers/pci/intr_remapping.c
+++ linux-2.6/drivers/pci/intr_remapping.c
@@ -201,7 +201,7 @@ int alloc_irte(struct intel_iommu *iommu
 	for (i = index; i < index + count; i++)
 		table->base[i].present = 1;
 
-	irq_iommu = irq_2_iommu_alloc(irq);
+	irq_iommu = irq_2_iommu_alloc_node(irq, irq_to_desc(irq)->node);
 	if (!irq_iommu) {
 		spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 		printk(KERN_ERR "can't allocate irq_2_iommu\n");
@@ -255,7 +255,7 @@ int set_irte_irq(int irq, struct intel_i
 
 	spin_lock_irqsave(&irq_2_ir_lock, flags);
 
-	irq_iommu = irq_2_iommu_alloc(irq);
+	irq_iommu = irq_2_iommu_alloc_node(irq, irq_to_desc(irq)->node);
 
 	if (!irq_iommu) {
 		spin_unlock_irqrestore(&irq_2_ir_lock, flags);
