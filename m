Return-Path: <linux-kernel-owner+w=401wt.eu-S1758450AbYHSAyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbYHSAyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbYHSAsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:48:31 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:55104 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531AbYHSAsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:48:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=mwsK2TVXW4BPT19A4KJcepgIWyQqvejdBZ7iIJu4CDxAolgZAVboQKrqNAu0pqwnGh
         dwHuSAFfxxFC2x2IJKOI7Hftma+jUic9TqLzRkPiPPS313VAUySeaicvhyxkMgVfkA1w
         sIniX5Zp288yC1Og37hyo6L/X/uxEbyd0XwTk=
Subject: [PATCH 17/23] sh: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 17:48:16 -0700
Message-Id: <1219106896.17033.70.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/sh/include/asm/byteorder.h |   36 +++++++++++++++++-------------------
 1 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/arch/sh/include/asm/byteorder.h b/arch/sh/include/asm/byteorder.h
index 4c13e61..f5fa065 100644
--- a/arch/sh/include/asm/byteorder.h
+++ b/arch/sh/include/asm/byteorder.h
@@ -8,7 +8,15 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
+#ifdef __LITTLE_ENDIAN__
+# define __LITTLE_ENDIAN
+#else
+# define __BIG_ENDIAN
+#endif
+
+#define __SWAB_64_THRU_32__
+
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
 	__asm__(
 #ifdef __SH5__
@@ -24,8 +32,9 @@ static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
 
 	return x;
 }
+#define __arch_swab32 __arch_swab32
 
-static inline __attribute_const__ __u16 ___arch__swab16(__u16 x)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 {
 	__asm__(
 #ifdef __SH5__
@@ -39,32 +48,21 @@ static inline __attribute_const__ __u16 ___arch__swab16(__u16 x)
 
 	return x;
 }
+#define __arch_swab16 __arch_swab16
 
-static inline __u64 ___arch__swab64(__u64 val)
+static inline __u64 __arch_swab64(__u64 val)
 {
 	union {
 		struct { __u32 a,b; } s;
 		__u64 u;
 	} v, w;
 	v.u = val;
-	w.s.b = ___arch__swab32(v.s.a);
-	w.s.a = ___arch__swab32(v.s.b);
+	w.s.b = __arch_swab32(v.s.a);
+	w.s.a = __arch_swab32(v.s.b);
 	return w.u;
 }
+#define __arch_swab64 __arch_swab64
 
-#define __arch__swab64(x) ___arch__swab64(x)
-#define __arch__swab32(x) ___arch__swab32(x)
-#define __arch__swab16(x) ___arch__swab16(x)
-
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#ifdef __LITTLE_ENDIAN__
-#include <linux/byteorder/little_endian.h>
-#else
-#include <linux/byteorder/big_endian.h>
-#endif
+#include <linux/byteorder.h>
 
 #endif /* __ASM_SH_BYTEORDER_H */
-- 
1.6.0.274.g8aacc


