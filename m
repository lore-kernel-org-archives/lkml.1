Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab0BJBjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:39:45 -0500
Received: from sh.osrg.net ([192.16.179.4]:54830 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755245Ab0BJBjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:39:41 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH v2 -mm 08/14] parisc: use include/linux/pci-dma.h
Date: Wed, 10 Feb 2010 10:34:41 +0900
Message-Id: <1265765687-14121-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 10 Feb 2010 10:38:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: James Bottomley <James.Bottomley@suse.de>
---
 arch/parisc/Kconfig           |    3 +++
 arch/parisc/include/asm/pci.h |   14 +-------------
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 524d935..efae9fa 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -96,6 +96,9 @@ config PM
 config STACKTRACE_SUPPORT
 	def_bool y
 
+config NEED_DMA_MAP_STATE
+	def_bool y
+
 config ISA_DMA_API
 	bool
 
diff --git a/arch/parisc/include/asm/pci.h b/arch/parisc/include/asm/pci.h
index 64c7aa5..632088d 100644
--- a/arch/parisc/include/asm/pci.h
+++ b/arch/parisc/include/asm/pci.h
@@ -183,19 +183,7 @@ struct pci_bios_ops {
 	void (*fixup_bus)(struct pci_bus *bus);
 };
 
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
 
 /*
 ** Stuff declared in arch/parisc/kernel/pci.c
-- 
1.5.6.5

