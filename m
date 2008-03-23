Return-Path: <linux-kernel-owner+w=401wt.eu-S1760026AbYCWILQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026AbYCWILQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758412AbYCWIHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:07:48 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1992 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755823AbYCWIHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:07:40 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 015/148] include/asm-x86/checksum_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:50 -0700
Message-Id: <1206259443-13210-16-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/checksum_64.h |  118 ++++++++++++++++++++---------------------
 1 files changed, 57 insertions(+), 61 deletions(-)

diff --git a/include/asm-x86/checksum_64.h b/include/asm-x86/checksum_64.h
index e5f7999..8bd861c 100644
--- a/include/asm-x86/checksum_64.h
+++ b/include/asm-x86/checksum_64.h
@@ -1,33 +1,31 @@
 #ifndef _X86_64_CHECKSUM_H
 #define _X86_64_CHECKSUM_H
 
-/* 
- * Checksums for x86-64 
- * Copyright 2002 by Andi Kleen, SuSE Labs 
+/*
+ * Checksums for x86-64
+ * Copyright 2002 by Andi Kleen, SuSE Labs
  * with some code from asm-x86/checksum.h
- */ 
+ */
 
 #include <linux/compiler.h>
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
 
-/** 
+/**
  * csum_fold - Fold and invert a 32bit checksum.
  * sum: 32bit unfolded sum
- * 
+ *
  * Fold a 32bit running checksum to 16bit and invert it. This is usually
  * the last step before putting a checksum into a packet.
  * Make sure not to mix with 64bit checksums.
  */
 static inline __sum16 csum_fold(__wsum sum)
 {
-	__asm__(
-		"  addl %1,%0\n"
-		"  adcl $0xffff,%0"
-		: "=r" (sum)
-		: "r" ((__force u32)sum << 16),
-		  "0" ((__force u32)sum & 0xffff0000)
-	);
+	asm("  addl %1,%0\n"
+	    "  adcl $0xffff,%0"
+	    : "=r" (sum)
+	    : "r" ((__force u32)sum << 16),
+	      "0" ((__force u32)sum & 0xffff0000));
 	return (__force __sum16)(~(__force u32)sum >> 16);
 }
 
@@ -43,46 +41,46 @@ static inline __sum16 csum_fold(__wsum sum)
  * ip_fast_csum - Compute the IPv4 header checksum efficiently.
  * iph: ipv4 header
  * ihl: length of header / 4
- */ 
+ */
 static inline __sum16 ip_fast_csum(const void *iph, unsigned int ihl)
 {
 	unsigned int sum;
 
-	asm(	"  movl (%1), %0\n"
-		"  subl $4, %2\n"
-		"  jbe 2f\n"
-		"  addl 4(%1), %0\n"
-		"  adcl 8(%1), %0\n"
-		"  adcl 12(%1), %0\n"
-		"1: adcl 16(%1), %0\n"
-		"  lea 4(%1), %1\n"
-		"  decl %2\n"
-		"  jne	1b\n"
-		"  adcl $0, %0\n"
-		"  movl %0, %2\n"
-		"  shrl $16, %0\n"
-		"  addw %w2, %w0\n"
-		"  adcl $0, %0\n"
-		"  notl %0\n"
-		"2:"
+	asm("  movl (%1), %0\n"
+	    "  subl $4, %2\n"
+	    "  jbe 2f\n"
+	    "  addl 4(%1), %0\n"
+	    "  adcl 8(%1), %0\n"
+	    "  adcl 12(%1), %0\n"
+	    "1: adcl 16(%1), %0\n"
+	    "  lea 4(%1), %1\n"
+	    "  decl %2\n"
+	    "  jne	1b\n"
+	    "  adcl $0, %0\n"
+	    "  movl %0, %2\n"
+	    "  shrl $16, %0\n"
+	    "  addw %w2, %w0\n"
+	    "  adcl $0, %0\n"
+	    "  notl %0\n"
+	    "2:"
 	/* Since the input registers which are loaded with iph and ihl
 	   are modified, we must also specify them as outputs, or gcc
 	   will assume they contain their original values. */
-	: "=r" (sum), "=r" (iph), "=r" (ihl)
-	: "1" (iph), "2" (ihl)
-	: "memory");
+	    : "=r" (sum), "=r" (iph), "=r" (ihl)
+	    : "1" (iph), "2" (ihl)
+	    : "memory");
 	return (__force __sum16)sum;
 }
 
-/** 
+/**
  * csum_tcpup_nofold - Compute an IPv4 pseudo header checksum.
  * @saddr: source address
  * @daddr: destination address
  * @len: length of packet
  * @proto: ip protocol of packet
- * @sum: initial sum to be added in (32bit unfolded) 
- * 
- * Returns the pseudo header checksum the input data. Result is 
+ * @sum: initial sum to be added in (32bit unfolded)
+ *
+ * Returns the pseudo header checksum the input data. Result is
  * 32bit unfolded.
  */
 static inline __wsum
@@ -93,32 +91,32 @@ csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
 	    "  adcl %2, %0\n"
 	    "  adcl %3, %0\n"
 	    "  adcl $0, %0\n"
-		: "=r" (sum)
+	    : "=r" (sum)
 	    : "g" (daddr), "g" (saddr),
 	      "g" ((len + proto)<<8), "0" (sum));
-    return sum;
+	return sum;
 }
 
 
-/** 
+/**
  * csum_tcpup_magic - Compute an IPv4 pseudo header checksum.
  * @saddr: source address
  * @daddr: destination address
  * @len: length of packet
  * @proto: ip protocol of packet
- * @sum: initial sum to be added in (32bit unfolded) 
- * 
+ * @sum: initial sum to be added in (32bit unfolded)
+ *
  * Returns the 16bit pseudo header checksum the input data already
  * complemented and ready to be filled in.
  */
-static inline __sum16
-csum_tcpudp_magic(__be32 saddr, __be32 daddr,
-		  unsigned short len, unsigned short proto, __wsum sum)
+static inline __sum16 csum_tcpudp_magic(__be32 saddr, __be32 daddr,
+					unsigned short len,
+					unsigned short proto, __wsum sum)
 {
-	return csum_fold(csum_tcpudp_nofold(saddr,daddr,len,proto,sum));
+	return csum_fold(csum_tcpudp_nofold(saddr, daddr, len, proto, sum));
 }
 
-/** 
+/**
  * csum_partial - Compute an internet checksum.
  * @buff: buffer to be checksummed
  * @len: length of buffer.
@@ -127,7 +125,7 @@ csum_tcpudp_magic(__be32 saddr, __be32 daddr,
  * Returns the 32bit unfolded internet checksum of the buffer.
  * Before filling it in it needs to be csum_fold()'ed.
  * buff should be aligned to a 64bit boundary if possible.
- */ 
+ */
 extern __wsum csum_partial(const void *buff, int len, __wsum sum);
 
 #define  _HAVE_ARCH_COPY_AND_CSUM_FROM_USER 1
@@ -136,23 +134,22 @@ extern __wsum csum_partial(const void *buff, int len, __wsum sum);
 
 /* Do not call this directly. Use the wrappers below */
 extern __wsum csum_partial_copy_generic(const void *src, const void *dst,
-					       int len,
-					       __wsum sum,
-					       int *src_err_ptr, int *dst_err_ptr);
+					int len, __wsum sum,
+					int *src_err_ptr, int *dst_err_ptr);
 
 
 extern __wsum csum_partial_copy_from_user(const void __user *src, void *dst,
-				       int len, __wsum isum, int *errp);
+					  int len, __wsum isum, int *errp);
 extern __wsum csum_partial_copy_to_user(const void *src, void __user *dst,
-				      int len, __wsum isum, int *errp);
-extern __wsum csum_partial_copy_nocheck(const void *src, void *dst, int len,
-					      __wsum sum);
+					int len, __wsum isum, int *errp);
+extern __wsum csum_partial_copy_nocheck(const void *src, void *dst,
+					int len, __wsum sum);
 
 /* Old names. To be removed. */
 #define csum_and_copy_to_user csum_partial_copy_to_user
 #define csum_and_copy_from_user csum_partial_copy_from_user
 
-/** 
+/**
  * ip_compute_csum - Compute an 16bit IP checksum.
  * @buff: buffer address.
  * @len: length of buffer.
@@ -170,7 +167,7 @@ extern __sum16 ip_compute_csum(const void *buff, int len);
  * @proto: protocol of packet
  * @sum: initial sum (32bit unfolded) to be added in
  *
- * Computes an IPv6 pseudo header checksum. This sum is added the checksum 
+ * Computes an IPv6 pseudo header checksum. This sum is added the checksum
  * into UDP/TCP packets and contains some link layer information.
  * Returns the unfolded 32bit checksum.
  */
@@ -185,11 +182,10 @@ csum_ipv6_magic(const struct in6_addr *saddr, const struct in6_addr *daddr,
 static inline unsigned add32_with_carry(unsigned a, unsigned b)
 {
 	asm("addl %2,%0\n\t"
-	    "adcl $0,%0" 
-	    : "=r" (a) 
+	    "adcl $0,%0"
+	    : "=r" (a)
 	    : "0" (a), "r" (b));
 	return a;
 }
 
 #endif
-
-- 
1.5.4.rc2

