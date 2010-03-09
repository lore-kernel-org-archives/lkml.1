Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab0CIWNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 17:13:16 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:19197 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab0CIWMa (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 9 Mar 2010 17:12:30 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       joerg.roedel@amd.com, chrisw@sous-sol.org, alex.williamson@hp.com,
       dwmw2@infradead.org
Cc: Konrad Rzeszutek <konrad@t42p-lan.dumpdata.com>,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/4] swiotlb: Fix checkpatch warnings.
Date: Tue,  9 Mar 2010 16:54:22 -0500
Message-Id: <1268171662-12701-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1268171662-12701-4-git-send-email-konrad.wilk@oracle.com>
References: <1268171662-12701-1-git-send-email-konrad.wilk@oracle.com>
 <1268171662-12701-2-git-send-email-konrad.wilk@oracle.com>
 <1268171662-12701-3-git-send-email-konrad.wilk@oracle.com>
 <1268171662-12701-4-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B96C7A4.0217:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek <konrad@t42p-lan.dumpdata.com>

I've fixed most of the checkpatch warnings except these three:

a). WARNING: consider using strict_strtoul in preference to simple_strtoul
115: FILE: swiotlb.c:115:
+                               val = simple_strtoul(str, endp, 0);

b). WARNING: consider using strict_strtoul in preference to simple_strtoul
126: FILE: swiotlb.c:126:
+                       io_tlb_nslabs = simple_strtoul(str, &str, 0);

c).WARNING: Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt
151: FILE: swiotlb.c:151:
+                                     volatile void *address)

total: 0 errors, 3 warnings, 965 lines checked

As a) and b) are OK, we MUST use simple_strtoul. For c) the 'volatile-consider*'
document outlines that it is OK for pointers to data structrues in coherent memory
which this certainly could be, hence not fixing that.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb.c |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 655883b..e63895f 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -29,16 +29,15 @@
 #include <linux/ctype.h>
 #include <linux/highmem.h>
 
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/dma.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 
 #include <linux/init.h>
 #include <linux/bootmem.h>
 #include <linux/iommu-helper.h>
 
-#define OFFSET(val,align) ((unsigned long)	\
-	                   ( (val) & ( (align) - 1)))
+#define OFFSET(val, align) ((unsigned long)	((val) & ((align) - 1)))
 
 #define SLABS_PER_PAGE (1 << (PAGE_SHIFT - IO_TLB_SHIFT))
 
@@ -172,7 +171,7 @@ swiotlb_init_early(size_t default_size, int verbose)
 	 */
 	io_tlb_list = alloc_bootmem(io_tlb_nslabs * sizeof(int));
 	for (i = 0; i < io_tlb_nslabs; i++)
- 		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
+		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
 	io_tlb_index = 0;
 	io_tlb_orig_addr = alloc_bootmem(io_tlb_nslabs * sizeof(phys_addr_t));
 
@@ -241,18 +240,16 @@ swiotlb_init_late(size_t default_size)
 	 * between io_tlb_start and io_tlb_end.
 	 */
 	io_tlb_list = (unsigned int *)__get_free_pages(GFP_KERNEL,
-	                              get_order(io_tlb_nslabs * sizeof(int)));
+					get_order(io_tlb_nslabs * sizeof(int)));
 	if (!io_tlb_list)
 		goto cleanup2;
 
 	for (i = 0; i < io_tlb_nslabs; i++)
- 		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
+		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
 	io_tlb_index = 0;
 
-	io_tlb_orig_addr = (phys_addr_t *)
-		__get_free_pages(GFP_KERNEL,
-				 get_order(io_tlb_nslabs *
-					   sizeof(phys_addr_t)));
+	io_tlb_orig_addr = (phys_addr_t *) __get_free_pages(GFP_KERNEL,
+				get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
 	if (!io_tlb_orig_addr)
 		goto cleanup3;
 
@@ -262,7 +259,7 @@ swiotlb_init_late(size_t default_size)
 	 * Get the overflow emergency buffer
 	 */
 	io_tlb_overflow_buffer = (void *)__get_free_pages(GFP_DMA,
-	                                          get_order(io_tlb_overflow));
+					 get_order(io_tlb_overflow));
 	if (!io_tlb_overflow_buffer)
 		goto cleanup4;
 
@@ -277,8 +274,8 @@ cleanup4:
 		   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
 	io_tlb_orig_addr = NULL;
 cleanup3:
-	free_pages((unsigned long)io_tlb_list, get_order(io_tlb_nslabs *
-	                                                 sizeof(int)));
+	free_pages((unsigned long)io_tlb_list,
+		   get_order(io_tlb_nslabs * sizeof(int)));
 	io_tlb_list = NULL;
 cleanup2:
 	io_tlb_end = NULL;
@@ -383,8 +380,8 @@ map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
 	offset_slots = ALIGN(start_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
 
 	/*
- 	 * Carefully handle integer overflow which can occur when mask == ~0UL.
- 	 */
+	 * Carefully handle integer overflow which can occur when mask == ~0UL.
+	 */
 	max_slots = mask + 1
 		    ? ALIGN(mask + 1, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT
 		    : 1UL << (BITS_PER_LONG - IO_TLB_SHIFT);
@@ -431,7 +428,8 @@ map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
 
 			for (i = index; i < (int) (index + nslots); i++)
 				io_tlb_list[i] = 0;
-			for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE) != IO_TLB_SEGSIZE - 1) && io_tlb_list[i]; i--)
+			for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE)
+				!= IO_TLB_SEGSIZE - 1) && io_tlb_list[i]; i--)
 				io_tlb_list[i] = ++count;
 			dma_addr = io_tlb_start + (index << IO_TLB_SHIFT);
 
@@ -505,7 +503,8 @@ do_unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
 		 * Step 2: merge the returned slots with the preceding slots,
 		 * if available (non zero)
 		 */
-		for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE) != IO_TLB_SEGSIZE -1) && io_tlb_list[i]; i--)
+		for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE) !=
+				IO_TLB_SEGSIZE - 1) && io_tlb_list[i]; i--)
 			io_tlb_list[i] = ++count;
 	}
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
@@ -853,7 +852,8 @@ EXPORT_SYMBOL(swiotlb_map_sg);
  */
 void
 swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
-		       int nelems, enum dma_data_direction dir, struct dma_attrs *attrs)
+		       int nelems, enum dma_data_direction dir,
+		       struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
 	int i;
-- 
1.6.2.5

