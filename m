Return-Path: <linux-kernel-owner+w=401wt.eu-S933853AbYGRANq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853AbYGRANq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 20:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933535AbYGRAKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 20:10:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:11137 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933507AbYGRAKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 20:10:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=IdYp+kX8R3vEfj02GCUwsAXUPI+q+1pfmizVwM//AWAjtbCDweut6pKvGhkqQb7KBC
         tjCnCjH5xpXhjBakSXowbLxEoGs+g9cUPlSm6UUSBzaXLCcL13uCQfA4aSGFQy+XRm8w
         ghuzPBgqhsKyjXqAJ+3ZTIRBRf4I9d6uiKqQE=
Subject: [PATCH 11/20] m68knommu: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 17:09:41 -0700
Message-Id: <1216339781.6029.122.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-m68knommu/byteorder.h |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/include/asm-m68knommu/byteorder.h b/include/asm-m68knommu/byteorder.h
index 20bb442..8a68b3c 100644
--- a/include/asm-m68knommu/byteorder.h
+++ b/include/asm-m68knommu/byteorder.h
@@ -3,13 +3,11 @@
 
 #include <linux/types.h>
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
+#define __BIG_ENDIAN
+#define __SWAB_64_THRU_32__
 
 #if defined (__mcfisaaplus__) || defined (__mcfisac__)
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 val)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
 {
 	asm(
 			"byterev %0"
@@ -18,10 +16,9 @@ static inline __attribute_const__ __u32 ___arch__swab32(__u32 val)
 	   );
 	return val;
 }
-
-#define __arch__swab32(x) ___arch__swab32(x)
+#define HAVE_ARCH_SWAB32
 #endif
 
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _M68KNOMMU_BYTEORDER_H */
-- 
1.5.6.3.569.ga9185


