Return-Path: <linux-kernel-owner+w=401wt.eu-S932511AbYGRAQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbYGRAQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 20:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932309AbYGRAKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 20:10:19 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:11137 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323AbYGRAKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 20:10:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=a7BMcoF3XY0KNeQy1rHRuIu9RbfU6U/A6huVitjmlaSaMNAGtMZ0H+CGSNwncwcF3g
         CKyTm5RahYfSmB+3o3oyHT0v9+7XO83kHsKk5LF+LmD/gKQX9xUeP0DiveLdlLa7QbFj
         Piof2O6Yxj3o3Gx1pfmfwtkV4NlEw3kg47V8M=
Subject: [PATCH 17/20] sh: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 17:09:45 -0700
Message-Id: <1216339785.6029.128.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-sh/byteorder.h |   32 +++++++++++++++-----------------
 1 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/include/asm-sh/byteorder.h b/include/asm-sh/byteorder.h
index 4c13e61..2259210 100644
--- a/include/asm-sh/byteorder.h
+++ b/include/asm-sh/byteorder.h
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
+#define HAVE_ARCH_SWAB32
 
-static inline __attribute_const__ __u16 ___arch__swab16(__u16 x)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 {
 	__asm__(
 #ifdef __SH5__
@@ -39,8 +48,9 @@ static inline __attribute_const__ __u16 ___arch__swab16(__u16 x)
 
 	return x;
 }
+#define HAVE_ARCH_SWAB16
 
-static inline __u64 ___arch__swab64(__u64 val)
+static inline __u64 __arch_swab64(__u64 val)
 {
 	union {
 		struct { __u32 a,b; } s;
@@ -51,20 +61,8 @@ static inline __u64 ___arch__swab64(__u64 val)
 	w.s.a = ___arch__swab32(v.s.b);
 	return w.u;
 }
+#define HAVE_ARCH_SWAB64
 
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
1.5.6.3.569.ga9185


