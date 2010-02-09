Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab0BIOI3 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 9 Feb 2010 09:08:29 -0500
Received: from sh.osrg.net ([192.16.179.4]:36556 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab0BIOI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 09:08:27 -0500
From: e@lab.ntt.co.jp
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH -mm 07/12] mips: use asm-generic/pci-dma-common.h
Date: Tue,  9 Feb 2010 22:35:19 +0900
Message-Id: <1265722524-9493-8-git-send-email-e>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265722524-9493-1-git-send-email-e>
References: <1265722524-9493-1-git-send-email-e>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 09 Feb 2010 23:07:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/include/asm/pci.h |   23 +++--------------------
 1 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/arch/mips/include/asm/pci.h b/arch/mips/include/asm/pci.h
index 5ebf825..76c6e98 100644
--- a/arch/mips/include/asm/pci.h
+++ b/arch/mips/include/asm/pci.h
@@ -103,26 +103,9 @@ struct pci_dev;
 extern unsigned int PCI_DMA_BUS_IS_PHYS;
 
 #ifdef CONFIG_DMA_NEED_PCI_MAP_STATE
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
+#define HAVE_ARCH_PCI_UNMAP
+#endif
+#include <asm-generic/pci-dma-common.h>
 
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
-- 
1.5.6.5

