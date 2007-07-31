Return-Path: <linux-kernel-owner+w=401wt.eu-S1763677AbXGaNPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763677AbXGaNPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763268AbXGaNOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:14:08 -0400
Received: from host86-137-100-191.range86-137.btcentralplus.com ([86.137.100.191]:42790
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762694AbXGaNOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:14:06 -0400
From: jack@hawkeye.stone.uk.eu.org
Message-Id: <20070731125438.662563000@hawkeye.stone.uk.eu.org>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
User-Agent: quilt/0.46-1
Date: Tue, 31 Jul 2007 13:53:18 +0100
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [Patch 02/16] Remove unnecessary kmalloc casts from the mips arch.
Content-Disposition: inline; filename=arch_mips_remove_kmalloc_casts.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>

CC: Ralf Baechle <ralf@linux-mips.org>

---
 arch/mips/au1000/common/dbdma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/arch/mips/au1000/common/dbdma.c
===================================================================
--- a/arch/mips/au1000/common/dbdma.c
+++ b/arch/mips/au1000/common/dbdma.c
@@ -396,7 +396,7 @@ au1xxx_dbdma_ring_alloc(u32 chanid, int 
 	 * and if we try that first we are likely to not waste larger
 	 * slabs of memory.
 	 */
-	desc_base = (u32)kmalloc(entries * sizeof(au1x_ddma_desc_t),
+	desc_base = kmalloc(entries * sizeof(au1x_ddma_desc_t),
 			GFP_KERNEL|GFP_DMA);
 	if (desc_base == 0)
 		return 0;
@@ -408,7 +408,7 @@ au1xxx_dbdma_ring_alloc(u32 chanid, int 
 		kfree((const void *)desc_base);
 		i = entries * sizeof(au1x_ddma_desc_t);
 		i += (sizeof(au1x_ddma_desc_t) - 1);
-		if ((desc_base = (u32)kmalloc(i, GFP_KERNEL|GFP_DMA)) == 0)
+		if ((desc_base = kmalloc(i, GFP_KERNEL|GFP_DMA)) == 0)
 			return 0;
 
 		desc_base = ALIGN_ADDR(desc_base, sizeof(au1x_ddma_desc_t));

-- 
