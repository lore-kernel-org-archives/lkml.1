Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab0BJBj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:39:28 -0500
Received: from sh.osrg.net ([192.16.179.4]:54815 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179Ab0BJBjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:39:21 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH v2 -mm 10/14] sh: use include/linux/pci-dma.h
Date: Wed, 10 Feb 2010 10:34:43 +0900
Message-Id: <1265765687-14121-11-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 10 Feb 2010 10:38:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/Kconfig           |    3 +++
 arch/sh/include/asm/pci.h |   19 +------------------
 2 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 05cef50..8d90564 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -183,6 +183,9 @@ config DMA_COHERENT
 config DMA_NONCOHERENT
 	def_bool !DMA_COHERENT
 
+config NEED_DMA_MAP_STATE
+	def_bool DMA_NONCOHERENT
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff --git a/arch/sh/include/asm/pci.h b/arch/sh/include/asm/pci.h
index 1042f7f..991c2a4 100644
--- a/arch/sh/include/asm/pci.h
+++ b/arch/sh/include/asm/pci.h
@@ -83,24 +83,7 @@ static inline void pcibios_penalize_isa_irq(int irq, int active)
  */
 #define PCI_DMA_BUS_IS_PHYS	(dma_ops->is_phys)
 
-/* pci_unmap_{single,page} being a nop depends upon the
- * configuration.
- */
-#ifdef CONFIG_DMA_NONCOHERENT
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	dma_addr_t ADDR_NAME;
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)		__u32 LEN_NAME;
-#define pci_unmap_addr(PTR, ADDR_NAME)		((PTR)->ADDR_NAME)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	(((PTR)->ADDR_NAME) = (VAL))
-#define pci_unmap_len(PTR, LEN_NAME)		((PTR)->LEN_NAME)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	(((PTR)->LEN_NAME) = (VAL))
-#else
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
-#define pci_unmap_addr(PTR, ADDR_NAME)		(0)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	do { } while (0)
-#define pci_unmap_len(PTR, LEN_NAME)		(0)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	do { } while (0)
-#endif
+#include <linux/pci-dma.h>
 
 #ifdef CONFIG_PCI
 /*
-- 
1.5.6.5

