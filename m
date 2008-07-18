Return-Path: <linux-kernel-owner+w=401wt.eu-S933917AbYGRAOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933917AbYGRAOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 20:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933548AbYGRAKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 20:10:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:57293 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933523AbYGRAKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 20:10:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=TXQ5zN8lxTBuzzUlOFYIAQ8D6P/e6EjgyLvLEnbck/TUVKsSvREUrHHjFsB9319vXC
         ecM4i6W5WUJhNgBVNTETGW4UcQZ11gGb5yUMQHSHdCpvqIYw0flW4jdkFSw9Dc3cvWrF
         50sWYNV2qq8K4WmxyHLbl7/tMxLAPPyQ0Hho4=
Subject: [PATCH 13/20] mn10300: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 17:09:42 -0700
Message-Id: <1216339782.6029.124.camel@brick>
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
index 3c993cc..3dd3e2a 100644
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
+#define HAVE_ARCH_SWAB32
 
-static inline __attribute__((const))
-__u16 ___arch__swab16(__u16 x)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 {
 	__u16 ret;
 	asm("swaph %1,%0" : "=r" (ret) : "r" (x));
 	return ret;
 }
+#define HAVE_ARCH_SWAB16
 
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
1.5.6.3.569.ga9185


