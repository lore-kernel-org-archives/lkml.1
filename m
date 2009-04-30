Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbZD3TE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbZD3TE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 15:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764909AbZD3TDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 15:03:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:63277 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761552AbZD3TC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 15:02:57 -0400
Message-Id: <20090430185716.955681783@arndb.de>
References: <20090430185628.866082445@arndb.de>
User-Agent: quilt/0.46-1
Date: Thu, 30 Apr 2009 20:56:32 +0200
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: [PATCH v2 4/9] asm-generic: make pci.h usable directly
Content-Disposition: inline; filename=0004-asm-generic-make-pci.h-usable-directly.patch
X-Provags-ID: V01U2FsdGVkX1/LQWB3PclPBq54ndsoL5zsm/6qpm9kwyq+Rnv
 vu07kS6DiqIlWSQS2TsCNxPU9I2AHg+YmgBciO37pjjkECCLhK
 IOq11pcb38xtXplH9dC4g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some generic code is using the horribly misnamed PCI_DMA_BUS_IS_PHYS
from asm/pci.h. This makes sure that an architecture without PCI
support does not have to define this itself but can rely on the
asm-generic version.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
---
 arch/frv/include/asm/pci.h  |   13 +++----------
 arch/m32r/include/asm/pci.h |    2 --
 include/asm-generic/pci.h   |    8 ++++++++
 3 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/frv/include/asm/pci.h b/arch/frv/include/asm/pci.h
index 585d9b4..3ce227b 100644
--- a/arch/frv/include/asm/pci.h
+++ b/arch/frv/include/asm/pci.h
@@ -10,8 +10,8 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#ifndef ASM_PCI_H
-#define	ASM_PCI_H
+#ifndef _ASM_FRV_PCI_H
+#define _ASM_FRV_PCI_H
 
 #include <linux/mm.h>
 #include <asm/scatterlist.h>
@@ -43,12 +43,6 @@ extern void pci_free_consistent(struct pci_dev *hwdev, size_t size,
 /* Return the index of the PCI controller for device PDEV. */
 #define pci_controller_num(PDEV)	(0)
 
-/* The PCI address space does equal the physical memory
- * address space.  The networking and block device layers use
- * this boolean for bounce buffer decisions.
- */
-#define PCI_DMA_BUS_IS_PHYS	(1)
-
 /* pci_unmap_{page,single} is a nop so... */
 #define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
 #define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
@@ -114,5 +108,4 @@ static inline void pci_dma_sync_sg(struct pci_dev *hwdev,
 				    sg_dma_address(&sg[i])+sg_dma_len(&sg[i]));
 }
 
-
-#endif
+#endif /* _ASM_FRV_PCI_H */
diff --git a/arch/m32r/include/asm/pci.h b/arch/m32r/include/asm/pci.h
index fe785d1..07d3834 100644
--- a/arch/m32r/include/asm/pci.h
+++ b/arch/m32r/include/asm/pci.h
@@ -3,6 +3,4 @@
 
 #include <asm-generic/pci.h>
 
-#define PCI_DMA_BUS_IS_PHYS	(1)
-
 #endif /* _ASM_M32R_PCI_H */
diff --git a/include/asm-generic/pci.h b/include/asm-generic/pci.h
index c36a77d..515c6e2 100644
--- a/include/asm-generic/pci.h
+++ b/include/asm-generic/pci.h
@@ -52,4 +52,12 @@ static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
 }
 #endif /* HAVE_ARCH_PCI_GET_LEGACY_IDE_IRQ */
 
+/*
+ * By default, assume that no iommu is in use and that the PCI
+ * space is mapped to address physical 0.
+ */
+#ifndef PCI_DMA_BUS_IS_PHYS
+#define PCI_DMA_BUS_IS_PHYS	(1)
 #endif
+
+#endif /* _ASM_GENERIC_PCI_H */
-- 
1.5.6.3

-- 

