Return-Path: <linux-kernel-owner+w=401wt.eu-S1757613AbYHGNIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbYHGNIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbYHGNHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:07:25 -0400
Received: from ie1ehsobe006.messaging.microsoft.com ([213.199.154.16]:50252
	"EHLO IE1EHSOBE003.bigfish.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752684AbYHGNHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:07:19 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K58F3H-03-RY8-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: akpm@linux-foundation.org
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/3] ia64: use common header for software IO/TLB
Date: Thu, 7 Aug 2008 15:06:49 +0200
Message-ID: <1218114409-20806-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1218114409-20806-1-git-send-email-joerg.roedel@amd.com>
References: <1218114409-20806-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Aug 2008 13:06:50.0412 (UTC) FILETIME=[74872EC0:01C8F88E]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the swiotlb prototypes from the architecture code and uses
the common header file instead.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/ia64/hp/common/hwsw_iommu.c |    9 +--------
 arch/ia64/include/asm/machvec.h  |   22 +---------------------
 2 files changed, 2 insertions(+), 29 deletions(-)

diff --git a/arch/ia64/hp/common/hwsw_iommu.c b/arch/ia64/hp/common/hwsw_iommu.c
index 88b6e6f..2769dbf 100644
--- a/arch/ia64/hp/common/hwsw_iommu.c
+++ b/arch/ia64/hp/common/hwsw_iommu.c
@@ -13,19 +13,12 @@
  */
 
 #include <linux/device.h>
+#include <linux/swiotlb.h>
 
 #include <asm/machvec.h>
 
 /* swiotlb declarations & definitions: */
 extern int swiotlb_late_init_with_default_size (size_t size);
-extern ia64_mv_dma_alloc_coherent	swiotlb_alloc_coherent;
-extern ia64_mv_dma_free_coherent	swiotlb_free_coherent;
-extern ia64_mv_dma_map_single_attrs	swiotlb_map_single_attrs;
-extern ia64_mv_dma_unmap_single_attrs	swiotlb_unmap_single_attrs;
-extern ia64_mv_dma_map_sg_attrs		swiotlb_map_sg_attrs;
-extern ia64_mv_dma_unmap_sg_attrs	swiotlb_unmap_sg_attrs;
-extern ia64_mv_dma_supported		swiotlb_dma_supported;
-extern ia64_mv_dma_mapping_error	swiotlb_dma_mapping_error;
 
 /* hwiommu declarations & definitions: */
 
diff --git a/arch/ia64/include/asm/machvec.h b/arch/ia64/include/asm/machvec.h
index 2b850cc..43af7ce 100644
--- a/arch/ia64/include/asm/machvec.h
+++ b/arch/ia64/include/asm/machvec.h
@@ -11,6 +11,7 @@
 #define _ASM_IA64_MACHVEC_H
 
 #include <linux/types.h>
+#include <linux/swiotlb.h>
 
 /* forward declarations: */
 struct device;
@@ -294,27 +295,6 @@ extern void machvec_init_from_cmdline(const char *cmdline);
 # endif /* CONFIG_IA64_GENERIC */
 
 /*
- * Declare default routines which aren't declared anywhere else:
- */
-extern ia64_mv_dma_init			swiotlb_init;
-extern ia64_mv_dma_alloc_coherent	swiotlb_alloc_coherent;
-extern ia64_mv_dma_free_coherent	swiotlb_free_coherent;
-extern ia64_mv_dma_map_single		swiotlb_map_single;
-extern ia64_mv_dma_map_single_attrs	swiotlb_map_single_attrs;
-extern ia64_mv_dma_unmap_single		swiotlb_unmap_single;
-extern ia64_mv_dma_unmap_single_attrs	swiotlb_unmap_single_attrs;
-extern ia64_mv_dma_map_sg		swiotlb_map_sg;
-extern ia64_mv_dma_map_sg_attrs		swiotlb_map_sg_attrs;
-extern ia64_mv_dma_unmap_sg		swiotlb_unmap_sg;
-extern ia64_mv_dma_unmap_sg_attrs	swiotlb_unmap_sg_attrs;
-extern ia64_mv_dma_sync_single_for_cpu	swiotlb_sync_single_for_cpu;
-extern ia64_mv_dma_sync_sg_for_cpu	swiotlb_sync_sg_for_cpu;
-extern ia64_mv_dma_sync_single_for_device swiotlb_sync_single_for_device;
-extern ia64_mv_dma_sync_sg_for_device	swiotlb_sync_sg_for_device;
-extern ia64_mv_dma_mapping_error	swiotlb_dma_mapping_error;
-extern ia64_mv_dma_supported		swiotlb_dma_supported;
-
-/*
  * Define default versions so we can extend machvec for new platforms without having
  * to update the machvec files for all existing platforms.
  */
-- 
1.5.3.7


