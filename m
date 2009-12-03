Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728AbZLCSSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbZLCSSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 13:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbZLCSSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 13:18:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41138 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbZLCSSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 13:18:06 -0500
Date: Thu, 3 Dec 2009 19:17:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Joerg Roedel <joerg.roedel@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/iommu changes for v2.6.33
Message-ID: <20091203181751.GA30737@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
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

Linus,

Please pull the latest IOMMU git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-iommu-for-linus

Highlights: refactorings, restructuring and cleanups mostly, all over 
the place. A new bootmem function is added, free_bootmem_late(). Also 
some fixes that didnt make it into .32.

Thanks,

	Ingo

------------------>
Darrick J. Wong (1):
      x86, Calgary IOMMU quirk: Find nearest matching Calgary while walking up the PCI tree

FUJITA Tomonori (20):
      x86: Use x86_platform for iommu_shutdown
      x86: Add iommu_init to x86_init_ops
      x86: Calgary: Convert detect_calgary() to use iommu_init hook
      x86: GART: Convert gart_iommu_hole_init() to use iommu_init hook
      x86: amd_iommu: Convert amd_iommu_detect() to use iommu_init hook
      x86: intel-iommu: Convert detect_intel_iommu to use iommu_init hook
      bootmem: Add free_bootmem_late()
      swiotlb: Add swiotlb_free() function
      swiotlb: Defer swiotlb init printing, export swiotlb_print_info()
      x86: Handle HW IOMMU initialization failure gracefully
      x86, 32-bit: Fix swiotlb boot crash
      swiotlb: Remove the swiotlb variable usage
      x86: Set dma_ops to nommu_dma_ops by default
      x86: Move iommu_shutdown_noop to x86_init.c
      swiotlb: Remove duplicate swiotlb_force extern declarations
      x86: Make calgary_iommu_init() static
      x86: gart: Add own dma_mapping_error function
      x86: Kill bad_dma_address variable
      x86: Calgary: Remove unnecessary DMA_ERROR_CODE usage
      x86: Fix iommu=soft boot option

Hiroshi Shimamoto (1):
      x86: Don't put iommu_shutdown_noop() in init section

Ingo Molnar (2):
      x86: Add iommu_init to x86_init_ops, fix build
      x86: gart: Clean up the code a bit

Joe Perches (1):
      x86: GART: pci-gart_64.c: Use correct length in strncmp

Joerg Roedel (36):
      x86/amd-iommu: un__init iommu_setup_msi
      x86/amd-iommu: attach devices to pre-allocated domains early
      x86/amd-iommu: Separate internal interface definitions
      x86/amd-iommu: Update copyright headers
      x86/amd-iommu: Add an index field to struct amd_iommu
      x86/amd-iommu: Add per IOMMU reference counting
      x86/amd-iommu: Add function to complete a tlb flush
      x86/amd-iommu: Make iommu_flush_pages aware of multiple IOMMUs
      x86/amd-iommu: Use __iommu_flush_pages for tlb flushes
      x86/amd-iommu: Remove iommu_flush_domain function
      x86/amd-iommu: Implement protection domain list
      x86/amd-iommu: Reimplement amd_iommu_flush_all_domains()
      x86/amd-iommu: Reimplement flush_all_domains_on_iommu()
      x86/amd-iommu: Make np-cache a global flag
      x86/amd-iommu: Use check_device for amd_iommu_dma_supported
      x86/amd-iommu: Use check_device in get_device_resources
      x86/amd-iommu: Remove iommu parameter from dma_ops_domain_(un)map
      x86/amd-iommu: Make alloc_new_range aware of multiple IOMMUs
      x86/amd-iommu: Remove iommu parameter from __(un)map_single
      x86/amd-iommu: Remove iommu specific handling from dma_ops path
      x86/amd-iommu: Let domain_for_device handle aliases
      x86/amd-iommu: Simplify get_device_resources()
      x86/amd-iommu: Move find_protection_domain to helper functions
      x86/amd-iommu: Use get_device_id and check_device where appropriate
      x86/amd-iommu: Remove iommu parameter from dma_ops_domain_alloc
      x86/amd-iommu: Move some pte allocation functions in the right section
      x86/amd-iommu: Rearrange dma_ops related functions
      x86/amd-iommu: Remove support for domain sharing
      x86/amd-iommu: Use dev->arch->iommu to store iommu related information
      x86/amd-iommu: Add device bind reference counting
      x86/amd-iommu: Keep devices per domain in a list
      x86/amd-iommu: Cleanup attach/detach_device code
      x86/amd-iommu: Introduce iommu_flush_device() function
      x86/amd-iommu: Cleanup DTE flushing code
      x86/amd-iommu: Move reset_iommu_command_buffer out of locked code
      x86/amd-iommu: Remove amd_iommu_pd_table

Pavel Vasilyev (1):
      agp/amd64: Remove GART dependency on AGP_AMD64

Tejun Heo (1):
      x86: Fix iommu=nodac parameter handling


 arch/ia64/include/asm/swiotlb.h        |    2 -
 arch/ia64/kernel/pci-swiotlb.c         |    4 +-
 arch/powerpc/kernel/setup_32.c         |    2 +-
 arch/powerpc/kernel/setup_64.c         |    2 +-
 arch/x86/include/asm/amd_iommu.h       |   16 +-
 arch/x86/include/asm/amd_iommu_proto.h |   38 +
 arch/x86/include/asm/amd_iommu_types.h |   54 ++-
 arch/x86/include/asm/calgary.h         |    2 -
 arch/x86/include/asm/device.h          |    2 +-
 arch/x86/include/asm/dma-mapping.h     |    5 +-
 arch/x86/include/asm/gart.h            |    9 +-
 arch/x86/include/asm/iommu.h           |    2 -
 arch/x86/include/asm/swiotlb.h         |    9 +-
 arch/x86/include/asm/x86_init.h        |   10 +
 arch/x86/kernel/amd_iommu.c            | 1247 +++++++++++++++++---------------
 arch/x86/kernel/amd_iommu_init.c       |   94 +--
 arch/x86/kernel/aperture_64.c          |    4 +-
 arch/x86/kernel/crash.c                |    5 +-
 arch/x86/kernel/pci-calgary_64.c       |   94 +--
 arch/x86/kernel/pci-dma.c              |   39 +-
 arch/x86/kernel/pci-gart_64.c          |  156 +++--
 arch/x86/kernel/pci-nommu.c            |   11 +-
 arch/x86/kernel/pci-swiotlb.c          |   18 +-
 arch/x86/kernel/reboot.c               |    4 +-
 arch/x86/kernel/x86_init.c             |    8 +
 drivers/char/agp/Kconfig               |    3 +-
 drivers/pci/dmar.c                     |    7 +-
 drivers/pci/intel-iommu.c              |    6 +-
 include/linux/bootmem.h                |    1 +
 include/linux/dmar.h                   |   15 +-
 include/linux/swiotlb.h                |   12 +-
 lib/swiotlb.c                          |   46 +-
 mm/bootmem.c                           |   24 +
 33 files changed, 1068 insertions(+), 883 deletions(-)
 create mode 100644 arch/x86/include/asm/amd_iommu_proto.h

diff --git a/arch/ia64/include/asm/swiotlb.h b/arch/ia64/include/asm/swiotlb.h
index dcbaea7..f0acde6 100644
--- a/arch/ia64/include/asm/swiotlb.h
+++ b/arch/ia64/include/asm/swiotlb.h
@@ -4,8 +4,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/swiotlb.h>
 
-extern int swiotlb_force;
-
 #ifdef CONFIG_SWIOTLB
 extern int swiotlb;
 extern void pci_swiotlb_init(void);
diff --git a/arch/ia64/kernel/pci-swiotlb.c b/arch/ia64/kernel/pci-swiotlb.c
index 285aae8..53292ab 100644
--- a/arch/ia64/kernel/pci-swiotlb.c
+++ b/arch/ia64/kernel/pci-swiotlb.c
@@ -41,7 +41,7 @@ struct dma_map_ops swiotlb_dma_ops = {
 void __init swiotlb_dma_init(void)
 {
 	dma_ops = &swiotlb_dma_ops;
-	swiotlb_init();
+	swiotlb_init(1);
 }
 
 void __init pci_swiotlb_init(void)
@@ -51,7 +51,7 @@ void __init pci_swiotlb_init(void)
 		swiotlb = 1;
 		printk(KERN_INFO "PCI-DMA: Re-initialize machine vector.\n");
 		machvec_init("dig");
-		swiotlb_init();
+		swiotlb_init(1);
 		dma_ops = &swiotlb_dma_ops;
 #else
 		panic("Unable to find Intel IOMMU");
diff --git a/arch/powerpc/kernel/setup_32.c b/arch/powerpc/kernel/setup_32.c
index 53bcf3d..b152de3 100644
--- a/arch/powerpc/kernel/setup_32.c
+++ b/arch/powerpc/kernel/setup_32.c
@@ -345,7 +345,7 @@ void __init setup_arch(char **cmdline_p)
 
 #ifdef CONFIG_SWIOTLB
 	if (ppc_swiotlb_enable)
-		swiotlb_init();
+		swiotlb_init(1);
 #endif
 
 	paging_init();
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 04f638d..df2c9e9 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -550,7 +550,7 @@ void __init setup_arch(char **cmdline_p)
 
 #ifdef CONFIG_SWIOTLB
 	if (ppc_swiotlb_enable)
-		swiotlb_init();
+		swiotlb_init(1);
 #endif
 
 	paging_init();
diff --git a/arch/x86/include/asm/amd_iommu.h b/arch/x86/include/asm/amd_iommu.h
index 4b18089..5af2982 100644
--- a/arch/x86/include/asm/amd_iommu.h
+++ b/arch/x86/include/asm/amd_iommu.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2007-2008 Advanced Micro Devices, Inc.
+ * Copyright (C) 2007-2009 Advanced Micro Devices, Inc.
  * Author: Joerg Roedel <joerg.roedel@amd.com>
  *         Leo Duran <leo.duran@amd.com>
  *
@@ -23,19 +23,13 @@
 #include <linux/irqreturn.h>
 
 #ifdef CONFIG_AMD_IOMMU
-extern int amd_iommu_init(void);
-extern int amd_iommu_init_dma_ops(void);
-extern int amd_iommu_init_passthrough(void);
+
 extern void amd_iommu_detect(void);
-extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
-extern void amd_iommu_flush_all_domains(void);
-extern void amd_iommu_flush_all_devices(void);
-extern void amd_iommu_shutdown(void);
-extern void amd_iommu_apply_erratum_63(u16 devid);
+
 #else
-static inline int amd_iommu_init(void) { return -ENODEV; }
+
 static inline void amd_iommu_detect(void) { }
-static inline void amd_iommu_shutdown(void) { }
+
 #endif
 
 #endif /* _ASM_X86_AMD_IOMMU_H */
diff --git a/arch/x86/include/asm/amd_iommu_proto.h b/arch/x86/include/asm/amd_iommu_proto.h
new file mode 100644
index 0000000..84786fb
--- /dev/null
+++ b/arch/x86/include/asm/amd_iommu_proto.h
@@ -0,0 +1,38 @@
+/*
+ * Copyright (C) 2009 Advanced Micro Devices, Inc.
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
+#ifndef _ASM_X86_AMD_IOMMU_PROTO_H
+#define _ASM_X86_AMD_IOMMU_PROTO_H
+
+struct amd_iommu;
+
+extern int amd_iommu_init_dma_ops(void);
+extern int amd_iommu_init_passthrough(void);
+extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
+extern void amd_iommu_flush_all_domains(void);
+extern void amd_iommu_flush_all_devices(void);
+extern void amd_iommu_apply_erratum_63(u16 devid);
+extern void amd_iommu_reset_cmd_buffer(struct amd_iommu *iommu);
+
+#ifndef CONFIG_AMD_IOMMU_STATS
+
+static inline void amd_iommu_stats_init(void) { }
+
+#endif /* !CONFIG_AMD_IOMMU_STATS */
+
+#endif /* _ASM_X86_AMD_IOMMU_PROTO_H  */
diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 2a2cc7a..ba19ad4 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2007-2008 Advanced Micro Devices, Inc.
+ * Copyright (C) 2007-2009 Advanced Micro Devices, Inc.
  * Author: Joerg Roedel <joerg.roedel@amd.com>
  *         Leo Duran <leo.duran@amd.com>
  *
@@ -25,6 +25,11 @@
 #include <linux/spinlock.h>
 
 /*
+ * Maximum number of IOMMUs supported
+ */
+#define MAX_IOMMUS	32
+
+/*
  * some size calculation constants
  */
 #define DEV_TABLE_ENTRY_SIZE		32
@@ -206,6 +211,9 @@ extern bool amd_iommu_dump;
 			printk(KERN_INFO "AMD-Vi: " format, ## arg);	\
 	} while(0);
 
+/* global flag if IOMMUs cache non-present entries */
+extern bool amd_iommu_np_cache;
+
 /*
  * Make iterating over all IOMMUs easier
  */
@@ -226,6 +234,8 @@ extern bool amd_iommu_dump;
  * independent of their use.
  */
 struct protection_domain {
+	struct list_head list;  /* for list of all protection domains */
+	struct list_head dev_list; /* List of all devices in this domain */
 	spinlock_t lock;	/* mostly used to lock the page table*/
 	u16 id;			/* the domain id written to the device table */
 	int mode;		/* paging mode (0-6 levels) */
@@ -233,7 +243,20 @@ struct protection_domain {
 	unsigned long flags;	/* flags to find out type of domain */
 	bool updated;		/* complete domain flush required */
 	unsigned dev_cnt;	/* devices assigned to this domain */
+	unsigned dev_iommu[MAX_IOMMUS]; /* per-IOMMU reference count */
 	void *priv;		/* private data */
+
+};
+
+/*
+ * This struct contains device specific data for the IOMMU
+ */
+struct iommu_dev_data {
+	struct list_head list;		  /* For domain->dev_list */
+	struct device *dev;		  /* Device this data belong to */
+	struct device *alias;		  /* The Alias Device */
+	struct protection_domain *domain; /* Domain the device is bound to */
+	atomic_t bind;			  /* Domain attach reverent count */
 };
 
 /*
@@ -291,6 +314,9 @@ struct dma_ops_domain {
 struct amd_iommu {
 	struct list_head list;
 
+	/* Index within the IOMMU array */
+	int index;
+
 	/* locks the accesses to the hardware */
 	spinlock_t lock;
 
@@ -357,6 +383,21 @@ struct amd_iommu {
 extern struct list_head amd_iommu_list;
 
 /*
+ * Array with pointers to each IOMMU struct
+ * The indices are referenced in the protection domains
+ */
+extern struct amd_iommu *amd_iommus[MAX_IOMMUS];
+
+/* Number of IOMMUs present in the system */
+extern int amd_iommus_present;
+
+/*
+ * Declarations for the global list of all protection domains
+ */
+extern spinlock_t amd_iommu_pd_lock;
+extern struct list_head amd_iommu_pd_list;
+
+/*
  * Structure defining one entry in the device table
  */
 struct dev_table_entry {
@@ -416,15 +457,9 @@ extern unsigned amd_iommu_aperture_order;
 /* largest PCI device id we expect translation requests for */
 extern u16 amd_iommu_last_bdf;
 
-/* data structures for protection domain handling */
-extern struct protection_domain **amd_iommu_pd_table;
-
 /* allocation bitmap for domain ids */
 extern unsigned long *amd_iommu_pd_alloc_bitmap;
 
-/* will be 1 if device isolation is enabled */
-extern bool amd_iommu_isolate;
-
 /*
  * If true, the addresses will be flushed on unmap time, not when
  * they are reused
@@ -462,11 +497,6 @@ struct __iommu_counter {
 #define ADD_STATS_COUNTER(name, x)
 #define SUB_STATS_COUNTER(name, x)
 
-static inline void amd_iommu_stats_init(void) { }
-
 #endif /* CONFIG_AMD_IOMMU_STATS */
 
-/* some function prototypes */
-extern void amd_iommu_reset_cmd_buffer(struct amd_iommu *iommu);
-
 #endif /* _ASM_X86_AMD_IOMMU_TYPES_H */
diff --git a/arch/x86/include/asm/calgary.h b/arch/x86/include/asm/calgary.h
index b03bedb..0918654 100644
--- a/arch/x86/include/asm/calgary.h
+++ b/arch/x86/include/asm/calgary.h
@@ -62,10 +62,8 @@ struct cal_chipset_ops {
 extern int use_calgary;
 
 #ifdef CONFIG_CALGARY_IOMMU
-extern int calgary_iommu_init(void);
 extern void detect_calgary(void);
 #else
-static inline int calgary_iommu_init(void) { return 1; }
 static inline void detect_calgary(void) { return; }
 #endif
 
diff --git a/arch/x86/include/asm/device.h b/arch/x86/include/asm/device.h
index cee34e9..029f230 100644
--- a/arch/x86/include/asm/device.h
+++ b/arch/x86/include/asm/device.h
@@ -8,7 +8,7 @@ struct dev_archdata {
 #ifdef CONFIG_X86_64
 struct dma_map_ops *dma_ops;
 #endif
-#ifdef CONFIG_DMAR
+#if defined(CONFIG_DMAR) || defined(CONFIG_AMD_IOMMU)
 	void *iommu; /* hook for IOMMU specific extension */
 #endif
 };
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 6a25d5d..0f6c02f 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -20,7 +20,8 @@
 # define ISA_DMA_BIT_MASK DMA_BIT_MASK(32)
 #endif
 
-extern dma_addr_t bad_dma_address;
+#define DMA_ERROR_CODE	0
+
 extern int iommu_merge;
 extern struct device x86_dma_fallback_dev;
 extern int panic_on_overflow;
@@ -48,7 +49,7 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 	if (ops->mapping_error)
 		return ops->mapping_error(dev, dma_addr);
 
-	return (dma_addr == bad_dma_address);
+	return (dma_addr == DMA_ERROR_CODE);
 }
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
diff --git a/arch/x86/include/asm/gart.h b/arch/x86/include/asm/gart.h
index 6cfdafa..4ac5b0f 100644
--- a/arch/x86/include/asm/gart.h
+++ b/arch/x86/include/asm/gart.h
@@ -35,8 +35,7 @@ extern int gart_iommu_aperture_allowed;
 extern int gart_iommu_aperture_disabled;
 
 extern void early_gart_iommu_check(void);
-extern void gart_iommu_init(void);
-extern void gart_iommu_shutdown(void);
+extern int gart_iommu_init(void);
 extern void __init gart_parse_options(char *);
 extern void gart_iommu_hole_init(void);
 
@@ -48,12 +47,6 @@ extern void gart_iommu_hole_init(void);
 static inline void early_gart_iommu_check(void)
 {
 }
-static inline void gart_iommu_init(void)
-{
-}
-static inline void gart_iommu_shutdown(void)
-{
-}
 static inline void gart_parse_options(char *options)
 {
 }
diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index fd6d21b..345c99c 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_X86_IOMMU_H
 #define _ASM_X86_IOMMU_H
 
-extern void pci_iommu_shutdown(void);
-extern void no_iommu_init(void);
 extern struct dma_map_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
diff --git a/arch/x86/include/asm/swiotlb.h b/arch/x86/include/asm/swiotlb.h
index b9e4e20..87ffcb1 100644
--- a/arch/x86/include/asm/swiotlb.h
+++ b/arch/x86/include/asm/swiotlb.h
@@ -3,17 +3,14 @@
 
 #include <linux/swiotlb.h>
 
-/* SWIOTLB interface */
-
-extern int swiotlb_force;
-
 #ifdef CONFIG_SWIOTLB
 extern int swiotlb;
-extern void pci_swiotlb_init(void);
+extern int pci_swiotlb_init(void);
 #else
 #define swiotlb 0
-static inline void pci_swiotlb_init(void)
+static inline int pci_swiotlb_init(void)
 {
+	return 0;
 }
 #endif
 
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 2c756fd..d8e7145 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -91,6 +91,14 @@ struct x86_init_timers {
 };
 
 /**
+ * struct x86_init_iommu - platform specific iommu setup
+ * @iommu_init:			platform specific iommu setup
+ */
+struct x86_init_iommu {
+	int (*iommu_init)(void);
+};
+
+/**
  * struct x86_init_ops - functions for platform specific setup
  *
  */
@@ -101,6 +109,7 @@ struct x86_init_ops {
 	struct x86_init_oem		oem;
 	struct x86_init_paging		paging;
 	struct x86_init_timers		timers;
+	struct x86_init_iommu		iommu;
 };
 
 /**
@@ -121,6 +130,7 @@ struct x86_platform_ops {
 	unsigned long (*calibrate_tsc)(void);
 	unsigned long (*get_wallclock)(void);
 	int (*set_wallclock)(unsigned long nowtime);
+	void (*iommu_shutdown)(void);
 };
 
 extern struct x86_init_ops x86_init;
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 0285521..32fb091 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2007-2008 Advanced Micro Devices, Inc.
+ * Copyright (C) 2007-2009 Advanced Micro Devices, Inc.
  * Author: Joerg Roedel <joerg.roedel@amd.com>
  *         Leo Duran <leo.duran@amd.com>
  *
@@ -28,6 +28,7 @@
 #include <asm/proto.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
+#include <asm/amd_iommu_proto.h>
 #include <asm/amd_iommu_types.h>
 #include <asm/amd_iommu.h>
 
@@ -56,20 +57,115 @@ struct iommu_cmd {
 	u32 data[4];
 };
 
-static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
-			     struct unity_map_entry *e);
-static struct dma_ops_domain *find_protection_domain(u16 devid);
-static u64 *alloc_pte(struct protection_domain *domain,
-		      unsigned long address, int end_lvl,
-		      u64 **pte_page, gfp_t gfp);
-static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
-				      unsigned long start_page,
-				      unsigned int pages);
 static void reset_iommu_command_buffer(struct amd_iommu *iommu);
-static u64 *fetch_pte(struct protection_domain *domain,
-		      unsigned long address, int map_size);
 static void update_domain(struct protection_domain *domain);
 
+/****************************************************************************
+ *
+ * Helper functions
+ *
+ ****************************************************************************/
+
+static inline u16 get_device_id(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	return calc_devid(pdev->bus->number, pdev->devfn);
+}
+
+static struct iommu_dev_data *get_dev_data(struct device *dev)
+{
+	return dev->archdata.iommu;
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
+	u16 alias = amd_iommu_alias_table[devid];
+
+	if (list_empty(&iommu_pd_list))
+		return NULL;
+
+	spin_lock_irqsave(&iommu_pd_list_lock, flags);
+
+	list_for_each_entry(entry, &iommu_pd_list, list) {
+		if (entry->target_dev == devid ||
+		    entry->target_dev == alias) {
+			ret = entry;
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
+ * This function checks if the driver got a valid device from the caller to
+ * avoid dereferencing invalid pointers.
+ */
+static bool check_device(struct device *dev)
+{
+	u16 devid;
+
+	if (!dev || !dev->dma_mask)
+		return false;
+
+	/* No device or no PCI device */
+	if (!dev || dev->bus != &pci_bus_type)
+		return false;
+
+	devid = get_device_id(dev);
+
+	/* Out of our scope? */
+	if (devid > amd_iommu_last_bdf)
+		return false;
+
+	if (amd_iommu_rlookup_table[devid] == NULL)
+		return false;
+
+	return true;
+}
+
+static int iommu_init_device(struct device *dev)
+{
+	struct iommu_dev_data *dev_data;
+	struct pci_dev *pdev;
+	u16 devid, alias;
+
+	if (dev->archdata.iommu)
+		return 0;
+
+	dev_data = kzalloc(sizeof(*dev_data), GFP_KERNEL);
+	if (!dev_data)
+		return -ENOMEM;
+
+	dev_data->dev = dev;
+
+	devid = get_device_id(dev);
+	alias = amd_iommu_alias_table[devid];
+	pdev = pci_get_bus_and_slot(PCI_BUS(alias), alias & 0xff);
+	if (pdev)
+		dev_data->alias = &pdev->dev;
+
+	atomic_set(&dev_data->bind, 0);
+
+	dev->archdata.iommu = dev_data;
+
+
+	return 0;
+}
+
+static void iommu_uninit_device(struct device *dev)
+{
+	kfree(dev->archdata.iommu);
+}
 #ifdef CONFIG_AMD_IOMMU_STATS
 
 /*
@@ -90,7 +186,6 @@ DECLARE_STATS_COUNTER(alloced_io_mem);
 DECLARE_STATS_COUNTER(total_map_requests);
 
 static struct dentry *stats_dir;
-static struct dentry *de_isolate;
 static struct dentry *de_fflush;
 
 static void amd_iommu_stats_add(struct __iommu_counter *cnt)
@@ -108,9 +203,6 @@ static void amd_iommu_stats_init(void)
 	if (stats_dir == NULL)
 		return;
 
-	de_isolate = debugfs_create_bool("isolation", 0444, stats_dir,
-					 (u32 *)&amd_iommu_isolate);
-
 	de_fflush  = debugfs_create_bool("fullflush", 0444, stats_dir,
 					 (u32 *)&amd_iommu_unmap_flush);
 
@@ -130,12 +222,6 @@ static void amd_iommu_stats_init(void)
 
 #endif
 
-/* returns !0 if the IOMMU is caching non-present entries in its TLB */
-static int iommu_has_npcache(struct amd_iommu *iommu)
-{
-	return iommu->cap & (1UL << IOMMU_CAP_NPCACHE);
-}
-
 /****************************************************************************
  *
  * Interrupt handling functions
@@ -199,6 +285,7 @@ static void iommu_print_event(struct amd_iommu *iommu, void *__evt)
 		break;
 	case EVENT_TYPE_ILL_CMD:
 		printk("ILLEGAL_COMMAND_ERROR address=0x%016llx]\n", address);
+		iommu->reset_in_progress = true;
 		reset_iommu_command_buffer(iommu);
 		dump_command(address);
 		break;
@@ -321,11 +408,8 @@ static void __iommu_wait_for_completion(struct amd_iommu *iommu)
 	status &= ~MMIO_STATUS_COM_WAIT_INT_MASK;
 	writel(status, iommu->mmio_base + MMIO_STATUS_OFFSET);
 
-	if (unlikely(i == EXIT_LOOP_COUNT)) {
-		spin_unlock(&iommu->lock);
-		reset_iommu_command_buffer(iommu);
-		spin_lock(&iommu->lock);
-	}
+	if (unlikely(i == EXIT_LOOP_COUNT))
+		iommu->reset_in_progress = true;
 }
 
 /*
@@ -372,26 +456,46 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 out:
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
+	if (iommu->reset_in_progress)
+		reset_iommu_command_buffer(iommu);
+
 	return 0;
 }
 
+static void iommu_flush_complete(struct protection_domain *domain)
+{
+	int i;
+
+	for (i = 0; i < amd_iommus_present; ++i) {
+		if (!domain->dev_iommu[i])
+			continue;
+
+		/*
+		 * Devices of this domain are behind this IOMMU
+		 * We need to wait for completion of all commands.
+		 */
+		iommu_completion_wait(amd_iommus[i]);
+	}
+}
+
 /*
  * Command send function for invalidating a device table entry
  */
-static int iommu_queue_inv_dev_entry(struct amd_iommu *iommu, u16 devid)
+static int iommu_flush_device(struct device *dev)
 {
+	struct amd_iommu *iommu;
 	struct iommu_cmd cmd;
-	int ret;
+	u16 devid;
 
-	BUG_ON(iommu == NULL);
+	devid = get_device_id(dev);
+	iommu = amd_iommu_rlookup_table[devid];
 
+	/* Build command */
 	memset(&cmd, 0, sizeof(cmd));
 	CMD_SET_TYPE(&cmd, CMD_INV_DEV_ENTRY);
 	cmd.data[0] = devid;
 
-	ret = iommu_queue_command(iommu, &cmd);
-
-	return ret;
+	return iommu_queue_command(iommu, &cmd);
 }
 
 static void __iommu_build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
@@ -430,11 +534,11 @@ static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
  * It invalidates a single PTE if the range to flush is within a single
  * page. Otherwise it flushes the whole TLB of the IOMMU.
  */
-static int iommu_flush_pages(struct amd_iommu *iommu, u16 domid,
-		u64 address, size_t size)
+static void __iommu_flush_pages(struct protection_domain *domain,
+				u64 address, size_t size, int pde)
 {
-	int s = 0;
-	unsigned pages = iommu_num_pages(address, size, PAGE_SIZE);
+	int s = 0, i;
+	unsigned long pages = iommu_num_pages(address, size, PAGE_SIZE);
 
 	address &= PAGE_MASK;
 
@@ -447,142 +551,212 @@ static int iommu_flush_pages(struct amd_iommu *iommu, u16 domid,
 		s = 1;
 	}
 
-	iommu_queue_inv_iommu_pages(iommu, address, domid, 0, s);
 
-	return 0;
+	for (i = 0; i < amd_iommus_present; ++i) {
+		if (!domain->dev_iommu[i])
+			continue;
+
+		/*
+		 * Devices of this domain are behind this IOMMU
+		 * We need a TLB flush
+		 */
+		iommu_queue_inv_iommu_pages(amd_iommus[i], address,
+					    domain->id, pde, s);
+	}
+
+	return;
 }
 
-/* Flush the whole IO/TLB for a given protection domain */
-static void iommu_flush_tlb(struct amd_iommu *iommu, u16 domid)
+static void iommu_flush_pages(struct protection_domain *domain,
+			     u64 address, size_t size)
 {
-	u64 address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
-
-	INC_STATS_COUNTER(domain_flush_single);
+	__iommu_flush_pages(domain, address, size, 0);
+}
 
-	iommu_queue_inv_iommu_pages(iommu, address, domid, 0, 1);
+/* Flush the whole IO/TLB for a given protection domain */
+static void iommu_flush_tlb(struct protection_domain *domain)
+{
+	__iommu_flush_pages(domain, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS, 0);
 }
 
 /* Flush the whole IO/TLB for a given protection domain - including PDE */
-static void iommu_flush_tlb_pde(struct amd_iommu *iommu, u16 domid)
+static void iommu_flush_tlb_pde(struct protection_domain *domain)
 {
-       u64 address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
-
-       INC_STATS_COUNTER(domain_flush_single);
-
-       iommu_queue_inv_iommu_pages(iommu, address, domid, 1, 1);
+	__iommu_flush_pages(domain, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS, 1);
 }
 
+
 /*
- * This function flushes one domain on one IOMMU
+ * This function flushes the DTEs for all devices in domain
  */
-static void flush_domain_on_iommu(struct amd_iommu *iommu, u16 domid)
+static void iommu_flush_domain_devices(struct protection_domain *domain)
 {
-	struct iommu_cmd cmd;
+	struct iommu_dev_data *dev_data;
 	unsigned long flags;
 
-	__iommu_build_inv_iommu_pages(&cmd, CMD_INV_IOMMU_ALL_PAGES_ADDRESS,
-				      domid, 1, 1);
+	spin_lock_irqsave(&domain->lock, flags);
 
-	spin_lock_irqsave(&iommu->lock, flags);
-	__iommu_queue_command(iommu, &cmd);
-	__iommu_completion_wait(iommu);
-	__iommu_wait_for_completion(iommu);
-	spin_unlock_irqrestore(&iommu->lock, flags);
+	list_for_each_entry(dev_data, &domain->dev_list, list)
+		iommu_flush_device(dev_data->dev);
+
+	spin_unlock_irqrestore(&domain->lock, flags);
 }
 
-static void flush_all_domains_on_iommu(struct amd_iommu *iommu)
+static void iommu_flush_all_domain_devices(void)
 {
-	int i;
+	struct protection_domain *domain;
+	unsigned long flags;
 
-	for (i = 1; i < MAX_DOMAIN_ID; ++i) {
-		if (!test_bit(i, amd_iommu_pd_alloc_bitmap))
-			continue;
-		flush_domain_on_iommu(iommu, i);
+	spin_lock_irqsave(&amd_iommu_pd_lock, flags);
+
+	list_for_each_entry(domain, &amd_iommu_pd_list, list) {
+		iommu_flush_domain_devices(domain);
+		iommu_flush_complete(domain);
 	}
 
+	spin_unlock_irqrestore(&amd_iommu_pd_lock, flags);
+}
+
+void amd_iommu_flush_all_devices(void)
+{
+	iommu_flush_all_domain_devices();
 }
 
 /*
- * This function is used to flush the IO/TLB for a given protection domain
- * on every IOMMU in the system
+ * This function uses heavy locking and may disable irqs for some time. But
+ * this is no issue because it is only called during resume.
  */
-static void iommu_flush_domain(u16 domid)
+void amd_iommu_flush_all_domains(void)
 {
-	struct amd_iommu *iommu;
+	struct protection_domain *domain;
+	unsigned long flags;
 
-	INC_STATS_COUNTER(domain_flush_all);
+	spin_lock_irqsave(&amd_iommu_pd_lock, flags);
 
-	for_each_iommu(iommu)
-		flush_domain_on_iommu(iommu, domid);
+	list_for_each_entry(domain, &amd_iommu_pd_list, list) {
+		spin_lock(&domain->lock);
+		iommu_flush_tlb_pde(domain);
+		iommu_flush_complete(domain);
+		spin_unlock(&domain->lock);
+	}
+
+	spin_unlock_irqrestore(&amd_iommu_pd_lock, flags);
 }
 
-void amd_iommu_flush_all_domains(void)
+static void reset_iommu_command_buffer(struct amd_iommu *iommu)
 {
-	struct amd_iommu *iommu;
+	pr_err("AMD-Vi: Resetting IOMMU command buffer\n");
 
-	for_each_iommu(iommu)
-		flush_all_domains_on_iommu(iommu);
+	if (iommu->reset_in_progress)
+		panic("AMD-Vi: ILLEGAL_COMMAND_ERROR while resetting command buffer\n");
+
+	amd_iommu_reset_cmd_buffer(iommu);
+	amd_iommu_flush_all_devices();
+	amd_iommu_flush_all_domains();
+
+	iommu->reset_in_progress = false;
 }
 
-static void flush_all_devices_for_iommu(struct amd_iommu *iommu)
+/****************************************************************************
+ *
+ * The functions below are used the create the page table mappings for
+ * unity mapped regions.
+ *
+ ****************************************************************************/
+
+/*
+ * This function is used to add another level to an IO page table. Adding
+ * another level increases the size of the address space by 9 bits to a size up
+ * to 64 bits.
+ */
+static bool increase_address_space(struct protection_domain *domain,
+				   gfp_t gfp)
 {
-	int i;
+	u64 *pte;
 
-	for (i = 0; i <= amd_iommu_last_bdf; ++i) {
-		if (iommu != amd_iommu_rlookup_table[i])
-			continue;
+	if (domain->mode == PAGE_MODE_6_LEVEL)
+		/* address space already 64 bit large */
+		return false;
 
-		iommu_queue_inv_dev_entry(iommu, i);
-		iommu_completion_wait(iommu);
-	}
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
 }
 
-static void flush_devices_by_domain(struct protection_domain *domain)
+static u64 *alloc_pte(struct protection_domain *domain,
+		      unsigned long address,
+		      int end_lvl,
+		      u64 **pte_page,
+		      gfp_t gfp)
 {
-	struct amd_iommu *iommu;
-	int i;
+	u64 *pte, *page;
+	int level;
 
-	for (i = 0; i <= amd_iommu_last_bdf; ++i) {
-		if ((domain == NULL && amd_iommu_pd_table[i] == NULL) ||
-		    (amd_iommu_pd_table[i] != domain))
-			continue;
+	while (address > PM_LEVEL_SIZE(domain->mode))
+		increase_address_space(domain, gfp);
 
-		iommu = amd_iommu_rlookup_table[i];
-		if (!iommu)
-			continue;
+	level =  domain->mode - 1;
+	pte   = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
 
-		iommu_queue_inv_dev_entry(iommu, i);
-		iommu_completion_wait(iommu);
+	while (level > end_lvl) {
+		if (!IOMMU_PTE_PRESENT(*pte)) {
+			page = (u64 *)get_zeroed_page(gfp);
+			if (!page)
+				return NULL;
+			*pte = PM_LEVEL_PDE(level, virt_to_phys(page));
+		}
+
+		level -= 1;
+
+		pte = IOMMU_PTE_PAGE(*pte);
+
+		if (pte_page && level == end_lvl)
+			*pte_page = pte;
+
+		pte = &pte[PM_LEVEL_INDEX(level, address)];
 	}
+
+	return pte;
 }
 
-static void reset_iommu_command_buffer(struct amd_iommu *iommu)
+/*
+ * This function checks if there is a PTE for a given dma address. If
+ * there is one, it returns the pointer to it.
+ */
+static u64 *fetch_pte(struct protection_domain *domain,
+		      unsigned long address, int map_size)
 {
-	pr_err("AMD-Vi: Resetting IOMMU command buffer\n");
+	int level;
+	u64 *pte;
 
-	if (iommu->reset_in_progress)
-		panic("AMD-Vi: ILLEGAL_COMMAND_ERROR while resetting command buffer\n");
+	level =  domain->mode - 1;
+	pte   = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
 
-	iommu->reset_in_progress = true;
+	while (level > map_size) {
+		if (!IOMMU_PTE_PRESENT(*pte))
+			return NULL;
 
-	amd_iommu_reset_cmd_buffer(iommu);
-	flush_all_devices_for_iommu(iommu);
-	flush_all_domains_on_iommu(iommu);
+		level -= 1;
 
-	iommu->reset_in_progress = false;
-}
+		pte = IOMMU_PTE_PAGE(*pte);
+		pte = &pte[PM_LEVEL_INDEX(level, address)];
 
-void amd_iommu_flush_all_devices(void)
-{
-	flush_devices_by_domain(NULL);
-}
+		if ((PM_PTE_LEVEL(*pte) == 0) && level != map_size) {
+			pte = NULL;
+			break;
+		}
+	}
 
-/****************************************************************************
- *
- * The functions below are used the create the page table mappings for
- * unity mapped regions.
- *
- ****************************************************************************/
+	return pte;
+}
 
 /*
  * Generic mapping functions. It maps a physical address into a DMA
@@ -654,28 +828,6 @@ static int iommu_for_unity_map(struct amd_iommu *iommu,
 }
 
 /*
- * Init the unity mappings for a specific IOMMU in the system
- *
- * Basically iterates over all unity mapping entries and applies them to
- * the default domain DMA of that IOMMU if necessary.
- */
-static int iommu_init_unity_mappings(struct amd_iommu *iommu)
-{
-	struct unity_map_entry *entry;
-	int ret;
-
-	list_for_each_entry(entry, &amd_iommu_unity_map, list) {
-		if (!iommu_for_unity_map(iommu, entry))
-			continue;
-		ret = dma_ops_unity_map(iommu->default_dom, entry);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
-/*
  * This function actually applies the mapping to the page table of the
  * dma_ops domain.
  */
@@ -704,6 +856,28 @@ static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 }
 
 /*
+ * Init the unity mappings for a specific IOMMU in the system
+ *
+ * Basically iterates over all unity mapping entries and applies them to
+ * the default domain DMA of that IOMMU if necessary.
+ */
+static int iommu_init_unity_mappings(struct amd_iommu *iommu)
+{
+	struct unity_map_entry *entry;
+	int ret;
+
+	list_for_each_entry(entry, &amd_iommu_unity_map, list) {
+		if (!iommu_for_unity_map(iommu, entry))
+			continue;
+		ret = dma_ops_unity_map(iommu->default_dom, entry);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/*
  * Inits the unity mappings required for a specific device
  */
 static int init_unity_mappings_for_device(struct dma_ops_domain *dma_dom,
@@ -740,34 +914,23 @@ static int init_unity_mappings_for_device(struct dma_ops_domain *dma_dom,
  */
 
 /*
- * This function checks if there is a PTE for a given dma address. If
- * there is one, it returns the pointer to it.
+ * Used to reserve address ranges in the aperture (e.g. for exclusion
+ * ranges.
  */
-static u64 *fetch_pte(struct protection_domain *domain,
-		      unsigned long address, int map_size)
+static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
+				      unsigned long start_page,
+				      unsigned int pages)
 {
-	int level;
-	u64 *pte;
-
-	level =  domain->mode - 1;
-	pte   = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
-
-	while (level > map_size) {
-		if (!IOMMU_PTE_PRESENT(*pte))
-			return NULL;
-
-		level -= 1;
+	unsigned int i, last_page = dom->aperture_size >> PAGE_SHIFT;
 
-		pte = IOMMU_PTE_PAGE(*pte);
-		pte = &pte[PM_LEVEL_INDEX(level, address)];
+	if (start_page + pages > last_page)
+		pages = last_page - start_page;
 
-		if ((PM_PTE_LEVEL(*pte) == 0) && level != map_size) {
-			pte = NULL;
-			break;
-		}
+	for (i = start_page; i < start_page + pages; ++i) {
+		int index = i / APERTURE_RANGE_PAGES;
+		int page  = i % APERTURE_RANGE_PAGES;
+		__set_bit(page, dom->aperture[index]->bitmap);
 	}
-
-	return pte;
 }
 
 /*
@@ -775,11 +938,11 @@ static u64 *fetch_pte(struct protection_domain *domain,
  * aperture in case of dma_ops domain allocation or address allocation
  * failure.
  */
-static int alloc_new_range(struct amd_iommu *iommu,
-			   struct dma_ops_domain *dma_dom,
+static int alloc_new_range(struct dma_ops_domain *dma_dom,
 			   bool populate, gfp_t gfp)
 {
 	int index = dma_dom->aperture_size >> APERTURE_RANGE_SHIFT;
+	struct amd_iommu *iommu;
 	int i;
 
 #ifdef CONFIG_IOMMU_STRESS
@@ -819,14 +982,17 @@ static int alloc_new_range(struct amd_iommu *iommu,
 	dma_dom->aperture_size += APERTURE_RANGE_SIZE;
 
 	/* Intialize the exclusion range if necessary */
-	if (iommu->exclusion_start &&
-	    iommu->exclusion_start >= dma_dom->aperture[index]->offset &&
-	    iommu->exclusion_start < dma_dom->aperture_size) {
-		unsigned long startpage = iommu->exclusion_start >> PAGE_SHIFT;
-		int pages = iommu_num_pages(iommu->exclusion_start,
-					    iommu->exclusion_length,
-					    PAGE_SIZE);
-		dma_ops_reserve_addresses(dma_dom, startpage, pages);
+	for_each_iommu(iommu) {
+		if (iommu->exclusion_start &&
+		    iommu->exclusion_start >= dma_dom->aperture[index]->offset
+		    && iommu->exclusion_start < dma_dom->aperture_size) {
+			unsigned long startpage;
+			int pages = iommu_num_pages(iommu->exclusion_start,
+						    iommu->exclusion_length,
+						    PAGE_SIZE);
+			startpage = iommu->exclusion_start >> PAGE_SHIFT;
+			dma_ops_reserve_addresses(dma_dom, startpage, pages);
+		}
 	}
 
 	/*
@@ -928,7 +1094,7 @@ static unsigned long dma_ops_alloc_addresses(struct device *dev,
 	}
 
 	if (unlikely(address == -1))
-		address = bad_dma_address;
+		address = DMA_ERROR_CODE;
 
 	WARN_ON((address + (PAGE_SIZE*pages)) > dom->aperture_size);
 
@@ -973,6 +1139,31 @@ static void dma_ops_free_addresses(struct dma_ops_domain *dom,
  *
  ****************************************************************************/
 
+/*
+ * This function adds a protection domain to the global protection domain list
+ */
+static void add_domain_to_list(struct protection_domain *domain)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&amd_iommu_pd_lock, flags);
+	list_add(&domain->list, &amd_iommu_pd_list);
+	spin_unlock_irqrestore(&amd_iommu_pd_lock, flags);
+}
+
+/*
+ * This function removes a protection domain to the global
+ * protection domain list
+ */
+static void del_domain_from_list(struct protection_domain *domain)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&amd_iommu_pd_lock, flags);
+	list_del(&domain->list);
+	spin_unlock_irqrestore(&amd_iommu_pd_lock, flags);
+}
+
 static u16 domain_id_alloc(void)
 {
 	unsigned long flags;
@@ -1000,26 +1191,6 @@ static void domain_id_free(int id)
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 }
 
-/*
- * Used to reserve address ranges in the aperture (e.g. for exclusion
- * ranges.
- */
-static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
-				      unsigned long start_page,
-				      unsigned int pages)
-{
-	unsigned int i, last_page = dom->aperture_size >> PAGE_SHIFT;
-
-	if (start_page + pages > last_page)
-		pages = last_page - start_page;
-
-	for (i = start_page; i < start_page + pages; ++i) {
-		int index = i / APERTURE_RANGE_PAGES;
-		int page  = i % APERTURE_RANGE_PAGES;
-		__set_bit(page, dom->aperture[index]->bitmap);
-	}
-}
-
 static void free_pagetable(struct protection_domain *domain)
 {
 	int i, j;
@@ -1061,6 +1232,8 @@ static void dma_ops_domain_free(struct dma_ops_domain *dom)
 	if (!dom)
 		return;
 
+	del_domain_from_list(&dom->domain);
+
 	free_pagetable(&dom->domain);
 
 	for (i = 0; i < APERTURE_MAX_RANGES; ++i) {
@@ -1078,7 +1251,7 @@ static void dma_ops_domain_free(struct dma_ops_domain *dom)
  * It also intializes the page table and the address allocator data
  * structures required for the dma_ops interface
  */
-static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu)
+static struct dma_ops_domain *dma_ops_domain_alloc(void)
 {
 	struct dma_ops_domain *dma_dom;
 
@@ -1091,6 +1264,7 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu)
 	dma_dom->domain.id = domain_id_alloc();
 	if (dma_dom->domain.id == 0)
 		goto free_dma_dom;
+	INIT_LIST_HEAD(&dma_dom->domain.dev_list);
 	dma_dom->domain.mode = PAGE_MODE_2_LEVEL;
 	dma_dom->domain.pt_root = (void *)get_zeroed_page(GFP_KERNEL);
 	dma_dom->domain.flags = PD_DMA_OPS_MASK;
@@ -1101,7 +1275,9 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu)
 	dma_dom->need_flush = false;
 	dma_dom->target_dev = 0xffff;
 
-	if (alloc_new_range(iommu, dma_dom, true, GFP_KERNEL))
+	add_domain_to_list(&dma_dom->domain);
+
+	if (alloc_new_range(dma_dom, true, GFP_KERNEL))
 		goto free_dma_dom;
 
 	/*
@@ -1129,22 +1305,6 @@ static bool dma_ops_domain(struct protection_domain *domain)
 	return domain->flags & PD_DMA_OPS_MASK;
 }
 
-/*
- * Find out the protection domain structure for a given PCI device. This
- * will give us the pointer to the page table root for example.
- */
-static struct protection_domain *domain_for_device(u16 devid)
-{
-	struct protection_domain *dom;
-	unsigned long flags;
-
-	read_lock_irqsave(&amd_iommu_devtable_lock, flags);
-	dom = amd_iommu_pd_table[devid];
-	read_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
-
-	return dom;
-}
-
 static void set_dte_entry(u16 devid, struct protection_domain *domain)
 {
 	u64 pte_root = virt_to_phys(domain->pt_root);
@@ -1156,42 +1316,123 @@ static void set_dte_entry(u16 devid, struct protection_domain *domain)
 	amd_iommu_dev_table[devid].data[2] = domain->id;
 	amd_iommu_dev_table[devid].data[1] = upper_32_bits(pte_root);
 	amd_iommu_dev_table[devid].data[0] = lower_32_bits(pte_root);
+}
+
+static void clear_dte_entry(u16 devid)
+{
+	/* remove entry from the device table seen by the hardware */
+	amd_iommu_dev_table[devid].data[0] = IOMMU_PTE_P | IOMMU_PTE_TV;
+	amd_iommu_dev_table[devid].data[1] = 0;
+	amd_iommu_dev_table[devid].data[2] = 0;
 
-	amd_iommu_pd_table[devid] = domain;
+	amd_iommu_apply_erratum_63(devid);
+}
+
+static void do_attach(struct device *dev, struct protection_domain *domain)
+{
+	struct iommu_dev_data *dev_data;
+	struct amd_iommu *iommu;
+	u16 devid;
+
+	devid    = get_device_id(dev);
+	iommu    = amd_iommu_rlookup_table[devid];
+	dev_data = get_dev_data(dev);
+
+	/* Update data structures */
+	dev_data->domain = domain;
+	list_add(&dev_data->list, &domain->dev_list);
+	set_dte_entry(devid, domain);
+
+	/* Do reference counting */
+	domain->dev_iommu[iommu->index] += 1;
+	domain->dev_cnt                 += 1;
+
+	/* Flush the DTE entry */
+	iommu_flush_device(dev);
+}
+
+static void do_detach(struct device *dev)
+{
+	struct iommu_dev_data *dev_data;
+	struct amd_iommu *iommu;
+	u16 devid;
+
+	devid    = get_device_id(dev);
+	iommu    = amd_iommu_rlookup_table[devid];
+	dev_data = get_dev_data(dev);
+
+	/* decrease reference counters */
+	dev_data->domain->dev_iommu[iommu->index] -= 1;
+	dev_data->domain->dev_cnt                 -= 1;
+
+	/* Update data structures */
+	dev_data->domain = NULL;
+	list_del(&dev_data->list);
+	clear_dte_entry(devid);
+
+	/* Flush the DTE entry */
+	iommu_flush_device(dev);
 }
 
 /*
  * If a device is not yet associated with a domain, this function does
  * assigns it visible for the hardware
  */
-static void __attach_device(struct amd_iommu *iommu,
-			    struct protection_domain *domain,
-			    u16 devid)
+static int __attach_device(struct device *dev,
+			   struct protection_domain *domain)
 {
+	struct iommu_dev_data *dev_data, *alias_data;
+
+	dev_data   = get_dev_data(dev);
+	alias_data = get_dev_data(dev_data->alias);
+
+	if (!alias_data)
+		return -EINVAL;
+
 	/* lock domain */
 	spin_lock(&domain->lock);
 
-	/* update DTE entry */
-	set_dte_entry(devid, domain);
+	/* Some sanity checks */
+	if (alias_data->domain != NULL &&
+	    alias_data->domain != domain)
+		return -EBUSY;
 
-	domain->dev_cnt += 1;
+	if (dev_data->domain != NULL &&
+	    dev_data->domain != domain)
+		return -EBUSY;
+
+	/* Do real assignment */
+	if (dev_data->alias != dev) {
+		alias_data = get_dev_data(dev_data->alias);
+		if (alias_data->domain == NULL)
+			do_attach(dev_data->alias, domain);
+
+		atomic_inc(&alias_data->bind);
+	}
+
+	if (dev_data->domain == NULL)
+		do_attach(dev, domain);
+
+	atomic_inc(&dev_data->bind);
 
 	/* ready */
 	spin_unlock(&domain->lock);
+
+	return 0;
 }
 
 /*
  * If a device is not yet associated with a domain, this function does
  * assigns it visible for the hardware
  */
-static void attach_device(struct amd_iommu *iommu,
-			  struct protection_domain *domain,
-			  u16 devid)
+static int attach_device(struct device *dev,
+			 struct protection_domain *domain)
 {
 	unsigned long flags;
+	int ret;
 
 	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
-	__attach_device(iommu, domain, devid);
+	ret = __attach_device(dev, domain);
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 
 	/*
@@ -1199,98 +1440,125 @@ static void attach_device(struct amd_iommu *iommu,
 	 * left the caches in the IOMMU dirty. So we have to flush
 	 * here to evict all dirty stuff.
 	 */
-	iommu_queue_inv_dev_entry(iommu, devid);
-	iommu_flush_tlb_pde(iommu, domain->id);
+	iommu_flush_tlb_pde(domain);
+
+	return ret;
 }
 
 /*
  * Removes a device from a protection domain (unlocked)
  */
-static void __detach_device(struct protection_domain *domain, u16 devid)
+static void __detach_device(struct device *dev)
 {
+	struct iommu_dev_data *dev_data = get_dev_data(dev);
+	struct iommu_dev_data *alias_data;
+	unsigned long flags;
 
-	/* lock domain */
-	spin_lock(&domain->lock);
-
-	/* remove domain from the lookup table */
-	amd_iommu_pd_table[devid] = NULL;
+	BUG_ON(!dev_data->domain);
 
-	/* remove entry from the device table seen by the hardware */
-	amd_iommu_dev_table[devid].data[0] = IOMMU_PTE_P | IOMMU_PTE_TV;
-	amd_iommu_dev_table[devid].data[1] = 0;
-	amd_iommu_dev_table[devid].data[2] = 0;
+	spin_lock_irqsave(&dev_data->domain->lock, flags);
 
-	amd_iommu_apply_erratum_63(devid);
+	if (dev_data->alias != dev) {
+		alias_data = get_dev_data(dev_data->alias);
+		if (atomic_dec_and_test(&alias_data->bind))
+			do_detach(dev_data->alias);
+	}
 
-	/* decrease reference counter */
-	domain->dev_cnt -= 1;
+	if (atomic_dec_and_test(&dev_data->bind))
+		do_detach(dev);
 
-	/* ready */
-	spin_unlock(&domain->lock);
+	spin_unlock_irqrestore(&dev_data->domain->lock, flags);
 
 	/*
 	 * If we run in passthrough mode the device must be assigned to the
 	 * passthrough domain if it is detached from any other domain
 	 */
-	if (iommu_pass_through) {
-		struct amd_iommu *iommu = amd_iommu_rlookup_table[devid];
-		__attach_device(iommu, pt_domain, devid);
-	}
+	if (iommu_pass_through && dev_data->domain == NULL)
+		__attach_device(dev, pt_domain);
 }
 
 /*
  * Removes a device from a protection domain (with devtable_lock held)
  */
-static void detach_device(struct protection_domain *domain, u16 devid)
+static void detach_device(struct device *dev)
 {
 	unsigned long flags;
 
 	/* lock device table */
 	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
-	__detach_device(domain, devid);
+	__detach_device(dev);
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 }
 
+/*
+ * Find out the protection domain structure for a given PCI device. This
+ * will give us the pointer to the page table root for example.
+ */
+static struct protection_domain *domain_for_device(struct device *dev)
+{
+	struct protection_domain *dom;
+	struct iommu_dev_data *dev_data, *alias_data;
+	unsigned long flags;
+	u16 devid, alias;
+
+	devid      = get_device_id(dev);
+	alias      = amd_iommu_alias_table[devid];
+	dev_data   = get_dev_data(dev);
+	alias_data = get_dev_data(dev_data->alias);
+	if (!alias_data)
+		return NULL;
+
+	read_lock_irqsave(&amd_iommu_devtable_lock, flags);
+	dom = dev_data->domain;
+	if (dom == NULL &&
+	    alias_data->domain != NULL) {
+		__attach_device(dev, alias_data->domain);
+		dom = alias_data->domain;
+	}
+
+	read_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
+
+	return dom;
+}
+
 static int device_change_notifier(struct notifier_block *nb,
 				  unsigned long action, void *data)
 {
 	struct device *dev = data;
-	struct pci_dev *pdev = to_pci_dev(dev);
-	u16 devid = calc_devid(pdev->bus->number, pdev->devfn);
+	u16 devid;
 	struct protection_domain *domain;
 	struct dma_ops_domain *dma_domain;
 	struct amd_iommu *iommu;
 	unsigned long flags;
 
-	if (devid > amd_iommu_last_bdf)
-		goto out;
-
-	devid = amd_iommu_alias_table[devid];
-
-	iommu = amd_iommu_rlookup_table[devid];
-	if (iommu == NULL)
-		goto out;
-
-	domain = domain_for_device(devid);
+	if (!check_device(dev))
+		return 0;
 
-	if (domain && !dma_ops_domain(domain))
-		WARN_ONCE(1, "AMD IOMMU WARNING: device %s already bound "
-			  "to a non-dma-ops domain\n", dev_name(dev));
+	devid  = get_device_id(dev);
+	iommu  = amd_iommu_rlookup_table[devid];
 
 	switch (action) {
 	case BUS_NOTIFY_UNBOUND_DRIVER:
+
+		domain = domain_for_device(dev);
+
 		if (!domain)
 			goto out;
 		if (iommu_pass_through)
 			break;
-		detach_device(domain, devid);
+		detach_device(dev);
 		break;
 	case BUS_NOTIFY_ADD_DEVICE:
+
+		iommu_init_device(dev);
+
+		domain = domain_for_device(dev);
+
 		/* allocate a protection domain if a device is added */
 		dma_domain = find_protection_domain(devid);
 		if (dma_domain)
 			goto out;
-		dma_domain = dma_ops_domain_alloc(iommu);
+		dma_domain = dma_ops_domain_alloc();
 		if (!dma_domain)
 			goto out;
 		dma_domain->target_dev = devid;
@@ -1300,11 +1568,15 @@ static int device_change_notifier(struct notifier_block *nb,
 		spin_unlock_irqrestore(&iommu_pd_list_lock, flags);
 
 		break;
+	case BUS_NOTIFY_DEL_DEVICE:
+
+		iommu_uninit_device(dev);
+
 	default:
 		goto out;
 	}
 
-	iommu_queue_inv_dev_entry(iommu, devid);
+	iommu_flush_device(dev);
 	iommu_completion_wait(iommu);
 
 out:
@@ -1322,106 +1594,46 @@ static struct notifier_block device_nb = {
  *****************************************************************************/
 
 /*
- * This function checks if the driver got a valid device from the caller to
- * avoid dereferencing invalid pointers.
- */
-static bool check_device(struct device *dev)
-{
-	if (!dev || !dev->dma_mask)
-		return false;
-
-	return true;
-}
-
-/*
- * In this function the list of preallocated protection domains is traversed to
- * find the domain for a specific device
- */
-static struct dma_ops_domain *find_protection_domain(u16 devid)
-{
-	struct dma_ops_domain *entry, *ret = NULL;
-	unsigned long flags;
-
-	if (list_empty(&iommu_pd_list))
-		return NULL;
-
-	spin_lock_irqsave(&iommu_pd_list_lock, flags);
-
-	list_for_each_entry(entry, &iommu_pd_list, list) {
-		if (entry->target_dev == devid) {
-			ret = entry;
-			break;
-		}
-	}
-
-	spin_unlock_irqrestore(&iommu_pd_list_lock, flags);
-
-	return ret;
-}
-
-/*
  * In the dma_ops path we only have the struct device. This function
  * finds the corresponding IOMMU, the protection domain and the
  * requestor id for a given device.
  * If the device is not yet associated with a domain this is also done
  * in this function.
  */
-static int get_device_resources(struct device *dev,
-				struct amd_iommu **iommu,
-				struct protection_domain **domain,
-				u16 *bdf)
+static struct protection_domain *get_domain(struct device *dev)
 {
+	struct protection_domain *domain;
 	struct dma_ops_domain *dma_dom;
-	struct pci_dev *pcidev;
-	u16 _bdf;
-
-	*iommu = NULL;
-	*domain = NULL;
-	*bdf = 0xffff;
-
-	if (dev->bus != &pci_bus_type)
-		return 0;
+	u16 devid = get_device_id(dev);
 
-	pcidev = to_pci_dev(dev);
-	_bdf = calc_devid(pcidev->bus->number, pcidev->devfn);
+	if (!check_device(dev))
+		return ERR_PTR(-EINVAL);
 
-	/* device not translated by any IOMMU in the system? */
-	if (_bdf > amd_iommu_last_bdf)
-		return 0;
+	domain = domain_for_device(dev);
+	if (domain != NULL && !dma_ops_domain(domain))
+		return ERR_PTR(-EBUSY);
 
-	*bdf = amd_iommu_alias_table[_bdf];
+	if (domain != NULL)
+		return domain;
 
-	*iommu = amd_iommu_rlookup_table[*bdf];
-	if (*iommu == NULL)
-		return 0;
-	*domain = domain_for_device(*bdf);
-	if (*domain == NULL) {
-		dma_dom = find_protection_domain(*bdf);
-		if (!dma_dom)
-			dma_dom = (*iommu)->default_dom;
-		*domain = &dma_dom->domain;
-		attach_device(*iommu, *domain, *bdf);
-		DUMP_printk("Using protection domain %d for device %s\n",
-			    (*domain)->id, dev_name(dev));
-	}
-
-	if (domain_for_device(_bdf) == NULL)
-		attach_device(*iommu, *domain, _bdf);
+	/* Device not bount yet - bind it */
+	dma_dom = find_protection_domain(devid);
+	if (!dma_dom)
+		dma_dom = amd_iommu_rlookup_table[devid]->default_dom;
+	attach_device(dev, &dma_dom->domain);
+	DUMP_printk("Using protection domain %d for device %s\n",
+		    dma_dom->domain.id, dev_name(dev));
 
-	return 1;
+	return &dma_dom->domain;
 }
 
 static void update_device_table(struct protection_domain *domain)
 {
-	unsigned long flags;
-	int i;
+	struct iommu_dev_data *dev_data;
 
-	for (i = 0; i <= amd_iommu_last_bdf; ++i) {
-		if (amd_iommu_pd_table[i] != domain)
-			continue;
-		write_lock_irqsave(&amd_iommu_devtable_lock, flags);
-		set_dte_entry(i, domain);
-		write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
+	list_for_each_entry(dev_data, &domain->dev_list, list) {
+		u16 devid = get_device_id(dev_data->dev);
+		set_dte_entry(devid, domain);
 	}
 }
 
@@ -1431,76 +1643,13 @@ static void update_domain(struct protection_domain *domain)
 		return;
 
 	update_device_table(domain);
-	flush_devices_by_domain(domain);
-	iommu_flush_domain(domain->id);
+	iommu_flush_domain_devices(domain);
+	iommu_flush_tlb_pde(domain);
 
 	domain->updated = false;
 }
 
 /*
- * This function is used to add another level to an IO page table. Adding
- * another level increases the size of the address space by 9 bits to a size up
- * to 64 bits.
- */
-static bool increase_address_space(struct protection_domain *domain,
-				   gfp_t gfp)
-{
-	u64 *pte;
-
-	if (domain->mode == PAGE_MODE_6_LEVEL)
-		/* address space already 64 bit large */
-		return false;
-
-	pte = (void *)get_zeroed_page(gfp);
-	if (!pte)
-		return false;
-
-	*pte             = PM_LEVEL_PDE(domain->mode,
-					virt_to_phys(domain->pt_root));
-	domain->pt_root  = pte;
-	domain->mode    += 1;
-	domain->updated  = true;
-
-	return true;
-}
-
-static u64 *alloc_pte(struct protection_domain *domain,
-		      unsigned long address,
-		      int end_lvl,
-		      u64 **pte_page,
-		      gfp_t gfp)
-{
-	u64 *pte, *page;
-	int level;
-
-	while (address > PM_LEVEL_SIZE(domain->mode))
-		increase_address_space(domain, gfp);
-
-	level =  domain->mode - 1;
-	pte   = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
-
-	while (level > end_lvl) {
-		if (!IOMMU_PTE_PRESENT(*pte)) {
-			page = (u64 *)get_zeroed_page(gfp);
-			if (!page)
-				return NULL;
-			*pte = PM_LEVEL_PDE(level, virt_to_phys(page));
-		}
-
-		level -= 1;
-
-		pte = IOMMU_PTE_PAGE(*pte);
-
-		if (pte_page && level == end_lvl)
-			*pte_page = pte;
-
-		pte = &pte[PM_LEVEL_INDEX(level, address)];
-	}
-
-	return pte;
-}
-
-/*
  * This function fetches the PTE for a given address in the aperture
  */
 static u64* dma_ops_get_pte(struct dma_ops_domain *dom,
@@ -1530,8 +1679,7 @@ static u64* dma_ops_get_pte(struct dma_ops_domain *dom,
  * This is the generic map function. It maps one 4kb page at paddr to
  * the given address in the DMA address space for the domain.
  */
-static dma_addr_t dma_ops_domain_map(struct amd_iommu *iommu,
-				     struct dma_ops_domain *dom,
+static dma_addr_t dma_ops_domain_map(struct dma_ops_domain *dom,
 				     unsigned long address,
 				     phys_addr_t paddr,
 				     int direction)
@@ -1544,7 +1692,7 @@ static dma_addr_t dma_ops_domain_map(struct amd_iommu *iommu,
 
 	pte  = dma_ops_get_pte(dom, address);
 	if (!pte)
-		return bad_dma_address;
+		return DMA_ERROR_CODE;
 
 	__pte = paddr | IOMMU_PTE_P | IOMMU_PTE_FC;
 
@@ -1565,8 +1713,7 @@ static dma_addr_t dma_ops_domain_map(struct amd_iommu *iommu,
 /*
  * The generic unmapping function for on page in the DMA address space.
  */
-static void dma_ops_domain_unmap(struct amd_iommu *iommu,
-				 struct dma_ops_domain *dom,
+static void dma_ops_domain_unmap(struct dma_ops_domain *dom,
 				 unsigned long address)
 {
 	struct aperture_range *aperture;
@@ -1597,7 +1744,6 @@ static void dma_ops_domain_unmap(struct amd_iommu *iommu,
  * Must be called with the domain lock held.
  */
 static dma_addr_t __map_single(struct device *dev,
-			       struct amd_iommu *iommu,
 			       struct dma_ops_domain *dma_dom,
 			       phys_addr_t paddr,
 			       size_t size,
@@ -1625,7 +1771,7 @@ static dma_addr_t __map_single(struct device *dev,
 retry:
 	address = dma_ops_alloc_addresses(dev, dma_dom, pages, align_mask,
 					  dma_mask);
-	if (unlikely(address == bad_dma_address)) {
+	if (unlikely(address == DMA_ERROR_CODE)) {
 		/*
 		 * setting next_address here will let the address
 		 * allocator only scan the new allocated range in the
@@ -1633,7 +1779,7 @@ retry:
 		 */
 		dma_dom->next_address = dma_dom->aperture_size;
 
-		if (alloc_new_range(iommu, dma_dom, false, GFP_ATOMIC))
+		if (alloc_new_range(dma_dom, false, GFP_ATOMIC))
 			goto out;
 
 		/*
@@ -1645,8 +1791,8 @@ retry:
 
 	start = address;
 	for (i = 0; i < pages; ++i) {
-		ret = dma_ops_domain_map(iommu, dma_dom, start, paddr, dir);
-		if (ret == bad_dma_address)
+		ret = dma_ops_domain_map(dma_dom, start, paddr, dir);
+		if (ret == DMA_ERROR_CODE)
 			goto out_unmap;
 
 		paddr += PAGE_SIZE;
@@ -1657,10 +1803,10 @@ retry:
 	ADD_STATS_COUNTER(alloced_io_mem, size);
 
 	if (unlikely(dma_dom->need_flush && !amd_iommu_unmap_flush)) {
-		iommu_flush_tlb(iommu, dma_dom->domain.id);
+		iommu_flush_tlb(&dma_dom->domain);
 		dma_dom->need_flush = false;
-	} else if (unlikely(iommu_has_npcache(iommu)))
-		iommu_flush_pages(iommu, dma_dom->domain.id, address, size);
+	} else if (unlikely(amd_iommu_np_cache))
+		iommu_flush_pages(&dma_dom->domain, address, size);
 
 out:
 	return address;
@@ -1669,20 +1815,19 @@ out_unmap:
 
 	for (--i; i >= 0; --i) {
 		start -= PAGE_SIZE;
-		dma_ops_domain_unmap(iommu, dma_dom, start);
+		dma_ops_domain_unmap(dma_dom, start);
 	}
 
 	dma_ops_free_addresses(dma_dom, address, pages);
 
-	return bad_dma_address;
+	return DMA_ERROR_CODE;
 }
 
 /*
  * Does the reverse of the __map_single function. Must be called with
  * the domain lock held too
  */
-static void __unmap_single(struct amd_iommu *iommu,
-			   struct dma_ops_domain *dma_dom,
+static void __unmap_single(struct dma_ops_domain *dma_dom,
 			   dma_addr_t dma_addr,
 			   size_t size,
 			   int dir)
@@ -1690,7 +1835,7 @@ static void __unmap_single(struct amd_iommu *iommu,
 	dma_addr_t i, start;
 	unsigned int pages;
 
-	if ((dma_addr == bad_dma_address) ||
+	if ((dma_addr == DMA_ERROR_CODE) ||
 	    (dma_addr + size > dma_dom->aperture_size))
 		return;
 
@@ -1699,7 +1844,7 @@ static void __unmap_single(struct amd_iommu *iommu,
 	start = dma_addr;
 
 	for (i = 0; i < pages; ++i) {
-		dma_ops_domain_unmap(iommu, dma_dom, start);
+		dma_ops_domain_unmap(dma_dom, start);
 		start += PAGE_SIZE;
 	}
 
@@ -1708,7 +1853,7 @@ static void __unmap_single(struct amd_iommu *iommu,
 	dma_ops_free_addresses(dma_dom, dma_addr, pages);
 
 	if (amd_iommu_unmap_flush || dma_dom->need_flush) {
-		iommu_flush_pages(iommu, dma_dom->domain.id, dma_addr, size);
+		iommu_flush_pages(&dma_dom->domain, dma_addr, size);
 		dma_dom->need_flush = false;
 	}
 }
@@ -1722,36 +1867,29 @@ static dma_addr_t map_page(struct device *dev, struct page *page,
 			   struct dma_attrs *attrs)
 {
 	unsigned long flags;
-	struct amd_iommu *iommu;
 	struct protection_domain *domain;
-	u16 devid;
 	dma_addr_t addr;
 	u64 dma_mask;
 	phys_addr_t paddr = page_to_phys(page) + offset;
 
 	INC_STATS_COUNTER(cnt_map_single);
 
-	if (!check_device(dev))
-		return bad_dma_address;
-
-	dma_mask = *dev->dma_mask;
-
-	get_device_resources(dev, &iommu, &domain, &devid);
-
-	if (iommu == NULL || domain == NULL)
-		/* device not handled by any AMD IOMMU */
+	domain = get_domain(dev);
+	if (PTR_ERR(domain) == -EINVAL)
 		return (dma_addr_t)paddr;
+	else if (IS_ERR(domain))
+		return DMA_ERROR_CODE;
 
-	if (!dma_ops_domain(domain))
-		return bad_dma_address;
+	dma_mask = *dev->dma_mask;
 
 	spin_lock_irqsave(&domain->lock, flags);
-	addr = __map_single(dev, iommu, domain->priv, paddr, size, dir, false,
+
+	addr = __map_single(dev, domain->priv, paddr, size, dir, false,
 			    dma_mask);
-	if (addr == bad_dma_address)
+	if (addr == DMA_ERROR_CODE)
 		goto out;
 
-	iommu_completion_wait(iommu);
+	iommu_flush_complete(domain);
 
 out:
 	spin_unlock_irqrestore(&domain->lock, flags);
@@ -1766,25 +1904,19 @@ static void unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
 		       enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	unsigned long flags;
-	struct amd_iommu *iommu;
 	struct protection_domain *domain;
-	u16 devid;
 
 	INC_STATS_COUNTER(cnt_unmap_single);
 
-	if (!check_device(dev) ||
-	    !get_device_resources(dev, &iommu, &domain, &devid))
-		/* device not handled by any AMD IOMMU */
-		return;
-
-	if (!dma_ops_domain(domain))
+	domain = get_domain(dev);
+	if (IS_ERR(domain))
 		return;
 
 	spin_lock_irqsave(&domain->lock, flags);
 
-	__unmap_single(iommu, domain->priv, dma_addr, size, dir);
+	__unmap_single(domain->priv, dma_addr, size, dir);
 
-	iommu_completion_wait(iommu);
+	iommu_flush_complete(domain);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 }
@@ -1816,9 +1948,7 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 		  struct dma_attrs *attrs)
 {
 	unsigned long flags;
-	struct amd_iommu *iommu;
 	struct protection_domain *domain;
-	u16 devid;
 	int i;
 	struct scatterlist *s;
 	phys_addr_t paddr;
@@ -1827,25 +1957,20 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 
 	INC_STATS_COUNTER(cnt_map_sg);
 
-	if (!check_device(dev))
+	domain = get_domain(dev);
+	if (PTR_ERR(domain) == -EINVAL)
+		return map_sg_no_iommu(dev, sglist, nelems, dir);
+	else if (IS_ERR(domain))
 		return 0;
 
 	dma_mask = *dev->dma_mask;
 
-	get_device_resources(dev, &iommu, &domain, &devid);
-
-	if (!iommu || !domain)
-		return map_sg_no_iommu(dev, sglist, nelems, dir);
-
-	if (!dma_ops_domain(domain))
-		return 0;
-
 	spin_lock_irqsave(&domain->lock, flags);
 
 	for_each_sg(sglist, s, nelems, i) {
 		paddr = sg_phys(s);
 
-		s->dma_address = __map_single(dev, iommu, domain->priv,
+		s->dma_address = __map_single(dev, domain->priv,
 					      paddr, s->length, dir, false,
 					      dma_mask);
 
@@ -1856,7 +1981,7 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 			goto unmap;
 	}
 
-	iommu_completion_wait(iommu);
+	iommu_flush_complete(domain);
 
 out:
 	spin_unlock_irqrestore(&domain->lock, flags);
@@ -1865,7 +1990,7 @@ out:
 unmap:
 	for_each_sg(sglist, s, mapped_elems, i) {
 		if (s->dma_address)
-			__unmap_single(iommu, domain->priv, s->dma_address,
+			__unmap_single(domain->priv, s->dma_address,
 				       s->dma_length, dir);
 		s->dma_address = s->dma_length = 0;
 	}
@@ -1884,30 +2009,25 @@ static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 		     struct dma_attrs *attrs)
 {
 	unsigned long flags;
-	struct amd_iommu *iommu;
 	struct protection_domain *domain;
 	struct scatterlist *s;
-	u16 devid;
 	int i;
 
 	INC_STATS_COUNTER(cnt_unmap_sg);
 
-	if (!check_device(dev) ||
-	    !get_device_resources(dev, &iommu, &domain, &devid))
-		return;
-
-	if (!dma_ops_domain(domain))
+	domain = get_domain(dev);
+	if (IS_ERR(domain))
 		return;
 
 	spin_lock_irqsave(&domain->lock, flags);
 
 	for_each_sg(sglist, s, nelems, i) {
-		__unmap_single(iommu, domain->priv, s->dma_address,
+		__unmap_single(domain->priv, s->dma_address,
 			       s->dma_length, dir);
 		s->dma_address = s->dma_length = 0;
 	}
 
-	iommu_completion_wait(iommu);
+	iommu_flush_complete(domain);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 }
@@ -1920,49 +2040,44 @@ static void *alloc_coherent(struct device *dev, size_t size,
 {
 	unsigned long flags;
 	void *virt_addr;
-	struct amd_iommu *iommu;
 	struct protection_domain *domain;
-	u16 devid;
 	phys_addr_t paddr;
 	u64 dma_mask = dev->coherent_dma_mask;
 
 	INC_STATS_COUNTER(cnt_alloc_coherent);
 
-	if (!check_device(dev))
+	domain = get_domain(dev);
+	if (PTR_ERR(domain) == -EINVAL) {
+		virt_addr = (void *)__get_free_pages(flag, get_order(size));
+		*dma_addr = __pa(virt_addr);
+		return virt_addr;
+	} else if (IS_ERR(domain))
 		return NULL;
 
-	if (!get_device_resources(dev, &iommu, &domain, &devid))
-		flag &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
+	dma_mask  = dev->coherent_dma_mask;
+	flag     &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
+	flag     |= __GFP_ZERO;
 
-	flag |= __GFP_ZERO;
 	virt_addr = (void *)__get_free_pages(flag, get_order(size));
 	if (!virt_addr)
 		return NULL;
 
 	paddr = virt_to_phys(virt_addr);
 
-	if (!iommu || !domain) {
-		*dma_addr = (dma_addr_t)paddr;
-		return virt_addr;
-	}
-
-	if (!dma_ops_domain(domain))
-		goto out_free;
-
 	if (!dma_mask)
 		dma_mask = *dev->dma_mask;
 
 	spin_lock_irqsave(&domain->lock, flags);
 
-	*dma_addr = __map_single(dev, iommu, domain->priv, paddr,
+	*dma_addr = __map_single(dev, domain->priv, paddr,
 				 size, DMA_BIDIRECTIONAL, true, dma_mask);
 
-	if (*dma_addr == bad_dma_address) {
+	if (*dma_addr == DMA_ERROR_CODE) {
 		spin_unlock_irqrestore(&domain->lock, flags);
 		goto out_free;
 	}
 
-	iommu_completion_wait(iommu);
+	iommu_flush_complete(domain);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 
@@ -1982,28 +2097,19 @@ static void free_coherent(struct device *dev, size_t size,
 			  void *virt_addr, dma_addr_t dma_addr)
 {
 	unsigned long flags;
-	struct amd_iommu *iommu;
 	struct protection_domain *domain;
-	u16 devid;
 
 	INC_STATS_COUNTER(cnt_free_coherent);
 
-	if (!check_device(dev))
-		return;
-
-	get_device_resources(dev, &iommu, &domain, &devid);
-
-	if (!iommu || !domain)
-		goto free_mem;
-
-	if (!dma_ops_domain(domain))
+	domain = get_domain(dev);
+	if (IS_ERR(domain))
 		goto free_mem;
 
 	spin_lock_irqsave(&domain->lock, flags);
 
-	__unmap_single(iommu, domain->priv, dma_addr, size, DMA_BIDIRECTIONAL);
+	__unmap_single(domain->priv, dma_addr, size, DMA_BIDIRECTIONAL);
 
-	iommu_completion_wait(iommu);
+	iommu_flush_complete(domain);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 
@@ -2017,22 +2123,7 @@ free_mem:
  */
 static int amd_iommu_dma_supported(struct device *dev, u64 mask)
 {
-	u16 bdf;
-	struct pci_dev *pcidev;
-
-	/* No device or no PCI device */
-	if (!dev || dev->bus != &pci_bus_type)
-		return 0;
-
-	pcidev = to_pci_dev(dev);
-
-	bdf = calc_devid(pcidev->bus->number, pcidev->devfn);
-
-	/* Out of our scope? */
-	if (bdf > amd_iommu_last_bdf)
-		return 0;
-
-	return 1;
+	return check_device(dev);
 }
 
 /*
@@ -2046,25 +2137,30 @@ static void prealloc_protection_domains(void)
 {
 	struct pci_dev *dev = NULL;
 	struct dma_ops_domain *dma_dom;
-	struct amd_iommu *iommu;
 	u16 devid;
 
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
-		devid = calc_devid(dev->bus->number, dev->devfn);
-		if (devid > amd_iommu_last_bdf)
-			continue;
-		devid = amd_iommu_alias_table[devid];
-		if (domain_for_device(devid))
+
+		/* Do we handle this device? */
+		if (!check_device(&dev->dev))
 			continue;
-		iommu = amd_iommu_rlookup_table[devid];
-		if (!iommu)
+
+		iommu_init_device(&dev->dev);
+
+		/* Is there already any domain for it? */
+		if (domain_for_device(&dev->dev))
 			continue;
-		dma_dom = dma_ops_domain_alloc(iommu);
+
+		devid = get_device_id(&dev->dev);
+
+		dma_dom = dma_ops_domain_alloc();
 		if (!dma_dom)
 			continue;
 		init_unity_mappings_for_device(dma_dom, devid);
 		dma_dom->target_dev = devid;
 
+		attach_device(&dev->dev, &dma_dom->domain);
+
 		list_add_tail(&dma_dom->list, &iommu_pd_list);
 	}
 }
@@ -2093,7 +2189,7 @@ int __init amd_iommu_init_dma_ops(void)
 	 * protection domain will be assigned to the default one.
 	 */
 	for_each_iommu(iommu) {
-		iommu->default_dom = dma_ops_domain_alloc(iommu);
+		iommu->default_dom = dma_ops_domain_alloc();
 		if (iommu->default_dom == NULL)
 			return -ENOMEM;
 		iommu->default_dom->domain.flags |= PD_DEFAULT_MASK;
@@ -2103,15 +2199,12 @@ int __init amd_iommu_init_dma_ops(void)
 	}
 
 	/*
-	 * If device isolation is enabled, pre-allocate the protection
-	 * domains for each device.
+	 * Pre-allocate the protection domains for each device.
 	 */
-	if (amd_iommu_isolate)
-		prealloc_protection_domains();
+	prealloc_protection_domains();
 
 	iommu_detected = 1;
-	force_iommu = 1;
-	bad_dma_address = 0;
+	swiotlb = 0;
 #ifdef CONFIG_GART_IOMMU
 	gart_iommu_aperture_disabled = 1;
 	gart_iommu_aperture = 0;
@@ -2150,14 +2243,17 @@ free_domains:
 
 static void cleanup_domain(struct protection_domain *domain)
 {
+	struct iommu_dev_data *dev_data, *next;
 	unsigned long flags;
-	u16 devid;
 
 	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
 
-	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid)
-		if (amd_iommu_pd_table[devid] == domain)
-			__detach_device(domain, devid);
+	list_for_each_entry_safe(dev_data, next, &domain->dev_list, list) {
+		struct device *dev = dev_data->dev;
+
+		do_detach(dev);
+		atomic_set(&dev_data->bind, 0);
+	}
 
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 }
@@ -2167,6 +2263,8 @@ static void protection_domain_free(struct protection_domain *domain)
 	if (!domain)
 		return;
 
+	del_domain_from_list(domain);
+
 	if (domain->id)
 		domain_id_free(domain->id);
 
@@ -2185,6 +2283,9 @@ static struct protection_domain *protection_domain_alloc(void)
 	domain->id = domain_id_alloc();
 	if (!domain->id)
 		goto out_err;
+	INIT_LIST_HEAD(&domain->dev_list);
+
+	add_domain_to_list(domain);
 
 	return domain;
 
@@ -2241,26 +2342,23 @@ static void amd_iommu_domain_destroy(struct iommu_domain *dom)
 static void amd_iommu_detach_device(struct iommu_domain *dom,
 				    struct device *dev)
 {
-	struct protection_domain *domain = dom->priv;
+	struct iommu_dev_data *dev_data = dev->archdata.iommu;
 	struct amd_iommu *iommu;
-	struct pci_dev *pdev;
 	u16 devid;
 
-	if (dev->bus != &pci_bus_type)
+	if (!check_device(dev))
 		return;
 
-	pdev = to_pci_dev(dev);
-
-	devid = calc_devid(pdev->bus->number, pdev->devfn);
+	devid = get_device_id(dev);
 
-	if (devid > 0)
-		detach_device(domain, devid);
+	if (dev_data->domain != NULL)
+		detach_device(dev);
 
 	iommu = amd_iommu_rlookup_table[devid];
 	if (!iommu)
 		return;
 
-	iommu_queue_inv_dev_entry(iommu, devid);
+	iommu_flush_device(dev);
 	iommu_completion_wait(iommu);
 }
 
@@ -2268,35 +2366,30 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
 				   struct device *dev)
 {
 	struct protection_domain *domain = dom->priv;
-	struct protection_domain *old_domain;
+	struct iommu_dev_data *dev_data;
 	struct amd_iommu *iommu;
-	struct pci_dev *pdev;
+	int ret;
 	u16 devid;
 
-	if (dev->bus != &pci_bus_type)
+	if (!check_device(dev))
 		return -EINVAL;
 
-	pdev = to_pci_dev(dev);
+	dev_data = dev->archdata.iommu;
 
-	devid = calc_devid(pdev->bus->number, pdev->devfn);
-
-	if (devid >= amd_iommu_last_bdf ||
-			devid != amd_iommu_alias_table[devid])
-		return -EINVAL;
+	devid = get_device_id(dev);
 
 	iommu = amd_iommu_rlookup_table[devid];
 	if (!iommu)
 		return -EINVAL;
 
-	old_domain = domain_for_device(devid);
-	if (old_domain)
-		detach_device(old_domain, devid);
+	if (dev_data->domain)
+		detach_device(dev);
 
-	attach_device(iommu, domain, devid);
+	ret = attach_device(dev, domain);
 
 	iommu_completion_wait(iommu);
 
-	return 0;
+	return ret;
 }
 
 static int amd_iommu_map_range(struct iommu_domain *dom,
@@ -2342,7 +2435,7 @@ static void amd_iommu_unmap_range(struct iommu_domain *dom,
 		iova  += PAGE_SIZE;
 	}
 
-	iommu_flush_domain(domain->id);
+	iommu_flush_tlb_pde(domain);
 }
 
 static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
@@ -2393,8 +2486,9 @@ static struct iommu_ops amd_iommu_ops = {
 
 int __init amd_iommu_init_passthrough(void)
 {
+	struct amd_iommu *iommu;
 	struct pci_dev *dev = NULL;
-	u16 devid, devid2;
+	u16 devid;
 
 	/* allocate passthroug domain */
 	pt_domain = protection_domain_alloc();
@@ -2404,20 +2498,17 @@ int __init amd_iommu_init_passthrough(void)
 	pt_domain->mode |= PAGE_MODE_NONE;
 
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
-		struct amd_iommu *iommu;
 
-		devid = calc_devid(dev->bus->number, dev->devfn);
-		if (devid > amd_iommu_last_bdf)
+		if (!check_device(&dev->dev))
 			continue;
 
-		devid2 = amd_iommu_alias_table[devid];
+		devid = get_device_id(&dev->dev);
 
-		iommu = amd_iommu_rlookup_table[devid2];
+		iommu = amd_iommu_rlookup_table[devid];
 		if (!iommu)
 			continue;
 
-		__attach_device(iommu, pt_domain, devid);
-		__attach_device(iommu, pt_domain, devid2);
+		attach_device(&dev->dev, pt_domain);
 	}
 
 	pr_info("AMD-Vi: Initialized for Passthrough Mode\n");
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index c20001e..7ffc399 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2007-2008 Advanced Micro Devices, Inc.
+ * Copyright (C) 2007-2009 Advanced Micro Devices, Inc.
  * Author: Joerg Roedel <joerg.roedel@amd.com>
  *         Leo Duran <leo.duran@amd.com>
  *
@@ -25,10 +25,12 @@
 #include <linux/interrupt.h>
 #include <linux/msi.h>
 #include <asm/pci-direct.h>
+#include <asm/amd_iommu_proto.h>
 #include <asm/amd_iommu_types.h>
 #include <asm/amd_iommu.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
+#include <asm/x86_init.h>
 
 /*
  * definitions for the ACPI scanning code
@@ -123,18 +125,24 @@ u16 amd_iommu_last_bdf;			/* largest PCI device id we have
 					   to handle */
 LIST_HEAD(amd_iommu_unity_map);		/* a list of required unity mappings
 					   we find in ACPI */
-#ifdef CONFIG_IOMMU_STRESS
-bool amd_iommu_isolate = false;
-#else
-bool amd_iommu_isolate = true;		/* if true, device isolation is
-					   enabled */
-#endif
-
 bool amd_iommu_unmap_flush;		/* if true, flush on every unmap */
 
 LIST_HEAD(amd_iommu_list);		/* list of all AMD IOMMUs in the
 					   system */
 
+/* Array to assign indices to IOMMUs*/
+struct amd_iommu *amd_iommus[MAX_IOMMUS];
+int amd_iommus_present;
+
+/* IOMMUs have a non-present cache? */
+bool amd_iommu_np_cache __read_mostly;
+
+/*
+ * List of protection domains - used during resume
+ */
+LIST_HEAD(amd_iommu_pd_list);
+spinlock_t amd_iommu_pd_lock;
+
 /*
  * Pointer to the device table which is shared by all AMD IOMMUs
  * it is indexed by the PCI device id or the HT unit id and contains
@@ -157,12 +165,6 @@ u16 *amd_iommu_alias_table;
 struct amd_iommu **amd_iommu_rlookup_table;
 
 /*
- * The pd table (protection domain table) is used to find the protection domain
- * data structure a device belongs to. Indexed with the PCI device id too.
- */
-struct protection_domain **amd_iommu_pd_table;
-
-/*
  * AMD IOMMU allows up to 2^16 differend protection domains. This is a bitmap
  * to know which ones are already in use.
  */
@@ -838,7 +840,18 @@ static void __init free_iommu_all(void)
 static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 {
 	spin_lock_init(&iommu->lock);
+
+	/* Add IOMMU to internal data structures */
 	list_add_tail(&iommu->list, &amd_iommu_list);
+	iommu->index             = amd_iommus_present++;
+
+	if (unlikely(iommu->index >= MAX_IOMMUS)) {
+		WARN(1, "AMD-Vi: System has more IOMMUs than supported by this driver\n");
+		return -ENOSYS;
+	}
+
+	/* Index is fine - add IOMMU to the array */
+	amd_iommus[iommu->index] = iommu;
 
 	/*
 	 * Copy data from ACPI table entry to the iommu struct
@@ -868,6 +881,9 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 	init_iommu_from_acpi(iommu, h);
 	init_iommu_devices(iommu);
 
+	if (iommu->cap & (1UL << IOMMU_CAP_NPCACHE))
+		amd_iommu_np_cache = true;
+
 	return pci_enable_device(iommu->dev);
 }
 
@@ -925,7 +941,7 @@ static int __init init_iommu_all(struct acpi_table_header *table)
  *
  ****************************************************************************/
 
-static int __init iommu_setup_msi(struct amd_iommu *iommu)
+static int iommu_setup_msi(struct amd_iommu *iommu)
 {
 	int r;
 
@@ -1176,19 +1192,10 @@ static struct sys_device device_amd_iommu = {
  * functions. Finally it prints some information about AMD IOMMUs and
  * the driver state and enables the hardware.
  */
-int __init amd_iommu_init(void)
+static int __init amd_iommu_init(void)
 {
 	int i, ret = 0;
 
-
-	if (no_iommu) {
-		printk(KERN_INFO "AMD-Vi disabled by kernel command line\n");
-		return 0;
-	}
-
-	if (!amd_iommu_detected)
-		return -ENODEV;
-
 	/*
 	 * First parse ACPI tables to find the largest Bus/Dev/Func
 	 * we need to handle. Upon this information the shared data
@@ -1225,15 +1232,6 @@ int __init amd_iommu_init(void)
 	if (amd_iommu_rlookup_table == NULL)
 		goto free;
 
-	/*
-	 * Protection Domain table - maps devices to protection domains
-	 * This table has the same size as the rlookup_table
-	 */
-	amd_iommu_pd_table = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
-				     get_order(rlookup_table_size));
-	if (amd_iommu_pd_table == NULL)
-		goto free;
-
 	amd_iommu_pd_alloc_bitmap = (void *)__get_free_pages(
 					    GFP_KERNEL | __GFP_ZERO,
 					    get_order(MAX_DOMAIN_ID/8));
@@ -1255,6 +1253,8 @@ int __init amd_iommu_init(void)
 	 */
 	amd_iommu_pd_alloc_bitmap[0] = 1;
 
+	spin_lock_init(&amd_iommu_pd_lock);
+
 	/*
 	 * now the data structures are allocated and basically initialized
 	 * start the real acpi table scan
@@ -1286,17 +1286,12 @@ int __init amd_iommu_init(void)
 	if (iommu_pass_through)
 		goto out;
 
-	printk(KERN_INFO "AMD-Vi: device isolation ");
-	if (amd_iommu_isolate)
-		printk("enabled\n");
-	else
-		printk("disabled\n");
-
 	if (amd_iommu_unmap_flush)
 		printk(KERN_INFO "AMD-Vi: IO/TLB flush on unmap enabled\n");
 	else
 		printk(KERN_INFO "AMD-Vi: Lazy IO/TLB flushing enabled\n");
 
+	x86_platform.iommu_shutdown = disable_iommus;
 out:
 	return ret;
 
@@ -1304,9 +1299,6 @@ free:
 	free_pages((unsigned long)amd_iommu_pd_alloc_bitmap,
 		   get_order(MAX_DOMAIN_ID/8));
 
-	free_pages((unsigned long)amd_iommu_pd_table,
-		   get_order(rlookup_table_size));
-
 	free_pages((unsigned long)amd_iommu_rlookup_table,
 		   get_order(rlookup_table_size));
 
@@ -1323,11 +1315,6 @@ free:
 	goto out;
 }
 
-void amd_iommu_shutdown(void)
-{
-	disable_iommus();
-}
-
 /****************************************************************************
  *
  * Early detect code. This code runs at IOMMU detection time in the DMA
@@ -1342,16 +1329,13 @@ static int __init early_amd_iommu_detect(struct acpi_table_header *table)
 
 void __init amd_iommu_detect(void)
 {
-	if (swiotlb || no_iommu || (iommu_detected && !gart_iommu_aperture))
+	if (no_iommu || (iommu_detected && !gart_iommu_aperture))
 		return;
 
 	if (acpi_table_parse("IVRS", early_amd_iommu_detect) == 0) {
 		iommu_detected = 1;
 		amd_iommu_detected = 1;
-#ifdef CONFIG_GART_IOMMU
-		gart_iommu_aperture_disabled = 1;
-		gart_iommu_aperture = 0;
-#endif
+		x86_init.iommu.iommu_init = amd_iommu_init;
 	}
 }
 
@@ -1372,10 +1356,6 @@ static int __init parse_amd_iommu_dump(char *str)
 static int __init parse_amd_iommu_options(char *str)
 {
 	for (; *str; ++str) {
-		if (strncmp(str, "isolate", 7) == 0)
-			amd_iommu_isolate = true;
-		if (strncmp(str, "share", 5) == 0)
-			amd_iommu_isolate = false;
 		if (strncmp(str, "fullflush", 9) == 0)
 			amd_iommu_unmap_flush = true;
 	}
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 128111d..e0dfb68 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -28,6 +28,7 @@
 #include <asm/pci-direct.h>
 #include <asm/dma.h>
 #include <asm/k8.h>
+#include <asm/x86_init.h>
 
 int gart_iommu_aperture;
 int gart_iommu_aperture_disabled __initdata;
@@ -400,6 +401,7 @@ void __init gart_iommu_hole_init(void)
 
 			iommu_detected = 1;
 			gart_iommu_aperture = 1;
+			x86_init.iommu.iommu_init = gart_iommu_init;
 
 			aper_order = (read_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL) >> 1) & 7;
 			aper_size = (32 * 1024 * 1024) << aper_order;
@@ -456,7 +458,7 @@ out:
 
 	if (aper_alloc) {
 		/* Got the aperture from the AGP bridge */
-	} else if (swiotlb && !valid_agp) {
+	} else if (!valid_agp) {
 		/* Do nothing */
 	} else if ((!no_iommu && max_pfn > MAX_DMA32_PFN) ||
 		   force_iommu ||
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 5e409dc..a4849c1 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -27,8 +27,7 @@
 #include <asm/cpu.h>
 #include <asm/reboot.h>
 #include <asm/virtext.h>
-#include <asm/iommu.h>
-
+#include <asm/x86_init.h>
 
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 
@@ -106,7 +105,7 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 #endif
 
 #ifdef CONFIG_X86_64
-	pci_iommu_shutdown();
+	x86_platform.iommu_shutdown();
 #endif
 
 	crash_save_cpu(regs, safe_smp_processor_id());
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 971a3be..c563e4c 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -46,6 +46,7 @@
 #include <asm/dma.h>
 #include <asm/rio.h>
 #include <asm/bios_ebda.h>
+#include <asm/x86_init.h>
 
 #ifdef CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT
 int use_calgary __read_mostly = 1;
@@ -244,7 +245,7 @@ static unsigned long iommu_range_alloc(struct device *dev,
 			if (panic_on_overflow)
 				panic("Calgary: fix the allocator.\n");
 			else
-				return bad_dma_address;
+				return DMA_ERROR_CODE;
 		}
 	}
 
@@ -260,12 +261,15 @@ static dma_addr_t iommu_alloc(struct device *dev, struct iommu_table *tbl,
 			      void *vaddr, unsigned int npages, int direction)
 {
 	unsigned long entry;
-	dma_addr_t ret = bad_dma_address;
+	dma_addr_t ret;
 
 	entry = iommu_range_alloc(dev, tbl, npages);
 
-	if (unlikely(entry == bad_dma_address))
-		goto error;
+	if (unlikely(entry == DMA_ERROR_CODE)) {
+		printk(KERN_WARNING "Calgary: failed to allocate %u pages in "
+		       "iommu %p\n", npages, tbl);
+		return DMA_ERROR_CODE;
+	}
 
 	/* set the return dma address */
 	ret = (entry << PAGE_SHIFT) | ((unsigned long)vaddr & ~PAGE_MASK);
@@ -273,13 +277,7 @@ static dma_addr_t iommu_alloc(struct device *dev, struct iommu_table *tbl,
 	/* put the TCEs in the HW table */
 	tce_build(tbl, entry, npages, (unsigned long)vaddr & PAGE_MASK,
 		  direction);
-
 	return ret;
-
-error:
-	printk(KERN_WARNING "Calgary: failed to allocate %u pages in "
-	       "iommu %p\n", npages, tbl);
-	return bad_dma_address;
 }
 
 static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
@@ -290,8 +288,8 @@ static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 	unsigned long flags;
 
 	/* were we called with bad_dma_address? */
-	badend = bad_dma_address + (EMERGENCY_PAGES * PAGE_SIZE);
-	if (unlikely((dma_addr >= bad_dma_address) && (dma_addr < badend))) {
+	badend = DMA_ERROR_CODE + (EMERGENCY_PAGES * PAGE_SIZE);
+	if (unlikely((dma_addr >= DMA_ERROR_CODE) && (dma_addr < badend))) {
 		WARN(1, KERN_ERR "Calgary: driver tried unmapping bad DMA "
 		       "address 0x%Lx\n", dma_addr);
 		return;
@@ -318,13 +316,15 @@ static inline struct iommu_table *find_iommu_table(struct device *dev)
 
 	pdev = to_pci_dev(dev);
 
+	/* search up the device tree for an iommu */
 	pbus = pdev->bus;
-
-	/* is the device behind a bridge? Look for the root bus */
-	while (pbus->parent)
+	do {
+		tbl = pci_iommu(pbus);
+		if (tbl && tbl->it_busno == pbus->number)
+			break;
+		tbl = NULL;
 		pbus = pbus->parent;
-
-	tbl = pci_iommu(pbus);
+	} while (pbus);
 
 	BUG_ON(tbl && (tbl->it_busno != pbus->number));
 
@@ -373,7 +373,7 @@ static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 		npages = iommu_num_pages(vaddr, s->length, PAGE_SIZE);
 
 		entry = iommu_range_alloc(dev, tbl, npages);
-		if (entry == bad_dma_address) {
+		if (entry == DMA_ERROR_CODE) {
 			/* makes sure unmap knows to stop */
 			s->dma_length = 0;
 			goto error;
@@ -391,7 +391,7 @@ static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 error:
 	calgary_unmap_sg(dev, sg, nelems, dir, NULL);
 	for_each_sg(sg, s, nelems, i) {
-		sg->dma_address = bad_dma_address;
+		sg->dma_address = DMA_ERROR_CODE;
 		sg->dma_length = 0;
 	}
 	return 0;
@@ -446,7 +446,7 @@ static void* calgary_alloc_coherent(struct device *dev, size_t size,
 
 	/* set up tces to cover the allocated range */
 	mapping = iommu_alloc(dev, tbl, ret, npages, DMA_BIDIRECTIONAL);
-	if (mapping == bad_dma_address)
+	if (mapping == DMA_ERROR_CODE)
 		goto free;
 	*dma_handle = mapping;
 	return ret;
@@ -727,7 +727,7 @@ static void __init calgary_reserve_regions(struct pci_dev *dev)
 	struct iommu_table *tbl = pci_iommu(dev->bus);
 
 	/* reserve EMERGENCY_PAGES from bad_dma_address and up */
-	iommu_range_reserve(tbl, bad_dma_address, EMERGENCY_PAGES);
+	iommu_range_reserve(tbl, DMA_ERROR_CODE, EMERGENCY_PAGES);
 
 	/* avoid the BIOS/VGA first 640KB-1MB region */
 	/* for CalIOC2 - avoid the entire first MB */
@@ -1344,6 +1344,23 @@ static void __init get_tce_space_from_tar(void)
 	return;
 }
 
+static int __init calgary_iommu_init(void)
+{
+	int ret;
+
+	/* ok, we're trying to use Calgary - let's roll */
+	printk(KERN_INFO "PCI-DMA: Using Calgary IOMMU\n");
+
+	ret = calgary_init();
+	if (ret) {
+		printk(KERN_ERR "PCI-DMA: Calgary init failed %d, "
+		       "falling back to no_iommu\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 void __init detect_calgary(void)
 {
 	int bus;
@@ -1357,7 +1374,7 @@ void __init detect_calgary(void)
 	 * if the user specified iommu=off or iommu=soft or we found
 	 * another HW IOMMU already, bail out.
 	 */
-	if (swiotlb || no_iommu || iommu_detected)
+	if (no_iommu || iommu_detected)
 		return;
 
 	if (!use_calgary)
@@ -1442,9 +1459,7 @@ void __init detect_calgary(void)
 		printk(KERN_INFO "PCI-DMA: Calgary TCE table spec is %d\n",
 		       specified_table_size);
 
-		/* swiotlb for devices that aren't behind the Calgary. */
-		if (max_pfn > MAX_DMA32_PFN)
-			swiotlb = 1;
+		x86_init.iommu.iommu_init = calgary_iommu_init;
 	}
 	return;
 
@@ -1457,35 +1472,6 @@ cleanup:
 	}
 }
 
-int __init calgary_iommu_init(void)
-{
-	int ret;
-
-	if (no_iommu || (swiotlb && !calgary_detected))
-		return -ENODEV;
-
-	if (!calgary_detected)
-		return -ENODEV;
-
-	/* ok, we're trying to use Calgary - let's roll */
-	printk(KERN_INFO "PCI-DMA: Using Calgary IOMMU\n");
-
-	ret = calgary_init();
-	if (ret) {
-		printk(KERN_ERR "PCI-DMA: Calgary init failed %d, "
-		       "falling back to no_iommu\n", ret);
-		return ret;
-	}
-
-	force_iommu = 1;
-	bad_dma_address = 0x0;
-	/* dma_ops is set to swiotlb or nommu */
-	if (!dma_ops)
-		dma_ops = &nommu_dma_ops;
-
-	return 0;
-}
-
 static int __init calgary_parse_options(char *p)
 {
 	unsigned int bridge;
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index a6e804d..afcc58b 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -11,10 +11,11 @@
 #include <asm/gart.h>
 #include <asm/calgary.h>
 #include <asm/amd_iommu.h>
+#include <asm/x86_init.h>
 
 static int forbid_dac __read_mostly;
 
-struct dma_map_ops *dma_ops;
+struct dma_map_ops *dma_ops = &nommu_dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 static int iommu_sac_force __read_mostly;
@@ -42,9 +43,6 @@ int iommu_detected __read_mostly = 0;
  */
 int iommu_pass_through __read_mostly;
 
-dma_addr_t bad_dma_address __read_mostly = 0;
-EXPORT_SYMBOL(bad_dma_address);
-
 /* Dummy device used for NULL arguments (normally ISA). */
 struct device x86_dma_fallback_dev = {
 	.init_name = "fallback device",
@@ -126,20 +124,17 @@ void __init pci_iommu_alloc(void)
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
 #endif
+	if (pci_swiotlb_init())
+		return;
 
-	/*
-	 * The order of these functions is important for
-	 * fall-back/fail-over reasons
-	 */
 	gart_iommu_hole_init();
 
 	detect_calgary();
 
 	detect_intel_iommu();
 
+	/* needs to be called after gart_iommu_hole_init */
 	amd_iommu_detect();
-
-	pci_swiotlb_init();
 }
 
 void *dma_generic_alloc_coherent(struct device *dev, size_t size,
@@ -214,7 +209,7 @@ static __init int iommu_setup(char *p)
 		if (!strncmp(p, "allowdac", 8))
 			forbid_dac = 0;
 		if (!strncmp(p, "nodac", 5))
-			forbid_dac = -1;
+			forbid_dac = 1;
 		if (!strncmp(p, "usedac", 6)) {
 			forbid_dac = -1;
 			return 1;
@@ -289,25 +284,17 @@ static int __init pci_iommu_init(void)
 #ifdef CONFIG_PCI
 	dma_debug_add_bus(&pci_bus_type);
 #endif
+	x86_init.iommu.iommu_init();
 
-	calgary_iommu_init();
-
-	intel_iommu_init();
+	if (swiotlb) {
+		printk(KERN_INFO "PCI-DMA: "
+		       "Using software bounce buffering for IO (SWIOTLB)\n");
+		swiotlb_print_info();
+	} else
+		swiotlb_free();
 
-	amd_iommu_init();
-
-	gart_iommu_init();
-
-	no_iommu_init();
 	return 0;
 }
-
-void pci_iommu_shutdown(void)
-{
-	gart_iommu_shutdown();
-
-	amd_iommu_shutdown();
-}
 /* Must execute after PCI subsystem */
 rootfs_initcall(pci_iommu_init);
 
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index a7f1b64..e6a0d40 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -39,6 +39,7 @@
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
 #include <asm/k8.h>
+#include <asm/x86_init.h>
 
 static unsigned long iommu_bus_base;	/* GART remapping area (physical) */
 static unsigned long iommu_size;	/* size of remapping area bytes */
@@ -46,6 +47,8 @@ static unsigned long iommu_pages;	/* .. and in pages */
 
 static u32 *iommu_gatt_base;		/* Remapping table */
 
+static dma_addr_t bad_dma_addr;
+
 /*
  * If this is disabled the IOMMU will use an optimized flushing strategy
  * of only flushing when an mapping is reused. With it true the GART is
@@ -92,7 +95,7 @@ static unsigned long alloc_iommu(struct device *dev, int size,
 
 	base_index = ALIGN(iommu_bus_base & dma_get_seg_boundary(dev),
 			   PAGE_SIZE) >> PAGE_SHIFT;
-	boundary_size = ALIGN((unsigned long long)dma_get_seg_boundary(dev) + 1,
+	boundary_size = ALIGN((u64)dma_get_seg_boundary(dev) + 1,
 			      PAGE_SIZE) >> PAGE_SHIFT;
 
 	spin_lock_irqsave(&iommu_bitmap_lock, flags);
@@ -216,7 +219,7 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 		if (panic_on_overflow)
 			panic("dma_map_area overflow %lu bytes\n", size);
 		iommu_full(dev, size, dir);
-		return bad_dma_address;
+		return bad_dma_addr;
 	}
 
 	for (i = 0; i < npages; i++) {
@@ -294,7 +297,7 @@ static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
 	int i;
 
 #ifdef CONFIG_IOMMU_DEBUG
-	printk(KERN_DEBUG "dma_map_sg overflow\n");
+	pr_debug("dma_map_sg overflow\n");
 #endif
 
 	for_each_sg(sg, s, nents, i) {
@@ -302,7 +305,7 @@ static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
 
 		if (nonforced_iommu(dev, addr, s->length)) {
 			addr = dma_map_area(dev, addr, s->length, dir, 0);
-			if (addr == bad_dma_address) {
+			if (addr == bad_dma_addr) {
 				if (i > 0)
 					gart_unmap_sg(dev, sg, i, dir, NULL);
 				nents = 0;
@@ -389,12 +392,14 @@ static int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	if (!dev)
 		dev = &x86_dma_fallback_dev;
 
-	out = 0;
-	start = 0;
-	start_sg = sgmap = sg;
-	seg_size = 0;
-	max_seg_size = dma_get_max_seg_size(dev);
-	ps = NULL; /* shut up gcc */
+	out		= 0;
+	start		= 0;
+	start_sg	= sg;
+	sgmap		= sg;
+	seg_size	= 0;
+	max_seg_size	= dma_get_max_seg_size(dev);
+	ps		= NULL; /* shut up gcc */
+
 	for_each_sg(sg, s, nents, i) {
 		dma_addr_t addr = sg_phys(s);
 
@@ -417,11 +422,12 @@ static int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 						 sgmap, pages, need) < 0)
 					goto error;
 				out++;
-				seg_size = 0;
-				sgmap = sg_next(sgmap);
-				pages = 0;
-				start = i;
-				start_sg = s;
+
+				seg_size	= 0;
+				sgmap		= sg_next(sgmap);
+				pages		= 0;
+				start		= i;
+				start_sg	= s;
 			}
 		}
 
@@ -455,7 +461,7 @@ error:
 
 	iommu_full(dev, pages << PAGE_SHIFT, dir);
 	for_each_sg(sg, s, nents, i)
-		s->dma_address = bad_dma_address;
+		s->dma_address = bad_dma_addr;
 	return 0;
 }
 
@@ -479,7 +485,7 @@ gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
 				     DMA_BIDIRECTIONAL, align_mask);
 
 		flush_gart();
-		if (paddr != bad_dma_address) {
+		if (paddr != bad_dma_addr) {
 			*dma_addr = paddr;
 			return page_address(page);
 		}
@@ -499,6 +505,11 @@ gart_free_coherent(struct device *dev, size_t size, void *vaddr,
 	free_pages((unsigned long)vaddr, get_order(size));
 }
 
+static int gart_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	return (dma_addr == bad_dma_addr);
+}
+
 static int no_agp;
 
 static __init unsigned long check_iommu_size(unsigned long aper, u64 aper_size)
@@ -515,7 +526,7 @@ static __init unsigned long check_iommu_size(unsigned long aper, u64 aper_size)
 	iommu_size -= round_up(a, PMD_PAGE_SIZE) - a;
 
 	if (iommu_size < 64*1024*1024) {
-		printk(KERN_WARNING
+		pr_warning(
 			"PCI-DMA: Warning: Small IOMMU %luMB."
 			" Consider increasing the AGP aperture in BIOS\n",
 				iommu_size >> 20);
@@ -570,28 +581,32 @@ void set_up_gart_resume(u32 aper_order, u32 aper_alloc)
 	aperture_alloc = aper_alloc;
 }
 
-static int gart_resume(struct sys_device *dev)
+static void gart_fixup_northbridges(struct sys_device *dev)
 {
-	printk(KERN_INFO "PCI-DMA: Resuming GART IOMMU\n");
+	int i;
 
-	if (fix_up_north_bridges) {
-		int i;
+	if (!fix_up_north_bridges)
+		return;
 
-		printk(KERN_INFO "PCI-DMA: Restoring GART aperture settings\n");
+	pr_info("PCI-DMA: Restoring GART aperture settings\n");
 
-		for (i = 0; i < num_k8_northbridges; i++) {
-			struct pci_dev *dev = k8_northbridges[i];
+	for (i = 0; i < num_k8_northbridges; i++) {
+		struct pci_dev *dev = k8_northbridges[i];
 
-			/*
-			 * Don't enable translations just yet.  That is the next
-			 * step.  Restore the pre-suspend aperture settings.
-			 */
-			pci_write_config_dword(dev, AMD64_GARTAPERTURECTL,
-						aperture_order << 1);
-			pci_write_config_dword(dev, AMD64_GARTAPERTUREBASE,
-						aperture_alloc >> 25);
-		}
+		/*
+		 * Don't enable translations just yet.  That is the next
+		 * step.  Restore the pre-suspend aperture settings.
+		 */
+		pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, aperture_order << 1);
+		pci_write_config_dword(dev, AMD64_GARTAPERTUREBASE, aperture_alloc >> 25);
 	}
+}
+
+static int gart_resume(struct sys_device *dev)
+{
+	pr_info("PCI-DMA: Resuming GART IOMMU\n");
+
+	gart_fixup_northbridges(dev);
 
 	enable_gart_translations();
 
@@ -604,15 +619,14 @@ static int gart_suspend(struct sys_device *dev, pm_message_t state)
 }
 
 static struct sysdev_class gart_sysdev_class = {
-	.name = "gart",
-	.suspend = gart_suspend,
-	.resume = gart_resume,
+	.name		= "gart",
+	.suspend	= gart_suspend,
+	.resume		= gart_resume,
 
 };
 
 static struct sys_device device_gart = {
-	.id	= 0,
-	.cls	= &gart_sysdev_class,
+	.cls		= &gart_sysdev_class,
 };
 
 /*
@@ -627,7 +641,8 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 	void *gatt;
 	int i, error;
 
-	printk(KERN_INFO "PCI-DMA: Disabling AGP.\n");
+	pr_info("PCI-DMA: Disabling AGP.\n");
+
 	aper_size = aper_base = info->aper_size = 0;
 	dev = NULL;
 	for (i = 0; i < num_k8_northbridges; i++) {
@@ -645,6 +660,7 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 	}
 	if (!aper_base)
 		goto nommu;
+
 	info->aper_base = aper_base;
 	info->aper_size = aper_size >> 20;
 
@@ -667,14 +683,14 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 
 	flush_gart();
 
-	printk(KERN_INFO "PCI-DMA: aperture base @ %x size %u KB\n",
+	pr_info("PCI-DMA: aperture base @ %x size %u KB\n",
 	       aper_base, aper_size>>10);
 
 	return 0;
 
  nommu:
 	/* Should not happen anymore */
-	printk(KERN_WARNING "PCI-DMA: More than 4GB of RAM and no IOMMU\n"
+	pr_warning("PCI-DMA: More than 4GB of RAM and no IOMMU\n"
 	       "falling back to iommu=soft.\n");
 	return -1;
 }
@@ -686,14 +702,15 @@ static struct dma_map_ops gart_dma_ops = {
 	.unmap_page			= gart_unmap_page,
 	.alloc_coherent			= gart_alloc_coherent,
 	.free_coherent			= gart_free_coherent,
+	.mapping_error			= gart_mapping_error,
 };
 
-void gart_iommu_shutdown(void)
+static void gart_iommu_shutdown(void)
 {
 	struct pci_dev *dev;
 	int i;
 
-	if (no_agp && (dma_ops != &gart_dma_ops))
+	if (no_agp)
 		return;
 
 	for (i = 0; i < num_k8_northbridges; i++) {
@@ -708,7 +725,7 @@ void gart_iommu_shutdown(void)
 	}
 }
 
-void __init gart_iommu_init(void)
+int __init gart_iommu_init(void)
 {
 	struct agp_kern_info info;
 	unsigned long iommu_start;
@@ -718,7 +735,7 @@ void __init gart_iommu_init(void)
 	long i;
 
 	if (cache_k8_northbridges() < 0 || num_k8_northbridges == 0)
-		return;
+		return 0;
 
 #ifndef CONFIG_AGP_AMD64
 	no_agp = 1;
@@ -730,35 +747,28 @@ void __init gart_iommu_init(void)
 		(agp_copy_info(agp_bridge, &info) < 0);
 #endif
 
-	if (swiotlb)
-		return;
-
-	/* Did we detect a different HW IOMMU? */
-	if (iommu_detected && !gart_iommu_aperture)
-		return;
-
 	if (no_iommu ||
 	    (!force_iommu && max_pfn <= MAX_DMA32_PFN) ||
 	    !gart_iommu_aperture ||
 	    (no_agp && init_k8_gatt(&info) < 0)) {
 		if (max_pfn > MAX_DMA32_PFN) {
-			printk(KERN_WARNING "More than 4GB of memory "
-			       "but GART IOMMU not available.\n");
-			printk(KERN_WARNING "falling back to iommu=soft.\n");
+			pr_warning("More than 4GB of memory but GART IOMMU not available.\n");
+			pr_warning("falling back to iommu=soft.\n");
 		}
-		return;
+		return 0;
 	}
 
 	/* need to map that range */
-	aper_size = info.aper_size << 20;
-	aper_base = info.aper_base;
-	end_pfn = (aper_base>>PAGE_SHIFT) + (aper_size>>PAGE_SHIFT);
+	aper_size	= info.aper_size << 20;
+	aper_base	= info.aper_base;
+	end_pfn		= (aper_base>>PAGE_SHIFT) + (aper_size>>PAGE_SHIFT);
+
 	if (end_pfn > max_low_pfn_mapped) {
 		start_pfn = (aper_base>>PAGE_SHIFT);
 		init_memory_mapping(start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT);
 	}
 
-	printk(KERN_INFO "PCI-DMA: using GART IOMMU.\n");
+	pr_info("PCI-DMA: using GART IOMMU.\n");
 	iommu_size = check_iommu_size(info.aper_base, aper_size);
 	iommu_pages = iommu_size >> PAGE_SHIFT;
 
@@ -773,8 +783,7 @@ void __init gart_iommu_init(void)
 
 		ret = dma_debug_resize_entries(iommu_pages);
 		if (ret)
-			printk(KERN_DEBUG
-			       "PCI-DMA: Cannot trace all the entries\n");
+			pr_debug("PCI-DMA: Cannot trace all the entries\n");
 	}
 #endif
 
@@ -784,15 +793,14 @@ void __init gart_iommu_init(void)
 	 */
 	iommu_area_reserve(iommu_gart_bitmap, 0, EMERGENCY_PAGES);
 
-	agp_memory_reserved = iommu_size;
-	printk(KERN_INFO
-	       "PCI-DMA: Reserving %luMB of IOMMU area in the AGP aperture\n",
+	pr_info("PCI-DMA: Reserving %luMB of IOMMU area in the AGP aperture\n",
 	       iommu_size >> 20);
 
-	iommu_start = aper_size - iommu_size;
-	iommu_bus_base = info.aper_base + iommu_start;
-	bad_dma_address = iommu_bus_base;
-	iommu_gatt_base = agp_gatt_table + (iommu_start>>PAGE_SHIFT);
+	agp_memory_reserved	= iommu_size;
+	iommu_start		= aper_size - iommu_size;
+	iommu_bus_base		= info.aper_base + iommu_start;
+	bad_dma_addr		= iommu_bus_base;
+	iommu_gatt_base		= agp_gatt_table + (iommu_start>>PAGE_SHIFT);
 
 	/*
 	 * Unmap the IOMMU part of the GART. The alias of the page is
@@ -814,7 +822,7 @@ void __init gart_iommu_init(void)
 	 * the pages as Not-Present:
 	 */
 	wbinvd();
-	
+
 	/*
 	 * Now all caches are flushed and we can safely enable
 	 * GART hardware.  Doing it early leaves the possibility
@@ -838,6 +846,10 @@ void __init gart_iommu_init(void)
 
 	flush_gart();
 	dma_ops = &gart_dma_ops;
+	x86_platform.iommu_shutdown = gart_iommu_shutdown;
+	swiotlb = 0;
+
+	return 0;
 }
 
 void __init gart_parse_options(char *p)
@@ -856,7 +868,7 @@ void __init gart_parse_options(char *p)
 #endif
 	if (isdigit(*p) && get_option(&p, &arg))
 		iommu_size = arg;
-	if (!strncmp(p, "fullflush", 8))
+	if (!strncmp(p, "fullflush", 9))
 		iommu_fullflush = 1;
 	if (!strncmp(p, "nofullflush", 11))
 		iommu_fullflush = 0;
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index a3933d4..22be12b 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -33,7 +33,7 @@ static dma_addr_t nommu_map_page(struct device *dev, struct page *page,
 	dma_addr_t bus = page_to_phys(page) + offset;
 	WARN_ON(size == 0);
 	if (!check_addr("map_single", dev, bus, size))
-		return bad_dma_address;
+		return DMA_ERROR_CODE;
 	flush_write_buffers();
 	return bus;
 }
@@ -103,12 +103,3 @@ struct dma_map_ops nommu_dma_ops = {
 	.sync_sg_for_device	= nommu_sync_sg_for_device,
 	.is_phys		= 1,
 };
-
-void __init no_iommu_init(void)
-{
-	if (dma_ops)
-		return;
-
-	force_iommu = 0; /* no HW IOMMU */
-	dma_ops = &nommu_dma_ops;
-}
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index aaa6b78..e3c0a66 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -42,18 +42,28 @@ static struct dma_map_ops swiotlb_dma_ops = {
 	.dma_supported = NULL,
 };
 
-void __init pci_swiotlb_init(void)
+/*
+ * pci_swiotlb_init - initialize swiotlb if necessary
+ *
+ * This returns non-zero if we are forced to use swiotlb (by the boot
+ * option).
+ */
+int __init pci_swiotlb_init(void)
 {
+	int use_swiotlb = swiotlb | swiotlb_force;
+
 	/* don't initialize swiotlb if iommu=off (no_iommu=1) */
 #ifdef CONFIG_X86_64
-	if ((!iommu_detected && !no_iommu && max_pfn > MAX_DMA32_PFN))
+	if (!no_iommu && max_pfn > MAX_DMA32_PFN)
 		swiotlb = 1;
 #endif
 	if (swiotlb_force)
 		swiotlb = 1;
+
 	if (swiotlb) {
-		printk(KERN_INFO "PCI-DMA: Using software bounce buffering for IO (SWIOTLB)\n");
-		swiotlb_init();
+		swiotlb_init(0);
 		dma_ops = &swiotlb_dma_ops;
 	}
+
+	return use_swiotlb;
 }
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index f930787..2b97fc5 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -23,7 +23,7 @@
 # include <linux/ctype.h>
 # include <linux/mc146818rtc.h>
 #else
-# include <asm/iommu.h>
+# include <asm/x86_init.h>
 #endif
 
 /*
@@ -622,7 +622,7 @@ void native_machine_shutdown(void)
 #endif
 
 #ifdef CONFIG_X86_64
-	pci_iommu_shutdown();
+	x86_platform.iommu_shutdown();
 #endif
 }
 
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 4449a4a..d11c5ff 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -14,10 +14,13 @@
 #include <asm/time.h>
 #include <asm/irq.h>
 #include <asm/tsc.h>
+#include <asm/iommu.h>
 
 void __cpuinit x86_init_noop(void) { }
 void __init x86_init_uint_noop(unsigned int unused) { }
 void __init x86_init_pgd_noop(pgd_t *unused) { }
+int __init iommu_init_noop(void) { return 0; }
+void iommu_shutdown_noop(void) { }
 
 /*
  * The platform setup functions are preset with the default functions
@@ -62,6 +65,10 @@ struct x86_init_ops x86_init __initdata = {
 		.tsc_pre_init		= x86_init_noop,
 		.timer_init		= hpet_time_init,
 	},
+
+	.iommu = {
+		.iommu_init		= iommu_init_noop,
+	},
 };
 
 struct x86_cpuinit_ops x86_cpuinit __cpuinitdata = {
@@ -72,4 +79,5 @@ struct x86_platform_ops x86_platform = {
 	.calibrate_tsc			= native_calibrate_tsc,
 	.get_wallclock			= mach_get_cmos_time,
 	.set_wallclock			= mach_set_rtc_mmss,
+	.iommu_shutdown			= iommu_shutdown_noop,
 };
diff --git a/drivers/char/agp/Kconfig b/drivers/char/agp/Kconfig
index ccb1fa8..2fb3a48 100644
--- a/drivers/char/agp/Kconfig
+++ b/drivers/char/agp/Kconfig
@@ -56,9 +56,8 @@ config AGP_AMD
 	  X on AMD Irongate, 761, and 762 chipsets.
 
 config AGP_AMD64
-	tristate "AMD Opteron/Athlon64 on-CPU GART support" if !GART_IOMMU
+	tristate "AMD Opteron/Athlon64 on-CPU GART support"
 	depends on AGP && X86
-	default y if GART_IOMMU
 	help
 	  This option gives you AGP support for the GLX component of
 	  X using the on-CPU northbridge of the AMD Athlon64/Opteron CPUs.
diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 22b02c6..4373996 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -613,10 +613,13 @@ void __init detect_intel_iommu(void)
 			       "x2apic and Intr-remapping.\n");
 #endif
 #ifdef CONFIG_DMAR
-		if (ret && !no_iommu && !iommu_detected && !swiotlb &&
-		    !dmar_disabled)
+		if (ret && !no_iommu && !iommu_detected && !dmar_disabled)
 			iommu_detected = 1;
 #endif
+#ifdef CONFIG_X86
+		if (ret)
+			x86_init.iommu.iommu_init = intel_iommu_init;
+#endif
 	}
 	early_acpi_os_unmap_memory(dmar_tbl, dmar_tbl_size);
 	dmar_tbl = NULL;
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index b1e97e6..43d755a 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3231,7 +3231,7 @@ int __init intel_iommu_init(void)
 	 * Check the need for DMA-remapping initialization now.
 	 * Above initialization will also be used by Interrupt-remapping.
 	 */
-	if (no_iommu || swiotlb || dmar_disabled)
+	if (no_iommu || dmar_disabled)
 		return -ENODEV;
 
 	iommu_init_mempool();
@@ -3252,7 +3252,9 @@ int __init intel_iommu_init(void)
 	"PCI-DMA: Intel(R) Virtualization Technology for Directed I/O\n");
 
 	init_timer(&unmap_timer);
-	force_iommu = 1;
+#ifdef CONFIG_SWIOTLB
+	swiotlb = 0;
+#endif
 	dma_ops = &intel_dma_ops;
 
 	init_iommu_sysfs();
diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index dd97fb8..b10ec49 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -53,6 +53,7 @@ extern void free_bootmem_node(pg_data_t *pgdat,
 			      unsigned long addr,
 			      unsigned long size);
 extern void free_bootmem(unsigned long addr, unsigned long size);
+extern void free_bootmem_late(unsigned long addr, unsigned long size);
 
 /*
  * Flags for reserve_bootmem (also if CONFIG_HAVE_ARCH_BOOTMEM_NODE,
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 4a2b162..5de4c9e 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -208,16 +208,9 @@ struct dmar_atsr_unit {
 	u8 include_all:1;		/* include all ports */
 };
 
-/* Intel DMAR  initialization functions */
 extern int intel_iommu_init(void);
-#else
-static inline int intel_iommu_init(void)
-{
-#ifdef CONFIG_INTR_REMAP
-	return dmar_dev_scope_init();
-#else
-	return -ENODEV;
-#endif
-}
-#endif /* !CONFIG_DMAR */
+#else /* !CONFIG_DMAR: */
+static inline int intel_iommu_init(void) { return -ENODEV; }
+#endif /* CONFIG_DMAR */
+
 #endif /* __DMAR_H__ */
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 73b1f1c..febedcf 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -7,6 +7,8 @@ struct device;
 struct dma_attrs;
 struct scatterlist;
 
+extern int swiotlb_force;
+
 /*
  * Maximum allowable number of contiguous slabs to map,
  * must be a power of 2.  What is the appropriate value ?
@@ -20,8 +22,7 @@ struct scatterlist;
  */
 #define IO_TLB_SHIFT 11
 
-extern void
-swiotlb_init(void);
+extern void swiotlb_init(int verbose);
 
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
@@ -88,4 +89,11 @@ swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
 extern int
 swiotlb_dma_supported(struct device *hwdev, u64 mask);
 
+#ifdef CONFIG_SWIOTLB
+extern void __init swiotlb_free(void);
+#else
+static inline void swiotlb_free(void) { }
+#endif
+
+extern void swiotlb_print_info(void);
 #endif /* __LINUX_SWIOTLB_H */
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index ac25cd2..795472d 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -97,6 +97,8 @@ static phys_addr_t *io_tlb_orig_addr;
  */
 static DEFINE_SPINLOCK(io_tlb_lock);
 
+static int late_alloc;
+
 static int __init
 setup_io_tlb_npages(char *str)
 {
@@ -109,6 +111,7 @@ setup_io_tlb_npages(char *str)
 		++str;
 	if (!strcmp(str, "force"))
 		swiotlb_force = 1;
+
 	return 1;
 }
 __setup("swiotlb=", setup_io_tlb_npages);
@@ -121,8 +124,9 @@ static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
 	return phys_to_dma(hwdev, virt_to_phys(address));
 }
 
-static void swiotlb_print_info(unsigned long bytes)
+void swiotlb_print_info(void)
 {
+	unsigned long bytes = io_tlb_nslabs << IO_TLB_SHIFT;
 	phys_addr_t pstart, pend;
 
 	pstart = virt_to_phys(io_tlb_start);
@@ -140,7 +144,7 @@ static void swiotlb_print_info(unsigned long bytes)
  * structures for the software IO TLB used to implement the DMA API.
  */
 void __init
-swiotlb_init_with_default_size(size_t default_size)
+swiotlb_init_with_default_size(size_t default_size, int verbose)
 {
 	unsigned long i, bytes;
 
@@ -176,14 +180,14 @@ swiotlb_init_with_default_size(size_t default_size)
 	io_tlb_overflow_buffer = alloc_bootmem_low(io_tlb_overflow);
 	if (!io_tlb_overflow_buffer)
 		panic("Cannot allocate SWIOTLB overflow buffer!\n");
-
-	swiotlb_print_info(bytes);
+	if (verbose)
+		swiotlb_print_info();
 }
 
 void __init
-swiotlb_init(void)
+swiotlb_init(int verbose)
 {
-	swiotlb_init_with_default_size(64 * (1<<20));	/* default to 64MB */
+	swiotlb_init_with_default_size(64 * (1<<20), verbose);	/* default to 64MB */
 }
 
 /*
@@ -260,7 +264,9 @@ swiotlb_late_init_with_default_size(size_t default_size)
 	if (!io_tlb_overflow_buffer)
 		goto cleanup4;
 
-	swiotlb_print_info(bytes);
+	swiotlb_print_info();
+
+	late_alloc = 1;
 
 	return 0;
 
@@ -281,6 +287,32 @@ cleanup1:
 	return -ENOMEM;
 }
 
+void __init swiotlb_free(void)
+{
+	if (!io_tlb_overflow_buffer)
+		return;
+
+	if (late_alloc) {
+		free_pages((unsigned long)io_tlb_overflow_buffer,
+			   get_order(io_tlb_overflow));
+		free_pages((unsigned long)io_tlb_orig_addr,
+			   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
+		free_pages((unsigned long)io_tlb_list, get_order(io_tlb_nslabs *
+								 sizeof(int)));
+		free_pages((unsigned long)io_tlb_start,
+			   get_order(io_tlb_nslabs << IO_TLB_SHIFT));
+	} else {
+		free_bootmem_late(__pa(io_tlb_overflow_buffer),
+				  io_tlb_overflow);
+		free_bootmem_late(__pa(io_tlb_orig_addr),
+				  io_tlb_nslabs * sizeof(phys_addr_t));
+		free_bootmem_late(__pa(io_tlb_list),
+				  io_tlb_nslabs * sizeof(int));
+		free_bootmem_late(__pa(io_tlb_start),
+				  io_tlb_nslabs << IO_TLB_SHIFT);
+	}
+}
+
 static int is_swiotlb_buffer(phys_addr_t paddr)
 {
 	return paddr >= virt_to_phys(io_tlb_start) &&
diff --git a/mm/bootmem.c b/mm/bootmem.c
index 555d5d2..d1dc23c 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -143,6 +143,30 @@ unsigned long __init init_bootmem(unsigned long start, unsigned long pages)
 	return init_bootmem_core(NODE_DATA(0)->bdata, start, 0, pages);
 }
 
+/*
+ * free_bootmem_late - free bootmem pages directly to page allocator
+ * @addr: starting address of the range
+ * @size: size of the range in bytes
+ *
+ * This is only useful when the bootmem allocator has already been torn
+ * down, but we are still initializing the system.  Pages are given directly
+ * to the page allocator, no bootmem metadata is updated because it is gone.
+ */
+void __init free_bootmem_late(unsigned long addr, unsigned long size)
+{
+	unsigned long cursor, end;
+
+	kmemleak_free_part(__va(addr), size);
+
+	cursor = PFN_UP(addr);
+	end = PFN_DOWN(addr + size);
+
+	for (; cursor < end; cursor++) {
+		__free_pages_bootmem(pfn_to_page(cursor), 0);
+		totalram_pages++;
+	}
+}
+
 static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 {
 	int aligned;
