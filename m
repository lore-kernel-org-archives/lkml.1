Return-Path: <linux-kernel-owner+w=401wt.eu-S1767596AbXCIXxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767596AbXCIXxE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767597AbXCIXxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:53:04 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53880 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767596AbXCIXxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:53:01 -0500
Date: Fri, 9 Mar 2007 15:46:40 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] dma_ops as const
Message-ID: <20070309154640.7d01bf68@dxpl.pdx.osdl.net>
Organization: The Linux Foundation
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The dma_ops structure can be const since it never changes
after boot.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
---
 arch/x86_64/kernel/pci-calgary.c |    2 +-
 arch/x86_64/kernel/pci-gart.c    |    2 +-
 arch/x86_64/kernel/pci-nommu.c   |    2 +-
 arch/x86_64/kernel/pci-swiotlb.c |    2 +-
 arch/x86_64/mm/init.c            |    2 +-
 include/asm-x86_64/dma-mapping.h |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index 04480c3..5bd20b5 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -507,7 +507,7 @@ error:
 	return ret;
 }
 
-static struct dma_mapping_ops calgary_dma_ops = {
+static const struct dma_mapping_ops calgary_dma_ops = {
 	.alloc_coherent = calgary_alloc_coherent,
 	.map_single = calgary_map_single,
 	.unmap_single = calgary_unmap_single,
diff --git a/arch/x86_64/kernel/pci-gart.c b/arch/x86_64/kernel/pci-gart.c
index 030eb37..f7723e6 100644
--- a/arch/x86_64/kernel/pci-gart.c
+++ b/arch/x86_64/kernel/pci-gart.c
@@ -552,7 +552,7 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 
 extern int agp_amd64_init(void);
 
-static struct dma_mapping_ops gart_dma_ops = {
+static const struct dma_mapping_ops gart_dma_ops = {
 	.mapping_error = NULL,
 	.map_single = gart_map_single,
 	.map_simple = gart_map_simple,
diff --git a/arch/x86_64/kernel/pci-nommu.c b/arch/x86_64/kernel/pci-nommu.c
index df09ab0..6dade0c 100644
--- a/arch/x86_64/kernel/pci-nommu.c
+++ b/arch/x86_64/kernel/pci-nommu.c
@@ -79,7 +79,7 @@ void nommu_unmap_sg(struct device *dev, struct scatterlist *sg,
 {
 }
 
-struct dma_mapping_ops nommu_dma_ops = {
+const struct dma_mapping_ops nommu_dma_ops = {
 	.map_single = nommu_map_single,
 	.unmap_single = nommu_unmap_single,
 	.map_sg = nommu_map_sg,
diff --git a/arch/x86_64/kernel/pci-swiotlb.c b/arch/x86_64/kernel/pci-swiotlb.c
index eb18be5..4b4569a 100644
--- a/arch/x86_64/kernel/pci-swiotlb.c
+++ b/arch/x86_64/kernel/pci-swiotlb.c
@@ -12,7 +12,7 @@
 int swiotlb __read_mostly;
 EXPORT_SYMBOL(swiotlb);
 
-struct dma_mapping_ops swiotlb_dma_ops = {
+const struct dma_mapping_ops swiotlb_dma_ops = {
 	.mapping_error = swiotlb_dma_mapping_error,
 	.alloc_coherent = swiotlb_alloc_coherent,
 	.free_coherent = swiotlb_free_coherent,
diff --git a/arch/x86_64/mm/init.c b/arch/x86_64/mm/init.c
index ec31534..5ca6173 100644
--- a/arch/x86_64/mm/init.c
+++ b/arch/x86_64/mm/init.c
@@ -46,7 +46,7 @@
 #define Dprintk(x...)
 #endif
 
-struct dma_mapping_ops* dma_ops;
+const struct dma_mapping_ops* dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 static unsigned long dma_reserve __initdata;
diff --git a/include/asm-x86_64/dma-mapping.h b/include/asm-x86_64/dma-mapping.h
index d2af227..6897e2a 100644
--- a/include/asm-x86_64/dma-mapping.h
+++ b/include/asm-x86_64/dma-mapping.h
@@ -52,7 +52,7 @@ struct dma_mapping_ops {
 };
 
 extern dma_addr_t bad_dma_address;
-extern struct dma_mapping_ops* dma_ops;
+extern const struct dma_mapping_ops* dma_ops;
 extern int iommu_merge;
 
 static inline int dma_mapping_error(dma_addr_t dma_addr)
-- 
1.5.0.2

