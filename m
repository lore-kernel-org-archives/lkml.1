Return-Path: <linux-kernel-owner+w=401wt.eu-S1751902Ab0AYHBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab0AYHBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 02:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697Ab0AYHBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 02:01:21 -0500
Received: from sh.osrg.net ([192.16.179.4]:51741 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab0AYHBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 02:01:20 -0500
Date: Mon, 25 Jan 2010 16:01:02 +0900
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] frv: remove pci_dma_sync_signle and pci_dma_sync_sg
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100125155943G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 25 Jan 2010 16:01:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No architecture except for frv has pci_dma_sync_signle() and
pci_dma_sync_sg(). The APIs are deprecated.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/frv/include/asm/pci.h |   37 -------------------------------------
 1 files changed, 0 insertions(+), 37 deletions(-)

diff --git a/arch/frv/include/asm/pci.h b/arch/frv/include/asm/pci.h
index 492b5c4..8c7260a 100644
--- a/arch/frv/include/asm/pci.h
+++ b/arch/frv/include/asm/pci.h
@@ -68,41 +68,4 @@ static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 #define PCIBIOS_MIN_IO		0x100
 #define PCIBIOS_MIN_MEM		0x00010000
 
-/* Make physical memory consistent for a single
- * streaming mode DMA translation after a transfer.
- *
- * If you perform a pci_map_single() but wish to interrogate the
- * buffer using the cpu, yet do not wish to teardown the PCI dma
- * mapping, you must call this function before doing so.  At the
- * next point you give the PCI dma address back to the card, the
- * device again owns the buffer.
- */
-static inline void pci_dma_sync_single(struct pci_dev *hwdev,
-				       dma_addr_t dma_handle,
-				       size_t size, int direction)
-{
-	BUG_ON(direction == PCI_DMA_NONE);
-
-	frv_cache_wback_inv((unsigned long)bus_to_virt(dma_handle),
-			    (unsigned long)bus_to_virt(dma_handle) + size);
-}
-
-/* Make physical memory consistent for a set of streaming
- * mode DMA translations after a transfer.
- *
- * The same as pci_dma_sync_single but for a scatter-gather list,
- * same rules and usage.
- */
-static inline void pci_dma_sync_sg(struct pci_dev *hwdev,
-				   struct scatterlist *sg,
-				   int nelems, int direction)
-{
-	int i;
-	BUG_ON(direction == PCI_DMA_NONE);
-
-	for (i = 0; i < nelems; i++)
-		frv_cache_wback_inv(sg_dma_address(&sg[i]),
-				    sg_dma_address(&sg[i])+sg_dma_len(&sg[i]));
-}
-
 #endif /* _ASM_FRV_PCI_H */
-- 
1.5.6.5

