Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbYIHJba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbYIHJba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 05:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbYIHJbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 05:31:13 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:50568 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbYIHJbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 05:31:12 -0400
Date: Mon, 8 Sep 2008 18:31:05 +0900
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: tony.luck@intel.com
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: [PATCH] ia64: remove duplicated swiotbl externs
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080908183053D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can safely remove the following duplication?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ia64: remove duplicated swiotbl externs

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/ia64/hp/common/hwsw_iommu.c |   11 -----------
 arch/ia64/hp/common/sba_iommu.c  |    2 --
 arch/ia64/include/asm/machvec.h  |    5 ++---
 3 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/arch/ia64/hp/common/hwsw_iommu.c b/arch/ia64/hp/common/hwsw_iommu.c
index 88b6e6f..a309bb3 100644
--- a/arch/ia64/hp/common/hwsw_iommu.c
+++ b/arch/ia64/hp/common/hwsw_iommu.c
@@ -16,17 +16,6 @@
 
 #include <asm/machvec.h>
 
-/* swiotlb declarations & definitions: */
-extern int swiotlb_late_init_with_default_size (size_t size);
-extern ia64_mv_dma_alloc_coherent	swiotlb_alloc_coherent;
-extern ia64_mv_dma_free_coherent	swiotlb_free_coherent;
-extern ia64_mv_dma_map_single_attrs	swiotlb_map_single_attrs;
-extern ia64_mv_dma_unmap_single_attrs	swiotlb_unmap_single_attrs;
-extern ia64_mv_dma_map_sg_attrs		swiotlb_map_sg_attrs;
-extern ia64_mv_dma_unmap_sg_attrs	swiotlb_unmap_sg_attrs;
-extern ia64_mv_dma_supported		swiotlb_dma_supported;
-extern ia64_mv_dma_mapping_error	swiotlb_dma_mapping_error;
-
 /* hwiommu declarations & definitions: */
 
 extern ia64_mv_dma_alloc_coherent	sba_alloc_coherent;
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 4956be4..8b69363 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -45,8 +45,6 @@
 
 #include <asm/acpi-ext.h>
 
-extern int swiotlb_late_init_with_default_size (size_t size);
-
 #define PFX "IOC: "
 
 /*
diff --git a/arch/ia64/include/asm/machvec.h b/arch/ia64/include/asm/machvec.h
index 2b850cc..4cd6064 100644
--- a/arch/ia64/include/asm/machvec.h
+++ b/arch/ia64/include/asm/machvec.h
@@ -293,9 +293,8 @@ extern void machvec_init_from_cmdline(const char *cmdline);
 #  error Unknown configuration.  Update arch/ia64/include/asm/machvec.h.
 # endif /* CONFIG_IA64_GENERIC */
 
-/*
- * Declare default routines which aren't declared anywhere else:
- */
+/* swiotlb declarations & definitions: */
+extern int swiotlb_late_init_with_default_size (size_t size);
 extern ia64_mv_dma_init			swiotlb_init;
 extern ia64_mv_dma_alloc_coherent	swiotlb_alloc_coherent;
 extern ia64_mv_dma_free_coherent	swiotlb_free_coherent;
-- 
1.5.4.2

