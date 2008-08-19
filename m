Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbYHSAvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbYHSAvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbYHSAsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:48:20 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:56504 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302AbYHSAsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:48:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=c2yR31LEBpSuHXnLjaWEE8CSmaOUsKhcYszMiR17gBhdaR7NnCimUZlUDLsfuGNfDE
         xcn9gZrZfb9Db1ByIvl24lLAlSnA4i9/3Tr8gwXHOy19INc7rYTDeI3F2PISTesIj2/D
         tTvk11lu6ZpAdzKnwqO8sGG1VfoLgFCVq980U=
Subject: [PATCH 11/23] m68knommu: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Ungerer <gerg@uclinux.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 17:48:08 -0700
Message-Id: <1219106888.17033.64.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/m68knommu/include/asm/byteorder.h |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/m68knommu/include/asm/byteorder.h b/arch/m68knommu/include/asm/byteorder.h
index 20bb442..6d9d3b8 100644
--- a/arch/m68knommu/include/asm/byteorder.h
+++ b/arch/m68knommu/include/asm/byteorder.h
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
+#define __arch_swab32 __arch_swab32
 #endif
 
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _M68KNOMMU_BYTEORDER_H */
-- 
1.6.0.274.g8aacc


