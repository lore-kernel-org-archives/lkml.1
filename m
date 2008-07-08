Return-Path: <linux-kernel-owner+w=401wt.eu-S1759891AbYGHMq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891AbYGHMq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759036AbYGHMpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:45:44 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:27555 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759314AbYGHMpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:45:42 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 35/58] microblaze_v5: io.h IO operations
Date: Tue,  8 Jul 2008 13:59:35 +0200
Message-Id: <7a16429cfc461420883dbaa80c16047e5a1a91c1.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <d1d33c18956829ec9ac7daf8d0516b17e85ed190.1215517976.git.monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
 <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
 <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
 <58f35f498bac29e7105c589c06567e86c5a42dd5.1215517976.git.monstr@monstr.eu>
 <810775b1bb678003923039726a9153ee34fb67b4.1215517976.git.monstr@monstr.eu>
 <2a24e5bc2cfbd349613ef10c716a28f04ce24a9f.1215517976.git.monstr@monstr.eu>
 <3171c5cf21eefc79665165f4a14bc5b68dd03f95.1215517976.git.monstr@monstr.eu>
 <9be4eff2f4d015023c453eaec3b3473a44380491.1215517976.git.monstr@monstr.eu>
 <f8e331ed9432719f3c0555c840cbbb7bbc1a6322.1215517976.git.monstr@monstr.eu>
 <4409daf2ac356e902a8f091bb5908eb8a90218bc.1215517976.git.monstr@monstr.eu>
 <f7458acb0252f72b5620d19c76104408ecc2e451.1215517976.git.monstr@monstr.eu>
 <dbd9df742cdd9eb3355d7bc8e39f9dfef6c545e4.1215517976.git.monstr@monstr.eu>
 <1f9a1f345caa749cb630cf85f95f217366395069.1215517976.git.monstr@monstr.eu>
 <fe3686f0f70d838b33642bcbcd7185fc2180b366.1215517976.git.monstr@monstr.eu>
 <e61f5a8579570cf7cd18a22e4106b7f85518928e.1215517976.git.monstr@monstr.eu>
 <59d7e0a5f38b8d38f01f357a071fc93eed36f3a8.1215517976.git.monstr@monstr.eu>
 <143afcf84af583ab66da7e8acfc9eb03b7f3eaa0.1215517976.git.monstr@monstr.eu>
 <a967ee4e5a60b410e2810ce0475e8fd04f99e3ae.1215517976.git.monstr@monstr.eu>
 <c5f0730287365c845746467a9917dbc07d2fca3c.1215517976.git.monstr@monstr.eu>
 <2aa1ac7891af57959237aae3addf4bbe607f55d7.1215517976.git.monstr@monstr.eu>
 <875ba2708f6cd3c585e4d965142e2feb07c39a0e.1215517976.git.monstr@monstr.eu>
 <eb0e741f891335df37c3cd19f1a3ce2f7ce8652a.1215517976.git.monstr@monstr.eu>
 <b28df2ea2419cbda26f9089ed6edcc175c009688.1215517976.git.monstr@monstr.eu>
 <5da1d8f069f18f14faee8c4bff736791179ef6f1.1215517976.git.monstr@monstr.eu>
 <9a32168fe72b772f301216a7090670474af78e49.1215517976.git.monstr@monstr.eu>
 <7ada4bceefc1806a2c8ef73676b7aabd8ac1cad6.1215517976.git.monstr@monstr.eu>
 <701c1dac442ac09f5010cb5356cc1a12bb0abfe1.1215517976.git.monstr@monstr.eu>
 <9b48e9d85b4a5a6dcffce8eef62b232b6bfac8e8.1215517976.git.monstr@monstr.eu>
 <04b0b222b84ba9cfe2507a9081f4d715f2323733.1215517976.git.monstr@monstr.eu>
 <d4c1b3ecfec1bf37ca0ecea6909ad25bbc945630.1215517976.git.monstr@monstr.eu>
 <6e5687d37386334cf122d1eafcca0c6649c955be.1215517976.git.monstr@monstr.eu>
 <689cff1b6d98f60d8f8abc4472193688b524284d.1215517976.git.monstr@monstr.eu>
 <9664f18e7e86af4332018549b29bf0797d6afcd5.1215517976.git.monstr@monstr.eu>
 <c7120d8a6379cb1a18af5330997e30ec974acc2f.1215517976.git.monstr@monstr.eu>
 <d1d33c18956829ec9ac7daf8d0516b17e85ed190.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/io.h |  208 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 208 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/io.h

diff --git a/include/asm-microblaze/io.h b/include/asm-microblaze/io.h
new file mode 100644
index 0000000..cb0a178
--- /dev/null
+++ b/include/asm-microblaze/io.h
@@ -0,0 +1,208 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_IO_H
+#define _ASM_MICROBLAZE_IO_H
+
+#include <asm/byteorder.h>
+#include <asm/page.h>
+
+static inline unsigned char __raw_readb(const volatile void *addr)
+{
+	return *(volatile unsigned char __force *)addr;
+}
+static inline unsigned short __raw_readw(const volatile void *addr)
+{
+	return *(volatile unsigned short __force *)addr;
+}
+static inline unsigned int __raw_readl(const volatile void *addr)
+{
+	return *(volatile unsigned int __force *)addr;
+}
+static inline unsigned long __raw_readq(const volatile void *addr)
+{
+	return *(volatile unsigned long __force *)addr;
+}
+static inline void __raw_writeb(unsigned char v, volatile void *addr)
+{
+	*(volatile unsigned char __force *)addr = v;
+}
+static inline void __raw_writew(unsigned short v, volatile void *addr)
+{
+	*(volatile unsigned short __force *)addr = v;
+}
+static inline void __raw_writel(unsigned int v, volatile void *addr)
+{
+	*(volatile unsigned int __force *)addr = v;
+}
+static inline void __raw_writeq(unsigned long v, volatile void *addr)
+{
+	*(volatile unsigned long __force *)addr = v;
+}
+
+/*
+ * read (readb, readw, readl, readq) and write (writeb, writew,
+ * writel, writeq) accessors are for PCI and thus littel endian.
+ * Linux 2.4 for Microblaze had this wrong.
+ */
+static inline unsigned char readb(const volatile void *addr)
+{
+	return *(volatile unsigned char __force *)addr;
+}
+static inline unsigned short readw(const volatile void *addr)
+{
+	return le16_to_cpu(*(volatile unsigned short __force *)addr);
+}
+static inline unsigned int readl(const volatile void *addr)
+{
+	return le32_to_cpu(*(volatile unsigned int __force *)addr);
+}
+static inline void writeb(unsigned char v, volatile void *addr)
+{
+	*(volatile unsigned char __force *)addr = v;
+}
+static inline void writew(unsigned short v, volatile void *addr)
+{
+	*(volatile unsigned short __force *)addr = cpu_to_le16(v);
+}
+static inline void writel(unsigned int v, volatile void __iomem *addr)
+{
+	*(volatile unsigned int __force *)addr = cpu_to_le32(v);
+}
+
+/* ioread and iowrite variants. thease are for now same as __raw_
+ * variants of accessors. we might check for endianess in the feature
+ */
+#define ioread8(addr)		__raw_readb((u8 *)(addr))
+#define ioread16(addr)		__raw_readw((u16 *)(addr))
+#define ioread32(addr)		__raw_readl((u32 *)(addr))
+#define iowrite8(v, addr)	__raw_writeb((u8)(v), (u8 *)(addr))
+#define iowrite16(v, addr)	__raw_writew((u16)(v), (u16 *)(addr))
+#define iowrite32(v, addr)	__raw_writel((u32)(v), (u32 *)(addr))
+
+/* These are the definitions for the x86 IO instructions
+ * inb/inw/inl/outb/outw/outl, the "string" versions
+ * insb/insw/insl/outsb/outsw/outsl, and the "pausing" versions
+ * inb_p/inw_p/...
+ * The macros don't do byte-swapping.
+ */
+#define inb(port)		readb((u8 *)((port)))
+#define outb(val, port)		writeb((val), (u8 *)((unsigned long)(port)))
+#define inw(port)		readw((u16 *)((port)))
+#define outw(val, port)		writew((val), (u16 *)((unsigned long)(port)))
+#define inl(port)		readl((u32 *)((port)))
+#define outl(val, port)		writel((val), (u32 *)((unsigned long)(port)))
+
+#define inb_p(port)		inb((port))
+#define outb_p(val, port)	outb((val), (port))
+#define inw_p(port)		inw((port))
+#define outw_p(val, port)	outw((val), (port))
+#define inl_p(port)		inl((port))
+#define outl_p(val, port)	outl((val), (port))
+
+#define memset_io(a, b, c)	memset((void *)(a), (b), (c))
+#define memcpy_fromio(a, b, c)	memcpy((a), (void *)(b), (c))
+#define memcpy_toio(a, b, c)	memcpy((void *)(a), (b), (c))
+
+/**
+ *	virt_to_phys	-	map virtual addresses to physical
+ *	@address: address to remap
+ *
+ *	The returned physical address is the physical (CPU) mapping for
+ *	the memory address given. It is only valid to use this function on
+ *	addresses directly mapped or allocated via kmalloc.
+ *
+ *	This function does not give bus mappings for DMA transfers. In
+ *	almost all conceivable cases a device driver should not be using
+ *	this function
+ */
+static inline unsigned long __iomem virt_to_phys(volatile void *address)
+{
+	return __pa((unsigned long)address);
+}
+
+#define virt_to_bus virt_to_phys
+
+/**
+ *	phys_to_virt	-	map physical address to virtual
+ *	@address: address to remap
+ *
+ *	The returned virtual address is a current CPU mapping for
+ *	the memory address given. It is only valid to use this function on
+ *	addresses that have a kernel mapping
+ *
+ *	This function does not handle bus mappings for DMA transfers. In
+ *	almost all conceivable cases a device driver should not be using
+ *	this function
+ */
+static inline void *phys_to_virt(unsigned long address)
+{
+	return (void *)__va(address);
+}
+
+#define bus_to_virt(a) phys_to_virt(a)
+
+static inline void *__ioremap(unsigned long address, unsigned long size,
+			unsigned long flags)
+{
+	return (void *)address;
+}
+
+
+#define IO_SPACE_LIMIT ~(0UL)
+
+#define ioremap(physaddr, size)	((void *)(unsigned long)(physaddr))
+#define iounmap(addr)		((void)0)
+#define ioremap_nocache(physaddr, size)	ioremap(physaddr, size)
+
+/*
+ * Convert a physical pointer to a virtual kernel pointer for /dev/mem
+ * access
+ */
+#define xlate_dev_mem_ptr(p)	__va(p)
+
+/*
+ * Convert a virtual cached pointer to an uncached pointer
+ */
+#define xlate_dev_kmem_ptr(p)	p
+
+/*
+ * Big Endian
+ */
+#define out_be32(a, v) __raw_writel((v), (a))
+#define out_be16(a, v) __raw_writew((v), (a))
+
+#define in_be32(a) __raw_readl(a)
+#define in_be16(a) __raw_readw(a)
+
+/*
+ * Little endian
+ */
+
+#define out_le32(a, v) __raw_writel(__cpu_to_le32(v), (a));
+#define out_le16(a, v) __raw_writew(__cpu_to_le16(v), (a))
+
+#define in_le32(a) __le32_to_cpu(__raw_readl(a))
+#define in_le16(a) __le16_to_cpu(__raw_readw(a))
+
+/* Byte ops */
+#define out_8(a, v) __raw_writeb((v), (a))
+#define in_8(a) __raw_readb(a)
+
+/* FIXME */
+static inline void __iomem *ioport_map(unsigned long port, unsigned int len)
+{
+	return (void __iomem *) (port);
+}
+
+static inline void ioport_unmap(void __iomem *addr)
+{
+	/* Nothing to do */
+}
+
+#endif /* _ASM_MICROBLAZE_IO_H */
-- 
1.5.4.GIT

