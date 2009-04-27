Return-Path: <linux-kernel-owner+w=401wt.eu-S932695AbZD3Poy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695AbZD3Poy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762978AbZD3PmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:42:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:49288 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359AbZD3PmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:42:01 -0400
Message-Id: <7f42e0c0a8d603d36db75bd3fc564e5f07d9345b.1241105648.git.arnd@arndb.de>
In-Reply-To: <cover.1241105648.git.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
From: Remis Lima Baima <remis.developer@googlemail.com>
Date: Mon, 27 Apr 2009 13:04:45 +0200
Subject: [PATCH 06/27] asm-generic: clean up asm-generic/io.h
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
X-Provags-ID: V01U2FsdGVkX1+JWLmudoFzs30wGhB4y19ArK7lVdEBG1w7dil
 HpT6Wu07H2qa/+iouS/B0jv6VkvGY+DltneD3x/XUZX3PcBNt5
 mMCmpECSl23JArOKQLzQg==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix various aspects of the new asm-generic/io.h, in particular
warnings from sparse regarding __iomem annotations.

Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/io.h |   37 ++++++++++++++++---------------------
 1 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 8377715..5ae45e5 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -13,6 +13,7 @@
 
 #include <asm/page.h> /* I/O is all done through memory accesses */
 #include <asm/cacheflush.h>
+#include <linux/types.h>
 
 #ifdef CONFIG_GENERIC_IOMAP
 #include <asm-generic/iomap.h>
@@ -29,17 +30,17 @@
  */
 static inline u8 __raw_readb(const volatile void __iomem *addr)
 {
-	return *(const volatile u8 *) addr;
+	return *(const volatile u8 __force *) addr;
 }
 
 static inline u16 __raw_readw(const volatile void __iomem *addr)
 {
-	return *(const volatile u16 *) addr;
+	return *(const volatile u16 __force *) addr;
 }
 
 static inline u32 __raw_readl(const volatile void __iomem *addr)
 {
-	return *(const volatile u32 *) addr;
+	return *(const volatile u32 __force *) addr;
 }
 
 #define readb __raw_readb
@@ -48,17 +49,17 @@ static inline u32 __raw_readl(const volatile void __iomem *addr)
 
 static inline void __raw_writeb(u8 b, volatile void __iomem *addr)
 {
-	*(volatile u8 *) addr = b;
+	*(volatile u8 __force *) addr = b;
 }
 
 static inline void __raw_writew(u16 b, volatile void __iomem *addr)
 {
-	*(volatile u16 *) addr = b;
+	*(volatile u16 __force *) addr = b;
 }
 
 static inline void __raw_writel(u32 b, volatile void __iomem *addr)
 {
-	*(volatile u32 *) addr = b;
+	*(volatile u32 __force *) addr = b;
 }
 
 #define writeb __raw_writeb
@@ -68,13 +69,13 @@ static inline void __raw_writel(u32 b, volatile void __iomem *addr)
 #ifdef CONFIG_64BIT
 static inline u64 __raw_readq(const volatile void __iomem *addr)
 {
-	return *(const volatile u64 *) addr;
+	return *(const volatile u64 __force *) addr;
 }
 #define readq(addr) __le64_to_cpu(__raw_readq(addr))
 
 static inline void __raw_writeq(u64 b, volatile void __iomem *addr)
 {
-	*(volatile u64 *) addr = b;
+	*(volatile u64 __force *) addr = b;
 }
 #define writeq(b,addr) __raw_writeq(__cpu_to_le64(b),addr)
 #endif
@@ -101,17 +102,17 @@ static inline u32 inl(unsigned long addr)
 
 static inline void outb(u8 b, unsigned long addr)
 {
-	return writeb(b, (volatile void __iomem *) addr);
+	writeb(b, (volatile void __iomem *) addr);
 }
 
 static inline void outw(u16 b, unsigned long addr)
 {
-	return writew(b, (volatile void __iomem *) addr);
+	writew(b, (volatile void __iomem *) addr);
 }
 
 static inline void outl(u32 b, unsigned long addr)
 {
-	return writel(b, (volatile void __iomem *) addr);
+	writel(b, (volatile void __iomem *) addr);
 }
 
 #define inb_p(addr)	inb(addr)
@@ -231,7 +232,7 @@ static inline void pci_iounmap(struct pci_dev *dev, void __iomem *p)
  */
 static inline unsigned long virt_to_phys(volatile void *address)
 {
-	return __pa(address);
+	return __pa((unsigned long)address);
 }
 
 static inline void *phys_to_virt(unsigned long address)
@@ -242,16 +243,12 @@ static inline void *phys_to_virt(unsigned long address)
 /*
  * Change "struct page" to physical address.
  */
-static inline void *__ioremap(unsigned long offset, unsigned long size,
-			      unsigned long flags)
+static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
 {
 	return (void *) offset;
 }
 
-static inline void *ioremap(unsigned long offset, unsigned long size)
-{
-	return (void *) offset;
-}
+#define __ioremap(offset, size, flags)	ioremap(offset, size)
 
 #ifndef ioremap_nocache
 #define ioremap_nocache ioremap
@@ -279,7 +276,7 @@ extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
 extern void ioport_unmap(void __iomem *p);
 #endif /* CONFIG_GENERIC_IOMAP */
 
-#define xlate_dev_kmem_ptr(p)	((void *) (p))
+#define xlate_dev_kmem_ptr(p)	p
 #define xlate_dev_mem_ptr(p)	((void *) (p))
 
 #ifndef virt_to_bus
@@ -294,8 +291,6 @@ static inline void *bus_to_virt(unsigned long address)
 }
 #endif
 
-#define page_to_bus page_to_phys
-
 #define memset_io(a, b, c)	memset(__io_virt(a), (b), (c))
 #define memcpy_fromio(a, b, c)	memcpy((a), __io_virt(b), (c))
 #define memcpy_toio(a, b, c)	memcpy(__io_virt(a), (b), (c))
-- 
1.5.6.3


