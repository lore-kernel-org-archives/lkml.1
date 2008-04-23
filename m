Return-Path: <linux-kernel-owner+w=401wt.eu-S1760601AbYDWKBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601AbYDWKBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 06:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756337AbYDWJx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:53:26 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:46273 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756320AbYDWJxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:53:24 -0400
Date: Wed, 23 Apr 2008 12:52:44 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Glauber Costa <gcosta@redhat.com>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86/kernel/pci-dma.c cleanups
Message-ID: <20080423095244.GN28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- make the following needlessly global code static:
  - forbid_dac
  - iommu_sac_force
  - dma_alloc_pages()
- remove the following unused export:
  - iommu_bio_merge

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/x86/kernel/pci-dma.c     |    8 +++-----
 include/asm-x86/dma-mapping.h |    1 -
 2 files changed, 3 insertions(+), 6 deletions(-)

41c6aac19822b9875abadb807c41ca1e95031bc7 diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 388b113..d4b1588 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -8,13 +8,12 @@
 #include <asm/gart.h>
 #include <asm/calgary.h>
 
-int forbid_dac __read_mostly;
-EXPORT_SYMBOL(forbid_dac);
+static int forbid_dac __read_mostly;
 
 const struct dma_mapping_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
-int iommu_sac_force __read_mostly = 0;
+static int iommu_sac_force __read_mostly = 0;
 
 #ifdef CONFIG_IOMMU_DEBUG
 int panic_on_overflow __read_mostly = 1;
@@ -33,7 +32,6 @@ int iommu_detected __read_mostly = 0;
 /* This tells the BIO block layer to assume merging. Default to off
    because we cannot guarantee merging later. */
 int iommu_bio_merge __read_mostly = 0;
-EXPORT_SYMBOL(iommu_bio_merge);
 
 dma_addr_t bad_dma_address __read_mostly = 0;
 EXPORT_SYMBOL(bad_dma_address);
@@ -357,7 +355,7 @@ int dma_supported(struct device *dev, u64 mask)
 EXPORT_SYMBOL(dma_supported);
 
 /* Allocate DMA memory on node near device */
-noinline struct page *
+static noinline struct page *
 dma_alloc_pages(struct device *dev, gfp_t gfp, unsigned order)
 {
 	int node;
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index a1a4dc7..c2ddd3d 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -14,7 +14,6 @@ extern dma_addr_t bad_dma_address;
 extern int iommu_merge;
 extern struct device fallback_dev;
 extern int panic_on_overflow;
-extern int forbid_dac;
 extern int force_iommu;
 
 struct dma_mapping_ops {

