Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab0BIOJk (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 9 Feb 2010 09:09:40 -0500
Received: from sh.osrg.net ([192.16.179.4]:36548 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab0BIOIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 09:08:23 -0500
From: e@lab.ntt.co.jp
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH -mm 04/12] arm: use asm-generic/pci-dma-common.h
Date: Tue,  9 Feb 2010 22:35:16 +0900
Message-Id: <1265722524-9493-5-git-send-email-e>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265722524-9493-1-git-send-email-e>
References: <1265722524-9493-1-git-send-email-e>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 09 Feb 2010 23:07:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/include/asm/pci.h |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/pci.h b/arch/arm/include/asm/pci.h
index 226cddd..27f4103 100644
--- a/arch/arm/include/asm/pci.h
+++ b/arch/arm/include/asm/pci.h
@@ -34,12 +34,8 @@ static inline void pcibios_penalize_isa_irq(int irq, int active)
  * Whether pci_unmap_{single,page} is a nop depends upon the
  * configuration.
  */
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	dma_addr_t ADDR_NAME;
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)		__u32 LEN_NAME;
-#define pci_unmap_addr(PTR, ADDR_NAME)		((PTR)->ADDR_NAME)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	(((PTR)->ADDR_NAME) = (VAL))
-#define pci_unmap_len(PTR, LEN_NAME)		((PTR)->LEN_NAME)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	(((PTR)->LEN_NAME) = (VAL))
+#define HAVE_ARCH_PCI_UNMAP
+#include <asm-generic/pci-dma-common.h>
 
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
-- 
1.5.6.5

