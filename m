Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab0BIOIL (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 9 Feb 2010 09:08:11 -0500
Received: from sh.osrg.net ([192.16.179.4]:36531 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754239Ab0BIOIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 09:08:09 -0500
From: e@lab.ntt.co.jp
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: [PATCH -mm 03/12] alpha: use asm-generic/pci-dma-common.h
Date: Tue,  9 Feb 2010 22:35:15 +0900
Message-Id: <1265722524-9493-4-git-send-email-e>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265722524-9493-1-git-send-email-e>
References: <1265722524-9493-1-git-send-email-e>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 09 Feb 2010 23:07:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
---
 arch/alpha/include/asm/pci.h |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/alpha/include/asm/pci.h b/arch/alpha/include/asm/pci.h
index dd8dcab..6d2a8cc 100644
--- a/arch/alpha/include/asm/pci.h
+++ b/arch/alpha/include/asm/pci.h
@@ -120,18 +120,8 @@ extern void pci_unmap_single(struct pci_dev *, dma_addr_t, size_t, int);
 extern void pci_unmap_page(struct pci_dev *, dma_addr_t, size_t, int);
 
 /* pci_unmap_{single,page} is not a nop, thus... */
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
+#define HAVE_ARCH_PCI_UNMAP
+#include <asm-generic/pci-dma-common.h>
 
 /* Map a set of buffers described by scatterlist in streaming mode for
    PCI DMA.  This is the scatter-gather version of the above
-- 
1.5.6.5

