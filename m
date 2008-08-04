Return-Path: <linux-kernel-owner+w=401wt.eu-S1758728AbYHDQIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbYHDQIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756993AbYHDQFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:05:21 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:4622 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820AbYHDQFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:05:19 -0400
X-BigFish: VPS5(zz19c2kzz10d3izzz32i62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 7,
X-WSS-ID: 0K533C2-04-0UF-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, rth@twiddle.net,
       paulus@samba.org, benh@kernel.crashing.org, davem@davemloft.net,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Muli Ben-Yehuda <muli@il.ibm.com>, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/10] powerpc: rename iommu_num_pages function to iommu_nr_pages
Date: Mon, 4 Aug 2008 18:04:43 +0200
Message-ID: <1217865890-3593-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
References: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Aug 2008 16:04:51.0521 (UTC) FILETIME=[D3B9D310:01C8F64B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation patch for introducing a generic iommu_num_pages function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/powerpc/kernel/iommu.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 550a193..e2cf632 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -51,7 +51,7 @@ static int protect4gb = 1;
 
 static void __iommu_free(struct iommu_table *, dma_addr_t, unsigned int);
 
-static inline unsigned long iommu_num_pages(unsigned long vaddr,
+static inline unsigned long iommu_nr_pages(unsigned long vaddr,
 					    unsigned long slen)
 {
 	unsigned long npages;
@@ -325,7 +325,7 @@ int iommu_map_sg(struct device *dev, struct iommu_table *tbl,
 		}
 		/* Allocate iommu entries for that segment */
 		vaddr = (unsigned long) sg_virt(s);
-		npages = iommu_num_pages(vaddr, slen);
+		npages = iommu_nr_pages(vaddr, slen);
 		align = 0;
 		if (IOMMU_PAGE_SHIFT < PAGE_SHIFT && slen >= PAGE_SIZE &&
 		    (vaddr & ~PAGE_MASK) == 0)
@@ -418,7 +418,7 @@ int iommu_map_sg(struct device *dev, struct iommu_table *tbl,
 			unsigned long vaddr, npages;
 
 			vaddr = s->dma_address & IOMMU_PAGE_MASK;
-			npages = iommu_num_pages(s->dma_address, s->dma_length);
+			npages = iommu_nr_pages(s->dma_address, s->dma_length);
 			__iommu_free(tbl, vaddr, npages);
 			s->dma_address = DMA_ERROR_CODE;
 			s->dma_length = 0;
@@ -452,7 +452,7 @@ void iommu_unmap_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 
 		if (sg->dma_length == 0)
 			break;
-		npages = iommu_num_pages(dma_handle, sg->dma_length);
+		npages = iommu_nr_pages(dma_handle, sg->dma_length);
 		__iommu_free(tbl, dma_handle, npages);
 		sg = sg_next(sg);
 	}
@@ -584,7 +584,7 @@ dma_addr_t iommu_map_single(struct device *dev, struct iommu_table *tbl,
 	BUG_ON(direction == DMA_NONE);
 
 	uaddr = (unsigned long)vaddr;
-	npages = iommu_num_pages(uaddr, size);
+	npages = iommu_nr_pages(uaddr, size);
 
 	if (tbl) {
 		align = 0;
@@ -617,7 +617,7 @@ void iommu_unmap_single(struct iommu_table *tbl, dma_addr_t dma_handle,
 	BUG_ON(direction == DMA_NONE);
 
 	if (tbl) {
-		npages = iommu_num_pages(dma_handle, size);
+		npages = iommu_nr_pages(dma_handle, size);
 		iommu_free(tbl, dma_handle, npages);
 	}
 }
-- 
1.5.3.7


