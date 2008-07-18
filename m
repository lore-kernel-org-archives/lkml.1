Return-Path: <linux-kernel-owner+w=401wt.eu-S933024AbYGRAJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbYGRAJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 20:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759064AbYGRAJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 20:09:36 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:11137 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758787AbYGRAJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 20:09:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=pCaqqn4H9duzR+vNCUPsNNIoCnJKOHyRJQ54XTHHnqIqVcPRVK6dTs8iEqM2fssyYZ
         lfLPNp36X/Ac5lXZNGjHXd/hVGYSHFdfzN8d0jX3+MhluDWDqsEsljYuRnn3/0/VxsdF
         WpU+2uS+0dgOWp/beEBvkqyaxyHeKwGtJVuoo=
Subject: [PATCH 01/20] alpha: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "rth@twiddle.net" <rth@twiddle.net>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 17:09:33 -0700
Message-Id: <1216339774.6029.112.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-alpha/byteorder.h |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/include/asm-alpha/byteorder.h b/include/asm-alpha/byteorder.h
index 58e958f..cc9d368 100644
--- a/include/asm-alpha/byteorder.h
+++ b/include/asm-alpha/byteorder.h
@@ -5,9 +5,9 @@
 #include <linux/compiler.h>
 #include <asm/compiler.h>
 
-#ifdef __GNUC__
+#define __LITTLE_ENDIAN
 
-static inline __attribute_const__ __u32 __arch__swab32(__u32 x)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
 	/*
 	 * Unfortunately, we can't use the 6 instruction sequence
@@ -35,13 +35,8 @@ static inline __attribute_const__ __u32 __arch__swab32(__u32 x)
 
 	return t1;
 }
+#define HAVE_ARCH_SWAB32
 
-#define __arch__swab32 __arch__swab32
-
-#endif /* __GNUC__ */
-
-#define __BYTEORDER_HAS_U64__
-
-#include <linux/byteorder/little_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _ALPHA_BYTEORDER_H */
-- 
1.5.6.3.569.ga9185


