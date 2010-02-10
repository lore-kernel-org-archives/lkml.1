Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab0BJBjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:39:08 -0500
Received: from sh.osrg.net ([192.16.179.4]:54799 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992Ab0BJBjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:39:04 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matt Turner <mattst88@gmail.com>
Subject: [PATCH v2 -mm 03/14] alpha: use include/linux/pci-dma.h
Date: Wed, 10 Feb 2010 10:34:36 +0900
Message-Id: <1265765687-14121-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 10 Feb 2010 10:38:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
---
 arch/alpha/Kconfig           |    3 +++
 arch/alpha/include/asm/pci.h |   14 +-------------
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index bd7261e..759f49d 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -58,6 +58,9 @@ config ZONE_DMA
 	bool
 	default y
 
+config NEED_DMA_MAP_STATE
+       def_bool y
+
 config GENERIC_ISA_DMA
 	bool
 	default y
diff --git a/arch/alpha/include/asm/pci.h b/arch/alpha/include/asm/pci.h
index dd8dcab..4765946 100644
--- a/arch/alpha/include/asm/pci.h
+++ b/arch/alpha/include/asm/pci.h
@@ -119,19 +119,7 @@ pci_dma_mapping_error(struct pci_dev *pdev, dma_addr_t dma_addr)
 extern void pci_unmap_single(struct pci_dev *, dma_addr_t, size_t, int);
 extern void pci_unmap_page(struct pci_dev *, dma_addr_t, size_t, int);
 
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
+#include <linux/pci-dma.h>
 
 /* Map a set of buffers described by scatterlist in streaming mode for
    PCI DMA.  This is the scatter-gather version of the above
-- 
1.5.6.5

