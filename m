Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab0BJBjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:39:32 -0500
Received: from sh.osrg.net ([192.16.179.4]:54820 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303Ab0BJBjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:39:25 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH v2 -mm 09/14] powerpc: use include/linux/pci-dma.h
Date: Wed, 10 Feb 2010 10:34:42 +0900
Message-Id: <1265765687-14121-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 10 Feb 2010 10:38:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/Kconfig           |    3 +++
 arch/powerpc/include/asm/pci.h |   32 +-------------------------------
 2 files changed, 4 insertions(+), 31 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 181dd84..c816a2c 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -645,6 +645,9 @@ config ZONE_DMA
 	bool
 	default y
 
+config NEED_DMA_MAP_STATE
+	def_bool (PPC64 || NOT_COHERENT_CACHE)
+
 config GENERIC_ISA_DMA
 	bool
 	depends on PPC64 || POWER4 || 6xx && !CPM2
diff --git a/arch/powerpc/include/asm/pci.h b/arch/powerpc/include/asm/pci.h
index b5ea626..4a9991b 100644
--- a/arch/powerpc/include/asm/pci.h
+++ b/arch/powerpc/include/asm/pci.h
@@ -141,37 +141,7 @@ extern int pci_mmap_legacy_page_range(struct pci_bus *bus,
 
 #define HAVE_PCI_LEGACY	1
 
-#if defined(CONFIG_PPC64) || defined(CONFIG_NOT_COHERENT_CACHE)
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
+#include <linux/pci-dma.h>
 
 #ifdef CONFIG_PPC64
 
-- 
1.5.6.5

