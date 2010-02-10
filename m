Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab0BJBj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:39:26 -0500
Received: from sh.osrg.net ([192.16.179.4]:54816 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755269Ab0BJBjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:39:22 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v2 -mm 04/14] arm: use include/linux/pci-dma.h
Date: Wed, 10 Feb 2010 10:34:37 +0900
Message-Id: <1265765687-14121-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 10 Feb 2010 10:38:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/Kconfig           |    3 +++
 arch/arm/include/asm/pci.h |   11 +----------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 0c9cedc..f4e42dc 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -155,6 +155,9 @@ config ARCH_MAY_HAVE_PC_FDC
 config ZONE_DMA
 	bool
 
+config NEED_DMA_MAP_STATE
+       def_bool y
+
 config GENERIC_ISA_DMA
 	bool
 
diff --git a/arch/arm/include/asm/pci.h b/arch/arm/include/asm/pci.h
index 226cddd..aea3450 100644
--- a/arch/arm/include/asm/pci.h
+++ b/arch/arm/include/asm/pci.h
@@ -30,16 +30,7 @@ static inline void pcibios_penalize_isa_irq(int irq, int active)
  */
 #define PCI_DMA_BUS_IS_PHYS     (1)
 
-/*
- * Whether pci_unmap_{single,page} is a nop depends upon the
- * configuration.
- */
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	dma_addr_t ADDR_NAME;
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)		__u32 LEN_NAME;
-#define pci_unmap_addr(PTR, ADDR_NAME)		((PTR)->ADDR_NAME)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	(((PTR)->ADDR_NAME) = (VAL))
-#define pci_unmap_len(PTR, LEN_NAME)		((PTR)->LEN_NAME)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	(((PTR)->LEN_NAME) = (VAL))
+#include <linux/pci-dma.h>
 
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
-- 
1.5.6.5

