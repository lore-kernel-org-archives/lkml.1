Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbZLENbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbZLENbN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 08:31:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbZLENbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 08:31:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38726 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbZLENbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 08:31:09 -0500
Message-ID: <4B1A60F6.7020201@gmail.com>
Date: Sat, 05 Dec 2009 14:32:38 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: tony.luck@intel.com, geoffrey.levand@am.sony.com, davem@davemloft.net,
       tglx@linutronix.de, joerg.roedel@amd.com, muli@il.ibm.com,
       jdmason@kudzu.us, jbarnes@virtuousgeek.org, dwmw2@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/31] Constify struct dma_map_ops for 2.6.32 v1
References: <4B198670.2000406@gmail.com>	<4B1989B0.102@gmail.com>	<20091205115936.d3a7a6ec.sfr@canb.auug.org.au>	<20091205122015.c898e234.sfr@canb.auug.org.au>	<4B19BEB9.3000600@gmail.com>	<20091205131011.e90d7f1c.sfr@canb.auug.org.au>	<4B19C493.4030506@gmail.com>	<20091205132724.154a07b6.sfr@canb.auug.org.au>	<4B19CAF1.8010705@gmail.com> <20091205142140.d8954929.sfr@canb.auug.org.au>
In-Reply-To: <20091205142140.d8954929.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
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

Stephen Rothwell wrote:
> Hi Emese,
> 
> On Sat, 05 Dec 2009 03:52:33 +0100 Emese Revfy <re.emese@gmail.com> wrote:
>> @@ -1232,7 +1231,7 @@ struct vio_dev *vio_register_device_node(struct device_node *of_node)
>>  	viodev->dev.archdata.of_node = of_node_get(of_node);
>>  
>>  	if (firmware_has_feature(FW_FEATURE_CMO))
>> -		vio_cmo_set_dma_ops(viodev);
>> +		viodev->dev.archdata.dma_ops = &vio_dma_mapping_ops;
>>  	else
>>  		viodev->dev.archdata.dma_ops = &dma_iommu_ops;
>>  	set_iommu_table_base(&viodev->dev, vio_build_iommu_table(viodev));
> 
> You forgot to remove this hunk.

Sorry, it's fixed now.

From: Emese Revfy <re.emese@gmail.com>

Constify struct dma_map_ops.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 arch/ia64/hp/common/hwsw_iommu.c         |    4 +-
 arch/ia64/hp/common/sba_iommu.c          |    4 +-
 arch/ia64/include/asm/dma-mapping.h      |   10 ++++----
 arch/ia64/include/asm/machvec.h          |    4 +-
 arch/ia64/kernel/dma-mapping.c           |    4 +-
 arch/ia64/kernel/pci-dma.c               |    2 +-
 arch/ia64/kernel/pci-swiotlb.c           |    2 +-
 arch/ia64/sn/pci/pci_dma.c               |    2 +-
 arch/powerpc/include/asm/device.h        |    2 +-
 arch/powerpc/include/asm/dma-mapping.h   |   18 ++++++++--------
 arch/powerpc/include/asm/iommu.h         |    3 ++
 arch/powerpc/include/asm/pci.h           |    4 +-
 arch/powerpc/include/asm/swiotlb.h       |    2 +-
 arch/powerpc/kernel/dma-iommu.c          |    4 +-
 arch/powerpc/kernel/dma-swiotlb.c        |    2 +-
 arch/powerpc/kernel/dma.c                |    2 +-
 arch/powerpc/kernel/ibmebus.c            |    2 +-
 arch/powerpc/kernel/pci-common.c         |    6 ++--
 arch/powerpc/kernel/vio.c                |    5 +--
 arch/powerpc/platforms/cell/iommu.c      |    2 +-
 arch/powerpc/platforms/ps3/system-bus.c  |    4 +-
 arch/sparc/include/asm/dma-mapping.h     |    8 +++---
 arch/sparc/kernel/iommu.c                |    4 +-
 arch/sparc/kernel/ioport.c               |    6 ++--
 arch/sparc/kernel/pci_sun4v.c            |    2 +-
 arch/x86/include/asm/device.h            |    2 +-
 arch/x86/include/asm/dma-mapping.h       |   10 ++++----
 arch/x86/include/asm/iommu.h             |    2 +-
 arch/x86/kernel/amd_iommu.c              |    2 +-
 arch/x86/kernel/pci-calgary_64.c         |    2 +-
 arch/x86/kernel/pci-dma.c                |    4 +-
 arch/x86/kernel/pci-gart_64.c            |    2 +-
 arch/x86/kernel/pci-nommu.c              |    2 +-
 arch/x86/kernel/pci-swiotlb.c            |    2 +-
 drivers/pci/intel-iommu.c                |    2 +-
 include/asm-generic/dma-mapping-common.h |   24 +++++++++++-----------
 include/linux/dma-mapping.h              |   32 +++++++++++++++---------------
 37 files changed, 98 insertions(+), 96 deletions(-)

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
index 674a837..a4465c6 100644
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
index 285aae8..61dbab6 100644
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
diff --git a/arch/powerpc/include/asm/device.h b/arch/powerpc/include/asm/device.h
index 6d94d27..50d4cad 100644
--- a/arch/powerpc/include/asm/device.h
+++ b/arch/powerpc/include/asm/device.h
@@ -14,7 +14,7 @@ struct dev_archdata {
 	struct device_node	*of_node;
 
 	/* DMA operations on that device */
-	struct dma_map_ops	*dma_ops;
+	const struct dma_map_ops	*dma_ops;
 
 	/*
 	 * When an iommu is in use, dma_data is used as a ptr to the base of the
diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
index e281dae..f025ef0 100644
--- a/arch/powerpc/include/asm/dma-mapping.h
+++ b/arch/powerpc/include/asm/dma-mapping.h
@@ -67,11 +67,11 @@ static inline unsigned long device_to_mask(struct device *dev)
  * Available generic sets of operations
  */
 #ifdef CONFIG_PPC64
-extern struct dma_map_ops dma_iommu_ops;
+extern const struct dma_map_ops dma_iommu_ops;
 #endif
-extern struct dma_map_ops dma_direct_ops;
+extern const struct dma_map_ops dma_direct_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 	/* We don't handle the NULL dev case for ISA for now. We could
 	 * do it via an out of line call but it is not needed for now. The
@@ -84,7 +84,7 @@ static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 	return dev->archdata.dma_ops;
 }
 
-static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
+static inline void set_dma_ops(struct device *dev, const struct dma_map_ops *ops)
 {
 	dev->archdata.dma_ops = ops;
 }
@@ -118,7 +118,7 @@ static inline void set_dma_offset(struct device *dev, dma_addr_t off)
 
 static inline int dma_supported(struct device *dev, u64 mask)
 {
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+	const struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	if (unlikely(dma_ops == NULL))
 		return 0;
@@ -132,7 +132,7 @@ static inline int dma_supported(struct device *dev, u64 mask)
 
 static inline int dma_set_mask(struct device *dev, u64 dma_mask)
 {
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+	const struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	if (unlikely(dma_ops == NULL))
 		return -EIO;
@@ -147,7 +147,7 @@ static inline int dma_set_mask(struct device *dev, u64 dma_mask)
 static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 				       dma_addr_t *dma_handle, gfp_t flag)
 {
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+	const struct dma_map_ops *dma_ops = get_dma_ops(dev);
 	void *cpu_addr;
 
 	BUG_ON(!dma_ops);
@@ -162,7 +162,7 @@ static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 static inline void dma_free_coherent(struct device *dev, size_t size,
 				     void *cpu_addr, dma_addr_t dma_handle)
 {
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+	const struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	BUG_ON(!dma_ops);
 
@@ -173,7 +173,7 @@ static inline void dma_free_coherent(struct device *dev, size_t size,
 
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
-	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+	const struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	if (dma_ops->mapping_error)
 		return dma_ops->mapping_error(dev, dma_addr);
diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index edfc980..1766f59 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -116,6 +116,9 @@ extern void iommu_init_early_iSeries(void);
 extern void iommu_init_early_dart(void);
 extern void iommu_init_early_pasemi(void);
 
+/* dma-iommu.c */
+extern int dma_iommu_dma_supported(struct device *dev, u64 mask);
+
 #ifdef CONFIG_PCI
 extern void pci_iommu_init(void);
 extern void pci_direct_iommu_init(void);
diff --git a/arch/powerpc/include/asm/pci.h b/arch/powerpc/include/asm/pci.h
index b5ea626..4030822 100644
--- a/arch/powerpc/include/asm/pci.h
+++ b/arch/powerpc/include/asm/pci.h
@@ -65,8 +65,8 @@ static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
 }
 
 #ifdef CONFIG_PCI
-extern void set_pci_dma_ops(struct dma_map_ops *dma_ops);
-extern struct dma_map_ops *get_pci_dma_ops(void);
+extern void set_pci_dma_ops(const struct dma_map_ops *dma_ops);
+extern const struct dma_map_ops *get_pci_dma_ops(void);
 #else	/* CONFIG_PCI */
 #define set_pci_dma_ops(d)
 #define get_pci_dma_ops()	NULL
diff --git a/arch/powerpc/include/asm/swiotlb.h b/arch/powerpc/include/asm/swiotlb.h
index 8979d4c..d2fd0d3 100644
--- a/arch/powerpc/include/asm/swiotlb.h
+++ b/arch/powerpc/include/asm/swiotlb.h
@@ -13,7 +13,7 @@
 
 #include <linux/swiotlb.h>
 
-extern struct dma_map_ops swiotlb_dma_ops;
+extern const struct dma_map_ops swiotlb_dma_ops;
 
 static inline void dma_mark_clean(void *addr, size_t size) {}
 
diff --git a/arch/powerpc/kernel/dma-iommu.c b/arch/powerpc/kernel/dma-iommu.c
index 37771a5..70f69e7 100644
--- a/arch/powerpc/kernel/dma-iommu.c
+++ b/arch/powerpc/kernel/dma-iommu.c
@@ -70,7 +70,7 @@ static void dma_iommu_unmap_sg(struct device *dev, struct scatterlist *sglist,
 }
 
 /* We support DMA to/from any memory page via the iommu */
-static int dma_iommu_dma_supported(struct device *dev, u64 mask)
+int dma_iommu_dma_supported(struct device *dev, u64 mask)
 {
 	struct iommu_table *tbl = get_iommu_table_base(dev);
 
@@ -89,7 +89,7 @@ static int dma_iommu_dma_supported(struct device *dev, u64 mask)
 		return 1;
 }
 
-struct dma_map_ops dma_iommu_ops = {
+const struct dma_map_ops dma_iommu_ops = {
 	.alloc_coherent	= dma_iommu_alloc_coherent,
 	.free_coherent	= dma_iommu_free_coherent,
 	.map_sg		= dma_iommu_map_sg,
diff --git a/arch/powerpc/kernel/dma-swiotlb.c b/arch/powerpc/kernel/dma-swiotlb.c
index e96cbbd..bdd6d41 100644
--- a/arch/powerpc/kernel/dma-swiotlb.c
+++ b/arch/powerpc/kernel/dma-swiotlb.c
@@ -31,7 +31,7 @@ unsigned int ppc_swiotlb_enable;
  * map_page, and unmap_page on highmem, use normal dma_ops
  * for everything else.
  */
-struct dma_map_ops swiotlb_dma_ops = {
+const struct dma_map_ops swiotlb_dma_ops = {
 	.alloc_coherent = dma_direct_alloc_coherent,
 	.free_coherent = dma_direct_free_coherent,
 	.map_sg = swiotlb_map_sg_attrs,
diff --git a/arch/powerpc/kernel/dma.c b/arch/powerpc/kernel/dma.c
index 6215062..ebea59c 100644
--- a/arch/powerpc/kernel/dma.c
+++ b/arch/powerpc/kernel/dma.c
@@ -134,7 +134,7 @@ static inline void dma_direct_sync_single_range(struct device *dev,
 }
 #endif
 
-struct dma_map_ops dma_direct_ops = {
+const struct dma_map_ops dma_direct_ops = {
 	.alloc_coherent	= dma_direct_alloc_coherent,
 	.free_coherent	= dma_direct_free_coherent,
 	.map_sg		= dma_direct_map_sg,
diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
index a4c8b38..1b09ad9 100644
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -127,7 +127,7 @@ static int ibmebus_dma_supported(struct device *dev, u64 mask)
 	return 1;
 }
 
-static struct dma_map_ops ibmebus_dma_ops = {
+static const struct dma_map_ops ibmebus_dma_ops = {
 	.alloc_coherent = ibmebus_alloc_coherent,
 	.free_coherent  = ibmebus_free_coherent,
 	.map_sg         = ibmebus_map_sg,
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index e8dfdbd..8583013 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -50,14 +50,14 @@ resource_size_t isa_mem_base;
 unsigned int ppc_pci_flags = 0;
 
 
-static struct dma_map_ops *pci_dma_ops = &dma_direct_ops;
+static const struct dma_map_ops *pci_dma_ops = &dma_direct_ops;
 
-void set_pci_dma_ops(struct dma_map_ops *dma_ops)
+void set_pci_dma_ops(const struct dma_map_ops *dma_ops)
 {
 	pci_dma_ops = dma_ops;
 }
 
-struct dma_map_ops *get_pci_dma_ops(void)
+const struct dma_map_ops *get_pci_dma_ops(void)
 {
 	return pci_dma_ops;
 }
diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index 77f6421..2f68442 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -601,14 +601,14 @@ static void vio_dma_iommu_unmap_sg(struct device *dev,
 	vio_cmo_dealloc(viodev, alloc_size);
 }
 
-struct dma_map_ops vio_dma_mapping_ops = {
+static const struct dma_map_ops vio_dma_mapping_ops = {
 	.alloc_coherent = vio_dma_iommu_alloc_coherent,
 	.free_coherent  = vio_dma_iommu_free_coherent,
 	.map_sg         = vio_dma_iommu_map_sg,
 	.unmap_sg       = vio_dma_iommu_unmap_sg,
+	.dma_supported  = dma_iommu_dma_supported,
 	.map_page       = vio_dma_iommu_map_page,
 	.unmap_page     = vio_dma_iommu_unmap_page,
-
 };
 
 /**
@@ -857,7 +857,6 @@ static void vio_cmo_bus_remove(struct vio_dev *viodev)
 
 static void vio_cmo_set_dma_ops(struct vio_dev *viodev)
 {
-	vio_dma_mapping_ops.dma_supported = dma_iommu_ops.dma_supported;
 	viodev->dev.archdata.dma_ops = &vio_dma_mapping_ops;
 }
 
diff --git a/arch/powerpc/platforms/cell/iommu.c b/arch/powerpc/platforms/cell/iommu.c
index ca5bfdf..1602e09 100644
--- a/arch/powerpc/platforms/cell/iommu.c
+++ b/arch/powerpc/platforms/cell/iommu.c
@@ -642,7 +642,7 @@ static int dma_fixed_dma_supported(struct device *dev, u64 mask)
 
 static int dma_set_mask_and_switch(struct device *dev, u64 dma_mask);
 
-struct dma_map_ops dma_iommu_fixed_ops = {
+const struct dma_map_ops dma_iommu_fixed_ops = {
 	.alloc_coherent = dma_fixed_alloc_coherent,
 	.free_coherent  = dma_fixed_free_coherent,
 	.map_sg         = dma_fixed_map_sg,
diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index e34b305..20e48ec 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -694,7 +694,7 @@ static int ps3_dma_supported(struct device *_dev, u64 mask)
 	return mask >= DMA_BIT_MASK(32);
 }
 
-static struct dma_map_ops ps3_sb_dma_ops = {
+static const struct dma_map_ops ps3_sb_dma_ops = {
 	.alloc_coherent = ps3_alloc_coherent,
 	.free_coherent = ps3_free_coherent,
 	.map_sg = ps3_sb_map_sg,
@@ -704,7 +704,7 @@ static struct dma_map_ops ps3_sb_dma_ops = {
 	.unmap_page = ps3_unmap_page,
 };
 
-static struct dma_map_ops ps3_ioc0_dma_ops = {
+static const struct dma_map_ops ps3_ioc0_dma_ops = {
 	.alloc_coherent = ps3_alloc_coherent,
 	.free_coherent = ps3_free_coherent,
 	.map_sg = ps3_ioc0_map_sg,
diff --git a/arch/sparc/include/asm/dma-mapping.h b/arch/sparc/include/asm/dma-mapping.h
index 5a8c308..fb7c253 100644
--- a/arch/sparc/include/asm/dma-mapping.h
+++ b/arch/sparc/include/asm/dma-mapping.h
@@ -14,10 +14,10 @@ extern int dma_set_mask(struct device *dev, u64 dma_mask);
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 #define dma_is_consistent(d, h)	(1)
 
-extern struct dma_map_ops *dma_ops, pci32_dma_ops;
+extern struct const dma_map_ops *dma_ops, pci32_dma_ops;
 extern struct bus_type pci_bus_type;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 #if defined(CONFIG_SPARC32) && defined(CONFIG_PCI)
 	if (dev->bus == &pci_bus_type)
@@ -31,7 +31,7 @@ static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 				       dma_addr_t *dma_handle, gfp_t flag)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	void *cpu_addr;
 
 	cpu_addr = ops->alloc_coherent(dev, size, dma_handle, flag);
@@ -42,7 +42,7 @@ static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 static inline void dma_free_coherent(struct device *dev, size_t size,
 				     void *cpu_addr, dma_addr_t dma_handle)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
 	ops->free_coherent(dev, size, cpu_addr, dma_handle);
diff --git a/arch/sparc/kernel/iommu.c b/arch/sparc/kernel/iommu.c
index 7690cc2..ece64c9 100644
--- a/arch/sparc/kernel/iommu.c
+++ b/arch/sparc/kernel/iommu.c
@@ -826,7 +826,7 @@ static void dma_4u_sync_sg_for_cpu(struct device *dev,
 	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
-static struct dma_map_ops sun4u_dma_ops = {
+static const struct dma_map_ops sun4u_dma_ops = {
 	.alloc_coherent		= dma_4u_alloc_coherent,
 	.free_coherent		= dma_4u_free_coherent,
 	.map_page		= dma_4u_map_page,
@@ -837,7 +837,7 @@ static struct dma_map_ops sun4u_dma_ops = {
 	.sync_sg_for_cpu	= dma_4u_sync_sg_for_cpu,
 };
 
-struct dma_map_ops *dma_ops = &sun4u_dma_ops;
+const struct dma_map_ops *dma_ops = &sun4u_dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 extern int pci64_dma_supported(struct pci_dev *pdev, u64 device_mask);
diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 9f61fd8..bd048db 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -392,7 +392,7 @@ static void sbus_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 	BUG();
 }
 
-struct dma_map_ops sbus_dma_ops = {
+const struct dma_map_ops sbus_dma_ops = {
 	.alloc_coherent		= sbus_alloc_coherent,
 	.free_coherent		= sbus_free_coherent,
 	.map_page		= sbus_map_page,
@@ -403,7 +403,7 @@ struct dma_map_ops sbus_dma_ops = {
 	.sync_sg_for_device	= sbus_sync_sg_for_device,
 };
 
-struct dma_map_ops *dma_ops = &sbus_dma_ops;
+const struct dma_map_ops *dma_ops = &sbus_dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 static int __init sparc_register_ioport(void)
@@ -640,7 +640,7 @@ static void pci32_sync_sg_for_device(struct device *device, struct scatterlist *
 	}
 }
 
-struct dma_map_ops pci32_dma_ops = {
+const struct dma_map_ops pci32_dma_ops = {
 	.alloc_coherent		= pci32_alloc_coherent,
 	.free_coherent		= pci32_free_coherent,
 	.map_page		= pci32_map_page,
diff --git a/arch/sparc/kernel/pci_sun4v.c b/arch/sparc/kernel/pci_sun4v.c
index 23c33ff..d137fbd 100644
--- a/arch/sparc/kernel/pci_sun4v.c
+++ b/arch/sparc/kernel/pci_sun4v.c
@@ -525,7 +525,7 @@ static void dma_4v_unmap_sg(struct device *dev, struct scatterlist *sglist,
 	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
-static struct dma_map_ops sun4v_dma_ops = {
+static const struct dma_map_ops sun4v_dma_ops = {
 	.alloc_coherent			= dma_4v_alloc_coherent,
 	.free_coherent			= dma_4v_free_coherent,
 	.map_page			= dma_4v_map_page,
diff --git a/arch/x86/include/asm/device.h b/arch/x86/include/asm/device.h
index cee34e9..a7c3fa2 100644
--- a/arch/x86/include/asm/device.h
+++ b/arch/x86/include/asm/device.h
@@ -6,7 +6,7 @@ struct dev_archdata {
 	void	*acpi_handle;
 #endif
 #ifdef CONFIG_X86_64
-struct dma_map_ops *dma_ops;
+	const struct dma_map_ops *dma_ops;
 #endif
 #ifdef CONFIG_DMAR
 	void *iommu; /* hook for IOMMU specific extension */
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 6a25d5d..786b202 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -25,9 +25,9 @@ extern int iommu_merge;
 extern struct device x86_dma_fallback_dev;
 extern int panic_on_overflow;
 
-extern struct dma_map_ops *dma_ops;
+extern const struct dma_map_ops *dma_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 #ifdef CONFIG_X86_32
 	return dma_ops;
@@ -44,7 +44,7 @@ static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 /* Make sure we keep the same behaviour */
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	if (ops->mapping_error)
 		return ops->mapping_error(dev, dma_addr);
 
@@ -122,7 +122,7 @@ static inline void *
 dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t gfp)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	void *memory;
 
 	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
@@ -149,7 +149,7 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 static inline void dma_free_coherent(struct device *dev, size_t size,
 				     void *vaddr, dma_addr_t bus)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	WARN_ON(irqs_disabled());       /* for portability */
 
diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index fd6d21b..8b13915 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -3,7 +3,7 @@
 
 extern void pci_iommu_shutdown(void);
 extern void no_iommu_init(void);
-extern struct dma_map_ops nommu_dma_ops;
+extern const struct dma_map_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
 extern int iommu_pass_through;
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 0285521..c3dc83a 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2069,7 +2069,7 @@ static void prealloc_protection_domains(void)
 	}
 }
 
-static struct dma_map_ops amd_iommu_dma_ops = {
+static const struct dma_map_ops amd_iommu_dma_ops = {
 	.alloc_coherent = alloc_coherent,
 	.free_coherent = free_coherent,
 	.map_page = map_page,
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 971a3be..071558a 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -470,7 +470,7 @@ static void calgary_free_coherent(struct device *dev, size_t size,
 	free_pages((unsigned long)vaddr, get_order(size));
 }
 
-static struct dma_map_ops calgary_dma_ops = {
+static const struct dma_map_ops calgary_dma_ops = {
 	.alloc_coherent = calgary_alloc_coherent,
 	.free_coherent = calgary_free_coherent,
 	.map_sg = calgary_map_sg,
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index a6e804d..e318f5a 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -14,7 +14,7 @@
 
 static int forbid_dac __read_mostly;
 
-struct dma_map_ops *dma_ops;
+const struct dma_map_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 static int iommu_sac_force __read_mostly;
@@ -243,7 +243,7 @@ early_param("iommu", iommu_setup);
 
 int dma_supported(struct device *dev, u64 mask)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 #ifdef CONFIG_PCI
 	if (mask > 0xffffffff && forbid_dac > 0) {
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index a7f1b64..24505d3 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -679,7 +679,7 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 	return -1;
 }
 
-static struct dma_map_ops gart_dma_ops = {
+static const struct dma_map_ops gart_dma_ops = {
 	.map_sg				= gart_map_sg,
 	.unmap_sg			= gart_unmap_sg,
 	.map_page			= gart_map_page,
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index a3933d4..c898869 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -94,7 +94,7 @@ static void nommu_sync_sg_for_device(struct device *dev,
 	flush_write_buffers();
 }
 
-struct dma_map_ops nommu_dma_ops = {
+const struct dma_map_ops nommu_dma_ops = {
 	.alloc_coherent		= dma_generic_alloc_coherent,
 	.free_coherent		= nommu_free_coherent,
 	.map_sg			= nommu_map_sg,
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index aaa6b78..4de1881 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -25,7 +25,7 @@ static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	return swiotlb_alloc_coherent(hwdev, size, dma_handle, flags);
 }
 
-static struct dma_map_ops swiotlb_dma_ops = {
+static const struct dma_map_ops swiotlb_dma_ops = {
 	.mapping_error = swiotlb_dma_mapping_error,
 	.alloc_coherent = x86_swiotlb_alloc_coherent,
 	.free_coherent = swiotlb_free_coherent,
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 1840a05..b4ece9f 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2937,7 +2937,7 @@ static int intel_mapping_error(struct device *dev, dma_addr_t dma_addr)
 	return !dma_addr;
 }
 
-struct dma_map_ops intel_dma_ops = {
+const struct dma_map_ops intel_dma_ops = {
 	.alloc_coherent = intel_alloc_coherent,
 	.free_coherent = intel_free_coherent,
 	.map_sg = intel_map_sg,
diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
index e694263..9ffa925 100644
--- a/include/asm-generic/dma-mapping-common.h
+++ b/include/asm-generic/dma-mapping-common.h
@@ -11,7 +11,7 @@ static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
 					      enum dma_data_direction dir,
 					      struct dma_attrs *attrs)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	dma_addr_t addr;
 
 	kmemcheck_mark_initialized(ptr, size);
@@ -30,7 +30,7 @@ static inline void dma_unmap_single_attrs(struct device *dev, dma_addr_t addr,
 					  enum dma_data_direction dir,
 					  struct dma_attrs *attrs)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->unmap_page)
@@ -42,7 +42,7 @@ static inline int dma_map_sg_attrs(struct device *dev, struct scatterlist *sg,
 				   int nents, enum dma_data_direction dir,
 				   struct dma_attrs *attrs)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	int i, ents;
 	struct scatterlist *s;
 
@@ -59,7 +59,7 @@ static inline void dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sg
 				      int nents, enum dma_data_direction dir,
 				      struct dma_attrs *attrs)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	debug_dma_unmap_sg(dev, sg, nents, dir);
@@ -71,7 +71,7 @@ static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 				      size_t offset, size_t size,
 				      enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	dma_addr_t addr;
 
 	kmemcheck_mark_initialized(page_address(page) + offset, size);
@@ -85,7 +85,7 @@ static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
 				  size_t size, enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->unmap_page)
@@ -97,7 +97,7 @@ static inline void dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr,
 					   size_t size,
 					   enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_for_cpu)
@@ -109,7 +109,7 @@ static inline void dma_sync_single_for_device(struct device *dev,
 					      dma_addr_t addr, size_t size,
 					      enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_for_device)
@@ -123,7 +123,7 @@ static inline void dma_sync_single_range_for_cpu(struct device *dev,
 						 size_t size,
 						 enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_range_for_cpu) {
@@ -140,7 +140,7 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
 						    size_t size,
 						    enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_range_for_device) {
@@ -155,7 +155,7 @@ static inline void
 dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 		    int nelems, enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_sg_for_cpu)
@@ -167,7 +167,7 @@ static inline void
 dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 		       int nelems, enum dma_data_direction dir)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_sg_for_device)
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 91b7618..fc9996f 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -16,50 +16,50 @@ enum dma_data_direction {
 };
 
 struct dma_map_ops {
-	void* (*alloc_coherent)(struct device *dev, size_t size,
+	void* (* const alloc_coherent)(struct device *dev, size_t size,
 				dma_addr_t *dma_handle, gfp_t gfp);
-	void (*free_coherent)(struct device *dev, size_t size,
+	void (* const free_coherent)(struct device *dev, size_t size,
 			      void *vaddr, dma_addr_t dma_handle);
-	dma_addr_t (*map_page)(struct device *dev, struct page *page,
+	dma_addr_t (* const map_page)(struct device *dev, struct page *page,
 			       unsigned long offset, size_t size,
 			       enum dma_data_direction dir,
 			       struct dma_attrs *attrs);
-	void (*unmap_page)(struct device *dev, dma_addr_t dma_handle,
+	void (* const unmap_page)(struct device *dev, dma_addr_t dma_handle,
 			   size_t size, enum dma_data_direction dir,
 			   struct dma_attrs *attrs);
-	int (*map_sg)(struct device *dev, struct scatterlist *sg,
+	int (* const map_sg)(struct device *dev, struct scatterlist *sg,
 		      int nents, enum dma_data_direction dir,
 		      struct dma_attrs *attrs);
-	void (*unmap_sg)(struct device *dev,
+	void (* const unmap_sg)(struct device *dev,
 			 struct scatterlist *sg, int nents,
 			 enum dma_data_direction dir,
 			 struct dma_attrs *attrs);
-	void (*sync_single_for_cpu)(struct device *dev,
+	void (* const sync_single_for_cpu)(struct device *dev,
 				    dma_addr_t dma_handle, size_t size,
 				    enum dma_data_direction dir);
-	void (*sync_single_for_device)(struct device *dev,
+	void (* const sync_single_for_device)(struct device *dev,
 				       dma_addr_t dma_handle, size_t size,
 				       enum dma_data_direction dir);
-	void (*sync_single_range_for_cpu)(struct device *dev,
+	void (* const sync_single_range_for_cpu)(struct device *dev,
 					  dma_addr_t dma_handle,
 					  unsigned long offset,
 					  size_t size,
 					  enum dma_data_direction dir);
-	void (*sync_single_range_for_device)(struct device *dev,
+	void (* const sync_single_range_for_device)(struct device *dev,
 					     dma_addr_t dma_handle,
 					     unsigned long offset,
 					     size_t size,
 					     enum dma_data_direction dir);
-	void (*sync_sg_for_cpu)(struct device *dev,
+	void (* const sync_sg_for_cpu)(struct device *dev,
 				struct scatterlist *sg, int nents,
 				enum dma_data_direction dir);
-	void (*sync_sg_for_device)(struct device *dev,
+	void (* const sync_sg_for_device)(struct device *dev,
 				   struct scatterlist *sg, int nents,
 				   enum dma_data_direction dir);
-	int (*mapping_error)(struct device *dev, dma_addr_t dma_addr);
-	int (*dma_supported)(struct device *dev, u64 mask);
-	int (*set_dma_mask)(struct device *dev, u64 mask);
-	int is_phys;
+	int (* const mapping_error)(struct device *dev, dma_addr_t dma_addr);
+	int (* const dma_supported)(struct device *dev, u64 mask);
+	int (* const set_dma_mask)(struct device *dev, u64 mask);
+	const int is_phys;
 };
 
 #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))

