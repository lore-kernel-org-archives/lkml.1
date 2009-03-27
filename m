Return-Path: <linux-kernel-owner+w=401wt.eu-S1763340AbZC0BhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763340AbZC0BhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 21:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763164AbZC0Bgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 21:36:54 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:37082 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763006AbZC0Bgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 21:36:52 -0400
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 3/13] score - New architecure port to SunplusCT S+CORE
  processor
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF84433681.EDC3D62D-ON48257586.000863EF-48257586.0008CF3B@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Fri, 27 Mar 2009 09:34:28 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/03/27 ?? 09:34:29,
	Serialize complete at 2009/03/27 ?? 09:34:29
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/score lastest patch place at 
http://www.sunplusct.com/images/linux-score-patch/linux-score-20090324.patch

diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/ioctls.h 
linux-2.6-git.new/arch/score/include/asm/ioctls.h
--- linux-2.6-git.ori/arch/score/include/asm/ioctls.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/ioctls.h   2009-03-26 
10:32:17.000000000 +0800
@@ -0,0 +1,87 @@
+#ifndef __ASM_SCORE_IOCTLS_H
+#define __ASM_SCORE_IOCTLS_H
+
+#include <asm/ioctl.h>
+
+/* 0x54 is just a magic number to make these relatively unique ('T') */
+
+#define TCGETS         0x5401
+#define TCSETS         0x5402 /* Clashes with SNDCTL_TMR_START sound 
ioctl */
+#define TCSETSW                0x5403
+#define TCSETSF                0x5404
+#define TCGETA         0x5405
+#define TCSETA         0x5406
+#define TCSETAW                0x5407
+#define TCSETAF                0x5408
+#define TCSBRK         0x5409
+#define TCXONC         0x540A
+#define TCFLSH         0x540B
+#define TIOCEXCL       0x540C
+#define TIOCNXCL       0x540D
+#define TIOCSCTTY      0x540E
+#define TIOCGPGRP      0x540F
+#define TIOCSPGRP      0x5410
+#define TIOCOUTQ       0x5411
+#define TIOCSTI                0x5412
+#define TIOCGWINSZ     0x5413
+#define TIOCSWINSZ     0x5414
+#define TIOCMGET       0x5415
+#define TIOCMBIS       0x5416
+#define TIOCMBIC       0x5417
+#define TIOCMSET       0x5418
+#define TIOCGSOFTCAR   0x5419
+#define TIOCSSOFTCAR   0x541A
+#define FIONREAD       0x541B
+#define TIOCINQ                FIONREAD
+#define TIOCLINUX      0x541C
+#define TIOCCONS       0x541D
+#define TIOCGSERIAL    0x541E
+#define TIOCSSERIAL    0x541F
+#define TIOCPKT                0x5420
+#define FIONBIO                0x5421
+#define TIOCNOTTY      0x5422
+#define TIOCSETD       0x5423
+#define TIOCGETD       0x5424
+#define TCSBRKP                0x5425  /* Needed for POSIX tcsendbreak() 
*/
+/* #define TIOCTTYGSTRUCT 0x5426 - Former debugging-only ioctl */
+#define TIOCSBRK       0x5427  /* BSD compatibility */
+#define TIOCCBRK       0x5428  /* BSD compatibility */
+#define TIOCGSID       0x5429  /* Return the session ID of FD */
+#define TCGETS2                _IOR('T',0x2A, struct termios2)
+#define TCSETS2                _IOW('T',0x2B, struct termios2)
+#define TCSETSW2       _IOW('T',0x2C, struct termios2)
+#define TCSETSF2       _IOW('T',0x2D, struct termios2)
+#define TIOCGPTN       _IOR('T',0x30, unsigned int) /* Get Pty Number (of 
pty-mux device) */
+#define TIOCSPTLCK     _IOW('T',0x31, int)     /* Lock/unlock Pty */
+
+#define FIONCLEX       0x5450
+#define FIOCLEX                0x5451
+#define FIOASYNC       0x5452
+#define TIOCSERCONFIG  0x5453
+#define TIOCSERGWILD   0x5454
+#define TIOCSERSWILD   0x5455
+#define TIOCGLCKTRMIOS 0x5456
+#define TIOCSLCKTRMIOS 0x5457
+#define TIOCSERGSTRUCT 0x5458 /* For debugging only */
+#define TIOCSERGETLSR  0x5459 /* Get line status register */
+#define TIOCSERGETMULTI 0x545A /* Get multiport config */
+#define TIOCSERSETMULTI 0x545B /* Set multiport config */
+
+#define TIOCMIWAIT     0x545C  /* wait for a change on serial input 
line(s) */
+#define TIOCGICOUNT    0x545D  /* read serial port inline interrupt 
counts */
+#define TIOCGHAYESESP  0x545E  /* Get Hayes ESP configuration */
+#define TIOCSHAYESESP  0x545F  /* Set Hayes ESP configuration */
+#define FIOQSIZE       0x5460
+
+/* Used for packet mode */
+#define TIOCPKT_DATA            0
+#define TIOCPKT_FLUSHREAD       1
+#define TIOCPKT_FLUSHWRITE      2
+#define TIOCPKT_STOP            4
+#define TIOCPKT_START           8
+#define TIOCPKT_NOSTOP         16
+#define TIOCPKT_DOSTOP         32
+
+#define TIOCSER_TEMT   0x01    /* Transmitter physically empty */
+
+#endif /* __ASM_SCORE_IOCTLS_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/io.h 
linux-2.6-git.new/arch/score/include/asm/io.h
--- linux-2.6-git.ori/arch/score/include/asm/io.h       1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/io.h       2009-03-23 
14:48:04.000000000 +0800
@@ -0,0 +1,195 @@
+#ifndef _ASM_IO_H
+#define _ASM_IO_H
+
+#include <linux/compiler.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+
+#include <asm/byteorder.h>
+#include <asm-generic/iomap.h>
+#include <asm/page.h>
+#include <asm/pgtable-bits.h>
+#include <asm/processor.h>
+#include <asm/string.h>
+
+#if defined(CONFIG_SWAP_IO_SPACE) && defined(__SCOREEB__)
+#define __ioswab16(x) swab16(x)
+#define __ioswab32(x) swab32(x)
+#else
+#define __ioswab16(x) (x)
+#define __ioswab32(x) (x)
+#endif
+
+#define __raw_readb(addr)      (*(volatile unsigned char *)addr)
+#define __raw_readw(addr)      (*(volatile unsigned short *)addr)
+#define __raw_readl(addr)      (*(volatile unsigned int *)addr)
+#define __raw_readq(addr)      (*(volatile unsigned long long *)addr)
+#define __raw_writeb(b, addr)  (*(volatile unsigned char *)addr = (b))
+#define __raw_writew(b, addr)  (*(volatile unsigned short *)addr = (b))
+#define __raw_writel(b, addr)  (*(volatile unsigned int *)addr = (b))
+#define __raw_writeq(b, addr)  (*(volatile unsigned long long *)addr = 
(b))
+
+#define readb(addr)            (*(volatile unsigned char *)addr)
+#define readw(addr)            __ioswab16(*(volatile unsigned short 
*)addr)
+#define readl(addr)            __ioswab32(*(volatile unsigned int *)addr)
+#define writeb(b, addr)                (*(volatile unsigned char *)addr = 
(b))
+#define writew(b, addr)                (*(volatile unsigned short *)addr 
= __ioswab16(b))
+#define writel(b, addr)                (*(volatile unsigned int *)addr = 
__ioswab32(b))
+
+#define inb_p(port)            __inb_p(port)
+#define inw_p(port)            __inw_p(port)
+#define inl_p(port)            __inl_p(port)
+#define outb_p(val, port)      *(volatile u8 *)port = (val)
+#define outw_p(val, port)      *(volatile u16 *)port = (val)
+#define outl_p(val, port)      *(volatile u32 *)port = (val)
+
+#define inb(port)              __inb(port)
+#define inw(port)              __inw(port)
+#define inl(port)              __inl(port)
+#define insb(port, addr, count)        __insb(port, addr, count)
+#define insw(port, addr, count)        __insw(port, addr, count)
+#define insl(port, addr, count)        __insl(port, addr, count)
+#define outb(val, port)                *(volatile u8 *)port = (val)
+#define outw(val, port)                *(volatile u16 *)port = (val)
+#define outl(val, port)                *(volatile u32 *)port = (val)
+#define outsb(port, addr, count)       __outsb(port, addr, count)
+#define outsw(port, addr, count)       __outsw(port, addr, count)
+#define outsl(port, addr, count)       __outsl(port, addr, count)
+
+#define IO_SPACE_LIMIT 0xffff
+#define xlate_dev_mem_ptr(p)   __va(p)
+#define xlate_dev_kmem_ptr(p)  p
+
+static inline unsigned char __inb(unsigned long port)
+{
+       return *(volatile u8 *)(port);
+}
+
+static inline unsigned short __inw(unsigned long port)
+{
+       return *(volatile u16 *)(port);
+}
+
+static inline unsigned int __inl(unsigned long port)
+{
+       return *(volatile u32 *)(port);
+}
+
+static inline unsigned char __inb_p(unsigned long port)
+{
+       u8 __val;
+       __val = *(volatile u8 *) (port);
+       return __val;
+}
+
+static inline unsigned short __inw_p(unsigned long port)
+{
+       u16 __val;
+       __val = *(volatile u16 *) (port);
+       return __val;
+}
+
+static inline unsigned long __inl_p(unsigned long port)
+{
+       u32 __val;
+       __val = *(volatile u32 *) (port);
+       return __val;
+}
+
+static inline void
+__insb(unsigned long port, void *addr, unsigned long count)
+{
+       while (count--) {
+               *(u8 *) addr = inb(port);
+               addr++;
+       }
+}
+
+static inline void
+__insw(unsigned long port, void *addr, unsigned long count)
+{
+       while (count--) {
+               *(u16 *) addr = inw(port);
+               addr += 2;
+       }
+}
+
+static inline void
+__insl(unsigned long port, void *addr, unsigned long count)
+{
+       while (count--) {
+               *(u32 *)addr = inl(port);
+               addr += 4;
+       }
+}
+
+static inline void
+__outsb(unsigned long port, void *addr, unsigned long count)
+{
+       while (count--) {
+               outb(*(u8 *) addr, port);
+               addr++;
+       }
+}
+
+static inline void
+__outsw(unsigned long port, void *addr, unsigned long count)
+{
+       while (count--) {
+               outb(*(u16 *) addr, port);
+               addr += 2;
+       }
+}
+
+
+static inline void
+__outsl(unsigned long port, void *addr, unsigned long count)
+{
+       while (count--) {
+               outb(*(u32 *) addr, port);
+               addr += 4;
+       }
+}
+
+static inline void
+memset_io(volatile void __iomem *addr, unsigned char val, int count)
+{
+       memset((void __force *) addr, val, count);
+}
+
+static inline void
+memcpy_fromio(void *dst, const volatile void __iomem *src, int count)
+{
+       memcpy(dst, (void __force *) src, count);
+}
+
+static inline void
+memcpy_toio(volatile void __iomem *dst, const void *src, int count)
+{
+       memcpy((void __force *) dst, src, count);
+}
+
+#define isa_page_to_bus page_to_phys
+
+/*
+ * However PCI ones are not necessarily 1:1 and therefore these 
interfaces
+ * are forbidden in portable PCI drivers.
+ *
+ * Allow them for x86 for legacy drivers, though.
+ */
+#define virt_to_bus virt_to_phys
+#define bus_to_virt phys_to_virt
+
+/*
+ * Change "struct page" to physical address.
+ */
+#define page_to_phys(page)     ((dma_addr_t)page_to_pfn(page) << 
PAGE_SHIFT)
+
+extern void __iomem *__ioremap(phys_t offset, phys_t size, unsigned long 
flags);
+extern void __iounmap(const volatile void __iomem *addr);
+
+#define ioremap(offset, size) __ioremap((offset), (size), 
_CACHE_UNCACHED)
+#define ioremap_nocache(offset, size) __ioremap((offset), (size), 
_CACHE_UNCACHED)
+#define iounmap(offset)        __iounmap(offset)
+
+#endif /* _ASM_IO_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/ipcbuf.h 
linux-2.6-git.new/arch/score/include/asm/ipcbuf.h
--- linux-2.6-git.ori/arch/score/include/asm/ipcbuf.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/ipcbuf.h   2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,28 @@
+#ifndef _ASM_IPCBUF_H
+#define _ASM_IPCBUF_H
+
+/*
+ * The ipc64_perm structure for alpha architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * Pad space is left for:
+ * - 32-bit seq
+ * - 2 miscellaneous 64-bit values
+ */
+
+struct ipc64_perm
+{
+       __kernel_key_t  key;
+       __kernel_uid_t  uid;
+       __kernel_gid_t  gid;
+       __kernel_uid_t  cuid;
+       __kernel_gid_t  cgid;
+       __kernel_mode_t mode;
+       unsigned short  seq;
+       unsigned short  __pad1;
+       unsigned long   __unused1;
+       unsigned long   __unused2;
+};
+
+#endif /* _ASM_IPCBUF_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/irqflags.h 
linux-2.6-git.new/arch/score/include/asm/irqflags.h
--- linux-2.6-git.ori/arch/score/include/asm/irqflags.h 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/irqflags.h 2009-03-23 
14:48:29.000000000 +0800
@@ -0,0 +1,111 @@
+#ifndef _ASM_IRQFLAGS_H
+#define _ASM_IRQFLAGS_H
+
+#ifndef __ASSEMBLY__
+
+#define raw_local_irq_save(x)                  \
+{                                              \
+       __asm__ __volatile__(                   \
+               "mfcr   r8, cr0;"               \
+               "li     r9, 0xfffffffe;"        \
+               "nop;"                          \
+               "mv     %0, r8;"                \
+               "and    r8, r8, r9;"            \
+               "mtcr   r8, cr0;"               \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "ldi    r9, 0x1;"               \
+               "and    %0, %0, r9;"            \
+               : "=r" (x)                      \
+               :                               \
+               : "r8","r9"                     \
+               );                              \
+}
+
+#define raw_local_irq_restore(x)               \
+{                                              \
+       __asm__ __volatile__(                   \
+               "mfcr   r8, cr0;"               \
+               "ldi    r9, 0x1;"               \
+               "and    %0, %0, r9;"            \
+               "or     r8, r8, %0;"            \
+               "mtcr   r8, cr0;"               \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               :                               \
+               : "r"(x)                        \
+               : "r8","r9"                     \
+               );                              \
+}
+
+#define raw_local_irq_enable(void)             \
+{                                              \
+       __asm__ __volatile__(                   \
+               "mfcr\tr8,cr0;"                 \
+               "nop;"                          \
+               "nop;"                          \
+               "ori\tr8,0x1;"                  \
+               "mtcr\tr8,cr0;"                 \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               :                               \
+               :                               \
+               : "r8");                        \
+}
+
+#define raw_local_irq_disable(void)            \
+{                                              \
+       __asm__ __volatile__(                   \
+               "mfcr\tr8,cr0;"                 \
+               "nop;"                          \
+               "nop;"                          \
+               "srli\tr8,r8,1;"                \
+               "slli\tr8,r8,1;"                \
+               "mtcr\tr8,cr0;"                 \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               :                               \
+               :                               \
+               : "r8");                        \
+}
+
+#define raw_local_save_flags(x)                        \
+{                                              \
+       __asm__ __volatile__(                   \
+               "mfcr   r8, cr0;"               \
+               "nop;"                          \
+               "nop;"                          \
+               "mv     %0, r8;"                \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "ldi    r9, 0x1;"               \
+               "and    %0, %0, r9;"            \
+               : "=r" (x)                      \
+               :                               \
+               : "r8","r9"                     \
+               );                              \
+}
+
+static inline int raw_irqs_disabled_flags(unsigned long flags)
+{
+       return !(flags & 1);
+}
+
+#endif
+
+#endif /* _ASM_IRQFLAGS_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/irq.h 
linux-2.6-git.new/arch/score/include/asm/irq.h
--- linux-2.6-git.ori/arch/score/include/asm/irq.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/irq.h      2009-03-20 
10:38:52.000000000 +0800
@@ -0,0 +1,22 @@
+#ifndef _ASM_IRQ_H
+#define _ASM_IRQ_H
+
+#define NR_IRQS        64
+
+#define EXCEPTION_VECTOR_BASE_ADDR     0xa0000000
+#define IRQ_VECTOR_BASE_ADDR           ((EXCEPTION_VECTOR_BASE_ADDR) + 
0x210)
+#define IRQ_VECTOR_END_ADDR            ((EXCEPTION_VECTOR_BASE_ADDR) + 
0x5f0)
+
+#define irq_canonicalize(irq)  (irq)
+
+#define rINTPND_L      (*(volatile unsigned *)(0x95F50000))
+#define rINTPND_H      (*(volatile unsigned *)(0x95F50004))
+#define rI_PMST                (*(volatile unsigned *)(0x95F50008))
+#define rI_PSLV0       (*(volatile unsigned *)(0x95F50010))
+#define rI_PSLV1       (*(volatile unsigned *)(0x95F50014))
+#define rI_PSLV2       (*(volatile unsigned *)(0x95F50018))
+#define rI_PSLV3       (*(volatile unsigned *)(0x95F5001C))
+#define rIMASK_L       (*(volatile unsigned *)(0x95F50020))
+#define rIMASK_H       (*(volatile unsigned *)(0x95F50024))
+
+#endif /* _ASM_IRQ_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/irq_regs.h 
linux-2.6-git.new/arch/score/include/asm/irq_regs.h
--- linux-2.6-git.ori/arch/score/include/asm/irq_regs.h 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/irq_regs.h 2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,11 @@
+#ifndef __ASM_IRQ_REGS_H
+#define __ASM_IRQ_REGS_H
+
+#include <linux/thread_info.h>
+
+static inline struct pt_regs *get_irq_regs(void)
+{
+       return current_thread_info()->regs;
+}
+
+#endif /* __ASM_IRQ_REGS_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/Kbuild 
linux-2.6-git.new/arch/score/include/asm/Kbuild
--- linux-2.6-git.ori/arch/score/include/asm/Kbuild     1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/Kbuild     2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,3 @@
+include include/asm-generic/Kbuild.asm
+
+header-y +=
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/kdebug.h 
linux-2.6-git.new/arch/score/include/asm/kdebug.h
--- linux-2.6-git.ori/arch/score/include/asm/kdebug.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/kdebug.h   2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,13 @@
+#ifndef _ASM_SCORE_KDEBUG_H
+#define _ASM_SCORE_KDEBUG_H
+
+#include <linux/notifier.h>
+
+enum die_val {
+       DIE_OOPS = 1,
+       DIE_FP,
+       DIE_TRAP,
+       DIE_RI,
+};
+
+#endif /* _ASM_SCORE_KDEBUG_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/kmap_types.h 
linux-2.6-git.new/arch/score/include/asm/kmap_types.h
--- linux-2.6-git.ori/arch/score/include/asm/kmap_types.h       1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/kmap_types.h       2009-03-23 
17:42:42.000000000 +0800
@@ -0,0 +1,21 @@
+#ifndef _ASM_KMAP_TYPES_H
+#define _ASM_KMAP_TYPES_H
+
+enum km_type {
+       KM_BOUNCE_READ,
+       KM_SKB_SUNRPC_DATA,
+       KM_SKB_DATA_SOFTIRQ,
+       KM_USER0,
+       KM_USER1,
+       KM_BIO_SRC_IRQ,
+       KM_BIO_DST_IRQ,
+       KM_PTE0,
+       KM_PTE1,
+       KM_IRQ0,
+       KM_IRQ1,
+       KM_SOFTIRQ0,
+       KM_SOFTIRQ1,
+       KM_TYPE_NR
+};
+
+#endif
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/linkage.h 
linux-2.6-git.new/arch/score/include/asm/linkage.h
--- linux-2.6-git.ori/arch/score/include/asm/linkage.h  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/linkage.h  2009-03-16 
19:57:41.000000000 +0800
@@ -0,0 +1,4 @@
+#ifndef __ASM_LINKAGE_H
+#define __ASM_LINKAGE_H
+
+#endif
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/local.h 
linux-2.6-git.new/arch/score/include/asm/local.h
--- linux-2.6-git.ori/arch/score/include/asm/local.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/local.h    2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef _ARCH_SCORE_LOCAL_H
+#define _ARCH_SCORE_LOCAL_H
+
+#include <asm-generic/local.h>
+
+#endif /* _ARCH_SCORE_LOCAL_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/mman.h 
linux-2.6-git.new/arch/score/include/asm/mman.h
--- linux-2.6-git.ori/arch/score/include/asm/mman.h     1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/mman.h     2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,69 @@
+#ifndef _ASM_MMAN_H
+#define _ASM_MMAN_H
+
+/*
+ * Protections are chosen from these bits, OR'd together.  The
+ * implementation does not necessarily support PROT_EXEC or PROT_WRITE
+ * without PROT_READ.  The only guarantees are that no writing will be
+ * allowed without PROT_WRITE and no access will be allowed for 
PROT_NONE.
+ */
+#define PROT_NONE      0x00            /* page can not be accessed */
+#define PROT_READ      0x01            /* page can be read */
+#define PROT_WRITE     0x02            /* page can be written */
+#define PROT_EXEC      0x04            /* page can be executed */
+#define PROT_SEM       0x10            /* page may be used for atomic ops 
*/
+#define PROT_GROWSDOWN 0x01000000      /* mprotect flag: extend change to 
start of growsdown vma */
+#define PROT_GROWSUP   0x02000000      /* mprotect flag: extend change to 
end of growsup vma */
+
+/*
+ * Flags for mmap
+ */
+#define MAP_SHARED     0x001           /* Share changes */
+#define MAP_PRIVATE    0x002           /* Changes are private */
+#define MAP_TYPE       0x00f           /* Mask for type of mapping */
+#define MAP_FIXED      0x010           /* Interpret addr exactly */
+
+/* not used by linux, but here to make sure we don't clash with ABI 
defines */
+#define MAP_RENAME     0x020           /* Assign page to file */
+#define MAP_AUTOGROW   0x040           /* File may grow by writing */
+#define MAP_LOCAL      0x080           /* Copy on fork/sproc */
+#define MAP_AUTORSRV   0x100           /* Logical swap reserved on demand 
*/
+
+/* These are linux-specific */
+#define MAP_NORESERVE  0x0400          /* don't check for reservations */
+#define MAP_ANONYMOUS  0x0800          /* don't use a file */
+#define MAP_GROWSDOWN  0x1000          /* stack-like segment */
+#define MAP_DENYWRITE  0x2000          /* ETXTBSY */
+#define MAP_EXECUTABLE 0x4000          /* mark it as an executable */
+#define MAP_LOCKED     0x8000          /* pages are locked */
+#define MAP_POPULATE   0x10000         /* populate (prefault) pagetables 
*/
+#define MAP_NONBLOCK   0x20000         /* do not block on IO */
+
+/*
+ * Flags for msync
+ */
+#define MS_ASYNC       0x0001          /* sync memory asynchronously */
+#define MS_INVALIDATE  0x0002          /* invalidate mappings & caches */
+#define MS_SYNC                0x0004          /* synchronous memory sync 
*/
+
+/*
+ * Flags for mlockall
+ */
+#define MCL_CURRENT    1               /* lock all current mappings */
+#define MCL_FUTURE     2               /* lock all future mappings */
+
+#define MADV_NORMAL    0               /* no further special treatment */
+#define MADV_RANDOM    1               /* expect random page references 
*/
+#define MADV_SEQUENTIAL        2               /* expect sequential page 
references */
+#define MADV_WILLNEED  3               /* will need these pages */
+#define MADV_DONTNEED  4               /* don't need these pages */
+
+/* common parameters: try to keep these consistent across architectures 
*/
+#define MADV_REMOVE    9               /* remove these pages & resources 
*/
+#define MADV_DONTFORK  10              /* don't inherit across fork */
+#define MADV_DOFORK    11              /* do inherit across fork */
+
+/* compatibility flags */
+#define MAP_FILE       0
+
+#endif /* _ASM_MMAN_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/mmu_context.h 
linux-2.6-git.new/arch/score/include/asm/mmu_context.h
--- linux-2.6-git.ori/arch/score/include/asm/mmu_context.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/mmu_context.h      2009-03-23 
17:23:50.000000000 +0800
@@ -0,0 +1,107 @@
+#ifndef _ASM_MMU_CONTEXT_H
+#define _ASM_MMU_CONTEXT_H
+
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <asm/cacheflush.h>
+#include <asm-generic/mm_hooks.h>
+#include <asm/tlbflush.h>
+#include <asm/scoreregs.h>
+
+/*
+ * For the fast tlb miss handlers, we keep a per cpu array of pointers
+ * to the current pgd for each processor. Also, the proc. id is stuffed
+ * into the context register.
+ */
+extern unsigned long asid_cache;
+
+#define TLBMISS_HANDLER_SETUP_PGD(pgd)                         \
+       pgd_current = (unsigned long)(pgd)
+
+#define TLBMISS_HANDLER_SETUP()                                \
+       write_c0_context(0);                            \
+       TLBMISS_HANDLER_SETUP_PGD(swapper_pg_dir)
+
+/*
+ *  All unused by hardware upper bits will be considered
+ *  as a software asid extension.
+ */
+#define ASID_VERSION_MASK  0xfffff000
+#define ASID_FIRST_VERSION 0x1000
+
+                               /* PEVN    --------- VPN ---------- 
--ASID--- -NA- */
+#define ASID_INC       0x10    /* binary: 0000 0000 0000 0000 0000 0000 
0001 0000 */
+#define ASID_MASK      0xff0   /* binary: 0000 0000 0000 0000 0000 1111 
1111 0000 */
+
+
+#define cpu_context(cpu, mm)   ((mm)->context[cpu])
+#define cpu_asid(cpu, mm)      (cpu_context((cpu), (mm)) & ASID_MASK)
+#define asid_cache(cpu)                (asid_cache)
+
+static inline void enter_lazy_tlb(struct mm_struct *mm, struct 
task_struct *tsk)
+{}
+
+static inline void
+get_new_mmu_context(struct mm_struct *mm, unsigned long cpu)
+{
+       unsigned long asid = asid_cache(0);
+ 
+       if (! ((asid += ASID_INC) & ASID_MASK)) {
+               local_flush_tlb_all();          /* start new asid cycle */
+               if (!asid)                      /* fix version if needed 
*/
+                       asid = ASID_FIRST_VERSION;
+       }
+       cpu_context(0, mm) = asid_cache(0) = asid;
+}
+
+/*
+ * Initialize the context related info for a new mm_struct
+ * instance.
+ */
+static inline int
+init_new_context(struct task_struct *tsk, struct mm_struct *mm)
+{
+       cpu_context(0, mm) = 0;
+       return 0;
+}
+
+static inline void switch_mm(struct mm_struct *prev, struct mm_struct 
*next,
+                               struct task_struct *tsk)
+{
+       unsigned long flags;
+
+       local_irq_save(flags);
+       if ((cpu_context(0, next) ^ asid_cache(0)) & ASID_VERSION_MASK)
+               get_new_mmu_context(next, 0);
+       set_PEVN(cpu_context(0, next));
+       TLBMISS_HANDLER_SETUP_PGD(next->pgd);
+       local_irq_restore(flags);
+}
+
+/*
+ * Destroy context related info for an mm_struct that is about
+ * to be put to rest.
+ */
+static inline void destroy_context(struct mm_struct *mm)
+{}
+
+#define deactivate_mm(tsk, mm) do { } while (0)
+
+/*
+ * After we have set current->mm to a new value, this activates
+ * the context for the new mm so we see the new mappings.
+ */
+static inline void
+activate_mm(struct mm_struct *prev, struct mm_struct *next)
+{
+       unsigned long flags;
+
+       local_irq_save(flags);
+       get_new_mmu_context(next, 0);
+       set_PEVN(cpu_context(0, next));
+       TLBMISS_HANDLER_SETUP_PGD(next->pgd);
+       local_irq_restore(flags);
+}
+
+#endif /* _ASM_MMU_CONTEXT_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/mmu.h 
linux-2.6-git.new/arch/score/include/asm/mmu.h
--- linux-2.6-git.ori/arch/score/include/asm/mmu.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/mmu.h      2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef __ASM_MMU_H
+#define __ASM_MMU_H
+
+typedef unsigned long mm_context_t[NR_CPUS];
+
+#endif /* __ASM_MMU_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/module.h 
linux-2.6-git.new/arch/score/include/asm/module.h
--- linux-2.6-git.ori/arch/score/include/asm/module.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/module.h   2009-03-23 
17:43:04.000000000 +0800
@@ -0,0 +1,45 @@
+#ifndef _ASM_MODULE_H
+#define _ASM_MODULE_H
+
+#include <linux/list.h>
+#include <asm/uaccess.h>
+
+struct mod_arch_specific {
+       /* Data Bus Error exception tables */
+       struct list_head dbe_list;
+       const struct exception_table_entry *dbe_start;
+       const struct exception_table_entry *dbe_end;
+};
+
+typedef uint8_t Elf64_Byte;            /* Type for a 8-bit quantity. */
+
+#define Elf_Shdr       Elf32_Shdr
+#define Elf_Sym                Elf32_Sym
+#define Elf_Ehdr       Elf32_Ehdr
+#define Elf_Addr       Elf32_Addr
+
+#ifdef CONFIG_MODULES
+/* Given an address, look for it in the exception tables. */
+const struct exception_table_entry *search_module_dbetables(unsigned long 
addr);
+#else
+/* Given an address, look for it in the exception tables. */
+static inline const struct exception_table_entry
+*search_module_dbetables(unsigned long addr)
+{
+       return NULL;
+}
+#endif
+
+#ifdef CONFIG_CPU_SCORE7
+#define MODULE_PROC_FAMILY "SCORE7"
+#else
+#error MODULE_PROC_FAMILY undefined for your processor configuration
+#endif
+
+#define MODULE_KERNEL_TYPE "32BIT "
+#define MODULE_KERNEL_SMTC ""
+
+#define MODULE_ARCH_VERMAGIC \
+       MODULE_PROC_FAMILY MODULE_KERNEL_TYPE MODULE_KERNEL_SMTC
+
+#endif /* _ASM_MODULE_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/msgbuf.h 
linux-2.6-git.new/arch/score/include/asm/msgbuf.h
--- linux-2.6-git.ori/arch/score/include/asm/msgbuf.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/msgbuf.h   2009-03-23 
17:43:39.000000000 +0800
@@ -0,0 +1,47 @@
+#ifndef _ASM_MSGBUF_H
+#define _ASM_MSGBUF_H
+
+
+/*
+ * The msqid64_ds structure for the SCORE architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * Pad space is left for:
+ * - extension of time_t to 64-bit on 32-bitsystem to solve the y2038 
problem
+ * - 2 miscellaneous unsigned long values
+ */
+
+struct msqid64_ds {
+       struct ipc64_perm msg_perm;
+#if defined(CONFIG_32BIT) && !defined(CONFIG_CPU_LITTLE_ENDIAN)
+       unsigned long   __unused1;
+#endif
+       __kernel_time_t msg_stime;      /* last msgsnd time */
+#if defined(CONFIG_32BIT) && defined(CONFIG_CPU_LITTLE_ENDIAN)
+       unsigned long   __unused1;
+#endif
+#if defined(CONFIG_32BIT) && !defined(CONFIG_CPU_LITTLE_ENDIAN)
+       unsigned long   __unused2;
+#endif
+       __kernel_time_t msg_rtime;      /* last msgrcv time */
+#if defined(CONFIG_32BIT) && defined(CONFIG_CPU_LITTLE_ENDIAN)
+       unsigned long   __unused2;
+#endif
+#if defined(CONFIG_32BIT) && !defined(CONFIG_CPU_LITTLE_ENDIAN)
+       unsigned long   __unused3;
+#endif
+       __kernel_time_t msg_ctime;      /* last change time */
+#if defined(CONFIG_32BIT) && defined(CONFIG_CPU_LITTLE_ENDIAN)
+       unsigned long   __unused3;
+#endif
+       unsigned long   msg_cbytes;     /* current number of bytes on 
queue */
+       unsigned long   msg_qnum;       /* number of messages in queue */
+       unsigned long   msg_qbytes;     /* max number of bytes on queue */
+       __kernel_pid_t  msg_lspid;      /* pid of last msgsnd */
+       __kernel_pid_t  msg_lrpid;      /* last receive pid */
+       unsigned long   __unused4;
+       unsigned long   __unused5;
+};
+
+#endif /* _ASM_MSGBUF_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/mutex.h 
linux-2.6-git.new/arch/score/include/asm/mutex.h
--- linux-2.6-git.ori/arch/score/include/asm/mutex.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/mutex.h    2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1 @@
+#include <asm-generic/mutex-dec.h>
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/page.h 
linux-2.6-git.new/arch/score/include/asm/page.h
--- linux-2.6-git.ori/arch/score/include/asm/page.h     1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/page.h     2009-03-23 
17:43:58.000000000 +0800
@@ -0,0 +1,113 @@
+#ifndef _ASM_PAGE_H
+#define _ASM_PAGE_H
+
+#define PHYS_OFFSET            (0UL)
+#define PAGE_OFFSET            (0xA0000000UL)
+
+/*
+ * PAGE_SHIFT determines the page size
+ */
+#define PAGE_SHIFT     12
+#define PAGE_SIZE      (1UL << PAGE_SHIFT)
+#define PAGE_MASK      (~((1 << PAGE_SHIFT) - 1))
+
+#ifndef __ASSEMBLY__
+
+#include <linux/pfn.h>
+#include <asm/io.h>
+
+extern void build_clear_page(void);
+extern void build_copy_page(void);
+
+/*
+ * It's normally defined only for FLATMEM config but it's
+ * used in our early mem init code for all memory models.
+ * So always define it.
+ */
+#define ARCH_PFN_OFFSET                PFN_UP(PHYS_OFFSET)
+
+#define clear_page(page)       memset((void *)(page), 0, PAGE_SIZE)
+#define copy_page(to,from)     memcpy((to), (from), PAGE_SIZE)
+
+#define clear_user_page(page, vaddr, pg)       clear_page(page)
+#define copy_user_page(to, from, vaddr, pg)    copy_page(to, from)
+
+/*
+ * These are used to make use of C type-checking..
+ */
+typedef struct { unsigned long pte; } pte_t;
+#define pte_val(x)     ((x).pte)
+#define __pte(x)       ((pte_t) {(x)})
+typedef struct page    *pgtable_t;
+
+/*
+ * Finall the top of the hierarchy, the pgd
+ */
+typedef struct { unsigned long pgd; } pgd_t;
+#define pgd_val(x)     ((x).pgd)
+#define __pgd(x)       ((pgd_t) {(x)})
+
+/*
+ * Manipulate page protection bits
+ */
+typedef struct { unsigned long pgprot; } pgprot_t;
+#define pgprot_val(x)  ((x).pgprot)
+#define __pgprot(x)    ((pgprot_t) {(x)})
+
+/*
+ *     virt_to_phys    -       map virtual addresses to physical
+ *     @address: address to remap
+ *
+ *     The returned physical address is the physical (CPU) mapping for
+ *     the memory address given. It is only valid to use this function on
+ *     addresses directly mapped or allocated via kmalloc.
+ *
+ *     This function does not give bus mappings for DMA transfers. In
+ *     almost all conceivable cases a device driver should not be using
+ *     this function
+ */
+static inline unsigned long virt_to_phys(volatile const void *address)
+{
+       return (unsigned long)address - PAGE_OFFSET + PHYS_OFFSET;
+}
+
+/*
+ *     phys_to_virt    -       map physical address to virtual
+ *     @address: address to remap
+ *
+ *     The returned virtual address is a current CPU mapping for
+ *     the memory address given. It is only valid to use this function on
+ *     addresses that have a kernel mapping
+ *
+ *     This function does not handle bus mappings for DMA transfers. In
+ *     almost all conceivable cases a device driver should not be using
+ *     this function
+ */
+static inline void *phys_to_virt(unsigned long address)
+{
+       return (void *)(address + PAGE_OFFSET - PHYS_OFFSET);
+}
+#endif /* !__ASSEMBLY__ */
+
+/*
+ * __pa()/__va() should be used only during mem init.
+ */
+
+#define __pa(x)                ((unsigned long) (x) - PAGE_OFFSET + 
PHYS_OFFSET)
+#define __va(x)                ((void *)((unsigned long) (x) + 
PAGE_OFFSET - PHYS_OFFSET))
+#define __pa_symbol(x) __pa(RELOC_HIDE((unsigned long) (x), 0))
+
+#define pfn_to_kaddr(pfn)      __va((pfn) << PAGE_SHIFT)
+#define pfn_valid(pfn)         ((pfn) >= ARCH_PFN_OFFSET && (pfn) < 
max_mapnr)
+
+#define virt_to_page(kaddr)    pfn_to_page(PFN_DOWN(virt_to_phys(kaddr)))
+#define virt_addr_valid(kaddr) pfn_valid(PFN_DOWN(virt_to_phys(kaddr)))
+
+#define VM_DATA_DEFAULT_FLAGS  (VM_READ | VM_WRITE | VM_EXEC | \
+                                VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+
+#include <asm-generic/memory_model.h>
+#include <asm-generic/page.h>
+
+#define HIGHMEM_START  (0x20000000)
+#endif /* _ASM_PAGE_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/param.h 
linux-2.6-git.new/arch/score/include/asm/param.h
--- linux-2.6-git.ori/arch/score/include/asm/param.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/param.h    2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,23 @@
+#ifndef _ASM_PARAM_H
+#define _ASM_PARAM_H
+
+#ifdef __KERNEL__
+
+# define HZ            CONFIG_HZ       /* Internal kernel timer frequency 
*/
+# define USER_HZ       100             /* .. some user interfaces are in 
"ticks" */
+# define CLOCKS_PER_SEC        (USER_HZ)       /* like times() */
+#endif
+
+#ifndef HZ
+#define HZ 100
+#endif
+
+#define EXEC_PAGESIZE  65536
+
+#ifndef NOGROUP
+#define NOGROUP                (-1)
+#endif
+
+#define MAXHOSTNAMELEN 64      /* max length of hostname */
+
+#endif /* _ASM_PARAM_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/pci.h 
linux-2.6-git.new/arch/score/include/asm/pci.h
--- linux-2.6-git.ori/arch/score/include/asm/pci.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/pci.h      2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef _ASM_PCI_H
+#define _ASM_PCI_H
+
+#include <linux/mm.h>
+
+#endif /* _ASM_PCI_H */

Signed off by: Chen Liqin <liqin.chen@sunplusct.com>
