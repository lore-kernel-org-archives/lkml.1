Return-Path: <linux-kernel-owner+w=401wt.eu-S1760223AbYG3A7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223AbYG3A7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757577AbYG3Azp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:55:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:59233 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbYG3Azn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:55:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=I+WvZLYC139Z63LRC0hyMxXUAKoDtvIgl+3a5NALs+AkCTrEgidZkU//FN7Hnn/+t+
         5py7Ko6Sk8+qfjR5GfMDg2/AgYnF573dukQ9ONEuoL8/JJ4WTYaeNRM0YXUrn/wif61C
         Jd94A0xvoyN6++J+TKwPSom5BskaxIhMkctD4=
Subject: [PATCH 13/24] mips: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "ralf@linux-mips.org" <ralf@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 17:55:25 -0700
Message-Id: <1217379325.23389.124.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
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
1.6.0.rc1.154.ge3fc


