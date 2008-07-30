Return-Path: <linux-kernel-owner+w=401wt.eu-S1759457AbYG3A7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457AbYG3A7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757540AbYG3Azn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:55:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:51866 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486AbYG3Azm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:55:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=CLrYUWlWa8sZ0FKsi+Y8A6o1qs2u5I3FJUHLtQEvEjerlHOPqD5I0I8/ivGD4n6t7b
         IoX/SGX11zyt7YKK6+SZ0GvRWHuv43YdNZkHRV70uZwBMJB1X7AjzneMUoIBJ24mDDHH
         URZVlsJ/99K4JAKsJ/PyTBLQkxFwIQqVFVRBc=
Subject: [PATCH 12/24] m68knommu: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 17:55:23 -0700
Message-Id: <1217379323.23389.123.camel@brick>
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
index 20bb442..6d9d3b8 100644
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
+#define __arch_swab32 __arch_swab32
 #endif
 
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _M68KNOMMU_BYTEORDER_H */
-- 
1.6.0.rc1.154.ge3fc


