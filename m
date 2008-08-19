Return-Path: <linux-kernel-owner+w=401wt.eu-S1758069AbYHSAwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbYHSAwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756302AbYHSAsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:48:24 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:55104 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710AbYHSAsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:48:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=n1YPBf5a3pNCgm1KU3ar2+m86YnNbMz+penJ6jQaJtkTR7aGJ/4HQQkkmQ8LZEnwyP
         Efu54eBwBOPdPwj8ARnD24jwLN/fWkFE8LKpEQ5SO+U9dfuzAhgQTNsl8wV+/Pzytcsu
         vNefz/WOvjHZYiTEoiUVeTZc4yTJFXIOIUYRs=
Subject: [PATCH 13/23] mn10300: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 17:48:11 -0700
Message-Id: <1219106891.17033.66.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also remove the byteorder subfolder from the boot image install script.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/mn10300/boot/install.sh    |    5 -----
 include/asm-mn10300/byteorder.h |   23 +++++++----------------
 2 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/arch/mn10300/boot/install.sh b/arch/mn10300/boot/install.sh
index abba309..9f8046c 100644
--- a/arch/mn10300/boot/install.sh
+++ b/arch/mn10300/boot/install.sh
@@ -30,11 +30,6 @@ cd ${srctree}/include/linux
 for i in `find . -maxdepth 1 -name '*.h' -print`; do
   install -c -m 0644 $i $4/../usr/include/linux
 done
-install -c -m 0755 -d $4/../usr/include/linux/byteorder
-cd ${srctree}/include/linux/byteorder
-for i in `find . -name '*.h' -print`; do
-  install -c -m 0644 $i $4/../usr/include/linux/byteorder
-done
 install -c -m 0755 -d $4/../usr/include/linux/lockd
 cd ${srctree}/include/linux/lockd
 for i in `find . -name '*.h' -print`; do
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
1.6.0.274.g8aacc


