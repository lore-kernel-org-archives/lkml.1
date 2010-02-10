Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab0BJBlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:41:14 -0500
Received: from sh.osrg.net ([192.16.179.4]:54822 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314Ab0BJBj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:39:26 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v2 -mm 11/14] sparc: use include/linux/pci-dma.h
Date: Wed, 10 Feb 2010 10:34:44 +0900
Message-Id: <1265765687-14121-12-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 10 Feb 2010 10:38:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: David S. Miller <davem@davemloft.net>
---
 arch/sparc/Kconfig              |    3 +++
 arch/sparc/include/asm/pci.h    |    2 ++
 arch/sparc/include/asm/pci_32.h |   14 --------------
 arch/sparc/include/asm/pci_64.h |   14 --------------
 4 files changed, 5 insertions(+), 28 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 4097f6a..6db5136 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -127,6 +127,9 @@ config ZONE_DMA
 	bool
 	default y if SPARC32
 
+config NEED_DMA_MAP_STATE
+	def_bool y
+
 config GENERIC_ISA_DMA
 	bool
 	default y if SPARC32
diff --git a/arch/sparc/include/asm/pci.h b/arch/sparc/include/asm/pci.h
index d9c031f..5ce773e 100644
--- a/arch/sparc/include/asm/pci.h
+++ b/arch/sparc/include/asm/pci.h
@@ -6,6 +6,8 @@
 #include <asm/pci_32.h>
 #endif
 
+#include <linux/pci-dma.h>
+
 #include <asm-generic/pci-dma-compat.h>
 
 #endif
diff --git a/arch/sparc/include/asm/pci_32.h b/arch/sparc/include/asm/pci_32.h
index e769f66..332ac9a 100644
--- a/arch/sparc/include/asm/pci_32.h
+++ b/arch/sparc/include/asm/pci_32.h
@@ -32,20 +32,6 @@ static inline void pcibios_penalize_isa_irq(int irq, int active)
 
 struct pci_dev;
 
-/* pci_unmap_{single,page} is not a nop, thus... */
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	\
-	dma_addr_t ADDR_NAME;
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)		\
-	__u32 LEN_NAME;
-#define pci_unmap_addr(PTR, ADDR_NAME)			\
-	((PTR)->ADDR_NAME)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)		\
-	(((PTR)->ADDR_NAME) = (VAL))
-#define pci_unmap_len(PTR, LEN_NAME)			\
-	((PTR)->LEN_NAME)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)		\
-	(((PTR)->LEN_NAME) = (VAL))
-
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 					enum pci_dma_burst_strategy *strat,
diff --git a/arch/sparc/include/asm/pci_64.h b/arch/sparc/include/asm/pci_64.h
index b0576df..5312782 100644
--- a/arch/sparc/include/asm/pci_64.h
+++ b/arch/sparc/include/asm/pci_64.h
@@ -32,20 +32,6 @@ static inline void pcibios_penalize_isa_irq(int irq, int active)
  */
 #define PCI_DMA_BUS_IS_PHYS	(0)
 
-/* pci_unmap_{single,page} is not a nop, thus... */
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	\
-	dma_addr_t ADDR_NAME;
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)		\
-	__u32 LEN_NAME;
-#define pci_unmap_addr(PTR, ADDR_NAME)			\
-	((PTR)->ADDR_NAME)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)		\
-	(((PTR)->ADDR_NAME) = (VAL))
-#define pci_unmap_len(PTR, LEN_NAME)			\
-	((PTR)->LEN_NAME)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)		\
-	(((PTR)->LEN_NAME) = (VAL))
-
 /* PCI IOMMU mapping bypass support. */
 
 /* PCI 64-bit addressing works for all slots on all controller
-- 
1.5.6.5

