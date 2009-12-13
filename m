Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbZLNATt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbZLNATt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbZLMX5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34042 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833AbZLMX5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:37 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, tony.luck@intel.com, mingo@elte.hu,
       akpm@linux-foundation.org, bjorn.helgaas@hp.com,
       torvalds@linux-foundation.org
Subject: [PATCH 03/10] Constify struct dma_map_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:18 +0100
Message-Id: <0fdcca18060bb52278eab267f302750acd9a4c04.1260662996.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662995.git.re.emese@gmail.com>
References: <cover.1260662995.git.re.emese@gmail.com>
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 arch/ia64/hp/common/hwsw_iommu.c    |    4 ++--
 arch/ia64/hp/common/sba_iommu.c     |    4 ++--
 arch/ia64/include/asm/dma-mapping.h |   10 +++++-----
 arch/ia64/include/asm/machvec.h     |    4 ++--
 arch/ia64/kernel/dma-mapping.c      |    4 ++--
 arch/ia64/kernel/pci-dma.c          |    2 +-
 arch/ia64/kernel/pci-swiotlb.c      |    2 +-
 arch/ia64/sn/pci/pci_dma.c          |    2 +-
 8 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/ia64/hp/common/hwsw_iommu.c b/arch/ia64/hp/common/hwsw_iommu.c
index e4a80d8..11a7ea1 100644
--- a/arch/ia64/hp/common/hwsw_iommu.c
+++ b/arch/ia64/hp/common/hwsw_iommu.c
@@ -17,7 +17,7 @@
 #include <linux/swiotlb.h>
 #include <asm/machvec.h>
 
-extern struct dma_map_ops sba_dma_ops, swiotlb_dma_ops;
+extern const struct dma_map_ops sba_dma_ops, swiotlb_dma_ops;
 
 /* swiotlb declarations & definitions: */
 extern int swiotlb_late_init_with_default_size (size_t size);
@@ -33,7 +33,7 @@ static inline int use_swiotlb(struct device *dev)
 		!sba_dma_ops.dma_supported(dev, *dev->dma_mask);
 }
 
-struct dma_map_ops *hwsw_dma_get_ops(struct device *dev)
+const struct dma_map_ops *hwsw_dma_get_ops(struct device *dev)
 {
 	if (use_swiotlb(dev))
 		return &swiotlb_dma_ops;
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index f332e3f..61faf7f 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -2077,7 +2077,7 @@ static struct acpi_driver acpi_sba_ioc_driver = {
 	},
 };
 
-extern struct dma_map_ops swiotlb_dma_ops;
+extern const struct dma_map_ops swiotlb_dma_ops;
 
 static int __init
 sba_init(void)
@@ -2191,7 +2191,7 @@ sba_page_override(char *str)
 
 __setup("sbapagesize=",sba_page_override);
 
-struct dma_map_ops sba_dma_ops = {
+const struct dma_map_ops sba_dma_ops = {
 	.alloc_coherent		= sba_alloc_coherent,
 	.free_coherent		= sba_free_coherent,
 	.map_page		= sba_map_page,
diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
index 8d3c79c..71b3af6 100644
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -12,7 +12,7 @@
 
 #define ARCH_HAS_DMA_GET_REQUIRED_MASK
 
-extern struct dma_map_ops *dma_ops;
+extern const struct dma_map_ops *dma_ops;
 extern struct ia64_machine_vector ia64_mv;
 extern void set_iommu_machvec(void);
 
@@ -24,7 +24,7 @@ extern void machvec_dma_sync_sg(struct device *, struct scatterlist *, int,
 static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 				       dma_addr_t *daddr, gfp_t gfp)
 {
-	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	const struct dma_map_ops *ops = platform_dma_get_ops(dev);
 	void *caddr;
 
 	caddr = ops->alloc_coherent(dev, size, daddr, gfp);
@@ -35,7 +35,7 @@ static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 static inline void dma_free_coherent(struct device *dev, size_t size,
 				     void *caddr, dma_addr_t daddr)
 {
-	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	const struct dma_map_ops *ops = platform_dma_get_ops(dev);
 	debug_dma_free_coherent(dev, size, caddr, daddr);
 	ops->free_coherent(dev, size, caddr, daddr);
 }
@@ -49,13 +49,13 @@ static inline void dma_free_coherent(struct device *dev, size_t size,
 
 static inline int dma_mapping_error(struct device *dev, dma_addr_t daddr)
 {
-	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	const struct dma_map_ops *ops = platform_dma_get_ops(dev);
 	return ops->mapping_error(dev, daddr);
 }
 
 static inline int dma_supported(struct device *dev, u64 mask)
 {
-	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	const struct dma_map_ops *ops = platform_dma_get_ops(dev);
 	return ops->dma_supported(dev, mask);
 }
 
diff --git a/arch/ia64/include/asm/machvec.h b/arch/ia64/include/asm/machvec.h
index 367d299..9ad4279 100644
--- a/arch/ia64/include/asm/machvec.h
+++ b/arch/ia64/include/asm/machvec.h
@@ -45,7 +45,7 @@ typedef void ia64_mv_kernel_launch_event_t(void);
 /* DMA-mapping interface: */
 typedef void ia64_mv_dma_init (void);
 typedef u64 ia64_mv_dma_get_required_mask (struct device *);
-typedef struct dma_map_ops *ia64_mv_dma_get_ops(struct device *);
+typedef const struct dma_map_ops *ia64_mv_dma_get_ops(struct device *);
 
 /*
  * WARNING: The legacy I/O space is _architected_.  Platforms are
@@ -251,7 +251,7 @@ extern void machvec_init_from_cmdline(const char *cmdline);
 # endif /* CONFIG_IA64_GENERIC */
 
 extern void swiotlb_dma_init(void);
-extern struct dma_map_ops *dma_get_ops(struct device *);
+extern const struct dma_map_ops *dma_get_ops(struct device *);
 
 /*
  * Define default versions so we can extend machvec for new platforms without having
diff --git a/arch/ia64/kernel/dma-mapping.c b/arch/ia64/kernel/dma-mapping.c
index f2c1600..969398a 100644
--- a/arch/ia64/kernel/dma-mapping.c
+++ b/arch/ia64/kernel/dma-mapping.c
@@ -3,7 +3,7 @@
 /* Set this to 1 if there is a HW IOMMU in the system */
 int iommu_detected __read_mostly;
 
-struct dma_map_ops *dma_ops;
+const struct dma_map_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 #define PREALLOC_DMA_DEBUG_ENTRIES (1 << 16)
@@ -16,7 +16,7 @@ static int __init dma_init(void)
 }
 fs_initcall(dma_init);
 
-struct dma_map_ops *dma_get_ops(struct device *dev)
+const struct dma_map_ops *dma_get_ops(struct device *dev)
 {
 	return dma_ops;
 }
diff --git a/arch/ia64/kernel/pci-dma.c b/arch/ia64/kernel/pci-dma.c
index f6b1ff0..ccacc2f 100644
--- a/arch/ia64/kernel/pci-dma.c
+++ b/arch/ia64/kernel/pci-dma.c
@@ -43,7 +43,7 @@ struct device fallback_dev = {
 	.dma_mask = &fallback_dev.coherent_dma_mask,
 };
 
-extern struct dma_map_ops intel_dma_ops;
+extern const struct dma_map_ops intel_dma_ops;
 
 static int __init pci_iommu_init(void)
 {
diff --git a/arch/ia64/kernel/pci-swiotlb.c b/arch/ia64/kernel/pci-swiotlb.c
index 53292ab..60bba67 100644
--- a/arch/ia64/kernel/pci-swiotlb.c
+++ b/arch/ia64/kernel/pci-swiotlb.c
@@ -21,7 +21,7 @@ static void *ia64_swiotlb_alloc_coherent(struct device *dev, size_t size,
 	return swiotlb_alloc_coherent(dev, size, dma_handle, gfp);
 }
 
-struct dma_map_ops swiotlb_dma_ops = {
+const struct dma_map_ops swiotlb_dma_ops = {
 	.alloc_coherent = ia64_swiotlb_alloc_coherent,
 	.free_coherent = swiotlb_free_coherent,
 	.map_page = swiotlb_map_page,
diff --git a/arch/ia64/sn/pci/pci_dma.c b/arch/ia64/sn/pci/pci_dma.c
index 98b6849..8046766 100644
--- a/arch/ia64/sn/pci/pci_dma.c
+++ b/arch/ia64/sn/pci/pci_dma.c
@@ -464,7 +464,7 @@ int sn_pci_legacy_write(struct pci_bus *bus, u16 port, u32 val, u8 size)
 	return ret;
 }
 
-static struct dma_map_ops sn_dma_ops = {
+static const struct dma_map_ops sn_dma_ops = {
 	.alloc_coherent		= sn_dma_alloc_coherent,
 	.free_coherent		= sn_dma_free_coherent,
 	.map_page		= sn_dma_map_page,
-- 
1.6.5.3

