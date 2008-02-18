Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbYBRFQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbYBRFQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 00:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYBRFQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 00:16:49 -0500
Received: from ozlabs.org ([203.10.76.45]:45353 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbYBRFQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 00:16:48 -0500
To: Linux-Arch <linux-arch@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Mon, 18 Feb 2008 16:16:24 +1100
Subject: [PATCH] iomap: Fix 64 bits resources on 32 bits
Message-Id: <20080218051645.C38FDDDE35@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Almost all implementations of pci_iomap() in the kernel, including
the generic lib/iomap.c one, copies the content of a struct resource
into unsigned long's which will break on 32 bits platforms with 64
bits resources.

This fixes all definitions of pci_iomap() to use resource_size_t. I
also "fixed" the 64bits arch for consistency.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 arch/alpha/kernel/pci.c               |    4 ++--
 arch/arm/mm/iomap.c                   |    4 ++--
 arch/frv/mb93090-mb00/pci-iomap.c     |    4 ++--
 arch/mips/lib/iomap-pci.c             |    4 ++--
 arch/mn10300/unit-asb2305/pci-iomap.c |    4 ++--
 arch/parisc/lib/iomap.c               |    4 ++--
 arch/ppc/kernel/pci.c                 |    4 ++--
 arch/sh/drivers/pci/pci.c             |    4 ++--
 arch/sparc/lib/iomap.c                |    4 ++--
 arch/sparc64/lib/iomap.c              |    4 ++--
 arch/v850/kernel/rte_mb_a_pci.c       |    4 ++--
 lib/iomap.c                           |    4 ++--
 12 files changed, 24 insertions(+), 24 deletions(-)

--- linux-work.orig/lib/iomap.c	2008-02-18 15:22:46.000000000 +1100
+++ linux-work/lib/iomap.c	2008-02-18 16:08:36.000000000 +1100
@@ -256,8 +256,8 @@ EXPORT_SYMBOL(ioport_unmap);
  * */
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
Index: linux-work/arch/alpha/kernel/pci.c
===================================================================
--- linux-work.orig/arch/alpha/kernel/pci.c	2008-02-18 16:06:23.000000000 +1100
+++ linux-work/arch/alpha/kernel/pci.c	2008-02-18 16:08:01.000000000 +1100
@@ -547,8 +547,8 @@ sys_pciconfig_iobase(long which, unsigne
 
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
Index: linux-work/arch/arm/mm/iomap.c
===================================================================
--- linux-work.orig/arch/arm/mm/iomap.c	2008-02-18 16:01:57.000000000 +1100
+++ linux-work/arch/arm/mm/iomap.c	2008-02-18 16:08:19.000000000 +1100
@@ -26,8 +26,8 @@ EXPORT_SYMBOL(ioport_unmap);
 #ifdef CONFIG_PCI
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len   = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len   = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
Index: linux-work/arch/frv/mb93090-mb00/pci-iomap.c
===================================================================
--- linux-work.orig/arch/frv/mb93090-mb00/pci-iomap.c	2008-02-18 16:05:58.000000000 +1100
+++ linux-work/arch/frv/mb93090-mb00/pci-iomap.c	2008-02-18 16:08:10.000000000 +1100
@@ -13,8 +13,8 @@
 
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
Index: linux-work/arch/mips/lib/iomap-pci.c
===================================================================
--- linux-work.orig/arch/mips/lib/iomap-pci.c	2008-02-18 16:03:55.000000000 +1100
+++ linux-work/arch/mips/lib/iomap-pci.c	2008-02-18 16:11:54.000000000 +1100
@@ -45,8 +45,8 @@ static void __iomem *ioport_map_pci(stru
  */
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
Index: linux-work/arch/parisc/lib/iomap.c
===================================================================
--- linux-work.orig/arch/parisc/lib/iomap.c	2008-02-18 16:06:48.000000000 +1100
+++ linux-work/arch/parisc/lib/iomap.c	2008-02-18 16:07:54.000000000 +1100
@@ -438,8 +438,8 @@ void ioport_unmap(void __iomem *addr)
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
Index: linux-work/arch/sh/drivers/pci/pci.c
===================================================================
--- linux-work.orig/arch/sh/drivers/pci/pci.c	2008-02-18 16:03:02.000000000 +1100
+++ linux-work/arch/sh/drivers/pci/pci.c	2008-02-18 16:12:18.000000000 +1100
@@ -191,8 +191,8 @@ void __init pcibios_update_irq(struct pc
 
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (unlikely(!len || !start))
Index: linux-work/arch/mn10300/unit-asb2305/pci-iomap.c
===================================================================
--- linux-work.orig/arch/mn10300/unit-asb2305/pci-iomap.c	2008-02-18 16:11:14.000000000 +1100
+++ linux-work/arch/mn10300/unit-asb2305/pci-iomap.c	2008-02-18 16:11:22.000000000 +1100
@@ -16,8 +16,8 @@
  */
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
Index: linux-work/arch/ppc/kernel/pci.c
===================================================================
--- linux-work.orig/arch/ppc/kernel/pci.c	2008-02-18 16:08:54.000000000 +1100
+++ linux-work/arch/ppc/kernel/pci.c	2008-02-18 16:09:41.000000000 +1100
@@ -1176,8 +1176,8 @@ void __init pci_init_resource(struct res
 
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len)
Index: linux-work/arch/sparc/lib/iomap.c
===================================================================
--- linux-work.orig/arch/sparc/lib/iomap.c	2008-02-18 16:10:02.000000000 +1100
+++ linux-work/arch/sparc/lib/iomap.c	2008-02-18 16:10:09.000000000 +1100
@@ -21,8 +21,8 @@ EXPORT_SYMBOL(ioport_unmap);
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
Index: linux-work/arch/sparc64/lib/iomap.c
===================================================================
--- linux-work.orig/arch/sparc64/lib/iomap.c	2008-02-18 16:10:19.000000000 +1100
+++ linux-work/arch/sparc64/lib/iomap.c	2008-02-18 16:10:26.000000000 +1100
@@ -21,8 +21,8 @@ EXPORT_SYMBOL(ioport_unmap);
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 {
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
 	if (!len || !start)
Index: linux-work/arch/v850/kernel/rte_mb_a_pci.c
===================================================================
--- linux-work.orig/arch/v850/kernel/rte_mb_a_pci.c	2008-02-18 16:10:37.000000000 +1100
+++ linux-work/arch/v850/kernel/rte_mb_a_pci.c	2008-02-18 16:10:47.000000000 +1100
@@ -790,8 +790,8 @@ pci_free_consistent (struct pci_dev *pde
 
 void __iomem *pci_iomap (struct pci_dev *dev, int bar, unsigned long max)
 {
-	unsigned long start = pci_resource_start (dev, bar);
-	unsigned long len = pci_resource_len (dev, bar);
+	resource_size_t start = pci_resource_start (dev, bar);
+	resource_size_t len = pci_resource_len (dev, bar);
 
 	if (!start || len == 0)
 		return 0;
