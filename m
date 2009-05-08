Return-Path: <linux-kernel-owner+w=401wt.eu-S1764357AbZEHAkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764357AbZEHAkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762624AbZEHARc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:17:32 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:48372
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762691AbZEHAR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:17:27 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 7/9] xen/swiotlb: improve comment on gfp flags in xen_alloc_coherent()
Date: Thu,  7 May 2009 17:17:20 -0700
Message-Id: <1241741842-7966-8-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241741842-7966-1-git-send-email-jeremy@goop.org>
References: <1241741842-7966-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Impact: cleanup

Clarify why we don't care about the kernel's pseudo-phys restrictions,
so long as the underlying pages are in the right place.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/pci/xen-iommu.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index 9d01be6..492ef42 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -199,15 +199,17 @@ static void *xen_alloc_coherent(struct device *dev, size_t size,
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

