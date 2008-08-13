Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbYHMA16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbYHMA16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbYHMA0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:26:42 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:49095 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbYHMA0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:26:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=M3eTHQQOiNUoWPdMiFnY3aMhVDLsOEYI4WzCkw5myYPT4pTTbe4Hw5YF5mid7m7muG
         b5f8m8PMh4kKN8+ZZkQGcqFKZhEMHUjzMFssqe7jB5xCDQBPQgoOVGfKtCShoucj6w4m
         iCwWqOAb8Nx3J+wwU/QW1xrrNHpDPUXlznIXM=
Subject: [PATCH 05/22] cris: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 17:26:36 -0700
Message-Id: <1218587196.30194.78.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
The prerequisite patches have landed in Linus' tree now.

 include/asm-cris/arch-v10/byteorder.h |    6 ++++--
 include/asm-cris/arch-v32/byteorder.h |    6 ++++--
 include/asm-cris/byteorder.h          |   18 +++---------------
 3 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/include/asm-cris/arch-v10/byteorder.h b/include/asm-cris/arch-v10/byteorder.h
index 255b646..d8df864 100644
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
+#define __arch_swab32 __arch_swab32
 
-static inline __attribute_const__ __u16 ___arch__swab16(__u16 x)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 {
 	__asm__ ("swapb %0" : "=r" (x) : "0" (x));
 	
 	return(x);
 }
+#define __arch_swab16 __arch_swab16
 
 #endif
diff --git a/include/asm-cris/arch-v32/byteorder.h b/include/asm-cris/arch-v32/byteorder.h
index 6ef8fb4..fb76087 100644
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
+#define __arch_swab32 __arch_swab32
 
 static inline __const__ __u16
-___arch__swab16(__u16 x)
+__arch_swab16(__u16 x)
 {
 	__asm__ __volatile__ ("swapb %0" : "=r" (x) : "0" (x));
 	return (x);
 }
+#define __arch_swab16 __arch_swab16
 
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
1.6.0.rc2.233.g3cb9d


