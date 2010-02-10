Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab0BJBjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:39:06 -0500
Received: from sh.osrg.net ([192.16.179.4]:54797 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954Ab0BJBjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:39:04 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 -mm 14/14] add linux/pci-dma.h to linux/pci.h
Date: Wed, 10 Feb 2010 10:34:47 +0900
Message-Id: <1265765687-14121-15-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 10 Feb 2010 10:38:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the architectures properly set NEED_DMA_MAP_STATE now so we can
safely add linux/pci-dma.h to linux/pci.h and remove the
linux/pci-dma.h inclusion in arch's asm/pci.h

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 arch/alpha/include/asm/pci.h   |    2 --
 arch/arm/include/asm/pci.h     |    2 --
 arch/cris/include/asm/pci.h    |    2 --
 arch/frv/include/asm/pci.h     |    2 --
 arch/ia64/include/asm/pci.h    |    2 --
 arch/mips/include/asm/pci.h    |    2 --
 arch/parisc/include/asm/pci.h  |    2 --
 arch/powerpc/include/asm/pci.h |    2 --
 arch/sh/include/asm/pci.h      |    2 --
 arch/sparc/include/asm/pci.h   |    2 --
 arch/x86/include/asm/pci.h     |    2 --
 arch/xtensa/include/asm/pci.h  |    2 --
 include/linux/pci.h            |    1 +
 13 files changed, 1 insertions(+), 24 deletions(-)

diff --git a/arch/alpha/include/asm/pci.h b/arch/alpha/include/asm/pci.h
index 4765946..e1846ba 100644
--- a/arch/alpha/include/asm/pci.h
+++ b/arch/alpha/include/asm/pci.h
@@ -119,8 +119,6 @@ pci_dma_mapping_error(struct pci_dev *pdev, dma_addr_t dma_addr)
 extern void pci_unmap_single(struct pci_dev *, dma_addr_t, size_t, int);
 extern void pci_unmap_page(struct pci_dev *, dma_addr_t, size_t, int);
 
-#include <linux/pci-dma.h>
-
 /* Map a set of buffers described by scatterlist in streaming mode for
    PCI DMA.  This is the scatter-gather version of the above
    pci_map_single interface.  Here the scatter gather list elements
diff --git a/arch/arm/include/asm/pci.h b/arch/arm/include/asm/pci.h
index aea3450..4798011 100644
--- a/arch/arm/include/asm/pci.h
+++ b/arch/arm/include/asm/pci.h
@@ -30,8 +30,6 @@ static inline void pcibios_penalize_isa_irq(int irq, int active)
  */
 #define PCI_DMA_BUS_IS_PHYS     (1)
 
-#include <linux/pci-dma.h>
-
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 					enum pci_dma_burst_strategy *strat,
diff --git a/arch/cris/include/asm/pci.h b/arch/cris/include/asm/pci.h
index 43cfa0c..9f1cd56 100644
--- a/arch/cris/include/asm/pci.h
+++ b/arch/cris/include/asm/pci.h
@@ -44,8 +44,6 @@ struct pci_dev;
  */
 #define PCI_DMA_BUS_IS_PHYS	(1)
 
-#include <linux/pci-dma.h>
-
 #define HAVE_PCI_MMAP
 extern int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 			       enum pci_mmap_state mmap_state, int write_combine);
diff --git a/arch/frv/include/asm/pci.h b/arch/frv/include/asm/pci.h
index 05db569..0d59979 100644
--- a/arch/frv/include/asm/pci.h
+++ b/arch/frv/include/asm/pci.h
@@ -43,8 +43,6 @@ extern void pci_free_consistent(struct pci_dev *hwdev, size_t size,
 /* Return the index of the PCI controller for device PDEV. */
 #define pci_controller_num(PDEV)	(0)
 
-#include <linux/pci-dma.h>
-
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 					enum pci_dma_burst_strategy *strat,
diff --git a/arch/ia64/include/asm/pci.h b/arch/ia64/include/asm/pci.h
index 4adf227..73b5f78 100644
--- a/arch/ia64/include/asm/pci.h
+++ b/arch/ia64/include/asm/pci.h
@@ -56,8 +56,6 @@ pcibios_penalize_isa_irq (int irq, int active)
 
 #include <asm-generic/pci-dma-compat.h>
 
-#include <linux/pci-dma.h>
-
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 					enum pci_dma_burst_strategy *strat,
diff --git a/arch/mips/include/asm/pci.h b/arch/mips/include/asm/pci.h
index 9b196f8..3beea14 100644
--- a/arch/mips/include/asm/pci.h
+++ b/arch/mips/include/asm/pci.h
@@ -102,8 +102,6 @@ struct pci_dev;
  */
 extern unsigned int PCI_DMA_BUS_IS_PHYS;
 
-#include <linux/pci-dma.h>
-
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 					enum pci_dma_burst_strategy *strat,
diff --git a/arch/parisc/include/asm/pci.h b/arch/parisc/include/asm/pci.h
index 632088d..2242a5c 100644
--- a/arch/parisc/include/asm/pci.h
+++ b/arch/parisc/include/asm/pci.h
@@ -183,8 +183,6 @@ struct pci_bios_ops {
 	void (*fixup_bus)(struct pci_bus *bus);
 };
 
-#include <linux/pci-dma.h>
-
 /*
 ** Stuff declared in arch/parisc/kernel/pci.c
 */
diff --git a/arch/powerpc/include/asm/pci.h b/arch/powerpc/include/asm/pci.h
index 4a9991b..a20a9ad 100644
--- a/arch/powerpc/include/asm/pci.h
+++ b/arch/powerpc/include/asm/pci.h
@@ -141,8 +141,6 @@ extern int pci_mmap_legacy_page_range(struct pci_bus *bus,
 
 #define HAVE_PCI_LEGACY	1
 
-#include <linux/pci-dma.h>
-
 #ifdef CONFIG_PPC64
 
 /* The PCI address space does not equal the physical memory address
diff --git a/arch/sh/include/asm/pci.h b/arch/sh/include/asm/pci.h
index 991c2a4..8bd952f 100644
--- a/arch/sh/include/asm/pci.h
+++ b/arch/sh/include/asm/pci.h
@@ -83,8 +83,6 @@ static inline void pcibios_penalize_isa_irq(int irq, int active)
  */
 #define PCI_DMA_BUS_IS_PHYS	(dma_ops->is_phys)
 
-#include <linux/pci-dma.h>
-
 #ifdef CONFIG_PCI
 /*
  * None of the SH PCI controllers support MWI, it is always treated as a
diff --git a/arch/sparc/include/asm/pci.h b/arch/sparc/include/asm/pci.h
index 5ce773e..d9c031f 100644
--- a/arch/sparc/include/asm/pci.h
+++ b/arch/sparc/include/asm/pci.h
@@ -6,8 +6,6 @@
 #include <asm/pci_32.h>
 #endif
 
-#include <linux/pci-dma.h>
-
 #include <asm-generic/pci-dma-compat.h>
 
 #endif
diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index d9bef0a..e1aa5a7 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -99,8 +99,6 @@ extern void pci_iommu_alloc(void);
 /* implement the pci_ DMA API in terms of the generic device dma_ one */
 #include <asm-generic/pci-dma-compat.h>
 
-#include <linux/pci-dma.h>
-
 /* generic pci stuff */
 #include <asm-generic/pci.h>
 #define PCIBIOS_MAX_MEM_32 0xffffffff
diff --git a/arch/xtensa/include/asm/pci.h b/arch/xtensa/include/asm/pci.h
index f3f0cf3..4609b0f 100644
--- a/arch/xtensa/include/asm/pci.h
+++ b/arch/xtensa/include/asm/pci.h
@@ -56,8 +56,6 @@ struct pci_dev;
 
 #define PCI_DMA_BUS_IS_PHYS	(1)
 
-#include <linux/pci-dma.h>
-
 /* Map a range of PCI memory or I/O space for a device into user space */
 int pci_mmap_page_range(struct pci_dev *pdev, struct vm_area_struct *vma,
                         enum pci_mmap_state mmap_state, int write_combine);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 4a02d84..67e2158 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -872,6 +872,7 @@ int pci_set_vga_state(struct pci_dev *pdev, bool decode,
 		      unsigned int command_bits, bool change_bridge);
 /* kmem_cache style wrapper around pci_alloc_consistent() */
 
+#include <linux/pci-dma.h>
 #include <linux/dmapool.h>
 
 #define	pci_pool dma_pool
-- 
1.5.6.5

