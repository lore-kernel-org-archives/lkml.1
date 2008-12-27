Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbYL0GvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbYL0GvQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 01:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbYL0GuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 01:50:07 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:36103 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbYL0GuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 01:50:05 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86 byteorder.h: use __asm__/__inline__ for userspace
Date: Sat, 27 Dec 2008 01:50:04 -0500
Message-Id: <1230360604-6711-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use __asm__/__inline__ rather than asm/inline for all the functions
exported to userspace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/x86/include/asm/byteorder.h |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/byteorder.h b/arch/x86/include/asm/byteorder.h
index e02ae2d..16f7c01 100644
--- a/arch/x86/include/asm/byteorder.h
+++ b/arch/x86/include/asm/byteorder.h
@@ -8,12 +8,12 @@
 
 #ifdef __i386__
 
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
+static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
 {
 #ifdef CONFIG_X86_BSWAP
-	asm("bswap %0" : "=r" (x) : "0" (x));
+	__asm__("bswap %0" : "=r" (x) : "0" (x));
 #else
-	asm("xchgb %b0,%h0\n\t"	/* swap lower bytes	*/
+	__asm__("xchgb %b0,%h0\n\t"	/* swap lower bytes	*/
 	    "rorl $16,%0\n\t"	/* swap words		*/
 	    "xchgb %b0,%h0"	/* swap higher bytes	*/
 	    : "=q" (x)
@@ -22,7 +22,7 @@ static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
 	return x;
 }
 
-static inline __attribute_const__ __u64 ___arch__swab64(__u64 val)
+static __inline__ __attribute_const__ __u64 ___arch__swab64(__u64 val)
 {
 	union {
 		struct {
@@ -33,13 +33,13 @@ static inline __attribute_const__ __u64 ___arch__swab64(__u64 val)
 	} v;
 	v.u = val;
 #ifdef CONFIG_X86_BSWAP
-	asm("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
+	__asm__("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
 	    : "=r" (v.s.a), "=r" (v.s.b)
 	    : "0" (v.s.a), "1" (v.s.b));
 #else
 	v.s.a = ___arch__swab32(v.s.a);
 	v.s.b = ___arch__swab32(v.s.b);
-	asm("xchgl %0,%1"
+	__asm__("xchgl %0,%1"
 	    : "=r" (v.s.a), "=r" (v.s.b)
 	    : "0" (v.s.a), "1" (v.s.b));
 #endif
@@ -48,17 +48,17 @@ static inline __attribute_const__ __u64 ___arch__swab64(__u64 val)
 
 #else /* __i386__ */
 
-static inline __attribute_const__ __u64 ___arch__swab64(__u64 x)
+static __inline__ __attribute_const__ __u64 ___arch__swab64(__u64 x)
 {
-	asm("bswapq %0"
+	__asm__("bswapq %0"
 	    : "=r" (x)
 	    : "0" (x));
 	return x;
 }
 
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
+static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
 {
-	asm("bswapl %0"
+	__asm__("bswapl %0"
 	    : "=r" (x)
 	    : "0" (x));
 	return x;
-- 
1.6.0.6

