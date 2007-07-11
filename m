Return-Path: <linux-kernel-owner+w=401wt.eu-S1764798AbXGKNgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764798AbXGKNgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 09:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760528AbXGKNfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 09:35:22 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:48227 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762731AbXGKNfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 09:35:18 -0400
From: muli@il.ibm.com
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org, muli@il.ibm.com, jdmason@kudzu.us
Subject: [PATCH 1/4] x86-64: Calgary - fix few style problems pointed out by checkpatch.pl
Date: Wed, 11 Jul 2007 16:35:11 +0300
Message-Id: <11841609141802-git-send-email-muli@il.ibm.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11841609143732-git-send-email-muli@il.ibm.com>
References: <11841609143732-git-send-email-muli@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Muli Ben-Yehuda <muli@il.ibm.com>

No actual code was harmed in the production of this patch.

Thanks to Andrew Morton <akpm@linux-foundation.org> for telling me
about checkpatch.pl.

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 arch/x86_64/kernel/pci-calgary.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index aef4cfc..f589c2d 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -377,7 +377,9 @@ static inline struct iommu_table *find_iommu_table(struct device *dev)
 		pbus = pdev->bus;
 
 	tbl = pbus->self->sysdata;
-	BUG_ON(pdev->bus->parent && (tbl->it_busno != pdev->bus->parent->number));
+
+	BUG_ON(pdev->bus->parent &&
+	       (tbl->it_busno != pdev->bus->parent->number));
 
 	return tbl;
 }
@@ -943,7 +945,8 @@ static void calioc2_dump_error_regs(struct iommu_table *tbl)
 	/* dump rest of error regs */
 	printk(KERN_EMERG "Calgary: ");
 	for (i = 0; i < ARRAY_SIZE(errregs); i++) {
-		erroff = (0x810 + (i * 0x10)); /* err regs are at 0x810 - 0x870 */
+		/* err regs are at 0x810 - 0x870 */
+		erroff = (0x810 + (i * 0x10));
 		target = calgary_reg(bbar, phboff | erroff);
 		errregs[i] = be32_to_cpu(readl(target));
 		printk("0x%08x@0x%lx ", errregs[i], erroff);
@@ -1209,7 +1212,7 @@ static int __init calgary_init(void)
 {
 	int ret;
 	struct pci_dev *dev = NULL;
-	void* tce_space;
+	void *tce_space;
 
 	ret = calgary_locate_bbars();
 	if (ret)
-- 
1.5.2

