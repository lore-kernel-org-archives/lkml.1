Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbZHMOpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbZHMOpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 10:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbZHMOpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 10:45:50 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:41455 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817AbZHMOpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 10:45:49 -0400
X-Greylist: delayed 1600 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Aug 2009 10:45:49 EDT
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: [PATCH] arch-x86-pci-swiotlb-cleanup-patch
Date: Thu, 13 Aug 2009 17:18:04 +0300
User-Agent: KMail/1.9.10
Cc: linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908131718.04623.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is a simple cleanup patch for arch/x86/kernel/pci-swiotlb.c file.

Deleted functions are already in lib/swiotlb.c, so no need to be duplicated.

The patch is against linux-2.6.31-rc5, compile/run tested on x86_64.

Best regards,

Marin Mitov

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

=====================================================
--- a/arch/x86/kernel/pci-swiotlb.c	2009-08-13 16:05:28.000000000 +0300
+++ b/arch/x86/kernel/pci-swiotlb.c	2009-08-13 16:13:09.000000000 +0300
@@ -13,31 +13,6 @@
 
 int swiotlb __read_mostly;
 
-void * __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
-{
-	return alloc_bootmem_low_pages(size);
-}
-
-void *swiotlb_alloc(unsigned order, unsigned long nslabs)
-{
-	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
-}
-
-dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
-{
-	return paddr;
-}
-
-phys_addr_t swiotlb_bus_to_phys(struct device *hwdev, dma_addr_t baddr)
-{
-	return baddr;
-}
-
-int __weak swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
-{
-	return 0;
-}
-
 static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 					dma_addr_t *dma_handle, gfp_t flags)
 {
