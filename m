Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbYHMA1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbYHMA1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbYHMA0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:26:38 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:49095 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbYHMA0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:26:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=JspZY5Xu9QFQwDbfukGHP9IEC+uiuvAwAy+DuaOqlODnYQDLt6qmYG7goCl7Kurht1
         /k3WF8TJ/RZFI46fWupwdVBrIZzbQvppQZd0lDhMImnvnabmGhwH49OoF8k5gKoHaMW2
         1ca75kFgAkCW7+F2FWRUbAORGcu+KlMkEntE8=
Subject: [PATCH 03/22] avr32: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 17:26:35 -0700
Message-Id: <1218587195.30194.76.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
The prerequisite patches have landed in Linus' tree now.

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
1.6.0.rc2.233.g3cb9d


