Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbYHSAsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbYHSAsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbYHSAr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:47:59 -0400
Received: from hs-out-0708.google.com ([64.233.178.250]:26031 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558AbYHSAr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:47:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ITdet0VHz0k4jQX3G1uO8lDhp81BWL1qGy6J8IMgYJhpnNGFrNND0yOkv6P4ec5O73
         Tt4tId+8sv7O3xm1bf3iL4lq9Cc9YX3vafakNQa6uKCKY8y8qDekbwjsx0FKEi5kirGo
         bDRyJJIJjhiYB2w7bTD/Z4LvsBg+NYpnvUgp8=
Subject: [PATCH 02/23] arm: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <rmk@arm.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 17:47:55 -0700
Message-Id: <1219106875.17033.55.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/arm/include/asm/byteorder.h |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/arm/include/asm/byteorder.h b/arch/arm/include/asm/byteorder.h
index 4fbfb22..d04a7a2 100644
--- a/arch/arm/include/asm/byteorder.h
+++ b/arch/arm/include/asm/byteorder.h
@@ -18,7 +18,15 @@
 #include <linux/compiler.h>
 #include <asm/types.h>
 
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
+#ifdef __ARMEB__
+# define __BIG_ENDIAN
+#else
+# define __LITTLE_ENDIAN
+#endif
+
+#define __SWAB_64_THRU_32__
+
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
 	__u32 t;
 
@@ -40,19 +48,8 @@ static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
 
 	return x;
 }
+#define __arch_swab32 __arch_swab32
 
-#define __arch__swab32(x) ___arch__swab32(x)
-
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#ifdef __ARMEB__
-#include <linux/byteorder/big_endian.h>
-#else
-#include <linux/byteorder/little_endian.h>
-#endif
+#include <linux/byteorder.h>
 
 #endif
-
-- 
1.6.0.274.g8aacc


