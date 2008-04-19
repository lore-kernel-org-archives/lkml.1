Return-Path: <linux-kernel-owner+w=401wt.eu-S1758509AbYDSGNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509AbYDSGNV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 02:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYDSGNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 02:13:11 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:50071 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbYDSGNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 02:13:11 -0400
Message-ID: <48098D74.9060106@tiscali.nl>
Date: Sat, 19 Apr 2008 08:13:08 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: airlied@linux.ie
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] pci-gart_64: comparison between signed and unsigned
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you confirm this is right, especially the last case?
---
Fix comparison between signed and unsigned

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 700e464..7af1991 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -97,12 +97,12 @@ static unsigned long alloc_iommu(struct device *dev, int size)
 	spin_lock_irqsave(&iommu_bitmap_lock, flags);
 	offset = iommu_area_alloc(iommu_gart_bitmap, iommu_pages, next_bit,
 				  size, base_index, boundary_size, 0);
-	if (offset == -1) {
+	if (offset == -1ul) {
 		need_flush = 1;
 		offset = iommu_area_alloc(iommu_gart_bitmap, iommu_pages, 0,
 					  size, base_index, boundary_size, 0);
 	}
-	if (offset != -1) {
+	if (offset != -1ul) {
 		set_bit_string(iommu_gart_bitmap, offset, size);
 		next_bit = offset+size;
 		if (next_bit >= iommu_pages) {
@@ -246,7 +246,7 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 	unsigned long iommu_page = alloc_iommu(dev, npages);
 	int i;
 
-	if (iommu_page == -1) {
+	if (iommu_page == -1ul) {
 		if (!nonforced_iommu(dev, phys_mem, size))
 			return phys_mem;
 		if (panic_on_overflow)
@@ -372,7 +372,7 @@ static int __dma_map_cont(struct device *dev, struct scatterlist *start,
 	struct scatterlist *s;
 	int i;
 
-	if (iommu_start == -1)
+	if (iommu_start == -1ul)
 		return -1;
 
 	for_each_sg(start, s, nelems, i) {
