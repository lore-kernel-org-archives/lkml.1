Return-Path: <linux-kernel-owner+w=401wt.eu-S1764262AbXGKNf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764262AbXGKNf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 09:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762871AbXGKNfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 09:35:20 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:25963 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761549AbXGKNfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 09:35:18 -0400
From: muli@il.ibm.com
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org, muli@il.ibm.com, jdmason@kudzu.us,
       Yinghai Lu <yinghai.lu@sun.com>
Subject: [PATCH 4/4] x86_64: Calgary - change _map_single, etc to static
Date: Wed, 11 Jul 2007 16:35:14 +0300
Message-Id: <1184160914174-git-send-email-muli@il.ibm.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11841609143965-git-send-email-muli@il.ibm.com>
References: <11841609143732-git-send-email-muli@il.ibm.com>
 <11841609141802-git-send-email-muli@il.ibm.com>
 <11841609142004-git-send-email-muli@il.ibm.com>
 <11841609143965-git-send-email-muli@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai.lu@sun.com>

there function are called via dma_ops->.., so change them to static

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 arch/x86_64/kernel/pci-calgary.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index c0cdba7..aec8f76 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -419,7 +419,7 @@ static int calgary_nontranslate_map_sg(struct device* dev,
 	return nelems;
 }
 
-int calgary_map_sg(struct device *dev, struct scatterlist *sg,
+static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 	int nelems, int direction)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
@@ -464,7 +464,7 @@ error:
 	return 0;
 }
 
-dma_addr_t calgary_map_single(struct device *dev, void *vaddr,
+static dma_addr_t calgary_map_single(struct device *dev, void *vaddr,
 	size_t size, int direction)
 {
 	dma_addr_t dma_handle = bad_dma_address;
@@ -483,7 +483,7 @@ dma_addr_t calgary_map_single(struct device *dev, void *vaddr,
 	return dma_handle;
 }
 
-void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
+static void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
 	size_t size, int direction)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
@@ -496,7 +496,7 @@ void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
 	iommu_free(tbl, dma_handle, npages);
 }
 
-void* calgary_alloc_coherent(struct device *dev, size_t size,
+static void* calgary_alloc_coherent(struct device *dev, size_t size,
 	dma_addr_t *dma_handle, gfp_t flag)
 {
 	void *ret = NULL;
-- 
1.5.2

