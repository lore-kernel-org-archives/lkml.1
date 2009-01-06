Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbZAFVck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbZAFVck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbZAFVcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:32:01 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:9512 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbZAFVb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:31:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ZebCPi0Tw9/rqdvtn52Yux1bDHK689EE7coZjgRrqgxkJyQ3x57EkoYQ/mHeRP4hqI
         xT5a8xqvGelD4t+cK6cHm/+kHyRtxx3ruH//7FBWFYdWNNMJA7lhBmJsCMO8BBnUnvyP
         8j5EzveUQi/WsUjYOgu6OeT7wuMJC3eDdd73k=
Subject: [PATCH 02/23] avr32: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 13:30:45 -0800
Message-Id: <1231277445.964.259.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/avr32/include/asm/Kbuild      |    1 +
 arch/avr32/include/asm/byteorder.h |   31 ++-----------------------------
 arch/avr32/include/asm/swab.h      |   35 +++++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 29 deletions(-)

diff --git a/arch/avr32/include/asm/Kbuild b/arch/avr32/include/asm/Kbuild
index 3136628..219822c 100644
--- a/arch/avr32/include/asm/Kbuild
+++ b/arch/avr32/include/asm/Kbuild
@@ -1,3 +1,4 @@
 include include/asm-generic/Kbuild.asm
 
+header-y	+= swab.h
 header-y	+= cachectl.h
diff --git a/arch/avr32/include/asm/byteorder.h b/arch/avr32/include/asm/byteorder.h
index 8e3af02..2aba64b 100644
--- a/arch/avr32/include/asm/byteorder.h
+++ b/arch/avr32/include/asm/byteorder.h
@@ -4,34 +4,7 @@
 #ifndef __ASM_AVR32_BYTEORDER_H
 #define __ASM_AVR32_BYTEORDER_H
 
-#include <asm/types.h>
-#include <linux/compiler.h>
+#include <asm/swab.h>
+#include <linux/byteorder/big_endian.h>
 
-#define __BIG_ENDIAN
-#define __SWAB_64_THRU_32__
-
-#ifdef __CHECKER__
-extern unsigned long __builtin_bswap_32(unsigned long x);
-extern unsigned short __builtin_bswap_16(unsigned short x);
-#endif
-
-/*
- * avr32-linux-gcc versions earlier than 4.2 improperly sign-extends
- * the result.
- */
-#if !(__GNUC__ == 4 && __GNUC_MINOR__ < 2)
-static inline __attribute_const__ __u16 __arch_swab16(__u16 val)
-{
-	return __builtin_bswap_16(val);
-}
-#define __arch_swab16 __arch_swab16
-
-static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
-{
-	return __builtin_bswap_32(val);
-}
-#define __arch_swab32 __arch_swab32
-#endif
-
-#include <linux/byteorder.h>
 #endif /* __ASM_AVR32_BYTEORDER_H */
diff --git a/arch/avr32/include/asm/swab.h b/arch/avr32/include/asm/swab.h
new file mode 100644
index 0000000..a14aa5b
--- /dev/null
+++ b/arch/avr32/include/asm/swab.h
@@ -0,0 +1,35 @@
+/*
+ * AVR32 byteswapping functions.
+ */
+#ifndef __ASM_AVR32_SWAB_H
+#define __ASM_AVR32_SWAB_H
+
+#include <asm/types.h>
+#include <linux/compiler.h>
+
+#define __SWAB_64_THRU_32__
+
+#ifdef __CHECKER__
+extern unsigned long __builtin_bswap_32(unsigned long x);
+extern unsigned short __builtin_bswap_16(unsigned short x);
+#endif
+
+/*
+ * avr32-linux-gcc versions earlier than 4.2 improperly sign-extends
+ * the result.
+ */
+#if !(__GNUC__ == 4 && __GNUC_MINOR__ < 2)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 val)
+{
+	return __builtin_bswap_16(val);
+}
+#define __arch_swab16 __arch_swab16
+
+static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
+{
+	return __builtin_bswap_32(val);
+}
+#define __arch_swab32 __arch_swab32
+#endif
+
+#endif /* __ASM_AVR32_SWAB_H */
-- 
1.6.1.94.g9388


