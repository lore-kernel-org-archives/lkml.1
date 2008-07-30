Return-Path: <linux-kernel-owner+w=401wt.eu-S1760305AbYG3BBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760305AbYG3BBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757916AbYG3Azy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:55:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:51866 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbYG3Azw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:55:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=g7A1j80RSkVyGzRR/NqGVCqomvuV/JSbYN6uP4USx2FpMUKRRojTxngvG+6G35FsLM
         GkwjSM6P0VVcBjTks+8BRWZzbTE+yBQIfk0XGUMKeSnfvv1CvMFiUMct5ahPn5SEs0RE
         IL2D4vQNBMdKh7EXdh1bPz95X+I3Wvnm9eY2U=
Subject: [PATCH 19/24] sparc: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 17:55:28 -0700
Message-Id: <1217379328.23389.130.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/sparc/include/asm/byteorder.h |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/arch/sparc/include/asm/byteorder.h b/arch/sparc/include/asm/byteorder.h
index bcd83aa..5a70f13 100644
--- a/arch/sparc/include/asm/byteorder.h
+++ b/arch/sparc/include/asm/byteorder.h
@@ -4,15 +4,14 @@
 #include <asm/types.h>
 #include <asm/asi.h>
 
-#ifdef __GNUC__
+#define __BIG_ENDIAN
 
 #ifdef CONFIG_SPARC32
 #define __SWAB_64_THRU_32__
 #endif
 
 #ifdef CONFIG_SPARC64
-
-static inline __u16 ___arch__swab16p(const __u16 *addr)
+static inline __u16 __arch_swab16p(const __u16 *addr)
 {
 	__u16 ret;
 
@@ -21,8 +20,9 @@ static inline __u16 ___arch__swab16p(const __u16 *addr)
 			      : "r" (addr), "i" (ASI_PL));
 	return ret;
 }
+#define __arch_swab16p __arch_swab16p
 
-static inline __u32 ___arch__swab32p(const __u32 *addr)
+static inline __u32 __arch_swab32p(const __u32 *addr)
 {
 	__u32 ret;
 
@@ -31,8 +31,9 @@ static inline __u32 ___arch__swab32p(const __u32 *addr)
 			      : "r" (addr), "i" (ASI_PL));
 	return ret;
 }
+#define __arch_swab32p __arch_swab32p
 
-static inline __u64 ___arch__swab64p(const __u64 *addr)
+static inline __u64 __arch_swab64p(const __u64 *addr)
 {
 	__u64 ret;
 
@@ -41,17 +42,10 @@ static inline __u64 ___arch__swab64p(const __u64 *addr)
 			      : "r" (addr), "i" (ASI_PL));
 	return ret;
 }
-
-#define __arch__swab16p(x) ___arch__swab16p(x)
-#define __arch__swab32p(x) ___arch__swab32p(x)
-#define __arch__swab64p(x) ___arch__swab64p(x)
+#define __arch_swab64p __arch_swab64p
 
 #endif /* CONFIG_SPARC64 */
 
-#define __BYTEORDER_HAS_U64__
-
-#endif
-
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _SPARC_BYTEORDER_H */
-- 
1.6.0.rc1.154.ge3fc


