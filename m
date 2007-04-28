Return-Path: <linux-kernel-owner+w=401wt.eu-S1163376AbXD1SAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163376AbXD1SAw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163313AbXD1R7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:59:20 -0400
Received: from ns2.suse.de ([195.135.220.15]:38959 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163340AbXD1R64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:58:56 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428758.455116000@suse.de>
In-Reply-To: <20070428758.455116000@suse.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH] [1/22] x86_64: dma_ops as const
Message-Id: <20070428175847.8DEA6151D1@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:58:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Stephen Hemminger <shemminger@linux-foundation.org>
The dma_ops structure can be const since it never changes
after boot.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/pci-calgary.c |    2 +-
 arch/x86_64/kernel/pci-gart.c    |    2 +-
 arch/x86_64/kernel/pci-nommu.c   |    2 +-
 arch/x86_64/kernel/pci-swiotlb.c |    2 +-
 arch/x86_64/mm/init.c            |    2 +-
 include/asm-x86_64/dma-mapping.h |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

Index: linux/arch/x86_64/kernel/pci-calgary.c
===================================================================
--- linux.orig/arch/x86_64/kernel/pci-calgary.c
+++ linux/arch/x86_64/kernel/pci-calgary.c
@@ -507,7 +507,7 @@ error:
 	return ret;
 }
 
-static struct dma_mapping_ops calgary_dma_ops = {
+static const struct dma_mapping_ops calgary_dma_ops = {
 	.alloc_coherent = calgary_alloc_coherent,
 	.map_single = calgary_map_single,
 	.unmap_single = calgary_unmap_single,
Index: linux/arch/x86_64/kernel/pci-gart.c
===================================================================
--- linux.orig/arch/x86_64/kernel/pci-gart.c
+++ linux/arch/x86_64/kernel/pci-gart.c
@@ -556,7 +556,7 @@ static __init int init_k8_gatt(struct ag
 
 extern int agp_amd64_init(void);
 
-static struct dma_mapping_ops gart_dma_ops = {
+static const struct dma_mapping_ops gart_dma_ops = {
 	.mapping_error = NULL,
 	.map_single = gart_map_single,
 	.map_simple = gart_map_simple,
Index: linux/arch/x86_64/kernel/pci-nommu.c
===================================================================
--- linux.orig/arch/x86_64/kernel/pci-nommu.c
+++ linux/arch/x86_64/kernel/pci-nommu.c
@@ -79,7 +79,7 @@ void nommu_unmap_sg(struct device *dev, 
 {
 }
 
-struct dma_mapping_ops nommu_dma_ops = {
+const struct dma_mapping_ops nommu_dma_ops = {
 	.map_single = nommu_map_single,
 	.unmap_single = nommu_unmap_single,
 	.map_sg = nommu_map_sg,
Index: linux/arch/x86_64/kernel/pci-swiotlb.c
===================================================================
--- linux.orig/arch/x86_64/kernel/pci-swiotlb.c
+++ linux/arch/x86_64/kernel/pci-swiotlb.c
@@ -12,7 +12,7 @@
 int swiotlb __read_mostly;
 EXPORT_SYMBOL(swiotlb);
 
-struct dma_mapping_ops swiotlb_dma_ops = {
+const struct dma_mapping_ops swiotlb_dma_ops = {
 	.mapping_error = swiotlb_dma_mapping_error,
 	.alloc_coherent = swiotlb_alloc_coherent,
 	.free_coherent = swiotlb_free_coherent,
Index: linux/arch/x86_64/mm/init.c
===================================================================
--- linux.orig/arch/x86_64/mm/init.c
+++ linux/arch/x86_64/mm/init.c
@@ -46,7 +46,7 @@
 #define Dprintk(x...)
 #endif
 
-struct dma_mapping_ops* dma_ops;
+const struct dma_mapping_ops* dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 static unsigned long dma_reserve __initdata;
Index: linux/include/asm-x86_64/dma-mapping.h
===================================================================
--- linux.orig/include/asm-x86_64/dma-mapping.h
+++ linux/include/asm-x86_64/dma-mapping.h
@@ -52,7 +52,7 @@ struct dma_mapping_ops {
 };
 
 extern dma_addr_t bad_dma_address;
-extern struct dma_mapping_ops* dma_ops;
+extern const struct dma_mapping_ops* dma_ops;
 extern int iommu_merge;
 
 static inline int dma_mapping_error(dma_addr_t dma_addr)
