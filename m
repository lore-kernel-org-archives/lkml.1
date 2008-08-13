Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbYHMAaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbYHMAaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbYHMA0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:26:52 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:49095 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773AbYHMA0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:26:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=mvTfvHabAnwXTDtakLiY8U8cHgTjTjiV4FkTh5IJqbCgCz895y+A5E798EAOhBaAH1
         JDPIRkWNQzQLgQfUxcl0/UQa8a4PB2hyYdSqv9rqQO07w0Pq4TUcuXbZXmleELKSCU5P
         YEDuu/Z5pvfuNZ5skRTFBS1Bp8n81zSilT474=
Subject: [PATCH 11/22] m68knommu: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Greg Ungerer <gerg@uclinux.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 17:26:40 -0700
Message-Id: <1218587200.30194.84.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
The prerequisite patches have landed in Linus' tree now.

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
1.6.0.rc2.233.g3cb9d


