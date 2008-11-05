Return-Path: <linux-kernel-owner+w=401wt.eu-S1757018AbYKEShZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbYKEShZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 13:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755856AbYKESfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 13:35:40 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:14445 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555AbYKESfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 13:35:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=jyNJ0atm+6eIwrysV2Kx5gwR2RHaOZi5DkrHLOeVE9SPal/K0X5wxnbWrTnGvKWWdL
         57AExGttEMmJhIIh8Dyif3E4Xw+tFqIj1fS1skaEuyrpecroxeHNqsC+D/AFdHszoEMV
         UX9dfW6mqcj76+zfygsglQYakyhTlaEhwl7j0=
Subject: [PATCH 06/10] ia64: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "tony.luck" <tony.luck@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 10:35:28 -0800
Message-Id: <1225910128.5991.226.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/ia64/include/asm/byteorder.h |   26 +++++++++++---------------
 1 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/arch/ia64/include/asm/byteorder.h b/arch/ia64/include/asm/byteorder.h
index 69bd41d..fac99a2 100644
--- a/arch/ia64/include/asm/byteorder.h
+++ b/arch/ia64/include/asm/byteorder.h
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
1.6.0.3.756.gb776d


