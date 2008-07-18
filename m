Return-Path: <linux-kernel-owner+w=401wt.eu-S933903AbYGRAN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903AbYGRAN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 20:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760922AbYGRAKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 20:10:08 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:57293 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761156AbYGRAKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 20:10:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=auws2x3xEx4+PVLJ0kE+SZYMw+gqyctW6tgs33A1CAwyxt3xlWzv7EM7JxGvtnejUC
         WlRhy6VaGF4MOg/rDqw9s1COzAw2wviDNNolkNui+VnGqT2EdO5vA48dmgCGJu4ZSr4c
         hfTJZ4VFbYRDJN2Oa9+QCgLNswAAfcHtwkvfk=
Subject: [PATCH 10/20] m68k: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 17:09:40 -0700
Message-Id: <1216339780.6029.121.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-m68k/byteorder.h |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/include/asm-m68k/byteorder.h b/include/asm-m68k/byteorder.h
index 81d420b..4569d49 100644
--- a/include/asm-m68k/byteorder.h
+++ b/include/asm-m68k/byteorder.h
@@ -4,22 +4,16 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-#ifdef __GNUC__
+#define __BIG_ENDIAN
+#define __SWAB_64_THRU_32__
 
-static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 val)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
 {
 	__asm__("rolw #8,%0; swap %0; rolw #8,%0" : "=d" (val) : "0" (val));
 	return val;
 }
-#define __arch__swab32(x) ___arch__swab32(x)
+#define HAVE_ARCH_SWAB32
 
-#endif
-
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _M68K_BYTEORDER_H */
-- 
1.5.6.3.569.ga9185


