Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbYKESiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbYKESiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 13:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756487AbYKESft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 13:35:49 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:10710 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302AbYKESfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 13:35:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=t3AyuKOfXm6rHNgNrhZ9FReYYUG7AGyhcqGJP36qxWmIKTYJpy5IOe/I+FcHko4qf9
         12sknt8Hj7asN/7nPYA9RF/tP3Jge6zHW4x/gR90DB4uXMpjVJ4vqsilBhlwcQx6M5WC
         HYpPE7TqVaJc+UlvNAJRXHpQVR0KCcoX3vhqo=
Subject: [PATCH 10/10] xtensa: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Chris Zankel <chris@zankel.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 10:35:31 -0800
Message-Id: <1225910131.5991.230.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
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
1.6.0.3.756.gb776d

