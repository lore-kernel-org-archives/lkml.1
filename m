Return-Path: <linux-kernel-owner+w=401wt.eu-S933718AbYGRALY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718AbYGRALY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 20:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933491AbYGRAJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 20:09:57 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:11137 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933470AbYGRAJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 20:09:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=PYP9f3p9dTvml0omKW8SteToUzfyIdWvHNafq2stA4PTW5SE7HyyPgpCNVW+dAyfJ3
         RV4ekkQaDTGJ5Y0Ni+F7LY5UtncyqGQES0z16d70QuUObAemb20Ouj4+8YCvQQr9G3C5
         s6HFJLNRwr8rGYZ7oLm73BcJynCv3+5p+2azM=
Subject: [PATCH 05/20] cris: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mikael Starvik <starvik@axis.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 17:09:36 -0700
Message-Id: <1216339776.6029.116.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-cris/arch-v10/byteorder.h |    6 ++++--
 include/asm-cris/arch-v32/byteorder.h |    6 ++++--
 include/asm-cris/byteorder.h          |   18 +++---------------
 3 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/include/asm-cris/arch-v10/byteorder.h b/include/asm-cris/arch-v10/byteorder.h
index 255b646..8aed4e4 100644
--- a/include/asm-cris/arch-v10/byteorder.h
+++ b/include/asm-cris/arch-v10/byteorder.h
@@ -9,18 +9,20 @@
  * them together into ntohl etc.
  */
 
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
 	__asm__ ("swapwb %0" : "=r" (x) : "0" (x));
   
 	return(x);
 }
+#define HAVE_ARCH_SWAB32
 
-static inline __attribute_const__ __u16 ___arch__swab16(__u16 x)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 {
 	__asm__ ("swapb %0" : "=r" (x) : "0" (x));
 	
 	return(x);
 }
+#define HAVE_ARCH_SWAB16
 
 #endif
diff --git a/include/asm-cris/arch-v32/byteorder.h b/include/asm-cris/arch-v32/byteorder.h
index 6ef8fb4..6023146 100644
--- a/include/asm-cris/arch-v32/byteorder.h
+++ b/include/asm-cris/arch-v32/byteorder.h
@@ -4,17 +4,19 @@
 #include <asm/types.h>
 
 static inline __const__ __u32
-___arch__swab32(__u32 x)
+__arch_swab32(__u32 x)
 {
 	__asm__ __volatile__ ("swapwb %0" : "=r" (x) : "0" (x));
 	return (x);
 }
+#define HAVE_ARCH_SWAB32
 
 static inline __const__ __u16
-___arch__swab16(__u16 x)
+__arch_swab16(__u16 x)
 {
 	__asm__ __volatile__ ("swapb %0" : "=r" (x) : "0" (x));
 	return (x);
 }
+#define HAVE_ARCH_SWAB16
 
 #endif /* _ASM_CRIS_ARCH_BYTEORDER_H */
diff --git a/include/asm-cris/byteorder.h b/include/asm-cris/byteorder.h
index 0cd9db1..fb02930 100644
--- a/include/asm-cris/byteorder.h
+++ b/include/asm-cris/byteorder.h
@@ -1,26 +1,14 @@
 #ifndef _CRIS_BYTEORDER_H
 #define _CRIS_BYTEORDER_H
 
-#ifdef __GNUC__
+#define __LITTLE_ENDIAN
+#define __SWAB_64_THRU_32__
 
 #ifdef __KERNEL__
 #include <asm/arch/byteorder.h>
-
-/* defines are necessary because the other files detect the presence
- * of a defined __arch_swab32, not an inline
- */
-#define __arch__swab32(x) ___arch__swab32(x)
-#define __arch__swab16(x) ___arch__swab16(x)
-#endif /* __KERNEL__ */
-
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
 #endif
 
-#endif /* __GNUC__ */
-
-#include <linux/byteorder/little_endian.h>
+#include <linux/byteorder.h>
 
 #endif
 
-- 
1.5.6.3.569.ga9185


