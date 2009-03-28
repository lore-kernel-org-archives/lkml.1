Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbZC1WX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbZC1WX2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 18:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754844AbZC1WXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 18:23:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52553 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338AbZC1WXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 18:23:09 -0400
Date: Sat, 28 Mar 2009 23:22:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Joerg Roedel <joerg.roedel@amd.com>,
       David Woodhouse <dwmw2@infradead.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [GIT PULL] IOMMU updates for v2.6.30
Message-ID: <20090328222227.GA25458@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest iommu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git iommu-for-linus

Highlights:

 - dma_mapping_ops cleanups and cross-arch unification

 - CONFIG_DMA_API_DEBUG debugging helper (default disabled), to
   debug various buggy uses of DMA APIs, even on systems without
   a hardware IOMMU.

Known risks:

 - CONFIG_DMA_API_DEBUG=y might emit warnings about DMA API 
   bugs/problems it finds. Common ones were fixed (they were almost 
   always driver bugs), but exposure to rare and old hardware was 
   relatively low. There is at most a single warning per bootup. 
   Fedora rawhide has been carrying (and enabling) this debug 
   facility for some time.

 - No known regressions.

 Thanks,

	Ingo

------------------>
David Woodhouse (2):
      dma-debug: add function to dump dma mappings
      dma-debug: print stacktrace of mapping path on unmap error

FUJITA Tomonori (31):
      add map/unmap_single_attr and map/unmap_sg_attr to struct dma_mapping_ops
      add dma_mapping_ops for SBA IOMMU
      add dma_mapping_ops for SWIOTLB and SBA IOMMU
      add dma_mapping_ops for intel-iommu
      add dma_mapping_ops for SGI Altix
      add dma_mapping_ops for SWIOTLB
      set up dma_ops appropriately
      convert the DMA API to use dma_ops
      remove dma operations in struct ia64_machine_vector
      make sn DMA mapping functions static
      add dma_get_ops to struct ia64_machine_vector
      remove hwsw_dma_ops
      make sba DMA mapping functions static
      x86: add map_page and unmap_page to struct dma_mapping_ops
      x86, swiotlb: add map_page and unmap_page
      x86, gart: add map_page and unmap_page
      x86, calgary: add map_page and unmap_page
      x86, AMD IOMMU: add map_page and unmap_page
      intel-iommu: add map_page and unmap_page
      x86, pci-nommu: add map_page
      x86: remove map_single and unmap_single in struct dma_mapping_ops
      generic: add common struct for dma map operations
      x86, ia64: convert to use generic dma_map_ops struct
      x86, ia64: remove duplicated swiotlb code
      convert to use generic dma_map_ops struct, cleanup
      IA64: fix compile error on IA64_DIG_VTD
      IA64: fix swiotlb alloc_coherent for non DMA_64BIT_MASK devices
      IA64: fix VT-d dma_mapping_error
      intel-iommu: make dma mapping functions static
      AMD IOMMU: remove unnecessary ifdef
      dma-debug: warn of unmapping an invalid dma address

Hannes Eder (1):
      IOMMU-API: use ANSI style function declaration for 'iommu_found'

Ian Campbell (3):
      swiotlb: range_needs_mapping should take a physical address.
      swiotlb: do not use sg_virt()
      x86: rename arch/x86/kernel/pci-swiotlb_64.c => pci-swiotlb.c

Ingo Molnar (1):
      dma-debug: fix dma_debug_add_bus() definition for !CONFIG_DMA_API_DEBUG

Joerg Roedel (20):
      dma-debug: add Kconfig entry
      dma-debug: add header file and core data structures
      dma-debug: add hash functions for dma_debug_entries
      dma-debug: add allocator code
      dma-debug: add initialization code
      dma-debug: add kernel command line parameters
      dma-debug: add debugfs interface
      dma-debug: add core checking functions
      dma-debug: add checking for map/unmap_page/single
      dma-debug: add add checking for map/unmap_sg
      dma-debug: add checking for [alloc|free]_coherent
      dma-debug: add checks for sync_single_*
      dma-debug: add checks for sync_single_range_*
      dma-debug: add checks for sync_single_sg_*
      dma-debug: x86 architecture bindings
      dma-debug: Documentation update
      dma-debug: add checks for kernel text and rodata
      dma-debug: add a check dma memory leaks
      dma-debug/x86: register pci bus for dma-debug leak detection
      dma-debug: make memory range checks more consistent

Tony Luck (1):
      ia64: fix section mismatch swiotlb_dma_init -> swiotlb_init

Yasunori Goto (1):
      IA64: fix swiotlb alloc_coherent for non DMA_64BIT_MASK devices, fix


 Documentation/DMA-API.txt                          |  106 +++
 Documentation/kernel-parameters.txt                |   10 +
 arch/Kconfig                                       |    2 +
 arch/ia64/dig/Makefile                             |    4 +-
 arch/ia64/dig/dig_vtd_iommu.c                      |   59 --
 arch/ia64/hp/common/hwsw_iommu.c                   |  165 +---
 arch/ia64/hp/common/sba_iommu.c                    |   79 ++-
 arch/ia64/include/asm/dma-mapping.h                |  194 +++--
 arch/ia64/include/asm/machvec.h                    |  102 +--
 arch/ia64/include/asm/machvec_dig_vtd.h            |   20 -
 arch/ia64/include/asm/machvec_hpzx1.h              |   23 +-
 arch/ia64/include/asm/machvec_hpzx1_swiotlb.h      |   27 +-
 arch/ia64/include/asm/machvec_sn2.h                |   27 +-
 arch/ia64/kernel/Makefile                          |    4 +-
 arch/ia64/kernel/dma-mapping.c                     |   13 +
 arch/ia64/kernel/machvec.c                         |    8 +-
 arch/ia64/kernel/pci-dma.c                         |   46 +-
 arch/ia64/kernel/pci-swiotlb.c                     |   30 +-
 arch/ia64/sn/pci/pci_dma.c                         |   99 ++-
 arch/x86/Kconfig                                   |    1 +
 arch/x86/include/asm/device.h                      |    2 +-
 arch/x86/include/asm/dma-mapping.h                 |  188 ++--
 arch/x86/include/asm/iommu.h                       |    2 +-
 arch/x86/kernel/Makefile                           |    2 +-
 arch/x86/kernel/amd_iommu.c                        |   26 +-
 arch/x86/kernel/pci-calgary_64.c                   |   38 +-
 arch/x86/kernel/pci-dma.c                          |   14 +-
 arch/x86/kernel/pci-gart_64.c                      |   34 +-
 arch/x86/kernel/pci-nommu.c                        |   21 +-
 .../x86/kernel/{pci-swiotlb_64.c => pci-swiotlb.c} |   19 +-
 drivers/base/iommu.c                               |    2 +-
 drivers/pci/intel-iommu.c                          |   50 +-
 include/linux/dma-debug.h                          |  174 ++++
 include/linux/dma-mapping.h                        |   48 +
 include/linux/intel-iommu.h                        |    7 -
 include/linux/swiotlb.h                            |   41 +-
 lib/Kconfig.debug                                  |   11 +
 lib/Makefile                                       |    2 +
 lib/dma-debug.c                                    |  955 ++++++++++++++++++++
 lib/swiotlb.c                                      |   88 +-
 40 files changed, 1899 insertions(+), 844 deletions(-)
 delete mode 100644 arch/ia64/dig/dig_vtd_iommu.c
 create mode 100644 arch/ia64/kernel/dma-mapping.c
 rename arch/x86/kernel/{pci-swiotlb_64.c => pci-swiotlb.c} (81%)
 create mode 100644 include/linux/dma-debug.h
 create mode 100644 lib/dma-debug.c

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index 2a3fcc5..d9aa43d 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -609,3 +609,109 @@ size is the size (and should be a page-sized multiple).
 The return value will be either a pointer to the processor virtual
 address of the memory, or an error (via PTR_ERR()) if any part of the
 region is occupied.
+
+Part III - Debug drivers use of the DMA-API
+-------------------------------------------
+
+The DMA-API as described above as some constraints. DMA addresses must be
+released with the corresponding function with the same size for example. With
+the advent of hardware IOMMUs it becomes more and more important that drivers
+do not violate those constraints. In the worst case such a violation can
+result in data corruption up to destroyed filesystems.
+
+To debug drivers and find bugs in the usage of the DMA-API checking code can
+be compiled into the kernel which will tell the developer about those
+violations. If your architecture supports it you can select the "Enable
+debugging of DMA-API usage" option in your kernel configuration. Enabling this
+option has a performance impact. Do not enable it in production kernels.
+
+If you boot the resulting kernel will contain code which does some bookkeeping
+about what DMA memory was allocated for which device. If this code detects an
+error it prints a warning message with some details into your kernel log. An
+example warning message may look like this:
+
+------------[ cut here ]------------
+WARNING: at /data2/repos/linux-2.6-iommu/lib/dma-debug.c:448
+	check_unmap+0x203/0x490()
+Hardware name:
+forcedeth 0000:00:08.0: DMA-API: device driver frees DMA memory with wrong
+	function [device address=0x00000000640444be] [size=66 bytes] [mapped as
+single] [unmapped as page]
+Modules linked in: nfsd exportfs bridge stp llc r8169
+Pid: 0, comm: swapper Tainted: G        W  2.6.28-dmatest-09289-g8bb99c0 #1
+Call Trace:
+ <IRQ>  [<ffffffff80240b22>] warn_slowpath+0xf2/0x130
+ [<ffffffff80647b70>] _spin_unlock+0x10/0x30
+ [<ffffffff80537e75>] usb_hcd_link_urb_to_ep+0x75/0xc0
+ [<ffffffff80647c22>] _spin_unlock_irqrestore+0x12/0x40
+ [<ffffffff8055347f>] ohci_urb_enqueue+0x19f/0x7c0
+ [<ffffffff80252f96>] queue_work+0x56/0x60
+ [<ffffffff80237e10>] enqueue_task_fair+0x20/0x50
+ [<ffffffff80539279>] usb_hcd_submit_urb+0x379/0xbc0
+ [<ffffffff803b78c3>] cpumask_next_and+0x23/0x40
+ [<ffffffff80235177>] find_busiest_group+0x207/0x8a0
+ [<ffffffff8064784f>] _spin_lock_irqsave+0x1f/0x50
+ [<ffffffff803c7ea3>] check_unmap+0x203/0x490
+ [<ffffffff803c8259>] debug_dma_unmap_page+0x49/0x50
+ [<ffffffff80485f26>] nv_tx_done_optimized+0xc6/0x2c0
+ [<ffffffff80486c13>] nv_nic_irq_optimized+0x73/0x2b0
+ [<ffffffff8026df84>] handle_IRQ_event+0x34/0x70
+ [<ffffffff8026ffe9>] handle_edge_irq+0xc9/0x150
+ [<ffffffff8020e3ab>] do_IRQ+0xcb/0x1c0
+ [<ffffffff8020c093>] ret_from_intr+0x0/0xa
+ <EOI> <4>---[ end trace f6435a98e2a38c0e ]---
+
+The driver developer can find the driver and the device including a stacktrace
+of the DMA-API call which caused this warning.
+
+Per default only the first error will result in a warning message. All other
+errors will only silently counted. This limitation exist to prevent the code
+from flooding your kernel log. To support debugging a device driver this can
+be disabled via debugfs. See the debugfs interface documentation below for
+details.
+
+The debugfs directory for the DMA-API debugging code is called dma-api/. In
+this directory the following files can currently be found:
+
+	dma-api/all_errors	This file contains a numeric value. If this
+				value is not equal to zero the debugging code
+				will print a warning for every error it finds
+				into the kernel log. Be carefull with this
+				option. It can easily flood your logs.
+
+	dma-api/disabled	This read-only file contains the character 'Y'
+				if the debugging code is disabled. This can
+				happen when it runs out of memory or if it was
+				disabled at boot time
+
+	dma-api/error_count	This file is read-only and shows the total
+				numbers of errors found.
+
+	dma-api/num_errors	The number in this file shows how many
+				warnings will be printed to the kernel log
+				before it stops. This number is initialized to
+				one at system boot and be set by writing into
+				this file
+
+	dma-api/min_free_entries
+				This read-only file can be read to get the
+				minimum number of free dma_debug_entries the
+				allocator has ever seen. If this value goes
+				down to zero the code will disable itself
+				because it is not longer reliable.
+
+	dma-api/num_free_entries
+				The current number of free dma_debug_entries
+				in the allocator.
+
+If you have this code compiled into your kernel it will be enabled by default.
+If you want to boot without the bookkeeping anyway you can provide
+'dma_debug=off' as a boot parameter. This will disable DMA-API debugging.
+Notice that you can not enable it again at runtime. You have to reboot to do
+so.
+
+When the code disables itself at runtime this is most likely because it ran
+out of dma_debug_entries. These entries are preallocated at boot. The number
+of preallocated entries is defined per architecture. If it is too low for you
+boot with 'dma_debug_entries=<your_desired_number>' to overwrite the
+architectural default.
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6b979d1..0122e5f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -492,6 +492,16 @@ and is between 256 and 4096 characters. It is defined in the file
 			Range: 0 - 8192
 			Default: 64
 
+	dma_debug=off	If the kernel is compiled with DMA_API_DEBUG support
+			this option disables the debugging code at boot.
+
+	dma_debug_entries=<number>
+			This option allows to tune the number of preallocated
+			entries for DMA-API debugging code. One entry is
+			required per DMA-API allocation. Use this if the
+			DMA-API debugging code disables itself because the
+			architectural default is too low.
+
 	hpet=		[X86-32,HPET] option to control HPET usage
 			Format: { enable (default) | disable | force |
 				verbose }
diff --git a/arch/Kconfig b/arch/Kconfig
index 550dab2..830c16a 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -106,3 +106,5 @@ config HAVE_CLK
 	  The <linux/clk.h> calls support software clock gating and
 	  thus are a key power management tool on many systems.
 
+config HAVE_DMA_API_DEBUG
+	bool
diff --git a/arch/ia64/dig/Makefile b/arch/ia64/dig/Makefile
index 5c02838..2f7cadd 100644
--- a/arch/ia64/dig/Makefile
+++ b/arch/ia64/dig/Makefile
@@ -7,8 +7,8 @@
 
 obj-y := setup.o
 ifeq ($(CONFIG_DMAR), y)
-obj-$(CONFIG_IA64_GENERIC) += machvec.o machvec_vtd.o dig_vtd_iommu.o
+obj-$(CONFIG_IA64_GENERIC) += machvec.o machvec_vtd.o
 else
 obj-$(CONFIG_IA64_GENERIC) += machvec.o
 endif
-obj-$(CONFIG_IA64_DIG_VTD) += dig_vtd_iommu.o
+
diff --git a/arch/ia64/dig/dig_vtd_iommu.c b/arch/ia64/dig/dig_vtd_iommu.c
deleted file mode 100644
index 1c8a079..0000000
--- a/arch/ia64/dig/dig_vtd_iommu.c
+++ /dev/null
@@ -1,59 +0,0 @@
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/intel-iommu.h>
-
-void *
-vtd_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
-		 gfp_t flags)
-{
-	return intel_alloc_coherent(dev, size, dma_handle, flags);
-}
-EXPORT_SYMBOL_GPL(vtd_alloc_coherent);
-
-void
-vtd_free_coherent(struct device *dev, size_t size, void *vaddr,
-		 dma_addr_t dma_handle)
-{
-	intel_free_coherent(dev, size, vaddr, dma_handle);
-}
-EXPORT_SYMBOL_GPL(vtd_free_coherent);
-
-dma_addr_t
-vtd_map_single_attrs(struct device *dev, void *addr, size_t size,
-		     int dir, struct dma_attrs *attrs)
-{
-	return intel_map_single(dev, (phys_addr_t)addr, size, dir);
-}
-EXPORT_SYMBOL_GPL(vtd_map_single_attrs);
-
-void
-vtd_unmap_single_attrs(struct device *dev, dma_addr_t iova, size_t size,
-		       int dir, struct dma_attrs *attrs)
-{
-	intel_unmap_single(dev, iova, size, dir);
-}
-EXPORT_SYMBOL_GPL(vtd_unmap_single_attrs);
-
-int
-vtd_map_sg_attrs(struct device *dev, struct scatterlist *sglist, int nents,
-		 int dir, struct dma_attrs *attrs)
-{
-	return intel_map_sg(dev, sglist, nents, dir);
-}
-EXPORT_SYMBOL_GPL(vtd_map_sg_attrs);
-
-void
-vtd_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist,
-		   int nents, int dir, struct dma_attrs *attrs)
-{
-	intel_unmap_sg(dev, sglist, nents, dir);
-}
-EXPORT_SYMBOL_GPL(vtd_unmap_sg_attrs);
-
-int
-vtd_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	return 0;
-}
-EXPORT_SYMBOL_GPL(vtd_dma_mapping_error);
diff --git a/arch/ia64/hp/common/hwsw_iommu.c b/arch/ia64/hp/common/hwsw_iommu.c
index 2769dbf..e4a80d8 100644
--- a/arch/ia64/hp/common/hwsw_iommu.c
+++ b/arch/ia64/hp/common/hwsw_iommu.c
@@ -13,49 +13,34 @@
  */
 
 #include <linux/device.h>
+#include <linux/dma-mapping.h>
 #include <linux/swiotlb.h>
-
 #include <asm/machvec.h>
 
+extern struct dma_map_ops sba_dma_ops, swiotlb_dma_ops;
+
 /* swiotlb declarations & definitions: */
 extern int swiotlb_late_init_with_default_size (size_t size);
 
-/* hwiommu declarations & definitions: */
-
-extern ia64_mv_dma_alloc_coherent	sba_alloc_coherent;
-extern ia64_mv_dma_free_coherent	sba_free_coherent;
-extern ia64_mv_dma_map_single_attrs	sba_map_single_attrs;
-extern ia64_mv_dma_unmap_single_attrs	sba_unmap_single_attrs;
-extern ia64_mv_dma_map_sg_attrs		sba_map_sg_attrs;
-extern ia64_mv_dma_unmap_sg_attrs	sba_unmap_sg_attrs;
-extern ia64_mv_dma_supported		sba_dma_supported;
-extern ia64_mv_dma_mapping_error	sba_dma_mapping_error;
-
-#define hwiommu_alloc_coherent		sba_alloc_coherent
-#define hwiommu_free_coherent		sba_free_coherent
-#define hwiommu_map_single_attrs	sba_map_single_attrs
-#define hwiommu_unmap_single_attrs	sba_unmap_single_attrs
-#define hwiommu_map_sg_attrs		sba_map_sg_attrs
-#define hwiommu_unmap_sg_attrs		sba_unmap_sg_attrs
-#define hwiommu_dma_supported		sba_dma_supported
-#define hwiommu_dma_mapping_error	sba_dma_mapping_error
-#define hwiommu_sync_single_for_cpu	machvec_dma_sync_single
-#define hwiommu_sync_sg_for_cpu		machvec_dma_sync_sg
-#define hwiommu_sync_single_for_device	machvec_dma_sync_single
-#define hwiommu_sync_sg_for_device	machvec_dma_sync_sg
-
-
 /*
  * Note: we need to make the determination of whether or not to use
  * the sw I/O TLB based purely on the device structure.  Anything else
  * would be unreliable or would be too intrusive.
  */
-static inline int
-use_swiotlb (struct device *dev)
+static inline int use_swiotlb(struct device *dev)
 {
-	return dev && dev->dma_mask && !hwiommu_dma_supported(dev, *dev->dma_mask);
+	return dev && dev->dma_mask &&
+		!sba_dma_ops.dma_supported(dev, *dev->dma_mask);
 }
 
+struct dma_map_ops *hwsw_dma_get_ops(struct device *dev)
+{
+	if (use_swiotlb(dev))
+		return &swiotlb_dma_ops;
+	return &sba_dma_ops;
+}
+EXPORT_SYMBOL(hwsw_dma_get_ops);
+
 void __init
 hwsw_init (void)
 {
@@ -71,125 +56,3 @@ hwsw_init (void)
 #endif
 	}
 }
-
-void *
-hwsw_alloc_coherent (struct device *dev, size_t size, dma_addr_t *dma_handle, gfp_t flags)
-{
-	if (use_swiotlb(dev))
-		return swiotlb_alloc_coherent(dev, size, dma_handle, flags);
-	else
-		return hwiommu_alloc_coherent(dev, size, dma_handle, flags);
-}
-
-void
-hwsw_free_coherent (struct device *dev, size_t size, void *vaddr, dma_addr_t dma_handle)
-{
-	if (use_swiotlb(dev))
-		swiotlb_free_coherent(dev, size, vaddr, dma_handle);
-	else
-		hwiommu_free_coherent(dev, size, vaddr, dma_handle);
-}
-
-dma_addr_t
-hwsw_map_single_attrs(struct device *dev, void *addr, size_t size, int dir,
-		       struct dma_attrs *attrs)
-{
-	if (use_swiotlb(dev))
-		return swiotlb_map_single_attrs(dev, addr, size, dir, attrs);
-	else
-		return hwiommu_map_single_attrs(dev, addr, size, dir, attrs);
-}
-EXPORT_SYMBOL(hwsw_map_single_attrs);
-
-void
-hwsw_unmap_single_attrs(struct device *dev, dma_addr_t iova, size_t size,
-			 int dir, struct dma_attrs *attrs)
-{
-	if (use_swiotlb(dev))
-		return swiotlb_unmap_single_attrs(dev, iova, size, dir, attrs);
-	else
-		return hwiommu_unmap_single_attrs(dev, iova, size, dir, attrs);
-}
-EXPORT_SYMBOL(hwsw_unmap_single_attrs);
-
-int
-hwsw_map_sg_attrs(struct device *dev, struct scatterlist *sglist, int nents,
-		   int dir, struct dma_attrs *attrs)
-{
-	if (use_swiotlb(dev))
-		return swiotlb_map_sg_attrs(dev, sglist, nents, dir, attrs);
-	else
-		return hwiommu_map_sg_attrs(dev, sglist, nents, dir, attrs);
-}
-EXPORT_SYMBOL(hwsw_map_sg_attrs);
-
-void
-hwsw_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist, int nents,
-		     int dir, struct dma_attrs *attrs)
-{
-	if (use_swiotlb(dev))
-		return swiotlb_unmap_sg_attrs(dev, sglist, nents, dir, attrs);
-	else
-		return hwiommu_unmap_sg_attrs(dev, sglist, nents, dir, attrs);
-}
-EXPORT_SYMBOL(hwsw_unmap_sg_attrs);
-
-void
-hwsw_sync_single_for_cpu (struct device *dev, dma_addr_t addr, size_t size, int dir)
-{
-	if (use_swiotlb(dev))
-		swiotlb_sync_single_for_cpu(dev, addr, size, dir);
-	else
-		hwiommu_sync_single_for_cpu(dev, addr, size, dir);
-}
-
-void
-hwsw_sync_sg_for_cpu (struct device *dev, struct scatterlist *sg, int nelems, int dir)
-{
-	if (use_swiotlb(dev))
-		swiotlb_sync_sg_for_cpu(dev, sg, nelems, dir);
-	else
-		hwiommu_sync_sg_for_cpu(dev, sg, nelems, dir);
-}
-
-void
-hwsw_sync_single_for_device (struct device *dev, dma_addr_t addr, size_t size, int dir)
-{
-	if (use_swiotlb(dev))
-		swiotlb_sync_single_for_device(dev, addr, size, dir);
-	else
-		hwiommu_sync_single_for_device(dev, addr, size, dir);
-}
-
-void
-hwsw_sync_sg_for_device (struct device *dev, struct scatterlist *sg, int nelems, int dir)
-{
-	if (use_swiotlb(dev))
-		swiotlb_sync_sg_for_device(dev, sg, nelems, dir);
-	else
-		hwiommu_sync_sg_for_device(dev, sg, nelems, dir);
-}
-
-int
-hwsw_dma_supported (struct device *dev, u64 mask)
-{
-	if (hwiommu_dma_supported(dev, mask))
-		return 1;
-	return swiotlb_dma_supported(dev, mask);
-}
-
-int
-hwsw_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	return hwiommu_dma_mapping_error(dev, dma_addr) ||
-		swiotlb_dma_mapping_error(dev, dma_addr);
-}
-
-EXPORT_SYMBOL(hwsw_dma_mapping_error);
-EXPORT_SYMBOL(hwsw_dma_supported);
-EXPORT_SYMBOL(hwsw_alloc_coherent);
-EXPORT_SYMBOL(hwsw_free_coherent);
-EXPORT_SYMBOL(hwsw_sync_single_for_cpu);
-EXPORT_SYMBOL(hwsw_sync_single_for_device);
-EXPORT_SYMBOL(hwsw_sync_sg_for_cpu);
-EXPORT_SYMBOL(hwsw_sync_sg_for_device);
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 6d5e6c5..56ceb68 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -36,6 +36,7 @@
 #include <linux/bitops.h>         /* hweight64() */
 #include <linux/crash_dump.h>
 #include <linux/iommu-helper.h>
+#include <linux/dma-mapping.h>
 
 #include <asm/delay.h>		/* ia64_get_itc() */
 #include <asm/io.h>
@@ -908,11 +909,13 @@ sba_mark_invalid(struct ioc *ioc, dma_addr_t iova, size_t byte_cnt)
  *
  * See Documentation/PCI/PCI-DMA-mapping.txt
  */
-dma_addr_t
-sba_map_single_attrs(struct device *dev, void *addr, size_t size, int dir,
-		     struct dma_attrs *attrs)
+static dma_addr_t sba_map_page(struct device *dev, struct page *page,
+			       unsigned long poff, size_t size,
+			       enum dma_data_direction dir,
+			       struct dma_attrs *attrs)
 {
 	struct ioc *ioc;
+	void *addr = page_address(page) + poff;
 	dma_addr_t iovp;
 	dma_addr_t offset;
 	u64 *pdir_start;
@@ -990,7 +993,14 @@ sba_map_single_attrs(struct device *dev, void *addr, size_t size, int dir,
 #endif
 	return SBA_IOVA(ioc, iovp, offset);
 }
-EXPORT_SYMBOL(sba_map_single_attrs);
+
+static dma_addr_t sba_map_single_attrs(struct device *dev, void *addr,
+				       size_t size, enum dma_data_direction dir,
+				       struct dma_attrs *attrs)
+{
+	return sba_map_page(dev, virt_to_page(addr),
+			    (unsigned long)addr & ~PAGE_MASK, size, dir, attrs);
+}
 
 #ifdef ENABLE_MARK_CLEAN
 static SBA_INLINE void
@@ -1026,8 +1036,8 @@ sba_mark_clean(struct ioc *ioc, dma_addr_t iova, size_t size)
  *
  * See Documentation/PCI/PCI-DMA-mapping.txt
  */
-void sba_unmap_single_attrs(struct device *dev, dma_addr_t iova, size_t size,
-			    int dir, struct dma_attrs *attrs)
+static void sba_unmap_page(struct device *dev, dma_addr_t iova, size_t size,
+			   enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	struct ioc *ioc;
 #if DELAYED_RESOURCE_CNT > 0
@@ -1094,7 +1104,12 @@ void sba_unmap_single_attrs(struct device *dev, dma_addr_t iova, size_t size,
 	spin_unlock_irqrestore(&ioc->res_lock, flags);
 #endif /* DELAYED_RESOURCE_CNT == 0 */
 }
-EXPORT_SYMBOL(sba_unmap_single_attrs);
+
+void sba_unmap_single_attrs(struct device *dev, dma_addr_t iova, size_t size,
+			    enum dma_data_direction dir, struct dma_attrs *attrs)
+{
+	sba_unmap_page(dev, iova, size, dir, attrs);
+}
 
 /**
  * sba_alloc_coherent - allocate/map shared mem for DMA
@@ -1104,7 +1119,7 @@ EXPORT_SYMBOL(sba_unmap_single_attrs);
  *
  * See Documentation/PCI/PCI-DMA-mapping.txt
  */
-void *
+static void *
 sba_alloc_coherent (struct device *dev, size_t size, dma_addr_t *dma_handle, gfp_t flags)
 {
 	struct ioc *ioc;
@@ -1167,7 +1182,8 @@ sba_alloc_coherent (struct device *dev, size_t size, dma_addr_t *dma_handle, gfp
  *
  * See Documentation/PCI/PCI-DMA-mapping.txt
  */
-void sba_free_coherent (struct device *dev, size_t size, void *vaddr, dma_addr_t dma_handle)
+static void sba_free_coherent (struct device *dev, size_t size, void *vaddr,
+			       dma_addr_t dma_handle)
 {
 	sba_unmap_single_attrs(dev, dma_handle, size, 0, NULL);
 	free_pages((unsigned long) vaddr, get_order(size));
@@ -1422,8 +1438,9 @@ sba_coalesce_chunks(struct ioc *ioc, struct device *dev,
  *
  * See Documentation/PCI/PCI-DMA-mapping.txt
  */
-int sba_map_sg_attrs(struct device *dev, struct scatterlist *sglist, int nents,
-		     int dir, struct dma_attrs *attrs)
+static int sba_map_sg_attrs(struct device *dev, struct scatterlist *sglist,
+			    int nents, enum dma_data_direction dir,
+			    struct dma_attrs *attrs)
 {
 	struct ioc *ioc;
 	int coalesced, filled = 0;
@@ -1502,7 +1519,6 @@ int sba_map_sg_attrs(struct device *dev, struct scatterlist *sglist, int nents,
 
 	return filled;
 }
-EXPORT_SYMBOL(sba_map_sg_attrs);
 
 /**
  * sba_unmap_sg_attrs - unmap Scatter/Gather list
@@ -1514,8 +1530,9 @@ EXPORT_SYMBOL(sba_map_sg_attrs);
  *
  * See Documentation/PCI/PCI-DMA-mapping.txt
  */
-void sba_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist,
-			int nents, int dir, struct dma_attrs *attrs)
+static void sba_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist,
+			       int nents, enum dma_data_direction dir,
+			       struct dma_attrs *attrs)
 {
 #ifdef ASSERT_PDIR_SANITY
 	struct ioc *ioc;
@@ -1551,7 +1568,6 @@ void sba_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist,
 #endif
 
 }
-EXPORT_SYMBOL(sba_unmap_sg_attrs);
 
 /**************************************************************
 *
@@ -2064,6 +2080,8 @@ static struct acpi_driver acpi_sba_ioc_driver = {
 	},
 };
 
+extern struct dma_map_ops swiotlb_dma_ops;
+
 static int __init
 sba_init(void)
 {
@@ -2077,6 +2095,7 @@ sba_init(void)
 	 * a successful kdump kernel boot is to use the swiotlb.
 	 */
 	if (is_kdump_kernel()) {
+		dma_ops = &swiotlb_dma_ops;
 		if (swiotlb_late_init_with_default_size(64 * (1<<20)) != 0)
 			panic("Unable to initialize software I/O TLB:"
 				  " Try machvec=dig boot option");
@@ -2092,6 +2111,7 @@ sba_init(void)
 		 * If we didn't find something sba_iommu can claim, we
 		 * need to setup the swiotlb and switch to the dig machvec.
 		 */
+		dma_ops = &swiotlb_dma_ops;
 		if (swiotlb_late_init_with_default_size(64 * (1<<20)) != 0)
 			panic("Unable to find SBA IOMMU or initialize "
 			      "software I/O TLB: Try machvec=dig boot option");
@@ -2138,15 +2158,13 @@ nosbagart(char *str)
 	return 1;
 }
 
-int
-sba_dma_supported (struct device *dev, u64 mask)
+static int sba_dma_supported (struct device *dev, u64 mask)
 {
 	/* make sure it's at least 32bit capable */
 	return ((mask & 0xFFFFFFFFUL) == 0xFFFFFFFFUL);
 }
 
-int
-sba_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+static int sba_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return 0;
 }
@@ -2176,7 +2194,22 @@ sba_page_override(char *str)
 
 __setup("sbapagesize=",sba_page_override);
 
-EXPORT_SYMBOL(sba_dma_mapping_error);
-EXPORT_SYMBOL(sba_dma_supported);
-EXPORT_SYMBOL(sba_alloc_coherent);
-EXPORT_SYMBOL(sba_free_coherent);
+struct dma_map_ops sba_dma_ops = {
+	.alloc_coherent		= sba_alloc_coherent,
+	.free_coherent		= sba_free_coherent,
+	.map_page		= sba_map_page,
+	.unmap_page		= sba_unmap_page,
+	.map_sg			= sba_map_sg_attrs,
+	.unmap_sg		= sba_unmap_sg_attrs,
+	.sync_single_for_cpu	= machvec_dma_sync_single,
+	.sync_sg_for_cpu	= machvec_dma_sync_sg,
+	.sync_single_for_device	= machvec_dma_sync_single,
+	.sync_sg_for_device	= machvec_dma_sync_sg,
+	.dma_supported		= sba_dma_supported,
+	.mapping_error		= sba_dma_mapping_error,
+};
+
+void sba_dma_init(void)
+{
+	dma_ops = &sba_dma_ops;
+}
diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
index 1f912d9..36c0009 100644
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -11,99 +11,128 @@
 
 #define ARCH_HAS_DMA_GET_REQUIRED_MASK
 
-struct dma_mapping_ops {
-	int             (*mapping_error)(struct device *dev,
-					 dma_addr_t dma_addr);
-	void*           (*alloc_coherent)(struct device *dev, size_t size,
-				dma_addr_t *dma_handle, gfp_t gfp);
-	void            (*free_coherent)(struct device *dev, size_t size,
-				void *vaddr, dma_addr_t dma_handle);
-	dma_addr_t      (*map_single)(struct device *hwdev, unsigned long ptr,
-				size_t size, int direction);
-	void            (*unmap_single)(struct device *dev, dma_addr_t addr,
-				size_t size, int direction);
-	void            (*sync_single_for_cpu)(struct device *hwdev,
-				dma_addr_t dma_handle, size_t size,
-				int direction);
-	void            (*sync_single_for_device)(struct device *hwdev,
-				dma_addr_t dma_handle, size_t size,
-				int direction);
-	void            (*sync_single_range_for_cpu)(struct device *hwdev,
-				dma_addr_t dma_handle, unsigned long offset,
-				size_t size, int direction);
-	void            (*sync_single_range_for_device)(struct device *hwdev,
-				dma_addr_t dma_handle, unsigned long offset,
-				size_t size, int direction);
-	void            (*sync_sg_for_cpu)(struct device *hwdev,
-				struct scatterlist *sg, int nelems,
-				int direction);
-	void            (*sync_sg_for_device)(struct device *hwdev,
-				struct scatterlist *sg, int nelems,
-				int direction);
-	int             (*map_sg)(struct device *hwdev, struct scatterlist *sg,
-				int nents, int direction);
-	void            (*unmap_sg)(struct device *hwdev,
-				struct scatterlist *sg, int nents,
-				int direction);
-	int             (*dma_supported_op)(struct device *hwdev, u64 mask);
-	int		is_phys;
-};
-
-extern struct dma_mapping_ops *dma_ops;
+extern struct dma_map_ops *dma_ops;
 extern struct ia64_machine_vector ia64_mv;
 extern void set_iommu_machvec(void);
 
-#define dma_alloc_coherent(dev, size, handle, gfp)	\
-	platform_dma_alloc_coherent(dev, size, handle, (gfp) | GFP_DMA)
+extern void machvec_dma_sync_single(struct device *, dma_addr_t, size_t,
+				    enum dma_data_direction);
+extern void machvec_dma_sync_sg(struct device *, struct scatterlist *, int,
+				enum dma_data_direction);
 
-/* coherent mem. is cheap */
-static inline void *
-dma_alloc_noncoherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
-		      gfp_t flag)
+static inline void *dma_alloc_coherent(struct device *dev, size_t size,
+				       dma_addr_t *daddr, gfp_t gfp)
 {
-	return dma_alloc_coherent(dev, size, dma_handle, flag);
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	return ops->alloc_coherent(dev, size, daddr, gfp);
 }
-#define dma_free_coherent	platform_dma_free_coherent
-static inline void
-dma_free_noncoherent(struct device *dev, size_t size, void *cpu_addr,
-		     dma_addr_t dma_handle)
+
+static inline void dma_free_coherent(struct device *dev, size_t size,
+				     void *caddr, dma_addr_t daddr)
+{
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	ops->free_coherent(dev, size, caddr, daddr);
+}
+
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+
+static inline dma_addr_t dma_map_single_attrs(struct device *dev,
+					      void *caddr, size_t size,
+					      enum dma_data_direction dir,
+					      struct dma_attrs *attrs)
+{
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	return ops->map_page(dev, virt_to_page(caddr),
+			     (unsigned long)caddr & ~PAGE_MASK, size,
+			     dir, attrs);
+}
+
+static inline void dma_unmap_single_attrs(struct device *dev, dma_addr_t daddr,
+					  size_t size,
+					  enum dma_data_direction dir,
+					  struct dma_attrs *attrs)
+{
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	ops->unmap_page(dev, daddr, size, dir, attrs);
+}
+
+#define dma_map_single(d, a, s, r) dma_map_single_attrs(d, a, s, r, NULL)
+#define dma_unmap_single(d, a, s, r) dma_unmap_single_attrs(d, a, s, r, NULL)
+
+static inline int dma_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
+				   int nents, enum dma_data_direction dir,
+				   struct dma_attrs *attrs)
+{
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	return ops->map_sg(dev, sgl, nents, dir, attrs);
+}
+
+static inline void dma_unmap_sg_attrs(struct device *dev,
+				      struct scatterlist *sgl, int nents,
+				      enum dma_data_direction dir,
+				      struct dma_attrs *attrs)
+{
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	ops->unmap_sg(dev, sgl, nents, dir, attrs);
+}
+
+#define dma_map_sg(d, s, n, r) dma_map_sg_attrs(d, s, n, r, NULL)
+#define dma_unmap_sg(d, s, n, r) dma_unmap_sg_attrs(d, s, n, r, NULL)
+
+static inline void dma_sync_single_for_cpu(struct device *dev, dma_addr_t daddr,
+					   size_t size,
+					   enum dma_data_direction dir)
 {
-	dma_free_coherent(dev, size, cpu_addr, dma_handle);
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	ops->sync_single_for_cpu(dev, daddr, size, dir);
 }
-#define dma_map_single_attrs	platform_dma_map_single_attrs
-static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
-					size_t size, int dir)
+
+static inline void dma_sync_sg_for_cpu(struct device *dev,
+				       struct scatterlist *sgl,
+				       int nents, enum dma_data_direction dir)
 {
-	return dma_map_single_attrs(dev, cpu_addr, size, dir, NULL);
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	ops->sync_sg_for_cpu(dev, sgl, nents, dir);
 }
-#define dma_map_sg_attrs	platform_dma_map_sg_attrs
-static inline int dma_map_sg(struct device *dev, struct scatterlist *sgl,
-			     int nents, int dir)
+
+static inline void dma_sync_single_for_device(struct device *dev,
+					      dma_addr_t daddr,
+					      size_t size,
+					      enum dma_data_direction dir)
 {
-	return dma_map_sg_attrs(dev, sgl, nents, dir, NULL);
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	ops->sync_single_for_device(dev, daddr, size, dir);
 }
-#define dma_unmap_single_attrs	platform_dma_unmap_single_attrs
-static inline void dma_unmap_single(struct device *dev, dma_addr_t cpu_addr,
-				    size_t size, int dir)
+
+static inline void dma_sync_sg_for_device(struct device *dev,
+					  struct scatterlist *sgl,
+					  int nents,
+					  enum dma_data_direction dir)
 {
-	return dma_unmap_single_attrs(dev, cpu_addr, size, dir, NULL);
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	ops->sync_sg_for_device(dev, sgl, nents, dir);
 }
-#define dma_unmap_sg_attrs	platform_dma_unmap_sg_attrs
-static inline void dma_unmap_sg(struct device *dev, struct scatterlist *sgl,
-				int nents, int dir)
+
+static inline int dma_mapping_error(struct device *dev, dma_addr_t daddr)
+{
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	return ops->mapping_error(dev, daddr);
+}
+
+static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
+				      size_t offset, size_t size,
+				      enum dma_data_direction dir)
 {
-	return dma_unmap_sg_attrs(dev, sgl, nents, dir, NULL);
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	return ops->map_page(dev, page, offset, size, dir, NULL);
 }
-#define dma_sync_single_for_cpu	platform_dma_sync_single_for_cpu
-#define dma_sync_sg_for_cpu	platform_dma_sync_sg_for_cpu
-#define dma_sync_single_for_device platform_dma_sync_single_for_device
-#define dma_sync_sg_for_device	platform_dma_sync_sg_for_device
-#define dma_mapping_error	platform_dma_mapping_error
 
-#define dma_map_page(dev, pg, off, size, dir)				\
-	dma_map_single(dev, page_address(pg) + (off), (size), (dir))
-#define dma_unmap_page(dev, dma_addr, size, dir)			\
-	dma_unmap_single(dev, dma_addr, size, dir)
+static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
+				  size_t size, enum dma_data_direction dir)
+{
+	dma_unmap_single(dev, addr, size, dir);
+}
 
 /*
  * Rest of this file is part of the "Advanced DMA API".  Use at your own risk.
@@ -115,7 +144,11 @@ static inline void dma_unmap_sg(struct device *dev, struct scatterlist *sgl,
 #define dma_sync_single_range_for_device(dev, dma_handle, offset, size, dir)	\
 	dma_sync_single_for_device(dev, dma_handle, size, dir)
 
-#define dma_supported		platform_dma_supported
+static inline int dma_supported(struct device *dev, u64 mask)
+{
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	return ops->dma_supported(dev, mask);
+}
 
 static inline int
 dma_set_mask (struct device *dev, u64 mask)
@@ -141,11 +174,4 @@ dma_cache_sync (struct device *dev, void *vaddr, size_t size,
 
 #define dma_is_consistent(d, h)	(1)	/* all we do is coherent memory... */
 
-static inline struct dma_mapping_ops *get_dma_ops(struct device *dev)
-{
-	return dma_ops;
-}
-
-
-
 #endif /* _ASM_IA64_DMA_MAPPING_H */
diff --git a/arch/ia64/include/asm/machvec.h b/arch/ia64/include/asm/machvec.h
index fe87b21..367d299 100644
--- a/arch/ia64/include/asm/machvec.h
+++ b/arch/ia64/include/asm/machvec.h
@@ -11,7 +11,6 @@
 #define _ASM_IA64_MACHVEC_H
 
 #include <linux/types.h>
-#include <linux/swiotlb.h>
 
 /* forward declarations: */
 struct device;
@@ -45,24 +44,8 @@ typedef void ia64_mv_kernel_launch_event_t(void);
 
 /* DMA-mapping interface: */
 typedef void ia64_mv_dma_init (void);
-typedef void *ia64_mv_dma_alloc_coherent (struct device *, size_t, dma_addr_t *, gfp_t);
-typedef void ia64_mv_dma_free_coherent (struct device *, size_t, void *, dma_addr_t);
-typedef dma_addr_t ia64_mv_dma_map_single (struct device *, void *, size_t, int);
-typedef void ia64_mv_dma_unmap_single (struct device *, dma_addr_t, size_t, int);
-typedef int ia64_mv_dma_map_sg (struct device *, struct scatterlist *, int, int);
-typedef void ia64_mv_dma_unmap_sg (struct device *, struct scatterlist *, int, int);
-typedef void ia64_mv_dma_sync_single_for_cpu (struct device *, dma_addr_t, size_t, int);
-typedef void ia64_mv_dma_sync_sg_for_cpu (struct device *, struct scatterlist *, int, int);
-typedef void ia64_mv_dma_sync_single_for_device (struct device *, dma_addr_t, size_t, int);
-typedef void ia64_mv_dma_sync_sg_for_device (struct device *, struct scatterlist *, int, int);
-typedef int ia64_mv_dma_mapping_error(struct device *, dma_addr_t dma_addr);
-typedef int ia64_mv_dma_supported (struct device *, u64);
-
-typedef dma_addr_t ia64_mv_dma_map_single_attrs (struct device *, void *, size_t, int, struct dma_attrs *);
-typedef void ia64_mv_dma_unmap_single_attrs (struct device *, dma_addr_t, size_t, int, struct dma_attrs *);
-typedef int ia64_mv_dma_map_sg_attrs (struct device *, struct scatterlist *, int, int, struct dma_attrs *);
-typedef void ia64_mv_dma_unmap_sg_attrs (struct device *, struct scatterlist *, int, int, struct dma_attrs *);
 typedef u64 ia64_mv_dma_get_required_mask (struct device *);
+typedef struct dma_map_ops *ia64_mv_dma_get_ops(struct device *);
 
 /*
  * WARNING: The legacy I/O space is _architected_.  Platforms are
@@ -114,8 +97,6 @@ machvec_noop_bus (struct pci_bus *bus)
 
 extern void machvec_setup (char **);
 extern void machvec_timer_interrupt (int, void *);
-extern void machvec_dma_sync_single (struct device *, dma_addr_t, size_t, int);
-extern void machvec_dma_sync_sg (struct device *, struct scatterlist *, int, int);
 extern void machvec_tlb_migrate_finish (struct mm_struct *);
 
 # if defined (CONFIG_IA64_HP_SIM)
@@ -148,19 +129,8 @@ extern void machvec_tlb_migrate_finish (struct mm_struct *);
 #  define platform_global_tlb_purge	ia64_mv.global_tlb_purge
 #  define platform_tlb_migrate_finish	ia64_mv.tlb_migrate_finish
 #  define platform_dma_init		ia64_mv.dma_init
-#  define platform_dma_alloc_coherent	ia64_mv.dma_alloc_coherent
-#  define platform_dma_free_coherent	ia64_mv.dma_free_coherent
-#  define platform_dma_map_single_attrs	ia64_mv.dma_map_single_attrs
-#  define platform_dma_unmap_single_attrs	ia64_mv.dma_unmap_single_attrs
-#  define platform_dma_map_sg_attrs	ia64_mv.dma_map_sg_attrs
-#  define platform_dma_unmap_sg_attrs	ia64_mv.dma_unmap_sg_attrs
-#  define platform_dma_sync_single_for_cpu ia64_mv.dma_sync_single_for_cpu
-#  define platform_dma_sync_sg_for_cpu	ia64_mv.dma_sync_sg_for_cpu
-#  define platform_dma_sync_single_for_device ia64_mv.dma_sync_single_for_device
-#  define platform_dma_sync_sg_for_device ia64_mv.dma_sync_sg_for_device
-#  define platform_dma_mapping_error		ia64_mv.dma_mapping_error
-#  define platform_dma_supported	ia64_mv.dma_supported
 #  define platform_dma_get_required_mask ia64_mv.dma_get_required_mask
+#  define platform_dma_get_ops		ia64_mv.dma_get_ops
 #  define platform_irq_to_vector	ia64_mv.irq_to_vector
 #  define platform_local_vector_to_irq	ia64_mv.local_vector_to_irq
 #  define platform_pci_get_legacy_mem	ia64_mv.pci_get_legacy_mem
@@ -203,19 +173,8 @@ struct ia64_machine_vector {
 	ia64_mv_global_tlb_purge_t *global_tlb_purge;
 	ia64_mv_tlb_migrate_finish_t *tlb_migrate_finish;
 	ia64_mv_dma_init *dma_init;
-	ia64_mv_dma_alloc_coherent *dma_alloc_coherent;
-	ia64_mv_dma_free_coherent *dma_free_coherent;
-	ia64_mv_dma_map_single_attrs *dma_map_single_attrs;
-	ia64_mv_dma_unmap_single_attrs *dma_unmap_single_attrs;
-	ia64_mv_dma_map_sg_attrs *dma_map_sg_attrs;
-	ia64_mv_dma_unmap_sg_attrs *dma_unmap_sg_attrs;
-	ia64_mv_dma_sync_single_for_cpu *dma_sync_single_for_cpu;
-	ia64_mv_dma_sync_sg_for_cpu *dma_sync_sg_for_cpu;
-	ia64_mv_dma_sync_single_for_device *dma_sync_single_for_device;
-	ia64_mv_dma_sync_sg_for_device *dma_sync_sg_for_device;
-	ia64_mv_dma_mapping_error *dma_mapping_error;
-	ia64_mv_dma_supported *dma_supported;
 	ia64_mv_dma_get_required_mask *dma_get_required_mask;
+	ia64_mv_dma_get_ops *dma_get_ops;
 	ia64_mv_irq_to_vector *irq_to_vector;
 	ia64_mv_local_vector_to_irq *local_vector_to_irq;
 	ia64_mv_pci_get_legacy_mem_t *pci_get_legacy_mem;
@@ -254,19 +213,8 @@ struct ia64_machine_vector {
 	platform_global_tlb_purge,		\
 	platform_tlb_migrate_finish,		\
 	platform_dma_init,			\
-	platform_dma_alloc_coherent,		\
-	platform_dma_free_coherent,		\
-	platform_dma_map_single_attrs,		\
-	platform_dma_unmap_single_attrs,	\
-	platform_dma_map_sg_attrs,		\
-	platform_dma_unmap_sg_attrs,		\
-	platform_dma_sync_single_for_cpu,	\
-	platform_dma_sync_sg_for_cpu,		\
-	platform_dma_sync_single_for_device,	\
-	platform_dma_sync_sg_for_device,	\
-	platform_dma_mapping_error,			\
-	platform_dma_supported,			\
 	platform_dma_get_required_mask,		\
+	platform_dma_get_ops,			\
 	platform_irq_to_vector,			\
 	platform_local_vector_to_irq,		\
 	platform_pci_get_legacy_mem,		\
@@ -302,6 +250,9 @@ extern void machvec_init_from_cmdline(const char *cmdline);
 #  error Unknown configuration.  Update arch/ia64/include/asm/machvec.h.
 # endif /* CONFIG_IA64_GENERIC */
 
+extern void swiotlb_dma_init(void);
+extern struct dma_map_ops *dma_get_ops(struct device *);
+
 /*
  * Define default versions so we can extend machvec for new platforms without having
  * to update the machvec files for all existing platforms.
@@ -332,43 +283,10 @@ extern void machvec_init_from_cmdline(const char *cmdline);
 # define platform_kernel_launch_event	machvec_noop
 #endif
 #ifndef platform_dma_init
-# define platform_dma_init		swiotlb_init
-#endif
-#ifndef platform_dma_alloc_coherent
-# define platform_dma_alloc_coherent	swiotlb_alloc_coherent
-#endif
-#ifndef platform_dma_free_coherent
-# define platform_dma_free_coherent	swiotlb_free_coherent
-#endif
-#ifndef platform_dma_map_single_attrs
-# define platform_dma_map_single_attrs	swiotlb_map_single_attrs
-#endif
-#ifndef platform_dma_unmap_single_attrs
-# define platform_dma_unmap_single_attrs	swiotlb_unmap_single_attrs
-#endif
-#ifndef platform_dma_map_sg_attrs
-# define platform_dma_map_sg_attrs	swiotlb_map_sg_attrs
-#endif
-#ifndef platform_dma_unmap_sg_attrs
-# define platform_dma_unmap_sg_attrs	swiotlb_unmap_sg_attrs
-#endif
-#ifndef platform_dma_sync_single_for_cpu
-# define platform_dma_sync_single_for_cpu	swiotlb_sync_single_for_cpu
-#endif
-#ifndef platform_dma_sync_sg_for_cpu
-# define platform_dma_sync_sg_for_cpu		swiotlb_sync_sg_for_cpu
-#endif
-#ifndef platform_dma_sync_single_for_device
-# define platform_dma_sync_single_for_device	swiotlb_sync_single_for_device
-#endif
-#ifndef platform_dma_sync_sg_for_device
-# define platform_dma_sync_sg_for_device	swiotlb_sync_sg_for_device
-#endif
-#ifndef platform_dma_mapping_error
-# define platform_dma_mapping_error		swiotlb_dma_mapping_error
+# define platform_dma_init		swiotlb_dma_init
 #endif
-#ifndef platform_dma_supported
-# define  platform_dma_supported	swiotlb_dma_supported
+#ifndef platform_dma_get_ops
+# define platform_dma_get_ops		dma_get_ops
 #endif
 #ifndef platform_dma_get_required_mask
 # define  platform_dma_get_required_mask	ia64_dma_get_required_mask
diff --git a/arch/ia64/include/asm/machvec_dig_vtd.h b/arch/ia64/include/asm/machvec_dig_vtd.h
index 3400b56..6ab1de5 100644
--- a/arch/ia64/include/asm/machvec_dig_vtd.h
+++ b/arch/ia64/include/asm/machvec_dig_vtd.h
@@ -2,14 +2,6 @@
 #define _ASM_IA64_MACHVEC_DIG_VTD_h
 
 extern ia64_mv_setup_t			dig_setup;
-extern ia64_mv_dma_alloc_coherent	vtd_alloc_coherent;
-extern ia64_mv_dma_free_coherent	vtd_free_coherent;
-extern ia64_mv_dma_map_single_attrs	vtd_map_single_attrs;
-extern ia64_mv_dma_unmap_single_attrs	vtd_unmap_single_attrs;
-extern ia64_mv_dma_map_sg_attrs		vtd_map_sg_attrs;
-extern ia64_mv_dma_unmap_sg_attrs	vtd_unmap_sg_attrs;
-extern ia64_mv_dma_supported		iommu_dma_supported;
-extern ia64_mv_dma_mapping_error	vtd_dma_mapping_error;
 extern ia64_mv_dma_init			pci_iommu_alloc;
 
 /*
@@ -22,17 +14,5 @@ extern ia64_mv_dma_init			pci_iommu_alloc;
 #define platform_name				"dig_vtd"
 #define platform_setup				dig_setup
 #define platform_dma_init			pci_iommu_alloc
-#define platform_dma_alloc_coherent		vtd_alloc_coherent
-#define platform_dma_free_coherent		vtd_free_coherent
-#define platform_dma_map_single_attrs		vtd_map_single_attrs
-#define platform_dma_unmap_single_attrs		vtd_unmap_single_attrs
-#define platform_dma_map_sg_attrs		vtd_map_sg_attrs
-#define platform_dma_unmap_sg_attrs		vtd_unmap_sg_attrs
-#define platform_dma_sync_single_for_cpu	machvec_dma_sync_single
-#define platform_dma_sync_sg_for_cpu		machvec_dma_sync_sg
-#define platform_dma_sync_single_for_device	machvec_dma_sync_single
-#define platform_dma_sync_sg_for_device		machvec_dma_sync_sg
-#define platform_dma_supported			iommu_dma_supported
-#define platform_dma_mapping_error		vtd_dma_mapping_error
 
 #endif /* _ASM_IA64_MACHVEC_DIG_VTD_h */
diff --git a/arch/ia64/include/asm/machvec_hpzx1.h b/arch/ia64/include/asm/machvec_hpzx1.h
index 2f57f51..3bd83d7 100644
--- a/arch/ia64/include/asm/machvec_hpzx1.h
+++ b/arch/ia64/include/asm/machvec_hpzx1.h
@@ -2,14 +2,7 @@
 #define _ASM_IA64_MACHVEC_HPZX1_h
 
 extern ia64_mv_setup_t			dig_setup;
-extern ia64_mv_dma_alloc_coherent	sba_alloc_coherent;
-extern ia64_mv_dma_free_coherent	sba_free_coherent;
-extern ia64_mv_dma_map_single_attrs	sba_map_single_attrs;
-extern ia64_mv_dma_unmap_single_attrs	sba_unmap_single_attrs;
-extern ia64_mv_dma_map_sg_attrs		sba_map_sg_attrs;
-extern ia64_mv_dma_unmap_sg_attrs	sba_unmap_sg_attrs;
-extern ia64_mv_dma_supported		sba_dma_supported;
-extern ia64_mv_dma_mapping_error	sba_dma_mapping_error;
+extern ia64_mv_dma_init			sba_dma_init;
 
 /*
  * This stuff has dual use!
@@ -20,18 +13,6 @@ extern ia64_mv_dma_mapping_error	sba_dma_mapping_error;
  */
 #define platform_name				"hpzx1"
 #define platform_setup				dig_setup
-#define platform_dma_init			machvec_noop
-#define platform_dma_alloc_coherent		sba_alloc_coherent
-#define platform_dma_free_coherent		sba_free_coherent
-#define platform_dma_map_single_attrs		sba_map_single_attrs
-#define platform_dma_unmap_single_attrs		sba_unmap_single_attrs
-#define platform_dma_map_sg_attrs		sba_map_sg_attrs
-#define platform_dma_unmap_sg_attrs		sba_unmap_sg_attrs
-#define platform_dma_sync_single_for_cpu	machvec_dma_sync_single
-#define platform_dma_sync_sg_for_cpu		machvec_dma_sync_sg
-#define platform_dma_sync_single_for_device	machvec_dma_sync_single
-#define platform_dma_sync_sg_for_device		machvec_dma_sync_sg
-#define platform_dma_supported			sba_dma_supported
-#define platform_dma_mapping_error		sba_dma_mapping_error
+#define platform_dma_init			sba_dma_init
 
 #endif /* _ASM_IA64_MACHVEC_HPZX1_h */
diff --git a/arch/ia64/include/asm/machvec_hpzx1_swiotlb.h b/arch/ia64/include/asm/machvec_hpzx1_swiotlb.h
index a842cdd..1091ac3 100644
--- a/arch/ia64/include/asm/machvec_hpzx1_swiotlb.h
+++ b/arch/ia64/include/asm/machvec_hpzx1_swiotlb.h
@@ -2,18 +2,7 @@
 #define _ASM_IA64_MACHVEC_HPZX1_SWIOTLB_h
 
 extern ia64_mv_setup_t				dig_setup;
-extern ia64_mv_dma_alloc_coherent		hwsw_alloc_coherent;
-extern ia64_mv_dma_free_coherent		hwsw_free_coherent;
-extern ia64_mv_dma_map_single_attrs		hwsw_map_single_attrs;
-extern ia64_mv_dma_unmap_single_attrs		hwsw_unmap_single_attrs;
-extern ia64_mv_dma_map_sg_attrs			hwsw_map_sg_attrs;
-extern ia64_mv_dma_unmap_sg_attrs		hwsw_unmap_sg_attrs;
-extern ia64_mv_dma_supported			hwsw_dma_supported;
-extern ia64_mv_dma_mapping_error		hwsw_dma_mapping_error;
-extern ia64_mv_dma_sync_single_for_cpu		hwsw_sync_single_for_cpu;
-extern ia64_mv_dma_sync_sg_for_cpu		hwsw_sync_sg_for_cpu;
-extern ia64_mv_dma_sync_single_for_device	hwsw_sync_single_for_device;
-extern ia64_mv_dma_sync_sg_for_device		hwsw_sync_sg_for_device;
+extern ia64_mv_dma_get_ops			hwsw_dma_get_ops;
 
 /*
  * This stuff has dual use!
@@ -23,20 +12,8 @@ extern ia64_mv_dma_sync_sg_for_device		hwsw_sync_sg_for_device;
  * the macros are used directly.
  */
 #define platform_name				"hpzx1_swiotlb"
-
 #define platform_setup				dig_setup
 #define platform_dma_init			machvec_noop
-#define platform_dma_alloc_coherent		hwsw_alloc_coherent
-#define platform_dma_free_coherent		hwsw_free_coherent
-#define platform_dma_map_single_attrs		hwsw_map_single_attrs
-#define platform_dma_unmap_single_attrs		hwsw_unmap_single_attrs
-#define platform_dma_map_sg_attrs		hwsw_map_sg_attrs
-#define platform_dma_unmap_sg_attrs		hwsw_unmap_sg_attrs
-#define platform_dma_supported			hwsw_dma_supported
-#define platform_dma_mapping_error		hwsw_dma_mapping_error
-#define platform_dma_sync_single_for_cpu	hwsw_sync_single_for_cpu
-#define platform_dma_sync_sg_for_cpu		hwsw_sync_sg_for_cpu
-#define platform_dma_sync_single_for_device	hwsw_sync_single_for_device
-#define platform_dma_sync_sg_for_device		hwsw_sync_sg_for_device
+#define platform_dma_get_ops			hwsw_dma_get_ops
 
 #endif /* _ASM_IA64_MACHVEC_HPZX1_SWIOTLB_h */
diff --git a/arch/ia64/include/asm/machvec_sn2.h b/arch/ia64/include/asm/machvec_sn2.h
index f1a6e0d..f061a30 100644
--- a/arch/ia64/include/asm/machvec_sn2.h
+++ b/arch/ia64/include/asm/machvec_sn2.h
@@ -55,19 +55,8 @@ extern ia64_mv_readb_t __sn_readb_relaxed;
 extern ia64_mv_readw_t __sn_readw_relaxed;
 extern ia64_mv_readl_t __sn_readl_relaxed;
 extern ia64_mv_readq_t __sn_readq_relaxed;
-extern ia64_mv_dma_alloc_coherent	sn_dma_alloc_coherent;
-extern ia64_mv_dma_free_coherent	sn_dma_free_coherent;
-extern ia64_mv_dma_map_single_attrs	sn_dma_map_single_attrs;
-extern ia64_mv_dma_unmap_single_attrs	sn_dma_unmap_single_attrs;
-extern ia64_mv_dma_map_sg_attrs		sn_dma_map_sg_attrs;
-extern ia64_mv_dma_unmap_sg_attrs	sn_dma_unmap_sg_attrs;
-extern ia64_mv_dma_sync_single_for_cpu	sn_dma_sync_single_for_cpu;
-extern ia64_mv_dma_sync_sg_for_cpu	sn_dma_sync_sg_for_cpu;
-extern ia64_mv_dma_sync_single_for_device sn_dma_sync_single_for_device;
-extern ia64_mv_dma_sync_sg_for_device	sn_dma_sync_sg_for_device;
-extern ia64_mv_dma_mapping_error	sn_dma_mapping_error;
-extern ia64_mv_dma_supported		sn_dma_supported;
 extern ia64_mv_dma_get_required_mask	sn_dma_get_required_mask;
+extern ia64_mv_dma_init			sn_dma_init;
 extern ia64_mv_migrate_t		sn_migrate;
 extern ia64_mv_kernel_launch_event_t	sn_kernel_launch_event;
 extern ia64_mv_setup_msi_irq_t		sn_setup_msi_irq;
@@ -111,20 +100,8 @@ extern ia64_mv_pci_fixup_bus_t		sn_pci_fixup_bus;
 #define platform_pci_get_legacy_mem	sn_pci_get_legacy_mem
 #define platform_pci_legacy_read	sn_pci_legacy_read
 #define platform_pci_legacy_write	sn_pci_legacy_write
-#define platform_dma_init		machvec_noop
-#define platform_dma_alloc_coherent	sn_dma_alloc_coherent
-#define platform_dma_free_coherent	sn_dma_free_coherent
-#define platform_dma_map_single_attrs	sn_dma_map_single_attrs
-#define platform_dma_unmap_single_attrs	sn_dma_unmap_single_attrs
-#define platform_dma_map_sg_attrs	sn_dma_map_sg_attrs
-#define platform_dma_unmap_sg_attrs	sn_dma_unmap_sg_attrs
-#define platform_dma_sync_single_for_cpu sn_dma_sync_single_for_cpu
-#define platform_dma_sync_sg_for_cpu	sn_dma_sync_sg_for_cpu
-#define platform_dma_sync_single_for_device sn_dma_sync_single_for_device
-#define platform_dma_sync_sg_for_device	sn_dma_sync_sg_for_device
-#define platform_dma_mapping_error		sn_dma_mapping_error
-#define platform_dma_supported		sn_dma_supported
 #define platform_dma_get_required_mask	sn_dma_get_required_mask
+#define platform_dma_init		sn_dma_init
 #define platform_migrate		sn_migrate
 #define platform_kernel_launch_event    sn_kernel_launch_event
 #ifdef CONFIG_PCI_MSI
diff --git a/arch/ia64/kernel/Makefile b/arch/ia64/kernel/Makefile
index c381ea9..f2778f2 100644
--- a/arch/ia64/kernel/Makefile
+++ b/arch/ia64/kernel/Makefile
@@ -7,7 +7,7 @@ extra-y	:= head.o init_task.o vmlinux.lds
 obj-y := acpi.o entry.o efi.o efi_stub.o gate-data.o fsys.o ia64_ksyms.o irq.o irq_ia64.o	\
 	 irq_lsapic.o ivt.o machvec.o pal.o patch.o process.o perfmon.o ptrace.o sal.o		\
 	 salinfo.o setup.o signal.o sys_ia64.o time.o traps.o unaligned.o \
-	 unwind.o mca.o mca_asm.o topology.o
+	 unwind.o mca.o mca_asm.o topology.o dma-mapping.o
 
 obj-$(CONFIG_IA64_BRL_EMU)	+= brl_emu.o
 obj-$(CONFIG_IA64_GENERIC)	+= acpi-ext.o
@@ -43,9 +43,7 @@ ifneq ($(CONFIG_IA64_ESI),)
 obj-y				+= esi_stub.o	# must be in kernel proper
 endif
 obj-$(CONFIG_DMAR)		+= pci-dma.o
-ifeq ($(CONFIG_DMAR), y)
 obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb.o
-endif
 
 # The gate DSO image is built using a special linker script.
 targets += gate.so gate-syms.o
diff --git a/arch/ia64/kernel/dma-mapping.c b/arch/ia64/kernel/dma-mapping.c
new file mode 100644
index 0000000..086a2ae
--- /dev/null
+++ b/arch/ia64/kernel/dma-mapping.c
@@ -0,0 +1,13 @@
+#include <linux/dma-mapping.h>
+
+/* Set this to 1 if there is a HW IOMMU in the system */
+int iommu_detected __read_mostly;
+
+struct dma_map_ops *dma_ops;
+EXPORT_SYMBOL(dma_ops);
+
+struct dma_map_ops *dma_get_ops(struct device *dev)
+{
+	return dma_ops;
+}
+EXPORT_SYMBOL(dma_get_ops);
diff --git a/arch/ia64/kernel/machvec.c b/arch/ia64/kernel/machvec.c
index 7ccb228..d41a40e 100644
--- a/arch/ia64/kernel/machvec.c
+++ b/arch/ia64/kernel/machvec.c
@@ -1,5 +1,5 @@
 #include <linux/module.h>
-
+#include <linux/dma-mapping.h>
 #include <asm/machvec.h>
 #include <asm/system.h>
 
@@ -75,14 +75,16 @@ machvec_timer_interrupt (int irq, void *dev_id)
 EXPORT_SYMBOL(machvec_timer_interrupt);
 
 void
-machvec_dma_sync_single (struct device *hwdev, dma_addr_t dma_handle, size_t size, int dir)
+machvec_dma_sync_single(struct device *hwdev, dma_addr_t dma_handle, size_t size,
+			enum dma_data_direction dir)
 {
 	mb();
 }
 EXPORT_SYMBOL(machvec_dma_sync_single);
 
 void
-machvec_dma_sync_sg (struct device *hwdev, struct scatterlist *sg, int n, int dir)
+machvec_dma_sync_sg(struct device *hwdev, struct scatterlist *sg, int n,
+		    enum dma_data_direction dir)
 {
 	mb();
 }
diff --git a/arch/ia64/kernel/pci-dma.c b/arch/ia64/kernel/pci-dma.c
index d0ada06..e4cb443 100644
--- a/arch/ia64/kernel/pci-dma.c
+++ b/arch/ia64/kernel/pci-dma.c
@@ -32,9 +32,6 @@ int force_iommu __read_mostly = 1;
 int force_iommu __read_mostly;
 #endif
 
-/* Set this to 1 if there is a HW IOMMU in the system */
-int iommu_detected __read_mostly;
-
 /* Dummy device used for NULL arguments (normally ISA). Better would
    be probably a smaller DMA mask, but this is bug-to-bug compatible
    to i386. */
@@ -44,18 +41,7 @@ struct device fallback_dev = {
 	.dma_mask = &fallback_dev.coherent_dma_mask,
 };
 
-void __init pci_iommu_alloc(void)
-{
-	/*
-	 * The order of these functions is important for
-	 * fall-back/fail-over reasons
-	 */
-	detect_intel_iommu();
-
-#ifdef CONFIG_SWIOTLB
-	pci_swiotlb_init();
-#endif
-}
+extern struct dma_map_ops intel_dma_ops;
 
 static int __init pci_iommu_init(void)
 {
@@ -79,15 +65,12 @@ iommu_dma_init(void)
 	return;
 }
 
-struct dma_mapping_ops *dma_ops;
-EXPORT_SYMBOL(dma_ops);
-
 int iommu_dma_supported(struct device *dev, u64 mask)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(dev);
+	struct dma_map_ops *ops = platform_dma_get_ops(dev);
 
-	if (ops->dma_supported_op)
-		return ops->dma_supported_op(dev, mask);
+	if (ops->dma_supported)
+		return ops->dma_supported(dev, mask);
 
 	/* Copied from i386. Doesn't make much sense, because it will
 	   only work for pci_alloc_coherent.
@@ -116,4 +99,25 @@ int iommu_dma_supported(struct device *dev, u64 mask)
 }
 EXPORT_SYMBOL(iommu_dma_supported);
 
+void __init pci_iommu_alloc(void)
+{
+	dma_ops = &intel_dma_ops;
+
+	dma_ops->sync_single_for_cpu = machvec_dma_sync_single;
+	dma_ops->sync_sg_for_cpu = machvec_dma_sync_sg;
+	dma_ops->sync_single_for_device = machvec_dma_sync_single;
+	dma_ops->sync_sg_for_device = machvec_dma_sync_sg;
+	dma_ops->dma_supported = iommu_dma_supported;
+
+	/*
+	 * The order of these functions is important for
+	 * fall-back/fail-over reasons
+	 */
+	detect_intel_iommu();
+
+#ifdef CONFIG_SWIOTLB
+	pci_swiotlb_init();
+#endif
+}
+
 #endif
diff --git a/arch/ia64/kernel/pci-swiotlb.c b/arch/ia64/kernel/pci-swiotlb.c
index 16c5051..573f02c 100644
--- a/arch/ia64/kernel/pci-swiotlb.c
+++ b/arch/ia64/kernel/pci-swiotlb.c
@@ -13,23 +13,37 @@
 int swiotlb __read_mostly;
 EXPORT_SYMBOL(swiotlb);
 
-struct dma_mapping_ops swiotlb_dma_ops = {
-	.mapping_error = swiotlb_dma_mapping_error,
-	.alloc_coherent = swiotlb_alloc_coherent,
+static void *ia64_swiotlb_alloc_coherent(struct device *dev, size_t size,
+					 dma_addr_t *dma_handle, gfp_t gfp)
+{
+	if (dev->coherent_dma_mask != DMA_64BIT_MASK)
+		gfp |= GFP_DMA;
+	return swiotlb_alloc_coherent(dev, size, dma_handle, gfp);
+}
+
+struct dma_map_ops swiotlb_dma_ops = {
+	.alloc_coherent = ia64_swiotlb_alloc_coherent,
 	.free_coherent = swiotlb_free_coherent,
-	.map_single = swiotlb_map_single,
-	.unmap_single = swiotlb_unmap_single,
+	.map_page = swiotlb_map_page,
+	.unmap_page = swiotlb_unmap_page,
+	.map_sg = swiotlb_map_sg_attrs,
+	.unmap_sg = swiotlb_unmap_sg_attrs,
 	.sync_single_for_cpu = swiotlb_sync_single_for_cpu,
 	.sync_single_for_device = swiotlb_sync_single_for_device,
 	.sync_single_range_for_cpu = swiotlb_sync_single_range_for_cpu,
 	.sync_single_range_for_device = swiotlb_sync_single_range_for_device,
 	.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
 	.sync_sg_for_device = swiotlb_sync_sg_for_device,
-	.map_sg = swiotlb_map_sg,
-	.unmap_sg = swiotlb_unmap_sg,
-	.dma_supported_op = swiotlb_dma_supported,
+	.dma_supported = swiotlb_dma_supported,
+	.mapping_error = swiotlb_dma_mapping_error,
 };
 
+void __init swiotlb_dma_init(void)
+{
+	dma_ops = &swiotlb_dma_ops;
+	swiotlb_init();
+}
+
 void __init pci_swiotlb_init(void)
 {
 	if (!iommu_detected) {
diff --git a/arch/ia64/sn/pci/pci_dma.c b/arch/ia64/sn/pci/pci_dma.c
index 863f501..8c130e8 100644
--- a/arch/ia64/sn/pci/pci_dma.c
+++ b/arch/ia64/sn/pci/pci_dma.c
@@ -10,7 +10,7 @@
  */
 
 #include <linux/module.h>
-#include <linux/dma-attrs.h>
+#include <linux/dma-mapping.h>
 #include <asm/dma.h>
 #include <asm/sn/intr.h>
 #include <asm/sn/pcibus_provider_defs.h>
@@ -31,7 +31,7 @@
  * this function.  Of course, SN only supports devices that have 32 or more
  * address bits when using the PMU.
  */
-int sn_dma_supported(struct device *dev, u64 mask)
+static int sn_dma_supported(struct device *dev, u64 mask)
 {
 	BUG_ON(dev->bus != &pci_bus_type);
 
@@ -39,7 +39,6 @@ int sn_dma_supported(struct device *dev, u64 mask)
 		return 0;
 	return 1;
 }
-EXPORT_SYMBOL(sn_dma_supported);
 
 /**
  * sn_dma_set_mask - set the DMA mask
@@ -75,8 +74,8 @@ EXPORT_SYMBOL(sn_dma_set_mask);
  * queue for a SCSI controller).  See Documentation/DMA-API.txt for
  * more information.
  */
-void *sn_dma_alloc_coherent(struct device *dev, size_t size,
-			    dma_addr_t * dma_handle, gfp_t flags)
+static void *sn_dma_alloc_coherent(struct device *dev, size_t size,
+				   dma_addr_t * dma_handle, gfp_t flags)
 {
 	void *cpuaddr;
 	unsigned long phys_addr;
@@ -124,7 +123,6 @@ void *sn_dma_alloc_coherent(struct device *dev, size_t size,
 
 	return cpuaddr;
 }
-EXPORT_SYMBOL(sn_dma_alloc_coherent);
 
 /**
  * sn_pci_free_coherent - free memory associated with coherent DMAable region
@@ -136,8 +134,8 @@ EXPORT_SYMBOL(sn_dma_alloc_coherent);
  * Frees the memory allocated by dma_alloc_coherent(), potentially unmapping
  * any associated IOMMU mappings.
  */
-void sn_dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
-			  dma_addr_t dma_handle)
+static void sn_dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
+				 dma_addr_t dma_handle)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
@@ -147,7 +145,6 @@ void sn_dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
 	provider->dma_unmap(pdev, dma_handle, 0);
 	free_pages((unsigned long)cpu_addr, get_order(size));
 }
-EXPORT_SYMBOL(sn_dma_free_coherent);
 
 /**
  * sn_dma_map_single_attrs - map a single page for DMA
@@ -173,10 +170,12 @@ EXPORT_SYMBOL(sn_dma_free_coherent);
  * TODO: simplify our interface;
  *       figure out how to save dmamap handle so can use two step.
  */
-dma_addr_t sn_dma_map_single_attrs(struct device *dev, void *cpu_addr,
-				   size_t size, int direction,
-				   struct dma_attrs *attrs)
+static dma_addr_t sn_dma_map_page(struct device *dev, struct page *page,
+				  unsigned long offset, size_t size,
+				  enum dma_data_direction dir,
+				  struct dma_attrs *attrs)
 {
+	void *cpu_addr = page_address(page) + offset;
 	dma_addr_t dma_addr;
 	unsigned long phys_addr;
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -201,7 +200,6 @@ dma_addr_t sn_dma_map_single_attrs(struct device *dev, void *cpu_addr,
 	}
 	return dma_addr;
 }
-EXPORT_SYMBOL(sn_dma_map_single_attrs);
 
 /**
  * sn_dma_unmap_single_attrs - unamp a DMA mapped page
@@ -215,21 +213,20 @@ EXPORT_SYMBOL(sn_dma_map_single_attrs);
  * by @dma_handle into the coherence domain.  On SN, we're always cache
  * coherent, so we just need to free any ATEs associated with this mapping.
  */
-void sn_dma_unmap_single_attrs(struct device *dev, dma_addr_t dma_addr,
-			       size_t size, int direction,
-			       struct dma_attrs *attrs)
+static void sn_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
+			      size_t size, enum dma_data_direction dir,
+			      struct dma_attrs *attrs)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
 
 	BUG_ON(dev->bus != &pci_bus_type);
 
-	provider->dma_unmap(pdev, dma_addr, direction);
+	provider->dma_unmap(pdev, dma_addr, dir);
 }
-EXPORT_SYMBOL(sn_dma_unmap_single_attrs);
 
 /**
- * sn_dma_unmap_sg_attrs - unmap a DMA scatterlist
+ * sn_dma_unmap_sg - unmap a DMA scatterlist
  * @dev: device to unmap
  * @sg: scatterlist to unmap
  * @nhwentries: number of scatterlist entries
@@ -238,9 +235,9 @@ EXPORT_SYMBOL(sn_dma_unmap_single_attrs);
  *
  * Unmap a set of streaming mode DMA translations.
  */
-void sn_dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sgl,
-			   int nhwentries, int direction,
-			   struct dma_attrs *attrs)
+static void sn_dma_unmap_sg(struct device *dev, struct scatterlist *sgl,
+			    int nhwentries, enum dma_data_direction dir,
+			    struct dma_attrs *attrs)
 {
 	int i;
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -250,15 +247,14 @@ void sn_dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sgl,
 	BUG_ON(dev->bus != &pci_bus_type);
 
 	for_each_sg(sgl, sg, nhwentries, i) {
-		provider->dma_unmap(pdev, sg->dma_address, direction);
+		provider->dma_unmap(pdev, sg->dma_address, dir);
 		sg->dma_address = (dma_addr_t) NULL;
 		sg->dma_length = 0;
 	}
 }
-EXPORT_SYMBOL(sn_dma_unmap_sg_attrs);
 
 /**
- * sn_dma_map_sg_attrs - map a scatterlist for DMA
+ * sn_dma_map_sg - map a scatterlist for DMA
  * @dev: device to map for
  * @sg: scatterlist to map
  * @nhwentries: number of entries
@@ -272,8 +268,9 @@ EXPORT_SYMBOL(sn_dma_unmap_sg_attrs);
  *
  * Maps each entry of @sg for DMA.
  */
-int sn_dma_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
-			int nhwentries, int direction, struct dma_attrs *attrs)
+static int sn_dma_map_sg(struct device *dev, struct scatterlist *sgl,
+			 int nhwentries, enum dma_data_direction dir,
+			 struct dma_attrs *attrs)
 {
 	unsigned long phys_addr;
 	struct scatterlist *saved_sg = sgl, *sg;
@@ -310,8 +307,7 @@ int sn_dma_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
 			 * Free any successfully allocated entries.
 			 */
 			if (i > 0)
-				sn_dma_unmap_sg_attrs(dev, saved_sg, i,
-						      direction, attrs);
+				sn_dma_unmap_sg(dev, saved_sg, i, dir, attrs);
 			return 0;
 		}
 
@@ -320,41 +316,36 @@ int sn_dma_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
 
 	return nhwentries;
 }
-EXPORT_SYMBOL(sn_dma_map_sg_attrs);
 
-void sn_dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
-				size_t size, int direction)
+static void sn_dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
+				       size_t size, enum dma_data_direction dir)
 {
 	BUG_ON(dev->bus != &pci_bus_type);
 }
-EXPORT_SYMBOL(sn_dma_sync_single_for_cpu);
 
-void sn_dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
-				   size_t size, int direction)
+static void sn_dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
+					  size_t size,
+					  enum dma_data_direction dir)
 {
 	BUG_ON(dev->bus != &pci_bus_type);
 }
-EXPORT_SYMBOL(sn_dma_sync_single_for_device);
 
-void sn_dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
-			    int nelems, int direction)
+static void sn_dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
+				   int nelems, enum dma_data_direction dir)
 {
 	BUG_ON(dev->bus != &pci_bus_type);
 }
-EXPORT_SYMBOL(sn_dma_sync_sg_for_cpu);
 
-void sn_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
-			       int nelems, int direction)
+static void sn_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
+				      int nelems, enum dma_data_direction dir)
 {
 	BUG_ON(dev->bus != &pci_bus_type);
 }
-EXPORT_SYMBOL(sn_dma_sync_sg_for_device);
 
-int sn_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+static int sn_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return 0;
 }
-EXPORT_SYMBOL(sn_dma_mapping_error);
 
 u64 sn_dma_get_required_mask(struct device *dev)
 {
@@ -471,3 +462,23 @@ int sn_pci_legacy_write(struct pci_bus *bus, u16 port, u32 val, u8 size)
  out:
 	return ret;
 }
+
+static struct dma_map_ops sn_dma_ops = {
+	.alloc_coherent		= sn_dma_alloc_coherent,
+	.free_coherent		= sn_dma_free_coherent,
+	.map_page		= sn_dma_map_page,
+	.unmap_page		= sn_dma_unmap_page,
+	.map_sg			= sn_dma_map_sg,
+	.unmap_sg		= sn_dma_unmap_sg,
+	.sync_single_for_cpu 	= sn_dma_sync_single_for_cpu,
+	.sync_sg_for_cpu	= sn_dma_sync_sg_for_cpu,
+	.sync_single_for_device = sn_dma_sync_single_for_device,
+	.sync_sg_for_device	= sn_dma_sync_sg_for_device,
+	.mapping_error		= sn_dma_mapping_error,
+	.dma_supported		= sn_dma_supported,
+};
+
+void sn_dma_init(void)
+{
+	dma_ops = &sn_dma_ops;
+}
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 06c02c0..c9012b9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -40,6 +40,7 @@ config X86
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select USER_STACKTRACE_SUPPORT
+	select HAVE_DMA_API_DEBUG
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
diff --git a/arch/x86/include/asm/device.h b/arch/x86/include/asm/device.h
index 3c034f4..4994a20 100644
--- a/arch/x86/include/asm/device.h
+++ b/arch/x86/include/asm/device.h
@@ -6,7 +6,7 @@ struct dev_archdata {
 	void	*acpi_handle;
 #endif
 #ifdef CONFIG_X86_64
-struct dma_mapping_ops *dma_ops;
+struct dma_map_ops *dma_ops;
 #endif
 #ifdef CONFIG_DMAR
 	void *iommu; /* hook for IOMMU specific extension */
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 132a134..cea7b74 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -7,6 +7,8 @@
  */
 
 #include <linux/scatterlist.h>
+#include <linux/dma-debug.h>
+#include <linux/dma-attrs.h>
 #include <asm/io.h>
 #include <asm/swiotlb.h>
 #include <asm-generic/dma-coherent.h>
@@ -16,47 +18,9 @@ extern int iommu_merge;
 extern struct device x86_dma_fallback_dev;
 extern int panic_on_overflow;
 
-struct dma_mapping_ops {
-	int             (*mapping_error)(struct device *dev,
-					 dma_addr_t dma_addr);
-	void*           (*alloc_coherent)(struct device *dev, size_t size,
-				dma_addr_t *dma_handle, gfp_t gfp);
-	void            (*free_coherent)(struct device *dev, size_t size,
-				void *vaddr, dma_addr_t dma_handle);
-	dma_addr_t      (*map_single)(struct device *hwdev, phys_addr_t ptr,
-				size_t size, int direction);
-	void            (*unmap_single)(struct device *dev, dma_addr_t addr,
-				size_t size, int direction);
-	void            (*sync_single_for_cpu)(struct device *hwdev,
-				dma_addr_t dma_handle, size_t size,
-				int direction);
-	void            (*sync_single_for_device)(struct device *hwdev,
-				dma_addr_t dma_handle, size_t size,
-				int direction);
-	void            (*sync_single_range_for_cpu)(struct device *hwdev,
-				dma_addr_t dma_handle, unsigned long offset,
-				size_t size, int direction);
-	void            (*sync_single_range_for_device)(struct device *hwdev,
-				dma_addr_t dma_handle, unsigned long offset,
-				size_t size, int direction);
-	void            (*sync_sg_for_cpu)(struct device *hwdev,
-				struct scatterlist *sg, int nelems,
-				int direction);
-	void            (*sync_sg_for_device)(struct device *hwdev,
-				struct scatterlist *sg, int nelems,
-				int direction);
-	int             (*map_sg)(struct device *hwdev, struct scatterlist *sg,
-				int nents, int direction);
-	void            (*unmap_sg)(struct device *hwdev,
-				struct scatterlist *sg, int nents,
-				int direction);
-	int             (*dma_supported)(struct device *hwdev, u64 mask);
-	int		is_phys;
-};
-
-extern struct dma_mapping_ops *dma_ops;
-
-static inline struct dma_mapping_ops *get_dma_ops(struct device *dev)
+extern struct dma_map_ops *dma_ops;
+
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 #ifdef CONFIG_X86_32
 	return dma_ops;
@@ -71,7 +35,7 @@ static inline struct dma_mapping_ops *get_dma_ops(struct device *dev)
 /* Make sure we keep the same behaviour */
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(dev);
+	struct dma_map_ops *ops = get_dma_ops(dev);
 	if (ops->mapping_error)
 		return ops->mapping_error(dev, dma_addr);
 
@@ -90,137 +54,167 @@ extern void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 
 static inline dma_addr_t
 dma_map_single(struct device *hwdev, void *ptr, size_t size,
-	       int direction)
+	       enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
-
-	BUG_ON(!valid_dma_direction(direction));
-	return ops->map_single(hwdev, virt_to_phys(ptr), size, direction);
+	struct dma_map_ops *ops = get_dma_ops(hwdev);
+	dma_addr_t addr;
+
+	BUG_ON(!valid_dma_direction(dir));
+	addr = ops->map_page(hwdev, virt_to_page(ptr),
+			     (unsigned long)ptr & ~PAGE_MASK, size,
+			     dir, NULL);
+	debug_dma_map_page(hwdev, virt_to_page(ptr),
+			   (unsigned long)ptr & ~PAGE_MASK, size,
+			   dir, addr, true);
+	return addr;
 }
 
 static inline void
 dma_unmap_single(struct device *dev, dma_addr_t addr, size_t size,
-		 int direction)
+		 enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(dev);
+	struct dma_map_ops *ops = get_dma_ops(dev);
 
-	BUG_ON(!valid_dma_direction(direction));
-	if (ops->unmap_single)
-		ops->unmap_single(dev, addr, size, direction);
+	BUG_ON(!valid_dma_direction(dir));
+	if (ops->unmap_page)
+		ops->unmap_page(dev, addr, size, dir, NULL);
+	debug_dma_unmap_page(dev, addr, size, dir, true);
 }
 
 static inline int
 dma_map_sg(struct device *hwdev, struct scatterlist *sg,
-	   int nents, int direction)
+	   int nents, enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+	struct dma_map_ops *ops = get_dma_ops(hwdev);
+	int ents;
+
+	BUG_ON(!valid_dma_direction(dir));
+	ents = ops->map_sg(hwdev, sg, nents, dir, NULL);
+	debug_dma_map_sg(hwdev, sg, nents, ents, dir);
 
-	BUG_ON(!valid_dma_direction(direction));
-	return ops->map_sg(hwdev, sg, nents, direction);
+	return ents;
 }
 
 static inline void
 dma_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
-	     int direction)
+	     enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+	struct dma_map_ops *ops = get_dma_ops(hwdev);
 
-	BUG_ON(!valid_dma_direction(direction));
+	BUG_ON(!valid_dma_direction(dir));
+	debug_dma_unmap_sg(hwdev, sg, nents, dir);
 	if (ops->unmap_sg)
-		ops->unmap_sg(hwdev, sg, nents, direction);
+		ops->unmap_sg(hwdev, sg, nents, dir, NULL);
 }
 
 static inline void
 dma_sync_single_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
-			size_t size, int direction)
+			size_t size, enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+	struct dma_map_ops *ops = get_dma_ops(hwdev);
 
-	BUG_ON(!valid_dma_direction(direction));
+	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_for_cpu)
-		ops->sync_single_for_cpu(hwdev, dma_handle, size, direction);
+		ops->sync_single_for_cpu(hwdev, dma_handle, size, dir);
+	debug_dma_sync_single_for_cpu(hwdev, dma_handle, size, dir);
 	flush_write_buffers();
 }
 
 static inline void
 dma_sync_single_for_device(struct device *hwdev, dma_addr_t dma_handle,
-			   size_t size, int direction)
+			   size_t size, enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+	struct dma_map_ops *ops = get_dma_ops(hwdev);
 
-	BUG_ON(!valid_dma_direction(direction));
+	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_for_device)
-		ops->sync_single_for_device(hwdev, dma_handle, size, direction);
+		ops->sync_single_for_device(hwdev, dma_handle, size, dir);
+	debug_dma_sync_single_for_device(hwdev, dma_handle, size, dir);
 	flush_write_buffers();
 }
 
 static inline void
 dma_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
-			      unsigned long offset, size_t size, int direction)
+			      unsigned long offset, size_t size,
+			      enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+	struct dma_map_ops *ops = get_dma_ops(hwdev);
 
-	BUG_ON(!valid_dma_direction(direction));
+	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_range_for_cpu)
 		ops->sync_single_range_for_cpu(hwdev, dma_handle, offset,
-					       size, direction);
+					       size, dir);
+	debug_dma_sync_single_range_for_cpu(hwdev, dma_handle,
+					    offset, size, dir);
 	flush_write_buffers();
 }
 
 static inline void
 dma_sync_single_range_for_device(struct device *hwdev, dma_addr_t dma_handle,
 				 unsigned long offset, size_t size,
-				 int direction)
+				 enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+	struct dma_map_ops *ops = get_dma_ops(hwdev);
 
-	BUG_ON(!valid_dma_direction(direction));
+	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_single_range_for_device)
 		ops->sync_single_range_for_device(hwdev, dma_handle,
-						  offset, size, direction);
+						  offset, size, dir);
+	debug_dma_sync_single_range_for_device(hwdev, dma_handle,
+					       offset, size, dir);
 	flush_write_buffers();
 }
 
 static inline void
 dma_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
-		    int nelems, int direction)
+		    int nelems, enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+	struct dma_map_ops *ops = get_dma_ops(hwdev);
 
-	BUG_ON(!valid_dma_direction(direction));
+	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_sg_for_cpu)
-		ops->sync_sg_for_cpu(hwdev, sg, nelems, direction);
+		ops->sync_sg_for_cpu(hwdev, sg, nelems, dir);
+	debug_dma_sync_sg_for_cpu(hwdev, sg, nelems, dir);
 	flush_write_buffers();
 }
 
 static inline void
 dma_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
-		       int nelems, int direction)
+		       int nelems, enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+	struct dma_map_ops *ops = get_dma_ops(hwdev);
 
-	BUG_ON(!valid_dma_direction(direction));
+	BUG_ON(!valid_dma_direction(dir));
 	if (ops->sync_sg_for_device)
-		ops->sync_sg_for_device(hwdev, sg, nelems, direction);
+		ops->sync_sg_for_device(hwdev, sg, nelems, dir);
+	debug_dma_sync_sg_for_device(hwdev, sg, nelems, dir);
 
 	flush_write_buffers();
 }
 
 static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 				      size_t offset, size_t size,
-				      int direction)
+				      enum dma_data_direction dir)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(dev);
+	struct dma_map_ops *ops = get_dma_ops(dev);
+	dma_addr_t addr;
 
-	BUG_ON(!valid_dma_direction(direction));
-	return ops->map_single(dev, page_to_phys(page) + offset,
-			       size, direction);
+	BUG_ON(!valid_dma_direction(dir));
+	addr = ops->map_page(dev, page, offset, size, dir, NULL);
+	debug_dma_map_page(dev, page, offset, size, dir, addr, false);
+
+	return addr;
 }
 
 static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
-				  size_t size, int direction)
+				  size_t size, enum dma_data_direction dir)
 {
-	dma_unmap_single(dev, addr, size, direction);
+	struct dma_map_ops *ops = get_dma_ops(dev);
+
+	BUG_ON(!valid_dma_direction(dir));
+	if (ops->unmap_page)
+		ops->unmap_page(dev, addr, size, dir, NULL);
+	debug_dma_unmap_page(dev, addr, size, dir, false);
 }
 
 static inline void
@@ -266,7 +260,7 @@ static inline void *
 dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t gfp)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(dev);
+	struct dma_map_ops *ops = get_dma_ops(dev);
 	void *memory;
 
 	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
@@ -285,20 +279,24 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	if (!ops->alloc_coherent)
 		return NULL;
 
-	return ops->alloc_coherent(dev, size, dma_handle,
-				   dma_alloc_coherent_gfp_flags(dev, gfp));
+	memory = ops->alloc_coherent(dev, size, dma_handle,
+				     dma_alloc_coherent_gfp_flags(dev, gfp));
+	debug_dma_alloc_coherent(dev, size, *dma_handle, memory);
+
+	return memory;
 }
 
 static inline void dma_free_coherent(struct device *dev, size_t size,
 				     void *vaddr, dma_addr_t bus)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(dev);
+	struct dma_map_ops *ops = get_dma_ops(dev);
 
 	WARN_ON(irqs_disabled());       /* for portability */
 
 	if (dma_release_from_coherent(dev, get_order(size), vaddr))
 		return;
 
+	debug_dma_free_coherent(dev, size, vaddr, bus);
 	if (ops->free_coherent)
 		ops->free_coherent(dev, size, vaddr, bus);
 }
diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index a6ee9e6..af326a2 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -3,7 +3,7 @@
 
 extern void pci_iommu_shutdown(void);
 extern void no_iommu_init(void);
-extern struct dma_mapping_ops nommu_dma_ops;
+extern struct dma_map_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 95f216b..1fc811b 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -106,7 +106,7 @@ obj-$(CONFIG_MICROCODE)			+= microcode.o
 
 obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
 
-obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb_64.o # NB rename without _64
+obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
 
 ###
 # 64 bit specific files
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 5113c08..c5962fe 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -22,10 +22,9 @@
 #include <linux/bitops.h>
 #include <linux/debugfs.h>
 #include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
 #include <linux/iommu-helper.h>
-#ifdef CONFIG_IOMMU_API
 #include <linux/iommu.h>
-#endif
 #include <asm/proto.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
@@ -1297,8 +1296,10 @@ static void __unmap_single(struct amd_iommu *iommu,
 /*
  * The exported map_single function for dma_ops.
  */
-static dma_addr_t map_single(struct device *dev, phys_addr_t paddr,
-			     size_t size, int dir)
+static dma_addr_t map_page(struct device *dev, struct page *page,
+			   unsigned long offset, size_t size,
+			   enum dma_data_direction dir,
+			   struct dma_attrs *attrs)
 {
 	unsigned long flags;
 	struct amd_iommu *iommu;
@@ -1306,6 +1307,7 @@ static dma_addr_t map_single(struct device *dev, phys_addr_t paddr,
 	u16 devid;
 	dma_addr_t addr;
 	u64 dma_mask;
+	phys_addr_t paddr = page_to_phys(page) + offset;
 
 	INC_STATS_COUNTER(cnt_map_single);
 
@@ -1340,8 +1342,8 @@ out:
 /*
  * The exported unmap_single function for dma_ops.
  */
-static void unmap_single(struct device *dev, dma_addr_t dma_addr,
-			 size_t size, int dir)
+static void unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
+		       enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	unsigned long flags;
 	struct amd_iommu *iommu;
@@ -1390,7 +1392,8 @@ static int map_sg_no_iommu(struct device *dev, struct scatterlist *sglist,
  * lists).
  */
 static int map_sg(struct device *dev, struct scatterlist *sglist,
-		  int nelems, int dir)
+		  int nelems, enum dma_data_direction dir,
+		  struct dma_attrs *attrs)
 {
 	unsigned long flags;
 	struct amd_iommu *iommu;
@@ -1457,7 +1460,8 @@ unmap:
  * lists).
  */
 static void unmap_sg(struct device *dev, struct scatterlist *sglist,
-		     int nelems, int dir)
+		     int nelems, enum dma_data_direction dir,
+		     struct dma_attrs *attrs)
 {
 	unsigned long flags;
 	struct amd_iommu *iommu;
@@ -1644,11 +1648,11 @@ static void prealloc_protection_domains(void)
 	}
 }
 
-static struct dma_mapping_ops amd_iommu_dma_ops = {
+static struct dma_map_ops amd_iommu_dma_ops = {
 	.alloc_coherent = alloc_coherent,
 	.free_coherent = free_coherent,
-	.map_single = map_single,
-	.unmap_single = unmap_single,
+	.map_page = map_page,
+	.unmap_page = unmap_page,
 	.map_sg = map_sg,
 	.unmap_sg = unmap_sg,
 	.dma_supported = amd_iommu_dma_supported,
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index d28bbdc..755c21e 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -380,8 +380,9 @@ static inline struct iommu_table *find_iommu_table(struct device *dev)
 	return tbl;
 }
 
-static void calgary_unmap_sg(struct device *dev,
-	struct scatterlist *sglist, int nelems, int direction)
+static void calgary_unmap_sg(struct device *dev, struct scatterlist *sglist,
+			     int nelems,enum dma_data_direction dir,
+			     struct dma_attrs *attrs)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
 	struct scatterlist *s;
@@ -404,7 +405,8 @@ static void calgary_unmap_sg(struct device *dev,
 }
 
 static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
-	int nelems, int direction)
+			  int nelems, enum dma_data_direction dir,
+			  struct dma_attrs *attrs)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
 	struct scatterlist *s;
@@ -429,15 +431,14 @@ static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 		s->dma_address = (entry << PAGE_SHIFT) | s->offset;
 
 		/* insert into HW table */
-		tce_build(tbl, entry, npages, vaddr & PAGE_MASK,
-			  direction);
+		tce_build(tbl, entry, npages, vaddr & PAGE_MASK, dir);
 
 		s->dma_length = s->length;
 	}
 
 	return nelems;
 error:
-	calgary_unmap_sg(dev, sg, nelems, direction);
+	calgary_unmap_sg(dev, sg, nelems, dir, NULL);
 	for_each_sg(sg, s, nelems, i) {
 		sg->dma_address = bad_dma_address;
 		sg->dma_length = 0;
@@ -445,10 +446,12 @@ error:
 	return 0;
 }
 
-static dma_addr_t calgary_map_single(struct device *dev, phys_addr_t paddr,
-	size_t size, int direction)
+static dma_addr_t calgary_map_page(struct device *dev, struct page *page,
+				   unsigned long offset, size_t size,
+				   enum dma_data_direction dir,
+				   struct dma_attrs *attrs)
 {
-	void *vaddr = phys_to_virt(paddr);
+	void *vaddr = page_address(page) + offset;
 	unsigned long uaddr;
 	unsigned int npages;
 	struct iommu_table *tbl = find_iommu_table(dev);
@@ -456,17 +459,18 @@ static dma_addr_t calgary_map_single(struct device *dev, phys_addr_t paddr,
 	uaddr = (unsigned long)vaddr;
 	npages = iommu_num_pages(uaddr, size, PAGE_SIZE);
 
-	return iommu_alloc(dev, tbl, vaddr, npages, direction);
+	return iommu_alloc(dev, tbl, vaddr, npages, dir);
 }
 
-static void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
-	size_t size, int direction)
+static void calgary_unmap_page(struct device *dev, dma_addr_t dma_addr,
+			       size_t size, enum dma_data_direction dir,
+			       struct dma_attrs *attrs)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
 	unsigned int npages;
 
-	npages = iommu_num_pages(dma_handle, size, PAGE_SIZE);
-	iommu_free(tbl, dma_handle, npages);
+	npages = iommu_num_pages(dma_addr, size, PAGE_SIZE);
+	iommu_free(tbl, dma_addr, npages);
 }
 
 static void* calgary_alloc_coherent(struct device *dev, size_t size,
@@ -515,13 +519,13 @@ static void calgary_free_coherent(struct device *dev, size_t size,
 	free_pages((unsigned long)vaddr, get_order(size));
 }
 
-static struct dma_mapping_ops calgary_dma_ops = {
+static struct dma_map_ops calgary_dma_ops = {
 	.alloc_coherent = calgary_alloc_coherent,
 	.free_coherent = calgary_free_coherent,
-	.map_single = calgary_map_single,
-	.unmap_single = calgary_unmap_single,
 	.map_sg = calgary_map_sg,
 	.unmap_sg = calgary_unmap_sg,
+	.map_page = calgary_map_page,
+	.unmap_page = calgary_unmap_page,
 };
 
 static inline void __iomem * busno_to_bbar(unsigned char num)
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index b254285..c7c4776 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -1,4 +1,5 @@
 #include <linux/dma-mapping.h>
+#include <linux/dma-debug.h>
 #include <linux/dmar.h>
 #include <linux/bootmem.h>
 #include <linux/pci.h>
@@ -12,7 +13,7 @@
 
 static int forbid_dac __read_mostly;
 
-struct dma_mapping_ops *dma_ops;
+struct dma_map_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 static int iommu_sac_force __read_mostly;
@@ -44,6 +45,9 @@ struct device x86_dma_fallback_dev = {
 };
 EXPORT_SYMBOL(x86_dma_fallback_dev);
 
+/* Number of entries preallocated for DMA-API debugging */
+#define PREALLOC_DMA_DEBUG_ENTRIES       32768
+
 int dma_set_mask(struct device *dev, u64 mask)
 {
 	if (!dev->dma_mask || !dma_supported(dev, mask))
@@ -224,7 +228,7 @@ early_param("iommu", iommu_setup);
 
 int dma_supported(struct device *dev, u64 mask)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(dev);
+	struct dma_map_ops *ops = get_dma_ops(dev);
 
 #ifdef CONFIG_PCI
 	if (mask > 0xffffffff && forbid_dac > 0) {
@@ -265,6 +269,12 @@ EXPORT_SYMBOL(dma_supported);
 
 static int __init pci_iommu_init(void)
 {
+	dma_debug_init(PREALLOC_DMA_DEBUG_ENTRIES);
+
+#ifdef CONFIG_PCI
+	dma_debug_add_bus(&pci_bus_type);
+#endif
+
 	calgary_iommu_init();
 
 	intel_iommu_init();
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index d5768b1..b284b58 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -255,10 +255,13 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 }
 
 /* Map a single area into the IOMMU */
-static dma_addr_t
-gart_map_single(struct device *dev, phys_addr_t paddr, size_t size, int dir)
+static dma_addr_t gart_map_page(struct device *dev, struct page *page,
+				unsigned long offset, size_t size,
+				enum dma_data_direction dir,
+				struct dma_attrs *attrs)
 {
 	unsigned long bus;
+	phys_addr_t paddr = page_to_phys(page) + offset;
 
 	if (!dev)
 		dev = &x86_dma_fallback_dev;
@@ -275,8 +278,9 @@ gart_map_single(struct device *dev, phys_addr_t paddr, size_t size, int dir)
 /*
  * Free a DMA mapping.
  */
-static void gart_unmap_single(struct device *dev, dma_addr_t dma_addr,
-			      size_t size, int direction)
+static void gart_unmap_page(struct device *dev, dma_addr_t dma_addr,
+			    size_t size, enum dma_data_direction dir,
+			    struct dma_attrs *attrs)
 {
 	unsigned long iommu_page;
 	int npages;
@@ -298,8 +302,8 @@ static void gart_unmap_single(struct device *dev, dma_addr_t dma_addr,
 /*
  * Wrapper for pci_unmap_single working with scatterlists.
  */
-static void
-gart_unmap_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
+static void gart_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
+			  enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	struct scatterlist *s;
 	int i;
@@ -307,7 +311,7 @@ gart_unmap_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 	for_each_sg(sg, s, nents, i) {
 		if (!s->dma_length || !s->length)
 			break;
-		gart_unmap_single(dev, s->dma_address, s->dma_length, dir);
+		gart_unmap_page(dev, s->dma_address, s->dma_length, dir, NULL);
 	}
 }
 
@@ -329,7 +333,7 @@ static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
 			addr = dma_map_area(dev, addr, s->length, dir, 0);
 			if (addr == bad_dma_address) {
 				if (i > 0)
-					gart_unmap_sg(dev, sg, i, dir);
+					gart_unmap_sg(dev, sg, i, dir, NULL);
 				nents = 0;
 				sg[0].dma_length = 0;
 				break;
@@ -400,8 +404,8 @@ dma_map_cont(struct device *dev, struct scatterlist *start, int nelems,
  * DMA map all entries in a scatterlist.
  * Merge chunks that have page aligned sizes into a continuous mapping.
  */
-static int
-gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
+static int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+		       enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	struct scatterlist *s, *ps, *start_sg, *sgmap;
 	int need = 0, nextneed, i, out, start;
@@ -468,7 +472,7 @@ gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 
 error:
 	flush_gart();
-	gart_unmap_sg(dev, sg, out, dir);
+	gart_unmap_sg(dev, sg, out, dir, NULL);
 
 	/* When it was forced or merged try again in a dumb way */
 	if (force_iommu || iommu_merge) {
@@ -521,7 +525,7 @@ static void
 gart_free_coherent(struct device *dev, size_t size, void *vaddr,
 		   dma_addr_t dma_addr)
 {
-	gart_unmap_single(dev, dma_addr, size, DMA_BIDIRECTIONAL);
+	gart_unmap_page(dev, dma_addr, size, DMA_BIDIRECTIONAL, NULL);
 	free_pages((unsigned long)vaddr, get_order(size));
 }
 
@@ -707,11 +711,11 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 	return -1;
 }
 
-static struct dma_mapping_ops gart_dma_ops = {
-	.map_single			= gart_map_single,
-	.unmap_single			= gart_unmap_single,
+static struct dma_map_ops gart_dma_ops = {
 	.map_sg				= gart_map_sg,
 	.unmap_sg			= gart_unmap_sg,
+	.map_page			= gart_map_page,
+	.unmap_page			= gart_unmap_page,
 	.alloc_coherent			= gart_alloc_coherent,
 	.free_coherent			= gart_free_coherent,
 };
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index c70ab5a..fe50214 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -25,19 +25,19 @@ check_addr(char *name, struct device *hwdev, dma_addr_t bus, size_t size)
 	return 1;
 }
 
-static dma_addr_t
-nommu_map_single(struct device *hwdev, phys_addr_t paddr, size_t size,
-	       int direction)
+static dma_addr_t nommu_map_page(struct device *dev, struct page *page,
+				 unsigned long offset, size_t size,
+				 enum dma_data_direction dir,
+				 struct dma_attrs *attrs)
 {
-	dma_addr_t bus = paddr;
+	dma_addr_t bus = page_to_phys(page) + offset;
 	WARN_ON(size == 0);
-	if (!check_addr("map_single", hwdev, bus, size))
-				return bad_dma_address;
+	if (!check_addr("map_single", dev, bus, size))
+		return bad_dma_address;
 	flush_write_buffers();
 	return bus;
 }
 
-
 /* Map a set of buffers described by scatterlist in streaming
  * mode for DMA.  This is the scatter-gather version of the
  * above pci_map_single interface.  Here the scatter gather list
@@ -54,7 +54,8 @@ nommu_map_single(struct device *hwdev, phys_addr_t paddr, size_t size,
  * the same here.
  */
 static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
-	       int nents, int direction)
+			int nents, enum dma_data_direction dir,
+			struct dma_attrs *attrs)
 {
 	struct scatterlist *s;
 	int i;
@@ -78,11 +79,11 @@ static void nommu_free_coherent(struct device *dev, size_t size, void *vaddr,
 	free_pages((unsigned long)vaddr, get_order(size));
 }
 
-struct dma_mapping_ops nommu_dma_ops = {
+struct dma_map_ops nommu_dma_ops = {
 	.alloc_coherent = dma_generic_alloc_coherent,
 	.free_coherent = nommu_free_coherent,
-	.map_single = nommu_map_single,
 	.map_sg = nommu_map_sg,
+	.map_page = nommu_map_page,
 	.is_phys = 1,
 };
 
diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb.c
similarity index 81%
rename from arch/x86/kernel/pci-swiotlb_64.c
rename to arch/x86/kernel/pci-swiotlb.c
index d59c917..34f12e9 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -33,18 +33,11 @@ phys_addr_t swiotlb_bus_to_phys(dma_addr_t baddr)
 	return baddr;
 }
 
-int __weak swiotlb_arch_range_needs_mapping(void *ptr, size_t size)
+int __weak swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
 {
 	return 0;
 }
 
-static dma_addr_t
-swiotlb_map_single_phys(struct device *hwdev, phys_addr_t paddr, size_t size,
-			int direction)
-{
-	return swiotlb_map_single(hwdev, phys_to_virt(paddr), size, direction);
-}
-
 static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 					dma_addr_t *dma_handle, gfp_t flags)
 {
@@ -57,20 +50,20 @@ static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	return swiotlb_alloc_coherent(hwdev, size, dma_handle, flags);
 }
 
-struct dma_mapping_ops swiotlb_dma_ops = {
+struct dma_map_ops swiotlb_dma_ops = {
 	.mapping_error = swiotlb_dma_mapping_error,
 	.alloc_coherent = x86_swiotlb_alloc_coherent,
 	.free_coherent = swiotlb_free_coherent,
-	.map_single = swiotlb_map_single_phys,
-	.unmap_single = swiotlb_unmap_single,
 	.sync_single_for_cpu = swiotlb_sync_single_for_cpu,
 	.sync_single_for_device = swiotlb_sync_single_for_device,
 	.sync_single_range_for_cpu = swiotlb_sync_single_range_for_cpu,
 	.sync_single_range_for_device = swiotlb_sync_single_range_for_device,
 	.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
 	.sync_sg_for_device = swiotlb_sync_sg_for_device,
-	.map_sg = swiotlb_map_sg,
-	.unmap_sg = swiotlb_unmap_sg,
+	.map_sg = swiotlb_map_sg_attrs,
+	.unmap_sg = swiotlb_unmap_sg_attrs,
+	.map_page = swiotlb_map_page,
+	.unmap_page = swiotlb_unmap_page,
 	.dma_supported = NULL,
 };
 
diff --git a/drivers/base/iommu.c b/drivers/base/iommu.c
index 5e039d4..c2d1eed 100644
--- a/drivers/base/iommu.c
+++ b/drivers/base/iommu.c
@@ -31,7 +31,7 @@ void register_iommu(struct iommu_ops *ops)
 	iommu_ops = ops;
 }
 
-bool iommu_found()
+bool iommu_found(void)
 {
 	return iommu_ops != NULL;
 }
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index f3f6865..e7d058a 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2284,11 +2284,13 @@ error:
 	return 0;
 }
 
-dma_addr_t intel_map_single(struct device *hwdev, phys_addr_t paddr,
-			    size_t size, int dir)
+static dma_addr_t intel_map_page(struct device *dev, struct page *page,
+				 unsigned long offset, size_t size,
+				 enum dma_data_direction dir,
+				 struct dma_attrs *attrs)
 {
-	return __intel_map_single(hwdev, paddr, size, dir,
-				  to_pci_dev(hwdev)->dma_mask);
+	return __intel_map_single(dev, page_to_phys(page) + offset, size,
+				  dir, to_pci_dev(dev)->dma_mask);
 }
 
 static void flush_unmaps(void)
@@ -2352,8 +2354,9 @@ static void add_unmap(struct dmar_domain *dom, struct iova *iova)
 	spin_unlock_irqrestore(&async_umap_flush_lock, flags);
 }
 
-void intel_unmap_single(struct device *dev, dma_addr_t dev_addr, size_t size,
-			int dir)
+static void intel_unmap_page(struct device *dev, dma_addr_t dev_addr,
+			     size_t size, enum dma_data_direction dir,
+			     struct dma_attrs *attrs)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct dmar_domain *domain;
@@ -2397,8 +2400,14 @@ void intel_unmap_single(struct device *dev, dma_addr_t dev_addr, size_t size,
 	}
 }
 
-void *intel_alloc_coherent(struct device *hwdev, size_t size,
-			   dma_addr_t *dma_handle, gfp_t flags)
+static void intel_unmap_single(struct device *dev, dma_addr_t dev_addr, size_t size,
+			       int dir)
+{
+	intel_unmap_page(dev, dev_addr, size, dir, NULL);
+}
+
+static void *intel_alloc_coherent(struct device *hwdev, size_t size,
+				  dma_addr_t *dma_handle, gfp_t flags)
 {
 	void *vaddr;
 	int order;
@@ -2421,8 +2430,8 @@ void *intel_alloc_coherent(struct device *hwdev, size_t size,
 	return NULL;
 }
 
-void intel_free_coherent(struct device *hwdev, size_t size, void *vaddr,
-			 dma_addr_t dma_handle)
+static void intel_free_coherent(struct device *hwdev, size_t size, void *vaddr,
+				dma_addr_t dma_handle)
 {
 	int order;
 
@@ -2435,8 +2444,9 @@ void intel_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 
 #define SG_ENT_VIRT_ADDRESS(sg)	(sg_virt((sg)))
 
-void intel_unmap_sg(struct device *hwdev, struct scatterlist *sglist,
-		    int nelems, int dir)
+static void intel_unmap_sg(struct device *hwdev, struct scatterlist *sglist,
+			   int nelems, enum dma_data_direction dir,
+			   struct dma_attrs *attrs)
 {
 	int i;
 	struct pci_dev *pdev = to_pci_dev(hwdev);
@@ -2493,8 +2503,8 @@ static int intel_nontranslate_map_sg(struct device *hddev,
 	return nelems;
 }
 
-int intel_map_sg(struct device *hwdev, struct scatterlist *sglist, int nelems,
-		 int dir)
+static int intel_map_sg(struct device *hwdev, struct scatterlist *sglist, int nelems,
+			enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	void *addr;
 	int i;
@@ -2574,13 +2584,19 @@ int intel_map_sg(struct device *hwdev, struct scatterlist *sglist, int nelems,
 	return nelems;
 }
 
-static struct dma_mapping_ops intel_dma_ops = {
+static int intel_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	return !dma_addr;
+}
+
+struct dma_map_ops intel_dma_ops = {
 	.alloc_coherent = intel_alloc_coherent,
 	.free_coherent = intel_free_coherent,
-	.map_single = intel_map_single,
-	.unmap_single = intel_unmap_single,
 	.map_sg = intel_map_sg,
 	.unmap_sg = intel_unmap_sg,
+	.map_page = intel_map_page,
+	.unmap_page = intel_unmap_page,
+	.mapping_error = intel_mapping_error,
 };
 
 static inline int iommu_domain_cache_init(void)
diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
new file mode 100644
index 0000000..28d53cb
--- /dev/null
+++ b/include/linux/dma-debug.h
@@ -0,0 +1,174 @@
+/*
+ * Copyright (C) 2008 Advanced Micro Devices, Inc.
+ *
+ * Author: Joerg Roedel <joerg.roedel@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#ifndef __DMA_DEBUG_H
+#define __DMA_DEBUG_H
+
+#include <linux/types.h>
+
+struct device;
+struct scatterlist;
+struct bus_type;
+
+#ifdef CONFIG_DMA_API_DEBUG
+
+extern void dma_debug_add_bus(struct bus_type *bus);
+
+extern void dma_debug_init(u32 num_entries);
+
+extern void debug_dma_map_page(struct device *dev, struct page *page,
+			       size_t offset, size_t size,
+			       int direction, dma_addr_t dma_addr,
+			       bool map_single);
+
+extern void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
+				 size_t size, int direction, bool map_single);
+
+extern void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
+			     int nents, int mapped_ents, int direction);
+
+extern void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
+			       int nelems, int dir);
+
+extern void debug_dma_alloc_coherent(struct device *dev, size_t size,
+				     dma_addr_t dma_addr, void *virt);
+
+extern void debug_dma_free_coherent(struct device *dev, size_t size,
+				    void *virt, dma_addr_t addr);
+
+extern void debug_dma_sync_single_for_cpu(struct device *dev,
+					  dma_addr_t dma_handle, size_t size,
+					  int direction);
+
+extern void debug_dma_sync_single_for_device(struct device *dev,
+					     dma_addr_t dma_handle,
+					     size_t size, int direction);
+
+extern void debug_dma_sync_single_range_for_cpu(struct device *dev,
+						dma_addr_t dma_handle,
+						unsigned long offset,
+						size_t size,
+						int direction);
+
+extern void debug_dma_sync_single_range_for_device(struct device *dev,
+						   dma_addr_t dma_handle,
+						   unsigned long offset,
+						   size_t size, int direction);
+
+extern void debug_dma_sync_sg_for_cpu(struct device *dev,
+				      struct scatterlist *sg,
+				      int nelems, int direction);
+
+extern void debug_dma_sync_sg_for_device(struct device *dev,
+					 struct scatterlist *sg,
+					 int nelems, int direction);
+
+extern void debug_dma_dump_mappings(struct device *dev);
+
+#else /* CONFIG_DMA_API_DEBUG */
+
+static inline void dma_debug_add_bus(struct bus_type *bus)
+{
+}
+
+static inline void dma_debug_init(u32 num_entries)
+{
+}
+
+static inline void debug_dma_map_page(struct device *dev, struct page *page,
+				      size_t offset, size_t size,
+				      int direction, dma_addr_t dma_addr,
+				      bool map_single)
+{
+}
+
+static inline void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
+					size_t size, int direction,
+					bool map_single)
+{
+}
+
+static inline void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
+				    int nents, int mapped_ents, int direction)
+{
+}
+
+static inline void debug_dma_unmap_sg(struct device *dev,
+				      struct scatterlist *sglist,
+				      int nelems, int dir)
+{
+}
+
+static inline void debug_dma_alloc_coherent(struct device *dev, size_t size,
+					    dma_addr_t dma_addr, void *virt)
+{
+}
+
+static inline void debug_dma_free_coherent(struct device *dev, size_t size,
+					   void *virt, dma_addr_t addr)
+{
+}
+
+static inline void debug_dma_sync_single_for_cpu(struct device *dev,
+						 dma_addr_t dma_handle,
+						 size_t size, int direction)
+{
+}
+
+static inline void debug_dma_sync_single_for_device(struct device *dev,
+						    dma_addr_t dma_handle,
+						    size_t size, int direction)
+{
+}
+
+static inline void debug_dma_sync_single_range_for_cpu(struct device *dev,
+						       dma_addr_t dma_handle,
+						       unsigned long offset,
+						       size_t size,
+						       int direction)
+{
+}
+
+static inline void debug_dma_sync_single_range_for_device(struct device *dev,
+							  dma_addr_t dma_handle,
+							  unsigned long offset,
+							  size_t size,
+							  int direction)
+{
+}
+
+static inline void debug_dma_sync_sg_for_cpu(struct device *dev,
+					     struct scatterlist *sg,
+					     int nelems, int direction)
+{
+}
+
+static inline void debug_dma_sync_sg_for_device(struct device *dev,
+						struct scatterlist *sg,
+						int nelems, int direction)
+{
+}
+
+static inline void debug_dma_dump_mappings(struct device *dev)
+{
+}
+
+#endif /* CONFIG_DMA_API_DEBUG */
+
+#endif /* __DMA_DEBUG_H */
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index ba9114e..d7d090d 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -3,6 +3,8 @@
 
 #include <linux/device.h>
 #include <linux/err.h>
+#include <linux/dma-attrs.h>
+#include <linux/scatterlist.h>
 
 /* These definitions mirror those in pci.h, so they can be used
  * interchangeably with their PCI_ counterparts */
@@ -13,6 +15,52 @@ enum dma_data_direction {
 	DMA_NONE = 3,
 };
 
+struct dma_map_ops {
+	void* (*alloc_coherent)(struct device *dev, size_t size,
+				dma_addr_t *dma_handle, gfp_t gfp);
+	void (*free_coherent)(struct device *dev, size_t size,
+			      void *vaddr, dma_addr_t dma_handle);
+	dma_addr_t (*map_page)(struct device *dev, struct page *page,
+			       unsigned long offset, size_t size,
+			       enum dma_data_direction dir,
+			       struct dma_attrs *attrs);
+	void (*unmap_page)(struct device *dev, dma_addr_t dma_handle,
+			   size_t size, enum dma_data_direction dir,
+			   struct dma_attrs *attrs);
+	int (*map_sg)(struct device *dev, struct scatterlist *sg,
+		      int nents, enum dma_data_direction dir,
+		      struct dma_attrs *attrs);
+	void (*unmap_sg)(struct device *dev,
+			 struct scatterlist *sg, int nents,
+			 enum dma_data_direction dir,
+			 struct dma_attrs *attrs);
+	void (*sync_single_for_cpu)(struct device *dev,
+				    dma_addr_t dma_handle, size_t size,
+				    enum dma_data_direction dir);
+	void (*sync_single_for_device)(struct device *dev,
+				       dma_addr_t dma_handle, size_t size,
+				       enum dma_data_direction dir);
+	void (*sync_single_range_for_cpu)(struct device *dev,
+					  dma_addr_t dma_handle,
+					  unsigned long offset,
+					  size_t size,
+					  enum dma_data_direction dir);
+	void (*sync_single_range_for_device)(struct device *dev,
+					     dma_addr_t dma_handle,
+					     unsigned long offset,
+					     size_t size,
+					     enum dma_data_direction dir);
+	void (*sync_sg_for_cpu)(struct device *dev,
+				struct scatterlist *sg, int nents,
+				enum dma_data_direction dir);
+	void (*sync_sg_for_device)(struct device *dev,
+				   struct scatterlist *sg, int nents,
+				   enum dma_data_direction dir);
+	int (*mapping_error)(struct device *dev, dma_addr_t dma_addr);
+	int (*dma_supported)(struct device *dev, u64 mask);
+	int is_phys;
+};
+
 #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
 
 /*
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index d2e3cbf..4d6a0a2 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -331,11 +331,4 @@ extern int qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 
 extern int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 
-extern void *intel_alloc_coherent(struct device *, size_t, dma_addr_t *, gfp_t);
-extern void intel_free_coherent(struct device *, size_t, void *, dma_addr_t);
-extern dma_addr_t intel_map_single(struct device *, phys_addr_t, size_t, int);
-extern void intel_unmap_single(struct device *, dma_addr_t, size_t, int);
-extern int intel_map_sg(struct device *, struct scatterlist *, int, int);
-extern void intel_unmap_sg(struct device *, struct scatterlist *, int, int);
-
 #endif
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index dedd3c0..ac9ff54 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -31,7 +31,7 @@ extern dma_addr_t swiotlb_phys_to_bus(struct device *hwdev,
 				      phys_addr_t address);
 extern phys_addr_t swiotlb_bus_to_phys(dma_addr_t address);
 
-extern int swiotlb_arch_range_needs_mapping(void *ptr, size_t size);
+extern int swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size);
 
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
@@ -41,20 +41,13 @@ extern void
 swiotlb_free_coherent(struct device *hwdev, size_t size,
 		      void *vaddr, dma_addr_t dma_handle);
 
-extern dma_addr_t
-swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, int dir);
-
-extern void
-swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
-		     size_t size, int dir);
-
-extern dma_addr_t
-swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
-			 int dir, struct dma_attrs *attrs);
-
-extern void
-swiotlb_unmap_single_attrs(struct device *hwdev, dma_addr_t dev_addr,
-			   size_t size, int dir, struct dma_attrs *attrs);
+extern dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
+				   unsigned long offset, size_t size,
+				   enum dma_data_direction dir,
+				   struct dma_attrs *attrs);
+extern void swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
+			       size_t size, enum dma_data_direction dir,
+			       struct dma_attrs *attrs);
 
 extern int
 swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg, int nents,
@@ -66,36 +59,38 @@ swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
 
 extern int
 swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
-		     int dir, struct dma_attrs *attrs);
+		     enum dma_data_direction dir, struct dma_attrs *attrs);
 
 extern void
 swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
-		       int nelems, int dir, struct dma_attrs *attrs);
+		       int nelems, enum dma_data_direction dir,
+		       struct dma_attrs *attrs);
 
 extern void
 swiotlb_sync_single_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
-			    size_t size, int dir);
+			    size_t size, enum dma_data_direction dir);
 
 extern void
 swiotlb_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
-			int nelems, int dir);
+			int nelems, enum dma_data_direction dir);
 
 extern void
 swiotlb_sync_single_for_device(struct device *hwdev, dma_addr_t dev_addr,
-			       size_t size, int dir);
+			       size_t size, enum dma_data_direction dir);
 
 extern void
 swiotlb_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
-			   int nelems, int dir);
+			   int nelems, enum dma_data_direction dir);
 
 extern void
 swiotlb_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
-				  unsigned long offset, size_t size, int dir);
+				  unsigned long offset, size_t size,
+				  enum dma_data_direction dir);
 
 extern void
 swiotlb_sync_single_range_for_device(struct device *hwdev, dma_addr_t dev_addr,
 				     unsigned long offset, size_t size,
-				     int dir);
+				     enum dma_data_direction dir);
 
 extern int
 swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8fee0a1..251fa7b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -912,6 +912,17 @@ config DYNAMIC_DEBUG
 
 	  See Documentation/dynamic-debug-howto.txt for additional information.
 
+config DMA_API_DEBUG
+	bool "Enable debugging of DMA-API usage"
+	depends on HAVE_DMA_API_DEBUG
+	help
+	  Enable this option to debug the use of the DMA API by device drivers.
+	  With this option you will be able to detect common bugs in device
+	  drivers like double-freeing of DMA mappings or freeing mappings that
+	  were never allocated.
+	  This option causes a performance degredation.  Use only if you want
+	  to debug device drivers. If unsure, say N.
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
diff --git a/lib/Makefile b/lib/Makefile
index 051a33a..d6edd67 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -90,6 +90,8 @@ obj-$(CONFIG_DYNAMIC_DEBUG) += dynamic_debug.o
 
 obj-$(CONFIG_NLATTR) += nlattr.o
 
+obj-$(CONFIG_DMA_API_DEBUG) += dma-debug.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
new file mode 100644
index 0000000..1a99208
--- /dev/null
+++ b/lib/dma-debug.c
@@ -0,0 +1,955 @@
+/*
+ * Copyright (C) 2008 Advanced Micro Devices, Inc.
+ *
+ * Author: Joerg Roedel <joerg.roedel@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
+#include <linux/stacktrace.h>
+#include <linux/dma-debug.h>
+#include <linux/spinlock.h>
+#include <linux/debugfs.h>
+#include <linux/device.h>
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+
+#include <asm/sections.h>
+
+#define HASH_SIZE       1024ULL
+#define HASH_FN_SHIFT   13
+#define HASH_FN_MASK    (HASH_SIZE - 1)
+
+enum {
+	dma_debug_single,
+	dma_debug_page,
+	dma_debug_sg,
+	dma_debug_coherent,
+};
+
+#define DMA_DEBUG_STACKTRACE_ENTRIES 5
+
+struct dma_debug_entry {
+	struct list_head list;
+	struct device    *dev;
+	int              type;
+	phys_addr_t      paddr;
+	u64              dev_addr;
+	u64              size;
+	int              direction;
+	int		 sg_call_ents;
+	int		 sg_mapped_ents;
+#ifdef CONFIG_STACKTRACE
+	struct		 stack_trace stacktrace;
+	unsigned long	 st_entries[DMA_DEBUG_STACKTRACE_ENTRIES];
+#endif
+};
+
+struct hash_bucket {
+	struct list_head list;
+	spinlock_t lock;
+} ____cacheline_aligned_in_smp;
+
+/* Hash list to save the allocated dma addresses */
+static struct hash_bucket dma_entry_hash[HASH_SIZE];
+/* List of pre-allocated dma_debug_entry's */
+static LIST_HEAD(free_entries);
+/* Lock for the list above */
+static DEFINE_SPINLOCK(free_entries_lock);
+
+/* Global disable flag - will be set in case of an error */
+static bool global_disable __read_mostly;
+
+/* Global error count */
+static u32 error_count;
+
+/* Global error show enable*/
+static u32 show_all_errors __read_mostly;
+/* Number of errors to show */
+static u32 show_num_errors = 1;
+
+static u32 num_free_entries;
+static u32 min_free_entries;
+
+/* number of preallocated entries requested by kernel cmdline */
+static u32 req_entries;
+
+/* debugfs dentry's for the stuff above */
+static struct dentry *dma_debug_dent        __read_mostly;
+static struct dentry *global_disable_dent   __read_mostly;
+static struct dentry *error_count_dent      __read_mostly;
+static struct dentry *show_all_errors_dent  __read_mostly;
+static struct dentry *show_num_errors_dent  __read_mostly;
+static struct dentry *num_free_entries_dent __read_mostly;
+static struct dentry *min_free_entries_dent __read_mostly;
+
+static const char *type2name[4] = { "single", "page",
+				    "scather-gather", "coherent" };
+
+static const char *dir2name[4] = { "DMA_BIDIRECTIONAL", "DMA_TO_DEVICE",
+				   "DMA_FROM_DEVICE", "DMA_NONE" };
+
+/*
+ * The access to some variables in this macro is racy. We can't use atomic_t
+ * here because all these variables are exported to debugfs. Some of them even
+ * writeable. This is also the reason why a lock won't help much. But anyway,
+ * the races are no big deal. Here is why:
+ *
+ *   error_count: the addition is racy, but the worst thing that can happen is
+ *                that we don't count some errors
+ *   show_num_errors: the subtraction is racy. Also no big deal because in
+ *                    worst case this will result in one warning more in the
+ *                    system log than the user configured. This variable is
+ *                    writeable via debugfs.
+ */
+static inline void dump_entry_trace(struct dma_debug_entry *entry)
+{
+#ifdef CONFIG_STACKTRACE
+	if (entry) {
+		printk(KERN_WARNING "Mapped at:\n");
+		print_stack_trace(&entry->stacktrace, 0);
+	}
+#endif
+}
+
+#define err_printk(dev, entry, format, arg...) do {		\
+		error_count += 1;				\
+		if (show_all_errors || show_num_errors > 0) {	\
+			WARN(1, "%s %s: " format,		\
+			     dev_driver_string(dev),		\
+			     dev_name(dev) , ## arg);		\
+			dump_entry_trace(entry);		\
+		}						\
+		if (!show_all_errors && show_num_errors > 0)	\
+			show_num_errors -= 1;			\
+	} while (0);
+
+/*
+ * Hash related functions
+ *
+ * Every DMA-API request is saved into a struct dma_debug_entry. To
+ * have quick access to these structs they are stored into a hash.
+ */
+static int hash_fn(struct dma_debug_entry *entry)
+{
+	/*
+	 * Hash function is based on the dma address.
+	 * We use bits 20-27 here as the index into the hash
+	 */
+	return (entry->dev_addr >> HASH_FN_SHIFT) & HASH_FN_MASK;
+}
+
+/*
+ * Request exclusive access to a hash bucket for a given dma_debug_entry.
+ */
+static struct hash_bucket *get_hash_bucket(struct dma_debug_entry *entry,
+					   unsigned long *flags)
+{
+	int idx = hash_fn(entry);
+	unsigned long __flags;
+
+	spin_lock_irqsave(&dma_entry_hash[idx].lock, __flags);
+	*flags = __flags;
+	return &dma_entry_hash[idx];
+}
+
+/*
+ * Give up exclusive access to the hash bucket
+ */
+static void put_hash_bucket(struct hash_bucket *bucket,
+			    unsigned long *flags)
+{
+	unsigned long __flags = *flags;
+
+	spin_unlock_irqrestore(&bucket->lock, __flags);
+}
+
+/*
+ * Search a given entry in the hash bucket list
+ */
+static struct dma_debug_entry *hash_bucket_find(struct hash_bucket *bucket,
+						struct dma_debug_entry *ref)
+{
+	struct dma_debug_entry *entry;
+
+	list_for_each_entry(entry, &bucket->list, list) {
+		if ((entry->dev_addr == ref->dev_addr) &&
+		    (entry->dev == ref->dev))
+			return entry;
+	}
+
+	return NULL;
+}
+
+/*
+ * Add an entry to a hash bucket
+ */
+static void hash_bucket_add(struct hash_bucket *bucket,
+			    struct dma_debug_entry *entry)
+{
+	list_add_tail(&entry->list, &bucket->list);
+}
+
+/*
+ * Remove entry from a hash bucket list
+ */
+static void hash_bucket_del(struct dma_debug_entry *entry)
+{
+	list_del(&entry->list);
+}
+
+/*
+ * Dump mapping entries for debugging purposes
+ */
+void debug_dma_dump_mappings(struct device *dev)
+{
+	int idx;
+
+	for (idx = 0; idx < HASH_SIZE; idx++) {
+		struct hash_bucket *bucket = &dma_entry_hash[idx];
+		struct dma_debug_entry *entry;
+		unsigned long flags;
+
+		spin_lock_irqsave(&bucket->lock, flags);
+
+		list_for_each_entry(entry, &bucket->list, list) {
+			if (!dev || dev == entry->dev) {
+				dev_info(entry->dev,
+					 "%s idx %d P=%Lx D=%Lx L=%Lx %s\n",
+					 type2name[entry->type], idx,
+					 (unsigned long long)entry->paddr,
+					 entry->dev_addr, entry->size,
+					 dir2name[entry->direction]);
+			}
+		}
+
+		spin_unlock_irqrestore(&bucket->lock, flags);
+	}
+}
+EXPORT_SYMBOL(debug_dma_dump_mappings);
+
+/*
+ * Wrapper function for adding an entry to the hash.
+ * This function takes care of locking itself.
+ */
+static void add_dma_entry(struct dma_debug_entry *entry)
+{
+	struct hash_bucket *bucket;
+	unsigned long flags;
+
+	bucket = get_hash_bucket(entry, &flags);
+	hash_bucket_add(bucket, entry);
+	put_hash_bucket(bucket, &flags);
+}
+
+/* struct dma_entry allocator
+ *
+ * The next two functions implement the allocator for
+ * struct dma_debug_entries.
+ */
+static struct dma_debug_entry *dma_entry_alloc(void)
+{
+	struct dma_debug_entry *entry = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&free_entries_lock, flags);
+
+	if (list_empty(&free_entries)) {
+		printk(KERN_ERR "DMA-API: debugging out of memory "
+				"- disabling\n");
+		global_disable = true;
+		goto out;
+	}
+
+	entry = list_entry(free_entries.next, struct dma_debug_entry, list);
+	list_del(&entry->list);
+	memset(entry, 0, sizeof(*entry));
+
+#ifdef CONFIG_STACKTRACE
+	entry->stacktrace.max_entries = DMA_DEBUG_STACKTRACE_ENTRIES;
+	entry->stacktrace.entries = entry->st_entries;
+	entry->stacktrace.skip = 2;
+	save_stack_trace(&entry->stacktrace);
+#endif
+	num_free_entries -= 1;
+	if (num_free_entries < min_free_entries)
+		min_free_entries = num_free_entries;
+
+out:
+	spin_unlock_irqrestore(&free_entries_lock, flags);
+
+	return entry;
+}
+
+static void dma_entry_free(struct dma_debug_entry *entry)
+{
+	unsigned long flags;
+
+	/*
+	 * add to beginning of the list - this way the entries are
+	 * more likely cache hot when they are reallocated.
+	 */
+	spin_lock_irqsave(&free_entries_lock, flags);
+	list_add(&entry->list, &free_entries);
+	num_free_entries += 1;
+	spin_unlock_irqrestore(&free_entries_lock, flags);
+}
+
+/*
+ * DMA-API debugging init code
+ *
+ * The init code does two things:
+ *   1. Initialize core data structures
+ *   2. Preallocate a given number of dma_debug_entry structs
+ */
+
+static int prealloc_memory(u32 num_entries)
+{
+	struct dma_debug_entry *entry, *next_entry;
+	int i;
+
+	for (i = 0; i < num_entries; ++i) {
+		entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+		if (!entry)
+			goto out_err;
+
+		list_add_tail(&entry->list, &free_entries);
+	}
+
+	num_free_entries = num_entries;
+	min_free_entries = num_entries;
+
+	printk(KERN_INFO "DMA-API: preallocated %d debug entries\n",
+			num_entries);
+
+	return 0;
+
+out_err:
+
+	list_for_each_entry_safe(entry, next_entry, &free_entries, list) {
+		list_del(&entry->list);
+		kfree(entry);
+	}
+
+	return -ENOMEM;
+}
+
+static int dma_debug_fs_init(void)
+{
+	dma_debug_dent = debugfs_create_dir("dma-api", NULL);
+	if (!dma_debug_dent) {
+		printk(KERN_ERR "DMA-API: can not create debugfs directory\n");
+		return -ENOMEM;
+	}
+
+	global_disable_dent = debugfs_create_bool("disabled", 0444,
+			dma_debug_dent,
+			(u32 *)&global_disable);
+	if (!global_disable_dent)
+		goto out_err;
+
+	error_count_dent = debugfs_create_u32("error_count", 0444,
+			dma_debug_dent, &error_count);
+	if (!error_count_dent)
+		goto out_err;
+
+	show_all_errors_dent = debugfs_create_u32("all_errors", 0644,
+			dma_debug_dent,
+			&show_all_errors);
+	if (!show_all_errors_dent)
+		goto out_err;
+
+	show_num_errors_dent = debugfs_create_u32("num_errors", 0644,
+			dma_debug_dent,
+			&show_num_errors);
+	if (!show_num_errors_dent)
+		goto out_err;
+
+	num_free_entries_dent = debugfs_create_u32("num_free_entries", 0444,
+			dma_debug_dent,
+			&num_free_entries);
+	if (!num_free_entries_dent)
+		goto out_err;
+
+	min_free_entries_dent = debugfs_create_u32("min_free_entries", 0444,
+			dma_debug_dent,
+			&min_free_entries);
+	if (!min_free_entries_dent)
+		goto out_err;
+
+	return 0;
+
+out_err:
+	debugfs_remove_recursive(dma_debug_dent);
+
+	return -ENOMEM;
+}
+
+static int device_dma_allocations(struct device *dev)
+{
+	struct dma_debug_entry *entry;
+	unsigned long flags;
+	int count = 0, i;
+
+	for (i = 0; i < HASH_SIZE; ++i) {
+		spin_lock_irqsave(&dma_entry_hash[i].lock, flags);
+		list_for_each_entry(entry, &dma_entry_hash[i].list, list) {
+			if (entry->dev == dev)
+				count += 1;
+		}
+		spin_unlock_irqrestore(&dma_entry_hash[i].lock, flags);
+	}
+
+	return count;
+}
+
+static int dma_debug_device_change(struct notifier_block *nb,
+				    unsigned long action, void *data)
+{
+	struct device *dev = data;
+	int count;
+
+
+	switch (action) {
+	case BUS_NOTIFY_UNBIND_DRIVER:
+		count = device_dma_allocations(dev);
+		if (count == 0)
+			break;
+		err_printk(dev, NULL, "DMA-API: device driver has pending "
+				"DMA allocations while released from device "
+				"[count=%d]\n", count);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+void dma_debug_add_bus(struct bus_type *bus)
+{
+	struct notifier_block *nb;
+
+	nb = kzalloc(sizeof(struct notifier_block), GFP_KERNEL);
+	if (nb == NULL) {
+		printk(KERN_ERR "dma_debug_add_bus: out of memory\n");
+		return;
+	}
+
+	nb->notifier_call = dma_debug_device_change;
+
+	bus_register_notifier(bus, nb);
+}
+
+/*
+ * Let the architectures decide how many entries should be preallocated.
+ */
+void dma_debug_init(u32 num_entries)
+{
+	int i;
+
+	if (global_disable)
+		return;
+
+	for (i = 0; i < HASH_SIZE; ++i) {
+		INIT_LIST_HEAD(&dma_entry_hash[i].list);
+		dma_entry_hash[i].lock = SPIN_LOCK_UNLOCKED;
+	}
+
+	if (dma_debug_fs_init() != 0) {
+		printk(KERN_ERR "DMA-API: error creating debugfs entries "
+				"- disabling\n");
+		global_disable = true;
+
+		return;
+	}
+
+	if (req_entries)
+		num_entries = req_entries;
+
+	if (prealloc_memory(num_entries) != 0) {
+		printk(KERN_ERR "DMA-API: debugging out of memory error "
+				"- disabled\n");
+		global_disable = true;
+
+		return;
+	}
+
+	printk(KERN_INFO "DMA-API: debugging enabled by kernel config\n");
+}
+
+static __init int dma_debug_cmdline(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	if (strncmp(str, "off", 3) == 0) {
+		printk(KERN_INFO "DMA-API: debugging disabled on kernel "
+				 "command line\n");
+		global_disable = true;
+	}
+
+	return 0;
+}
+
+static __init int dma_debug_entries_cmdline(char *str)
+{
+	int res;
+
+	if (!str)
+		return -EINVAL;
+
+	res = get_option(&str, &req_entries);
+
+	if (!res)
+		req_entries = 0;
+
+	return 0;
+}
+
+__setup("dma_debug=", dma_debug_cmdline);
+__setup("dma_debug_entries=", dma_debug_entries_cmdline);
+
+static void check_unmap(struct dma_debug_entry *ref)
+{
+	struct dma_debug_entry *entry;
+	struct hash_bucket *bucket;
+	unsigned long flags;
+
+	if (dma_mapping_error(ref->dev, ref->dev_addr)) {
+		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
+			   "to free an invalid DMA memory address\n");
+		return;
+	}
+
+	bucket = get_hash_bucket(ref, &flags);
+	entry = hash_bucket_find(bucket, ref);
+
+	if (!entry) {
+		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
+			   "to free DMA memory it has not allocated "
+			   "[device address=0x%016llx] [size=%llu bytes]\n",
+			   ref->dev_addr, ref->size);
+		goto out;
+	}
+
+	if (ref->size != entry->size) {
+		err_printk(ref->dev, entry, "DMA-API: device driver frees "
+			   "DMA memory with different size "
+			   "[device address=0x%016llx] [map size=%llu bytes] "
+			   "[unmap size=%llu bytes]\n",
+			   ref->dev_addr, entry->size, ref->size);
+	}
+
+	if (ref->type != entry->type) {
+		err_printk(ref->dev, entry, "DMA-API: device driver frees "
+			   "DMA memory with wrong function "
+			   "[device address=0x%016llx] [size=%llu bytes] "
+			   "[mapped as %s] [unmapped as %s]\n",
+			   ref->dev_addr, ref->size,
+			   type2name[entry->type], type2name[ref->type]);
+	} else if ((entry->type == dma_debug_coherent) &&
+		   (ref->paddr != entry->paddr)) {
+		err_printk(ref->dev, entry, "DMA-API: device driver frees "
+			   "DMA memory with different CPU address "
+			   "[device address=0x%016llx] [size=%llu bytes] "
+			   "[cpu alloc address=%p] [cpu free address=%p]",
+			   ref->dev_addr, ref->size,
+			   (void *)entry->paddr, (void *)ref->paddr);
+	}
+
+	if (ref->sg_call_ents && ref->type == dma_debug_sg &&
+	    ref->sg_call_ents != entry->sg_call_ents) {
+		err_printk(ref->dev, entry, "DMA-API: device driver frees "
+			   "DMA sg list with different entry count "
+			   "[map count=%d] [unmap count=%d]\n",
+			   entry->sg_call_ents, ref->sg_call_ents);
+	}
+
+	/*
+	 * This may be no bug in reality - but most implementations of the
+	 * DMA API don't handle this properly, so check for it here
+	 */
+	if (ref->direction != entry->direction) {
+		err_printk(ref->dev, entry, "DMA-API: device driver frees "
+			   "DMA memory with different direction "
+			   "[device address=0x%016llx] [size=%llu bytes] "
+			   "[mapped with %s] [unmapped with %s]\n",
+			   ref->dev_addr, ref->size,
+			   dir2name[entry->direction],
+			   dir2name[ref->direction]);
+	}
+
+	hash_bucket_del(entry);
+	dma_entry_free(entry);
+
+out:
+	put_hash_bucket(bucket, &flags);
+}
+
+static void check_for_stack(struct device *dev, void *addr)
+{
+	if (object_is_on_stack(addr))
+		err_printk(dev, NULL, "DMA-API: device driver maps memory from"
+				"stack [addr=%p]\n", addr);
+}
+
+static inline bool overlap(void *addr, u64 size, void *start, void *end)
+{
+	void *addr2 = (char *)addr + size;
+
+	return ((addr >= start && addr < end) ||
+		(addr2 >= start && addr2 < end) ||
+		((addr < start) && (addr2 >= end)));
+}
+
+static void check_for_illegal_area(struct device *dev, void *addr, u64 size)
+{
+	if (overlap(addr, size, _text, _etext) ||
+	    overlap(addr, size, __start_rodata, __end_rodata))
+		err_printk(dev, NULL, "DMA-API: device driver maps "
+				"memory from kernel text or rodata "
+				"[addr=%p] [size=%llu]\n", addr, size);
+}
+
+static void check_sync(struct device *dev, dma_addr_t addr,
+		       u64 size, u64 offset, int direction, bool to_cpu)
+{
+	struct dma_debug_entry ref = {
+		.dev            = dev,
+		.dev_addr       = addr,
+		.size           = size,
+		.direction      = direction,
+	};
+	struct dma_debug_entry *entry;
+	struct hash_bucket *bucket;
+	unsigned long flags;
+
+	bucket = get_hash_bucket(&ref, &flags);
+
+	entry = hash_bucket_find(bucket, &ref);
+
+	if (!entry) {
+		err_printk(dev, NULL, "DMA-API: device driver tries "
+				"to sync DMA memory it has not allocated "
+				"[device address=0x%016llx] [size=%llu bytes]\n",
+				addr, size);
+		goto out;
+	}
+
+	if ((offset + size) > entry->size) {
+		err_printk(dev, entry, "DMA-API: device driver syncs"
+				" DMA memory outside allocated range "
+				"[device address=0x%016llx] "
+				"[allocation size=%llu bytes] [sync offset=%llu] "
+				"[sync size=%llu]\n", entry->dev_addr, entry->size,
+				offset, size);
+	}
+
+	if (direction != entry->direction) {
+		err_printk(dev, entry, "DMA-API: device driver syncs "
+				"DMA memory with different direction "
+				"[device address=0x%016llx] [size=%llu bytes] "
+				"[mapped with %s] [synced with %s]\n",
+				addr, entry->size,
+				dir2name[entry->direction],
+				dir2name[direction]);
+	}
+
+	if (entry->direction == DMA_BIDIRECTIONAL)
+		goto out;
+
+	if (to_cpu && !(entry->direction == DMA_FROM_DEVICE) &&
+		      !(direction == DMA_TO_DEVICE))
+		err_printk(dev, entry, "DMA-API: device driver syncs "
+				"device read-only DMA memory for cpu "
+				"[device address=0x%016llx] [size=%llu bytes] "
+				"[mapped with %s] [synced with %s]\n",
+				addr, entry->size,
+				dir2name[entry->direction],
+				dir2name[direction]);
+
+	if (!to_cpu && !(entry->direction == DMA_TO_DEVICE) &&
+		       !(direction == DMA_FROM_DEVICE))
+		err_printk(dev, entry, "DMA-API: device driver syncs "
+				"device write-only DMA memory to device "
+				"[device address=0x%016llx] [size=%llu bytes] "
+				"[mapped with %s] [synced with %s]\n",
+				addr, entry->size,
+				dir2name[entry->direction],
+				dir2name[direction]);
+
+out:
+	put_hash_bucket(bucket, &flags);
+
+}
+
+void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
+			size_t size, int direction, dma_addr_t dma_addr,
+			bool map_single)
+{
+	struct dma_debug_entry *entry;
+
+	if (unlikely(global_disable))
+		return;
+
+	if (unlikely(dma_mapping_error(dev, dma_addr)))
+		return;
+
+	entry = dma_entry_alloc();
+	if (!entry)
+		return;
+
+	entry->dev       = dev;
+	entry->type      = dma_debug_page;
+	entry->paddr     = page_to_phys(page) + offset;
+	entry->dev_addr  = dma_addr;
+	entry->size      = size;
+	entry->direction = direction;
+
+	if (map_single)
+		entry->type = dma_debug_single;
+
+	if (!PageHighMem(page)) {
+		void *addr = ((char *)page_address(page)) + offset;
+		check_for_stack(dev, addr);
+		check_for_illegal_area(dev, addr, size);
+	}
+
+	add_dma_entry(entry);
+}
+EXPORT_SYMBOL(debug_dma_map_page);
+
+void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
+			  size_t size, int direction, bool map_single)
+{
+	struct dma_debug_entry ref = {
+		.type           = dma_debug_page,
+		.dev            = dev,
+		.dev_addr       = addr,
+		.size           = size,
+		.direction      = direction,
+	};
+
+	if (unlikely(global_disable))
+		return;
+
+	if (map_single)
+		ref.type = dma_debug_single;
+
+	check_unmap(&ref);
+}
+EXPORT_SYMBOL(debug_dma_unmap_page);
+
+void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
+		      int nents, int mapped_ents, int direction)
+{
+	struct dma_debug_entry *entry;
+	struct scatterlist *s;
+	int i;
+
+	if (unlikely(global_disable))
+		return;
+
+	for_each_sg(sg, s, mapped_ents, i) {
+		entry = dma_entry_alloc();
+		if (!entry)
+			return;
+
+		entry->type           = dma_debug_sg;
+		entry->dev            = dev;
+		entry->paddr          = sg_phys(s);
+		entry->size           = s->length;
+		entry->dev_addr       = s->dma_address;
+		entry->direction      = direction;
+		entry->sg_call_ents   = nents;
+		entry->sg_mapped_ents = mapped_ents;
+
+		if (!PageHighMem(sg_page(s))) {
+			check_for_stack(dev, sg_virt(s));
+			check_for_illegal_area(dev, sg_virt(s), s->length);
+		}
+
+		add_dma_entry(entry);
+	}
+}
+EXPORT_SYMBOL(debug_dma_map_sg);
+
+void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
+			int nelems, int dir)
+{
+	struct dma_debug_entry *entry;
+	struct scatterlist *s;
+	int mapped_ents = 0, i;
+	unsigned long flags;
+
+	if (unlikely(global_disable))
+		return;
+
+	for_each_sg(sglist, s, nelems, i) {
+
+		struct dma_debug_entry ref = {
+			.type           = dma_debug_sg,
+			.dev            = dev,
+			.paddr          = sg_phys(s),
+			.dev_addr       = s->dma_address,
+			.size           = s->length,
+			.direction      = dir,
+			.sg_call_ents   = 0,
+		};
+
+		if (mapped_ents && i >= mapped_ents)
+			break;
+
+		if (mapped_ents == 0) {
+			struct hash_bucket *bucket;
+			ref.sg_call_ents = nelems;
+			bucket = get_hash_bucket(&ref, &flags);
+			entry = hash_bucket_find(bucket, &ref);
+			if (entry)
+				mapped_ents = entry->sg_mapped_ents;
+			put_hash_bucket(bucket, &flags);
+		}
+
+		check_unmap(&ref);
+	}
+}
+EXPORT_SYMBOL(debug_dma_unmap_sg);
+
+void debug_dma_alloc_coherent(struct device *dev, size_t size,
+			      dma_addr_t dma_addr, void *virt)
+{
+	struct dma_debug_entry *entry;
+
+	if (unlikely(global_disable))
+		return;
+
+	if (unlikely(virt == NULL))
+		return;
+
+	entry = dma_entry_alloc();
+	if (!entry)
+		return;
+
+	entry->type      = dma_debug_coherent;
+	entry->dev       = dev;
+	entry->paddr     = virt_to_phys(virt);
+	entry->size      = size;
+	entry->dev_addr  = dma_addr;
+	entry->direction = DMA_BIDIRECTIONAL;
+
+	add_dma_entry(entry);
+}
+EXPORT_SYMBOL(debug_dma_alloc_coherent);
+
+void debug_dma_free_coherent(struct device *dev, size_t size,
+			 void *virt, dma_addr_t addr)
+{
+	struct dma_debug_entry ref = {
+		.type           = dma_debug_coherent,
+		.dev            = dev,
+		.paddr          = virt_to_phys(virt),
+		.dev_addr       = addr,
+		.size           = size,
+		.direction      = DMA_BIDIRECTIONAL,
+	};
+
+	if (unlikely(global_disable))
+		return;
+
+	check_unmap(&ref);
+}
+EXPORT_SYMBOL(debug_dma_free_coherent);
+
+void debug_dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
+				   size_t size, int direction)
+{
+	if (unlikely(global_disable))
+		return;
+
+	check_sync(dev, dma_handle, size, 0, direction, true);
+}
+EXPORT_SYMBOL(debug_dma_sync_single_for_cpu);
+
+void debug_dma_sync_single_for_device(struct device *dev,
+				      dma_addr_t dma_handle, size_t size,
+				      int direction)
+{
+	if (unlikely(global_disable))
+		return;
+
+	check_sync(dev, dma_handle, size, 0, direction, false);
+}
+EXPORT_SYMBOL(debug_dma_sync_single_for_device);
+
+void debug_dma_sync_single_range_for_cpu(struct device *dev,
+					 dma_addr_t dma_handle,
+					 unsigned long offset, size_t size,
+					 int direction)
+{
+	if (unlikely(global_disable))
+		return;
+
+	check_sync(dev, dma_handle, size, offset, direction, true);
+}
+EXPORT_SYMBOL(debug_dma_sync_single_range_for_cpu);
+
+void debug_dma_sync_single_range_for_device(struct device *dev,
+					    dma_addr_t dma_handle,
+					    unsigned long offset,
+					    size_t size, int direction)
+{
+	if (unlikely(global_disable))
+		return;
+
+	check_sync(dev, dma_handle, size, offset, direction, false);
+}
+EXPORT_SYMBOL(debug_dma_sync_single_range_for_device);
+
+void debug_dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
+			       int nelems, int direction)
+{
+	struct scatterlist *s;
+	int i;
+
+	if (unlikely(global_disable))
+		return;
+
+	for_each_sg(sg, s, nelems, i) {
+		check_sync(dev, s->dma_address, s->dma_length, 0,
+				direction, true);
+	}
+}
+EXPORT_SYMBOL(debug_dma_sync_sg_for_cpu);
+
+void debug_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
+				  int nelems, int direction)
+{
+	struct scatterlist *s;
+	int i;
+
+	if (unlikely(global_disable))
+		return;
+
+	for_each_sg(sg, s, nelems, i) {
+		check_sync(dev, s->dma_address, s->dma_length, 0,
+				direction, false);
+	}
+}
+EXPORT_SYMBOL(debug_dma_sync_sg_for_device);
+
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 1f991ac..32e2bd3 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -145,7 +145,7 @@ static void *swiotlb_bus_to_virt(dma_addr_t address)
 	return phys_to_virt(swiotlb_bus_to_phys(address));
 }
 
-int __weak swiotlb_arch_range_needs_mapping(void *ptr, size_t size)
+int __weak swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
 {
 	return 0;
 }
@@ -315,9 +315,9 @@ address_needs_mapping(struct device *hwdev, dma_addr_t addr, size_t size)
 	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
 }
 
-static inline int range_needs_mapping(void *ptr, size_t size)
+static inline int range_needs_mapping(phys_addr_t paddr, size_t size)
 {
-	return swiotlb_force || swiotlb_arch_range_needs_mapping(ptr, size);
+	return swiotlb_force || swiotlb_arch_range_needs_mapping(paddr, size);
 }
 
 static int is_swiotlb_buffer(char *addr)
@@ -636,11 +636,14 @@ swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
  * Once the device is given the dma address, the device owns this memory until
  * either swiotlb_unmap_single or swiotlb_dma_sync_single is performed.
  */
-dma_addr_t
-swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
-			 int dir, struct dma_attrs *attrs)
-{
-	dma_addr_t dev_addr = swiotlb_virt_to_bus(hwdev, ptr);
+dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
+			    unsigned long offset, size_t size,
+			    enum dma_data_direction dir,
+			    struct dma_attrs *attrs)
+{
+	phys_addr_t phys = page_to_phys(page) + offset;
+	void *ptr = page_address(page) + offset;
+	dma_addr_t dev_addr = swiotlb_phys_to_bus(dev, phys);
 	void *map;
 
 	BUG_ON(dir == DMA_NONE);
@@ -649,37 +652,30 @@ swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
 	 * we can safely return the device addr and not worry about bounce
 	 * buffering it.
 	 */
-	if (!address_needs_mapping(hwdev, dev_addr, size) &&
-	    !range_needs_mapping(ptr, size))
+	if (!address_needs_mapping(dev, dev_addr, size) &&
+	    !range_needs_mapping(virt_to_phys(ptr), size))
 		return dev_addr;
 
 	/*
 	 * Oh well, have to allocate and map a bounce buffer.
 	 */
-	map = map_single(hwdev, virt_to_phys(ptr), size, dir);
+	map = map_single(dev, phys, size, dir);
 	if (!map) {
-		swiotlb_full(hwdev, size, dir, 1);
+		swiotlb_full(dev, size, dir, 1);
 		map = io_tlb_overflow_buffer;
 	}
 
-	dev_addr = swiotlb_virt_to_bus(hwdev, map);
+	dev_addr = swiotlb_virt_to_bus(dev, map);
 
 	/*
 	 * Ensure that the address returned is DMA'ble
 	 */
-	if (address_needs_mapping(hwdev, dev_addr, size))
+	if (address_needs_mapping(dev, dev_addr, size))
 		panic("map_single: bounce buffer is not DMA'ble");
 
 	return dev_addr;
 }
-EXPORT_SYMBOL(swiotlb_map_single_attrs);
-
-dma_addr_t
-swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, int dir)
-{
-	return swiotlb_map_single_attrs(hwdev, ptr, size, dir, NULL);
-}
-EXPORT_SYMBOL(swiotlb_map_single);
+EXPORT_SYMBOL_GPL(swiotlb_map_page);
 
 /*
  * Unmap a single streaming mode DMA translation.  The dma_addr and size must
@@ -689,9 +685,9 @@ EXPORT_SYMBOL(swiotlb_map_single);
  * After this call, reads by the cpu to the buffer are guaranteed to see
  * whatever the device wrote there.
  */
-void
-swiotlb_unmap_single_attrs(struct device *hwdev, dma_addr_t dev_addr,
-			   size_t size, int dir, struct dma_attrs *attrs)
+void swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
+			size_t size, enum dma_data_direction dir,
+			struct dma_attrs *attrs)
 {
 	char *dma_addr = swiotlb_bus_to_virt(dev_addr);
 
@@ -701,15 +697,7 @@ swiotlb_unmap_single_attrs(struct device *hwdev, dma_addr_t dev_addr,
 	else if (dir == DMA_FROM_DEVICE)
 		dma_mark_clean(dma_addr, size);
 }
-EXPORT_SYMBOL(swiotlb_unmap_single_attrs);
-
-void
-swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr, size_t size,
-		     int dir)
-{
-	return swiotlb_unmap_single_attrs(hwdev, dev_addr, size, dir, NULL);
-}
-EXPORT_SYMBOL(swiotlb_unmap_single);
+EXPORT_SYMBOL_GPL(swiotlb_unmap_page);
 
 /*
  * Make physical memory consistent for a single streaming mode DMA translation
@@ -736,7 +724,7 @@ swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 
 void
 swiotlb_sync_single_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
-			    size_t size, int dir)
+			    size_t size, enum dma_data_direction dir)
 {
 	swiotlb_sync_single(hwdev, dev_addr, size, dir, SYNC_FOR_CPU);
 }
@@ -744,7 +732,7 @@ EXPORT_SYMBOL(swiotlb_sync_single_for_cpu);
 
 void
 swiotlb_sync_single_for_device(struct device *hwdev, dma_addr_t dev_addr,
-			       size_t size, int dir)
+			       size_t size, enum dma_data_direction dir)
 {
 	swiotlb_sync_single(hwdev, dev_addr, size, dir, SYNC_FOR_DEVICE);
 }
@@ -769,7 +757,8 @@ swiotlb_sync_single_range(struct device *hwdev, dma_addr_t dev_addr,
 
 void
 swiotlb_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
-				  unsigned long offset, size_t size, int dir)
+				  unsigned long offset, size_t size,
+				  enum dma_data_direction dir)
 {
 	swiotlb_sync_single_range(hwdev, dev_addr, offset, size, dir,
 				  SYNC_FOR_CPU);
@@ -778,7 +767,8 @@ EXPORT_SYMBOL_GPL(swiotlb_sync_single_range_for_cpu);
 
 void
 swiotlb_sync_single_range_for_device(struct device *hwdev, dma_addr_t dev_addr,
-				     unsigned long offset, size_t size, int dir)
+				     unsigned long offset, size_t size,
+				     enum dma_data_direction dir)
 {
 	swiotlb_sync_single_range(hwdev, dev_addr, offset, size, dir,
 				  SYNC_FOR_DEVICE);
@@ -803,7 +793,7 @@ EXPORT_SYMBOL_GPL(swiotlb_sync_single_range_for_device);
  */
 int
 swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
-		     int dir, struct dma_attrs *attrs)
+		     enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -811,10 +801,10 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		void *addr = sg_virt(sg);
-		dma_addr_t dev_addr = swiotlb_virt_to_bus(hwdev, addr);
+		phys_addr_t paddr = sg_phys(sg);
+		dma_addr_t dev_addr = swiotlb_phys_to_bus(hwdev, paddr);
 
-		if (range_needs_mapping(addr, sg->length) ||
+		if (range_needs_mapping(paddr, sg->length) ||
 		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
 			void *map = map_single(hwdev, sg_phys(sg),
 					       sg->length, dir);
@@ -850,7 +840,7 @@ EXPORT_SYMBOL(swiotlb_map_sg);
  */
 void
 swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
-		       int nelems, int dir, struct dma_attrs *attrs)
+		       int nelems, enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -858,11 +848,11 @@ swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != swiotlb_virt_to_bus(hwdev, sg_virt(sg)))
+		if (sg->dma_address != swiotlb_phys_to_bus(hwdev, sg_phys(sg)))
 			unmap_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
 				     sg->dma_length, dir);
 		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(sg_virt(sg), sg->dma_length);
+			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg->dma_length);
 	}
 }
 EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
@@ -892,17 +882,17 @@ swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != swiotlb_virt_to_bus(hwdev, sg_virt(sg)))
+		if (sg->dma_address != swiotlb_phys_to_bus(hwdev, sg_phys(sg)))
 			sync_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
 				    sg->dma_length, dir, target);
 		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(sg_virt(sg), sg->dma_length);
+			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg->dma_length);
 	}
 }
 
 void
 swiotlb_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
-			int nelems, int dir)
+			int nelems, enum dma_data_direction dir)
 {
 	swiotlb_sync_sg(hwdev, sg, nelems, dir, SYNC_FOR_CPU);
 }
@@ -910,7 +900,7 @@ EXPORT_SYMBOL(swiotlb_sync_sg_for_cpu);
 
 void
 swiotlb_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
-			   int nelems, int dir)
+			   int nelems, enum dma_data_direction dir)
 {
 	swiotlb_sync_sg(hwdev, sg, nelems, dir, SYNC_FOR_DEVICE);
 }
