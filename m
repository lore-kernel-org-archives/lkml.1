Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbYHMA07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbYHMA07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYHMA0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:26:36 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:49095 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbYHMA0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:26:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=uNB4CBVwre8xg8kNyVdblIwbo/3sp2HxeJJ7xtNNmNHBjyfCuhlM6tl9lTQ/VWCaYf
         sHGPs6C7V/9N5YaKCr3tSjDxK5bkQcmpF71h2p4r8sI88McUXKHrNwaaOP6hnimD0ONJ
         /qZBKwCn+LUopG/6YtdY47suLFlEdjHQ0ICfM=
Subject: [PATCH 02/22] arm: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 17:26:34 -0700
Message-Id: <1218587194.30194.75.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
The prerequisite patches have landed in Linus' tree now.

 arch/arm/include/asm/byteorder.h |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/arch/arm/include/asm/byteorder.h b/arch/arm/include/asm/byteorder.h
index 4fbfb22..d04a7a2 100644
--- a/arch/arm/include/asm/byteorder.h
+++ b/arch/arm/include/asm/byteorder.h
@@ -18,7 +18,15 @@
 #include <linux/compiler.h>
 #include <asm/types.h>
 
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
+#ifdef __ARMEB__
+# define __BIG_ENDIAN
+#else
+# define __LITTLE_ENDIAN
+#endif
+
+#define __SWAB_64_THRU_32__
+
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
 	__u32 t;
 
@@ -40,19 +48,8 @@ static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
 
 	return x;
 }
+#define __arch_swab32 __arch_swab32
 
-#define __arch__swab32(x) ___arch__swab32(x)
-
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#ifdef __ARMEB__
-#include <linux/byteorder/big_endian.h>
-#else
-#include <linux/byteorder/little_endian.h>
-#endif
+#include <linux/byteorder.h>
 
 #endif
-
-- 
1.6.0.rc2.233.g3cb9d


