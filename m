Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbXGREl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbXGREl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 00:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbXGRElt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 00:41:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43331 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbXGREls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 00:41:48 -0400
Date: Wed, 18 Jul 2007 14:41:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>, wli@holomorphy.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, sparclinux@vger.kernel.org
Subject: [PATCH] Mark sparc and sparc64 as not having virt_to_bus
Message-Id: <20070718144140.3b4fd82e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sparc/Kconfig       |    3 +++
 arch/sparc64/Kconfig     |    3 +++
 include/asm-sparc64/io.h |    5 -----
 3 files changed, 6 insertions(+), 5 deletions(-)

This is part of a rash attempt to make allmodconfig builds work for sparc
and sparc64 :-)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 73df711..603d83a 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -21,6 +21,9 @@ config GENERIC_ISA_DMA
 	bool
 	default y
 
+config ARCH_NO_VIRT_TO_BUS
+	def_bool y
+
 source "init/Kconfig"
 
 menu "General machine setup"
diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index b84b6af..df6ee71 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -62,6 +62,9 @@ config AUDIT_ARCH
 	bool
 	default y
 
+config ARCH_NO_VIRT_TO_BUS
+	def_bool y
+
 choice
 	prompt "Kernel page size"
 	default SPARC64_PAGE_SIZE_8KB
diff --git a/include/asm-sparc64/io.h b/include/asm-sparc64/io.h
index ad595b6..9565a89 100644
--- a/include/asm-sparc64/io.h
+++ b/include/asm-sparc64/io.h
@@ -14,11 +14,6 @@
 #define __SLOW_DOWN_IO	do { } while (0)
 #define SLOW_DOWN_IO	do { } while (0)
 
-extern unsigned long virt_to_bus_not_defined_use_pci_map(volatile void *addr);
-#define virt_to_bus virt_to_bus_not_defined_use_pci_map
-extern unsigned long bus_to_virt_not_defined_use_pci_map(volatile void *addr);
-#define bus_to_virt bus_to_virt_not_defined_use_pci_map
-
 /* BIO layer definitions. */
 extern unsigned long kern_base, kern_size;
 #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
-- 
1.5.2.3

