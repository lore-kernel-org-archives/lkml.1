Return-Path: <linux-kernel-owner+w=401wt.eu-S1760498AbYG3A7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760498AbYG3A7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757636AbYG3Azq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:55:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:59233 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587AbYG3Azp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:55:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=lzZpockLhWj7Ayl5cQLyWtS0uh45CoCFVzuRzqlG7FIoELZzQG/I10KMBSifEM+6ki
         ENqy5jak6i+Dvi6l1MrlCeqskqYCpvPjlAKxNBSuJXUJ6960lUaBGymrBfMUQ61bbNf6
         YmtMENTRVkUogO6xtp7HuDO5Qg+wbKlf+UY9w=
Subject: [PATCH 14/24] mn10300: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 17:55:25 -0700
Message-Id: <1217379325.23389.125.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-mn10300/byteorder.h |   23 +++++++----------------
 1 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/include/asm-mn10300/byteorder.h b/include/asm-mn10300/byteorder.h
index 3c993cc..762d8b2 100644
--- a/include/asm-mn10300/byteorder.h
+++ b/include/asm-mn10300/byteorder.h
@@ -13,34 +13,25 @@
 
 #include <asm/types.h>
 
-#ifdef __GNUC__
+#define __LITTLE_ENDIAN
+#define __SWAB_64_THRU_32__
 
-static inline __attribute__((const))
-__u32 ___arch__swab32(__u32 x)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
 	__u32 ret;
 	asm("swap %1,%0" : "=r" (ret) : "r" (x));
 	return ret;
 }
+#define __arch_swab32 __arch_swab32
 
-static inline __attribute__((const))
-__u16 ___arch__swab16(__u16 x)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 {
 	__u16 ret;
 	asm("swaph %1,%0" : "=r" (ret) : "r" (x));
 	return ret;
 }
+#define __arch_swab16 __arch_swab16
 
-#define __arch__swab32(x) ___arch__swab32(x)
-#define __arch__swab16(x) ___arch__swab16(x)
-
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#endif /* __GNUC__ */
-
-#include <linux/byteorder/little_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _ASM_BYTEORDER_H */
-- 
1.6.0.rc1.154.ge3fc


