Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab0BIOI7 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 9 Feb 2010 09:08:59 -0500
Received: from sh.osrg.net ([192.16.179.4]:36554 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582Ab0BIOIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 09:08:25 -0500
From: e@lab.ntt.co.jp
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH -mm 09/12] powerpc: use asm-generic/pci-dma-common.h
Date: Tue,  9 Feb 2010 22:35:21 +0900
Message-Id: <1265722524-9493-10-git-send-email-e>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265722524-9493-1-git-send-email-e>
References: <1265722524-9493-1-git-send-email-e>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 09 Feb 2010 23:07:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/include/asm/pci.h |   33 +++------------------------------
 1 files changed, 3 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/include/asm/pci.h b/arch/powerpc/include/asm/pci.h
index b5ea626..089c8d3 100644
--- a/arch/powerpc/include/asm/pci.h
+++ b/arch/powerpc/include/asm/pci.h
@@ -142,36 +142,9 @@ extern int pci_mmap_legacy_page_range(struct pci_bus *bus,
 #define HAVE_PCI_LEGACY	1
 
 #if defined(CONFIG_PPC64) || defined(CONFIG_NOT_COHERENT_CACHE)
-/*
- * For 64-bit kernels, pci_unmap_{single,page} is not a nop.
- * For 32-bit non-coherent kernels, pci_dma_sync_single_for_cpu() and
- * so on are not nops.
- * and thus...
- */
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
-#else /* 32-bit && coherent */
-
-/* pci_unmap_{page,single} is a nop so... */
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
-#define pci_unmap_addr(PTR, ADDR_NAME)		(0)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	do { } while (0)
-#define pci_unmap_len(PTR, LEN_NAME)		(0)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	do { } while (0)
-
-#endif /* CONFIG_PPC64 || CONFIG_NOT_COHERENT_CACHE */
+#define HAVE_ARCH_PCI_UNMAP
+#endif
+#include <asm-generic/pci-dma-common.h>
 
 #ifdef CONFIG_PPC64
 
-- 
1.5.6.5

