Return-Path: <linux-kernel-owner+w=401wt.eu-S933815AbYGRAMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933815AbYGRAMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 20:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761151AbYGRAKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 20:10:05 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:11137 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761004AbYGRAKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 20:10:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=bx+RAWoprZN2/mRU3UqIthKPVfEPZLQvPwLeLFKvXG4UWLt+JWMk18VoYW/kL4A1f/
         ppE4n/l7ALUIP2XEnvDWlAjO6uyqtCMaRTyzZtjYnyIyj0ceQFoPzwRV7UtY/OGNWAN3
         JxMlKQLgrXyXaxwJE209TruUGZ+RtH+Pod8DU=
Subject: [PATCH 08/20] ia64: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "tony.luck" <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 17:09:38 -0700
Message-Id: <1216339779.6029.119.camel@brick>
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
index 69bd41d..afd8ded 100644
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
+#define HAVE_ARCH_SWAB64
 
-static __inline__ __attribute_const__ __u32
-__ia64_swab32 (__u32 x)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
-	return __ia64_swab64(x) >> 32;
+	return __arch_swab64(x) >> 32;
 }
+#define HAVE_ARCH_SWAB32
 
-static __inline__ __attribute_const__ __u16
-__ia64_swab16(__u16 x)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 {
-	return __ia64_swab64(x) >> 48;
+	return __arch_swab64(x) >> 48;
 }
+#define HAVE_ARCH_SWAB16
 
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
1.5.6.3.569.ga9185


