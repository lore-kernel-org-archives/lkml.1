Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0BIOJB (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 9 Feb 2010 09:09:01 -0500
Received: from sh.osrg.net ([192.16.179.4]:36553 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581Ab0BIOIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 09:08:25 -0500
From: e@lab.ntt.co.jp
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH -mm 11/12] sparc: use asm-generic/pci-dma-common.h
Date: Tue,  9 Feb 2010 22:35:23 +0900
Message-Id: <1265722524-9493-12-git-send-email-e>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265722524-9493-1-git-send-email-e>
References: <1265722524-9493-1-git-send-email-e>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 09 Feb 2010 23:07:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: David S. Miller <davem@davemloft.net>
---
 arch/sparc/include/asm/pci.h    |    3 +++
 arch/sparc/include/asm/pci_32.h |   14 --------------
 arch/sparc/include/asm/pci_64.h |   14 --------------
 3 files changed, 3 insertions(+), 28 deletions(-)

diff --git a/arch/sparc/include/asm/pci.h b/arch/sparc/include/asm/pci.h
index d9c031f..4fd2d17 100644
--- a/arch/sparc/include/asm/pci.h
+++ b/arch/sparc/include/asm/pci.h
@@ -6,6 +6,9 @@
 #include <asm/pci_32.h>
 #endif
 
+#define HAVE_ARCH_PCI_UNMAP
+#include <asm-generic/pci-dma-common.h>
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

