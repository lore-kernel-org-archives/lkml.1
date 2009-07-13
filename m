Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbZGMGaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbZGMGaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 02:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753766AbZGMG3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 02:29:39 -0400
Received: from sh.osrg.net ([192.16.179.4]:60451 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbZGMG2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 02:28:51 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       reif@earthlink.net, x86@kernel.org, tony.luck@intel.com,
       fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org
Subject: [PATCH 5/8] sparc: remove no-op dma_4v_sync_single_for_cpu and dma_4v_sync_sg_for_cpu
Date: Mon, 13 Jul 2009 15:25:57 +0900
Message-Id: <1247466360-13330-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1247466360-13330-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1247466360-13330-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 13 Jul 2009 15:27:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now sparc uses include/asm-generic/dma-mapping-common.h. pci_sun4v.c
doesn't need to have no-op dma_4v_sync_single_for_cpu and
dma_4v_sync_sg_for_cpu (dma-mapping-common.h does nothing if
sync_{single|sg}_for_cpu hook is not defined). So we can remove them
safely.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: Robert Reif <reif@earthlink.net>
---
 arch/sparc/kernel/pci_sun4v.c |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/arch/sparc/kernel/pci_sun4v.c b/arch/sparc/kernel/pci_sun4v.c
index ee800f9..23c33ff 100644
--- a/arch/sparc/kernel/pci_sun4v.c
+++ b/arch/sparc/kernel/pci_sun4v.c
@@ -525,20 +525,6 @@ static void dma_4v_unmap_sg(struct device *dev, struct scatterlist *sglist,
 	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
-static void dma_4v_sync_single_for_cpu(struct device *dev,
-				       dma_addr_t bus_addr, size_t sz,
-				       enum dma_data_direction direction)
-{
-	/* Nothing to do... */
-}
-
-static void dma_4v_sync_sg_for_cpu(struct device *dev,
-				   struct scatterlist *sglist, int nelems,
-				   enum dma_data_direction direction)
-{
-	/* Nothing to do... */
-}
-
 static struct dma_map_ops sun4v_dma_ops = {
 	.alloc_coherent			= dma_4v_alloc_coherent,
 	.free_coherent			= dma_4v_free_coherent,
@@ -546,8 +532,6 @@ static struct dma_map_ops sun4v_dma_ops = {
 	.unmap_page			= dma_4v_unmap_page,
 	.map_sg				= dma_4v_map_sg,
 	.unmap_sg			= dma_4v_unmap_sg,
-	.sync_single_for_cpu		= dma_4v_sync_single_for_cpu,
-	.sync_sg_for_cpu		= dma_4v_sync_sg_for_cpu,
 };
 
 static void __devinit pci_sun4v_scan_bus(struct pci_pbm_info *pbm,
-- 
1.6.0.6

