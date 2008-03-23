Return-Path: <linux-kernel-owner+w=401wt.eu-S1759779AbYCWIKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759779AbYCWIKX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758239AbYCWIHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:07:45 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1965 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbYCWIHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:07:37 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 014/148] include/asm-x86/checksum_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:49 -0700
Message-Id: <1206259443-13210-15-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/checksum_32.h |  152 ++++++++++++++++++++---------------------
 1 files changed, 75 insertions(+), 77 deletions(-)

diff --git a/include/asm-x86/checksum_32.h b/include/asm-x86/checksum_32.h
index 75194ab..52bbb0d 100644
--- a/include/asm-x86/checksum_32.h
+++ b/include/asm-x86/checksum_32.h
@@ -28,7 +28,8 @@ asmlinkage __wsum csum_partial(const void *buff, int len, __wsum sum);
  */
 
 asmlinkage __wsum csum_partial_copy_generic(const void *src, void *dst,
-						  int len, __wsum sum, int *src_err_ptr, int *dst_err_ptr);
+					    int len, __wsum sum,
+					    int *src_err_ptr, int *dst_err_ptr);
 
 /*
  *	Note: when you get a NULL pointer exception here this means someone
@@ -37,20 +38,20 @@ asmlinkage __wsum csum_partial_copy_generic(const void *src, void *dst,
  *	If you use these functions directly please don't forget the
  *	access_ok().
  */
-static __inline__
-__wsum csum_partial_copy_nocheck (const void *src, void *dst,
-					int len, __wsum sum)
+static inline __wsum csum_partial_copy_nocheck(const void *src, void *dst,
+					       int len, __wsum sum)
 {
-	return csum_partial_copy_generic ( src, dst, len, sum, NULL, NULL);
+	return csum_partial_copy_generic(src, dst, len, sum, NULL, NULL);
 }
 
-static __inline__
-__wsum csum_partial_copy_from_user(const void __user *src, void *dst,
-						int len, __wsum sum, int *err_ptr)
+static inline __wsum csum_partial_copy_from_user(const void __user *src,
+						 void *dst,
+						 int len, __wsum sum,
+						 int *err_ptr)
 {
 	might_sleep();
 	return csum_partial_copy_generic((__force void *)src, dst,
-					len, sum, err_ptr, NULL);
+					 len, sum, err_ptr, NULL);
 }
 
 /*
@@ -64,30 +65,29 @@ static inline __sum16 ip_fast_csum(const void *iph, unsigned int ihl)
 {
 	unsigned int sum;
 
-	__asm__ __volatile__(
-	    "movl (%1), %0	;\n"
-	    "subl $4, %2	;\n"
-	    "jbe 2f		;\n"
-	    "addl 4(%1), %0	;\n"
-	    "adcl 8(%1), %0	;\n"
-	    "adcl 12(%1), %0	;\n"
-"1:	    adcl 16(%1), %0	;\n"
-	    "lea 4(%1), %1	;\n"
-	    "decl %2		;\n"
-	    "jne 1b		;\n"
-	    "adcl $0, %0	;\n"
-	    "movl %0, %2	;\n"
-	    "shrl $16, %0	;\n"
-	    "addw %w2, %w0	;\n"
-	    "adcl $0, %0	;\n"
-	    "notl %0		;\n"
-"2:				;\n"
+	asm volatile("movl (%1), %0	;\n"
+		     "subl $4, %2	;\n"
+		     "jbe 2f		;\n"
+		     "addl 4(%1), %0	;\n"
+		     "adcl 8(%1), %0	;\n"
+		     "adcl 12(%1), %0;\n"
+		     "1:	adcl 16(%1), %0	;\n"
+		     "lea 4(%1), %1	;\n"
+		     "decl %2	;\n"
+		     "jne 1b		;\n"
+		     "adcl $0, %0	;\n"
+		     "movl %0, %2	;\n"
+		     "shrl $16, %0	;\n"
+		     "addw %w2, %w0	;\n"
+		     "adcl $0, %0	;\n"
+		     "notl %0	;\n"
+		     "2:		;\n"
 	/* Since the input registers which are loaded with iph and ihl
 	   are modified, we must also specify them as outputs, or gcc
 	   will assume they contain their original values. */
-	: "=r" (sum), "=r" (iph), "=r" (ihl)
-	: "1" (iph), "2" (ihl)
-	: "memory");
+		     : "=r" (sum), "=r" (iph), "=r" (ihl)
+		     : "1" (iph), "2" (ihl)
+		     : "memory");
 	return (__force __sum16)sum;
 }
 
@@ -97,29 +97,27 @@ static inline __sum16 ip_fast_csum(const void *iph, unsigned int ihl)
 
 static inline __sum16 csum_fold(__wsum sum)
 {
-	__asm__(
-		"addl %1, %0		;\n"
-		"adcl $0xffff, %0	;\n"
-		: "=r" (sum)
-		: "r" ((__force u32)sum << 16),
-		  "0" ((__force u32)sum & 0xffff0000)
-	);
+	asm("addl %1, %0		;\n"
+	    "adcl $0xffff, %0	;\n"
+	    : "=r" (sum)
+	    : "r" ((__force u32)sum << 16),
+	      "0" ((__force u32)sum & 0xffff0000));
 	return (__force __sum16)(~(__force u32)sum >> 16);
 }
 
 static inline __wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr,
-					   unsigned short len,
-					   unsigned short proto,
-					   __wsum sum)
+					unsigned short len,
+					unsigned short proto,
+					__wsum sum)
 {
-    __asm__(
-	"addl %1, %0	;\n"
-	"adcl %2, %0	;\n"
-	"adcl %3, %0	;\n"
-	"adcl $0, %0	;\n"
-	: "=r" (sum)
-	: "g" (daddr), "g"(saddr), "g"((len + proto) << 8), "0"(sum));
-    return sum;
+	asm("addl %1, %0	;\n"
+	    "adcl %2, %0	;\n"
+	    "adcl %3, %0	;\n"
+	    "adcl $0, %0	;\n"
+	    : "=r" (sum)
+	    : "g" (daddr), "g"(saddr),
+	      "g" ((len + proto) << 8), "0" (sum));
+	return sum;
 }
 
 /*
@@ -127,11 +125,11 @@ static inline __wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr,
  * returns a 16-bit checksum, already complemented
  */
 static inline __sum16 csum_tcpudp_magic(__be32 saddr, __be32 daddr,
-						   unsigned short len,
-						   unsigned short proto,
-						   __wsum sum)
+					unsigned short len,
+					unsigned short proto,
+					__wsum sum)
 {
-	return csum_fold(csum_tcpudp_nofold(saddr,daddr,len,proto,sum));
+	return csum_fold(csum_tcpudp_nofold(saddr, daddr, len, proto, sum));
 }
 
 /*
@@ -141,30 +139,29 @@ static inline __sum16 csum_tcpudp_magic(__be32 saddr, __be32 daddr,
 
 static inline __sum16 ip_compute_csum(const void *buff, int len)
 {
-    return csum_fold (csum_partial(buff, len, 0));
+    return csum_fold(csum_partial(buff, len, 0));
 }
 
 #define _HAVE_ARCH_IPV6_CSUM
-static __inline__ __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
-					  const struct in6_addr *daddr,
-					  __u32 len, unsigned short proto,
-					  __wsum sum)
+static inline __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
+				      const struct in6_addr *daddr,
+				      __u32 len, unsigned short proto,
+				      __wsum sum)
 {
-	__asm__(
-		"addl 0(%1), %0		;\n"
-		"adcl 4(%1), %0		;\n"
-		"adcl 8(%1), %0		;\n"
-		"adcl 12(%1), %0	;\n"
-		"adcl 0(%2), %0		;\n"
-		"adcl 4(%2), %0		;\n"
-		"adcl 8(%2), %0		;\n"
-		"adcl 12(%2), %0	;\n"
-		"adcl %3, %0		;\n"
-		"adcl %4, %0		;\n"
-		"adcl $0, %0		;\n"
-		: "=&r" (sum)
-		: "r" (saddr), "r" (daddr),
-		  "r"(htonl(len)), "r"(htonl(proto)), "0"(sum));
+	asm("addl 0(%1), %0	;\n"
+	    "adcl 4(%1), %0	;\n"
+	    "adcl 8(%1), %0	;\n"
+	    "adcl 12(%1), %0	;\n"
+	    "adcl 0(%2), %0	;\n"
+	    "adcl 4(%2), %0	;\n"
+	    "adcl 8(%2), %0	;\n"
+	    "adcl 12(%2), %0	;\n"
+	    "adcl %3, %0	;\n"
+	    "adcl %4, %0	;\n"
+	    "adcl $0, %0	;\n"
+	    : "=&r" (sum)
+	    : "r" (saddr), "r" (daddr),
+	      "r" (htonl(len)), "r" (htonl(proto)), "0" (sum));
 
 	return csum_fold(sum);
 }
@@ -173,14 +170,15 @@ static __inline__ __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
  *	Copy and checksum to user
  */
 #define HAVE_CSUM_COPY_USER
-static __inline__ __wsum csum_and_copy_to_user(const void *src,
-						     void __user *dst,
-						     int len, __wsum sum,
-						     int *err_ptr)
+static inline __wsum csum_and_copy_to_user(const void *src,
+					   void __user *dst,
+					   int len, __wsum sum,
+					   int *err_ptr)
 {
 	might_sleep();
 	if (access_ok(VERIFY_WRITE, dst, len))
-		return csum_partial_copy_generic(src, (__force void *)dst, len, sum, NULL, err_ptr);
+		return csum_partial_copy_generic(src, (__force void *)dst,
+						 len, sum, NULL, err_ptr);
 
 	if (len)
 		*err_ptr = -EFAULT;
-- 
1.5.4.rc2

