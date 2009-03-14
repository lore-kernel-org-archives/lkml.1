Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbZCNPZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbZCNPZj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 11:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbZCNPZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 11:25:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:34253 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbZCNPZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 11:25:29 -0400
Subject: [PATCH -tip] x86: pci-nommu.c cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 20:55:00 +0530
Message-Id: <1237044300.4546.18.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] x86: pci-nommu.c cleanup

Impact: cleanup

 - fix various style problems
  - fix header file issues

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/pci-nommu.c |   29 +++++++++++++++++++----------
 1 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index fe50214..b240d1b 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -1,14 +1,14 @@
 /* Fallback functions when the main IOMMU code is not compiled in. This
    code is roughly equivalent to i386. */
-#include <linux/mm.h>
-#include <linux/init.h>
-#include <linux/pci.h>
-#include <linux/string.h>
 #include <linux/dma-mapping.h>
 #include <linux/scatterlist.h>
+#include <linux/string.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/mm.h>
 
-#include <asm/iommu.h>
 #include <asm/processor.h>
+#include <asm/iommu.h>
 #include <asm/dma.h>
 
 static int
@@ -20,8 +20,10 @@ check_addr(char *name, struct device *hwdev, dma_addr_t bus, size_t size)
 			    "nommu_%s: overflow %Lx+%zu of device mask %Lx\n",
 				name, (long long)bus, size,
 				(long long)*hwdev->dma_mask);
+
 		return 0;
 	}
+
 	return 1;
 }
 
@@ -31,10 +33,14 @@ static dma_addr_t nommu_map_page(struct device *dev, struct page *page,
 				 struct dma_attrs *attrs)
 {
 	dma_addr_t bus = page_to_phys(page) + offset;
+
 	WARN_ON(size == 0);
+
 	if (!check_addr("map_single", dev, bus, size))
 		return bad_dma_address;
+
 	flush_write_buffers();
+
 	return bus;
 }
 
@@ -65,11 +71,14 @@ static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
 	for_each_sg(sg, s, nents, i) {
 		BUG_ON(!sg_page(s));
 		s->dma_address = sg_phys(s);
+
 		if (!check_addr("map_sg", hwdev, s->dma_address, s->length))
 			return 0;
+
 		s->dma_length = s->length;
 	}
 	flush_write_buffers();
+
 	return nents;
 }
 
@@ -80,11 +89,11 @@ static void nommu_free_coherent(struct device *dev, size_t size, void *vaddr,
 }
 
 struct dma_map_ops nommu_dma_ops = {
-	.alloc_coherent = dma_generic_alloc_coherent,
-	.free_coherent = nommu_free_coherent,
-	.map_sg = nommu_map_sg,
-	.map_page = nommu_map_page,
-	.is_phys = 1,
+	.alloc_coherent	= dma_generic_alloc_coherent,
+	.free_coherent	= nommu_free_coherent,
+	.map_sg		= nommu_map_sg,
+	.map_page	= nommu_map_page,
+	.is_phys	= 1,
 };
 
 void __init no_iommu_init(void)
-- 
1.6.0.6



