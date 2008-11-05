Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbYKESgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbYKESgD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 13:36:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbYKESfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 13:35:34 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:14445 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbYKESfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 13:35:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=PEP+rJ2XvHLESC4ySbzyOKApkMcMXcTQ9XEdpCXqzp2J4uOqMsgebBD6z1jL5RJLWY
         EvCGPAqwnb5EQdG9SQMnIHKgaF5bHANtmSaX3bSz46R/wc802EHTH/iBOFFJfkCh7h3z
         U8qCQpcr0PBZXjeSyKbUQGGNvLWF+ot4yaqUg=
Subject: [PATCH 02/10] arm: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 10:35:26 -0800
Message-Id: <1225910126.5991.222.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
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
1.6.0.3.756.gb776d


