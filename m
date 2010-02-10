Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab0BJBjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:39:24 -0500
Received: from sh.osrg.net ([192.16.179.4]:54817 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755270Ab0BJBjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:39:22 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp, x86@kernel.org
Subject: [PATCH v2 -mm 02/14] x86: use include/linux/pci-dma.h
Date: Wed, 10 Feb 2010 10:34:35 +0900
Message-Id: <1265765687-14121-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 10 Feb 2010 10:38:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: x86@kernel.org
---
 arch/x86/Kconfig           |    3 +++
 arch/x86/include/asm/pci.h |   30 ++----------------------------
 2 files changed, 5 insertions(+), 28 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 15c1c09..46da6ce 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -100,6 +100,9 @@ config ZONE_DMA
 config SBUS
 	bool
 
+config NEED_DMA_MAP_STATE
+       def_bool (X86_64 || DMAR || DMA_API_DEBUG)
+
 config GENERIC_ISA_DMA
 	def_bool y
 
diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index ada8c20..d9bef0a 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -90,34 +90,6 @@ extern void pci_iommu_alloc(void);
 
 #define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
 
-#if defined(CONFIG_X86_64) || defined(CONFIG_DMAR) || defined(CONFIG_DMA_API_DEBUG)
-
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)       \
-	        dma_addr_t ADDR_NAME;
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)         \
-	        __u32 LEN_NAME;
-#define pci_unmap_addr(PTR, ADDR_NAME)                  \
-	        ((PTR)->ADDR_NAME)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)         \
-	        (((PTR)->ADDR_NAME) = (VAL))
-#define pci_unmap_len(PTR, LEN_NAME)                    \
-	        ((PTR)->LEN_NAME)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)           \
-	        (((PTR)->LEN_NAME) = (VAL))
-
-#else
-
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)       dma_addr_t ADDR_NAME[0];
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME) unsigned LEN_NAME[0];
-#define pci_unmap_addr(PTR, ADDR_NAME)  sizeof((PTR)->ADDR_NAME)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL) \
-	        do { break; } while (pci_unmap_addr(PTR, ADDR_NAME))
-#define pci_unmap_len(PTR, LEN_NAME)            sizeof((PTR)->LEN_NAME)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL) \
-	        do { break; } while (pci_unmap_len(PTR, LEN_NAME))
-
-#endif
-
 #endif  /* __KERNEL__ */
 
 #ifdef CONFIG_X86_64
@@ -127,6 +99,8 @@ extern void pci_iommu_alloc(void);
 /* implement the pci_ DMA API in terms of the generic device dma_ one */
 #include <asm-generic/pci-dma-compat.h>
 
+#include <linux/pci-dma.h>
+
 /* generic pci stuff */
 #include <asm-generic/pci.h>
 #define PCIBIOS_MAX_MEM_32 0xffffffff
-- 
1.5.6.5

