Return-Path: <linux-kernel-owner+w=401wt.eu-S1752026AbZHHPWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbZHHPWb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 11:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbZHHPWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 11:22:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:49952 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbZHHPW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 11:22:29 -0400
Date: Sat, 8 Aug 2009 15:22:00 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, jbarnes@virtuousgeek.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, jbarnes@virtuousgeek.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A785C17.3030104@kernel.org>
References: <4A785C17.3030104@kernel.org>
Subject: [tip:irq/core] pci/intr_remapping: Allocate irq_iommu on node
Message-ID: <tip-94fb9a6b49d3a63831c4e752f6f0ab8da0a99eb5@git.kernel.org>
Git-Commit-ID: 94fb9a6b49d3a63831c4e752f6f0ab8da0a99eb5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 08 Aug 2009 15:22:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  94fb9a6b49d3a63831c4e752f6f0ab8da0a99eb5
Gitweb:     http://git.kernel.org/tip/94fb9a6b49d3a63831c4e752f6f0ab8da0a99eb5
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 4 Aug 2009 09:04:39 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 8 Aug 2009 17:07:37 +0200

pci/intr_remapping: Allocate irq_iommu on node

Make it use node from irq_desc - this results in more
optimal memory layout.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <4A785C17.3030104@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 drivers/pci/intr_remapping.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 4f5b871..e27a28c 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -201,7 +201,7 @@ int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 	for (i = index; i < index + count; i++)
 		table->base[i].present = 1;
 
-	irq_iommu = irq_2_iommu_alloc(irq);
+	irq_iommu = irq_2_iommu_alloc_node(irq, irq_to_desc(irq)->node);
 	if (!irq_iommu) {
 		spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 		printk(KERN_ERR "can't allocate irq_2_iommu\n");
@@ -255,7 +255,7 @@ int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 
 	spin_lock_irqsave(&irq_2_ir_lock, flags);
 
-	irq_iommu = irq_2_iommu_alloc(irq);
+	irq_iommu = irq_2_iommu_alloc_node(irq, irq_to_desc(irq)->node);
 
 	if (!irq_iommu) {
 		spin_unlock_irqrestore(&irq_2_ir_lock, flags);
