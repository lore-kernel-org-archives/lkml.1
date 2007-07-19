Return-Path: <linux-kernel-owner+w=401wt.eu-S938367AbXGSN5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938367AbXGSN5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937158AbXGSNst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:49 -0400
Received: from ns.suse.de ([195.135.220.2]:54533 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762312AbXGSNss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:48 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: Yinghai.Lu@Sun.COM, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [17/48] x86_64: change _map_single to static in pci_gart.c etc
Message-Id: <20070719134846.A2FEF14E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Yinghai Lu <Yinghai.Lu@Sun.COM>

This function is called via dma_ops->.., so change it to static

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/kernel/pci-gart.c  |    6 +++---
 arch/x86_64/kernel/pci-nommu.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

Index: linux/arch/x86_64/kernel/pci-gart.c
===================================================================
--- linux.orig/arch/x86_64/kernel/pci-gart.c
+++ linux/arch/x86_64/kernel/pci-gart.c
@@ -235,7 +235,7 @@ static dma_addr_t gart_map_simple(struct
 }
 
 /* Map a single area into the IOMMU */
-dma_addr_t gart_map_single(struct device *dev, void *addr, size_t size, int dir)
+static dma_addr_t gart_map_single(struct device *dev, void *addr, size_t size, int dir)
 {
 	unsigned long phys_mem, bus;
 
@@ -253,7 +253,7 @@ dma_addr_t gart_map_single(struct device
 /*
  * Free a DMA mapping.
  */
-void gart_unmap_single(struct device *dev, dma_addr_t dma_addr,
+static void gart_unmap_single(struct device *dev, dma_addr_t dma_addr,
 		      size_t size, int direction)
 {
 	unsigned long iommu_page;
@@ -275,7 +275,7 @@ void gart_unmap_single(struct device *de
 /*
  * Wrapper for pci_unmap_single working with scatterlists.
  */
-void gart_unmap_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
+static void gart_unmap_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 {
 	int i;
 
Index: linux/arch/x86_64/kernel/pci-nommu.c
===================================================================
--- linux.orig/arch/x86_64/kernel/pci-nommu.c
+++ linux/arch/x86_64/kernel/pci-nommu.c
@@ -34,7 +34,7 @@ nommu_map_single(struct device *hwdev, v
 	return bus;
 }
 
-void nommu_unmap_single(struct device *dev, dma_addr_t addr,size_t size,
+static void nommu_unmap_single(struct device *dev, dma_addr_t addr,size_t size,
 			int direction)
 {
 }
@@ -54,7 +54,7 @@ void nommu_unmap_single(struct device *d
  * Device ownership issues as mentioned above for pci_map_single are
  * the same here.
  */
-int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
+static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
 	       int nents, int direction)
 {
 	int i;
@@ -74,7 +74,7 @@ int nommu_map_sg(struct device *hwdev, s
  * Again, cpu read rules concerning calls here are the same as for
  * pci_unmap_single() above.
  */
-void nommu_unmap_sg(struct device *dev, struct scatterlist *sg,
+static void nommu_unmap_sg(struct device *dev, struct scatterlist *sg,
 		  int nents, int dir)
 {
 }
