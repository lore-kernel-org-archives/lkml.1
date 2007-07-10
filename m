Return-Path: <linux-kernel-owner+w=401wt.eu-S1763930AbXGJJEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763930AbXGJJEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763681AbXGJJEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:04:22 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:25980 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762122AbXGJJEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:04:20 -0400
Date: Tue, 10 Jul 2007 11:04:19 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: intel iommu (Re: -mm merge plans for 2.6.23)
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707101058390.11053@fbirervta.pbzchgretzou.qr>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 10 2007 01:31, Andrew Morton wrote:

>intel-iommu-dmar-detection-and-parsing-logic.patch
>intel-iommu-pci-generic-helper-function.patch
>intel-iommu-clflush_cache_range-now-takes-size-param.patch
>intel-iommu-iova-allocation-and-management-routines.patch
>intel-iommu-intel-iommu-driver.patch
>intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
>intel-iommu-intel-iommu-cmdline-option-forcedac.patch
>intel-iommu-dmar-fault-handling-support.patch
>intel-iommu-iommu-gfx-workaround.patch
>intel-iommu-iommu-floppy-workaround.patch

Here's some fix:


Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 arch/x86_64/Kconfig |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: linux-2.6.22-rc6/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.22-rc6.orig/arch/x86_64/Kconfig
+++ linux-2.6.22-rc6/arch/x86_64/Kconfig
@@ -753,11 +753,11 @@ config DMAR
 	depends on PCI_MSI && ACPI && EXPERIMENTAL
 	default y
 	help
-	  DMA remapping(DMAR) devices support enables independent address
-	  translations for Direct Memory Access(DMA) from Devices.
+	  DMA remapping (DMAR) devices support enables independent address
+	  translations for Direct Memory Access (DMA) from devices.
 	  These DMA remapping devices are reported via ACPI tables
-	  and includes pci device scope covered by these DMA
-	  remapping device.
+	  and include PCI device scope covered by these DMA
+	  remapping devices.
 
 config DMAR_GFX_WA
 	bool "Support for Graphics workaround"
@@ -765,9 +765,9 @@ config DMAR_GFX_WA
 	default y
 	help
 	 Current Graphics drivers tend to use physical address
-	 for DMA and avoid using DMA api's. Setting this config
+	 for DMA and avoid using DMA APIs. Setting this config
 	 option permits the IOMMU driver to set a unity map for
-	 all the OS visible memory. Hence the driver can continue
+	 all the OS-visible memory. Hence the driver can continue
 	 to use physical addresses for DMA.
 
 config DMAR_FLOPPY_WA
@@ -775,10 +775,10 @@ config DMAR_FLOPPY_WA
 	depends on DMAR
 	default y
 	help
-	 Floppy disk drivers are know to by pass dma api calls
-	 their by failing to work when IOMMU is enabled. This
-	 work around will setup a 1 to 1 mappings for the first
-	 16M to make floppy(isa device) work.
+	 Floppy disk drivers are know to bypass DMA API calls
+	 thereby failing to work when IOMMU is enabled. This
+	 workaround will setup a 1:1 mapping for the first
+	 16M to make floppy (an ISA device) work.
 
 source "drivers/pci/pcie/Kconfig"
 
