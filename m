Return-Path: <linux-kernel-owner+w=401wt.eu-S1751333AbZH0HWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333AbZH0HWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 03:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbZH0HWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 03:22:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60474 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbZH0HW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 03:22:29 -0400
Date: Thu, 27 Aug 2009 09:22:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linuxppc-dev@lists.ozlabs.org, galak@kernel.crashing.orga,
       beckyb@kernel.crashing.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2 0/7] powerpc: use asm-generic/dma-mapping-common.h
Message-ID: <20090827072208.GA2131@elte.hu>
References: <1249448908-18985-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1250142522.3587.110.camel@pasglop> <20090813160625B.fujita.tomonori@lab.ntt.co.jp> <20090813074131.GH12143@elte.hu> <1250150981.3587.157.camel@pasglop> <20090813085505.GA10671@elte.hu> <1251342735.20467.2.camel@pasglop> <1251343070.20467.3.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251343070.20467.3.camel@pasglop>
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


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Thu, 2009-08-27 at 13:12 +1000, Benjamin Herrenschmidt wrote:
> > On Thu, 2009-08-13 at 10:55 +0200, Ingo Molnar wrote:
> > 
> > > Ok! We could also stage it a bit (one or two weeks) in a 
> > > separate branch and allow a rebase, should you find any bugs 
> > > during testing?
> > 
> > Allright so after various delays and sidetracking on my side, 
> > the patches have been in my -test branch for long enough, I'm 
> > happy for them to go in either way now.
> > 
> > I'm going to take them out of powerpc test for now and not put 
> > them in my -next right away until I'm sure I have the right 
> > source to pull, at which point I can just put from tip iommu.
> 
> IE. I think I was not clear :-)
> 
> I mean, I plan to pull tip/iommu into powerpc-next and then apply 
> the patches, but I want just your final word that this is a 
> "stable" (non-rebase) branch and from Fujita that the patches are 
> still good and haven't changed from those currently on patchwork.

ah, yes, they are stable/fine. I've put it into a separate branch 
for you.

Ben, please pull the latest iommu-for-powerpc git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git iommu-for-powerpc

And i could pull back the new bits from you once you have the new 
patches added and are happy with them. [I suspect you dont want the 
diffstat below in the powerpc tree]

That was the plan, right?

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


 arch/ia64/include/asm/dma-mapping.h      |   19 +++-
 arch/powerpc/include/asm/dma-mapping.h   |   23 ++++
 arch/powerpc/kernel/dma-swiotlb.c        |   48 +--------
 arch/sparc/Kconfig                       |    2 +
 arch/sparc/include/asm/dma-mapping.h     |  145 ++++-------------------
 arch/sparc/include/asm/pci.h             |    3 +
 arch/sparc/include/asm/pci_32.h          |  105 ----------------
 arch/sparc/include/asm/pci_64.h          |   88 --------------
 arch/sparc/kernel/Makefile               |    2 +-
 arch/sparc/kernel/dma.c                  |  175 +--------------------------
 arch/sparc/kernel/dma.h                  |   14 --
 arch/sparc/kernel/iommu.c                |   20 ++-
 arch/sparc/kernel/ioport.c               |  190 ++++++++++++++++-------------
 arch/sparc/kernel/pci.c                  |    2 +-
 arch/sparc/kernel/pci_sun4v.c            |   30 ++----
 arch/x86/include/asm/dma-mapping.h       |   18 +++
 arch/x86/kernel/pci-dma.c                |    2 +-
 arch/x86/kernel/pci-gart_64.c            |    5 +-
 arch/x86/kernel/pci-nommu.c              |   29 ++++-
 arch/x86/kernel/pci-swiotlb.c            |   25 ----
 include/asm-generic/dma-mapping-common.h |    6 -
 include/linux/dma-mapping.h              |    5 -
 include/linux/swiotlb.h                  |   11 --
 lib/swiotlb.c                            |  124 +++++++-------------
 24 files changed, 291 insertions(+), 800 deletions(-)
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
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 1a041bc..3c945c0 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -147,7 +147,7 @@ again:
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
