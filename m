Return-Path: <linux-kernel-owner+w=401wt.eu-S1761967AbZFQUnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761967AbZFQUnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757056AbZFQUmC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:42:02 -0400
Received: from ottawa-hs-64-26-170-27.d-ip.magma.ca ([64.26.170.27]:59298 "EHLO
	gonzo.int.wil.cx" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756248AbZFQUl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:41:57 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: torvalds@linux-foundation.org, jbarnes@virtuousgeek.org
Cc: andrew.patterson@hp.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 2/4] Delete pcibios_select_root
Date: Wed, 17 Jun 2009 16:33:34 -0400
Message-Id: <1245270816-11755-3-git-send-email-willy@linux.intel.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245270816-11755-1-git-send-email-willy@linux.intel.com>
References: <1245270816-11755-1-git-send-email-willy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function was only used by pci_claim_resource(), and the last commit
deleted that use.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 arch/alpha/include/asm/pci.h    |   13 -------------
 arch/arm/include/asm/pci.h      |   13 -------------
 arch/ia64/include/asm/pci.h     |   13 -------------
 arch/mips/include/asm/pci.h     |   13 -------------
 arch/mn10300/include/asm/pci.h  |   13 -------------
 arch/parisc/include/asm/pci.h   |   13 -------------
 arch/powerpc/include/asm/pci.h  |   13 -------------
 arch/sh/include/asm/pci.h       |   13 -------------
 arch/sparc/include/asm/pci_64.h |    2 --
 arch/sparc/kernel/pci.c         |   13 -------------
 include/asm-generic/pci.h       |   13 -------------
 11 files changed, 0 insertions(+), 132 deletions(-)

diff --git a/arch/alpha/include/asm/pci.h b/arch/alpha/include/asm/pci.h
index cb04eaa..d22ace9 100644
--- a/arch/alpha/include/asm/pci.h
+++ b/arch/alpha/include/asm/pci.h
@@ -237,19 +237,6 @@ extern void pcibios_resource_to_bus(struct pci_dev *, struct pci_bus_region *,
 extern void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
 				    struct pci_bus_region *region);
 
-static inline struct resource *
-pcibios_select_root(struct pci_dev *pdev, struct resource *res)
-{
-	struct resource *root = NULL;
-
-	if (res->flags & IORESOURCE_IO)
-		root = &ioport_resource;
-	if (res->flags & IORESOURCE_MEM)
-		root = &iomem_resource;
-
-	return root;
-}
-
 #define pci_domain_nr(bus) ((struct pci_controller *)(bus)->sysdata)->index
 
 static inline int pci_proc_domain(struct pci_bus *bus)
diff --git a/arch/arm/include/asm/pci.h b/arch/arm/include/asm/pci.h
index 918d0cb..0abf386 100644
--- a/arch/arm/include/asm/pci.h
+++ b/arch/arm/include/asm/pci.h
@@ -65,19 +65,6 @@ extern void
 pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
 			struct pci_bus_region *region);
 
-static inline struct resource *
-pcibios_select_root(struct pci_dev *pdev, struct resource *res)
-{
-	struct resource *root = NULL;
-
-	if (res->flags & IORESOURCE_IO)
-		root = &ioport_resource;
-	if (res->flags & IORESOURCE_MEM)
-		root = &iomem_resource;
-
-	return root;
-}
-
 /*
  * Dummy implementation; always return 0.
  */
diff --git a/arch/ia64/include/asm/pci.h b/arch/ia64/include/asm/pci.h
index 1d660d8..fcfca56 100644
--- a/arch/ia64/include/asm/pci.h
+++ b/arch/ia64/include/asm/pci.h
@@ -135,19 +135,6 @@ extern void pcibios_resource_to_bus(struct pci_dev *dev,
 extern void pcibios_bus_to_resource(struct pci_dev *dev,
 		struct resource *res, struct pci_bus_region *region);
 
-static inline struct resource *
-pcibios_select_root(struct pci_dev *pdev, struct resource *res)
-{
-	struct resource *root = NULL;
-
-	if (res->flags & IORESOURCE_IO)
-		root = &ioport_resource;
-	if (res->flags & IORESOURCE_MEM)
-		root = &iomem_resource;
-
-	return root;
-}
-
 #define pcibios_scan_all_fns(a, b)	0
 
 #define HAVE_ARCH_PCI_GET_LEGACY_IDE_IRQ
diff --git a/arch/mips/include/asm/pci.h b/arch/mips/include/asm/pci.h
index 053e463..a68d111 100644
--- a/arch/mips/include/asm/pci.h
+++ b/arch/mips/include/asm/pci.h
@@ -142,19 +142,6 @@ extern void pcibios_resource_to_bus(struct pci_dev *dev,
 extern void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
 				    struct pci_bus_region *region);
 
-static inline struct resource *
-pcibios_select_root(struct pci_dev *pdev, struct resource *res)
-{
-	struct resource *root = NULL;
-
-	if (res->flags & IORESOURCE_IO)
-		root = &ioport_resource;
-	if (res->flags & IORESOURCE_MEM)
-		root = &iomem_resource;
-
-	return root;
-}
-
 #define pci_domain_nr(bus) ((struct pci_controller *)(bus)->sysdata)->index
 
 static inline int pci_proc_domain(struct pci_bus *bus)
diff --git a/arch/mn10300/include/asm/pci.h b/arch/mn10300/include/asm/pci.h
index 0517b45..e58b9a4 100644
--- a/arch/mn10300/include/asm/pci.h
+++ b/arch/mn10300/include/asm/pci.h
@@ -106,19 +106,6 @@ extern void pcibios_bus_to_resource(struct pci_dev *dev,
 				    struct resource *res,
 				    struct pci_bus_region *region);
 
-static inline struct resource *
-pcibios_select_root(struct pci_dev *pdev, struct resource *res)
-{
-	struct resource *root = NULL;
-
-	if (res->flags & IORESOURCE_IO)
-		root = &ioport_resource;
-	if (res->flags & IORESOURCE_MEM)
-		root = &iomem_resource;
-
-	return root;
-}
-
 #define pcibios_scan_all_fns(a, b)	0
 
 static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
diff --git a/arch/parisc/include/asm/pci.h b/arch/parisc/include/asm/pci.h
index 4ba868f..7d842d6 100644
--- a/arch/parisc/include/asm/pci.h
+++ b/arch/parisc/include/asm/pci.h
@@ -268,19 +268,6 @@ extern void
 pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
 			struct pci_bus_region *region);
 
-static inline struct resource *
-pcibios_select_root(struct pci_dev *pdev, struct resource *res)
-{
-	struct resource *root = NULL;
-
-	if (res->flags & IORESOURCE_IO)
-		root = &ioport_resource;
-	if (res->flags & IORESOURCE_MEM)
-		root = &iomem_resource;
-
-	return root;
-}
-
 static inline void pcibios_penalize_isa_irq(int irq, int active)
 {
 	/* We don't need to penalize isa irq's */
diff --git a/arch/powerpc/include/asm/pci.h b/arch/powerpc/include/asm/pci.h
index ba17d5d..d9483c5 100644
--- a/arch/powerpc/include/asm/pci.h
+++ b/arch/powerpc/include/asm/pci.h
@@ -195,19 +195,6 @@ extern void pcibios_bus_to_resource(struct pci_dev *dev,
 			struct resource *res,
 			struct pci_bus_region *region);
 
-static inline struct resource *pcibios_select_root(struct pci_dev *pdev,
-			struct resource *res)
-{
-	struct resource *root = NULL;
-
-	if (res->flags & IORESOURCE_IO)
-		root = &ioport_resource;
-	if (res->flags & IORESOURCE_MEM)
-		root = &iomem_resource;
-
-	return root;
-}
-
 extern void pcibios_claim_one_bus(struct pci_bus *b);
 
 extern void pcibios_finish_adding_to_bus(struct pci_bus *bus);
diff --git a/arch/sh/include/asm/pci.h b/arch/sh/include/asm/pci.h
index ae0da6f..d3633f5 100644
--- a/arch/sh/include/asm/pci.h
+++ b/arch/sh/include/asm/pci.h
@@ -137,19 +137,6 @@ extern void pcibios_resource_to_bus(struct pci_dev *dev,
 extern void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
 				    struct pci_bus_region *region);
 
-static inline struct resource *
-pcibios_select_root(struct pci_dev *pdev, struct resource *res)
-{
-	struct resource *root = NULL;
-
-	if (res->flags & IORESOURCE_IO)
-		root = &ioport_resource;
-	if (res->flags & IORESOURCE_MEM)
-		root = &iomem_resource;
-
-	return root;
-}
-
 /* Chances are this interrupt is wired PC-style ...  */
 static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
 {
diff --git a/arch/sparc/include/asm/pci_64.h b/arch/sparc/include/asm/pci_64.h
index 4f79a54..7a1e356 100644
--- a/arch/sparc/include/asm/pci_64.h
+++ b/arch/sparc/include/asm/pci_64.h
@@ -191,8 +191,6 @@ extern void
 pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
 			struct pci_bus_region *region);
 
-extern struct resource *pcibios_select_root(struct pci_dev *, struct resource *);
-
 static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
 {
 	return PCI_IRQ_NONE;
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 4638fba..57859ad 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -711,19 +711,6 @@ void __devinit pcibios_fixup_bus(struct pci_bus *pbus)
 	pbus->resource[1] = &pbm->mem_space;
 }
 
-struct resource *pcibios_select_root(struct pci_dev *pdev, struct resource *r)
-{
-	struct pci_pbm_info *pbm = pdev->bus->sysdata;
-	struct resource *root = NULL;
-
-	if (r->flags & IORESOURCE_IO)
-		root = &pbm->io_space;
-	if (r->flags & IORESOURCE_MEM)
-		root = &pbm->mem_space;
-
-	return root;
-}
-
 void pcibios_update_irq(struct pci_dev *pdev, int irq)
 {
 }
diff --git a/include/asm-generic/pci.h b/include/asm-generic/pci.h
index 515c6e2..b4326b5 100644
--- a/include/asm-generic/pci.h
+++ b/include/asm-generic/pci.h
@@ -30,19 +30,6 @@ pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
 	res->end = region->end;
 }
 
-static inline struct resource *
-pcibios_select_root(struct pci_dev *pdev, struct resource *res)
-{
-	struct resource *root = NULL;
-
-	if (res->flags & IORESOURCE_IO)
-		root = &ioport_resource;
-	if (res->flags & IORESOURCE_MEM)
-		root = &iomem_resource;
-
-	return root;
-}
-
 #define pcibios_scan_all_fns(a, b)	0
 
 #ifndef HAVE_ARCH_PCI_GET_LEGACY_IDE_IRQ
-- 
1.6.3.1

