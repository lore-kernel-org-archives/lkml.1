Return-Path: <linux-kernel-owner+w=401wt.eu-S1762964AbXKIGGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762964AbXKIGGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 01:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbXKIGEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 01:04:06 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52888 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751460AbXKIGEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 01:04:04 -0500
Date: Fri, 9 Nov 2007 07:03:38 +0100
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86 pci-dma_64.c: cleanups
Message-ID: <20071109060338.GY26163@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- make the needlessly global iommu_setup() static
- remove the unused EXPORT_SYMBOL(iommu_merge)

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/x86/kernel/pci-dma_64.c |    3 +--
 include/asm-x86/pci_64.h     |    1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

90fe7f396f3428a83dd5301f3d9622e32fb3bac5 
diff --git a/arch/x86/kernel/pci-dma_64.c b/arch/x86/kernel/pci-dma_64.c
index aa805b1..516f85f 100644
--- a/arch/x86/kernel/pci-dma_64.c
+++ b/arch/x86/kernel/pci-dma_64.c
@@ -13,7 +13,6 @@
 #include <asm/calgary.h>
 
 int iommu_merge __read_mostly = 1;
-EXPORT_SYMBOL(iommu_merge);
 
 dma_addr_t bad_dma_address __read_mostly;
 EXPORT_SYMBOL(bad_dma_address);
@@ -230,7 +229,7 @@ EXPORT_SYMBOL(dma_set_mask);
  * See <Documentation/x86_64/boot-options.txt> for the iommu kernel parameter
  * documentation.
  */
-__init int iommu_setup(char *p)
+static __init int iommu_setup(char *p)
 {
 	iommu_merge = 1;
 
diff --git a/include/asm-x86/pci_64.h b/include/asm-x86/pci_64.h
index ef54226..3746903 100644
--- a/include/asm-x86/pci_64.h
+++ b/include/asm-x86/pci_64.h
@@ -26,7 +26,6 @@ extern int (*pci_config_write)(int seg, int bus, int dev, int fn, int reg, int l
 
 
 extern void pci_iommu_alloc(void);
-extern int iommu_setup(char *opt);
 
 /* The PCI address space does equal the physical memory
  * address space.  The networking and block device layers use

