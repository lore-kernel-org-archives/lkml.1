Return-Path: <linux-kernel-owner+w=401wt.eu-S1763313AbZC0B4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763313AbZC0B4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 21:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755244AbZC0B4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 21:56:03 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:40464 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbZC0Bz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 21:55:58 -0400
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 2/13] score - New architecure port to SunplusCT S+CORE
  processor
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF4046F987.7C4DE9E1-ON48257586.00082C0A-48257586.00087E3B@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Fri, 27 Mar 2009 09:31:01 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/03/27 ?? 09:31:02,
	Serialize complete at 2009/03/27 ?? 09:31:02
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/score lastest patch place at 
http://www.sunplusct.com/images/linux-score-patch/linux-score-20090324.patch

diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/bug.h 
linux-2.6-git.new/arch/score/include/asm/bug.h
--- linux-2.6-git.ori/arch/score/include/asm/bug.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/bug.h      2009-03-18 
16:08:52.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef __ASM_BUG_H
+#define __ASM_BUG_H
+
+#include <asm-generic/bug.h>
+
+#endif /* __ASM_BUG_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/bugs.h 
linux-2.6-git.new/arch/score/include/asm/bugs.h
--- linux-2.6-git.ori/arch/score/include/asm/bugs.h     1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/bugs.h     2009-03-18 
16:08:57.000000000 +0800
@@ -0,0 +1,7 @@
+#ifndef _ASM_BUGS_H
+#define _ASM_BUGS_H
+
+static inline void check_bugs(void)
+{}
+
+#endif /* _ASM_BUGS_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/byteorder.h 
linux-2.6-git.new/arch/score/include/asm/byteorder.h
--- linux-2.6-git.ori/arch/score/include/asm/byteorder.h        1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/byteorder.h        2009-03-20 
09:48:54.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef _ASM_BYTEORDER_H
+#define _ASM_BYTEORDER_H
+
+#include <linux/byteorder/little_endian.h>
+
+#endif /* _ASM_BYTEORDER_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/cacheflush.h 
linux-2.6-git.new/arch/score/include/asm/cacheflush.h
--- linux-2.6-git.ori/arch/score/include/asm/cacheflush.h       1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/cacheflush.h       2009-03-23 
17:37:20.000000000 +0800
@@ -0,0 +1,85 @@
+#ifndef _ASM_CACHEFLUSH_H
+#define _ASM_CACHEFLUSH_H
+
+/* Keep includes the same across arches.  */
+#include <linux/mm.h>
+
+/* Cache flushing:
+ *
+ *  - flush_cache_all() flushes entire cache
+ *  - flush_cache_mm(mm) flushes the specified mm context's cache lines
+ *  - flush_cache_dup mm(mm) handles cache flushing when forking
+ *  - flush_cache_page(mm, vmaddr, pfn) flushes a single page
+ *  - flush_cache_range(vma, start, end) flushes a range of pages
+ *  - flush_icache_range(start, end) flush a range of instructions
+ *  - flush_dcache_page(pg) flushes(wback&invalidates) a page for dcache
+ *
+ *  - flush_cache_sigtramp() flush signal trampoline
+ *  - flush_icache_all() flush the entire instruction cache
+ *  - flush_data_cache_page() flushes a page from the data cache
+ */
+extern void (*flush_cache_all)(void);
+extern void (*__flush_cache_all)(void);
+extern void (*flush_cache_mm)(struct mm_struct *mm);
+extern void (*flush_cache_range)(struct vm_area_struct *vma,
+                                unsigned long start, unsigned long end);
+extern void (*flush_cache_page)(struct vm_area_struct *vma,
+                                unsigned long page, unsigned long pfn);
+extern void __flush_dcache_page(struct page *page);
+
+#define flush_cache_dup_mm(mm)                 do {} while (0)
+#define flush_dcache_page(page)                        do {} while (0)
+#define flush_dcache_mmap_lock(mapping)                do {} while (0)
+#define flush_dcache_mmap_unlock(mapping)      do {} while (0)
+
+extern void (*flush_icache_range)(unsigned long start, unsigned long 
end);
+
+static inline void flush_icache_page(struct vm_area_struct *vma,
+       struct page *page)
+{
+       if (vma->vm_flags & VM_EXEC) {
+               void *v = page_address(page);
+               flush_icache_range((unsigned long) v,
+                                  (unsigned long) v + PAGE_SIZE);
+       }
+}
+
+extern void (*flush_icache_range)(unsigned long start, unsigned long 
end);
+extern void (*__flush_cache_vmap)(void);
+extern void (*__flush_cache_vunmap)(void);
+
+static inline void flush_cache_vmap(unsigned long start, unsigned long 
end)
+{}
+
+static inline void flush_cache_vunmap(unsigned long start, unsigned long 
end)
+{}
+
+#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
+       memcpy(dst, src, len)
+
+#define copy_to_user_page(vma, page, vaddr, dst, src, len)     \
+       do {                                                    \
+               memcpy(dst, src, len);                          \
+               if ((vma->vm_flags & VM_EXEC))                  \
+                       flush_cache_page(vma, vaddr, page_to_pfn(page));\
+       } while(0)
+
+extern void (*flush_cache_sigtramp)(unsigned long addr);
+extern void (*flush_icache_all)(void);
+extern void (*local_flush_data_cache_page)(void *addr);
+extern void (*flush_data_cache_page)(unsigned long addr);
+
+/*
+ * This flag is used to indicate that the page pointed to by a pte
+ * is dirty and requires cleaning before returning it to the user.
+ */
+#define PG_dcache_dirty                        PG_arch_1
+
+#define Page_dcache_dirty(page)                \
+       test_bit(PG_dcache_dirty, &(page)->flags)
+#define SetPageDcacheDirty(page)       \
+       set_bit(PG_dcache_dirty, &(page)->flags)
+#define ClearPageDcacheDirty(page)     \
+       clear_bit(PG_dcache_dirty, &(page)->flags)
+
+#endif /* _ASM_CACHEFLUSH_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/cache.h 
linux-2.6-git.new/arch/score/include/asm/cache.h
--- linux-2.6-git.ori/arch/score/include/asm/cache.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/cache.h    2009-03-18 
16:09:03.000000000 +0800
@@ -0,0 +1,12 @@
+#ifndef _ASM_CACHE_H
+#define _ASM_CACHE_H
+
+/* Primary cache parameters. Cache Line Size*/
+/* Score7 chache line size:4 words*/
+#define ICACHE_LSIZE           16
+#define DCACHE_LSIZE           16
+
+#define L1_CACHE_SHIFT         4
+#define L1_CACHE_BYTES         (1 << L1_CACHE_SHIFT)
+
+#endif /* _ASM_CACHE_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/checksum.h 
linux-2.6-git.new/arch/score/include/asm/checksum.h
--- linux-2.6-git.ori/arch/score/include/asm/checksum.h 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/checksum.h 2009-03-23 
17:23:09.000000000 +0800
@@ -0,0 +1,236 @@
+#ifndef _ASM_CHECKSUM_H
+#define _ASM_CHECKSUM_H
+
+#include <linux/in6.h>
+
+#include <asm/uaccess.h>
+
+/*
+ * computes the checksum of a memory block at buff, length len,
+ * and adds in "sum" (32-bit)
+ *
+ * returns a 32-bit number suitable for feeding into itself
+ * or csum_tcpudp_magic
+ *
+ * this function must be called with even lengths, except
+ * for the last fragment, which may be odd
+ *
+ * it's best to have buff aligned on a 32-bit boundary
+ */
+unsigned int csum_partial(const void *buff, int len, __wsum sum);
+unsigned int csum_partial_copy_from_user(const char *src, char *dst, int 
len,
+                                        unsigned int sum, int *csum_err);
+unsigned int csum_partial_copy(const char *src, char *dst,
+                                        int len, unsigned int sum);
+
+/*
+ * this is a new version of the above that records errors it finds in 
*errp,
+ * but continues and zeros the rest of the buffer.
+ */
+
+/*
+ * Copy and checksum to user
+ */
+#define HAVE_CSUM_COPY_USER
+static inline
+__wsum csum_and_copy_to_user(const void *src, void __user *dst, int len,
+                               __wsum sum, int *err_ptr)
+{
+       sum = csum_partial(src, len, sum);
+       if(copy_to_user(dst, src, len)) {
+               *err_ptr = -EFAULT;
+               return (__force __wsum) - 1; /* invalid checksum */
+       }
+       return sum;
+}
+
+
+#define csum_partial_copy_nocheck csum_partial_copy
+/*
+ *     Fold a partial checksum without adding pseudo headers
+ */
+
+static inline __sum16 csum_fold(__wsum sum)
+{
+       /* the while loop is unnecessary really, it's always enough with 
two
+          iterations */
+       __asm__ __volatile__(
+               ".set volatile\n\t"
+               ".set\tr1\n\t"
+               "slli\tr1,%0, 16\n\t"
+               "add\t%0,%0, r1\n\t"
+               "cmp.c\tr1, %0\n\t"
+               "srli\t%0, %0, 16\n\t"
+               "bleu\t1f\n\t"
+               "addi\t%0, 0x1\n\t"
+               "1:ldi\tr30, 0xffff\n\t"
+               "xor\t%0, %0, r30\n\t"
+               "slli\t%0, %0, 16\n\t"
+               "srli\t%0, %0, 16\n\t"
+               ".set\tnor1\n\t"
+               ".set optimize\n\t"
+               : "=r" (sum)
+               : "0" (sum));
+       return sum;
+}
+
+/*
+ *     This is a version of ip_compute_csum() optimized for IP headers,
+ *     which always checksum on 4 octet boundaries.
+ *
+ *     By Jorge Cwik <jorge@laser.satlink.net>, adapted for linux by
+ *     Arnt Gulbrandsen.
+ */
+static inline __sum16 ip_fast_csum(const void *iph, unsigned int ihl)
+{
+       unsigned int sum;
+       unsigned long dummy;
+
+       __asm__ __volatile__(
+               ".set volatile\n\t"
+               ".set\tnor1\n\t"
+               "lw\t%0, [%1]\n\t"
+               "subri\t%2, %2, 4\n\t"
+               "slli\t%2, %2, 2\n\t"
+               "lw\t%3, [%1, 4]\n\t"
+               "add\t%2, %2, %1\n\t"
+               "add\t%0, %0, %3\n\t"
+               "cmp.c\t%3, %0\n\t"
+               "lw\t%3, [%1, 8]\n\t"
+               "bleu\t1f\n\t"
+               "addi\t%0, 0x1\n\t"
+               "1:\n\t"
+               "add\t%0, %0, %3\n\t"
+               "cmp.c\t%3, %0\n\t"
+               "lw\t%3, [%1, 12]\n\t"
+               "bleu\t1f\n\t"
+               "addi\t%0, 0x1\n\t"
+               "1:add\t%0, %0, %3\n\t"
+               "cmp.c\t%3, %0\n\t"
+               "bleu\t1f\n\t"
+               "addi\t%0, 0x1\n"
+
+               "1:\tlw\t%3, [%1, 16]\n\t"
+               "addi\t%1, 4\n\t"
+               "add\t%0, %0, %3\n\t"
+               "cmp.c\t%3, %0\n\t"
+               "bleu\t2f\n\t"
+               "addi\t%0, 0x1\n"
+               "2:cmp.c\t%2, %1\n\t"
+               "bne\t1b\n\t"
+
+               ".set\tr1\n\t"
+               ".set optimize\n\t"
+               : "=&r" (sum), "=&r" (iph), "=&r" (ihl), "=&r" (dummy)
+               : "1" (iph), "2" (ihl));
+
+       return csum_fold(sum);
+}
+
+static inline __wsum
+csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
+                       unsigned short proto,__wsum sum)
+{
+       unsigned long tmp = (ntohs(len) << 16) + proto * 256;
+       __asm__ __volatile__(
+               ".set volatile\n\t"
+               "add\t%0, %0, %2\n\t"
+               "cmp.c\t%2, %0\n\t"
+               "bleu\t1f\n\t"
+               "addi\t%0, 0x1\n\t"
+               "1:\n\t"
+               "add\t%0, %0, %3\n\t"
+               "cmp.c\t%3, %0\n\t"
+               "bleu\t1f\n\t"
+               "addi\t%0, 0x1\n\t"
+               "1:\n\t"
+               "add\t%0, %0, %4\n\t"
+               "cmp.c\t%4, %0\n\t"
+               "bleu\t1f\n\t"
+               "addi\t%0, 0x1\n\t"
+               "1:\n\t"
+               ".set optimize\n\t"
+               : "=r" (sum)
+               : "0" (daddr), "r"(saddr),
+               "r" (tmp),
+               "r" (sum));
+       return sum;
+}
+
+/*
+ * computes the checksum of the TCP/UDP pseudo-header
+ * returns a 16-bit checksum, already complemented
+ */
+static inline __sum16
+csum_tcpudp_magic(__be32 saddr, __be32 daddr, unsigned short len,
+                       unsigned short proto, __wsum sum)
+{
+       return csum_fold(csum_tcpudp_nofold(saddr, daddr, len, proto, 
sum));
+}
+
+/*
+ * this routine is used for miscellaneous IP-like checksums, mainly
+ * in icmp.c
+ */
+
+static inline unsigned short ip_compute_csum(const void *buff, int len)
+{
+       return csum_fold(csum_partial(buff, len, 0));
+}
+
+#define _HAVE_ARCH_IPV6_CSUM
+static __inline__ __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
+                                       const struct in6_addr *daddr,
+                                       __u32 len, unsigned short proto,
+                                       __wsum sum)
+{
+       __asm__ __volatile__(
+               ".set\tnoreorder\t\t\t# csum_ipv6_magic\n\t"
+               ".set\tnoat\n\t"
+               "addu\t%0, %5\t\t\t# proto (long in network byte 
order)\n\t"
+               "sltu\t$1, %0, %5\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %6\t\t\t# csum\n\t"
+               "sltu\t$1, %0, %6\n\t"
+               "lw\t%1, 0(%2)\t\t\t# four words source address\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "lw\t%1, 4(%2)\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "lw\t%1, 8(%2)\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "lw\t%1, 12(%2)\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "lw\t%1, 0(%3)\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "lw\t%1, 4(%3)\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "lw\t%1, 8(%3)\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "lw\t%1, 12(%3)\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "addu\t%0, $1\t\t\t# Add final carry\n\t"
+               ".set\tnoat\n\t"
+               ".set\tnoreorder"
+               : "=r" (sum), "=r" (proto)
+               : "r" (saddr), "r" (daddr),
+                 "0" (htonl(len)), "1" (htonl(proto)), "r" (sum));
+
+       return csum_fold(sum);
+}
+#endif /* _ASM_CHECKSUM_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/cputime.h 
linux-2.6-git.new/arch/score/include/asm/cputime.h
--- linux-2.6-git.ori/arch/score/include/asm/cputime.h  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/cputime.h  2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef __SCORE_CPUTIME_H
+#define __SCORE_CPUTIME_H
+
+#include <asm-generic/cputime.h>
+
+#endif /* __SCORE_CPUTIME_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/current.h 
linux-2.6-git.new/arch/score/include/asm/current.h
--- linux-2.6-git.ori/arch/score/include/asm/current.h  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/current.h  2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,15 @@
+#ifndef _ASM_CURRENT_H
+#define _ASM_CURRENT_H
+
+#include <linux/thread_info.h>
+
+struct task_struct;
+
+static inline struct task_struct * get_current(void)
+{
+       return current_thread_info()->task;
+}
+
+#define current                get_current()
+
+#endif /* _ASM_CURRENT_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/delay.h 
linux-2.6-git.new/arch/score/include/asm/delay.h
--- linux-2.6-git.ori/arch/score/include/asm/delay.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/delay.h    2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,37 @@
+#ifndef _ASM_DELAY_H
+#define _ASM_DELAY_H
+
+#include <linux/param.h>
+
+static inline void __delay(unsigned long loops)
+{}
+
+/*
+ * Division by multiplication: you don't have to worry about
+ * loss of precision.
+ *
+ * Use only for very small delays ( < 1 msec).  Should probably use a
+ * lookup table, really, as the multiplications take much too long with
+ * short delays.  This is a "reasonable" implementation, though (and the
+ * first constant multiplications gets optimized away if the delay is
+ * a constant)
+ */
+
+static inline void __udelay(unsigned long usecs, unsigned long lpj)
+{
+       __delay(usecs);
+}
+
+#define __udelay_val   1
+#define udelay(usecs) __udelay((usecs), __udelay_val)
+
+/* make sure "usecs *= ..." in udelay do not overflow. */
+#if HZ >= 1000
+#define MAX_UDELAY_MS  1
+#elif HZ <= 200
+#define MAX_UDELAY_MS  5
+#else
+#define MAX_UDELAY_MS  (1000 / HZ)
+#endif
+
+#endif /* _ASM_DELAY_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/device.h 
linux-2.6-git.new/arch/score/include/asm/device.h
--- linux-2.6-git.ori/arch/score/include/asm/device.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/device.h   2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,2 @@
+#include <asm-generic/device.h>
+
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/div64.h 
linux-2.6-git.new/arch/score/include/asm/div64.h
--- linux-2.6-git.ori/arch/score/include/asm/div64.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/div64.h    2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef _ASM_DIV64_H
+#define _ASM_DIV64_H
+
+#include <asm-generic/div64.h>
+
+#endif /* _ASM_DIV64_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/dma.h 
linux-2.6-git.new/arch/score/include/asm/dma.h
--- linux-2.6-git.ori/arch/score/include/asm/dma.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/dma.h      2009-03-23 
14:44:36.000000000 +0800
@@ -0,0 +1,15 @@
+#ifndef _ASM_DMA_H
+#define _ASM_DMA_H
+
+#include <linux/spinlock.h>            /* And spinlocks */
+#include <linux/delay.h>
+
+#include <asm/system.h>
+#include <asm/io.h>                    /* need byte IO */
+
+#define MAX_DMA_ADDRESS                (PAGE_OFFSET + 0x01000000)
+
+extern int request_dma(unsigned int dmanr, const char *device_id);     /* 
reserve a DMA channel */
+extern void free_dma(unsigned int dmanr);      /* release it again */
+
+#endif /* _ASM_DMA_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/dma-mapping.h 
linux-2.6-git.new/arch/score/include/asm/dma-mapping.h
--- linux-2.6-git.ori/arch/score/include/asm/dma-mapping.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/dma-mapping.h      2009-03-14 
13:37:13.000000000 +0800
@@ -0,0 +1,51 @@
+#ifndef _ASM_DMA_MAPPING_H
+#define _ASM_DMA_MAPPING_H
+
+#include <asm/scatterlist.h>
+#include <asm/cache.h>
+
+void *dma_alloc_noncoherent(struct device *dev, size_t size,
+       dma_addr_t *dma_handle, gfp_t flag);
+
+void dma_free_noncoherent(struct device *dev, size_t size,
+       void *vaddr, dma_addr_t dma_handle);
+
+void *dma_alloc_coherent(struct device *dev, size_t size,
+       dma_addr_t *dma_handle, gfp_t flag);
+
+void dma_free_coherent(struct device *dev, size_t size,
+       void *vaddr, dma_addr_t dma_handle);
+
+extern dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t 
size,
+       enum dma_data_direction direction);
+extern void dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
+       size_t size, enum dma_data_direction direction);
+extern int dma_map_sg(struct device *dev, struct scatterlist *sg, int 
nents,
+       enum dma_data_direction direction);
+extern dma_addr_t dma_map_page(struct device *dev, struct page *page,
+       unsigned long offset, size_t size, enum dma_data_direction 
direction);
+extern void dma_unmap_page(struct device *dev, dma_addr_t dma_address,
+       size_t size, enum dma_data_direction direction);
+extern void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
+       int nhwentries, enum dma_data_direction direction);
+extern void dma_sync_single_for_cpu(struct device *dev, dma_addr_t 
dma_handle,
+       size_t size, enum dma_data_direction direction);
+extern void dma_sync_single_for_device(struct device *dev,
+       dma_addr_t dma_handle, size_t size, enum dma_data_direction 
direction);
+extern void dma_sync_single_range_for_cpu(struct device *dev,
+       dma_addr_t dma_handle, unsigned long offset, size_t size,
+       enum dma_data_direction direction);
+extern void dma_sync_single_range_for_device(struct device *dev,
+       dma_addr_t dma_handle, unsigned long offset, size_t size,
+       enum dma_data_direction direction);
+extern void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist 
*sg,
+       int nelems, enum dma_data_direction direction);
+extern void dma_sync_sg_for_device(struct device *dev, struct scatterlist 
*sg,
+       int nelems, enum dma_data_direction direction);
+extern int dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
+extern int dma_supported(struct device *dev, u64 mask);
+extern int dma_is_consistent(struct device *dev, dma_addr_t dma_addr);
+extern void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
+       enum dma_data_direction direction);
+
+#endif /* _ASM_DMA_MAPPING_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/elf.h 
linux-2.6-git.new/arch/score/include/asm/elf.h
--- linux-2.6-git.ori/arch/score/include/asm/elf.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/elf.h      2009-03-23 
17:40:20.000000000 +0800
@@ -0,0 +1,118 @@
+#ifndef _ASM_ELF_H
+#define _ASM_ELF_H
+
+/* ELF register definitions */
+#define ELF_NGREG      45
+#define ELF_NFPREG     33
+#define EM_SCORE7      135
+
+/* Relocation types. */
+#define R_SCORE_NONE           0
+#define R_SCORE_HI16           1
+#define R_SCORE_LO16           2
+#define R_SCORE_BCMP           3
+#define R_SCORE_24             4
+#define R_SCORE_PC19           5
+#define R_SCORE16_11           6
+#define R_SCORE16_PC8          7
+#define R_SCORE_ABS32          8
+#define R_SCORE_ABS16          9
+#define R_SCORE_DUMMY2         10
+#define R_SCORE_GP15           11
+#define R_SCORE_GNU_VTINHERIT  12
+#define R_SCORE_GNU_VTENTRY    13
+#define R_SCORE_GOT15          14
+#define R_SCORE_GOT_LO16       15
+#define R_SCORE_CALL15         16
+#define R_SCORE_GPREL32                17
+#define R_SCORE_REL32          18
+#define R_SCORE_DUMMY_HI16     19
+#define R_SCORE_IMM30          20
+#define R_SCORE_IMM32          21
+
+
+typedef unsigned long elf_greg_t;
+typedef elf_greg_t elf_gregset_t[ELF_NGREG];
+
+typedef double elf_fpreg_t;
+typedef elf_fpreg_t elf_fpregset_t[ELF_NFPREG];
+
+/*
+ * This is used to ensure we don't load something for the wrong 
architecture.
+ */
+#define elf_check_arch(hdr)                            \
+({                                                     \
+       int __res = 1;                                  \
+       struct elfhdr *__h = (hdr);                     \
+                                                       \
+       if (__h->e_ident[EI_CLASS] != ELFCLASS32)       \
+               __res = 0;                              \
+                                                       \
+       __res;                                          \
+})
+
+/*
+ * These are used to set parameters in the core dumps.
+ */
+#define ELF_CLASS      ELFCLASS32
+
+/*
+ * These are used to set parameters in the core dumps.
+ */
+#define ELF_DATA       ELFDATA2LSB
+#define ELF_ARCH       EM_SCORE7
+
+#define SET_PERSONALITY(ex)                                            \
+do {                                                                   \
+       set_personality(PER_LINUX);                                     \
+} while (0)
+
+struct task_struct;
+struct pt_regs;
+
+extern void elf_dump_regs(elf_greg_t *, struct pt_regs *regs);
+extern int dump_task_regs(struct task_struct *, elf_gregset_t *);
+
+#define ELF_CORE_COPY_REGS(elf_regs, regs)             \
+       elf_dump_regs((elf_greg_t *)&(elf_regs), regs);
+#define ELF_CORE_COPY_TASK_REGS(tsk, elf_regs) dump_task_regs(tsk, 
elf_regs)
+
+#define USE_ELF_CORE_DUMP
+#define ELF_EXEC_PAGESIZE      PAGE_SIZE
+
+/* This yields a mask that user programs can use to figure out what
+   instruction set this cpu supports.  This could be done in userspace,
+   but it's not easy, and we've already done it here.  */
+
+#define ELF_HWCAP      (0)
+
+/* This yields a string that ld.so will use to load implementation
+   specific libraries for optimization.  This is more specific in
+   intent than poking at uname or /proc/cpuinfo.
+
+   For the moment, we have only optimizations for the Intel generations,
+   but that could change... */
+
+#define ELF_PLATFORM   (NULL)
+
+#define ELF_PLAT_INIT(_r,load_addr)    do { \
+       _r->regs[1] = _r->regs[2] = _r->regs[3] = _r->regs[4] = 0;      \
+       _r->regs[5] = _r->regs[6] = _r->regs[7] = _r->regs[8] = 0;      \
+       _r->regs[9] = _r->regs[10] = _r->regs[11] = _r->regs[12] = 0;   \
+       _r->regs[13] = _r->regs[14] = _r->regs[15] = _r->regs[16] = 0;  \
+       _r->regs[17] = _r->regs[18] = _r->regs[19] = _r->regs[20] = 0;  \
+       _r->regs[21] = _r->regs[22] = _r->regs[23] = _r->regs[24] = 0;  \
+       _r->regs[25] = _r->regs[26] = _r->regs[27] = _r->regs[28] = 0;  \
+       _r->regs[30] = _r->regs[31] = 0;                                \
+} while (0)
+
+/* This is the location that an ET_DYN program is loaded if exec'ed. 
Typical
+   use of this is to invoke "./ld.so someprog" to test out a new version 
of
+   the loader.  We need to make sure that it is out of the way of the 
program
+   that it will "exec", and that there is sufficient room for the brk. */
+
+#ifndef ELF_ET_DYN_BASE
+#define ELF_ET_DYN_BASE                (TASK_SIZE / 3 * 2)
+#endif
+
+#endif /* _ASM_ELF_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/emergency-restart.h 
linux-2.6-git.new/arch/score/include/asm/emergency-restart.h
--- linux-2.6-git.ori/arch/score/include/asm/emergency-restart.h 
1970-01-01 08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/emergency-restart.h 
2009-03-13 14:26:33.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef _ASM_EMERGENCY_RESTART_H
+#define _ASM_EMERGENCY_RESTART_H
+
+#include <asm-generic/emergency-restart.h>
+
+#endif /* _ASM_EMERGENCY_RESTART_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/errno.h 
linux-2.6-git.new/arch/score/include/asm/errno.h
--- linux-2.6-git.ori/arch/score/include/asm/errno.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/errno.h    2009-03-20 
10:23:21.000000000 +0800
@@ -0,0 +1,124 @@
+#ifndef _ASM_ERRNO_H
+#define _ASM_ERRNO_H
+
+/*
+ * These error numbers are intended to be SCORE ABI compatible
+ */
+
+#include <asm-generic/errno-base.h>
+
+#define        ENOMSG          35      /* No message of desired type */
+#define        EIDRM           36      /* Identifier removed */
+#define        ECHRNG          37      /* Channel number out of range */
+#define        EL2NSYNC        38      /* Level 2 not synchronized */
+#define        EL3HLT          39      /* Level 3 halted */
+#define        EL3RST          40      /* Level 3 reset */
+#define        ELNRNG          41      /* Link number out of range */
+#define        EUNATCH         42      /* Protocol driver not attached */
+#define        ENOCSI          43      /* No CSI structure available */
+#define        EL2HLT          44      /* Level 2 halted */
+#define        EDEADLK         45      /* Resource deadlock would occur 
*/
+#define        ENOLCK          46      /* No record locks available */
+#define        EBADE           50      /* Invalid exchange */
+#define        EBADR           51      /* Invalid request descriptor */
+#define        EXFULL          52      /* Exchange full */
+#define        ENOANO          53      /* No anode */
+#define        EBADRQC         54      /* Invalid request code */
+#define        EBADSLT         55      /* Invalid slot */
+#define        EDEADLOCK       56      /* File locking deadlock error */
+#define        EBFONT          59      /* Bad font file format */
+#define        ENOSTR          60      /* Device not a stream */
+#define        ENODATA         61      /* No data available */
+#define        ETIME           62      /* Timer expired */
+#define        ENOSR           63      /* Out of streams resources */
+#define        ENONET          64      /* Machine is not on the network 
*/
+#define        ENOPKG          65      /* Package not installed */
+#define        EREMOTE         66      /* Object is remote */
+#define        ENOLINK         67      /* Link has been severed */
+#define        EADV            68      /* Advertise error */
+#define        ESRMNT          69      /* Srmount error */
+#define        ECOMM           70      /* Communication error on send */
+#define        EPROTO          71      /* Protocol error */
+#define        EDOTDOT         73      /* RFS specific error */
+#define        EMULTIHOP       74      /* Multihop attempted */
+#define        EBADMSG         77      /* Not a data message */
+#define        ENAMETOOLONG    78      /* File name too long */
+#define        EOVERFLOW       79      /* Value too large for defined 
data type */
+#define        ENOTUNIQ        80      /* Name not unique on network */
+#define        EBADFD          81      /* File descriptor in bad state */
+#define        EREMCHG         82      /* Remote address changed */
+#define        ELIBACC         83      /* Can not access a needed shared 
library */
+#define        ELIBBAD         84      /* Accessing a corrupted shared 
library */
+#define        ELIBSCN         85      /* .lib section in a.out corrupted 
*/
+#define        ELIBMAX         86      /* Attempting to link in too many 
shared libraries */
+#define        ELIBEXEC        87      /* Cannot exec a shared library 
directly */
+#define        EILSEQ          88      /* Illegal byte sequence */
+#define        ENOSYS          89      /* Function not implemented */
+#define        ELOOP           90      /* Too many symbolic links 
encountered */
+#define        ERESTART        91      /* Interrupted system call should 
be restarted */
+#define        ESTRPIPE        92      /* Streams pipe error */
+#define        ENOTEMPTY       93      /* Directory not empty */
+#define        EUSERS          94      /* Too many users */
+#define        ENOTSOCK        95      /* Socket operation on non-socket 
*/
+#define        EDESTADDRREQ    96      /* Destination address required */
+#define        EMSGSIZE        97      /* Message too long */
+#define        EPROTOTYPE      98      /* Protocol wrong type for socket 
*/
+#define        ENOPROTOOPT     99      /* Protocol not available */
+#define        EPROTONOSUPPORT 120     /* Protocol not supported */
+#define        ESOCKTNOSUPPORT 121     /* Socket type not supported */
+#define        EOPNOTSUPP      122     /* Operation not supported on 
transport endpoint */
+#define        EPFNOSUPPORT    123     /* Protocol family not supported 
*/
+#define        EAFNOSUPPORT    124     /* Address family not supported by 
protocol */
+#define        EADDRINUSE      125     /* Address already in use */
+#define        EADDRNOTAVAIL   126     /* Cannot assign requested address 
*/
+#define        ENETDOWN        127     /* Network is down */
+#define        ENETUNREACH     128     /* Network is unreachable */
+#define        ENETRESET       129     /* Network dropped connection 
because of reset */
+#define        ECONNABORTED    130     /* Software caused connection 
abort */
+#define        ECONNRESET      131     /* Connection reset by peer */
+#define        ENOBUFS         132     /* No buffer space available */
+#define        EISCONN         133     /* Transport endpoint is already 
connected */
+#define        ENOTCONN        134     /* Transport endpoint is not 
connected */
+#define        EUCLEAN         135     /* Structure needs cleaning */
+#define        ENOTNAM         137     /* Not a XENIX named type file */
+#define        ENAVAIL         138     /* No XENIX semaphores available 
*/
+#define        EISNAM          139     /* Is a named type file */
+#define        EREMOTEIO       140     /* Remote I/O error */
+#define        EINIT           141     /* Reserved */
+#define        EREMDEV         142     /* Error 142 */
+#define        ESHUTDOWN       143     /* Cannot send after transport 
endpoint shutdown */
+#define        ETOOMANYREFS    144     /* Too many references: cannot 
splice */
+#define        ETIMEDOUT       145     /* Connection timed out */
+#define        ECONNREFUSED    146     /* Connection refused */
+#define        EHOSTDOWN       147     /* Host is down */
+#define        EHOSTUNREACH    148     /* No route to host */
+#define        EWOULDBLOCK     EAGAIN  /* Operation would block */
+#define        EALREADY        149     /* Operation already in progress 
*/
+#define        EINPROGRESS     150     /* Operation now in progress */
+#define        ESTALE          151     /* Stale NFS file handle */
+#define        ECANCELED       158     /* AIO operation canceled */
+
+/*
+ * These error are Linux extensions.
+ */
+#define        ENOMEDIUM       159     /* No medium found */
+#define        EMEDIUMTYPE     160     /* Wrong medium type */
+#define        ENOKEY          161     /* Required key not available */
+#define        EKEYEXPIRED     162     /* Key has expired */
+#define        EKEYREVOKED     163     /* Key has been revoked */
+#define        EKEYREJECTED    164     /* Key was rejected by service */
+
+/* for robust mutexes */
+#define        EOWNERDEAD      165     /* Owner died */
+#define        ENOTRECOVERABLE 166     /* State not recoverable */
+
+#define EDQUOT         1133    /* Quota exceeded */
+
+#ifdef __KERNEL__
+
+/* The biggest error number defined here or in <linux/errno.h>. */
+#define EMAXERRNO      1133
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_ERRNO_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/fb.h 
linux-2.6-git.new/arch/score/include/asm/fb.h
--- linux-2.6-git.ori/arch/score/include/asm/fb.h       1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/fb.h       2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,18 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fb.h>
+#include <linux/fs.h>
+
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct 
*vma,
+                               unsigned long off)
+{}
+
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+       return 0;
+}
+
+#endif /* _ASM_FB_H_ */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/fcntl.h 
linux-2.6-git.new/arch/score/include/asm/fcntl.h
--- linux-2.6-git.ori/arch/score/include/asm/fcntl.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/fcntl.h    2009-03-23 
17:41:15.000000000 +0800
@@ -0,0 +1,47 @@
+#ifndef _ASM_FCNTL_H
+#define _ASM_FCNTL_H
+
+#define O_APPEND       0x0008
+#define O_SYNC         0x0010
+#define O_NONBLOCK     0x0080
+#define O_CREAT                0x0100  /* not fcntl */
+#define O_TRUNC                0x0200  /* not fcntl */
+#define O_EXCL         0x0400  /* not fcntl */
+#define O_NOCTTY       0x0800  /* not fcntl */
+#define FASYNC         0x1000  /* fcntl, for BSD compatibility */
+#define O_LARGEFILE    0x2000  /* allow large file opens */
+#define O_DIRECT       0x8000  /* direct disk access hint */
+
+#define F_GETLK                14
+#define F_SETLK                6
+#define F_SETLKW       7
+
+#define F_SETOWN       24      /* for sockets. */
+#define F_GETOWN       23      /* for sockets. */
+
+#define F_GETLK64      33      /* using 'struct flock64' */
+#define F_SETLK64      34
+#define F_SETLKW64     35
+
+/*
+ * The flavours of struct flock.  "struct flock" is the ABI compliant
+ * variant.  Finally struct flock64 is the LFS variant of struct flock. 
As
+ * a historic accident and inconsistence with the ABI definition it 
doesn't
+ * contain all the same fields as struct flock.
+ */
+
+struct flock {
+       short   l_type;
+       short   l_whence;
+       off_t   l_start;
+       off_t   l_len;
+       long    l_sysid;
+       __kernel_pid_t l_pid;
+       long    pad[4];
+};
+
+#define HAVE_ARCH_STRUCT_FLOCK
+
+#include <asm-generic/fcntl.h>
+
+#endif /* _ASM_FCNTL_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/fixmap.h 
linux-2.6-git.new/arch/score/include/asm/fixmap.h
--- linux-2.6-git.ori/arch/score/include/asm/fixmap.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/fixmap.h   2009-03-23 
17:17:31.000000000 +0800
@@ -0,0 +1,86 @@
+#ifndef _ASM_FIXMAP_H
+#define _ASM_FIXMAP_H
+
+#include <asm/page.h>
+
+#define PHY_RAM_BASE           0x00000000
+#define PHY_IO_BASE            0x10000000
+
+#define VIRTUAL_RAM_BASE       0xa0000000
+#define VIRTUAL_IO_BASE                0xb0000000
+
+#define RAM_SPACE_SIZE         0x10000000
+#define IO_SPACE_SIZE          0x10000000
+
+#define KSEG1                  0xa0000000      /* Kernel unmapped, cached 
512MB  */
+
+/*
+ * Here we define all the compile-time 'special' virtual
+ * addresses. The point is to have a constant address at
+ * compile time, but to set the physical address only
+ * in the boot process. We allocate these special  addresses
+ * from the end of virtual memory (0xfffff000) backwards.
+ * Also this lets us do fail-safe vmalloc(), we
+ * can guarantee that these special addresses and
+ * vmalloc()-ed addresses never overlap.
+ *
+ * these 'compile-time allocated' memory buffers are
+ * fixed-size 4k pages. (or larger if used with an increment
+ * highger than 1) use fixmap_set(idx,phys) to associate
+ * physical memory with fixmap indices.
+ *
+ * TLB entries of such buffers will not be flushed across
+ * task switches.
+ */
+
+/*
+ * on UP currently we will have no trace of the fixmap mechanizm,
+ * no page table allocations, etc. This might change in the
+ * future, say framebuffers for the console driver(s) could be
+ * fix-mapped?
+ */
+enum fixed_addresses {
+#define FIX_N_COLOURS 8
+       FIX_CMAP_BEGIN,
+       FIX_CMAP_END = FIX_CMAP_BEGIN + FIX_N_COLOURS,
+       __end_of_fixed_addresses
+};
+
+/*
+ * used by vmalloc.c.
+ *
+ * Leave one empty page between vmalloc'ed areas and
+ * the start of the fixmap, and leave one page empty
+ * at the top of mem..
+ */
+#define FIXADDR_TOP    ((unsigned long)(long)(int)0xfefe0000)
+#define FIXADDR_SIZE   (__end_of_fixed_addresses << PAGE_SHIFT)
+#define FIXADDR_START  (FIXADDR_TOP - FIXADDR_SIZE)
+
+#define __fix_to_virt(x)       (FIXADDR_TOP - ((x) << PAGE_SHIFT))
+#define __virt_to_fix(x)       ((FIXADDR_TOP - ((x)&PAGE_MASK)) >> 
PAGE_SHIFT)
+
+extern void __this_fixmap_does_not_exist(void);
+
+/*
+ * 'index to address' translation. If anyone tries to use the idx
+ * directly without tranlation, we catch the bug with a NULL-deference
+ * kernel oops. Illegal ranges of incoming indices are caught too.
+ */
+static inline unsigned long fix_to_virt(const unsigned int idx)
+{
+       return __fix_to_virt(idx);
+}
+
+static inline unsigned long virt_to_fix(const unsigned long vaddr)
+{
+       return __virt_to_fix(vaddr);
+}
+
+/*
+ * Called from pgtable_init()
+ */
+extern void fixrange_init(unsigned long start, unsigned long end,
+                       pgd_t *pgd_base);
+
+#endif
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/futex.h 
linux-2.6-git.new/arch/score/include/asm/futex.h
--- linux-2.6-git.ori/arch/score/include/asm/futex.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/futex.h    2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef _ASM_FUTEX_H
+#define _ASM_FUTEX_H
+
+#include <asm-generic/futex.h>
+
+#endif /* _ASM_FUTEX_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/hardirq.h 
linux-2.6-git.new/arch/score/include/asm/hardirq.h
--- linux-2.6-git.ori/arch/score/include/asm/hardirq.h  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/hardirq.h  2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,15 @@
+#ifndef _ASM_HARDIRQ_H
+#define _ASM_HARDIRQ_H
+
+#include <linux/threads.h>
+#include <linux/irq.h>
+
+typedef struct {
+       unsigned int __softirq_pending;
+} ____cacheline_aligned irq_cpustat_t;
+
+#include <linux/irq_cpustat.h> /* Standard mappings for irq_cpustat_t 
above */
+
+extern void ack_bad_irq(unsigned int irq);
+
+#endif /* _ASM_HARDIRQ_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/hw_irq.h 
linux-2.6-git.new/arch/score/include/asm/hw_irq.h
--- linux-2.6-git.ori/arch/score/include/asm/hw_irq.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/hw_irq.h   2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,8 @@
+#ifndef __ASM_HW_IRQ_H
+#define __ASM_HW_IRQ_H
+
+#include <asm/atomic.h>
+
+extern atomic_t irq_err_count;
+
+#endif /* __ASM_HW_IRQ_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/ioctl.h 
linux-2.6-git.new/arch/score/include/asm/ioctl.h
--- linux-2.6-git.ori/arch/score/include/asm/ioctl.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/ioctl.h    2009-03-23 
17:42:15.000000000 +0800
@@ -0,0 +1,82 @@
+#ifndef _ASM_IOCTL_H
+#define _ASM_IOCTL_H
+
+/*
+ * The original linux ioctl numbering scheme was just a general
+ * "anything goes" setup, where more or less random numbers were
+ * assigned.  Sorry, I was clueless when I started out on this.
+ *
+ * On the alpha, we'll try to clean it up a bit, using a more sane
+ * ioctl numbering, and also trying to be compatible with OSF/1 in
+ * the process. I'd like to clean it up for the i386 as well, but
+ * it's so painful recognizing both the new and the old numbers..
+ */
+
+#define _IOC_NRBITS    8
+#define _IOC_TYPEBITS  8
+#define _IOC_SIZEBITS  13
+#define _IOC_DIRBITS   3
+
+#define _IOC_NRMASK    ((1 << _IOC_NRBITS)-1)
+#define _IOC_TYPEMASK  ((1 << _IOC_TYPEBITS)-1)
+#define _IOC_SIZEMASK  ((1 << _IOC_SIZEBITS)-1)
+#define _IOC_DIRMASK   ((1 << _IOC_DIRBITS)-1)
+
+#define _IOC_NRSHIFT   0
+#define _IOC_TYPESHIFT (_IOC_NRSHIFT+_IOC_NRBITS)
+#define _IOC_SIZESHIFT (_IOC_TYPESHIFT+_IOC_TYPEBITS)
+#define _IOC_DIRSHIFT  (_IOC_SIZESHIFT+_IOC_SIZEBITS)
+
+/*
+ * Direction bits _IOC_NONE could be 0, but OSF/1 gives it a bit.
+ * And this turns out useful to catch old ioctl numbers in header
+ * files for us.
+ */
+#define _IOC_NONE      1U
+#define _IOC_READ      2U
+#define _IOC_WRITE     4U
+
+/*
+ * The following are included for compatibility
+ */
+#define _IOC_VOID      0x20000000
+#define _IOC_OUT       0x40000000
+#define _IOC_IN                0x80000000
+#define _IOC_INOUT     (IOC_IN|IOC_OUT)
+
+#define _IOC(dir, type, nr, size) \
+       (((dir) << _IOC_DIRSHIFT) | ((type) << _IOC_TYPESHIFT) | \
+        ((nr) << _IOC_NRSHIFT) | ((size) << _IOC_SIZESHIFT))
+
+/* provoke compile error for invalid uses of size argument */
+extern unsigned int __invalid_size_argument_for_IOC;
+#define _IOC_TYPECHECK(t) \
+       ((sizeof(t) == sizeof(t[1]) && \
+         sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
+         sizeof(t) : __invalid_size_argument_for_IOC)
+
+/* used to create numbers */
+#define _IO(type, nr)          _IOC(_IOC_NONE, (type), (nr), 0)
+#define _IOR(type, nr, size)   _IOC(_IOC_READ, (type), (nr), 
(_IOC_TYPECHECK(size)))
+#define _IOW(type, nr, size)   _IOC(_IOC_WRITE, (type), (nr), 
(_IOC_TYPECHECK(size)))
+#define _IOWR(type, nr, size)  _IOC(_IOC_READ|_IOC_WRITE, (type), (nr), 
(_IOC_TYPECHECK(size)))
+#define _IOR_BAD(type, nr, size)       _IOC(_IOC_READ, (type), (nr), 
sizeof(size))
+#define _IOW_BAD(type, nr, size)       _IOC(_IOC_WRITE, (type), (nr), 
sizeof(size))
+#define _IOWR_BAD(type, nr, size)      _IOC(_IOC_READ|_IOC_WRITE, (type), 
(nr), sizeof(size))
+
+
+/* used to decode them.. */
+#define _IOC_DIR(nr)           (((nr) >> _IOC_DIRSHIFT) & _IOC_DIRMASK)
+#define _IOC_TYPE(nr)          (((nr) >> _IOC_TYPESHIFT) & _IOC_TYPEMASK)
+#define _IOC_NR(nr)            (((nr) >> _IOC_NRSHIFT) & _IOC_NRMASK)
+#define _IOC_SIZE(nr)          (((nr) >> _IOC_SIZESHIFT) & _IOC_SIZEMASK)
+
+/* ...and for the drivers/sound files... */
+
+#define IOC_IN         (_IOC_WRITE << _IOC_DIRSHIFT)
+#define IOC_OUT                (_IOC_READ << _IOC_DIRSHIFT)
+#define IOC_INOUT      ((_IOC_WRITE|_IOC_READ) << _IOC_DIRSHIFT)
+#define IOCSIZE_MASK   (_IOC_SIZEMASK << _IOC_SIZESHIFT)
+#define IOCSIZE_SHIFT  (_IOC_SIZESHIFT)
+
+#endif /* _ASM_IOCTL_H */
