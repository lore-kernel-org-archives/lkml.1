Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab0BJBjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:39:35 -0500
Received: from sh.osrg.net ([192.16.179.4]:54825 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab0BJBja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:39:30 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH v2 -mm 07/14] mips: use include/linux/pci-dma.h
Date: Wed, 10 Feb 2010 10:34:40 +0900
Message-Id: <1265765687-14121-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 10 Feb 2010 10:38:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/Kconfig           |    4 ++--
 arch/mips/include/asm/pci.h |   22 +---------------------
 2 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 591ca0c..29e8692 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -812,9 +812,9 @@ config DMA_COHERENT
 
 config DMA_NONCOHERENT
 	bool
-	select DMA_NEED_PCI_MAP_STATE
+	select NEED_DMA_MAP_STATE
 
-config DMA_NEED_PCI_MAP_STATE
+config NEED_DMA_MAP_STATE
 	bool
 
 config SYS_HAS_EARLY_PRINTK
diff --git a/arch/mips/include/asm/pci.h b/arch/mips/include/asm/pci.h
index 5ebf825..9b196f8 100644
--- a/arch/mips/include/asm/pci.h
+++ b/arch/mips/include/asm/pci.h
@@ -102,27 +102,7 @@ struct pci_dev;
  */
 extern unsigned int PCI_DMA_BUS_IS_PHYS;
 
-#ifdef CONFIG_DMA_NEED_PCI_MAP_STATE
-
-/* pci_unmap_{single,page} is not a nop, thus... */
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	dma_addr_t ADDR_NAME;
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)		__u32 LEN_NAME;
-#define pci_unmap_addr(PTR, ADDR_NAME)		((PTR)->ADDR_NAME)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	(((PTR)->ADDR_NAME) = (VAL))
-#define pci_unmap_len(PTR, LEN_NAME)		((PTR)->LEN_NAME)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	(((PTR)->LEN_NAME) = (VAL))
-
-#else /* CONFIG_DMA_NEED_PCI_MAP_STATE  */
-
-/* pci_unmap_{page,single} is a nop so... */
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
-#define pci_unmap_addr(PTR, ADDR_NAME)		(0)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	do { } while (0)
-#define pci_unmap_len(PTR, LEN_NAME)		(0)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	do { } while (0)
-
-#endif /* CONFIG_DMA_NEED_PCI_MAP_STATE  */
+#include <linux/pci-dma.h>
 
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
-- 
1.5.6.5

