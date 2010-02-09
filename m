Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab0BIOPj (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 9 Feb 2010 09:15:39 -0500
Received: from sh.osrg.net ([192.16.179.4]:49135 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451Ab0BIOPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 09:15:38 -0500
From: e@lab.ntt.co.jp
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp, x86@kernel.org
Subject: [PATCH -mm 02/12] x86: use asm-generic/pci-dma-common.h
Date: Tue,  9 Feb 2010 22:35:14 +0900
Message-Id: <1265722524-9493-3-git-send-email-e>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265722524-9493-1-git-send-email-e>
References: <1265722524-9493-1-git-send-email-e>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 09 Feb 2010 23:07:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: x86@kernel.org
---
 arch/x86/include/asm/pci.h |   27 ++-------------------------
 1 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index ada8c20..441e94a 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -91,32 +91,9 @@ extern void pci_iommu_alloc(void);
 #define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
 
 #if defined(CONFIG_X86_64) || defined(CONFIG_DMAR) || defined(CONFIG_DMA_API_DEBUG)
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
+#define HAVE_ARCH_PCI_UNMAP
 #endif
+#include <asm-generic/pci-dma-common.h>
 
 #endif  /* __KERNEL__ */
 
-- 
1.5.6.5

