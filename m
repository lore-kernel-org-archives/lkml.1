Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbYHGNIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbYHGNIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755082AbYHGNHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:07:35 -0400
Received: from ie1ehsobe006.messaging.microsoft.com ([213.199.154.16]:50252
	"EHLO IE1EHSOBE003.bigfish.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755993AbYHGNHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:07:18 -0400
X-BigFish: VPS19(z1039oe80izzz10d3izzz32i43j68o)
X-Spam-TCS-SCL: 7:0
X-WSS-ID: 0K58F3D-04-DHM-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: akpm@linux-foundation.org
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/3] introduce generic header file for the software IO/TLB
Date: Thu, 7 Aug 2008 15:06:47 +0200
Message-ID: <1218114409-20806-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1218114409-20806-1-git-send-email-joerg.roedel@amd.com>
References: <1218114409-20806-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Aug 2008 13:06:50.0383 (UTC) FILETIME=[7482C1F0:01C8F88E]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch created the include/linux/swiotlb.h file which contains all function
prototypes for the lib/swiotlb.c file.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/swiotlb.h |   83 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 83 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/swiotlb.h

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
new file mode 100644
index 0000000..b18ec55
--- /dev/null
+++ b/include/linux/swiotlb.h
@@ -0,0 +1,83 @@
+#ifndef __LINUX_SWIOTLB_H
+#define __LINUX_SWIOTLB_H
+
+#include <linux/types.h>
+
+struct device;
+struct dma_attrs;
+struct scatterlist;
+
+extern void
+swiotlb_init(void);
+
+extern void
+*swiotlb_alloc_coherent(struct device *hwdev, size_t size,
+			dma_addr_t *dma_handle, gfp_t flags);
+
+extern void
+swiotlb_free_coherent(struct device *hwdev, size_t size,
+		      void *vaddr, dma_addr_t dma_handle);
+
+extern dma_addr_t
+swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, int dir);
+
+extern void
+swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
+		     size_t size, int dir);
+
+extern dma_addr_t
+swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
+			 int dir, struct dma_attrs *attrs);
+
+extern void
+swiotlb_unmap_single_attrs(struct device *hwdev, dma_addr_t dev_addr,
+			   size_t size, int dir, struct dma_attrs *attrs);
+
+extern int
+swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg, int nents,
+	       int direction);
+
+extern void
+swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
+		 int direction);
+
+extern int
+swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
+		     int dir, struct dma_attrs *attrs);
+
+extern void
+swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
+		       int nelems, int dir, struct dma_attrs *attrs);
+
+extern void
+swiotlb_sync_single_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
+			    size_t size, int dir);
+
+extern void
+swiotlb_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
+			int nelems, int dir);
+
+extern void
+swiotlb_sync_single_for_device(struct device *hwdev, dma_addr_t dev_addr,
+			       size_t size, int dir);
+
+extern void
+swiotlb_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
+			   int nelems, int dir);
+
+extern void
+swiotlb_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
+				  unsigned long offset, size_t size, int dir);
+
+extern void
+swiotlb_sync_single_range_for_device(struct device *hwdev, dma_addr_t dev_addr,
+				     unsigned long offset, size_t size,
+				     int dir);
+
+extern int
+swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
+
+extern int
+swiotlb_dma_supported(struct device *hwdev, u64 mask);
+
+#endif /* __LINUX_SWIOTLB_H */
-- 
1.5.3.7


