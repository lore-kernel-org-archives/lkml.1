Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbYHMAad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbYHMAad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbYHMA04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:26:56 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:33264 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbYHMA0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:26:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=m/3w/kFAGYV2SVw32VhBmlioXaMDyKDOCInuh7f8Y97UN1q7ZBKXQ4xX7/OP5WZfm8
         bDA3HQSxW4D1R8bDjJLKEBC1VJ+zR9LmKpew5jCP9qmpExNFSIUii/p3cDJpvntPpcdN
         rMPDzMcExQTl4jTtC3FqTluWsXDRDjq5NMmy8=
Subject: [PATCH 12/22] mips: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "ralf@linux-mips.org" <ralf@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 17:26:41 -0700
Message-Id: <1218587201.30194.85.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
The prerequisite patches have landed in Linus' tree now.

 include/asm-mips/byteorder.h |   40 ++++++++++++++++------------------------
 1 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/include/asm-mips/byteorder.h b/include/asm-mips/byteorder.h
index fe7dc2d..2988d29 100644
--- a/include/asm-mips/byteorder.h
+++ b/include/asm-mips/byteorder.h
@@ -11,11 +11,19 @@
 #include <linux/compiler.h>
 #include <asm/types.h>
 
-#ifdef __GNUC__
+#if defined(__MIPSEB__)
+# define __BIG_ENDIAN
+#elif defined(__MIPSEL__)
+# define __LITTLE_ENDIAN
+#else
+# error "MIPS, but neither __MIPSEB__, nor __MIPSEL__???"
+#endif
+
+#define __SWAB_64_THRU_32__
 
 #ifdef CONFIG_CPU_MIPSR2
 
-static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 x)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 {
 	__asm__(
 	"	wsbh	%0, %1			\n"
@@ -24,9 +32,9 @@ static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 x)
 
 	return x;
 }
-#define __arch__swab16(x)	___arch__swab16(x)
+#define __arch_swab16 __arch_swab16
 
-static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
 	__asm__(
 	"	wsbh	%0, %1			\n"
@@ -36,11 +44,10 @@ static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
 
 	return x;
 }
-#define __arch__swab32(x)	___arch__swab32(x)
+#define __arch_swab32 __arch_swab32
 
 #ifdef CONFIG_CPU_MIPS64_R2
-
-static __inline__ __attribute_const__ __u64 ___arch__swab64(__u64 x)
+static inline __attribute_const__ __u64 __arch_swab64(__u64 x)
 {
 	__asm__(
 	"	dsbh	%0, %1			\n"
@@ -51,26 +58,11 @@ static __inline__ __attribute_const__ __u64 ___arch__swab64(__u64 x)
 
 	return x;
 }
-
-#define __arch__swab64(x)	___arch__swab64(x)
-
+#define __arch_swab64 __arch_swab64
 #endif /* CONFIG_CPU_MIPS64_R2 */
 
 #endif /* CONFIG_CPU_MIPSR2 */
 
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#endif /* __GNUC__ */
-
-#if defined(__MIPSEB__)
-#  include <linux/byteorder/big_endian.h>
-#elif defined(__MIPSEL__)
-#  include <linux/byteorder/little_endian.h>
-#else
-#  error "MIPS, but neither __MIPSEB__, nor __MIPSEL__???"
-#endif
+#include <linux/byteorder.h>
 
 #endif /* _ASM_BYTEORDER_H */
-- 
1.6.0.rc2.233.g3cb9d


