Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbYHSAsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbYHSAsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756176AbYHSAsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:48:00 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:56504 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050AbYHSAr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:47:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=I3VYVbfPCW66fppQAAV4xcgwTa5G8ZHb18WjfiLS4TIiSO/KtQMvEqY47EozXgUoqX
         YH8TSbZrzFbi/6SUbJJDfRQQEuT/viaIH4pM3rLp0p+lDQcAdV+RaLwxAryyROO1uQCH
         Agj6EOUwmy1p/e/yYg++MqhIW+XM92dAky6Xo=
Subject: [PATCH 03/23] avr32: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 17:47:57 -0700
Message-Id: <1219106877.17033.56.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/avr32/include/asm/byteorder.h |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/avr32/include/asm/byteorder.h b/arch/avr32/include/asm/byteorder.h
index d77b48b..8e3af02 100644
--- a/arch/avr32/include/asm/byteorder.h
+++ b/arch/avr32/include/asm/byteorder.h
@@ -7,6 +7,9 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
+#define __BIG_ENDIAN
+#define __SWAB_64_THRU_32__
+
 #ifdef __CHECKER__
 extern unsigned long __builtin_bswap_32(unsigned long x);
 extern unsigned short __builtin_bswap_16(unsigned short x);
@@ -17,15 +20,18 @@ extern unsigned short __builtin_bswap_16(unsigned short x);
  * the result.
  */
 #if !(__GNUC__ == 4 && __GNUC_MINOR__ < 2)
-#define __arch__swab32(x) __builtin_bswap_32(x)
-#define __arch__swab16(x) __builtin_bswap_16(x)
-#endif
+static inline __attribute_const__ __u16 __arch_swab16(__u16 val)
+{
+	return __builtin_bswap_16(val);
+}
+#define __arch_swab16 __arch_swab16
 
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-# define __BYTEORDER_HAS_U64__
-# define __SWAB_64_THRU_32__
+static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
+{
+	return __builtin_bswap_32(val);
+}
+#define __arch_swab32 __arch_swab32
 #endif
 
-#include <linux/byteorder/big_endian.h>
-
+#include <linux/byteorder.h>
 #endif /* __ASM_AVR32_BYTEORDER_H */
-- 
1.6.0.274.g8aacc


