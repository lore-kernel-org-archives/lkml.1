Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641Ab0BRQwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:52:46 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:17272 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758595Ab0BRQwp (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 18 Feb 2010 11:52:45 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       chrisw@sous-sol.org, iommu@lists.linux-foundation.org,
       dwmw2@infradead.org, alex.williamson@hp.com
Cc: jeremy@goop.org, Ian.Campbell@eu.citrix.com,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 10/10] swiotlb: EXPORT_SYMBOL_GPL functions + variables that are defined in the header file.
Date: Thu, 18 Feb 2010 11:27:06 -0500
Message-Id: <1266510426-6815-11-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266510426-6815-10-git-send-email-konrad.wilk@oracle.com>
References: <1266510426-6815-1-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-2-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-3-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-4-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-5-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-6-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-7-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-8-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-9-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-10-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B7D6E53.00FA:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the functions and variables that are now declared in the swiotlb.h
header file visible by the linker.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 674d025..ddf4a2d 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -56,19 +56,24 @@ int swiotlb_force;
  * API.
  */
 char *io_tlb_start, *io_tlb_end;
+EXPORT_SYMBOL_GPL(io_tlb_start);
+EXPORT_SYMBOL_GPL(io_tlb_end);
 
 /*
  * The number of IO TLB blocks (in groups of 64) betweeen io_tlb_start and
  * io_tlb_end.  This is command line adjustable via setup_io_tlb_npages.
  */
 unsigned long io_tlb_nslabs;
+EXPORT_SYMBOL_GPL(io_tlb_nslabs);
 
 /*
  * When the IOMMU overflows we return a fallback buffer. This sets the size.
  */
 unsigned long io_tlb_overflow = 32*1024;
+EXPORT_SYMBOL_GPL(io_tlb_overflow);
 
 void *io_tlb_overflow_buffer;
+EXPORT_SYMBOL_GPL(io_tlb_overflow_buffer);
 
 /*
  * This is a free list describing the number of free entries available from
@@ -204,6 +209,7 @@ swiotlb_init_early(size_t default_size, int verbose)
 	if (verbose)
 		swiotlb_print_info();
 }
+EXPORT_SYMBOL_GPL(swiotlb_init_early);
 
 void __init
 swiotlb_init(int verbose)
@@ -337,6 +343,7 @@ int is_swiotlb_buffer(phys_addr_t paddr)
 	return paddr >= virt_to_phys(io_tlb_start) &&
 		paddr < virt_to_phys(io_tlb_end);
 }
+EXPORT_SYMBOL_GPL(is_swiotlb_buffer);
 
 /*
  * Bounce: copy the swiotlb buffer back to the original dma location
@@ -378,6 +385,7 @@ void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 			memcpy(phys_to_virt(phys), dma_addr, size);
 	}
 }
+EXPORT_SYMBOL_GPL(swiotlb_bounce);
 
 /*
  * Allocates bounce buffer and returns its kernel virtual address.
@@ -484,6 +492,7 @@ found:
 
 	return dma_addr;
 }
+EXPORT_SYMBOL_GPL(do_map_single);
 
 /*
  * dma_addr is the kernel virtual address of the bounce buffer to unmap.
@@ -528,6 +537,7 @@ do_unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
 	}
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
 }
+EXPORT_SYMBOL_GPL(do_unmap_single);
 
 void
 do_sync_single(struct device *hwdev, char *dma_addr, size_t size,
@@ -555,6 +565,7 @@ do_sync_single(struct device *hwdev, char *dma_addr, size_t size,
 		BUG();
 	}
 }
+EXPORT_SYMBOL_GPL(do_sync_single);
 
 void *
 swiotlb_alloc_coherent(struct device *hwdev, size_t size,
@@ -646,6 +657,7 @@ swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
 	if (dir == DMA_TO_DEVICE)
 		panic("DMA: Random memory could be DMA read\n");
 }
+EXPORT_SYMBOL_GPL(swiotlb_full);
 
 /*
  * Map a single buffer of the indicated size for DMA in streaming mode.  The
-- 
1.6.2.5

