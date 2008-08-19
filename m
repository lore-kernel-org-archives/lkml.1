Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbYHSAtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbYHSAtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756341AbYHSAsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:48:06 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:56504 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224AbYHSAsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:48:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ILr6Dgpw/NMoSL/y3zFVq5J8pCB7F4NH5+0VhKf42IRBA6aSW6dVUwhvVR1QIzuHTc
         Cs5OwJh6YwXmbOtq15LA6y30QvVtraF0CgHthxiLg4c3EDl8nf+fXu0NrDZKMTVqT4Kx
         HnSiR5AiwknSGzcsw4nOOfNFT0kChNfPTKvM4=
Subject: [PATCH 05/23] cris: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 17:48:01 -0700
Message-Id: <1219106881.17033.58.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
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
1.6.0.274.g8aacc


