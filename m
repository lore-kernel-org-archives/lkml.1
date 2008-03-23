Return-Path: <linux-kernel-owner+w=401wt.eu-S1759229AbYCWIIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229AbYCWIIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757857AbYCWIHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:07:42 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1940 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbYCWIHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:07:35 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 012/148] include/asm-x86/byteorder.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:01:47 -0700
Message-Id: <1206259443-13210-13-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/byteorder.h |   39 ++++++++++++++++++++++++---------------
 1 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/include/asm-x86/byteorder.h b/include/asm-x86/byteorder.h
index fe2f2e5..e02ae2d 100644
--- a/include/asm-x86/byteorder.h
+++ b/include/asm-x86/byteorder.h
@@ -8,50 +8,59 @@
 
 #ifdef __i386__
 
-static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
+static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
 {
 #ifdef CONFIG_X86_BSWAP
-	__asm__("bswap %0" : "=r" (x) : "0" (x));
+	asm("bswap %0" : "=r" (x) : "0" (x));
 #else
-	__asm__("xchgb %b0,%h0\n\t"	/* swap lower bytes	*/
-		"rorl $16,%0\n\t"	/* swap words		*/
-		"xchgb %b0,%h0"		/* swap higher bytes	*/
-		:"=q" (x)
-		: "0" (x));
+	asm("xchgb %b0,%h0\n\t"	/* swap lower bytes	*/
+	    "rorl $16,%0\n\t"	/* swap words		*/
+	    "xchgb %b0,%h0"	/* swap higher bytes	*/
+	    : "=q" (x)
+	    : "0" (x));
 #endif
 	return x;
 }
 
-static __inline__ __attribute_const__ __u64 ___arch__swab64(__u64 val)
+static inline __attribute_const__ __u64 ___arch__swab64(__u64 val)
 {
 	union {
-		struct { __u32 a,b; } s;
+		struct {
+			__u32 a;
+			__u32 b;
+		} s;
 		__u64 u;
 	} v;
 	v.u = val;
 #ifdef CONFIG_X86_BSWAP
-	__asm__("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
+	asm("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
 	    : "=r" (v.s.a), "=r" (v.s.b)
 	    : "0" (v.s.a), "1" (v.s.b));
 #else
 	v.s.a = ___arch__swab32(v.s.a);
 	v.s.b = ___arch__swab32(v.s.b);
-	__asm__("xchgl %0,%1" : "=r" (v.s.a), "=r" (v.s.b) : "0" (v.s.a), "1" (v.s.b));
+	asm("xchgl %0,%1"
+	    : "=r" (v.s.a), "=r" (v.s.b)
+	    : "0" (v.s.a), "1" (v.s.b));
 #endif
 	return v.u;
 }
 
 #else /* __i386__ */
 
-static __inline__ __attribute_const__ __u64 ___arch__swab64(__u64 x)
+static inline __attribute_const__ __u64 ___arch__swab64(__u64 x)
 {
-	__asm__("bswapq %0" : "=r" (x) : "0" (x));
+	asm("bswapq %0"
+	    : "=r" (x)
+	    : "0" (x));
 	return x;
 }
 
-static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
+static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
 {
-	__asm__("bswapl %0" : "=r" (x) : "0" (x));
+	asm("bswapl %0"
+	    : "=r" (x)
+	    : "0" (x));
 	return x;
 }
 
-- 
1.5.4.rc2

