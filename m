Return-Path: <linux-kernel-owner+w=401wt.eu-S1757689AbYHSAv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689AbYHSAv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756274AbYHSAsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:48:18 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:56504 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbYHSAsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:48:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Kf44EevK+SNNg3dYCWU7zBSbFQx7Tiv+VfdULJKDrbXzyFY7i7tepFxlgK1Wv5pfEj
         piAnYUKgaN5ba8rqLEbfdzkARu2b1q7uMwJwBkhExBTDbXZud7t4zlZHR8JfRtGxTghd
         33seKacKQEno0xPjxzRa/8R5HnP/OEMvBcIto=
Subject: [PATCH 10/23] m68k: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 17:48:07 -0700
Message-Id: <1219106887.17033.63.camel@brick>
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
index 81d420b..b354acd 100644
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
+#define __arch_swab32 __arch_swab32
 
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
1.6.0.274.g8aacc


