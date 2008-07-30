Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbYG3A4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbYG3A4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755968AbYG3Az3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:55:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:59233 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358AbYG3Az2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:55:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Km3i6z8MJ145eq40bT8y63b/taNKD1shctuKbcpXjOyE8KHOYCe91aCGG0f481SFsB
         lLyQqvfjQ2cMBxLKAoaCRzNgVKTaoUxj5CbZUjYaIVppy+uE+cbBF5GU2N3hN00mazd4
         /uQZ6M5w/oU9vq+6EjzoNm0IOiQlryLkHVTPs=
Subject: [PATCH 04/24] avr32: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 17:55:19 -0700
Message-Id: <1217379319.23389.115.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-avr32/byteorder.h |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/include/asm-avr32/byteorder.h b/include/asm-avr32/byteorder.h
index d77b48b..8e3af02 100644
--- a/include/asm-avr32/byteorder.h
+++ b/include/asm-avr32/byteorder.h
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
1.6.0.rc1.154.ge3fc


