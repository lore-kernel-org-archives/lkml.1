Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbZHZGh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbZHZGh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbZHZGh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:37:27 -0400
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:43308
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756835AbZHZGhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:37:25 -0400
Subject: Subject: [PATCH 04/33] score: create head files Kbuild asmmacro.h
	bug.h bugs.h checksum.h errno.h
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:07:58 +0800
Message-Id: <1251266878.3026.0.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From de72de77f81cf53d73f49b33c68c948825d4a156 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:04:57 +0800
Subject: [PATCH 04/33] score: create head files Kbuild asmmacro.h bug.h bugs.h checksum.h errno.h


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/Kbuild     |    3 +
 arch/score/include/asm/asmmacro.h |  161 +++++++++++++++++++++++++
 arch/score/include/asm/bug.h      |    6 +
 arch/score/include/asm/bugs.h     |    6 +
 arch/score/include/asm/checksum.h |  235 +++++++++++++++++++++++++++++++++++++
 arch/score/include/asm/errno.h    |    6 +
 6 files changed, 417 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/Kbuild
 create mode 100644 arch/score/include/asm/asmmacro.h
 create mode 100644 arch/score/include/asm/bug.h
 create mode 100644 arch/score/include/asm/bugs.h
 create mode 100644 arch/score/include/asm/checksum.h
 create mode 100644 arch/score/include/asm/errno.h

diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
new file mode 100644
index 0000000..b367abd
--- /dev/null
+++ b/arch/score/include/asm/Kbuild
@@ -0,0 +1,3 @@
+include include/asm-generic/Kbuild.asm
+
+header-y +=
diff --git a/arch/score/include/asm/asmmacro.h b/arch/score/include/asm/asmmacro.h
new file mode 100644
index 0000000..a04a54c
--- /dev/null
+++ b/arch/score/include/asm/asmmacro.h
@@ -0,0 +1,161 @@
+#ifndef _ASM_SCORE_ASMMACRO_H
+#define _ASM_SCORE_ASMMACRO_H
+
+#include <asm/asm-offsets.h>
+
+#ifdef __ASSEMBLY__
+
+.macro	SAVE_ALL
+	mfcr	r30, cr0
+	mv	r31, r0
+	nop
+	/* if UMs == 1, change stack. */
+	slli.c	r30, r30, 28
+	bpl	1f
+	la	r31, kernelsp
+	lw	r31, [r31]
+1:
+	mv	r30, r0
+	addri	r0, r31, -PT_SIZE
+
+	sw	r30, [r0, PT_R0]
+	.set	r1
+	sw	r1, [r0, PT_R1]
+	.set	nor1
+	sw	r2, [r0, PT_R2]
+	sw	r3, [r0, PT_R3]
+	sw	r4, [r0, PT_R4]
+	sw	r5, [r0, PT_R5]
+	sw	r6, [r0, PT_R6]
+	sw	r7, [r0, PT_R7]
+
+	sw	r8, [r0, PT_R8]
+	sw	r9, [r0, PT_R9]
+	sw	r10, [r0, PT_R10]
+	sw	r11, [r0, PT_R11]
+	sw	r12, [r0, PT_R12]
+	sw	r13, [r0, PT_R13]
+	sw	r14, [r0, PT_R14]
+	sw	r15, [r0, PT_R15]
+
+	sw	r16, [r0, PT_R16]
+	sw	r17, [r0, PT_R17]
+	sw	r18, [r0, PT_R18]
+	sw	r19, [r0, PT_R19]
+	sw	r20, [r0, PT_R20]
+	sw	r21, [r0, PT_R21]
+	sw	r22, [r0, PT_R22]
+	sw	r23, [r0, PT_R23]
+
+	sw	r24, [r0, PT_R24]
+	sw	r25, [r0, PT_R25]
+	sw	r25, [r0, PT_R25]
+	sw	r26, [r0, PT_R26]
+	sw	r27, [r0, PT_R27]
+
+	sw	r28, [r0, PT_R28]
+	sw	r29, [r0, PT_R29]
+	orri	r28, r0, 0x1fff
+	li	r31, 0x00001fff
+	xor	r28, r28, r31
+
+	mfcehl	r30, r31
+	sw	r30, [r0, PT_CEH]
+	sw	r31, [r0, PT_CEL]
+
+	mfcr	r31, cr0
+	sw	r31, [r0, PT_PSR]
+
+	mfcr	r31, cr1
+	sw	r31, [r0, PT_CONDITION]
+
+	mfcr	r31, cr2
+	sw	r31, [r0, PT_ECR]
+	
+	mfcr	r31, cr5
+	srli	r31, r31, 1
+	slli	r31, r31, 1
+	sw	r31, [r0, PT_EPC]
+.endm
+
+.macro	RESTORE_ALL_AND_RET
+	mfcr	r30, cr0
+	srli	r30, r30, 1
+	slli	r30, r30, 1
+	mtcr	r30, cr0
+	nop
+	nop
+	nop
+	nop
+	nop
+
+	.set	r1
+	ldis	r1, 0x00ff
+	and	r30, r30, r1
+	not	r1, r1
+	lw	r31, [r0, PT_PSR]
+	and	r31, r31, r1
+	.set	nor1
+	or	r31, r31, r30
+	mtcr	r31, cr0
+	nop
+	nop
+	nop
+	nop
+	nop
+
+	lw	r30, [r0, PT_CONDITION]
+	mtcr	r30, cr1
+	nop
+	nop
+	nop
+	nop
+	nop
+
+	lw	r30, [r0, PT_CEH]
+	lw	r31, [r0, PT_CEL]
+	mtcehl	r30, r31
+
+	.set	r1
+	lw	r1, [r0, PT_R1]
+	.set	nor1
+	lw	r2, [r0, PT_R2]
+	lw	r3, [r0, PT_R3]
+	lw	r4, [r0, PT_R4]
+	lw	r5, [r0, PT_R5]
+	lw	r6, [r0, PT_R6]
+	lw	r7, [r0, PT_R7]
+
+	lw	r8, [r0, PT_R8]
+	lw	r9, [r0, PT_R9]
+	lw	r10, [r0, PT_R10]
+	lw	r11, [r0, PT_R11]
+	lw	r12, [r0, PT_R12]
+	lw	r13, [r0, PT_R13]
+	lw	r14, [r0, PT_R14]
+	lw	r15, [r0, PT_R15]
+
+	lw	r16, [r0, PT_R16]
+	lw	r17, [r0, PT_R17]
+	lw	r18, [r0, PT_R18]
+	lw	r19, [r0, PT_R19]
+	lw	r20, [r0, PT_R20]
+	lw	r21, [r0, PT_R21]
+	lw	r22, [r0, PT_R22]
+	lw	r23, [r0, PT_R23]
+
+	lw	r24, [r0, PT_R24]
+	lw	r25, [r0, PT_R25]
+	lw	r26, [r0, PT_R26]
+	lw	r27, [r0, PT_R27]
+	lw	r28, [r0, PT_R28]
+	lw	r29, [r0, PT_R29]
+
+	lw	r30, [r0, PT_EPC]
+	lw	r0, [r0, PT_R0]
+	mtcr	r30, cr5
+	rte
+.endm
+
+#endif /* __ASSEMBLY__ */
+#endif /* _ASM_SCORE_ASMMACRO_H */
diff --git a/arch/score/include/asm/bug.h b/arch/score/include/asm/bug.h
new file mode 100644
index 0000000..bb76a33
--- /dev/null
+++ b/arch/score/include/asm/bug.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_BUG_H
+#define _ASM_SCORE_BUG_H
+
+#include <asm-generic/bug.h>
+
+#endif /* _ASM_SCORE_BUG_H */
diff --git a/arch/score/include/asm/bugs.h b/arch/score/include/asm/bugs.h
new file mode 100644
index 0000000..a062e10
--- /dev/null
+++ b/arch/score/include/asm/bugs.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_BUGS_H
+#define _ASM_SCORE_BUGS_H
+
+#include <asm-generic/bugs.h>
+
+#endif /* _ASM_SCORE_BUGS_H */
diff --git a/arch/score/include/asm/checksum.h b/arch/score/include/asm/checksum.h
new file mode 100644
index 0000000..f909ac3
--- /dev/null
+++ b/arch/score/include/asm/checksum.h
@@ -0,0 +1,235 @@
+#ifndef _ASM_SCORE_CHECKSUM_H
+#define _ASM_SCORE_CHECKSUM_H
+
+#include <linux/in6.h>
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
+unsigned int csum_partial_copy_from_user(const char *src, char *dst, int len,
+					unsigned int sum, int *csum_err);
+unsigned int csum_partial_copy(const char *src, char *dst,
+					int len, unsigned int sum);
+
+/*
+ * this is a new version of the above that records errors it finds in *errp,
+ * but continues and zeros the rest of the buffer.
+ */
+
+/*
+ * Copy and checksum to user
+ */
+#define HAVE_CSUM_COPY_USER
+static inline
+__wsum csum_and_copy_to_user(const void *src, void __user *dst, int len,
+			__wsum sum, int *err_ptr)
+{
+	sum = csum_partial(src, len, sum);
+	if (copy_to_user(dst, src, len)) {
+		*err_ptr = -EFAULT;
+		return (__force __wsum) -1; /* invalid checksum */
+	}
+	return sum;
+}
+
+
+#define csum_partial_copy_nocheck csum_partial_copy
+/*
+ *	Fold a partial checksum without adding pseudo headers
+ */
+
+static inline __sum16 csum_fold(__wsum sum)
+{
+	/* the while loop is unnecessary really, it's always enough with two
+	   iterations */
+	__asm__ __volatile__(
+		".set volatile\n\t"
+		".set\tr1\n\t"
+		"slli\tr1,%0, 16\n\t"
+		"add\t%0,%0, r1\n\t"
+		"cmp.c\tr1, %0\n\t"
+		"srli\t%0, %0, 16\n\t"
+		"bleu\t1f\n\t"
+		"addi\t%0, 0x1\n\t"
+		"1:ldi\tr30, 0xffff\n\t"
+		"xor\t%0, %0, r30\n\t"
+		"slli\t%0, %0, 16\n\t"
+		"srli\t%0, %0, 16\n\t"
+		".set\tnor1\n\t"
+		".set optimize\n\t"
+		: "=r" (sum)
+		: "0" (sum));
+	return sum;
+}
+
+/*
+ *	This is a version of ip_compute_csum() optimized for IP headers,
+ *	which always checksum on 4 octet boundaries.
+ *
+ *	By Jorge Cwik <jorge@laser.satlink.net>, adapted for linux by
+ *	Arnt Gulbrandsen.
+ */
+static inline __sum16 ip_fast_csum(const void *iph, unsigned int ihl)
+{
+	unsigned int sum;
+	unsigned long dummy;
+
+	__asm__ __volatile__(
+		".set volatile\n\t"
+		".set\tnor1\n\t"
+		"lw\t%0, [%1]\n\t"
+		"subri\t%2, %2, 4\n\t"
+		"slli\t%2, %2, 2\n\t"
+		"lw\t%3, [%1, 4]\n\t"
+		"add\t%2, %2, %1\n\t"
+		"add\t%0, %0, %3\n\t"
+		"cmp.c\t%3, %0\n\t"
+		"lw\t%3, [%1, 8]\n\t"
+		"bleu\t1f\n\t"
+		"addi\t%0, 0x1\n\t"
+		"1:\n\t"
+		"add\t%0, %0, %3\n\t"
+		"cmp.c\t%3, %0\n\t"
+		"lw\t%3, [%1, 12]\n\t"
+		"bleu\t1f\n\t"
+		"addi\t%0, 0x1\n\t"
+		"1:add\t%0, %0, %3\n\t"
+		"cmp.c\t%3, %0\n\t"
+		"bleu\t1f\n\t"
+		"addi\t%0, 0x1\n"
+
+		"1:\tlw\t%3, [%1, 16]\n\t"
+		"addi\t%1, 4\n\t"
+		"add\t%0, %0, %3\n\t"
+		"cmp.c\t%3, %0\n\t"
+		"bleu\t2f\n\t"
+		"addi\t%0, 0x1\n"
+		"2:cmp.c\t%2, %1\n\t"
+		"bne\t1b\n\t"
+
+		".set\tr1\n\t"
+		".set optimize\n\t"
+		: "=&r" (sum), "=&r" (iph), "=&r" (ihl), "=&r" (dummy)
+		: "1" (iph), "2" (ihl));
+
+	return csum_fold(sum);
+}
+
+static inline __wsum
+csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
+		unsigned short proto, __wsum sum)
+{
+	unsigned long tmp = (ntohs(len) << 16) + proto * 256;
+	__asm__ __volatile__(
+		".set volatile\n\t"
+		"add\t%0, %0, %2\n\t"
+		"cmp.c\t%2, %0\n\t"
+		"bleu\t1f\n\t"
+		"addi\t%0, 0x1\n\t"
+		"1:\n\t"
+		"add\t%0, %0, %3\n\t"
+		"cmp.c\t%3, %0\n\t"
+		"bleu\t1f\n\t"
+		"addi\t%0, 0x1\n\t"
+		"1:\n\t"
+		"add\t%0, %0, %4\n\t"
+		"cmp.c\t%4, %0\n\t"
+		"bleu\t1f\n\t"
+		"addi\t%0, 0x1\n\t"
+		"1:\n\t"
+		".set optimize\n\t"
+		: "=r" (sum)
+		: "0" (daddr), "r"(saddr),
+		"r" (tmp),
+		"r" (sum));
+	return sum;
+}
+
+/*
+ * computes the checksum of the TCP/UDP pseudo-header
+ * returns a 16-bit checksum, already complemented
+ */
+static inline __sum16
+csum_tcpudp_magic(__be32 saddr, __be32 daddr, unsigned short len,
+		unsigned short proto, __wsum sum)
+{
+	return csum_fold(csum_tcpudp_nofold(saddr, daddr, len, proto, sum));
+}
+
+/*
+ * this routine is used for miscellaneous IP-like checksums, mainly
+ * in icmp.c
+ */
+
+static inline unsigned short ip_compute_csum(const void *buff, int len)
+{
+	return csum_fold(csum_partial(buff, len, 0));
+}
+
+#define _HAVE_ARCH_IPV6_CSUM
+static inline __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
+				const struct in6_addr *daddr,
+				__u32 len, unsigned short proto,
+				__wsum sum)
+{
+	__asm__ __volatile__(
+		".set\tnoreorder\t\t\t# csum_ipv6_magic\n\t"
+		".set\tnoat\n\t"
+		"addu\t%0, %5\t\t\t# proto (long in network byte order)\n\t"
+		"sltu\t$1, %0, %5\n\t"
+		"addu\t%0, $1\n\t"
+		"addu\t%0, %6\t\t\t# csum\n\t"
+		"sltu\t$1, %0, %6\n\t"
+		"lw\t%1, 0(%2)\t\t\t# four words source address\n\t"
+		"addu\t%0, $1\n\t"
+		"addu\t%0, %1\n\t"
+		"sltu\t$1, %0, %1\n\t"
+		"lw\t%1, 4(%2)\n\t"
+		"addu\t%0, $1\n\t"
+		"addu\t%0, %1\n\t"
+		"sltu\t$1, %0, %1\n\t"
+		"lw\t%1, 8(%2)\n\t"
+		"addu\t%0, $1\n\t"
+		"addu\t%0, %1\n\t"
+		"sltu\t$1, %0, %1\n\t"
+		"lw\t%1, 12(%2)\n\t"
+		"addu\t%0, $1\n\t"
+		"addu\t%0, %1\n\t"
+		"sltu\t$1, %0, %1\n\t"
+		"lw\t%1, 0(%3)\n\t"
+		"addu\t%0, $1\n\t"
+		"addu\t%0, %1\n\t"
+		"sltu\t$1, %0, %1\n\t"
+		"lw\t%1, 4(%3)\n\t"
+		"addu\t%0, $1\n\t"
+		"addu\t%0, %1\n\t"
+		"sltu\t$1, %0, %1\n\t"
+		"lw\t%1, 8(%3)\n\t"
+		"addu\t%0, $1\n\t"
+		"addu\t%0, %1\n\t"
+		"sltu\t$1, %0, %1\n\t"
+		"lw\t%1, 12(%3)\n\t"
+		"addu\t%0, $1\n\t"
+		"addu\t%0, %1\n\t"
+		"sltu\t$1, %0, %1\n\t"
+		"addu\t%0, $1\t\t\t# Add final carry\n\t"
+		".set\tnoat\n\t"
+		".set\tnoreorder"
+		: "=r" (sum), "=r" (proto)
+		: "r" (saddr), "r" (daddr),
+		  "0" (htonl(len)), "1" (htonl(proto)), "r" (sum));
+
+	return csum_fold(sum);
+}
+#endif /* _ASM_SCORE_CHECKSUM_H */
diff --git a/arch/score/include/asm/errno.h b/arch/score/include/asm/errno.h
new file mode 100644
index 0000000..29ff39d
--- /dev/null
+++ b/arch/score/include/asm/errno.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_ERRNO_H
+#define _ASM_SCORE_ERRNO_H
+
+#include <asm-generic/errno.h>
+
+#endif /* _ASM_SCORE_ERRNO_H */
-- 
1.6.2



