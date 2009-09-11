Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbZIKSwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbZIKSwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbZIKSwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:52:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40043 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbZIKSs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:48:29 -0400
Date: Fri, 11 Sep 2009 20:48:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] core/iommu for v2.6.32
Message-ID: <20090911184821.GA6684@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the core-iommu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-iommu-for-linus

Highlights:

 - SPARC dma-debug support
 - AMD IOMMU updates / improved hw support
 - cleanups

 Thanks,

	Ingo

------------------>
Arnd Bergmann (1):
      dma-ops: Remove flush_write_buffers() in dma-mapping-common.h

Casey Dahlin (1):
      lib/swiotlb.c: Fix strange panic message selection logic when swiotlb fills up

FUJITA Tomonori (22):
      swiotlb: remove unused swiotlb_alloc_boot()
      swiotlb: remove unused swiotlb_alloc()
      swiotlb: remove swiotlb_arch_range_needs_mapping
      swiotlb: remove unnecessary swiotlb_bus_to_virt
      x86: add dma_capable() to replace is_buffer_dma_capable()
      x86: replace is_buffer_dma_capable() with dma_capable
      ia64: add dma_capable() to replace is_buffer_dma_capable()
      powerpc: add dma_capable() to replace is_buffer_dma_capable()
      swiotlb: use dma_capable()
      powerpc: remove unncesary swiotlb_arch_address_needs_mapping
      remove is_buffer_dma_capable()
      x86, IA64, powerpc: add phys_to_dma() and dma_to_phys()
      swiotlb: use phys_to_dma and dma_to_phys
      powerpc: remove unused swiotlb_phys_to_bus() and swiotlb_bus_to_phys()
      x86: remove unused swiotlb_phys_to_bus() and swiotlb_bus_to_phys()
      IA64: Remove NULL flush_write_buffers
      sparc: Use dma_map_ops struct
      sparc: Use asm-generic/dma-mapping-common.h
      sparc: Remove no-op dma_4v_sync_single_for_cpu and dma_4v_sync_sg_for_cpu
      sparc: Replace sbus_map_single and sbus_unmap_single with sbus_map_page and sbus_unmap_page
      sparc: Use asm-generic/pci-dma-compat
      sparc: Add CONFIG_DMA_API_DEBUG support

Joerg Roedel (34):
      x86/amd-iommu: Dump fault entry on DTE error
      x86/amd-iommu: Dump illegal command on ILLEGAL_COMMAND_ERROR
      x86/amd-iommu: Introduce function for iommu-local domain flush
      x86/amd-iommu: Remove some merge helper code
      x86/amd-iommu: replace "AMD IOMMU" by "AMD-Vi"
      x86/amd-iommu: Remove redundant 'IOMMU' string
      x86/amd-iommu: fix broken check in amd_iommu_flush_all_devices
      x86/amd-iommu: Add function to flush all DTEs on one IOMMU
      x86/amd-iommu: Add reset function for command buffers
      x86/amd-iommu: Reset command buffer on ILLEGAL_COMMAND_ERROR
      x86/amd-iommu: Panic if IOMMU command buffer reset fails
      x86/amd-iommu: Reset command buffer if wait loop fails
      x86/amd-iommu: Make fetch_pte aware of dynamic mapping levels
      x86/amd-iommu: Use fetch_pte in iommu_unmap_page
      x86/amd-iommu: Use fetch_pte in amd_iommu_iova_to_phys
      x86/amd-iommu: Add a gneric version of amd_iommu_flush_all_devices
      x86/amd-iommu: Introduce set_dte_entry function
      x86/amd-iommu: Flush domains if address space size was increased
      x86/amd-iommu: Introduce increase_address_space function
      x86/amd-iommu: Change alloc_pte to support 64 bit address space
      x86/amd-iommu: Remove last usages of IOMMU_PTE_L0_INDEX
      x86/amd-iommu: Remove bus_addr check in iommu_map_page
      x86/amd-iommu: Use 2-level page tables for dma_ops domains
      x86/amd-iommu: Remove old page table handling macros
      x86/amd-iommu: Support higher level PTEs in iommu_page_unmap
      x86/amd-iommu: Change iommu_map_page to support multiple page sizes
      x86/dma: Mark iommu_pass_through as __read_mostly
      x86/amd-iommu: Add core functions for pd allocation/freeing
      x86/amd-iommu: Add passthrough mode initialization functions
      x86/amd-iommu: Fix device table write order
      x86/amd-iommu: Align locking between attach_device and detach_device
      x86/amd-iommu: Make sure a device is assigned in passthrough mode
      x86/amd-iommu: Don't detach device from pt domain on driver unbind
      x86/amd-iommu: Initialize passthrough mode when requested

Pavel Vasilyev (1):
      x86/gart: Do not select AGP for GART_IOMMU


 arch/ia64/include/asm/dma-mapping.h      |   19 ++-
 arch/powerpc/include/asm/dma-mapping.h   |   23 ++
 arch/powerpc/kernel/dma-swiotlb.c        |   48 +---
 arch/sparc/Kconfig                       |    2 +
 arch/sparc/include/asm/dma-mapping.h     |  145 ++--------
 arch/sparc/include/asm/pci.h             |    3 +
 arch/sparc/include/asm/pci_32.h          |  105 -------
 arch/sparc/include/asm/pci_64.h          |   88 ------
 arch/sparc/kernel/Makefile               |    2 +-
 arch/sparc/kernel/dma.c                  |  175 +-----------
 arch/sparc/kernel/dma.h                  |   14 -
 arch/sparc/kernel/iommu.c                |   20 +-
 arch/sparc/kernel/ioport.c               |  190 +++++++-----
 arch/sparc/kernel/pci.c                  |    2 +-
 arch/sparc/kernel/pci_sun4v.c            |   30 +--
 arch/x86/Kconfig                         |    1 -
 arch/x86/include/asm/amd_iommu.h         |    1 +
 arch/x86/include/asm/amd_iommu_types.h   |   50 ++--
 arch/x86/include/asm/dma-mapping.h       |   18 ++
 arch/x86/kernel/amd_iommu.c              |  489 ++++++++++++++++++++++--------
 arch/x86/kernel/amd_iommu_init.c         |   42 ++-
 arch/x86/kernel/pci-dma.c                |   11 +-
 arch/x86/kernel/pci-gart_64.c            |    5 +-
 arch/x86/kernel/pci-nommu.c              |   29 ++-
 arch/x86/kernel/pci-swiotlb.c            |   25 --
 include/asm-generic/dma-mapping-common.h |    6 -
 include/linux/dma-mapping.h              |    5 -
 include/linux/swiotlb.h                  |   11 -
 lib/swiotlb.c                            |  124 +++-----
 29 files changed, 720 insertions(+), 963 deletions(-)
 delete mode 100644 arch/sparc/kernel/dma.h

diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
index 5a61b5c..8d3c79c 100644
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -44,7 +44,6 @@ static inline void dma_free_coherent(struct device *dev, size_t size,
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
 #define get_dma_ops(dev) platform_dma_get_ops(dev)
-#define flush_write_buffers()
 
 #include <asm-generic/dma-mapping-common.h>
 
@@ -69,6 +68,24 @@ dma_set_mask (struct device *dev, u64 mask)
 	return 0;
 }
 
+static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
+{
+	if (!dev->dma_mask)
+		return 0;
+
+	return addr + size <= *dev->dma_mask;
+}
+
+static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
+{
+	return paddr;
+}
+
+static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
+{
+	return daddr;
+}
+
 extern int dma_get_cache_alignment(void);
 
 static inline void
diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
index b44aaab..0c34371 100644
--- a/arch/powerpc/include/asm/dma-mapping.h
+++ b/arch/powerpc/include/asm/dma-mapping.h
@@ -424,6 +424,29 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 #endif
 }
 
+static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
+{
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
+
+	if (ops->addr_needs_map && ops->addr_needs_map(dev, addr, size))
+		return 0;
+
+	if (!dev->dma_mask)
+		return 0;
+
+	return addr + size <= *dev->dma_mask;
+}
+
+static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
+{
+	return paddr + get_dma_direct_offset(dev);
+}
+
+static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
+{
+	return daddr - get_dma_direct_offset(dev);
+}
+
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 #ifdef CONFIG_NOT_COHERENT_CACHE
diff --git a/arch/powerpc/kernel/dma-swiotlb.c b/arch/powerpc/kernel/dma-swiotlb.c
index 68ccf11..e8a57de 100644
--- a/arch/powerpc/kernel/dma-swiotlb.c
+++ b/arch/powerpc/kernel/dma-swiotlb.c
@@ -24,50 +24,12 @@
 int swiotlb __read_mostly;
 unsigned int ppc_swiotlb_enable;
 
-void *swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t addr)
-{
-	unsigned long pfn = PFN_DOWN(swiotlb_bus_to_phys(hwdev, addr));
-	void *pageaddr = page_address(pfn_to_page(pfn));
-
-	if (pageaddr != NULL)
-		return pageaddr + (addr % PAGE_SIZE);
-	return NULL;
-}
-
-dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
-{
-	return paddr + get_dma_direct_offset(hwdev);
-}
-
-phys_addr_t swiotlb_bus_to_phys(struct device *hwdev, dma_addr_t baddr)
-
-{
-	return baddr - get_dma_direct_offset(hwdev);
-}
-
-/*
- * Determine if an address needs bounce buffering via swiotlb.
- * Going forward I expect the swiotlb code to generalize on using
- * a dma_ops->addr_needs_map, and this function will move from here to the
- * generic swiotlb code.
- */
-int
-swiotlb_arch_address_needs_mapping(struct device *hwdev, dma_addr_t addr,
-				   size_t size)
-{
-	struct dma_mapping_ops *dma_ops = get_dma_ops(hwdev);
-
-	BUG_ON(!dma_ops);
-	return dma_ops->addr_needs_map(hwdev, addr, size);
-}
-
 /*
  * Determine if an address is reachable by a pci device, or if we must bounce.
  */
 static int
 swiotlb_pci_addr_needs_map(struct device *hwdev, dma_addr_t addr, size_t size)
 {
-	u64 mask = dma_get_mask(hwdev);
 	dma_addr_t max;
 	struct pci_controller *hose;
 	struct pci_dev *pdev = to_pci_dev(hwdev);
@@ -79,16 +41,9 @@ swiotlb_pci_addr_needs_map(struct device *hwdev, dma_addr_t addr, size_t size)
 	if ((addr + size > max) | (addr < hose->dma_window_base_cur))
 		return 1;
 
-	return !is_buffer_dma_capable(mask, addr, size);
-}
-
-static int
-swiotlb_addr_needs_map(struct device *hwdev, dma_addr_t addr, size_t size)
-{
-	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
+	return 0;
 }
 
-
 /*
  * At the moment, all platforms that use this code only require
  * swiotlb to be used if we're operating on HIGHMEM.  Since
@@ -104,7 +59,6 @@ struct dma_mapping_ops swiotlb_dma_ops = {
 	.dma_supported = swiotlb_dma_supported,
 	.map_page = swiotlb_map_page,
 	.unmap_page = swiotlb_unmap_page,
-	.addr_needs_map = swiotlb_addr_needs_map,
 	.sync_single_range_for_cpu = swiotlb_sync_single_range_for_cpu,
 	.sync_single_range_for_device = swiotlb_sync_single_range_for_device,
 	.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 3f8b6a9..233cff5 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -25,6 +25,8 @@ config SPARC
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select RTC_CLASS
 	select RTC_DRV_M48T59
+	select HAVE_DMA_ATTRS
+	select HAVE_DMA_API_DEBUG
 
 config SPARC32
 	def_bool !64BIT
diff --git a/arch/sparc/include/asm/dma-mapping.h b/arch/sparc/include/asm/dma-mapping.h
index 204e4bf..5a8c308 100644
--- a/arch/sparc/include/asm/dma-mapping.h
+++ b/arch/sparc/include/asm/dma-mapping.h
@@ -3,6 +3,7 @@
 
 #include <linux/scatterlist.h>
 #include <linux/mm.h>
+#include <linux/dma-debug.h>
 
 #define DMA_ERROR_CODE	(~(dma_addr_t)0x0)
 
@@ -13,142 +14,40 @@ extern int dma_set_mask(struct device *dev, u64 dma_mask);
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 #define dma_is_consistent(d, h)	(1)
 
-struct dma_ops {
-	void *(*alloc_coherent)(struct device *dev, size_t size,
-				dma_addr_t *dma_handle, gfp_t flag);
-	void (*free_coherent)(struct device *dev, size_t size,
-			      void *cpu_addr, dma_addr_t dma_handle);
-	dma_addr_t (*map_page)(struct device *dev, struct page *page,
-			       unsigned long offset, size_t size,
-			       enum dma_data_direction direction);
-	void (*unmap_page)(struct device *dev, dma_addr_t dma_addr,
-			   size_t size,
-			   enum dma_data_direction direction);
-	int (*map_sg)(struct device *dev, struct scatterlist *sg, int nents,
-		      enum dma_data_direction direction);
-	void (*unmap_sg)(struct device *dev, struct scatterlist *sg,
-			 int nhwentries,
-			 enum dma_data_direction direction);
-	void (*sync_single_for_cpu)(struct device *dev,
-				    dma_addr_t dma_handle, size_t size,
-				    enum dma_data_direction direction);
-	void (*sync_single_for_device)(struct device *dev,
-				       dma_addr_t dma_handle, size_t size,
-				       enum dma_data_direction direction);
-	void (*sync_sg_for_cpu)(struct device *dev, struct scatterlist *sg,
-				int nelems,
-				enum dma_data_direction direction);
-	void (*sync_sg_for_device)(struct device *dev,
-				   struct scatterlist *sg, int nents,
-				   enum dma_data_direction dir);
-};
-extern const struct dma_ops *dma_ops;
+extern struct dma_map_ops *dma_ops, pci32_dma_ops;
+extern struct bus_type pci_bus_type;
 
-static inline void *dma_alloc_coherent(struct device *dev, size_t size,
-				       dma_addr_t *dma_handle, gfp_t flag)
-{
-	return dma_ops->alloc_coherent(dev, size, dma_handle, flag);
-}
-
-static inline void dma_free_coherent(struct device *dev, size_t size,
-				     void *cpu_addr, dma_addr_t dma_handle)
-{
-	dma_ops->free_coherent(dev, size, cpu_addr, dma_handle);
-}
-
-static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
-					size_t size,
-					enum dma_data_direction direction)
-{
-	return dma_ops->map_page(dev, virt_to_page(cpu_addr),
-				 (unsigned long)cpu_addr & ~PAGE_MASK, size,
-				 direction);
-}
-
-static inline void dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
-				    size_t size,
-				    enum dma_data_direction direction)
-{
-	dma_ops->unmap_page(dev, dma_addr, size, direction);
-}
-
-static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
-				      unsigned long offset, size_t size,
-				      enum dma_data_direction direction)
-{
-	return dma_ops->map_page(dev, page, offset, size, direction);
-}
-
-static inline void dma_unmap_page(struct device *dev, dma_addr_t dma_address,
-				  size_t size,
-				  enum dma_data_direction direction)
-{
-	dma_ops->unmap_page(dev, dma_address, size, direction);
-}
-
-static inline int dma_map_sg(struct device *dev, struct scatterlist *sg,
-			     int nents, enum dma_data_direction direction)
-{
-	return dma_ops->map_sg(dev, sg, nents, direction);
-}
-
-static inline void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
-				int nents, enum dma_data_direction direction)
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
-	dma_ops->unmap_sg(dev, sg, nents, direction);
-}
-
-static inline void dma_sync_single_for_cpu(struct device *dev,
-					   dma_addr_t dma_handle, size_t size,
-					   enum dma_data_direction direction)
-{
-	dma_ops->sync_single_for_cpu(dev, dma_handle, size, direction);
+#if defined(CONFIG_SPARC32) && defined(CONFIG_PCI)
+	if (dev->bus == &pci_bus_type)
+		return &pci32_dma_ops;
+#endif
+	return dma_ops;
 }
 
-static inline void dma_sync_single_for_device(struct device *dev,
-					      dma_addr_t dma_handle,
-					      size_t size,
-					      enum dma_data_direction direction)
-{
-	if (dma_ops->sync_single_for_device)
-		dma_ops->sync_single_for_device(dev, dma_handle, size,
-						direction);
-}
+#include <asm-generic/dma-mapping-common.h>
 
-static inline void dma_sync_sg_for_cpu(struct device *dev,
-				       struct scatterlist *sg, int nelems,
-				       enum dma_data_direction direction)
+static inline void *dma_alloc_coherent(struct device *dev, size_t size,
+				       dma_addr_t *dma_handle, gfp_t flag)
 {
-	dma_ops->sync_sg_for_cpu(dev, sg, nelems, direction);
-}
+	struct dma_map_ops *ops = get_dma_ops(dev);
+	void *cpu_addr;
 
-static inline void dma_sync_sg_for_device(struct device *dev,
-					  struct scatterlist *sg, int nelems,
-					  enum dma_data_direction direction)
-{
-	if (dma_ops->sync_sg_for_device)
-		dma_ops->sync_sg_for_device(dev, sg, nelems, direction);
+	cpu_addr = ops->alloc_coherent(dev, size, dma_handle, flag);
+	debug_dma_alloc_coherent(dev, size, *dma_handle, cpu_addr);
+	return cpu_addr;
 }
 
-static inline void dma_sync_single_range_for_cpu(struct device *dev,
-						 dma_addr_t dma_handle,
-						 unsigned long offset,
-						 size_t size,
-						 enum dma_data_direction dir)
+static inline void dma_free_coherent(struct device *dev, size_t size,
+				     void *cpu_addr, dma_addr_t dma_handle)
 {
-	dma_sync_single_for_cpu(dev, dma_handle+offset, size, dir);
-}
+	struct dma_map_ops *ops = get_dma_ops(dev);
 
-static inline void dma_sync_single_range_for_device(struct device *dev,
-						    dma_addr_t dma_handle,
-						    unsigned long offset,
-						    size_t size,
-						    enum dma_data_direction dir)
-{
-	dma_sync_single_for_device(dev, dma_handle+offset, size, dir);
+	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
+	ops->free_coherent(dev, size, cpu_addr, dma_handle);
 }
 
-
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return (dma_addr == DMA_ERROR_CODE);
diff --git a/arch/sparc/include/asm/pci.h b/arch/sparc/include/asm/pci.h
index 6e14fd1..d9c031f 100644
--- a/arch/sparc/include/asm/pci.h
+++ b/arch/sparc/include/asm/pci.h
@@ -5,4 +5,7 @@
 #else
 #include <asm/pci_32.h>
 #endif
+
+#include <asm-generic/pci-dma-compat.h>
+
 #endif
diff --git a/arch/sparc/include/asm/pci_32.h b/arch/sparc/include/asm/pci_32.h
index b41c4c1..ac0e836 100644
--- a/arch/sparc/include/asm/pci_32.h
+++ b/arch/sparc/include/asm/pci_32.h
@@ -31,42 +31,8 @@ static inline void pcibios_penalize_isa_irq(int irq, int active)
  */
 #define PCI_DMA_BUS_IS_PHYS	(0)
 
-#include <asm/scatterlist.h>
-
 struct pci_dev;
 
-/* Allocate and map kernel buffer using consistent mode DMA for a device.
- * hwdev should be valid struct pci_dev pointer for PCI devices.
- */
-extern void *pci_alloc_consistent(struct pci_dev *hwdev, size_t size, dma_addr_t *dma_handle);
-
-/* Free and unmap a consistent DMA buffer.
- * cpu_addr is what was returned from pci_alloc_consistent,
- * size must be the same as what as passed into pci_alloc_consistent,
- * and likewise dma_addr must be the same as what *dma_addrp was set to.
- *
- * References to the memory and mappings assosciated with cpu_addr/dma_addr
- * past this call are illegal.
- */
-extern void pci_free_consistent(struct pci_dev *hwdev, size_t size, void *vaddr, dma_addr_t dma_handle);
-
-/* Map a single buffer of the indicated size for DMA in streaming mode.
- * The 32-bit bus address to use is returned.
- *
- * Once the device is given the dma address, the device owns this memory
- * until either pci_unmap_single or pci_dma_sync_single_for_cpu is performed.
- */
-extern dma_addr_t pci_map_single(struct pci_dev *hwdev, void *ptr, size_t size, int direction);
-
-/* Unmap a single streaming mode DMA translation.  The dma_addr and size
- * must match what was provided for in a previous pci_map_single call.  All
- * other usages are undefined.
- *
- * After this call, reads by the cpu to the buffer are guaranteed to see
- * whatever the device wrote there.
- */
-extern void pci_unmap_single(struct pci_dev *hwdev, dma_addr_t dma_addr, size_t size, int direction);
-
 /* pci_unmap_{single,page} is not a nop, thus... */
 #define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	\
 	dma_addr_t ADDR_NAME;
@@ -81,69 +47,6 @@ extern void pci_unmap_single(struct pci_dev *hwdev, dma_addr_t dma_addr, size_t
 #define pci_unmap_len_set(PTR, LEN_NAME, VAL)		\
 	(((PTR)->LEN_NAME) = (VAL))
 
-/*
- * Same as above, only with pages instead of mapped addresses.
- */
-extern dma_addr_t pci_map_page(struct pci_dev *hwdev, struct page *page,
-			unsigned long offset, size_t size, int direction);
-extern void pci_unmap_page(struct pci_dev *hwdev,
-			dma_addr_t dma_address, size_t size, int direction);
-
-/* Map a set of buffers described by scatterlist in streaming
- * mode for DMA.  This is the scather-gather version of the
- * above pci_map_single interface.  Here the scatter gather list
- * elements are each tagged with the appropriate dma address
- * and length.  They are obtained via sg_dma_{address,length}(SG).
- *
- * NOTE: An implementation may be able to use a smaller number of
- *       DMA address/length pairs than there are SG table elements.
- *       (for example via virtual mapping capabilities)
- *       The routine returns the number of addr/length pairs actually
- *       used, at most nents.
- *
- * Device ownership issues as mentioned above for pci_map_single are
- * the same here.
- */
-extern int pci_map_sg(struct pci_dev *hwdev, struct scatterlist *sg, int nents, int direction);
-
-/* Unmap a set of streaming mode DMA translations.
- * Again, cpu read rules concerning calls here are the same as for
- * pci_unmap_single() above.
- */
-extern void pci_unmap_sg(struct pci_dev *hwdev, struct scatterlist *sg, int nhwents, int direction);
-
-/* Make physical memory consistent for a single
- * streaming mode DMA translation after a transfer.
- *
- * If you perform a pci_map_single() but wish to interrogate the
- * buffer using the cpu, yet do not wish to teardown the PCI dma
- * mapping, you must call this function before doing so.  At the
- * next point you give the PCI dma address back to the card, you
- * must first perform a pci_dma_sync_for_device, and then the device
- * again owns the buffer.
- */
-extern void pci_dma_sync_single_for_cpu(struct pci_dev *hwdev, dma_addr_t dma_handle, size_t size, int direction);
-extern void pci_dma_sync_single_for_device(struct pci_dev *hwdev, dma_addr_t dma_handle, size_t size, int direction);
-
-/* Make physical memory consistent for a set of streaming
- * mode DMA translations after a transfer.
- *
- * The same as pci_dma_sync_single_* but for a scatter-gather list,
- * same rules and usage.
- */
-extern void pci_dma_sync_sg_for_cpu(struct pci_dev *hwdev, struct scatterlist *sg, int nelems, int direction);
-extern void pci_dma_sync_sg_for_device(struct pci_dev *hwdev, struct scatterlist *sg, int nelems, int direction);
-
-/* Return whether the given PCI device DMA address mask can
- * be supported properly.  For example, if your device can
- * only drive the low 24-bits during PCI bus mastering, then
- * you would pass 0x00ffffff as the mask to this function.
- */
-static inline int pci_dma_supported(struct pci_dev *hwdev, u64 mask)
-{
-	return 1;
-}
-
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 					enum pci_dma_burst_strategy *strat,
@@ -154,14 +57,6 @@ static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 }
 #endif
 
-#define PCI_DMA_ERROR_CODE      (~(dma_addr_t)0x0)
-
-static inline int pci_dma_mapping_error(struct pci_dev *pdev,
-					dma_addr_t dma_addr)
-{
-        return (dma_addr == PCI_DMA_ERROR_CODE);
-}
-
 struct device_node;
 extern struct device_node *pci_device_to_OF_node(struct pci_dev *pdev);
 
diff --git a/arch/sparc/include/asm/pci_64.h b/arch/sparc/include/asm/pci_64.h
index 7a1e356..5cc9f6a 100644
--- a/arch/sparc/include/asm/pci_64.h
+++ b/arch/sparc/include/asm/pci_64.h
@@ -35,37 +35,6 @@ static inline void pcibios_penalize_isa_irq(int irq, int active)
  */
 #define PCI_DMA_BUS_IS_PHYS	(0)
 
-static inline void *pci_alloc_consistent(struct pci_dev *pdev, size_t size,
-					 dma_addr_t *dma_handle)
-{
-	return dma_alloc_coherent(&pdev->dev, size, dma_handle, GFP_ATOMIC);
-}
-
-static inline void pci_free_consistent(struct pci_dev *pdev, size_t size,
-				       void *vaddr, dma_addr_t dma_handle)
-{
-	return dma_free_coherent(&pdev->dev, size, vaddr, dma_handle);
-}
-
-static inline dma_addr_t pci_map_single(struct pci_dev *pdev, void *ptr,
-					size_t size, int direction)
-{
-	return dma_map_single(&pdev->dev, ptr, size,
-			      (enum dma_data_direction) direction);
-}
-
-static inline void pci_unmap_single(struct pci_dev *pdev, dma_addr_t dma_addr,
-				    size_t size, int direction)
-{
-	dma_unmap_single(&pdev->dev, dma_addr, size,
-			 (enum dma_data_direction) direction);
-}
-
-#define pci_map_page(dev, page, off, size, dir) \
-	pci_map_single(dev, (page_address(page) + (off)), size, dir)
-#define pci_unmap_page(dev,addr,sz,dir) \
-	pci_unmap_single(dev,addr,sz,dir)
-
 /* pci_unmap_{single,page} is not a nop, thus... */
 #define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	\
 	dma_addr_t ADDR_NAME;
@@ -80,57 +49,6 @@ static inline void pci_unmap_single(struct pci_dev *pdev, dma_addr_t dma_addr,
 #define pci_unmap_len_set(PTR, LEN_NAME, VAL)		\
 	(((PTR)->LEN_NAME) = (VAL))
 
-static inline int pci_map_sg(struct pci_dev *pdev, struct scatterlist *sg,
-			     int nents, int direction)
-{
-	return dma_map_sg(&pdev->dev, sg, nents,
-			  (enum dma_data_direction) direction);
-}
-
-static inline void pci_unmap_sg(struct pci_dev *pdev, struct scatterlist *sg,
-				int nents, int direction)
-{
-	dma_unmap_sg(&pdev->dev, sg, nents,
-		     (enum dma_data_direction) direction);
-}
-
-static inline void pci_dma_sync_single_for_cpu(struct pci_dev *pdev,
-					       dma_addr_t dma_handle,
-					       size_t size, int direction)
-{
-	dma_sync_single_for_cpu(&pdev->dev, dma_handle, size,
-				(enum dma_data_direction) direction);
-}
-
-static inline void pci_dma_sync_single_for_device(struct pci_dev *pdev,
-						  dma_addr_t dma_handle,
-						  size_t size, int direction)
-{
-	/* No flushing needed to sync cpu writes to the device.  */
-}
-
-static inline void pci_dma_sync_sg_for_cpu(struct pci_dev *pdev,
-					   struct scatterlist *sg,
-					   int nents, int direction)
-{
-	dma_sync_sg_for_cpu(&pdev->dev, sg, nents,
-			    (enum dma_data_direction) direction);
-}
-
-static inline void pci_dma_sync_sg_for_device(struct pci_dev *pdev,
-					      struct scatterlist *sg,
-					      int nelems, int direction)
-{
-	/* No flushing needed to sync cpu writes to the device.  */
-}
-
-/* Return whether the given PCI device DMA address mask can
- * be supported properly.  For example, if your device can
- * only drive the low 24-bits during PCI bus mastering, then
- * you would pass 0x00ffffff as the mask to this function.
- */
-extern int pci_dma_supported(struct pci_dev *hwdev, u64 mask);
-
 /* PCI IOMMU mapping bypass support. */
 
 /* PCI 64-bit addressing works for all slots on all controller
@@ -140,12 +58,6 @@ extern int pci_dma_supported(struct pci_dev *hwdev, u64 mask);
 #define PCI64_REQUIRED_MASK	(~(dma64_addr_t)0)
 #define PCI64_ADDR_BASE		0xfffc000000000000UL
 
-static inline int pci_dma_mapping_error(struct pci_dev *pdev,
-					dma_addr_t dma_addr)
-{
-	return dma_mapping_error(&pdev->dev, dma_addr);
-}
-
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 					enum pci_dma_burst_strategy *strat,
diff --git a/arch/sparc/kernel/Makefile b/arch/sparc/kernel/Makefile
index 475ce46..29b88a5 100644
--- a/arch/sparc/kernel/Makefile
+++ b/arch/sparc/kernel/Makefile
@@ -61,7 +61,7 @@ obj-$(CONFIG_SPARC64_SMP) += cpumap.o
 obj-$(CONFIG_SPARC32)     += devres.o
 devres-y                  := ../../../kernel/irq/devres.o
 
-obj-$(CONFIG_SPARC32)     += dma.o
+obj-y                     += dma.o
 
 obj-$(CONFIG_SPARC32_PCI) += pcic.o
 
diff --git a/arch/sparc/kernel/dma.c b/arch/sparc/kernel/dma.c
index 524c32f..e1ba8ee 100644
--- a/arch/sparc/kernel/dma.c
+++ b/arch/sparc/kernel/dma.c
@@ -1,178 +1,13 @@
-/* dma.c: PCI and SBUS DMA accessors for 32-bit sparc.
- *
- * Copyright (C) 2008 David S. Miller <davem@davemloft.net>
- */
-
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
-#include <linux/scatterlist.h>
-#include <linux/mm.h>
-
-#ifdef CONFIG_PCI
-#include <linux/pci.h>
-#endif
+#include <linux/dma-debug.h>
 
-#include "dma.h"
+#define PREALLOC_DMA_DEBUG_ENTRIES       (1 << 15)
 
-int dma_supported(struct device *dev, u64 mask)
+static int __init dma_init(void)
 {
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type)
-		return pci_dma_supported(to_pci_dev(dev), mask);
-#endif
+	dma_debug_init(PREALLOC_DMA_DEBUG_ENTRIES);
 	return 0;
 }
-EXPORT_SYMBOL(dma_supported);
-
-int dma_set_mask(struct device *dev, u64 dma_mask)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type)
-		return pci_set_dma_mask(to_pci_dev(dev), dma_mask);
-#endif
-	return -EOPNOTSUPP;
-}
-EXPORT_SYMBOL(dma_set_mask);
-
-static void *dma32_alloc_coherent(struct device *dev, size_t size,
-				  dma_addr_t *dma_handle, gfp_t flag)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type)
-		return pci_alloc_consistent(to_pci_dev(dev), size, dma_handle);
-#endif
-	return sbus_alloc_consistent(dev, size, dma_handle);
-}
-
-static void dma32_free_coherent(struct device *dev, size_t size,
-				void *cpu_addr, dma_addr_t dma_handle)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type) {
-		pci_free_consistent(to_pci_dev(dev), size,
-				    cpu_addr, dma_handle);
-		return;
-	}
-#endif
-	sbus_free_consistent(dev, size, cpu_addr, dma_handle);
-}
-
-static dma_addr_t dma32_map_page(struct device *dev, struct page *page,
-				 unsigned long offset, size_t size,
-				 enum dma_data_direction direction)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type)
-		return pci_map_page(to_pci_dev(dev), page, offset,
-				    size, (int)direction);
-#endif
-	return sbus_map_single(dev, page_address(page) + offset,
-			       size, (int)direction);
-}
-
-static void dma32_unmap_page(struct device *dev, dma_addr_t dma_address,
-			     size_t size, enum dma_data_direction direction)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type) {
-		pci_unmap_page(to_pci_dev(dev), dma_address,
-			       size, (int)direction);
-		return;
-	}
-#endif
-	sbus_unmap_single(dev, dma_address, size, (int)direction);
-}
-
-static int dma32_map_sg(struct device *dev, struct scatterlist *sg,
-			int nents, enum dma_data_direction direction)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type)
-		return pci_map_sg(to_pci_dev(dev), sg, nents, (int)direction);
-#endif
-	return sbus_map_sg(dev, sg, nents, direction);
-}
-
-void dma32_unmap_sg(struct device *dev, struct scatterlist *sg,
-		    int nents, enum dma_data_direction direction)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type) {
-		pci_unmap_sg(to_pci_dev(dev), sg, nents, (int)direction);
-		return;
-	}
-#endif
-	sbus_unmap_sg(dev, sg, nents, (int)direction);
-}
-
-static void dma32_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
-				      size_t size,
-				      enum dma_data_direction direction)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type) {
-		pci_dma_sync_single_for_cpu(to_pci_dev(dev), dma_handle,
-					    size, (int)direction);
-		return;
-	}
-#endif
-	sbus_dma_sync_single_for_cpu(dev, dma_handle, size, (int) direction);
-}
-
-static void dma32_sync_single_for_device(struct device *dev,
-					 dma_addr_t dma_handle, size_t size,
-					 enum dma_data_direction direction)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type) {
-		pci_dma_sync_single_for_device(to_pci_dev(dev), dma_handle,
-					       size, (int)direction);
-		return;
-	}
-#endif
-	sbus_dma_sync_single_for_device(dev, dma_handle, size, (int) direction);
-}
-
-static void dma32_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
-				  int nelems, enum dma_data_direction direction)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type) {
-		pci_dma_sync_sg_for_cpu(to_pci_dev(dev), sg,
-					nelems, (int)direction);
-		return;
-	}
-#endif
-	BUG();
-}
-
-static void dma32_sync_sg_for_device(struct device *dev,
-				     struct scatterlist *sg, int nelems,
-				     enum dma_data_direction direction)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type) {
-		pci_dma_sync_sg_for_device(to_pci_dev(dev), sg,
-					   nelems, (int)direction);
-		return;
-	}
-#endif
-	BUG();
-}
-
-static const struct dma_ops dma32_dma_ops = {
-	.alloc_coherent		= dma32_alloc_coherent,
-	.free_coherent		= dma32_free_coherent,
-	.map_page		= dma32_map_page,
-	.unmap_page		= dma32_unmap_page,
-	.map_sg			= dma32_map_sg,
-	.unmap_sg		= dma32_unmap_sg,
-	.sync_single_for_cpu	= dma32_sync_single_for_cpu,
-	.sync_single_for_device	= dma32_sync_single_for_device,
-	.sync_sg_for_cpu	= dma32_sync_sg_for_cpu,
-	.sync_sg_for_device	= dma32_sync_sg_for_device,
-};
-
-const struct dma_ops *dma_ops = &dma32_dma_ops;
-EXPORT_SYMBOL(dma_ops);
+fs_initcall(dma_init);
diff --git a/arch/sparc/kernel/dma.h b/arch/sparc/kernel/dma.h
deleted file mode 100644
index f8d8951..0000000
--- a/arch/sparc/kernel/dma.h
+++ /dev/null
@@ -1,14 +0,0 @@
-void *sbus_alloc_consistent(struct device *dev, long len, u32 *dma_addrp);
-void sbus_free_consistent(struct device *dev, long n, void *p, u32 ba);
-dma_addr_t sbus_map_single(struct device *dev, void *va,
-			   size_t len, int direction);
-void sbus_unmap_single(struct device *dev, dma_addr_t ba,
-		       size_t n, int direction);
-int sbus_map_sg(struct device *dev, struct scatterlist *sg,
-		int n, int direction);
-void sbus_unmap_sg(struct device *dev, struct scatterlist *sg,
-		   int n, int direction);
-void sbus_dma_sync_single_for_cpu(struct device *dev, dma_addr_t ba,
-				  size_t size, int direction);
-void sbus_dma_sync_single_for_device(struct device *dev, dma_addr_t ba,
-				     size_t size, int direction);
diff --git a/arch/sparc/kernel/iommu.c b/arch/sparc/kernel/iommu.c
index 0aeaefe..7690cc2 100644
--- a/arch/sparc/kernel/iommu.c
+++ b/arch/sparc/kernel/iommu.c
@@ -353,7 +353,8 @@ static void dma_4u_free_coherent(struct device *dev, size_t size,
 
 static dma_addr_t dma_4u_map_page(struct device *dev, struct page *page,
 				  unsigned long offset, size_t sz,
-				  enum dma_data_direction direction)
+				  enum dma_data_direction direction,
+				  struct dma_attrs *attrs)
 {
 	struct iommu *iommu;
 	struct strbuf *strbuf;
@@ -474,7 +475,8 @@ do_flush_sync:
 }
 
 static void dma_4u_unmap_page(struct device *dev, dma_addr_t bus_addr,
-			      size_t sz, enum dma_data_direction direction)
+			      size_t sz, enum dma_data_direction direction,
+			      struct dma_attrs *attrs)
 {
 	struct iommu *iommu;
 	struct strbuf *strbuf;
@@ -520,7 +522,8 @@ static void dma_4u_unmap_page(struct device *dev, dma_addr_t bus_addr,
 }
 
 static int dma_4u_map_sg(struct device *dev, struct scatterlist *sglist,
-			 int nelems, enum dma_data_direction direction)
+			 int nelems, enum dma_data_direction direction,
+			 struct dma_attrs *attrs)
 {
 	struct scatterlist *s, *outs, *segstart;
 	unsigned long flags, handle, prot, ctx;
@@ -691,7 +694,8 @@ static unsigned long fetch_sg_ctx(struct iommu *iommu, struct scatterlist *sg)
 }
 
 static void dma_4u_unmap_sg(struct device *dev, struct scatterlist *sglist,
-			    int nelems, enum dma_data_direction direction)
+			    int nelems, enum dma_data_direction direction,
+			    struct dma_attrs *attrs)
 {
 	unsigned long flags, ctx;
 	struct scatterlist *sg;
@@ -822,7 +826,7 @@ static void dma_4u_sync_sg_for_cpu(struct device *dev,
 	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
-static const struct dma_ops sun4u_dma_ops = {
+static struct dma_map_ops sun4u_dma_ops = {
 	.alloc_coherent		= dma_4u_alloc_coherent,
 	.free_coherent		= dma_4u_free_coherent,
 	.map_page		= dma_4u_map_page,
@@ -833,9 +837,11 @@ static const struct dma_ops sun4u_dma_ops = {
 	.sync_sg_for_cpu	= dma_4u_sync_sg_for_cpu,
 };
 
-const struct dma_ops *dma_ops = &sun4u_dma_ops;
+struct dma_map_ops *dma_ops = &sun4u_dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
+extern int pci64_dma_supported(struct pci_dev *pdev, u64 device_mask);
+
 int dma_supported(struct device *dev, u64 device_mask)
 {
 	struct iommu *iommu = dev->archdata.iommu;
@@ -849,7 +855,7 @@ int dma_supported(struct device *dev, u64 device_mask)
 
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type)
-		return pci_dma_supported(to_pci_dev(dev), device_mask);
+		return pci64_dma_supported(to_pci_dev(dev), device_mask);
 #endif
 
 	return 0;
diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 87ea0d0..edbea23 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -48,8 +48,6 @@
 #include <asm/iommu.h>
 #include <asm/io-unit.h>
 
-#include "dma.h"
-
 #define mmu_inval_dma_area(p, l)	/* Anton pulled it out for 2.4.0-xx */
 
 static struct resource *_sparc_find_resource(struct resource *r,
@@ -246,7 +244,8 @@ EXPORT_SYMBOL(sbus_set_sbus64);
  * Typically devices use them for control blocks.
  * CPU may access them without any explicit flushing.
  */
-void *sbus_alloc_consistent(struct device *dev, long len, u32 *dma_addrp)
+static void *sbus_alloc_coherent(struct device *dev, size_t len,
+				 dma_addr_t *dma_addrp, gfp_t gfp)
 {
 	struct of_device *op = to_of_device(dev);
 	unsigned long len_total = (len + PAGE_SIZE-1) & PAGE_MASK;
@@ -299,7 +298,8 @@ err_nopages:
 	return NULL;
 }
 
-void sbus_free_consistent(struct device *dev, long n, void *p, u32 ba)
+static void sbus_free_coherent(struct device *dev, size_t n, void *p,
+			       dma_addr_t ba)
 {
 	struct resource *res;
 	struct page *pgv;
@@ -317,7 +317,7 @@ void sbus_free_consistent(struct device *dev, long n, void *p, u32 ba)
 
 	n = (n + PAGE_SIZE-1) & PAGE_MASK;
 	if ((res->end-res->start)+1 != n) {
-		printk("sbus_free_consistent: region 0x%lx asked 0x%lx\n",
+		printk("sbus_free_consistent: region 0x%lx asked 0x%zx\n",
 		    (long)((res->end-res->start)+1), n);
 		return;
 	}
@@ -337,8 +337,13 @@ void sbus_free_consistent(struct device *dev, long n, void *p, u32 ba)
  * CPU view of this memory may be inconsistent with
  * a device view and explicit flushing is necessary.
  */
-dma_addr_t sbus_map_single(struct device *dev, void *va, size_t len, int direction)
+static dma_addr_t sbus_map_page(struct device *dev, struct page *page,
+				unsigned long offset, size_t len,
+				enum dma_data_direction dir,
+				struct dma_attrs *attrs)
 {
+	void *va = page_address(page) + offset;
+
 	/* XXX why are some lengths signed, others unsigned? */
 	if (len <= 0) {
 		return 0;
@@ -350,12 +355,14 @@ dma_addr_t sbus_map_single(struct device *dev, void *va, size_t len, int directi
 	return mmu_get_scsi_one(dev, va, len);
 }
 
-void sbus_unmap_single(struct device *dev, dma_addr_t ba, size_t n, int direction)
+static void sbus_unmap_page(struct device *dev, dma_addr_t ba, size_t n,
+			    enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	mmu_release_scsi_one(dev, ba, n);
 }
 
-int sbus_map_sg(struct device *dev, struct scatterlist *sg, int n, int direction)
+static int sbus_map_sg(struct device *dev, struct scatterlist *sg, int n,
+		       enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	mmu_get_scsi_sgl(dev, sg, n);
 
@@ -366,19 +373,38 @@ int sbus_map_sg(struct device *dev, struct scatterlist *sg, int n, int direction
 	return n;
 }
 
-void sbus_unmap_sg(struct device *dev, struct scatterlist *sg, int n, int direction)
+static void sbus_unmap_sg(struct device *dev, struct scatterlist *sg, int n,
+			  enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	mmu_release_scsi_sgl(dev, sg, n);
 }
 
-void sbus_dma_sync_single_for_cpu(struct device *dev, dma_addr_t ba, size_t size, int direction)
+static void sbus_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
+				 int n,	enum dma_data_direction dir)
 {
+	BUG();
 }
 
-void sbus_dma_sync_single_for_device(struct device *dev, dma_addr_t ba, size_t size, int direction)
+static void sbus_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
+				    int n, enum dma_data_direction dir)
 {
+	BUG();
 }
 
+struct dma_map_ops sbus_dma_ops = {
+	.alloc_coherent		= sbus_alloc_coherent,
+	.free_coherent		= sbus_free_coherent,
+	.map_page		= sbus_map_page,
+	.unmap_page		= sbus_unmap_page,
+	.map_sg			= sbus_map_sg,
+	.unmap_sg		= sbus_unmap_sg,
+	.sync_sg_for_cpu	= sbus_sync_sg_for_cpu,
+	.sync_sg_for_device	= sbus_sync_sg_for_device,
+};
+
+struct dma_map_ops *dma_ops = &sbus_dma_ops;
+EXPORT_SYMBOL(dma_ops);
+
 static int __init sparc_register_ioport(void)
 {
 	register_proc_sparc_ioport();
@@ -395,7 +421,8 @@ arch_initcall(sparc_register_ioport);
 /* Allocate and map kernel buffer using consistent mode DMA for a device.
  * hwdev should be valid struct pci_dev pointer for PCI devices.
  */
-void *pci_alloc_consistent(struct pci_dev *pdev, size_t len, dma_addr_t *pba)
+static void *pci32_alloc_coherent(struct device *dev, size_t len,
+				  dma_addr_t *pba, gfp_t gfp)
 {
 	unsigned long len_total = (len + PAGE_SIZE-1) & PAGE_MASK;
 	unsigned long va;
@@ -439,7 +466,6 @@ void *pci_alloc_consistent(struct pci_dev *pdev, size_t len, dma_addr_t *pba)
 	*pba = virt_to_phys(va); /* equals virt_to_bus (R.I.P.) for us. */
 	return (void *) res->start;
 }
-EXPORT_SYMBOL(pci_alloc_consistent);
 
 /* Free and unmap a consistent DMA buffer.
  * cpu_addr is what was returned from pci_alloc_consistent,
@@ -449,7 +475,8 @@ EXPORT_SYMBOL(pci_alloc_consistent);
  * References to the memory and mappings associated with cpu_addr/dma_addr
  * past this call are illegal.
  */
-void pci_free_consistent(struct pci_dev *pdev, size_t n, void *p, dma_addr_t ba)
+static void pci32_free_coherent(struct device *dev, size_t n, void *p,
+				dma_addr_t ba)
 {
 	struct resource *res;
 	unsigned long pgp;
@@ -481,60 +508,18 @@ void pci_free_consistent(struct pci_dev *pdev, size_t n, void *p, dma_addr_t ba)
 
 	free_pages(pgp, get_order(n));
 }
-EXPORT_SYMBOL(pci_free_consistent);
-
-/* Map a single buffer of the indicated size for DMA in streaming mode.
- * The 32-bit bus address to use is returned.
- *
- * Once the device is given the dma address, the device owns this memory
- * until either pci_unmap_single or pci_dma_sync_single_* is performed.
- */
-dma_addr_t pci_map_single(struct pci_dev *hwdev, void *ptr, size_t size,
-    int direction)
-{
-	BUG_ON(direction == PCI_DMA_NONE);
-	/* IIep is write-through, not flushing. */
-	return virt_to_phys(ptr);
-}
-EXPORT_SYMBOL(pci_map_single);
-
-/* Unmap a single streaming mode DMA translation.  The dma_addr and size
- * must match what was provided for in a previous pci_map_single call.  All
- * other usages are undefined.
- *
- * After this call, reads by the cpu to the buffer are guaranteed to see
- * whatever the device wrote there.
- */
-void pci_unmap_single(struct pci_dev *hwdev, dma_addr_t ba, size_t size,
-    int direction)
-{
-	BUG_ON(direction == PCI_DMA_NONE);
-	if (direction != PCI_DMA_TODEVICE) {
-		mmu_inval_dma_area((unsigned long)phys_to_virt(ba),
-		    (size + PAGE_SIZE-1) & PAGE_MASK);
-	}
-}
-EXPORT_SYMBOL(pci_unmap_single);
 
 /*
  * Same as pci_map_single, but with pages.
  */
-dma_addr_t pci_map_page(struct pci_dev *hwdev, struct page *page,
-			unsigned long offset, size_t size, int direction)
+static dma_addr_t pci32_map_page(struct device *dev, struct page *page,
+				 unsigned long offset, size_t size,
+				 enum dma_data_direction dir,
+				 struct dma_attrs *attrs)
 {
-	BUG_ON(direction == PCI_DMA_NONE);
 	/* IIep is write-through, not flushing. */
 	return page_to_phys(page) + offset;
 }
-EXPORT_SYMBOL(pci_map_page);
-
-void pci_unmap_page(struct pci_dev *hwdev,
-			dma_addr_t dma_address, size_t size, int direction)
-{
-	BUG_ON(direction == PCI_DMA_NONE);
-	/* mmu_inval_dma_area XXX */
-}
-EXPORT_SYMBOL(pci_unmap_page);
 
 /* Map a set of buffers described by scatterlist in streaming
  * mode for DMA.  This is the scather-gather version of the
@@ -551,13 +536,13 @@ EXPORT_SYMBOL(pci_unmap_page);
  * Device ownership issues as mentioned above for pci_map_single are
  * the same here.
  */
-int pci_map_sg(struct pci_dev *hwdev, struct scatterlist *sgl, int nents,
-    int direction)
+static int pci32_map_sg(struct device *device, struct scatterlist *sgl,
+			int nents, enum dma_data_direction dir,
+			struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
 	int n;
 
-	BUG_ON(direction == PCI_DMA_NONE);
 	/* IIep is write-through, not flushing. */
 	for_each_sg(sgl, sg, nents, n) {
 		BUG_ON(page_address(sg_page(sg)) == NULL);
@@ -566,20 +551,19 @@ int pci_map_sg(struct pci_dev *hwdev, struct scatterlist *sgl, int nents,
 	}
 	return nents;
 }
-EXPORT_SYMBOL(pci_map_sg);
 
 /* Unmap a set of streaming mode DMA translations.
  * Again, cpu read rules concerning calls here are the same as for
  * pci_unmap_single() above.
  */
-void pci_unmap_sg(struct pci_dev *hwdev, struct scatterlist *sgl, int nents,
-    int direction)
+static void pci32_unmap_sg(struct device *dev, struct scatterlist *sgl,
+			   int nents, enum dma_data_direction dir,
+			   struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
 	int n;
 
-	BUG_ON(direction == PCI_DMA_NONE);
-	if (direction != PCI_DMA_TODEVICE) {
+	if (dir != PCI_DMA_TODEVICE) {
 		for_each_sg(sgl, sg, nents, n) {
 			BUG_ON(page_address(sg_page(sg)) == NULL);
 			mmu_inval_dma_area(
@@ -588,7 +572,6 @@ void pci_unmap_sg(struct pci_dev *hwdev, struct scatterlist *sgl, int nents,
 		}
 	}
 }
-EXPORT_SYMBOL(pci_unmap_sg);
 
 /* Make physical memory consistent for a single
  * streaming mode DMA translation before or after a transfer.
@@ -600,25 +583,23 @@ EXPORT_SYMBOL(pci_unmap_sg);
  * must first perform a pci_dma_sync_for_device, and then the
  * device again owns the buffer.
  */
-void pci_dma_sync_single_for_cpu(struct pci_dev *hwdev, dma_addr_t ba, size_t size, int direction)
+static void pci32_sync_single_for_cpu(struct device *dev, dma_addr_t ba,
+				      size_t size, enum dma_data_direction dir)
 {
-	BUG_ON(direction == PCI_DMA_NONE);
-	if (direction != PCI_DMA_TODEVICE) {
+	if (dir != PCI_DMA_TODEVICE) {
 		mmu_inval_dma_area((unsigned long)phys_to_virt(ba),
 		    (size + PAGE_SIZE-1) & PAGE_MASK);
 	}
 }
-EXPORT_SYMBOL(pci_dma_sync_single_for_cpu);
 
-void pci_dma_sync_single_for_device(struct pci_dev *hwdev, dma_addr_t ba, size_t size, int direction)
+static void pci32_sync_single_for_device(struct device *dev, dma_addr_t ba,
+					 size_t size, enum dma_data_direction dir)
 {
-	BUG_ON(direction == PCI_DMA_NONE);
-	if (direction != PCI_DMA_TODEVICE) {
+	if (dir != PCI_DMA_TODEVICE) {
 		mmu_inval_dma_area((unsigned long)phys_to_virt(ba),
 		    (size + PAGE_SIZE-1) & PAGE_MASK);
 	}
 }
-EXPORT_SYMBOL(pci_dma_sync_single_for_device);
 
 /* Make physical memory consistent for a set of streaming
  * mode DMA translations after a transfer.
@@ -626,13 +607,13 @@ EXPORT_SYMBOL(pci_dma_sync_single_for_device);
  * The same as pci_dma_sync_single_* but for a scatter-gather list,
  * same rules and usage.
  */
-void pci_dma_sync_sg_for_cpu(struct pci_dev *hwdev, struct scatterlist *sgl, int nents, int direction)
+static void pci32_sync_sg_for_cpu(struct device *dev, struct scatterlist *sgl,
+				  int nents, enum dma_data_direction dir)
 {
 	struct scatterlist *sg;
 	int n;
 
-	BUG_ON(direction == PCI_DMA_NONE);
-	if (direction != PCI_DMA_TODEVICE) {
+	if (dir != PCI_DMA_TODEVICE) {
 		for_each_sg(sgl, sg, nents, n) {
 			BUG_ON(page_address(sg_page(sg)) == NULL);
 			mmu_inval_dma_area(
@@ -641,15 +622,14 @@ void pci_dma_sync_sg_for_cpu(struct pci_dev *hwdev, struct scatterlist *sgl, int
 		}
 	}
 }
-EXPORT_SYMBOL(pci_dma_sync_sg_for_cpu);
 
-void pci_dma_sync_sg_for_device(struct pci_dev *hwdev, struct scatterlist *sgl, int nents, int direction)
+static void pci32_sync_sg_for_device(struct device *device, struct scatterlist *sgl,
+				     int nents, enum dma_data_direction dir)
 {
 	struct scatterlist *sg;
 	int n;
 
-	BUG_ON(direction == PCI_DMA_NONE);
-	if (direction != PCI_DMA_TODEVICE) {
+	if (dir != PCI_DMA_TODEVICE) {
 		for_each_sg(sgl, sg, nents, n) {
 			BUG_ON(page_address(sg_page(sg)) == NULL);
 			mmu_inval_dma_area(
@@ -658,9 +638,49 @@ void pci_dma_sync_sg_for_device(struct pci_dev *hwdev, struct scatterlist *sgl,
 		}
 	}
 }
-EXPORT_SYMBOL(pci_dma_sync_sg_for_device);
+
+struct dma_map_ops pci32_dma_ops = {
+	.alloc_coherent		= pci32_alloc_coherent,
+	.free_coherent		= pci32_free_coherent,
+	.map_page		= pci32_map_page,
+	.map_sg			= pci32_map_sg,
+	.unmap_sg		= pci32_unmap_sg,
+	.sync_single_for_cpu	= pci32_sync_single_for_cpu,
+	.sync_single_for_device	= pci32_sync_single_for_device,
+	.sync_sg_for_cpu	= pci32_sync_sg_for_cpu,
+	.sync_sg_for_device	= pci32_sync_sg_for_device,
+};
+EXPORT_SYMBOL(pci32_dma_ops);
+
 #endif /* CONFIG_PCI */
 
+/*
+ * Return whether the given PCI device DMA address mask can be
+ * supported properly.  For example, if your device can only drive the
+ * low 24-bits during PCI bus mastering, then you would pass
+ * 0x00ffffff as the mask to this function.
+ */
+int dma_supported(struct device *dev, u64 mask)
+{
+#ifdef CONFIG_PCI
+	if (dev->bus == &pci_bus_type)
+		return 1;
+#endif
+	return 0;
+}
+EXPORT_SYMBOL(dma_supported);
+
+int dma_set_mask(struct device *dev, u64 dma_mask)
+{
+#ifdef CONFIG_PCI
+	if (dev->bus == &pci_bus_type)
+		return pci_set_dma_mask(to_pci_dev(dev), dma_mask);
+#endif
+	return -EOPNOTSUPP;
+}
+EXPORT_SYMBOL(dma_set_mask);
+
+
 #ifdef CONFIG_PROC_FS
 
 static int
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 57859ad..c686486 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -1039,7 +1039,7 @@ static void ali_sound_dma_hack(struct pci_dev *pdev, int set_bit)
 	pci_dev_put(ali_isa_bridge);
 }
 
-int pci_dma_supported(struct pci_dev *pdev, u64 device_mask)
+int pci64_dma_supported(struct pci_dev *pdev, u64 device_mask)
 {
 	u64 dma_addr_mask;
 
diff --git a/arch/sparc/kernel/pci_sun4v.c b/arch/sparc/kernel/pci_sun4v.c
index 2485eaa..23c33ff 100644
--- a/arch/sparc/kernel/pci_sun4v.c
+++ b/arch/sparc/kernel/pci_sun4v.c
@@ -232,7 +232,8 @@ static void dma_4v_free_coherent(struct device *dev, size_t size, void *cpu,
 
 static dma_addr_t dma_4v_map_page(struct device *dev, struct page *page,
 				  unsigned long offset, size_t sz,
-				  enum dma_data_direction direction)
+				  enum dma_data_direction direction,
+				  struct dma_attrs *attrs)
 {
 	struct iommu *iommu;
 	unsigned long flags, npages, oaddr;
@@ -296,7 +297,8 @@ iommu_map_fail:
 }
 
 static void dma_4v_unmap_page(struct device *dev, dma_addr_t bus_addr,
-			      size_t sz, enum dma_data_direction direction)
+			      size_t sz, enum dma_data_direction direction,
+			      struct dma_attrs *attrs)
 {
 	struct pci_pbm_info *pbm;
 	struct iommu *iommu;
@@ -336,7 +338,8 @@ static void dma_4v_unmap_page(struct device *dev, dma_addr_t bus_addr,
 }
 
 static int dma_4v_map_sg(struct device *dev, struct scatterlist *sglist,
-			 int nelems, enum dma_data_direction direction)
+			 int nelems, enum dma_data_direction direction,
+			 struct dma_attrs *attrs)
 {
 	struct scatterlist *s, *outs, *segstart;
 	unsigned long flags, handle, prot;
@@ -478,7 +481,8 @@ iommu_map_failed:
 }
 
 static void dma_4v_unmap_sg(struct device *dev, struct scatterlist *sglist,
-			    int nelems, enum dma_data_direction direction)
+			    int nelems, enum dma_data_direction direction,
+			    struct dma_attrs *attrs)
 {
 	struct pci_pbm_info *pbm;
 	struct scatterlist *sg;
@@ -521,29 +525,13 @@ static void dma_4v_unmap_sg(struct device *dev, struct scatterlist *sglist,
 	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
-static void dma_4v_sync_single_for_cpu(struct device *dev,
-				       dma_addr_t bus_addr, size_t sz,
-				       enum dma_data_direction direction)
-{
-	/* Nothing to do... */
-}
-
-static void dma_4v_sync_sg_for_cpu(struct device *dev,
-				   struct scatterlist *sglist, int nelems,
-				   enum dma_data_direction direction)
-{
-	/* Nothing to do... */
-}
-
-static const struct dma_ops sun4v_dma_ops = {
+static struct dma_map_ops sun4v_dma_ops = {
 	.alloc_coherent			= dma_4v_alloc_coherent,
 	.free_coherent			= dma_4v_free_coherent,
 	.map_page			= dma_4v_map_page,
 	.unmap_page			= dma_4v_unmap_page,
 	.map_sg				= dma_4v_map_sg,
 	.unmap_sg			= dma_4v_unmap_sg,
-	.sync_single_for_cpu		= dma_4v_sync_single_for_cpu,
-	.sync_sg_for_cpu		= dma_4v_sync_sg_for_cpu,
 };
 
 static void __devinit pci_sun4v_scan_bus(struct pci_pbm_info *pbm,
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 13ffa5d..1d9c18a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -586,7 +586,6 @@ config GART_IOMMU
 	bool "GART IOMMU support" if EMBEDDED
 	default y
 	select SWIOTLB
-	select AGP
 	depends on X86_64 && PCI
 	---help---
 	  Support for full DMA access of devices with 32bit memory access only
diff --git a/arch/x86/include/asm/amd_iommu.h b/arch/x86/include/asm/amd_iommu.h
index bdf96f1..ac95995 100644
--- a/arch/x86/include/asm/amd_iommu.h
+++ b/arch/x86/include/asm/amd_iommu.h
@@ -25,6 +25,7 @@
 #ifdef CONFIG_AMD_IOMMU
 extern int amd_iommu_init(void);
 extern int amd_iommu_init_dma_ops(void);
+extern int amd_iommu_init_passthrough(void);
 extern void amd_iommu_detect(void);
 extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
 extern void amd_iommu_flush_all_domains(void);
diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 0c878ca..2a2cc7a 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -143,22 +143,29 @@
 #define EVT_BUFFER_SIZE		8192 /* 512 entries */
 #define EVT_LEN_MASK		(0x9ULL << 56)
 
+#define PAGE_MODE_NONE    0x00
 #define PAGE_MODE_1_LEVEL 0x01
 #define PAGE_MODE_2_LEVEL 0x02
 #define PAGE_MODE_3_LEVEL 0x03
-
-#define IOMMU_PDE_NL_0   0x000ULL
-#define IOMMU_PDE_NL_1   0x200ULL
-#define IOMMU_PDE_NL_2   0x400ULL
-#define IOMMU_PDE_NL_3   0x600ULL
-
-#define IOMMU_PTE_L2_INDEX(address) (((address) >> 30) & 0x1ffULL)
-#define IOMMU_PTE_L1_INDEX(address) (((address) >> 21) & 0x1ffULL)
-#define IOMMU_PTE_L0_INDEX(address) (((address) >> 12) & 0x1ffULL)
-
-#define IOMMU_MAP_SIZE_L1 (1ULL << 21)
-#define IOMMU_MAP_SIZE_L2 (1ULL << 30)
-#define IOMMU_MAP_SIZE_L3 (1ULL << 39)
+#define PAGE_MODE_4_LEVEL 0x04
+#define PAGE_MODE_5_LEVEL 0x05
+#define PAGE_MODE_6_LEVEL 0x06
+
+#define PM_LEVEL_SHIFT(x)	(12 + ((x) * 9))
+#define PM_LEVEL_SIZE(x)	(((x) < 6) ? \
+				  ((1ULL << PM_LEVEL_SHIFT((x))) - 1): \
+				   (0xffffffffffffffffULL))
+#define PM_LEVEL_INDEX(x, a)	(((a) >> PM_LEVEL_SHIFT((x))) & 0x1ffULL)
+#define PM_LEVEL_ENC(x)		(((x) << 9) & 0xe00ULL)
+#define PM_LEVEL_PDE(x, a)	((a) | PM_LEVEL_ENC((x)) | \
+				 IOMMU_PTE_P | IOMMU_PTE_IR | IOMMU_PTE_IW)
+#define PM_PTE_LEVEL(pte)	(((pte) >> 9) & 0x7ULL)
+
+#define PM_MAP_4k		0
+#define PM_ADDR_MASK		0x000ffffffffff000ULL
+#define PM_MAP_MASK(lvl)	(PM_ADDR_MASK & \
+				(~((1ULL << (12 + ((lvl) * 9))) - 1)))
+#define PM_ALIGNED(lvl, addr)	((PM_MAP_MASK(lvl) & (addr)) == (addr))
 
 #define IOMMU_PTE_P  (1ULL << 0)
 #define IOMMU_PTE_TV (1ULL << 1)
@@ -167,11 +174,6 @@
 #define IOMMU_PTE_IR (1ULL << 61)
 #define IOMMU_PTE_IW (1ULL << 62)
 
-#define IOMMU_L1_PDE(address) \
-	((address) | IOMMU_PDE_NL_1 | IOMMU_PTE_P | IOMMU_PTE_IR | IOMMU_PTE_IW)
-#define IOMMU_L2_PDE(address) \
-	((address) | IOMMU_PDE_NL_2 | IOMMU_PTE_P | IOMMU_PTE_IR | IOMMU_PTE_IW)
-
 #define IOMMU_PAGE_MASK (((1ULL << 52) - 1) & ~0xfffULL)
 #define IOMMU_PTE_PRESENT(pte) ((pte) & IOMMU_PTE_P)
 #define IOMMU_PTE_PAGE(pte) (phys_to_virt((pte) & IOMMU_PAGE_MASK))
@@ -194,11 +196,14 @@
 #define PD_DMA_OPS_MASK		(1UL << 0) /* domain used for dma_ops */
 #define PD_DEFAULT_MASK		(1UL << 1) /* domain is a default dma_ops
 					      domain for an IOMMU */
+#define PD_PASSTHROUGH_MASK	(1UL << 2) /* domain has no page
+					      translation */
+
 extern bool amd_iommu_dump;
 #define DUMP_printk(format, arg...)					\
 	do {								\
 		if (amd_iommu_dump)						\
-			printk(KERN_INFO "AMD IOMMU: " format, ## arg);	\
+			printk(KERN_INFO "AMD-Vi: " format, ## arg);	\
 	} while(0);
 
 /*
@@ -226,6 +231,7 @@ struct protection_domain {
 	int mode;		/* paging mode (0-6 levels) */
 	u64 *pt_root;		/* page table root pointer */
 	unsigned long flags;	/* flags to find out type of domain */
+	bool updated;		/* complete domain flush required */
 	unsigned dev_cnt;	/* devices assigned to this domain */
 	void *priv;		/* private data */
 };
@@ -337,6 +343,9 @@ struct amd_iommu {
 	/* if one, we need to send a completion wait command */
 	bool need_sync;
 
+	/* becomes true if a command buffer reset is running */
+	bool reset_in_progress;
+
 	/* default dma_ops domain for that IOMMU */
 	struct dma_ops_domain *default_dom;
 };
@@ -457,4 +466,7 @@ static inline void amd_iommu_stats_init(void) { }
 
 #endif /* CONFIG_AMD_IOMMU_STATS */
 
+/* some function prototypes */
+extern void amd_iommu_reset_cmd_buffer(struct amd_iommu *iommu);
+
 #endif /* _ASM_X86_AMD_IOMMU_TYPES_H */
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 1c3f943..0ee770d 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -55,6 +55,24 @@ extern int dma_set_mask(struct device *dev, u64 mask);
 extern void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 					dma_addr_t *dma_addr, gfp_t flag);
 
+static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
+{
+	if (!dev->dma_mask)
+		return 0;
+
+	return addr + size <= *dev->dma_mask;
+}
+
+static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
+{
+	return paddr;
+}
+
+static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
+{
+	return daddr;
+}
+
 static inline void
 dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	enum dma_data_direction dir)
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 6c99f50..98f230f 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -41,9 +41,13 @@ static DEFINE_RWLOCK(amd_iommu_devtable_lock);
 static LIST_HEAD(iommu_pd_list);
 static DEFINE_SPINLOCK(iommu_pd_list_lock);
 
-#ifdef CONFIG_IOMMU_API
+/*
+ * Domain for untranslated devices - only allocated
+ * if iommu=pt passed on kernel cmd line.
+ */
+static struct protection_domain *pt_domain;
+
 static struct iommu_ops amd_iommu_ops;
-#endif
 
 /*
  * general struct to manage commands send to an IOMMU
@@ -55,16 +59,16 @@ struct iommu_cmd {
 static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 			     struct unity_map_entry *e);
 static struct dma_ops_domain *find_protection_domain(u16 devid);
-static u64* alloc_pte(struct protection_domain *dom,
-		      unsigned long address, u64
-		      **pte_page, gfp_t gfp);
+static u64 *alloc_pte(struct protection_domain *domain,
+		      unsigned long address, int end_lvl,
+		      u64 **pte_page, gfp_t gfp);
 static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
 				      unsigned long start_page,
 				      unsigned int pages);
-
-#ifndef BUS_NOTIFY_UNBOUND_DRIVER
-#define BUS_NOTIFY_UNBOUND_DRIVER 0x0005
-#endif
+static void reset_iommu_command_buffer(struct amd_iommu *iommu);
+static u64 *fetch_pte(struct protection_domain *domain,
+		      unsigned long address, int map_size);
+static void update_domain(struct protection_domain *domain);
 
 #ifdef CONFIG_AMD_IOMMU_STATS
 
@@ -138,7 +142,25 @@ static int iommu_has_npcache(struct amd_iommu *iommu)
  *
  ****************************************************************************/
 
-static void iommu_print_event(void *__evt)
+static void dump_dte_entry(u16 devid)
+{
+	int i;
+
+	for (i = 0; i < 8; ++i)
+		pr_err("AMD-Vi: DTE[%d]: %08x\n", i,
+			amd_iommu_dev_table[devid].data[i]);
+}
+
+static void dump_command(unsigned long phys_addr)
+{
+	struct iommu_cmd *cmd = phys_to_virt(phys_addr);
+	int i;
+
+	for (i = 0; i < 4; ++i)
+		pr_err("AMD-Vi: CMD[%d]: %08x\n", i, cmd->data[i]);
+}
+
+static void iommu_print_event(struct amd_iommu *iommu, void *__evt)
 {
 	u32 *event = __evt;
 	int type  = (event[1] >> EVENT_TYPE_SHIFT)  & EVENT_TYPE_MASK;
@@ -147,7 +169,7 @@ static void iommu_print_event(void *__evt)
 	int flags = (event[1] >> EVENT_FLAGS_SHIFT) & EVENT_FLAGS_MASK;
 	u64 address = (u64)(((u64)event[3]) << 32) | event[2];
 
-	printk(KERN_ERR "AMD IOMMU: Event logged [");
+	printk(KERN_ERR "AMD-Vi: Event logged [");
 
 	switch (type) {
 	case EVENT_TYPE_ILL_DEV:
@@ -155,6 +177,7 @@ static void iommu_print_event(void *__evt)
 		       "address=0x%016llx flags=0x%04x]\n",
 		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
 		       address, flags);
+		dump_dte_entry(devid);
 		break;
 	case EVENT_TYPE_IO_FAULT:
 		printk("IO_PAGE_FAULT device=%02x:%02x.%x "
@@ -176,6 +199,8 @@ static void iommu_print_event(void *__evt)
 		break;
 	case EVENT_TYPE_ILL_CMD:
 		printk("ILLEGAL_COMMAND_ERROR address=0x%016llx]\n", address);
+		reset_iommu_command_buffer(iommu);
+		dump_command(address);
 		break;
 	case EVENT_TYPE_CMD_HARD_ERR:
 		printk("COMMAND_HARDWARE_ERROR address=0x%016llx "
@@ -209,7 +234,7 @@ static void iommu_poll_events(struct amd_iommu *iommu)
 	tail = readl(iommu->mmio_base + MMIO_EVT_TAIL_OFFSET);
 
 	while (head != tail) {
-		iommu_print_event(iommu->evt_buf + head);
+		iommu_print_event(iommu, iommu->evt_buf + head);
 		head = (head + EVENT_ENTRY_SIZE) % iommu->evt_buf_size;
 	}
 
@@ -296,8 +321,11 @@ static void __iommu_wait_for_completion(struct amd_iommu *iommu)
 	status &= ~MMIO_STATUS_COM_WAIT_INT_MASK;
 	writel(status, iommu->mmio_base + MMIO_STATUS_OFFSET);
 
-	if (unlikely(i == EXIT_LOOP_COUNT))
-		panic("AMD IOMMU: Completion wait loop failed\n");
+	if (unlikely(i == EXIT_LOOP_COUNT)) {
+		spin_unlock(&iommu->lock);
+		reset_iommu_command_buffer(iommu);
+		spin_lock(&iommu->lock);
+	}
 }
 
 /*
@@ -445,47 +473,78 @@ static void iommu_flush_tlb_pde(struct amd_iommu *iommu, u16 domid)
 }
 
 /*
+ * This function flushes one domain on one IOMMU
+ */
+static void flush_domain_on_iommu(struct amd_iommu *iommu, u16 domid)
+{
+	struct iommu_cmd cmd;
+	unsigned long flags;
+
+	__iommu_build_inv_iommu_pages(&cmd, CMD_INV_IOMMU_ALL_PAGES_ADDRESS,
+				      domid, 1, 1);
+
+	spin_lock_irqsave(&iommu->lock, flags);
+	__iommu_queue_command(iommu, &cmd);
+	__iommu_completion_wait(iommu);
+	__iommu_wait_for_completion(iommu);
+	spin_unlock_irqrestore(&iommu->lock, flags);
+}
+
+static void flush_all_domains_on_iommu(struct amd_iommu *iommu)
+{
+	int i;
+
+	for (i = 1; i < MAX_DOMAIN_ID; ++i) {
+		if (!test_bit(i, amd_iommu_pd_alloc_bitmap))
+			continue;
+		flush_domain_on_iommu(iommu, i);
+	}
+
+}
+
+/*
  * This function is used to flush the IO/TLB for a given protection domain
  * on every IOMMU in the system
  */
 static void iommu_flush_domain(u16 domid)
 {
-	unsigned long flags;
 	struct amd_iommu *iommu;
-	struct iommu_cmd cmd;
 
 	INC_STATS_COUNTER(domain_flush_all);
 
-	__iommu_build_inv_iommu_pages(&cmd, CMD_INV_IOMMU_ALL_PAGES_ADDRESS,
-				      domid, 1, 1);
-
-	for_each_iommu(iommu) {
-		spin_lock_irqsave(&iommu->lock, flags);
-		__iommu_queue_command(iommu, &cmd);
-		__iommu_completion_wait(iommu);
-		__iommu_wait_for_completion(iommu);
-		spin_unlock_irqrestore(&iommu->lock, flags);
-	}
+	for_each_iommu(iommu)
+		flush_domain_on_iommu(iommu, domid);
 }
 
 void amd_iommu_flush_all_domains(void)
 {
+	struct amd_iommu *iommu;
+
+	for_each_iommu(iommu)
+		flush_all_domains_on_iommu(iommu);
+}
+
+static void flush_all_devices_for_iommu(struct amd_iommu *iommu)
+{
 	int i;
 
-	for (i = 1; i < MAX_DOMAIN_ID; ++i) {
-		if (!test_bit(i, amd_iommu_pd_alloc_bitmap))
+	for (i = 0; i <= amd_iommu_last_bdf; ++i) {
+		if (iommu != amd_iommu_rlookup_table[i])
 			continue;
-		iommu_flush_domain(i);
+
+		iommu_queue_inv_dev_entry(iommu, i);
+		iommu_completion_wait(iommu);
 	}
 }
 
-void amd_iommu_flush_all_devices(void)
+static void flush_devices_by_domain(struct protection_domain *domain)
 {
 	struct amd_iommu *iommu;
 	int i;
 
 	for (i = 0; i <= amd_iommu_last_bdf; ++i) {
-		if (amd_iommu_pd_table[i] == NULL)
+		if ((domain == NULL && amd_iommu_pd_table[i] == NULL) ||
+		    (amd_iommu_pd_table[i] != domain))
 			continue;
 
 		iommu = amd_iommu_rlookup_table[i];
@@ -497,6 +556,27 @@ void amd_iommu_flush_all_devices(void)
 	}
 }
 
+static void reset_iommu_command_buffer(struct amd_iommu *iommu)
+{
+	pr_err("AMD-Vi: Resetting IOMMU command buffer\n");
+
+	if (iommu->reset_in_progress)
+		panic("AMD-Vi: ILLEGAL_COMMAND_ERROR while resetting command buffer\n");
+
+	iommu->reset_in_progress = true;
+
+	amd_iommu_reset_cmd_buffer(iommu);
+	flush_all_devices_for_iommu(iommu);
+	flush_all_domains_on_iommu(iommu);
+
+	iommu->reset_in_progress = false;
+}
+
+void amd_iommu_flush_all_devices(void)
+{
+	flush_devices_by_domain(NULL);
+}
+
 /****************************************************************************
  *
  * The functions below are used the create the page table mappings for
@@ -514,18 +594,21 @@ void amd_iommu_flush_all_devices(void)
 static int iommu_map_page(struct protection_domain *dom,
 			  unsigned long bus_addr,
 			  unsigned long phys_addr,
-			  int prot)
+			  int prot,
+			  int map_size)
 {
 	u64 __pte, *pte;
 
 	bus_addr  = PAGE_ALIGN(bus_addr);
 	phys_addr = PAGE_ALIGN(phys_addr);
 
-	/* only support 512GB address spaces for now */
-	if (bus_addr > IOMMU_MAP_SIZE_L3 || !(prot & IOMMU_PROT_MASK))
+	BUG_ON(!PM_ALIGNED(map_size, bus_addr));
+	BUG_ON(!PM_ALIGNED(map_size, phys_addr));
+
+	if (!(prot & IOMMU_PROT_MASK))
 		return -EINVAL;
 
-	pte = alloc_pte(dom, bus_addr, NULL, GFP_KERNEL);
+	pte = alloc_pte(dom, bus_addr, map_size, NULL, GFP_KERNEL);
 
 	if (IOMMU_PTE_PRESENT(*pte))
 		return -EBUSY;
@@ -538,29 +621,18 @@ static int iommu_map_page(struct protection_domain *dom,
 
 	*pte = __pte;
 
+	update_domain(dom);
+
 	return 0;
 }
 
 static void iommu_unmap_page(struct protection_domain *dom,
-			     unsigned long bus_addr)
+			     unsigned long bus_addr, int map_size)
 {
-	u64 *pte;
-
-	pte = &dom->pt_root[IOMMU_PTE_L2_INDEX(bus_addr)];
-
-	if (!IOMMU_PTE_PRESENT(*pte))
-		return;
-
-	pte = IOMMU_PTE_PAGE(*pte);
-	pte = &pte[IOMMU_PTE_L1_INDEX(bus_addr)];
+	u64 *pte = fetch_pte(dom, bus_addr, map_size);
 
-	if (!IOMMU_PTE_PRESENT(*pte))
-		return;
-
-	pte = IOMMU_PTE_PAGE(*pte);
-	pte = &pte[IOMMU_PTE_L1_INDEX(bus_addr)];
-
-	*pte = 0;
+	if (pte)
+		*pte = 0;
 }
 
 /*
@@ -615,7 +687,8 @@ static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 
 	for (addr = e->address_start; addr < e->address_end;
 	     addr += PAGE_SIZE) {
-		ret = iommu_map_page(&dma_dom->domain, addr, addr, e->prot);
+		ret = iommu_map_page(&dma_dom->domain, addr, addr, e->prot,
+				     PM_MAP_4k);
 		if (ret)
 			return ret;
 		/*
@@ -670,24 +743,29 @@ static int init_unity_mappings_for_device(struct dma_ops_domain *dma_dom,
  * This function checks if there is a PTE for a given dma address. If
  * there is one, it returns the pointer to it.
  */
-static u64* fetch_pte(struct protection_domain *domain,
-		      unsigned long address)
+static u64 *fetch_pte(struct protection_domain *domain,
+		      unsigned long address, int map_size)
 {
+	int level;
 	u64 *pte;
 
-	pte = &domain->pt_root[IOMMU_PTE_L2_INDEX(address)];
+	level =  domain->mode - 1;
+	pte   = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
 
-	if (!IOMMU_PTE_PRESENT(*pte))
-		return NULL;
+	while (level > map_size) {
+		if (!IOMMU_PTE_PRESENT(*pte))
+			return NULL;
 
-	pte = IOMMU_PTE_PAGE(*pte);
-	pte = &pte[IOMMU_PTE_L1_INDEX(address)];
+		level -= 1;
 
-	if (!IOMMU_PTE_PRESENT(*pte))
-		return NULL;
+		pte = IOMMU_PTE_PAGE(*pte);
+		pte = &pte[PM_LEVEL_INDEX(level, address)];
 
-	pte = IOMMU_PTE_PAGE(*pte);
-	pte = &pte[IOMMU_PTE_L0_INDEX(address)];
+		if ((PM_PTE_LEVEL(*pte) == 0) && level != map_size) {
+			pte = NULL;
+			break;
+		}
+	}
 
 	return pte;
 }
@@ -727,7 +805,7 @@ static int alloc_new_range(struct amd_iommu *iommu,
 		u64 *pte, *pte_page;
 
 		for (i = 0; i < num_ptes; ++i) {
-			pte = alloc_pte(&dma_dom->domain, address,
+			pte = alloc_pte(&dma_dom->domain, address, PM_MAP_4k,
 					&pte_page, gfp);
 			if (!pte)
 				goto out_free;
@@ -760,16 +838,20 @@ static int alloc_new_range(struct amd_iommu *iommu,
 	for (i = dma_dom->aperture[index]->offset;
 	     i < dma_dom->aperture_size;
 	     i += PAGE_SIZE) {
-		u64 *pte = fetch_pte(&dma_dom->domain, i);
+		u64 *pte = fetch_pte(&dma_dom->domain, i, PM_MAP_4k);
 		if (!pte || !IOMMU_PTE_PRESENT(*pte))
 			continue;
 
 		dma_ops_reserve_addresses(dma_dom, i << PAGE_SHIFT, 1);
 	}
 
+	update_domain(&dma_dom->domain);
+
 	return 0;
 
 out_free:
+	update_domain(&dma_dom->domain);
+
 	free_page((unsigned long)dma_dom->aperture[index]->bitmap);
 
 	kfree(dma_dom->aperture[index]);
@@ -1009,7 +1091,7 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu)
 	dma_dom->domain.id = domain_id_alloc();
 	if (dma_dom->domain.id == 0)
 		goto free_dma_dom;
-	dma_dom->domain.mode = PAGE_MODE_3_LEVEL;
+	dma_dom->domain.mode = PAGE_MODE_2_LEVEL;
 	dma_dom->domain.pt_root = (void *)get_zeroed_page(GFP_KERNEL);
 	dma_dom->domain.flags = PD_DMA_OPS_MASK;
 	dma_dom->domain.priv = dma_dom;
@@ -1063,6 +1145,41 @@ static struct protection_domain *domain_for_device(u16 devid)
 	return dom;
 }
 
+static void set_dte_entry(u16 devid, struct protection_domain *domain)
+{
+	u64 pte_root = virt_to_phys(domain->pt_root);
+
+	pte_root |= (domain->mode & DEV_ENTRY_MODE_MASK)
+		    << DEV_ENTRY_MODE_SHIFT;
+	pte_root |= IOMMU_PTE_IR | IOMMU_PTE_IW | IOMMU_PTE_P | IOMMU_PTE_TV;
+
+	amd_iommu_dev_table[devid].data[2] = domain->id;
+	amd_iommu_dev_table[devid].data[1] = upper_32_bits(pte_root);
+	amd_iommu_dev_table[devid].data[0] = lower_32_bits(pte_root);
+
+	amd_iommu_pd_table[devid] = domain;
+}
+
+/*
+ * If a device is not yet associated with a domain, this function does
+ * assigns it visible for the hardware
+ */
+static void __attach_device(struct amd_iommu *iommu,
+			    struct protection_domain *domain,
+			    u16 devid)
+{
+	/* lock domain */
+	spin_lock(&domain->lock);
+
+	/* update DTE entry */
+	set_dte_entry(devid, domain);
+
+	domain->dev_cnt += 1;
+
+	/* ready */
+	spin_unlock(&domain->lock);
+}
+
 /*
  * If a device is not yet associated with a domain, this function does
  * assigns it visible for the hardware
@@ -1072,27 +1189,16 @@ static void attach_device(struct amd_iommu *iommu,
 			  u16 devid)
 {
 	unsigned long flags;
-	u64 pte_root = virt_to_phys(domain->pt_root);
-
-	domain->dev_cnt += 1;
-
-	pte_root |= (domain->mode & DEV_ENTRY_MODE_MASK)
-		    << DEV_ENTRY_MODE_SHIFT;
-	pte_root |= IOMMU_PTE_IR | IOMMU_PTE_IW | IOMMU_PTE_P | IOMMU_PTE_TV;
 
 	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
-	amd_iommu_dev_table[devid].data[0] = lower_32_bits(pte_root);
-	amd_iommu_dev_table[devid].data[1] = upper_32_bits(pte_root);
-	amd_iommu_dev_table[devid].data[2] = domain->id;
-
-	amd_iommu_pd_table[devid] = domain;
+	__attach_device(iommu, domain, devid);
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 
-       /*
-        * We might boot into a crash-kernel here. The crashed kernel
-        * left the caches in the IOMMU dirty. So we have to flush
-        * here to evict all dirty stuff.
-        */
+	/*
+	 * We might boot into a crash-kernel here. The crashed kernel
+	 * left the caches in the IOMMU dirty. So we have to flush
+	 * here to evict all dirty stuff.
+	 */
 	iommu_queue_inv_dev_entry(iommu, devid);
 	iommu_flush_tlb_pde(iommu, domain->id);
 }
@@ -1119,6 +1225,15 @@ static void __detach_device(struct protection_domain *domain, u16 devid)
 
 	/* ready */
 	spin_unlock(&domain->lock);
+
+	/*
+	 * If we run in passthrough mode the device must be assigned to the
+	 * passthrough domain if it is detached from any other domain
+	 */
+	if (iommu_pass_through) {
+		struct amd_iommu *iommu = amd_iommu_rlookup_table[devid];
+		__attach_device(iommu, pt_domain, devid);
+	}
 }
 
 /*
@@ -1164,6 +1279,8 @@ static int device_change_notifier(struct notifier_block *nb,
 	case BUS_NOTIFY_UNBOUND_DRIVER:
 		if (!domain)
 			goto out;
+		if (iommu_pass_through)
+			break;
 		detach_device(domain, devid);
 		break;
 	case BUS_NOTIFY_ADD_DEVICE:
@@ -1292,39 +1409,91 @@ static int get_device_resources(struct device *dev,
 	return 1;
 }
 
+static void update_device_table(struct protection_domain *domain)
+{
+	unsigned long flags;
+	int i;
+
+	for (i = 0; i <= amd_iommu_last_bdf; ++i) {
+		if (amd_iommu_pd_table[i] != domain)
+			continue;
+		write_lock_irqsave(&amd_iommu_devtable_lock, flags);
+		set_dte_entry(i, domain);
+		write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
+	}
+}
+
+static void update_domain(struct protection_domain *domain)
+{
+	if (!domain->updated)
+		return;
+
+	update_device_table(domain);
+	flush_devices_by_domain(domain);
+	iommu_flush_domain(domain->id);
+
+	domain->updated = false;
+}
+
 /*
- * If the pte_page is not yet allocated this function is called
+ * This function is used to add another level to an IO page table. Adding
+ * another level increases the size of the address space by 9 bits to a size up
+ * to 64 bits.
  */
-static u64* alloc_pte(struct protection_domain *dom,
-		      unsigned long address, u64 **pte_page, gfp_t gfp)
+static bool increase_address_space(struct protection_domain *domain,
+				   gfp_t gfp)
+{
+	u64 *pte;
+
+	if (domain->mode == PAGE_MODE_6_LEVEL)
+		/* address space already 64 bit large */
+		return false;
+
+	pte = (void *)get_zeroed_page(gfp);
+	if (!pte)
+		return false;
+
+	*pte             = PM_LEVEL_PDE(domain->mode,
+					virt_to_phys(domain->pt_root));
+	domain->pt_root  = pte;
+	domain->mode    += 1;
+	domain->updated  = true;
+
+	return true;
+}
+
+static u64 *alloc_pte(struct protection_domain *domain,
+		      unsigned long address,
+		      int end_lvl,
+		      u64 **pte_page,
+		      gfp_t gfp)
 {
 	u64 *pte, *page;
+	int level;
 
-	pte = &dom->pt_root[IOMMU_PTE_L2_INDEX(address)];
+	while (address > PM_LEVEL_SIZE(domain->mode))
+		increase_address_space(domain, gfp);
 
-	if (!IOMMU_PTE_PRESENT(*pte)) {
-		page = (u64 *)get_zeroed_page(gfp);
-		if (!page)
-			return NULL;
-		*pte = IOMMU_L2_PDE(virt_to_phys(page));
-	}
+	level =  domain->mode - 1;
+	pte   = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
 
-	pte = IOMMU_PTE_PAGE(*pte);
-	pte = &pte[IOMMU_PTE_L1_INDEX(address)];
+	while (level > end_lvl) {
+		if (!IOMMU_PTE_PRESENT(*pte)) {
+			page = (u64 *)get_zeroed_page(gfp);
+			if (!page)
+				return NULL;
+			*pte = PM_LEVEL_PDE(level, virt_to_phys(page));
+		}
 
-	if (!IOMMU_PTE_PRESENT(*pte)) {
-		page = (u64 *)get_zeroed_page(gfp);
-		if (!page)
-			return NULL;
-		*pte = IOMMU_L1_PDE(virt_to_phys(page));
-	}
+		level -= 1;
 
-	pte = IOMMU_PTE_PAGE(*pte);
+		pte = IOMMU_PTE_PAGE(*pte);
 
-	if (pte_page)
-		*pte_page = pte;
+		if (pte_page && level == end_lvl)
+			*pte_page = pte;
 
-	pte = &pte[IOMMU_PTE_L0_INDEX(address)];
+		pte = &pte[PM_LEVEL_INDEX(level, address)];
+	}
 
 	return pte;
 }
@@ -1344,10 +1513,13 @@ static u64* dma_ops_get_pte(struct dma_ops_domain *dom,
 
 	pte = aperture->pte_pages[APERTURE_PAGE_INDEX(address)];
 	if (!pte) {
-		pte = alloc_pte(&dom->domain, address, &pte_page, GFP_ATOMIC);
+		pte = alloc_pte(&dom->domain, address, PM_MAP_4k, &pte_page,
+				GFP_ATOMIC);
 		aperture->pte_pages[APERTURE_PAGE_INDEX(address)] = pte_page;
 	} else
-		pte += IOMMU_PTE_L0_INDEX(address);
+		pte += PM_LEVEL_INDEX(0, address);
+
+	update_domain(&dom->domain);
 
 	return pte;
 }
@@ -1409,7 +1581,7 @@ static void dma_ops_domain_unmap(struct amd_iommu *iommu,
 	if (!pte)
 		return;
 
-	pte += IOMMU_PTE_L0_INDEX(address);
+	pte += PM_LEVEL_INDEX(0, address);
 
 	WARN_ON(!*pte);
 
@@ -1988,19 +2160,47 @@ static void cleanup_domain(struct protection_domain *domain)
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 }
 
-static int amd_iommu_domain_init(struct iommu_domain *dom)
+static void protection_domain_free(struct protection_domain *domain)
+{
+	if (!domain)
+		return;
+
+	if (domain->id)
+		domain_id_free(domain->id);
+
+	kfree(domain);
+}
+
+static struct protection_domain *protection_domain_alloc(void)
 {
 	struct protection_domain *domain;
 
 	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
 	if (!domain)
-		return -ENOMEM;
+		return NULL;
 
 	spin_lock_init(&domain->lock);
-	domain->mode = PAGE_MODE_3_LEVEL;
 	domain->id = domain_id_alloc();
 	if (!domain->id)
+		goto out_err;
+
+	return domain;
+
+out_err:
+	kfree(domain);
+
+	return NULL;
+}
+
+static int amd_iommu_domain_init(struct iommu_domain *dom)
+{
+	struct protection_domain *domain;
+
+	domain = protection_domain_alloc();
+	if (!domain)
 		goto out_free;
+
+	domain->mode    = PAGE_MODE_3_LEVEL;
 	domain->pt_root = (void *)get_zeroed_page(GFP_KERNEL);
 	if (!domain->pt_root)
 		goto out_free;
@@ -2010,7 +2210,7 @@ static int amd_iommu_domain_init(struct iommu_domain *dom)
 	return 0;
 
 out_free:
-	kfree(domain);
+	protection_domain_free(domain);
 
 	return -ENOMEM;
 }
@@ -2115,7 +2315,7 @@ static int amd_iommu_map_range(struct iommu_domain *dom,
 	paddr &= PAGE_MASK;
 
 	for (i = 0; i < npages; ++i) {
-		ret = iommu_map_page(domain, iova, paddr, prot);
+		ret = iommu_map_page(domain, iova, paddr, prot, PM_MAP_4k);
 		if (ret)
 			return ret;
 
@@ -2136,7 +2336,7 @@ static void amd_iommu_unmap_range(struct iommu_domain *dom,
 	iova  &= PAGE_MASK;
 
 	for (i = 0; i < npages; ++i) {
-		iommu_unmap_page(domain, iova);
+		iommu_unmap_page(domain, iova, PM_MAP_4k);
 		iova  += PAGE_SIZE;
 	}
 
@@ -2151,21 +2351,9 @@ static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
 	phys_addr_t paddr;
 	u64 *pte;
 
-	pte = &domain->pt_root[IOMMU_PTE_L2_INDEX(iova)];
-
-	if (!IOMMU_PTE_PRESENT(*pte))
-		return 0;
-
-	pte = IOMMU_PTE_PAGE(*pte);
-	pte = &pte[IOMMU_PTE_L1_INDEX(iova)];
-
-	if (!IOMMU_PTE_PRESENT(*pte))
-		return 0;
-
-	pte = IOMMU_PTE_PAGE(*pte);
-	pte = &pte[IOMMU_PTE_L0_INDEX(iova)];
+	pte = fetch_pte(domain, iova, PM_MAP_4k);
 
-	if (!IOMMU_PTE_PRESENT(*pte))
+	if (!pte || !IOMMU_PTE_PRESENT(*pte))
 		return 0;
 
 	paddr  = *pte & IOMMU_PAGE_MASK;
@@ -2191,3 +2379,46 @@ static struct iommu_ops amd_iommu_ops = {
 	.domain_has_cap = amd_iommu_domain_has_cap,
 };
 
+/*****************************************************************************
+ *
+ * The next functions do a basic initialization of IOMMU for pass through
+ * mode
+ *
+ * In passthrough mode the IOMMU is initialized and enabled but not used for
+ * DMA-API translation.
+ *
+ *****************************************************************************/
+
+int __init amd_iommu_init_passthrough(void)
+{
+	struct pci_dev *dev = NULL;
+	u16 devid, devid2;
+
+	/* allocate passthroug domain */
+	pt_domain = protection_domain_alloc();
+	if (!pt_domain)
+		return -ENOMEM;
+
+	pt_domain->mode |= PAGE_MODE_NONE;
+
+	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+		struct amd_iommu *iommu;
+
+		devid = calc_devid(dev->bus->number, dev->devfn);
+		if (devid > amd_iommu_last_bdf)
+			continue;
+
+		devid2 = amd_iommu_alias_table[devid];
+
+		iommu = amd_iommu_rlookup_table[devid2];
+		if (!iommu)
+			continue;
+
+		__attach_device(iommu, pt_domain, devid);
+		__attach_device(iommu, pt_domain, devid2);
+	}
+
+	pr_info("AMD-Vi: Initialized for Passthrough Mode\n");
+
+	return 0;
+}
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index c1b17e9..b4b61d4 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -252,7 +252,7 @@ static void __init iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
 /* Function to enable the hardware */
 static void iommu_enable(struct amd_iommu *iommu)
 {
-	printk(KERN_INFO "AMD IOMMU: Enabling IOMMU at %s cap 0x%hx\n",
+	printk(KERN_INFO "AMD-Vi: Enabling IOMMU at %s cap 0x%hx\n",
 	       dev_name(&iommu->dev->dev), iommu->cap_ptr);
 
 	iommu_feature_enable(iommu, CONTROL_IOMMU_EN);
@@ -435,6 +435,20 @@ static u8 * __init alloc_command_buffer(struct amd_iommu *iommu)
 }
 
 /*
+ * This function resets the command buffer if the IOMMU stopped fetching
+ * commands from it.
+ */
+void amd_iommu_reset_cmd_buffer(struct amd_iommu *iommu)
+{
+	iommu_feature_disable(iommu, CONTROL_CMDBUF_EN);
+
+	writel(0x00, iommu->mmio_base + MMIO_CMD_HEAD_OFFSET);
+	writel(0x00, iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
+
+	iommu_feature_enable(iommu, CONTROL_CMDBUF_EN);
+}
+
+/*
  * This function writes the command buffer address to the hardware and
  * enables it.
  */
@@ -450,11 +464,7 @@ static void iommu_enable_command_buffer(struct amd_iommu *iommu)
 	memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
 		    &entry, sizeof(entry));
 
-	/* set head and tail to zero manually */
-	writel(0x00, iommu->mmio_base + MMIO_CMD_HEAD_OFFSET);
-	writel(0x00, iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
-
-	iommu_feature_enable(iommu, CONTROL_CMDBUF_EN);
+	amd_iommu_reset_cmd_buffer(iommu);
 }
 
 static void __init free_command_buffer(struct amd_iommu *iommu)
@@ -858,7 +868,7 @@ static int __init init_iommu_all(struct acpi_table_header *table)
 		switch (*p) {
 		case ACPI_IVHD_TYPE:
 
-			DUMP_printk("IOMMU: device: %02x:%02x.%01x cap: %04x "
+			DUMP_printk("device: %02x:%02x.%01x cap: %04x "
 				    "seg: %d flags: %01x info %04x\n",
 				    PCI_BUS(h->devid), PCI_SLOT(h->devid),
 				    PCI_FUNC(h->devid), h->cap_ptr,
@@ -902,7 +912,7 @@ static int __init iommu_setup_msi(struct amd_iommu *iommu)
 
 	r = request_irq(iommu->dev->irq, amd_iommu_int_handler,
 			IRQF_SAMPLE_RANDOM,
-			"AMD IOMMU",
+			"AMD-Vi",
 			NULL);
 
 	if (r) {
@@ -1150,7 +1160,7 @@ int __init amd_iommu_init(void)
 
 
 	if (no_iommu) {
-		printk(KERN_INFO "AMD IOMMU disabled by kernel command line\n");
+		printk(KERN_INFO "AMD-Vi disabled by kernel command line\n");
 		return 0;
 	}
 
@@ -1242,22 +1252,28 @@ int __init amd_iommu_init(void)
 	if (ret)
 		goto free;
 
-	ret = amd_iommu_init_dma_ops();
+	if (iommu_pass_through)
+		ret = amd_iommu_init_passthrough();
+	else
+		ret = amd_iommu_init_dma_ops();
 	if (ret)
 		goto free;
 
 	enable_iommus();
 
-	printk(KERN_INFO "AMD IOMMU: device isolation ");
+	if (iommu_pass_through)
+		goto out;
+
+	printk(KERN_INFO "AMD-Vi: device isolation ");
 	if (amd_iommu_isolate)
 		printk("enabled\n");
 	else
 		printk("disabled\n");
 
 	if (amd_iommu_unmap_flush)
-		printk(KERN_INFO "AMD IOMMU: IO/TLB flush on unmap enabled\n");
+		printk(KERN_INFO "AMD-Vi: IO/TLB flush on unmap enabled\n");
 	else
-		printk(KERN_INFO "AMD IOMMU: Lazy IO/TLB flushing enabled\n");
+		printk(KERN_INFO "AMD-Vi: Lazy IO/TLB flushing enabled\n");
 
 out:
 	return ret;
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 1a041bc..8fb4ce3 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -32,7 +32,14 @@ int no_iommu __read_mostly;
 /* Set this to 1 if there is a HW IOMMU in the system */
 int iommu_detected __read_mostly = 0;
 
-int iommu_pass_through;
+/*
+ * This variable becomes 1 if iommu=pt is passed on the kernel command line.
+ * If this variable is 1, IOMMU implementations do no DMA ranslation for
+ * devices and allow every device to access to whole physical memory. This is
+ * useful if a user want to use an IOMMU only for KVM device assignment to
+ * guests and not for driver dma translation.
+ */
+int iommu_pass_through __read_mostly;
 
 dma_addr_t bad_dma_address __read_mostly = 0;
 EXPORT_SYMBOL(bad_dma_address);
@@ -147,7 +154,7 @@ again:
 		return NULL;
 
 	addr = page_to_phys(page);
-	if (!is_buffer_dma_capable(dma_mask, addr, size)) {
+	if (addr + size > dma_mask) {
 		__free_pages(page, get_order(size));
 
 		if (dma_mask < DMA_BIT_MASK(32) && !(flag & GFP_DMA)) {
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index d2e56b8..98a827e 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -190,14 +190,13 @@ static void iommu_full(struct device *dev, size_t size, int dir)
 static inline int
 need_iommu(struct device *dev, unsigned long addr, size_t size)
 {
-	return force_iommu ||
-		!is_buffer_dma_capable(*dev->dma_mask, addr, size);
+	return force_iommu || !dma_capable(dev, addr, size);
 }
 
 static inline int
 nonforced_iommu(struct device *dev, unsigned long addr, size_t size)
 {
-	return !is_buffer_dma_capable(*dev->dma_mask, addr, size);
+	return !dma_capable(dev, addr, size);
 }
 
 /* Map a single continuous physical area into the IOMMU.
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index 71d412a..a3933d4 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -14,7 +14,7 @@
 static int
 check_addr(char *name, struct device *hwdev, dma_addr_t bus, size_t size)
 {
-	if (hwdev && !is_buffer_dma_capable(*hwdev->dma_mask, bus, size)) {
+	if (hwdev && !dma_capable(hwdev, bus, size)) {
 		if (*hwdev->dma_mask >= DMA_BIT_MASK(32))
 			printk(KERN_ERR
 			    "nommu_%s: overflow %Lx+%zu of device mask %Lx\n",
@@ -79,12 +79,29 @@ static void nommu_free_coherent(struct device *dev, size_t size, void *vaddr,
 	free_pages((unsigned long)vaddr, get_order(size));
 }
 
+static void nommu_sync_single_for_device(struct device *dev,
+			dma_addr_t addr, size_t size,
+			enum dma_data_direction dir)
+{
+	flush_write_buffers();
+}
+
+
+static void nommu_sync_sg_for_device(struct device *dev,
+			struct scatterlist *sg, int nelems,
+			enum dma_data_direction dir)
+{
+	flush_write_buffers();
+}
+
 struct dma_map_ops nommu_dma_ops = {
-	.alloc_coherent	= dma_generic_alloc_coherent,
-	.free_coherent	= nommu_free_coherent,
-	.map_sg		= nommu_map_sg,
-	.map_page	= nommu_map_page,
-	.is_phys	= 1,
+	.alloc_coherent		= dma_generic_alloc_coherent,
+	.free_coherent		= nommu_free_coherent,
+	.map_sg			= nommu_map_sg,
+	.map_page		= nommu_map_page,
+	.sync_single_for_device = nommu_sync_single_for_device,
+	.sync_sg_for_device	= nommu_sync_sg_for_device,
+	.is_phys		= 1,
 };
 
 void __init no_iommu_init(void)
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 6af96ee..e8a3501 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
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
diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
index 5406a60..e694263 100644
--- a/include/asm-generic/dma-mapping-common.h
+++ b/include/asm-generic/dma-mapping-common.h
@@ -103,7 +103,6 @@ static inline void dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr,
 	if (ops->sync_single_for_cpu)
 		ops->sync_single_for_cpu(dev, addr, size, dir);
 	debug_dma_sync_single_for_cpu(dev, addr, size, dir);
-	flush_write_buffers();
 }
 
 static inline void dma_sync_single_for_device(struct device *dev,
@@ -116,7 +115,6 @@ static inline void dma_sync_single_for_device(struct device *dev,
 	if (ops->sync_single_for_device)
 		ops->sync_single_for_device(dev, addr, size, dir);
 	debug_dma_sync_single_for_device(dev, addr, size, dir);
-	flush_write_buffers();
 }
 
 static inline void dma_sync_single_range_for_cpu(struct device *dev,
@@ -132,7 +130,6 @@ static inline void dma_sync_single_range_for_cpu(struct device *dev,
 		ops->sync_single_range_for_cpu(dev, addr, offset, size, dir);
 		debug_dma_sync_single_range_for_cpu(dev, addr, offset, size, dir);
 
-		flush_write_buffers();
 	} else
 		dma_sync_single_for_cpu(dev, addr, size, dir);
 }
@@ -150,7 +147,6 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
 		ops->sync_single_range_for_device(dev, addr, offset, size, dir);
 		debug_dma_sync_single_range_for_device(dev, addr, offset, size, dir);
 
-		flush_write_buffers();
 	} else
 		dma_sync_single_for_device(dev, addr, size, dir);
 }
@@ -165,7 +161,6 @@ dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 	if (ops->sync_sg_for_cpu)
 		ops->sync_sg_for_cpu(dev, sg, nelems, dir);
 	debug_dma_sync_sg_for_cpu(dev, sg, nelems, dir);
-	flush_write_buffers();
 }
 
 static inline void
@@ -179,7 +174,6 @@ dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 		ops->sync_sg_for_device(dev, sg, nelems, dir);
 	debug_dma_sync_sg_for_device(dev, sg, nelems, dir);
 
-	flush_write_buffers();
 }
 
 #define dma_map_single(d, a, s, r) dma_map_single_attrs(d, a, s, r, NULL)
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 07dfd46..c0f6c3c 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -98,11 +98,6 @@ static inline int is_device_dma_capable(struct device *dev)
 	return dev->dma_mask != NULL && *dev->dma_mask != DMA_MASK_NONE;
 }
 
-static inline int is_buffer_dma_capable(u64 mask, dma_addr_t addr, size_t size)
-{
-	return addr + size <= mask;
-}
-
 #ifdef CONFIG_HAS_DMA
 #include <asm/dma-mapping.h>
 #else
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index cb1a663..73b1f1c 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -14,7 +14,6 @@ struct scatterlist;
  */
 #define IO_TLB_SEGSIZE	128
 
-
 /*
  * log of the size of each IO TLB slab.  The number of slabs is command line
  * controllable.
@@ -24,16 +23,6 @@ struct scatterlist;
 extern void
 swiotlb_init(void);
 
-extern void *swiotlb_alloc_boot(size_t bytes, unsigned long nslabs);
-extern void *swiotlb_alloc(unsigned order, unsigned long nslabs);
-
-extern dma_addr_t swiotlb_phys_to_bus(struct device *hwdev,
-				      phys_addr_t address);
-extern phys_addr_t swiotlb_bus_to_phys(struct device *hwdev,
-				       dma_addr_t address);
-
-extern int swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size);
-
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			dma_addr_t *dma_handle, gfp_t flags);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index bffe6d7..ac25cd2 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -114,46 +114,11 @@ setup_io_tlb_npages(char *str)
 __setup("swiotlb=", setup_io_tlb_npages);
 /* make io_tlb_overflow tunable too? */
 
-void * __weak __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
-{
-	return alloc_bootmem_low_pages(size);
-}
-
-void * __weak swiotlb_alloc(unsigned order, unsigned long nslabs)
-{
-	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
-}
-
-dma_addr_t __weak swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
-{
-	return paddr;
-}
-
-phys_addr_t __weak swiotlb_bus_to_phys(struct device *hwdev, dma_addr_t baddr)
-{
-	return baddr;
-}
-
+/* Note that this doesn't work with highmem page */
 static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
 				      volatile void *address)
 {
-	return swiotlb_phys_to_bus(hwdev, virt_to_phys(address));
-}
-
-void * __weak swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
-{
-	return phys_to_virt(swiotlb_bus_to_phys(hwdev, address));
-}
-
-int __weak swiotlb_arch_address_needs_mapping(struct device *hwdev,
-					       dma_addr_t addr, size_t size)
-{
-	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
-}
-
-int __weak swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
-{
-	return 0;
+	return phys_to_dma(hwdev, virt_to_phys(address));
 }
 
 static void swiotlb_print_info(unsigned long bytes)
@@ -189,7 +154,7 @@ swiotlb_init_with_default_size(size_t default_size)
 	/*
 	 * Get IO TLB memory from the low pages
 	 */
-	io_tlb_start = swiotlb_alloc_boot(bytes, io_tlb_nslabs);
+	io_tlb_start = alloc_bootmem_low_pages(bytes);
 	if (!io_tlb_start)
 		panic("Cannot allocate SWIOTLB buffer");
 	io_tlb_end = io_tlb_start + bytes;
@@ -245,7 +210,8 @@ swiotlb_late_init_with_default_size(size_t default_size)
 	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
 
 	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
-		io_tlb_start = swiotlb_alloc(order, io_tlb_nslabs);
+		io_tlb_start = (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
+							order);
 		if (io_tlb_start)
 			break;
 		order--;
@@ -315,20 +281,10 @@ cleanup1:
 	return -ENOMEM;
 }
 
-static inline int
-address_needs_mapping(struct device *hwdev, dma_addr_t addr, size_t size)
+static int is_swiotlb_buffer(phys_addr_t paddr)
 {
-	return swiotlb_arch_address_needs_mapping(hwdev, addr, size);
-}
-
-static inline int range_needs_mapping(phys_addr_t paddr, size_t size)
-{
-	return swiotlb_force || swiotlb_arch_range_needs_mapping(paddr, size);
-}
-
-static int is_swiotlb_buffer(char *addr)
-{
-	return addr >= io_tlb_start && addr < io_tlb_end;
+	return paddr >= virt_to_phys(io_tlb_start) &&
+		paddr < virt_to_phys(io_tlb_end);
 }
 
 /*
@@ -561,9 +517,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		dma_mask = hwdev->coherent_dma_mask;
 
 	ret = (void *)__get_free_pages(flags, order);
-	if (ret &&
-	    !is_buffer_dma_capable(dma_mask, swiotlb_virt_to_bus(hwdev, ret),
-				   size)) {
+	if (ret && swiotlb_virt_to_bus(hwdev, ret) + size > dma_mask) {
 		/*
 		 * The allocated memory isn't reachable by the device.
 		 */
@@ -585,7 +539,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	dev_addr = swiotlb_virt_to_bus(hwdev, ret);
 
 	/* Confirm address can be DMA'd by device */
-	if (!is_buffer_dma_capable(dma_mask, dev_addr, size)) {
+	if (dev_addr + size > dma_mask) {
 		printk("hwdev DMA mask = 0x%016Lx, dev_addr = 0x%016Lx\n",
 		       (unsigned long long)dma_mask,
 		       (unsigned long long)dev_addr);
@@ -601,11 +555,13 @@ EXPORT_SYMBOL(swiotlb_alloc_coherent);
 
 void
 swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
-		      dma_addr_t dma_handle)
+		      dma_addr_t dev_addr)
 {
+	phys_addr_t paddr = dma_to_phys(hwdev, dev_addr);
+
 	WARN_ON(irqs_disabled());
-	if (!is_swiotlb_buffer(vaddr))
-		free_pages((unsigned long) vaddr, get_order(size));
+	if (!is_swiotlb_buffer(paddr))
+		free_pages((unsigned long)vaddr, get_order(size));
 	else
 		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
 		do_unmap_single(hwdev, vaddr, size, DMA_TO_DEVICE);
@@ -625,12 +581,15 @@ swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
 	printk(KERN_ERR "DMA: Out of SW-IOMMU space for %zu bytes at "
 	       "device %s\n", size, dev ? dev_name(dev) : "?");
 
-	if (size > io_tlb_overflow && do_panic) {
-		if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)
-			panic("DMA: Memory would be corrupted\n");
-		if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
-			panic("DMA: Random memory would be DMAed\n");
-	}
+	if (size <= io_tlb_overflow || !do_panic)
+		return;
+
+	if (dir == DMA_BIDIRECTIONAL)
+		panic("DMA: Random memory could be DMA accessed\n");
+	if (dir == DMA_FROM_DEVICE)
+		panic("DMA: Random memory could be DMA written\n");
+	if (dir == DMA_TO_DEVICE)
+		panic("DMA: Random memory could be DMA read\n");
 }
 
 /*
@@ -646,7 +605,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 			    struct dma_attrs *attrs)
 {
 	phys_addr_t phys = page_to_phys(page) + offset;
-	dma_addr_t dev_addr = swiotlb_phys_to_bus(dev, phys);
+	dma_addr_t dev_addr = phys_to_dma(dev, phys);
 	void *map;
 
 	BUG_ON(dir == DMA_NONE);
@@ -655,8 +614,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	 * we can safely return the device addr and not worry about bounce
 	 * buffering it.
 	 */
-	if (!address_needs_mapping(dev, dev_addr, size) &&
-	    !range_needs_mapping(phys, size))
+	if (dma_capable(dev, dev_addr, size) && !swiotlb_force)
 		return dev_addr;
 
 	/*
@@ -673,7 +631,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	/*
 	 * Ensure that the address returned is DMA'ble
 	 */
-	if (address_needs_mapping(dev, dev_addr, size))
+	if (!dma_capable(dev, dev_addr, size))
 		panic("map_single: bounce buffer is not DMA'ble");
 
 	return dev_addr;
@@ -691,19 +649,25 @@ EXPORT_SYMBOL_GPL(swiotlb_map_page);
 static void unmap_single(struct device *hwdev, dma_addr_t dev_addr,
 			 size_t size, int dir)
 {
-	char *dma_addr = swiotlb_bus_to_virt(hwdev, dev_addr);
+	phys_addr_t paddr = dma_to_phys(hwdev, dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 
-	if (is_swiotlb_buffer(dma_addr)) {
-		do_unmap_single(hwdev, dma_addr, size, dir);
+	if (is_swiotlb_buffer(paddr)) {
+		do_unmap_single(hwdev, phys_to_virt(paddr), size, dir);
 		return;
 	}
 
 	if (dir != DMA_FROM_DEVICE)
 		return;
 
-	dma_mark_clean(dma_addr, size);
+	/*
+	 * phys_to_virt doesn't work with hihgmem page but we could
+	 * call dma_mark_clean() with hihgmem page here. However, we
+	 * are fine since dma_mark_clean() is null on POWERPC. We can
+	 * make dma_mark_clean() take a physical address if necessary.
+	 */
+	dma_mark_clean(phys_to_virt(paddr), size);
 }
 
 void swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
@@ -728,19 +692,19 @@ static void
 swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 		    size_t size, int dir, int target)
 {
-	char *dma_addr = swiotlb_bus_to_virt(hwdev, dev_addr);
+	phys_addr_t paddr = dma_to_phys(hwdev, dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 
-	if (is_swiotlb_buffer(dma_addr)) {
-		sync_single(hwdev, dma_addr, size, dir, target);
+	if (is_swiotlb_buffer(paddr)) {
+		sync_single(hwdev, phys_to_virt(paddr), size, dir, target);
 		return;
 	}
 
 	if (dir != DMA_FROM_DEVICE)
 		return;
 
-	dma_mark_clean(dma_addr, size);
+	dma_mark_clean(phys_to_virt(paddr), size);
 }
 
 void
@@ -817,10 +781,10 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 
 	for_each_sg(sgl, sg, nelems, i) {
 		phys_addr_t paddr = sg_phys(sg);
-		dma_addr_t dev_addr = swiotlb_phys_to_bus(hwdev, paddr);
+		dma_addr_t dev_addr = phys_to_dma(hwdev, paddr);
 
-		if (range_needs_mapping(paddr, sg->length) ||
-		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
+		if (swiotlb_force ||
+		    !dma_capable(hwdev, dev_addr, sg->length)) {
 			void *map = map_single(hwdev, sg_phys(sg),
 					       sg->length, dir);
 			if (!map) {
