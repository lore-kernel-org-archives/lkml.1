Return-Path: <linux-kernel-owner+w=401wt.eu-S1762056AbXF0RmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762056AbXF0RmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757746AbXF0Rlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:41:46 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:37912 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbXF0Rlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:41:44 -0400
Date: Wed, 27 Jun 2007 10:41:21 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: change _map_single to static in pci_gart.c etc
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200706271041.21937.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: change _map_single to static in pci_gart.c etc

there function is called via dma_ops->.., so change it to static

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index 5bd20b5..8e03399 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -385,7 +385,7 @@ static int calgary_nontranslate_map_sg(struct device* dev,
 	return nelems;
 }
 
-int calgary_map_sg(struct device *dev, struct scatterlist *sg,
+static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 	int nelems, int direction)
 {
 	struct iommu_table *tbl = to_pci_dev(dev)->bus->self->sysdata;
@@ -436,7 +436,7 @@ error:
 	return 0;
 }
 
-dma_addr_t calgary_map_single(struct device *dev, void *vaddr,
+static dma_addr_t calgary_map_single(struct device *dev, void *vaddr,
 	size_t size, int direction)
 {
 	dma_addr_t dma_handle = bad_dma_address;
@@ -455,7 +455,7 @@ dma_addr_t calgary_map_single(struct device *dev, void *vaddr,
 	return dma_handle;
 }
 
-void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
+static void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
 	size_t size, int direction)
 {
 	struct iommu_table *tbl = to_pci_dev(dev)->bus->self->sysdata;
@@ -468,7 +468,7 @@ void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
 	iommu_free(tbl, dma_handle, npages);
 }
 
-void* calgary_alloc_coherent(struct device *dev, size_t size,
+static void* calgary_alloc_coherent(struct device *dev, size_t size,
 	dma_addr_t *dma_handle, gfp_t flag)
 {
 	void *ret = NULL;
diff --git a/arch/x86_64/kernel/pci-nommu.c b/arch/x86_64/kernel/pci-nommu.c
index 6dade0c..2a34c6c 100644
--- a/arch/x86_64/kernel/pci-nommu.c
+++ b/arch/x86_64/kernel/pci-nommu.c
@@ -34,7 +34,7 @@ nommu_map_single(struct device *hwdev, void *ptr, size_t size,
 	return bus;
 }
 
-void nommu_unmap_single(struct device *dev, dma_addr_t addr,size_t size,
+static void nommu_unmap_single(struct device *dev, dma_addr_t addr,size_t size,
 			int direction)
 {
 }
@@ -54,7 +54,7 @@ void nommu_unmap_single(struct device *dev, dma_addr_t addr,size_t size,
  * Device ownership issues as mentioned above for pci_map_single are
  * the same here.
  */
-int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
+static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
 	       int nents, int direction)
 {
 	int i;
@@ -74,7 +74,7 @@ int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
  * Again, cpu read rules concerning calls here are the same as for
  * pci_unmap_single() above.
  */
-void nommu_unmap_sg(struct device *dev, struct scatterlist *sg,
+static void nommu_unmap_sg(struct device *dev, struct scatterlist *sg,
 		  int nents, int dir)
 {
 }
diff --git a/arch/x86_64/kernel/pci-gart.c b/arch/x86_64/kernel/pci-gart.c
index ae091cd..4918c57 100644
--- a/arch/x86_64/kernel/pci-gart.c
+++ b/arch/x86_64/kernel/pci-gart.c
@@ -235,7 +236,7 @@ static dma_addr_t gart_map_simple(struct device *dev, char *buf,
 }
 
 /* Map a single area into the IOMMU */
-dma_addr_t gart_map_single(struct device *dev, void *addr, size_t size, int dir)
+static dma_addr_t gart_map_single(struct device *dev, void *addr, size_t size, int dir)
 {
 	unsigned long phys_mem, bus;
 
@@ -253,7 +254,7 @@ dma_addr_t gart_map_single(struct device *dev, void *addr, size_t size, int dir)
 /*
  * Free a DMA mapping.
  */
-void gart_unmap_single(struct device *dev, dma_addr_t dma_addr,
+static void gart_unmap_single(struct device *dev, dma_addr_t dma_addr,
 		      size_t size, int direction)
 {
 	unsigned long iommu_page;
@@ -275,7 +276,7 @@ void gart_unmap_single(struct device *dev, dma_addr_t dma_addr,
 /*
  * Wrapper for pci_unmap_single working with scatterlists.
  */
-void gart_unmap_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
+static void gart_unmap_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 {
 	int i;
 
