Return-Path: <linux-kernel-owner+w=401wt.eu-S932084AbYJJRtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084AbYJJRtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 13:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758716AbYJJRtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 13:49:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52491 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758966AbYJJRs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 13:48:58 -0400
Date: Fri, 10 Oct 2008 19:48:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 updates for v2.6.28, phase #3 - IOMMU
Message-ID: <20081010174838.GA18689@elte.hu>
References: <20081009235945.GA31581@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081009235945.GA31581@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Linus,
> 
> Please pull the latest x86-v28-for-linus-phase3 git tree from:
> 
> IOMMU updates.

Linus, please find the updated pull request below - relative to the 
respun x86-v28-for-linus-phase2-B.

	Ingo

-------------->
Linus,

Please pull the latest x86-v28-for-linus-phase3-B git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-v28-for-linus-phase3-B


out-of-topic modifications in x86-v28-for-linus-phase3-B:
---------------------------------------------------------
MAINTAINERS                        # bbd001c: add AMD IOMMU tree to MAINTAINERS
arch/ia64/include/asm/dma-mapping.h# 3a80b6a: ia64: dma_alloc_coherent always u
include/linux/dma-mapping.h        # 07a2c01: convert swiotlb to use dma_get_ma
                                   # 589fc9a6: iommu: add dma_get_mask helper f
                                   # 636dc67: add is_buffer_dma_capable helper 
include/linux/iommu-helper.h       # 1e19b16: AMD IOMMU: use iommu_device_max_i
                                   # d26dbc5: iommu: export iommu_area_reserve 
                                   # eecfffc: iommu: add iommu_device_max_index
include/linux/pci_ids.h            # 2426824: x86: add PCI IDs for AMD Barcelon
                                   # ca1af29: x86, pci: add northbridge pci ids
kernel/dma-coherent.c              # a38409f: dma-coherent: export dma_[alloc|r
lib/iommu-helper.c                 # d26dbc5: iommu: export iommu_area_reserve 
lib/swiotlb.c                      # 07a2c01: convert swiotlb to use dma_get_ma
                                   # 2797982: swiotlb: convert swiotlb to use i
                                   # 640aebf: swiotlb: add is_swiotlb_buffer he
                                   # 21f6c4d: swiotlb: use unmap_single instead
                                   # 9dfda12: swiotlb: use map_single instead o
                                   # 68e91d6: swiotlb: remove GFP_DMA hack in s

 Thanks,

	Ingo

------------------>
David Woodhouse (1):
      x86: blacklist DMAR on Intel G31/G33 chipsets

FUJITA Tomonori (32):
      dma-mapping.h, x86: remove last user of dma_mapping_ops->map_simple
      x86: dma_*_coherent rework patchset v2, fix
      x86: gart alloc_coherent doesn't need to check NULL device argument
      ia64: dma_alloc_coherent always use GFP_DMA
      x86: move pci-nommu's dma_mask check to common code
      x86: fix nommu_alloc_coherent allocation with NULL device argument
      x86: dma_alloc_coherent sets gfp flags properly
      swiotlb: remove GFP_DMA hack in swiotlb_alloc_coherent
      swiotlb: use map_single instead of swiotlb_map_single in swiotlb_alloc_coherent
      swiotlb: use unmap_single instead of swiotlb_unmap_single in swiotlb_free_coherent
      swiotlb: add is_swiotlb_buffer helper function
      add is_buffer_dma_capable helper function
      x86: convert gart to use is_buffer_dma_capable helper function
      x86: convert pci-nommu to use is_buffer_dma_capable helper function
      swiotlb: convert swiotlb to use is_buffer_dma_capable helper function
      x86: remove duplicated extern force_iommu
      x86: convert dma_alloc_coherent to use is_device_dma_capable
      iommu: add iommu_device_max_index IOMMU helper function
      iommu: add dma_get_mask helper function
      x86: make GART to respect device's dma_mask about virtual mappings
      x86: avoid unnecessary low zone allocation in Calgary's alloc_coherent
      x86: gart alloc_coherent does virtual mapppings only when necessary
      convert swiotlb to use dma_get_mask
      AMD IOMMU: avoid unnecessary low zone allocation in alloc_coherent
      iommu: export iommu_area_reserve helper function
      x86: remove set_bit_string()
      iommu: remove fullflush and nofullflush in IOMMU generic option
      x86: export pci-nommu's alloc_coherent
      revert "x86: make GART to respect device's dma_mask about virtual mappings"
      x86: restore old GART alloc_coherent behavior
      x86 gart: remove unnecessary initialization
      AMD IOMMU: use iommu_device_max_index

Ingo Molnar (2):
      dma-coherent: export dma_[alloc|release]_from_coherent methods
      x86: add PCI IDs for AMD Barcelona PCI devices

Joerg Roedel (37):
      x86: add alloc_coherent dma_ops callback to GART driver
      x86: add free_coherent dma_ops callback to GART driver
      x86: add free_coherent dma_ops callback to Calgary IOMMU driver
      x86: add alloc_coherent dma_ops callback to NOMMU driver
      x86: add free_coherent dma_ops callback to NOMMU driver
      x86: cleanup dma_*_coherent functions
      x86: move dma_*_coherent functions to include file
      x86, AMD IOMMU: remove obsolete FIXME comment
      x86, pci: add northbridge pci ids for fam 0x11 processors
      x86, gart: add detection of AMD family 0x11 northbridges
      AMD IOMMU: check for invalid device pointers
      AMD IOMMU: move TLB flushing to the map/unmap helper functions
      x86: move GART TLB flushing options to generic code
      AMD IOMMU: implement lazy IO/TLB flushing
      AMD IOMMU: add branch hints to completion wait checks
      AMD IOMMU: align alloc_coherent addresses properly
      AMD IOMMU: add event buffer allocation
      AMD IOMMU: save pci segment from ACPI tables
      AMD IOMMU: save pci_dev instead of devid
      AMD IOMMU: add MSI interrupt support
      AMD IOMMU: add event handling code
      AMD IOMMU: enable event logging
      AMD IOMMU: allow IO page faults from devices
      AMD IOMMU: add dma_supported callback
      AMD IOMMU: don't assign preallocated protection domains to devices
      AMD IOMMU: some set_device_domain cleanups
      AMD IOMMU: replace memset with __GFP_ZERO in alloc_coherent
      AMD IOMMU: simplify dma_mask_to_pages
      AMD IOMMU: free domain bitmap with its allocation order
      AMD IOMMU: remove unnecessary cast to u64 in the init code
      AMD IOMMU: calculate IVHD size with a function
      AMD IOMMU: use cmd_buf_size when freeing the command buffer
      add AMD IOMMU tree to MAINTAINERS file
      AMD IOMMU: use coherent_dma_mask in alloc_coherent
      x86/iommu: make GART driver checkpatch clean
      x86/iommu: convert GART need_flush to bool
      x86/iommu: use __GFP_ZERO instead of memset for GART

Steven Noonan (1):
      x86: unused variable in dma_alloc_coherent_gfp_flags()

Thomas Gleixner (1):
      AMD IOMMU: use iommu_device_max_index, fix


 Documentation/kernel-parameters.txt |    5 +
 MAINTAINERS                         |    1 +
 arch/ia64/include/asm/dma-mapping.h |    4 +-
 arch/x86/Kconfig                    |    1 +
 arch/x86/kernel/amd_iommu.c         |  328 ++++++++++++++++++++++++++++-------
 arch/x86/kernel/amd_iommu_init.c    |  194 +++++++++++++++++++--
 arch/x86/kernel/early-quirks.c      |   18 ++
 arch/x86/kernel/k8.c                |    5 +-
 arch/x86/kernel/pci-calgary_64.c    |   18 ++-
 arch/x86/kernel/pci-dma.c           |  177 ++++---------------
 arch/x86/kernel/pci-gart_64.c       |  125 +++++++------
 arch/x86/kernel/pci-nommu.c         |   10 +-
 drivers/pci/intel-iommu.c           |    2 +-
 include/asm-x86/amd_iommu.h         |    3 +
 include/asm-x86/amd_iommu_types.h   |   64 +++++++-
 include/asm-x86/bitops.h            |   10 -
 include/asm-x86/dma-mapping.h       |   87 ++++++++--
 include/asm-x86/gart.h              |    2 +
 include/asm-x86/iommu.h             |    1 +
 include/linux/dma-mapping.h         |   12 ++
 include/linux/iommu-helper.h        |   16 ++
 include/linux/pci_ids.h             |   10 +
 kernel/dma-coherent.c               |    2 +
 lib/iommu-helper.c                  |    5 +-
 lib/swiotlb.c                       |   49 ++---
 25 files changed, 803 insertions(+), 346 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 329dcab..a2701cb 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -284,6 +284,11 @@ and is between 256 and 4096 characters. It is defined in the file
 			isolate - enable device isolation (each device, as far
 			          as possible, will get its own protection
 			          domain)
+			fullflush - enable flushing of IO/TLB entries when
+				    they are unmapped. Otherwise they are
+				    flushed before they will be reused, which
+				    is a lot of faster
+
 	amd_iommu_size= [HW,X86-64]
 			Define the size of the aperture for the AMD IOMMU
 			driver. Possible values are:
diff --git a/MAINTAINERS b/MAINTAINERS
index 8dae455..3c124d7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -387,6 +387,7 @@ AMD IOMMU (AMD-VI)
 P:	Joerg Roedel
 M:	joerg.roedel@amd.com
 L:	iommu@lists.linux-foundation.org
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git
 S:	Supported
 
 AMS (Apple Motion Sensor) DRIVER
diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
index 9f0df9b..06ff1ba 100644
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -8,7 +8,9 @@
 #include <asm/machvec.h>
 #include <linux/scatterlist.h>
 
-#define dma_alloc_coherent	platform_dma_alloc_coherent
+#define dma_alloc_coherent(dev, size, handle, gfp)	\
+	platform_dma_alloc_coherent(dev, size, handle, (gfp) | GFP_DMA)
+
 /* coherent mem. is cheap */
 static inline void *
 dma_alloc_noncoherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 97f0d2b..0d7cdbb 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -554,6 +554,7 @@ config CALGARY_IOMMU_ENABLED_BY_DEFAULT
 config AMD_IOMMU
 	bool "AMD IOMMU support"
 	select SWIOTLB
+	select PCI_MSI
 	depends on X86_64 && PCI && ACPI
 	help
 	  With this option you can enable support for AMD IOMMU hardware in
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 042fdc2..34e4d11 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -33,6 +33,10 @@
 
 static DEFINE_RWLOCK(amd_iommu_devtable_lock);
 
+/* A list of preallocated protection domains */
+static LIST_HEAD(iommu_pd_list);
+static DEFINE_SPINLOCK(iommu_pd_list_lock);
+
 /*
  * general struct to manage commands send to an IOMMU
  */
@@ -51,6 +55,102 @@ static int iommu_has_npcache(struct amd_iommu *iommu)
 
 /****************************************************************************
  *
+ * Interrupt handling functions
+ *
+ ****************************************************************************/
+
+static void iommu_print_event(void *__evt)
+{
+	u32 *event = __evt;
+	int type  = (event[1] >> EVENT_TYPE_SHIFT)  & EVENT_TYPE_MASK;
+	int devid = (event[0] >> EVENT_DEVID_SHIFT) & EVENT_DEVID_MASK;
+	int domid = (event[1] >> EVENT_DOMID_SHIFT) & EVENT_DOMID_MASK;
+	int flags = (event[1] >> EVENT_FLAGS_SHIFT) & EVENT_FLAGS_MASK;
+	u64 address = (u64)(((u64)event[3]) << 32) | event[2];
+
+	printk(KERN_ERR "AMD IOMMU: Event logged [");
+
+	switch (type) {
+	case EVENT_TYPE_ILL_DEV:
+		printk("ILLEGAL_DEV_TABLE_ENTRY device=%02x:%02x.%x "
+		       "address=0x%016llx flags=0x%04x]\n",
+		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
+		       address, flags);
+		break;
+	case EVENT_TYPE_IO_FAULT:
+		printk("IO_PAGE_FAULT device=%02x:%02x.%x "
+		       "domain=0x%04x address=0x%016llx flags=0x%04x]\n",
+		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
+		       domid, address, flags);
+		break;
+	case EVENT_TYPE_DEV_TAB_ERR:
+		printk("DEV_TAB_HARDWARE_ERROR device=%02x:%02x.%x "
+		       "address=0x%016llx flags=0x%04x]\n",
+		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
+		       address, flags);
+		break;
+	case EVENT_TYPE_PAGE_TAB_ERR:
+		printk("PAGE_TAB_HARDWARE_ERROR device=%02x:%02x.%x "
+		       "domain=0x%04x address=0x%016llx flags=0x%04x]\n",
+		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
+		       domid, address, flags);
+		break;
+	case EVENT_TYPE_ILL_CMD:
+		printk("ILLEGAL_COMMAND_ERROR address=0x%016llx]\n", address);
+		break;
+	case EVENT_TYPE_CMD_HARD_ERR:
+		printk("COMMAND_HARDWARE_ERROR address=0x%016llx "
+		       "flags=0x%04x]\n", address, flags);
+		break;
+	case EVENT_TYPE_IOTLB_INV_TO:
+		printk("IOTLB_INV_TIMEOUT device=%02x:%02x.%x "
+		       "address=0x%016llx]\n",
+		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
+		       address);
+		break;
+	case EVENT_TYPE_INV_DEV_REQ:
+		printk("INVALID_DEVICE_REQUEST device=%02x:%02x.%x "
+		       "address=0x%016llx flags=0x%04x]\n",
+		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
+		       address, flags);
+		break;
+	default:
+		printk(KERN_ERR "UNKNOWN type=0x%02x]\n", type);
+	}
+}
+
+static void iommu_poll_events(struct amd_iommu *iommu)
+{
+	u32 head, tail;
+	unsigned long flags;
+
+	spin_lock_irqsave(&iommu->lock, flags);
+
+	head = readl(iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
+	tail = readl(iommu->mmio_base + MMIO_EVT_TAIL_OFFSET);
+
+	while (head != tail) {
+		iommu_print_event(iommu->evt_buf + head);
+		head = (head + EVENT_ENTRY_SIZE) % iommu->evt_buf_size;
+	}
+
+	writel(head, iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
+
+	spin_unlock_irqrestore(&iommu->lock, flags);
+}
+
+irqreturn_t amd_iommu_int_handler(int irq, void *data)
+{
+	struct amd_iommu *iommu;
+
+	list_for_each_entry(iommu, &amd_iommu_list, list)
+		iommu_poll_events(iommu);
+
+	return IRQ_HANDLED;
+}
+
+/****************************************************************************
+ *
  * IOMMU command queuing functions
  *
  ****************************************************************************/
@@ -213,6 +313,14 @@ static int iommu_flush_pages(struct amd_iommu *iommu, u16 domid,
 	return 0;
 }
 
+/* Flush the whole IO/TLB for a given protection domain */
+static void iommu_flush_tlb(struct amd_iommu *iommu, u16 domid)
+{
+	u64 address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
+
+	iommu_queue_inv_iommu_pages(iommu, address, domid, 0, 1);
+}
+
 /****************************************************************************
  *
  * The functions below are used the create the page table mappings for
@@ -372,11 +480,6 @@ static int init_unity_mappings_for_device(struct dma_ops_domain *dma_dom,
  * efficient allocator.
  *
  ****************************************************************************/
-static unsigned long dma_mask_to_pages(unsigned long mask)
-{
-	return (mask >> PAGE_SHIFT) +
-		(PAGE_ALIGN(mask & ~PAGE_MASK) >> PAGE_SHIFT);
-}
 
 /*
  * The address allocator core function.
@@ -385,25 +488,31 @@ static unsigned long dma_mask_to_pages(unsigned long mask)
  */
 static unsigned long dma_ops_alloc_addresses(struct device *dev,
 					     struct dma_ops_domain *dom,
-					     unsigned int pages)
+					     unsigned int pages,
+					     unsigned long align_mask,
+					     u64 dma_mask)
 {
-	unsigned long limit = dma_mask_to_pages(*dev->dma_mask);
+	unsigned long limit;
 	unsigned long address;
-	unsigned long size = dom->aperture_size >> PAGE_SHIFT;
 	unsigned long boundary_size;
 
 	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
 			PAGE_SIZE) >> PAGE_SHIFT;
-	limit = limit < size ? limit : size;
+	limit = iommu_device_max_index(dom->aperture_size >> PAGE_SHIFT, 0,
+				       dma_mask >> PAGE_SHIFT);
 
-	if (dom->next_bit >= limit)
+	if (dom->next_bit >= limit) {
 		dom->next_bit = 0;
+		dom->need_flush = true;
+	}
 
 	address = iommu_area_alloc(dom->bitmap, limit, dom->next_bit, pages,
-			0 , boundary_size, 0);
-	if (address == -1)
+				   0 , boundary_size, align_mask);
+	if (address == -1) {
 		address = iommu_area_alloc(dom->bitmap, limit, 0, pages,
-				0, boundary_size, 0);
+				0, boundary_size, align_mask);
+		dom->need_flush = true;
+	}
 
 	if (likely(address != -1)) {
 		dom->next_bit = address + pages;
@@ -469,7 +578,7 @@ static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
 	if (start_page + pages > last_page)
 		pages = last_page - start_page;
 
-	set_bit_string(dom->bitmap, start_page, pages);
+	iommu_area_reserve(dom->bitmap, start_page, pages);
 }
 
 static void dma_ops_free_pagetable(struct dma_ops_domain *dma_dom)
@@ -563,6 +672,9 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 	dma_dom->bitmap[0] = 1;
 	dma_dom->next_bit = 0;
 
+	dma_dom->need_flush = false;
+	dma_dom->target_dev = 0xffff;
+
 	/* Intialize the exclusion range if necessary */
 	if (iommu->exclusion_start &&
 	    iommu->exclusion_start < dma_dom->aperture_size) {
@@ -633,12 +745,13 @@ static void set_device_domain(struct amd_iommu *iommu,
 
 	u64 pte_root = virt_to_phys(domain->pt_root);
 
-	pte_root |= (domain->mode & 0x07) << 9;
-	pte_root |= IOMMU_PTE_IR | IOMMU_PTE_IW | IOMMU_PTE_P | 2;
+	pte_root |= (domain->mode & DEV_ENTRY_MODE_MASK)
+		    << DEV_ENTRY_MODE_SHIFT;
+	pte_root |= IOMMU_PTE_IR | IOMMU_PTE_IW | IOMMU_PTE_P | IOMMU_PTE_TV;
 
 	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
-	amd_iommu_dev_table[devid].data[0] = pte_root;
-	amd_iommu_dev_table[devid].data[1] = pte_root >> 32;
+	amd_iommu_dev_table[devid].data[0] = lower_32_bits(pte_root);
+	amd_iommu_dev_table[devid].data[1] = upper_32_bits(pte_root);
 	amd_iommu_dev_table[devid].data[2] = domain->id;
 
 	amd_iommu_pd_table[devid] = domain;
@@ -656,6 +769,45 @@ static void set_device_domain(struct amd_iommu *iommu,
  *****************************************************************************/
 
 /*
+ * This function checks if the driver got a valid device from the caller to
+ * avoid dereferencing invalid pointers.
+ */
+static bool check_device(struct device *dev)
+{
+	if (!dev || !dev->dma_mask)
+		return false;
+
+	return true;
+}
+
+/*
+ * In this function the list of preallocated protection domains is traversed to
+ * find the domain for a specific device
+ */
+static struct dma_ops_domain *find_protection_domain(u16 devid)
+{
+	struct dma_ops_domain *entry, *ret = NULL;
+	unsigned long flags;
+
+	if (list_empty(&iommu_pd_list))
+		return NULL;
+
+	spin_lock_irqsave(&iommu_pd_list_lock, flags);
+
+	list_for_each_entry(entry, &iommu_pd_list, list) {
+		if (entry->target_dev == devid) {
+			ret = entry;
+			list_del(&ret->list);
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&iommu_pd_list_lock, flags);
+
+	return ret;
+}
+
+/*
  * In the dma_ops path we only have the struct device. This function
  * finds the corresponding IOMMU, the protection domain and the
  * requestor id for a given device.
@@ -671,27 +823,30 @@ static int get_device_resources(struct device *dev,
 	struct pci_dev *pcidev;
 	u16 _bdf;
 
-	BUG_ON(!dev || dev->bus != &pci_bus_type || !dev->dma_mask);
+	*iommu = NULL;
+	*domain = NULL;
+	*bdf = 0xffff;
+
+	if (dev->bus != &pci_bus_type)
+		return 0;
 
 	pcidev = to_pci_dev(dev);
 	_bdf = calc_devid(pcidev->bus->number, pcidev->devfn);
 
 	/* device not translated by any IOMMU in the system? */
-	if (_bdf > amd_iommu_last_bdf) {
-		*iommu = NULL;
-		*domain = NULL;
-		*bdf = 0xffff;
+	if (_bdf > amd_iommu_last_bdf)
 		return 0;
-	}
 
 	*bdf = amd_iommu_alias_table[_bdf];
 
 	*iommu = amd_iommu_rlookup_table[*bdf];
 	if (*iommu == NULL)
 		return 0;
-	dma_dom = (*iommu)->default_dom;
 	*domain = domain_for_device(*bdf);
 	if (*domain == NULL) {
+		dma_dom = find_protection_domain(*bdf);
+		if (!dma_dom)
+			dma_dom = (*iommu)->default_dom;
 		*domain = &dma_dom->domain;
 		set_device_domain(*iommu, *domain, *bdf);
 		printk(KERN_INFO "AMD IOMMU: Using protection domain %d for "
@@ -770,17 +925,24 @@ static dma_addr_t __map_single(struct device *dev,
 			       struct dma_ops_domain *dma_dom,
 			       phys_addr_t paddr,
 			       size_t size,
-			       int dir)
+			       int dir,
+			       bool align,
+			       u64 dma_mask)
 {
 	dma_addr_t offset = paddr & ~PAGE_MASK;
 	dma_addr_t address, start;
 	unsigned int pages;
+	unsigned long align_mask = 0;
 	int i;
 
 	pages = iommu_num_pages(paddr, size);
 	paddr &= PAGE_MASK;
 
-	address = dma_ops_alloc_addresses(dev, dma_dom, pages);
+	if (align)
+		align_mask = (1UL << get_order(size)) - 1;
+
+	address = dma_ops_alloc_addresses(dev, dma_dom, pages, align_mask,
+					  dma_mask);
 	if (unlikely(address == bad_dma_address))
 		goto out;
 
@@ -792,6 +954,12 @@ static dma_addr_t __map_single(struct device *dev,
 	}
 	address += offset;
 
+	if (unlikely(dma_dom->need_flush && !amd_iommu_unmap_flush)) {
+		iommu_flush_tlb(iommu, dma_dom->domain.id);
+		dma_dom->need_flush = false;
+	} else if (unlikely(iommu_has_npcache(iommu)))
+		iommu_flush_pages(iommu, dma_dom->domain.id, address, size);
+
 out:
 	return address;
 }
@@ -822,6 +990,9 @@ static void __unmap_single(struct amd_iommu *iommu,
 	}
 
 	dma_ops_free_addresses(dma_dom, dma_addr, pages);
+
+	if (amd_iommu_unmap_flush)
+		iommu_flush_pages(iommu, dma_dom->domain.id, dma_addr, size);
 }
 
 /*
@@ -835,6 +1006,12 @@ static dma_addr_t map_single(struct device *dev, phys_addr_t paddr,
 	struct protection_domain *domain;
 	u16 devid;
 	dma_addr_t addr;
+	u64 dma_mask;
+
+	if (!check_device(dev))
+		return bad_dma_address;
+
+	dma_mask = *dev->dma_mask;
 
 	get_device_resources(dev, &iommu, &domain, &devid);
 
@@ -843,14 +1020,12 @@ static dma_addr_t map_single(struct device *dev, phys_addr_t paddr,
 		return (dma_addr_t)paddr;
 
 	spin_lock_irqsave(&domain->lock, flags);
-	addr = __map_single(dev, iommu, domain->priv, paddr, size, dir);
+	addr = __map_single(dev, iommu, domain->priv, paddr, size, dir, false,
+			    dma_mask);
 	if (addr == bad_dma_address)
 		goto out;
 
-	if (iommu_has_npcache(iommu))
-		iommu_flush_pages(iommu, domain->id, addr, size);
-
-	if (iommu->need_sync)
+	if (unlikely(iommu->need_sync))
 		iommu_completion_wait(iommu);
 
 out:
@@ -870,7 +1045,8 @@ static void unmap_single(struct device *dev, dma_addr_t dma_addr,
 	struct protection_domain *domain;
 	u16 devid;
 
-	if (!get_device_resources(dev, &iommu, &domain, &devid))
+	if (!check_device(dev) ||
+	    !get_device_resources(dev, &iommu, &domain, &devid))
 		/* device not handled by any AMD IOMMU */
 		return;
 
@@ -878,9 +1054,7 @@ static void unmap_single(struct device *dev, dma_addr_t dma_addr,
 
 	__unmap_single(iommu, domain->priv, dma_addr, size, dir);
 
-	iommu_flush_pages(iommu, domain->id, dma_addr, size);
-
-	if (iommu->need_sync)
+	if (unlikely(iommu->need_sync))
 		iommu_completion_wait(iommu);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
@@ -919,6 +1093,12 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 	struct scatterlist *s;
 	phys_addr_t paddr;
 	int mapped_elems = 0;
+	u64 dma_mask;
+
+	if (!check_device(dev))
+		return 0;
+
+	dma_mask = *dev->dma_mask;
 
 	get_device_resources(dev, &iommu, &domain, &devid);
 
@@ -931,19 +1111,17 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 		paddr = sg_phys(s);
 
 		s->dma_address = __map_single(dev, iommu, domain->priv,
-					      paddr, s->length, dir);
+					      paddr, s->length, dir, false,
+					      dma_mask);
 
 		if (s->dma_address) {
 			s->dma_length = s->length;
 			mapped_elems++;
 		} else
 			goto unmap;
-		if (iommu_has_npcache(iommu))
-			iommu_flush_pages(iommu, domain->id, s->dma_address,
-					  s->dma_length);
 	}
 
-	if (iommu->need_sync)
+	if (unlikely(iommu->need_sync))
 		iommu_completion_wait(iommu);
 
 out:
@@ -977,7 +1155,8 @@ static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 	u16 devid;
 	int i;
 
-	if (!get_device_resources(dev, &iommu, &domain, &devid))
+	if (!check_device(dev) ||
+	    !get_device_resources(dev, &iommu, &domain, &devid))
 		return;
 
 	spin_lock_irqsave(&domain->lock, flags);
@@ -985,12 +1164,10 @@ static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 	for_each_sg(sglist, s, nelems, i) {
 		__unmap_single(iommu, domain->priv, s->dma_address,
 			       s->dma_length, dir);
-		iommu_flush_pages(iommu, domain->id, s->dma_address,
-				  s->dma_length);
 		s->dma_address = s->dma_length = 0;
 	}
 
-	if (iommu->need_sync)
+	if (unlikely(iommu->need_sync))
 		iommu_completion_wait(iommu);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
@@ -1008,25 +1185,33 @@ static void *alloc_coherent(struct device *dev, size_t size,
 	struct protection_domain *domain;
 	u16 devid;
 	phys_addr_t paddr;
+	u64 dma_mask = dev->coherent_dma_mask;
+
+	if (!check_device(dev))
+		return NULL;
+
+	if (!get_device_resources(dev, &iommu, &domain, &devid))
+		flag &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
 
+	flag |= __GFP_ZERO;
 	virt_addr = (void *)__get_free_pages(flag, get_order(size));
 	if (!virt_addr)
 		return 0;
 
-	memset(virt_addr, 0, size);
 	paddr = virt_to_phys(virt_addr);
 
-	get_device_resources(dev, &iommu, &domain, &devid);
-
 	if (!iommu || !domain) {
 		*dma_addr = (dma_addr_t)paddr;
 		return virt_addr;
 	}
 
+	if (!dma_mask)
+		dma_mask = *dev->dma_mask;
+
 	spin_lock_irqsave(&domain->lock, flags);
 
 	*dma_addr = __map_single(dev, iommu, domain->priv, paddr,
-				 size, DMA_BIDIRECTIONAL);
+				 size, DMA_BIDIRECTIONAL, true, dma_mask);
 
 	if (*dma_addr == bad_dma_address) {
 		free_pages((unsigned long)virt_addr, get_order(size));
@@ -1034,10 +1219,7 @@ static void *alloc_coherent(struct device *dev, size_t size,
 		goto out;
 	}
 
-	if (iommu_has_npcache(iommu))
-		iommu_flush_pages(iommu, domain->id, *dma_addr, size);
-
-	if (iommu->need_sync)
+	if (unlikely(iommu->need_sync))
 		iommu_completion_wait(iommu);
 
 out:
@@ -1048,8 +1230,6 @@ out:
 
 /*
  * The exported free_coherent function for dma_ops.
- * FIXME: fix the generic x86 DMA layer so that it actually calls that
- *        function.
  */
 static void free_coherent(struct device *dev, size_t size,
 			  void *virt_addr, dma_addr_t dma_addr)
@@ -1059,6 +1239,9 @@ static void free_coherent(struct device *dev, size_t size,
 	struct protection_domain *domain;
 	u16 devid;
 
+	if (!check_device(dev))
+		return;
+
 	get_device_resources(dev, &iommu, &domain, &devid);
 
 	if (!iommu || !domain)
@@ -1067,9 +1250,8 @@ static void free_coherent(struct device *dev, size_t size,
 	spin_lock_irqsave(&domain->lock, flags);
 
 	__unmap_single(iommu, domain->priv, dma_addr, size, DMA_BIDIRECTIONAL);
-	iommu_flush_pages(iommu, domain->id, dma_addr, size);
 
-	if (iommu->need_sync)
+	if (unlikely(iommu->need_sync))
 		iommu_completion_wait(iommu);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
@@ -1079,6 +1261,30 @@ free_mem:
 }
 
 /*
+ * This function is called by the DMA layer to find out if we can handle a
+ * particular device. It is part of the dma_ops.
+ */
+static int amd_iommu_dma_supported(struct device *dev, u64 mask)
+{
+	u16 bdf;
+	struct pci_dev *pcidev;
+
+	/* No device or no PCI device */
+	if (!dev || dev->bus != &pci_bus_type)
+		return 0;
+
+	pcidev = to_pci_dev(dev);
+
+	bdf = calc_devid(pcidev->bus->number, pcidev->devfn);
+
+	/* Out of our scope? */
+	if (bdf > amd_iommu_last_bdf)
+		return 0;
+
+	return 1;
+}
+
+/*
  * The function for pre-allocating protection domains.
  *
  * If the driver core informs the DMA layer if a driver grabs a device
@@ -1107,10 +1313,9 @@ void prealloc_protection_domains(void)
 		if (!dma_dom)
 			continue;
 		init_unity_mappings_for_device(dma_dom, devid);
-		set_device_domain(iommu, &dma_dom->domain, devid);
-		printk(KERN_INFO "AMD IOMMU: Allocated domain %d for device ",
-		       dma_dom->domain.id);
-		print_devid(devid, 1);
+		dma_dom->target_dev = devid;
+
+		list_add_tail(&dma_dom->list, &iommu_pd_list);
 	}
 }
 
@@ -1121,6 +1326,7 @@ static struct dma_mapping_ops amd_iommu_dma_ops = {
 	.unmap_single = unmap_single,
 	.map_sg = map_sg,
 	.unmap_sg = unmap_sg,
+	.dma_supported = amd_iommu_dma_supported,
 };
 
 /*
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index a69cc0f..148fcfe 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -22,6 +22,8 @@
 #include <linux/gfp.h>
 #include <linux/list.h>
 #include <linux/sysdev.h>
+#include <linux/interrupt.h>
+#include <linux/msi.h>
 #include <asm/pci-direct.h>
 #include <asm/amd_iommu_types.h>
 #include <asm/amd_iommu.h>
@@ -30,7 +32,6 @@
 /*
  * definitions for the ACPI scanning code
  */
-#define PCI_BUS(x) (((x) >> 8) & 0xff)
 #define IVRS_HEADER_LENGTH 48
 
 #define ACPI_IVHD_TYPE                  0x10
@@ -121,6 +122,7 @@ LIST_HEAD(amd_iommu_unity_map);		/* a list of required unity mappings
 					   we find in ACPI */
 unsigned amd_iommu_aperture_order = 26; /* size of aperture in power of 2 */
 int amd_iommu_isolate;			/* if 1, device isolation is enabled */
+bool amd_iommu_unmap_flush;		/* if true, flush on every unmap */
 
 LIST_HEAD(amd_iommu_list);		/* list of all AMD IOMMUs in the
 					   system */
@@ -234,7 +236,7 @@ static void __init iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
 {
 	u32 ctrl;
 
-	ctrl = (u64)readl(iommu->mmio_base + MMIO_CONTROL_OFFSET);
+	ctrl = readl(iommu->mmio_base + MMIO_CONTROL_OFFSET);
 	ctrl &= ~(1 << bit);
 	writel(ctrl, iommu->mmio_base + MMIO_CONTROL_OFFSET);
 }
@@ -242,13 +244,23 @@ static void __init iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
 /* Function to enable the hardware */
 void __init iommu_enable(struct amd_iommu *iommu)
 {
-	printk(KERN_INFO "AMD IOMMU: Enabling IOMMU at ");
-	print_devid(iommu->devid, 0);
-	printk(" cap 0x%hx\n", iommu->cap_ptr);
+	printk(KERN_INFO "AMD IOMMU: Enabling IOMMU "
+	       "at %02x:%02x.%x cap 0x%hx\n",
+	       iommu->dev->bus->number,
+	       PCI_SLOT(iommu->dev->devfn),
+	       PCI_FUNC(iommu->dev->devfn),
+	       iommu->cap_ptr);
 
 	iommu_feature_enable(iommu, CONTROL_IOMMU_EN);
 }
 
+/* Function to enable IOMMU event logging and event interrupts */
+void __init iommu_enable_event_logging(struct amd_iommu *iommu)
+{
+	iommu_feature_enable(iommu, CONTROL_EVT_LOG_EN);
+	iommu_feature_enable(iommu, CONTROL_EVT_INT_EN);
+}
+
 /*
  * mapping and unmapping functions for the IOMMU MMIO space. Each AMD IOMMU in
  * the system has one.
@@ -286,6 +298,14 @@ static void __init iommu_unmap_mmio_space(struct amd_iommu *iommu)
  ****************************************************************************/
 
 /*
+ * This function calculates the length of a given IVHD entry
+ */
+static inline int ivhd_entry_length(u8 *ivhd)
+{
+	return 0x04 << (*ivhd >> 6);
+}
+
+/*
  * This function reads the last device id the IOMMU has to handle from the PCI
  * capability header for this IOMMU
  */
@@ -329,7 +349,7 @@ static int __init find_last_devid_from_ivhd(struct ivhd_header *h)
 		default:
 			break;
 		}
-		p += 0x04 << (*p >> 6);
+		p += ivhd_entry_length(p);
 	}
 
 	WARN_ON(p != end);
@@ -414,7 +434,32 @@ static u8 * __init alloc_command_buffer(struct amd_iommu *iommu)
 
 static void __init free_command_buffer(struct amd_iommu *iommu)
 {
-	free_pages((unsigned long)iommu->cmd_buf, get_order(CMD_BUFFER_SIZE));
+	free_pages((unsigned long)iommu->cmd_buf,
+		   get_order(iommu->cmd_buf_size));
+}
+
+/* allocates the memory where the IOMMU will log its events to */
+static u8 * __init alloc_event_buffer(struct amd_iommu *iommu)
+{
+	u64 entry;
+	iommu->evt_buf = (u8 *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+						get_order(EVT_BUFFER_SIZE));
+
+	if (iommu->evt_buf == NULL)
+		return NULL;
+
+	entry = (u64)virt_to_phys(iommu->evt_buf) | EVT_LEN_MASK;
+	memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
+		    &entry, sizeof(entry));
+
+	iommu->evt_buf_size = EVT_BUFFER_SIZE;
+
+	return iommu->evt_buf;
+}
+
+static void __init free_event_buffer(struct amd_iommu *iommu)
+{
+	free_pages((unsigned long)iommu->evt_buf, get_order(EVT_BUFFER_SIZE));
 }
 
 /* sets a specific bit in the device table entry. */
@@ -487,19 +532,21 @@ static void __init set_device_exclusion_range(u16 devid, struct ivmd_header *m)
  */
 static void __init init_iommu_from_pci(struct amd_iommu *iommu)
 {
-	int bus = PCI_BUS(iommu->devid);
-	int dev = PCI_SLOT(iommu->devid);
-	int fn  = PCI_FUNC(iommu->devid);
 	int cap_ptr = iommu->cap_ptr;
-	u32 range;
+	u32 range, misc;
 
-	iommu->cap = read_pci_config(bus, dev, fn, cap_ptr+MMIO_CAP_HDR_OFFSET);
+	pci_read_config_dword(iommu->dev, cap_ptr + MMIO_CAP_HDR_OFFSET,
+			      &iommu->cap);
+	pci_read_config_dword(iommu->dev, cap_ptr + MMIO_RANGE_OFFSET,
+			      &range);
+	pci_read_config_dword(iommu->dev, cap_ptr + MMIO_MISC_OFFSET,
+			      &misc);
 
-	range = read_pci_config(bus, dev, fn, cap_ptr+MMIO_RANGE_OFFSET);
 	iommu->first_device = calc_devid(MMIO_GET_BUS(range),
 					 MMIO_GET_FD(range));
 	iommu->last_device = calc_devid(MMIO_GET_BUS(range),
 					MMIO_GET_LD(range));
+	iommu->evt_msi_num = MMIO_MSI_NUM(misc);
 }
 
 /*
@@ -604,7 +651,7 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 			break;
 		}
 
-		p += 0x04 << (e->type >> 6);
+		p += ivhd_entry_length(p);
 	}
 }
 
@@ -622,6 +669,7 @@ static int __init init_iommu_devices(struct amd_iommu *iommu)
 static void __init free_iommu_one(struct amd_iommu *iommu)
 {
 	free_command_buffer(iommu);
+	free_event_buffer(iommu);
 	iommu_unmap_mmio_space(iommu);
 }
 
@@ -649,8 +697,12 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 	/*
 	 * Copy data from ACPI table entry to the iommu struct
 	 */
-	iommu->devid = h->devid;
+	iommu->dev = pci_get_bus_and_slot(PCI_BUS(h->devid), h->devid & 0xff);
+	if (!iommu->dev)
+		return 1;
+
 	iommu->cap_ptr = h->cap_ptr;
+	iommu->pci_seg = h->pci_seg;
 	iommu->mmio_phys = h->mmio_phys;
 	iommu->mmio_base = iommu_map_mmio_space(h->mmio_phys);
 	if (!iommu->mmio_base)
@@ -661,10 +713,18 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 	if (!iommu->cmd_buf)
 		return -ENOMEM;
 
+	iommu->evt_buf = alloc_event_buffer(iommu);
+	if (!iommu->evt_buf)
+		return -ENOMEM;
+
+	iommu->int_enabled = false;
+
 	init_iommu_from_pci(iommu);
 	init_iommu_from_acpi(iommu, h);
 	init_iommu_devices(iommu);
 
+	pci_enable_device(iommu->dev);
+
 	return 0;
 }
 
@@ -706,6 +766,95 @@ static int __init init_iommu_all(struct acpi_table_header *table)
 
 /****************************************************************************
  *
+ * The following functions initialize the MSI interrupts for all IOMMUs
+ * in the system. Its a bit challenging because there could be multiple
+ * IOMMUs per PCI BDF but we can call pci_enable_msi(x) only once per
+ * pci_dev.
+ *
+ ****************************************************************************/
+
+static int __init iommu_setup_msix(struct amd_iommu *iommu)
+{
+	struct amd_iommu *curr;
+	struct msix_entry entries[32]; /* only 32 supported by AMD IOMMU */
+	int nvec = 0, i;
+
+	list_for_each_entry(curr, &amd_iommu_list, list) {
+		if (curr->dev == iommu->dev) {
+			entries[nvec].entry = curr->evt_msi_num;
+			entries[nvec].vector = 0;
+			curr->int_enabled = true;
+			nvec++;
+		}
+	}
+
+	if (pci_enable_msix(iommu->dev, entries, nvec)) {
+		pci_disable_msix(iommu->dev);
+		return 1;
+	}
+
+	for (i = 0; i < nvec; ++i) {
+		int r = request_irq(entries->vector, amd_iommu_int_handler,
+				    IRQF_SAMPLE_RANDOM,
+				    "AMD IOMMU",
+				    NULL);
+		if (r)
+			goto out_free;
+	}
+
+	return 0;
+
+out_free:
+	for (i -= 1; i >= 0; --i)
+		free_irq(entries->vector, NULL);
+
+	pci_disable_msix(iommu->dev);
+
+	return 1;
+}
+
+static int __init iommu_setup_msi(struct amd_iommu *iommu)
+{
+	int r;
+	struct amd_iommu *curr;
+
+	list_for_each_entry(curr, &amd_iommu_list, list) {
+		if (curr->dev == iommu->dev)
+			curr->int_enabled = true;
+	}
+
+
+	if (pci_enable_msi(iommu->dev))
+		return 1;
+
+	r = request_irq(iommu->dev->irq, amd_iommu_int_handler,
+			IRQF_SAMPLE_RANDOM,
+			"AMD IOMMU",
+			NULL);
+
+	if (r) {
+		pci_disable_msi(iommu->dev);
+		return 1;
+	}
+
+	return 0;
+}
+
+static int __init iommu_init_msi(struct amd_iommu *iommu)
+{
+	if (iommu->int_enabled)
+		return 0;
+
+	if (pci_find_capability(iommu->dev, PCI_CAP_ID_MSIX))
+		return iommu_setup_msix(iommu);
+	else if (pci_find_capability(iommu->dev, PCI_CAP_ID_MSI))
+		return iommu_setup_msi(iommu);
+
+	return 1;
+}
+
+/****************************************************************************
+ *
  * The next functions belong to the third pass of parsing the ACPI
  * table. In this last pass the memory mapping requirements are
  * gathered (like exclusion and unity mapping reanges).
@@ -811,7 +960,6 @@ static void init_device_table(void)
 	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid) {
 		set_dev_entry_bit(devid, DEV_ENTRY_VALID);
 		set_dev_entry_bit(devid, DEV_ENTRY_TRANSLATION);
-		set_dev_entry_bit(devid, DEV_ENTRY_NO_PAGE_FAULT);
 	}
 }
 
@@ -825,6 +973,8 @@ static void __init enable_iommus(void)
 
 	list_for_each_entry(iommu, &amd_iommu_list, list) {
 		iommu_set_exclusion_range(iommu);
+		iommu_init_msi(iommu);
+		iommu_enable_event_logging(iommu);
 		iommu_enable(iommu);
 	}
 }
@@ -995,11 +1145,17 @@ int __init amd_iommu_init(void)
 	else
 		printk("disabled\n");
 
+	if (amd_iommu_unmap_flush)
+		printk(KERN_INFO "AMD IOMMU: IO/TLB flush on unmap enabled\n");
+	else
+		printk(KERN_INFO "AMD IOMMU: Lazy IO/TLB flushing enabled\n");
+
 out:
 	return ret;
 
 free:
-	free_pages((unsigned long)amd_iommu_pd_alloc_bitmap, 1);
+	free_pages((unsigned long)amd_iommu_pd_alloc_bitmap,
+		   get_order(MAX_DOMAIN_ID/8));
 
 	free_pages((unsigned long)amd_iommu_pd_table,
 		   get_order(rlookup_table_size));
@@ -1057,8 +1213,10 @@ void __init amd_iommu_detect(void)
 static int __init parse_amd_iommu_options(char *str)
 {
 	for (; *str; ++str) {
-		if (strcmp(str, "isolate") == 0)
+		if (strncmp(str, "isolate", 7) == 0)
 			amd_iommu_isolate = 1;
+		if (strncmp(str, "fullflush", 11) == 0)
+			amd_iommu_unmap_flush = true;
 	}
 
 	return 1;
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 4353cf5..24bb5fa 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -95,6 +95,20 @@ static void __init nvidia_bugs(int num, int slot, int func)
 
 }
 
+#ifdef CONFIG_DMAR
+static void __init intel_g33_dmar(int num, int slot, int func)
+{
+	struct acpi_table_header *dmar_tbl;
+	acpi_status status;
+
+	status = acpi_get_table(ACPI_SIG_DMAR, 0, &dmar_tbl);
+	if (ACPI_SUCCESS(status)) {
+		printk(KERN_INFO "BIOS BUG: DMAR advertised on Intel G31/G33 chipset -- ignoring\n");
+		dmar_disabled = 1;
+	}
+}
+#endif
+
 #define QFLAG_APPLY_ONCE 	0x1
 #define QFLAG_APPLIED		0x2
 #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
@@ -114,6 +128,10 @@ static struct chipset early_qrk[] __initdata = {
 	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, via_bugs },
 	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB,
 	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, fix_hypertransport_config },
+#ifdef CONFIG_DMAR
+	{ PCI_VENDOR_ID_INTEL, 0x29c0,
+	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, intel_g33_dmar },
+#endif
 	{}
 };
 
diff --git a/arch/x86/kernel/k8.c b/arch/x86/kernel/k8.c
index 7377ccb..304d8ba 100644
--- a/arch/x86/kernel/k8.c
+++ b/arch/x86/kernel/k8.c
@@ -16,8 +16,9 @@ EXPORT_SYMBOL(num_k8_northbridges);
 static u32 *flush_words;
 
 struct pci_device_id k8_nb_ids[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1103) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1203) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_11H_NB_MISC) },
 	{}
 };
 EXPORT_SYMBOL(k8_nb_ids);
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index dcdac6c..080d1d2 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -261,7 +261,7 @@ static void iommu_range_reserve(struct iommu_table *tbl,
 			       badbit, tbl, start_addr, npages);
 	}
 
-	set_bit_string(tbl->it_map, index, npages);
+	iommu_area_reserve(tbl->it_map, index, npages);
 
 	spin_unlock_irqrestore(&tbl->it_lock, flags);
 }
@@ -491,6 +491,8 @@ static void* calgary_alloc_coherent(struct device *dev, size_t size,
 	npages = size >> PAGE_SHIFT;
 	order = get_order(size);
 
+	flag &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
+
 	/* alloc enough pages (and possibly more) */
 	ret = (void *)__get_free_pages(flag, order);
 	if (!ret)
@@ -510,8 +512,22 @@ error:
 	return ret;
 }
 
+static void calgary_free_coherent(struct device *dev, size_t size,
+				  void *vaddr, dma_addr_t dma_handle)
+{
+	unsigned int npages;
+	struct iommu_table *tbl = find_iommu_table(dev);
+
+	size = PAGE_ALIGN(size);
+	npages = size >> PAGE_SHIFT;
+
+	iommu_free(tbl, dma_handle, npages);
+	free_pages((unsigned long)vaddr, get_order(size));
+}
+
 static struct dma_mapping_ops calgary_dma_ops = {
 	.alloc_coherent = calgary_alloc_coherent,
+	.free_coherent = calgary_free_coherent,
 	.map_single = calgary_map_single,
 	.unmap_single = calgary_unmap_single,
 	.map_sg = calgary_map_sg,
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index f704cb5..0a3824e 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -41,11 +41,12 @@ EXPORT_SYMBOL(bad_dma_address);
 /* Dummy device used for NULL arguments (normally ISA). Better would
    be probably a smaller DMA mask, but this is bug-to-bug compatible
    to older i386. */
-struct device fallback_dev = {
+struct device x86_dma_fallback_dev = {
 	.bus_id = "fallback device",
 	.coherent_dma_mask = DMA_32BIT_MASK,
-	.dma_mask = &fallback_dev.coherent_dma_mask,
+	.dma_mask = &x86_dma_fallback_dev.coherent_dma_mask,
 };
+EXPORT_SYMBOL(x86_dma_fallback_dev);
 
 int dma_set_mask(struct device *dev, u64 mask)
 {
@@ -133,6 +134,37 @@ unsigned long iommu_num_pages(unsigned long addr, unsigned long len)
 EXPORT_SYMBOL(iommu_num_pages);
 #endif
 
+void *dma_generic_alloc_coherent(struct device *dev, size_t size,
+				 dma_addr_t *dma_addr, gfp_t flag)
+{
+	unsigned long dma_mask;
+	struct page *page;
+	dma_addr_t addr;
+
+	dma_mask = dma_alloc_coherent_mask(dev, flag);
+
+	flag |= __GFP_ZERO;
+again:
+	page = alloc_pages_node(dev_to_node(dev), flag, get_order(size));
+	if (!page)
+		return NULL;
+
+	addr = page_to_phys(page);
+	if (!is_buffer_dma_capable(dma_mask, addr, size)) {
+		__free_pages(page, get_order(size));
+
+		if (dma_mask < DMA_32BIT_MASK && !(flag & GFP_DMA)) {
+			flag = (flag & ~GFP_DMA32) | GFP_DMA;
+			goto again;
+		}
+
+		return NULL;
+	}
+
+	*dma_addr = addr;
+	return page_address(page);
+}
+
 /*
  * See <Documentation/x86_64/boot-options.txt> for the iommu kernel parameter
  * documentation.
@@ -241,147 +273,6 @@ int dma_supported(struct device *dev, u64 mask)
 }
 EXPORT_SYMBOL(dma_supported);
 
-/* Allocate DMA memory on node near device */
-static noinline struct page *
-dma_alloc_pages(struct device *dev, gfp_t gfp, unsigned order)
-{
-	int node;
-
-	node = dev_to_node(dev);
-
-	return alloc_pages_node(node, gfp, order);
-}
-
-/*
- * Allocate memory for a coherent mapping.
- */
-void *
-dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
-		   gfp_t gfp)
-{
-	struct dma_mapping_ops *ops = get_dma_ops(dev);
-	void *memory = NULL;
-	struct page *page;
-	unsigned long dma_mask = 0;
-	dma_addr_t bus;
-	int noretry = 0;
-
-	/* ignore region specifiers */
-	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
-
-	if (dma_alloc_from_coherent(dev, size, dma_handle, &memory))
-		return memory;
-
-	if (!dev) {
-		dev = &fallback_dev;
-		gfp |= GFP_DMA;
-	}
-	dma_mask = dev->coherent_dma_mask;
-	if (dma_mask == 0)
-		dma_mask = (gfp & GFP_DMA) ? DMA_24BIT_MASK : DMA_32BIT_MASK;
-
-	/* Device not DMA able */
-	if (dev->dma_mask == NULL)
-		return NULL;
-
-	/* Don't invoke OOM killer or retry in lower 16MB DMA zone */
-	if (gfp & __GFP_DMA)
-		noretry = 1;
-
-#ifdef CONFIG_X86_64
-	/* Why <=? Even when the mask is smaller than 4GB it is often
-	   larger than 16MB and in this case we have a chance of
-	   finding fitting memory in the next higher zone first. If
-	   not retry with true GFP_DMA. -AK */
-	if (dma_mask <= DMA_32BIT_MASK && !(gfp & GFP_DMA)) {
-		gfp |= GFP_DMA32;
-		if (dma_mask < DMA_32BIT_MASK)
-			noretry = 1;
-	}
-#endif
-
- again:
-	page = dma_alloc_pages(dev,
-		noretry ? gfp | __GFP_NORETRY : gfp, get_order(size));
-	if (page == NULL)
-		return NULL;
-
-	{
-		int high, mmu;
-		bus = page_to_phys(page);
-		memory = page_address(page);
-		high = (bus + size) >= dma_mask;
-		mmu = high;
-		if (force_iommu && !(gfp & GFP_DMA))
-			mmu = 1;
-		else if (high) {
-			free_pages((unsigned long)memory,
-				   get_order(size));
-
-			/* Don't use the 16MB ZONE_DMA unless absolutely
-			   needed. It's better to use remapping first. */
-			if (dma_mask < DMA_32BIT_MASK && !(gfp & GFP_DMA)) {
-				gfp = (gfp & ~GFP_DMA32) | GFP_DMA;
-				goto again;
-			}
-
-			/* Let low level make its own zone decisions */
-			gfp &= ~(GFP_DMA32|GFP_DMA);
-
-			if (ops->alloc_coherent)
-				return ops->alloc_coherent(dev, size,
-							   dma_handle, gfp);
-			return NULL;
-		}
-
-		memset(memory, 0, size);
-		if (!mmu) {
-			*dma_handle = bus;
-			return memory;
-		}
-	}
-
-	if (ops->alloc_coherent) {
-		free_pages((unsigned long)memory, get_order(size));
-		gfp &= ~(GFP_DMA|GFP_DMA32);
-		return ops->alloc_coherent(dev, size, dma_handle, gfp);
-	}
-
-	if (ops->map_simple) {
-		*dma_handle = ops->map_simple(dev, virt_to_phys(memory),
-					      size,
-					      PCI_DMA_BIDIRECTIONAL);
-		if (*dma_handle != bad_dma_address)
-			return memory;
-	}
-
-	if (panic_on_overflow)
-		panic("dma_alloc_coherent: IOMMU overflow by %lu bytes\n",
-		      (unsigned long)size);
-	free_pages((unsigned long)memory, get_order(size));
-	return NULL;
-}
-EXPORT_SYMBOL(dma_alloc_coherent);
-
-/*
- * Unmap coherent memory.
- * The caller must ensure that the device has finished accessing the mapping.
- */
-void dma_free_coherent(struct device *dev, size_t size,
-			 void *vaddr, dma_addr_t bus)
-{
-	struct dma_mapping_ops *ops = get_dma_ops(dev);
-
-	int order = get_order(size);
-	WARN_ON(irqs_disabled());	/* for portability */
-	if (dma_release_from_coherent(dev, order, vaddr))
-		return;
-	if (ops->unmap_single)
-		ops->unmap_single(dev, bus, size, 0);
-	free_pages((unsigned long)vaddr, order);
-}
-EXPORT_SYMBOL(dma_free_coherent);
-
 static int __init pci_iommu_init(void)
 {
 	calgary_iommu_init();
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 1a895a5..145f1c8 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -27,8 +27,8 @@
 #include <linux/scatterlist.h>
 #include <linux/iommu-helper.h>
 #include <linux/sysdev.h>
+#include <linux/io.h>
 #include <asm/atomic.h>
-#include <asm/io.h>
 #include <asm/mtrr.h>
 #include <asm/pgtable.h>
 #include <asm/proto.h>
@@ -80,7 +80,7 @@ AGPEXTERN int agp_memory_reserved;
 AGPEXTERN __u32 *agp_gatt_table;
 
 static unsigned long next_bit;  /* protected by iommu_bitmap_lock */
-static int need_flush;		/* global flush state. set for each gart wrap */
+static bool need_flush;		/* global flush state. set for each gart wrap */
 
 static unsigned long alloc_iommu(struct device *dev, int size,
 				 unsigned long align_mask)
@@ -98,7 +98,7 @@ static unsigned long alloc_iommu(struct device *dev, int size,
 	offset = iommu_area_alloc(iommu_gart_bitmap, iommu_pages, next_bit,
 				  size, base_index, boundary_size, align_mask);
 	if (offset == -1) {
-		need_flush = 1;
+		need_flush = true;
 		offset = iommu_area_alloc(iommu_gart_bitmap, iommu_pages, 0,
 					  size, base_index, boundary_size,
 					  align_mask);
@@ -107,11 +107,11 @@ static unsigned long alloc_iommu(struct device *dev, int size,
 		next_bit = offset+size;
 		if (next_bit >= iommu_pages) {
 			next_bit = 0;
-			need_flush = 1;
+			need_flush = true;
 		}
 	}
 	if (iommu_fullflush)
-		need_flush = 1;
+		need_flush = true;
 	spin_unlock_irqrestore(&iommu_bitmap_lock, flags);
 
 	return offset;
@@ -136,7 +136,7 @@ static void flush_gart(void)
 	spin_lock_irqsave(&iommu_bitmap_lock, flags);
 	if (need_flush) {
 		k8_flush_garts();
-		need_flush = 0;
+		need_flush = false;
 	}
 	spin_unlock_irqrestore(&iommu_bitmap_lock, flags);
 }
@@ -175,7 +175,8 @@ static void dump_leak(void)
 	       iommu_leak_pages);
 	for (i = 0; i < iommu_leak_pages; i += 2) {
 		printk(KERN_DEBUG "%lu: ", iommu_pages-i);
-		printk_address((unsigned long) iommu_leak_tab[iommu_pages-i], 0);
+		printk_address((unsigned long) iommu_leak_tab[iommu_pages-i],
+				0);
 		printk(KERN_CONT "%c", (i+1)%2 == 0 ? '\n' : ' ');
 	}
 	printk(KERN_DEBUG "\n");
@@ -214,24 +215,14 @@ static void iommu_full(struct device *dev, size_t size, int dir)
 static inline int
 need_iommu(struct device *dev, unsigned long addr, size_t size)
 {
-	u64 mask = *dev->dma_mask;
-	int high = addr + size > mask;
-	int mmu = high;
-
-	if (force_iommu)
-		mmu = 1;
-
-	return mmu;
+	return force_iommu ||
+		!is_buffer_dma_capable(*dev->dma_mask, addr, size);
 }
 
 static inline int
 nonforced_iommu(struct device *dev, unsigned long addr, size_t size)
 {
-	u64 mask = *dev->dma_mask;
-	int high = addr + size > mask;
-	int mmu = high;
-
-	return mmu;
+	return !is_buffer_dma_capable(*dev->dma_mask, addr, size);
 }
 
 /* Map a single continuous physical area into the IOMMU.
@@ -261,20 +252,6 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 	return iommu_bus_base + iommu_page*PAGE_SIZE + (phys_mem & ~PAGE_MASK);
 }
 
-static dma_addr_t
-gart_map_simple(struct device *dev, phys_addr_t paddr, size_t size, int dir)
-{
-	dma_addr_t map;
-	unsigned long align_mask;
-
-	align_mask = (1UL << get_order(size)) - 1;
-	map = dma_map_area(dev, paddr, size, dir, align_mask);
-
-	flush_gart();
-
-	return map;
-}
-
 /* Map a single area into the IOMMU */
 static dma_addr_t
 gart_map_single(struct device *dev, phys_addr_t paddr, size_t size, int dir)
@@ -282,7 +259,7 @@ gart_map_single(struct device *dev, phys_addr_t paddr, size_t size, int dir)
 	unsigned long bus;
 
 	if (!dev)
-		dev = &fallback_dev;
+		dev = &x86_dma_fallback_dev;
 
 	if (!need_iommu(dev, paddr, size))
 		return paddr;
@@ -434,7 +411,7 @@ gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 		return 0;
 
 	if (!dev)
-		dev = &fallback_dev;
+		dev = &x86_dma_fallback_dev;
 
 	out = 0;
 	start = 0;
@@ -506,6 +483,46 @@ error:
 	return 0;
 }
 
+/* allocate and map a coherent mapping */
+static void *
+gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
+		    gfp_t flag)
+{
+	dma_addr_t paddr;
+	unsigned long align_mask;
+	struct page *page;
+
+	if (force_iommu && !(flag & GFP_DMA)) {
+		flag &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
+		page = alloc_pages(flag | __GFP_ZERO, get_order(size));
+		if (!page)
+			return NULL;
+
+		align_mask = (1UL << get_order(size)) - 1;
+		paddr = dma_map_area(dev, page_to_phys(page), size,
+				     DMA_BIDIRECTIONAL, align_mask);
+
+		flush_gart();
+		if (paddr != bad_dma_address) {
+			*dma_addr = paddr;
+			return page_address(page);
+		}
+		__free_pages(page, get_order(size));
+	} else
+		return dma_generic_alloc_coherent(dev, size, dma_addr, flag);
+
+	return NULL;
+}
+
+/* free a coherent mapping */
+static void
+gart_free_coherent(struct device *dev, size_t size, void *vaddr,
+		   dma_addr_t dma_addr)
+{
+	gart_unmap_single(dev, dma_addr, size, DMA_BIDIRECTIONAL);
+	free_pages((unsigned long)vaddr, get_order(size));
+}
+
 static int no_agp;
 
 static __init unsigned long check_iommu_size(unsigned long aper, u64 aper_size)
@@ -656,13 +673,13 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 	info->aper_size = aper_size >> 20;
 
 	gatt_size = (aper_size >> PAGE_SHIFT) * sizeof(u32);
-	gatt = (void *)__get_free_pages(GFP_KERNEL, get_order(gatt_size));
+	gatt = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+					get_order(gatt_size));
 	if (!gatt)
 		panic("Cannot allocate GATT table");
 	if (set_memory_uc((unsigned long)gatt, gatt_size >> PAGE_SHIFT))
 		panic("Could not set GART PTEs to uncacheable pages");
 
-	memset(gatt, 0, gatt_size);
 	agp_gatt_table = gatt;
 
 	enable_gart_translations();
@@ -671,7 +688,8 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 	if (!error)
 		error = sysdev_register(&device_gart);
 	if (error)
-		panic("Could not register gart_sysdev -- would corrupt data on next suspend");
+		panic("Could not register gart_sysdev -- "
+		      "would corrupt data on next suspend");
 
 	flush_gart();
 
@@ -687,20 +705,13 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 	return -1;
 }
 
-extern int agp_amd64_init(void);
-
 static struct dma_mapping_ops gart_dma_ops = {
 	.map_single			= gart_map_single,
-	.map_simple			= gart_map_simple,
 	.unmap_single			= gart_unmap_single,
-	.sync_single_for_cpu		= NULL,
-	.sync_single_for_device		= NULL,
-	.sync_single_range_for_cpu	= NULL,
-	.sync_single_range_for_device	= NULL,
-	.sync_sg_for_cpu		= NULL,
-	.sync_sg_for_device		= NULL,
 	.map_sg				= gart_map_sg,
 	.unmap_sg			= gart_unmap_sg,
+	.alloc_coherent			= gart_alloc_coherent,
+	.free_coherent			= gart_free_coherent,
 };
 
 void gart_iommu_shutdown(void)
@@ -760,8 +771,8 @@ void __init gart_iommu_init(void)
 	    (no_agp && init_k8_gatt(&info) < 0)) {
 		if (max_pfn > MAX_DMA32_PFN) {
 			printk(KERN_WARNING "More than 4GB of memory "
-			       	          "but GART IOMMU not available.\n"
-			       KERN_WARNING "falling back to iommu=soft.\n");
+			       "but GART IOMMU not available.\n");
+			printk(KERN_WARNING "falling back to iommu=soft.\n");
 		}
 		return;
 	}
@@ -779,19 +790,16 @@ void __init gart_iommu_init(void)
 	iommu_size = check_iommu_size(info.aper_base, aper_size);
 	iommu_pages = iommu_size >> PAGE_SHIFT;
 
-	iommu_gart_bitmap = (void *) __get_free_pages(GFP_KERNEL,
+	iommu_gart_bitmap = (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
 						      get_order(iommu_pages/8));
 	if (!iommu_gart_bitmap)
 		panic("Cannot allocate iommu bitmap\n");
-	memset(iommu_gart_bitmap, 0, iommu_pages/8);
 
 #ifdef CONFIG_IOMMU_LEAK
 	if (leak_trace) {
-		iommu_leak_tab = (void *)__get_free_pages(GFP_KERNEL,
+		iommu_leak_tab = (void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO,
 				  get_order(iommu_pages*sizeof(void *)));
-		if (iommu_leak_tab)
-			memset(iommu_leak_tab, 0, iommu_pages * 8);
-		else
+		if (!iommu_leak_tab)
 			printk(KERN_DEBUG
 			       "PCI-DMA: Cannot allocate leak trace area\n");
 	}
@@ -801,7 +809,7 @@ void __init gart_iommu_init(void)
 	 * Out of IOMMU space handling.
 	 * Reserve some invalid pages at the beginning of the GART.
 	 */
-	set_bit_string(iommu_gart_bitmap, 0, EMERGENCY_PAGES);
+	iommu_area_reserve(iommu_gart_bitmap, 0, EMERGENCY_PAGES);
 
 	agp_memory_reserved = iommu_size;
 	printk(KERN_INFO
@@ -859,7 +867,8 @@ void __init gart_parse_options(char *p)
 	if (!strncmp(p, "leak", 4)) {
 		leak_trace = 1;
 		p += 4;
-		if (*p == '=') ++p;
+		if (*p == '=')
+			++p;
 		if (isdigit(*p) && get_option(&p, &arg))
 			iommu_leak_pages = arg;
 	}
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index 3f91f71..c70ab5a 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -14,7 +14,7 @@
 static int
 check_addr(char *name, struct device *hwdev, dma_addr_t bus, size_t size)
 {
-	if (hwdev && bus + size > *hwdev->dma_mask) {
+	if (hwdev && !is_buffer_dma_capable(*hwdev->dma_mask, bus, size)) {
 		if (*hwdev->dma_mask >= DMA_32BIT_MASK)
 			printk(KERN_ERR
 			    "nommu_%s: overflow %Lx+%zu of device mask %Lx\n",
@@ -72,7 +72,15 @@ static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
 	return nents;
 }
 
+static void nommu_free_coherent(struct device *dev, size_t size, void *vaddr,
+				dma_addr_t dma_addr)
+{
+	free_pages((unsigned long)vaddr, get_order(size));
+}
+
 struct dma_mapping_ops nommu_dma_ops = {
+	.alloc_coherent = dma_generic_alloc_coherent,
+	.free_coherent = nommu_free_coherent,
 	.map_single = nommu_map_single,
 	.map_sg = nommu_map_sg,
 	.is_phys = 1,
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index c3edcdc..6c4c1c3 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -80,7 +80,7 @@ static long list_size;
 
 static void domain_remove_dev_info(struct dmar_domain *domain);
 
-static int dmar_disabled;
+int dmar_disabled;
 static int __initdata dmar_map_gfx = 1;
 static int dmar_forcedac;
 static int intel_iommu_strict;
diff --git a/include/asm-x86/amd_iommu.h b/include/asm-x86/amd_iommu.h
index 783f43e..041d0db 100644
--- a/include/asm-x86/amd_iommu.h
+++ b/include/asm-x86/amd_iommu.h
@@ -20,10 +20,13 @@
 #ifndef ASM_X86__AMD_IOMMU_H
 #define ASM_X86__AMD_IOMMU_H
 
+#include <linux/irqreturn.h>
+
 #ifdef CONFIG_AMD_IOMMU
 extern int amd_iommu_init(void);
 extern int amd_iommu_init_dma_ops(void);
 extern void amd_iommu_detect(void);
+extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
 #else
 static inline int amd_iommu_init(void) { return -ENODEV; }
 static inline void amd_iommu_detect(void) { }
diff --git a/include/asm-x86/amd_iommu_types.h b/include/asm-x86/amd_iommu_types.h
index 1ffa4e5..b308586 100644
--- a/include/asm-x86/amd_iommu_types.h
+++ b/include/asm-x86/amd_iommu_types.h
@@ -37,6 +37,7 @@
 /* Capability offsets used by the driver */
 #define MMIO_CAP_HDR_OFFSET	0x00
 #define MMIO_RANGE_OFFSET	0x0c
+#define MMIO_MISC_OFFSET	0x10
 
 /* Masks, shifts and macros to parse the device range capability */
 #define MMIO_RANGE_LD_MASK	0xff000000
@@ -48,6 +49,7 @@
 #define MMIO_GET_LD(x)  (((x) & MMIO_RANGE_LD_MASK) >> MMIO_RANGE_LD_SHIFT)
 #define MMIO_GET_FD(x)  (((x) & MMIO_RANGE_FD_MASK) >> MMIO_RANGE_FD_SHIFT)
 #define MMIO_GET_BUS(x) (((x) & MMIO_RANGE_BUS_MASK) >> MMIO_RANGE_BUS_SHIFT)
+#define MMIO_MSI_NUM(x)	((x) & 0x1f)
 
 /* Flag masks for the AMD IOMMU exclusion range */
 #define MMIO_EXCL_ENABLE_MASK 0x01ULL
@@ -69,6 +71,25 @@
 /* MMIO status bits */
 #define MMIO_STATUS_COM_WAIT_INT_MASK	0x04
 
+/* event logging constants */
+#define EVENT_ENTRY_SIZE	0x10
+#define EVENT_TYPE_SHIFT	28
+#define EVENT_TYPE_MASK		0xf
+#define EVENT_TYPE_ILL_DEV	0x1
+#define EVENT_TYPE_IO_FAULT	0x2
+#define EVENT_TYPE_DEV_TAB_ERR	0x3
+#define EVENT_TYPE_PAGE_TAB_ERR	0x4
+#define EVENT_TYPE_ILL_CMD	0x5
+#define EVENT_TYPE_CMD_HARD_ERR	0x6
+#define EVENT_TYPE_IOTLB_INV_TO	0x7
+#define EVENT_TYPE_INV_DEV_REQ	0x8
+#define EVENT_DEVID_MASK	0xffff
+#define EVENT_DEVID_SHIFT	0
+#define EVENT_DOMID_MASK	0xffff
+#define EVENT_DOMID_SHIFT	0
+#define EVENT_FLAGS_MASK	0xfff
+#define EVENT_FLAGS_SHIFT	0x10
+
 /* feature control bits */
 #define CONTROL_IOMMU_EN        0x00ULL
 #define CONTROL_HT_TUN_EN       0x01ULL
@@ -109,6 +130,8 @@
 #define DEV_ENTRY_NMI_PASS      0xba
 #define DEV_ENTRY_LINT0_PASS    0xbe
 #define DEV_ENTRY_LINT1_PASS    0xbf
+#define DEV_ENTRY_MODE_MASK	0x07
+#define DEV_ENTRY_MODE_SHIFT	0x09
 
 /* constants to configure the command buffer */
 #define CMD_BUFFER_SIZE    8192
@@ -116,6 +139,10 @@
 #define MMIO_CMD_SIZE_SHIFT 56
 #define MMIO_CMD_SIZE_512 (0x9ULL << MMIO_CMD_SIZE_SHIFT)
 
+/* constants for event buffer handling */
+#define EVT_BUFFER_SIZE		8192 /* 512 entries */
+#define EVT_LEN_MASK		(0x9ULL << 56)
+
 #define PAGE_MODE_1_LEVEL 0x01
 #define PAGE_MODE_2_LEVEL 0x02
 #define PAGE_MODE_3_LEVEL 0x03
@@ -134,6 +161,7 @@
 #define IOMMU_MAP_SIZE_L3 (1ULL << 39)
 
 #define IOMMU_PTE_P  (1ULL << 0)
+#define IOMMU_PTE_TV (1ULL << 1)
 #define IOMMU_PTE_U  (1ULL << 59)
 #define IOMMU_PTE_FC (1ULL << 60)
 #define IOMMU_PTE_IR (1ULL << 61)
@@ -159,6 +187,9 @@
 
 #define MAX_DOMAIN_ID 65536
 
+/* FIXME: move this macro to <linux/pci.h> */
+#define PCI_BUS(x) (((x) >> 8) & 0xff)
+
 /*
  * This structure contains generic data for  IOMMU protection domains
  * independent of their use.
@@ -196,6 +227,15 @@ struct dma_ops_domain {
 	 * just calculate its address in constant time.
 	 */
 	u64 **pte_pages;
+
+	/* This will be set to true when TLB needs to be flushed */
+	bool need_flush;
+
+	/*
+	 * if this is a preallocated domain, keep the device for which it was
+	 * preallocated in this variable
+	 */
+	u16 target_dev;
 };
 
 /*
@@ -208,8 +248,9 @@ struct amd_iommu {
 	/* locks the accesses to the hardware */
 	spinlock_t lock;
 
-	/* device id of this IOMMU */
-	u16 devid;
+	/* Pointer to PCI device of this IOMMU */
+	struct pci_dev *dev;
+
 	/*
 	 * Capability pointer. There could be more than one IOMMU per PCI
 	 * device function if there are more than one AMD IOMMU capability
@@ -225,6 +266,9 @@ struct amd_iommu {
 	/* capabilities of that IOMMU read from ACPI */
 	u32 cap;
 
+	/* pci domain of this IOMMU */
+	u16 pci_seg;
+
 	/* first device this IOMMU handles. read from PCI */
 	u16 first_device;
 	/* last device this IOMMU handles. read from PCI */
@@ -240,9 +284,19 @@ struct amd_iommu {
 	/* size of command buffer */
 	u32 cmd_buf_size;
 
+	/* event buffer virtual address */
+	u8 *evt_buf;
+	/* size of event buffer */
+	u32 evt_buf_size;
+	/* MSI number for event interrupt */
+	u16 evt_msi_num;
+
 	/* if one, we need to send a completion wait command */
 	int need_sync;
 
+	/* true if interrupts for this IOMMU are already enabled */
+	bool int_enabled;
+
 	/* default dma_ops domain for that IOMMU */
 	struct dma_ops_domain *default_dom;
 };
@@ -322,6 +376,12 @@ extern unsigned long *amd_iommu_pd_alloc_bitmap;
 /* will be 1 if device isolation is enabled */
 extern int amd_iommu_isolate;
 
+/*
+ * If true, the addresses will be flushed on unmap time, not when
+ * they are reused
+ */
+extern bool amd_iommu_unmap_flush;
+
 /* takes a PCI device id and prints it out in a readable form */
 static inline void print_devid(u16 devid, int nl)
 {
diff --git a/include/asm-x86/bitops.h b/include/asm-x86/bitops.h
index 61989b9..451a747 100644
--- a/include/asm-x86/bitops.h
+++ b/include/asm-x86/bitops.h
@@ -424,16 +424,6 @@ static inline int fls(int x)
 
 #undef ADDR
 
-static inline void set_bit_string(unsigned long *bitmap,
-		unsigned long i, int len)
-{
-	unsigned long end = i + len;
-	while (i < end) {
-		__set_bit(i, bitmap);
-		i++;
-	}
-}
-
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/sched.h>
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 5d200e7..219c33d 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -9,12 +9,12 @@
 #include <linux/scatterlist.h>
 #include <asm/io.h>
 #include <asm/swiotlb.h>
+#include <asm-generic/dma-coherent.h>
 
 extern dma_addr_t bad_dma_address;
 extern int iommu_merge;
-extern struct device fallback_dev;
+extern struct device x86_dma_fallback_dev;
 extern int panic_on_overflow;
-extern int force_iommu;
 
 struct dma_mapping_ops {
 	int             (*mapping_error)(struct device *dev,
@@ -25,9 +25,6 @@ struct dma_mapping_ops {
 				void *vaddr, dma_addr_t dma_handle);
 	dma_addr_t      (*map_single)(struct device *hwdev, phys_addr_t ptr,
 				size_t size, int direction);
-	/* like map_single, but doesn't check the device mask */
-	dma_addr_t      (*map_simple)(struct device *hwdev, phys_addr_t ptr,
-				size_t size, int direction);
 	void            (*unmap_single)(struct device *dev, dma_addr_t addr,
 				size_t size, int direction);
 	void            (*sync_single_for_cpu)(struct device *hwdev,
@@ -68,7 +65,7 @@ static inline struct dma_mapping_ops *get_dma_ops(struct device *dev)
 		return dma_ops;
 	else
 		return dev->archdata.dma_ops;
-#endif
+#endif /* ASM_X86__DMA_MAPPING_H */
 }
 
 /* Make sure we keep the same behaviour */
@@ -87,17 +84,14 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			   dma_addr_t *dma_handle, gfp_t flag);
-
-void dma_free_coherent(struct device *dev, size_t size,
-			 void *vaddr, dma_addr_t dma_handle);
-
+#define dma_is_consistent(d, h)	(1)
 
 extern int dma_supported(struct device *hwdev, u64 mask);
 extern int dma_set_mask(struct device *dev, u64 mask);
 
+extern void *dma_generic_alloc_coherent(struct device *dev, size_t size,
+					dma_addr_t *dma_addr, gfp_t flag);
+
 static inline dma_addr_t
 dma_map_single(struct device *hwdev, void *ptr, size_t size,
 	       int direction)
@@ -247,7 +241,68 @@ static inline int dma_get_cache_alignment(void)
 	return boot_cpu_data.x86_clflush_size;
 }
 
-#define dma_is_consistent(d, h)	(1)
+static inline unsigned long dma_alloc_coherent_mask(struct device *dev,
+						    gfp_t gfp)
+{
+	unsigned long dma_mask = 0;
 
-#include <asm-generic/dma-coherent.h>
-#endif /* ASM_X86__DMA_MAPPING_H */
+	dma_mask = dev->coherent_dma_mask;
+	if (!dma_mask)
+		dma_mask = (gfp & GFP_DMA) ? DMA_24BIT_MASK : DMA_32BIT_MASK;
+
+	return dma_mask;
+}
+
+static inline gfp_t dma_alloc_coherent_gfp_flags(struct device *dev, gfp_t gfp)
+{
+#ifdef CONFIG_X86_64
+	unsigned long dma_mask = dma_alloc_coherent_mask(dev, gfp);
+
+	if (dma_mask <= DMA_32BIT_MASK && !(gfp & GFP_DMA))
+		gfp |= GFP_DMA32;
+#endif
+       return gfp;
+}
+
+static inline void *
+dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
+		gfp_t gfp)
+{
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
+	void *memory;
+
+	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
+
+	if (dma_alloc_from_coherent(dev, size, dma_handle, &memory))
+		return memory;
+
+	if (!dev) {
+		dev = &x86_dma_fallback_dev;
+		gfp |= GFP_DMA;
+	}
+
+	if (!is_device_dma_capable(dev))
+		return NULL;
+
+	if (!ops->alloc_coherent)
+		return NULL;
+
+	return ops->alloc_coherent(dev, size, dma_handle,
+				   dma_alloc_coherent_gfp_flags(dev, gfp));
+}
+
+static inline void dma_free_coherent(struct device *dev, size_t size,
+				     void *vaddr, dma_addr_t bus)
+{
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
+
+	WARN_ON(irqs_disabled());       /* for portability */
+
+	if (dma_release_from_coherent(dev, get_order(size), vaddr))
+		return;
+
+	if (ops->free_coherent)
+		ops->free_coherent(dev, size, vaddr, bus);
+}
+
+#endif
diff --git a/include/asm-x86/gart.h b/include/asm-x86/gart.h
index baa54fa..605edb3 100644
--- a/include/asm-x86/gart.h
+++ b/include/asm-x86/gart.h
@@ -29,6 +29,8 @@ extern int fix_aperture;
 #define AMD64_GARTCACHECTL	0x9c
 #define AMD64_GARTEN		(1<<0)
 
+extern int agp_amd64_init(void);
+
 static inline void enable_gart_translation(struct pci_dev *dev, u64 addr)
 {
 	u32 tmp, ctl;
diff --git a/include/asm-x86/iommu.h b/include/asm-x86/iommu.h
index e86f441..546ad31 100644
--- a/include/asm-x86/iommu.h
+++ b/include/asm-x86/iommu.h
@@ -6,6 +6,7 @@ extern void no_iommu_init(void);
 extern struct dma_mapping_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
+extern int dmar_disabled;
 
 extern unsigned long iommu_num_pages(unsigned long addr, unsigned long len);
 
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 952e0f8..ba9114e 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -48,6 +48,11 @@ static inline int is_device_dma_capable(struct device *dev)
 	return dev->dma_mask != NULL && *dev->dma_mask != DMA_MASK_NONE;
 }
 
+static inline int is_buffer_dma_capable(u64 mask, dma_addr_t addr, size_t size)
+{
+	return addr + size <= mask;
+}
+
 #ifdef CONFIG_HAS_DMA
 #include <asm/dma-mapping.h>
 #else
@@ -58,6 +63,13 @@ static inline int is_device_dma_capable(struct device *dev)
 #define dma_sync_single		dma_sync_single_for_cpu
 #define dma_sync_sg		dma_sync_sg_for_cpu
 
+static inline u64 dma_get_mask(struct device *dev)
+{
+	if (dev && dev->dma_mask && *dev->dma_mask)
+		return *dev->dma_mask;
+	return DMA_32BIT_MASK;
+}
+
 extern u64 dma_get_required_mask(struct device *dev);
 
 static inline unsigned int dma_get_max_seg_size(struct device *dev)
diff --git a/include/linux/iommu-helper.h b/include/linux/iommu-helper.h
index c975caf..a6d0586 100644
--- a/include/linux/iommu-helper.h
+++ b/include/linux/iommu-helper.h
@@ -1,6 +1,20 @@
+#ifndef _LINUX_IOMMU_HELPER_H
+#define _LINUX_IOMMU_HELPER_H
+
+static inline unsigned long iommu_device_max_index(unsigned long size,
+						   unsigned long offset,
+						   u64 dma_mask)
+{
+	if (size + offset > dma_mask)
+		return dma_mask - offset + 1;
+	else
+		return size;
+}
+
 extern int iommu_is_span_boundary(unsigned int index, unsigned int nr,
 				  unsigned long shift,
 				  unsigned long boundary_size);
+extern void iommu_area_reserve(unsigned long *map, unsigned long i, int len);
 extern unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
 				      unsigned long start, unsigned int nr,
 				      unsigned long shift,
@@ -8,3 +22,5 @@ extern unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
 				      unsigned long align_mask);
 extern void iommu_area_free(unsigned long *map, unsigned long start,
 			    unsigned int nr);
+
+#endif
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index f1624b3..c114103 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -497,6 +497,16 @@
 #define PCI_DEVICE_ID_AMD_K8_NB_ADDRMAP	0x1101
 #define PCI_DEVICE_ID_AMD_K8_NB_MEMCTL	0x1102
 #define PCI_DEVICE_ID_AMD_K8_NB_MISC	0x1103
+#define PCI_DEVICE_ID_AMD_10H_NB_HT	0x1200
+#define PCI_DEVICE_ID_AMD_10H_NB_MAP	0x1201
+#define PCI_DEVICE_ID_AMD_10H_NB_DRAM	0x1202
+#define PCI_DEVICE_ID_AMD_10H_NB_MISC	0x1203
+#define PCI_DEVICE_ID_AMD_10H_NB_LINK	0x1204
+#define PCI_DEVICE_ID_AMD_11H_NB_HT	0x1300
+#define PCI_DEVICE_ID_AMD_11H_NB_MAP	0x1301
+#define PCI_DEVICE_ID_AMD_11H_NB_DRAM	0x1302
+#define PCI_DEVICE_ID_AMD_11H_NB_MISC	0x1303
+#define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
 #define PCI_DEVICE_ID_AMD_SCSI		0x2020
diff --git a/kernel/dma-coherent.c b/kernel/dma-coherent.c
index c1d4d5b..f013a0c 100644
--- a/kernel/dma-coherent.c
+++ b/kernel/dma-coherent.c
@@ -124,6 +124,7 @@ int dma_alloc_from_coherent(struct device *dev, ssize_t size,
 	}
 	return (mem != NULL);
 }
+EXPORT_SYMBOL(dma_alloc_from_coherent);
 
 /**
  * dma_release_from_coherent() - try to free the memory allocated from per-device coherent memory pool
@@ -151,3 +152,4 @@ int dma_release_from_coherent(struct device *dev, int order, void *vaddr)
 	}
 	return 0;
 }
+EXPORT_SYMBOL(dma_release_from_coherent);
diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
index a3b8d4c..5d90074 100644
--- a/lib/iommu-helper.c
+++ b/lib/iommu-helper.c
@@ -30,8 +30,7 @@ again:
 	return index;
 }
 
-static inline void set_bit_area(unsigned long *map, unsigned long i,
-				int len)
+void iommu_area_reserve(unsigned long *map, unsigned long i, int len)
 {
 	unsigned long end = i + len;
 	while (i < end) {
@@ -64,7 +63,7 @@ again:
 			start = index + 1;
 			goto again;
 		}
-		set_bit_area(map, index, nr);
+		iommu_area_reserve(map, index, nr);
 	}
 	return index;
 }
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 8826fdf..f8eebd4 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -274,13 +274,14 @@ cleanup1:
 }
 
 static int
-address_needs_mapping(struct device *hwdev, dma_addr_t addr)
+address_needs_mapping(struct device *hwdev, dma_addr_t addr, size_t size)
 {
-	dma_addr_t mask = 0xffffffff;
-	/* If the device has a mask, use it, otherwise default to 32 bits */
-	if (hwdev && hwdev->dma_mask)
-		mask = *hwdev->dma_mask;
-	return (addr & ~mask) != 0;
+	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
+}
+
+static int is_swiotlb_buffer(char *addr)
+{
+	return addr >= io_tlb_start && addr < io_tlb_end;
 }
 
 /*
@@ -467,15 +468,8 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	void *ret;
 	int order = get_order(size);
 
-	/*
-	 * XXX fix me: the DMA API should pass us an explicit DMA mask
-	 * instead, or use ZONE_DMA32 (ia64 overloads ZONE_DMA to be a ~32
-	 * bit range instead of a 16MB one).
-	 */
-	flags |= GFP_DMA;
-
 	ret = (void *)__get_free_pages(flags, order);
-	if (ret && address_needs_mapping(hwdev, virt_to_bus(ret))) {
+	if (ret && address_needs_mapping(hwdev, virt_to_bus(ret), size)) {
 		/*
 		 * The allocated memory isn't reachable by the device.
 		 * Fall back on swiotlb_map_single().
@@ -490,19 +484,16 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		 * swiotlb_map_single(), which will grab memory from
 		 * the lowest available address range.
 		 */
-		dma_addr_t handle;
-		handle = swiotlb_map_single(hwdev, NULL, size, DMA_FROM_DEVICE);
-		if (swiotlb_dma_mapping_error(hwdev, handle))
+		ret = map_single(hwdev, NULL, size, DMA_FROM_DEVICE);
+		if (!ret)
 			return NULL;
-
-		ret = bus_to_virt(handle);
 	}
 
 	memset(ret, 0, size);
 	dev_addr = virt_to_bus(ret);
 
 	/* Confirm address can be DMA'd by device */
-	if (address_needs_mapping(hwdev, dev_addr)) {
+	if (address_needs_mapping(hwdev, dev_addr, size)) {
 		printk("hwdev DMA mask = 0x%016Lx, dev_addr = 0x%016Lx\n",
 		       (unsigned long long)*hwdev->dma_mask,
 		       (unsigned long long)dev_addr);
@@ -518,12 +509,11 @@ swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 		      dma_addr_t dma_handle)
 {
 	WARN_ON(irqs_disabled());
-	if (!(vaddr >= (void *)io_tlb_start
-                    && vaddr < (void *)io_tlb_end))
+	if (!is_swiotlb_buffer(vaddr))
 		free_pages((unsigned long) vaddr, get_order(size));
 	else
 		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
-		swiotlb_unmap_single (hwdev, dma_handle, size, DMA_TO_DEVICE);
+		unmap_single(hwdev, vaddr, size, DMA_TO_DEVICE);
 }
 
 static void
@@ -567,7 +557,7 @@ swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
 	 * we can safely return the device addr and not worry about bounce
 	 * buffering it.
 	 */
-	if (!address_needs_mapping(hwdev, dev_addr) && !swiotlb_force)
+	if (!address_needs_mapping(hwdev, dev_addr, size) && !swiotlb_force)
 		return dev_addr;
 
 	/*
@@ -584,7 +574,7 @@ swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
 	/*
 	 * Ensure that the address returned is DMA'ble
 	 */
-	if (address_needs_mapping(hwdev, dev_addr))
+	if (address_needs_mapping(hwdev, dev_addr, size))
 		panic("map_single: bounce buffer is not DMA'ble");
 
 	return dev_addr;
@@ -612,7 +602,7 @@ swiotlb_unmap_single_attrs(struct device *hwdev, dma_addr_t dev_addr,
 	char *dma_addr = bus_to_virt(dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
-	if (dma_addr >= io_tlb_start && dma_addr < io_tlb_end)
+	if (is_swiotlb_buffer(dma_addr))
 		unmap_single(hwdev, dma_addr, size, dir);
 	else if (dir == DMA_FROM_DEVICE)
 		dma_mark_clean(dma_addr, size);
@@ -642,7 +632,7 @@ swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 	char *dma_addr = bus_to_virt(dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
-	if (dma_addr >= io_tlb_start && dma_addr < io_tlb_end)
+	if (is_swiotlb_buffer(dma_addr))
 		sync_single(hwdev, dma_addr, size, dir, target);
 	else if (dir == DMA_FROM_DEVICE)
 		dma_mark_clean(dma_addr, size);
@@ -673,7 +663,7 @@ swiotlb_sync_single_range(struct device *hwdev, dma_addr_t dev_addr,
 	char *dma_addr = bus_to_virt(dev_addr) + offset;
 
 	BUG_ON(dir == DMA_NONE);
-	if (dma_addr >= io_tlb_start && dma_addr < io_tlb_end)
+	if (is_swiotlb_buffer(dma_addr))
 		sync_single(hwdev, dma_addr, size, dir, target);
 	else if (dir == DMA_FROM_DEVICE)
 		dma_mark_clean(dma_addr, size);
@@ -727,7 +717,8 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 	for_each_sg(sgl, sg, nelems, i) {
 		addr = SG_ENT_VIRT_ADDRESS(sg);
 		dev_addr = virt_to_bus(addr);
-		if (swiotlb_force || address_needs_mapping(hwdev, dev_addr)) {
+		if (swiotlb_force ||
+		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
 			void *map = map_single(hwdev, addr, sg->length, dir);
 			if (!map) {
 				/* Don't panic here, we expect map_sg users
