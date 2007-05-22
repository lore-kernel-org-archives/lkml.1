Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbXEVIHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbXEVIHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756952AbXEVIGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:06:18 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:10693 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930AbXEVIGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:06:12 -0400
From: muli@il.ibm.com
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org, discuss@x86-64.org, jdmason@kudzu.us,
       michaelv@il.ibm.com, guillaume.thouvenin@ext.bull.net, muli@il.ibm.com
Subject: [PATCH 10/15] x86-64: Calgary - grab PLSSR too when a DMA error occurs
Date: Tue, 22 May 2007 04:05:59 -0400
Message-Id: <1179821167443-git-send-email-muli@il.ibm.com>
X-Mailer: git-send-email 1.4.4
In-Reply-To: <11798211672822-git-send-email-muli@il.ibm.com>
References: <11798211643534-git-send-email-muli@il.ibm.com> <11798211643659-git-send-email-muli@il.ibm.com> <11798211643144-git-send-email-muli@il.ibm.com> <11798211663773-git-send-email-muli@il.ibm.com> <1179821166685-git-send-email-muli@il.ibm.com> <11798211661041-git-send-email-muli@il.ibm.com> <11798211672108-git-send-email-muli@il.ibm.com> <1179821167481-git-send-email-muli@il.ibm.com> <11798211673003-git-send-email-muli@il.ibm.com> <11798211672822-git-send-email-muli@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Muli Ben-Yehuda <muli@il.ibm.com>

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 arch/x86_64/kernel/pci-calgary.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index 57ac81b..a49b19d 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -902,15 +902,18 @@ static void __init calgary_free_bus(stru
 static void calgary_dump_error_regs(struct iommu_table *tbl)
 {
 	void __iomem *bbar = tbl->bbar;
-	u32 val32;
 	void __iomem *target;
+	u32 csr, plssr;
 	
 	target = calgary_reg(bbar, phb_offset(tbl->it_busno) | PHB_CSR_OFFSET);
-	val32 = be32_to_cpu(readl(target));
+	csr = be32_to_cpu(readl(target));
+
+	target = calgary_reg(bbar, phb_offset(tbl->it_busno) | PHB_PLSSR_OFFSET);
+	plssr = be32_to_cpu(readl(target));
 
 	/* If no error, the agent ID in the CSR is not valid */
 	printk(KERN_EMERG "Calgary: DMA error on Calgary PHB 0x%x, "
-	       "CSR = 0x%08x\n", tbl->it_busno, val32);
+	       "0x%08x@CSR 0x%08x@PLSSR\n", tbl->it_busno, csr, plssr);
 }
 
 static void calioc2_dump_error_regs(struct iommu_table *tbl)
-- 
1.4.4

