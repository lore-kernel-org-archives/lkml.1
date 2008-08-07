Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbYHGNH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbYHGNH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948AbYHGNHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:07:16 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:64258 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbYHGNHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:07:13 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0K58F3E-04-DHO-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: akpm@linux-foundation.org
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/3] x86: use common header for software IO/TLB
Date: Thu, 7 Aug 2008 15:06:48 +0200
Message-ID: <1218114409-20806-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1218114409-20806-1-git-send-email-joerg.roedel@amd.com>
References: <1218114409-20806-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Aug 2008 13:06:50.0397 (UTC) FILETIME=[7484E4D0:01C8F88E]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the swiotlb prototypes from the architecture code and uses
the common header file instead.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/asm-x86/swiotlb.h |   40 +---------------------------------------
 1 files changed, 1 insertions(+), 39 deletions(-)

diff --git a/include/asm-x86/swiotlb.h b/include/asm-x86/swiotlb.h
index 2730b35..b3221aa 100644
--- a/include/asm-x86/swiotlb.h
+++ b/include/asm-x86/swiotlb.h
@@ -1,45 +1,7 @@
 #ifndef _ASM_SWIOTLB_H
 #define _ASM_SWIOTLB_H 1
 
-#include <asm/dma-mapping.h>
-
-/* SWIOTLB interface */
-
-extern dma_addr_t swiotlb_map_single(struct device *hwdev, void *ptr,
-				     size_t size, int dir);
-extern void *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
-				    dma_addr_t *dma_handle, gfp_t flags);
-extern void swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
-				 size_t size, int dir);
-extern void swiotlb_sync_single_for_cpu(struct device *hwdev,
-					dma_addr_t dev_addr,
-					size_t size, int dir);
-extern void swiotlb_sync_single_for_device(struct device *hwdev,
-					   dma_addr_t dev_addr,
-					   size_t size, int dir);
-extern void swiotlb_sync_single_range_for_cpu(struct device *hwdev,
-					      dma_addr_t dev_addr,
-					      unsigned long offset,
-					      size_t size, int dir);
-extern void swiotlb_sync_single_range_for_device(struct device *hwdev,
-						 dma_addr_t dev_addr,
-						 unsigned long offset,
-						 size_t size, int dir);
-extern void swiotlb_sync_sg_for_cpu(struct device *hwdev,
-				    struct scatterlist *sg, int nelems,
-				    int dir);
-extern void swiotlb_sync_sg_for_device(struct device *hwdev,
-				       struct scatterlist *sg, int nelems,
-				       int dir);
-extern int swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg,
-			  int nents, int direction);
-extern void swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg,
-			     int nents, int direction);
-extern int swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
-extern void swiotlb_free_coherent(struct device *hwdev, size_t size,
-				  void *vaddr, dma_addr_t dma_handle);
-extern int swiotlb_dma_supported(struct device *hwdev, u64 mask);
-extern void swiotlb_init(void);
+#include <linux/swiotlb.h>
 
 extern int swiotlb_force;
 
-- 
1.5.3.7


