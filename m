Return-Path: <linux-kernel-owner+w=401wt.eu-S1760325AbYG3BCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760325AbYG3BCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757968AbYG3Az5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:55:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:59233 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbYG3Az4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:55:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=apf2v334x04wVUkxJMAab9g3lTFCD4luoJPkiGulVPuTlJ8gfoyWMiNEiuTv8Pb/rH
         cGL8qdt/MF+tmAj+7SfjnF/gjG6+QvcSKCND+u//hRC7iemRB7xCQoZVVQpQ4mcw6zSL
         fJirWMESwDrXkV8pKmXKhajInumP1j1+QKGm4=
Subject: [PATCH 21/24] xtensa: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 17:55:29 -0700
Message-Id: <1217379329.23389.132.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-xtensa/byteorder.h |   32 +++++++++++++++-----------------
 1 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/include/asm-xtensa/byteorder.h b/include/asm-xtensa/byteorder.h
index 765edf1..07d10ad 100644
--- a/include/asm-xtensa/byteorder.h
+++ b/include/asm-xtensa/byteorder.h
@@ -14,7 +14,17 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
+#ifdef __XTENSA_EL__
+# define __LITTLE_ENDIAN
+#elif defined(__XTENSA_EB__)
+# define __BIG_ENDIAN
+#else
+# error processor byte order undefined!
+#endif
+
+#define __SWAB_64_THRU_32__
+
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
     __u32 res;
     /* instruction sequence from Xtensa ISA release 2/2000 */
@@ -28,8 +38,9 @@ static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
 	    );
     return res;
 }
+#define __arch_swab32 __arch_swab32
 
-static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 x)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 {
     /* Given that 'short' values are signed (i.e., can be negative),
      * we cannot assume that the upper 16-bits of the register are
@@ -62,21 +73,8 @@ static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 x)
 
     return res;
 }
+#define __arch_swab16 __arch_swab16
 
-#define __arch__swab32(x) ___arch__swab32(x)
-#define __arch__swab16(x) ___arch__swab16(x)
-
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#ifdef __XTENSA_EL__
-# include <linux/byteorder/little_endian.h>
-#elif defined(__XTENSA_EB__)
-# include <linux/byteorder/big_endian.h>
-#else
-# error processor byte order undefined!
-#endif
+#include <linux/byteorder.h>
 
 #endif /* _XTENSA_BYTEORDER_H */
-- 
1.6.0.rc1.154.ge3fc


