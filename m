Return-Path: <linux-kernel-owner+w=401wt.eu-S1760882AbZCMRFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760882AbZCMRFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759773AbZCMRBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:01:22 -0400
Received: from gw.goop.org ([64.81.55.164]:57402 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759748AbZCMRBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:01:21 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       David Airlie <airlied@linux.ie>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 17/27] xen/swiotlb: improve comment on gfp flags in xen_alloc_coherent()
Date: Fri, 13 Mar 2009 10:00:02 -0700
Message-Id: <1236963612-14287-18-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236963612-14287-1-git-send-email-jeremy@goop.org>
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Clarify why we don't care about the kernel's pseudo-phys restrictions,
so long as the underlying pages are in the right place.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/pci/xen-iommu.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index 7b6fd3e..13cfe0c 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -202,15 +202,17 @@ static void *xen_alloc_coherent(struct device *dev, size_t size,
 	unsigned long vstart;
 	u64 mask;
 
-	/* ignore region specifiers */
+	/*
+	 * Ignore region specifiers - the kernel's ideas of
+	 * pseudo-phys memory layout has nothing to do with the
+	 * machine physical layout.  We can't allocate highmem
+	 * because we can't return a pointer to it.
+	 */
 	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM);
 
 	if (dma_alloc_from_coherent(dev, size, dma_handle, &ret))
 		return ret;
 
-	if (dev == NULL || (dev->coherent_dma_mask < 0xffffffff))
-		gfp |= GFP_DMA;
-
 	vstart = __get_free_pages(gfp, order);
 	ret = (void *)vstart;
 
-- 
1.6.0.6

