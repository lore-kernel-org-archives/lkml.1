Return-Path: <linux-kernel-owner+w=401wt.eu-S1759612AbYG3A6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbYG3A6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757337AbYG3Azi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:55:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:51866 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283AbYG3Azh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:55:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=twKXzUUvY12l1HUe+52qSTBJZuo49RWEf5Yoly2HQiBA0QUYvaCQ3mht+JMZ0IZvrl
         wx1eL7TGr93Ay8Dc+Csz0BlgSOFnVE6DWLpiadyoE/Kjf61KF0Sn6c7bXZ5PuRb73gsl
         1d9TPci3A0mibzWVS9h8SbYydehVY3ypPT7Z8=
Subject: [PATCH 09/24] ia64: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "tony.luck" <tony.luck@intel.com>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 17:55:21 -0700
Message-Id: <1217379321.23389.120.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-ia64/byteorder.h |   26 +++++++++++---------------
 1 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/include/asm-ia64/byteorder.h b/include/asm-ia64/byteorder.h
index 69bd41d..fac99a2 100644
--- a/include/asm-ia64/byteorder.h
+++ b/include/asm-ia64/byteorder.h
@@ -10,33 +10,29 @@
 #include <asm/intrinsics.h>
 #include <linux/compiler.h>
 
-static __inline__ __attribute_const__ __u64
-__ia64_swab64 (__u64 x)
+#define __LITTLE_ENDIAN
+
+static inline __attribute_const__ __u64 __arch_swab64(__u64 x)
 {
 	__u64 result;
 
 	result = ia64_mux1(x, ia64_mux1_rev);
 	return result;
 }
+#define __arch_swab64 __arch_swab64
 
-static __inline__ __attribute_const__ __u32
-__ia64_swab32 (__u32 x)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
-	return __ia64_swab64(x) >> 32;
+	return __arch_swab64(x) >> 32;
 }
+#define __arch_swab32 __arch_swab32
 
-static __inline__ __attribute_const__ __u16
-__ia64_swab16(__u16 x)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 {
-	return __ia64_swab64(x) >> 48;
+	return __arch_swab64(x) >> 48;
 }
+#define __arch_swab16 __arch_swab16
 
-#define __arch__swab64(x) __ia64_swab64(x)
-#define __arch__swab32(x) __ia64_swab32(x)
-#define __arch__swab16(x) __ia64_swab16(x)
-
-#define __BYTEORDER_HAS_U64__
-
-#include <linux/byteorder/little_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _ASM_IA64_BYTEORDER_H */
-- 
1.6.0.rc1.154.ge3fc


