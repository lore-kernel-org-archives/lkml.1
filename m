Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbYG3A4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbYG3A4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbYG3Az1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:55:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:59233 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbYG3Az0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:55:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=WPJpEuLaZbujuXrmMU/imj5e0ZbqchKaGI1mCS/sFpdN9/aS3D5K0IFAC3/8dfwmJU
         nym7C70n8K0ANaZGnvZ4fMTPXVcv8lPhQXtfswJQpTCnMiVjlsxhOK2/UmKkqq40eLTi
         JYvUM4qlDuJtly7xlzi6g3YrYdIl0q9Ia32MU=
Subject: [PATCH 03/24] arm: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Russell King <rmk@arm.linux.org.uk>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 17:55:18 -0700
Message-Id: <1217379318.23389.114.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-arm/byteorder.h |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/include/asm-arm/byteorder.h b/include/asm-arm/byteorder.h
index e6f7fcd..e3fb7c6 100644
--- a/include/asm-arm/byteorder.h
+++ b/include/asm-arm/byteorder.h
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
1.6.0.rc1.154.ge3fc


