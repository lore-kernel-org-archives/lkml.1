Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbYHMAcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbYHMAcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbYHMA1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:27:17 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:49095 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbYHMA1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:27:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=gjUnvacnjYheFl4riuDXGg1msUP05snG9aZLJBFd90zyursbm/GkgTsAA3tLC4s+0J
         q4yWYsW6YBwrrsmLiCnAd4CUkKlGKu53AsxifXyFzw500zb4A3fyV+M8rZo1Bwmz1LUY
         vGGUs5VvrE5Rg6lJWP+WYkuPNM0XwRKFjdTpQ=
Subject: [PATCH 17/22] sh: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 17:27:13 -0700
Message-Id: <1218587233.30194.91.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
The prerequisite patches have landed in Linus' tree now.

 arch/sh/include/asm/byteorder.h |   32 +++++++++++++++-----------------
 1 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/arch/sh/include/asm/byteorder.h b/arch/sh/include/asm/byteorder.h
index 4c13e61..60f040a 100644
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
@@ -39,8 +48,9 @@ static inline __attribute_const__ __u16 ___arch__swab16(__u16 x)
 
 	return x;
 }
+#define __arch_swab16 __arch_swab16
 
-static inline __u64 ___arch__swab64(__u64 val)
+static inline __u64 __arch_swab64(__u64 val)
 {
 	union {
 		struct { __u32 a,b; } s;
@@ -51,20 +61,8 @@ static inline __u64 ___arch__swab64(__u64 val)
 	w.s.a = ___arch__swab32(v.s.b);
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
1.6.0.rc2.233.g3cb9d


