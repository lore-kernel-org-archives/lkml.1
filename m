Return-Path: <linux-kernel-owner+w=401wt.eu-S1756948AbYKESgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbYKESgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 13:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbYKESff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 13:35:35 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:10710 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbYKESfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 13:35:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=bAnnjchyg7AWF24gC84WkJ4inq1DzYwAsuLmNdhbwEGgTLwGdi5LDWdD7XUo/bzVmO
         Afvo2Azn3s8GmrC18RSgUBSbrSTOW87gcbUBbv8cKF4OpC62kuN8oqynV0TP1aVptz1t
         Q1DrjxmVzZEGVXwqAgR+V5qzOVUMDBXSQ+IO0=
Subject: [PATCH 03/10] blackfin: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Bryan Wu <cooloney@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 10:35:27 -0800
Message-Id: <1225910127.5991.223.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/blackfin/include/asm/byteorder.h |   33 +++++++++++++++------------------
 1 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/arch/blackfin/include/asm/byteorder.h b/arch/blackfin/include/asm/byteorder.h
index 6a673d4..6bc8d18 100644
--- a/arch/blackfin/include/asm/byteorder.h
+++ b/arch/blackfin/include/asm/byteorder.h
@@ -4,9 +4,10 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-#ifdef __GNUC__
+#define __LITTLE_ENDIAN
+#define __SWAB_64_THRU_32__
 
-static __inline__ __attribute_const__ __u32 ___arch__swahb32(__u32 xx)
+static inline __attribute_const__ __u32 __arch_swahb32(__u32 xx)
 {
 	__u32 tmp;
 	__asm__("%1 = %0 >> 8 (V);\n\t"
@@ -15,34 +16,30 @@ static __inline__ __attribute_const__ __u32 ___arch__swahb32(__u32 xx)
 		: "+d"(xx), "=&d"(tmp));
 	return xx;
 }
+#define __arch_swahb32 __arch_swahb32
 
-static __inline__ __attribute_const__ __u32 ___arch__swahw32(__u32 xx)
+static inline __attribute_const__ __u32 __arch_swahw32(__u32 xx)
 {
 	__u32 rv;
 	__asm__("%0 = PACK(%1.L, %1.H);\n\t": "=d"(rv): "d"(xx));
 	return rv;
 }
+#define __arch_swahw32 __arch_swahw32
 
-#define __arch__swahb32(x) ___arch__swahb32(x)
-#define __arch__swahw32(x) ___arch__swahw32(x)
-#define __arch__swab32(x) ___arch__swahb32(___arch__swahw32(x))
+static inline __attribute_const__ __u32 __arch_swab32(__u32 xx)
+{
+	return __arch_swahb32(__arch_swahw32(xx));
+}
+#define __arch_swab32 __arch_swab32
 
-static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 xx)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 xx)
 {
 	__u32 xw = xx;
 	__asm__("%0 <<= 8;\n	%0.L = %0.L + %0.H (NS);\n": "+d"(xw));
 	return (__u16)xw;
 }
+#define __arch_swab16 __arch_swab16
 
-#define __arch__swab16(x) ___arch__swab16(x)
-
-#endif
-
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#include <linux/byteorder/little_endian.h>
+#include <linux/byteorder.h>
 
-#endif				/* _BLACKFIN_BYTEORDER_H */
+#endif /* _BLACKFIN_BYTEORDER_H */
-- 
1.6.0.3.756.gb776d


