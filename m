Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbYKESfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbYKESfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 13:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYKESfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 13:35:32 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:48774 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbYKESfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 13:35:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=hoyFV/AvKGsZRMYw5NvHJiqMm8HWLMbRGTT2IMOcN+pX44nuvfQuH+PkovXoFKK/9S
         c6zb5fB1toGkPK6liyqVeW0JMozXxGkLrNVwLsgiyHJVv9dgmBh2dJx7ZfyvBnBw6efb
         QvsYAWue0aRFNmxt+FDSQeuhUi1ihzNN9Hrkg=
Subject: [PATCH 01/10] alpha: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "rth@twiddle.net" <rth@twiddle.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 10:35:25 -0800
Message-Id: <1225910125.5991.221.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/alpha/include/asm/byteorder.h |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/alpha/include/asm/byteorder.h b/arch/alpha/include/asm/byteorder.h
index 58e958f..0e6996f 100644
--- a/arch/alpha/include/asm/byteorder.h
+++ b/arch/alpha/include/asm/byteorder.h
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
+#define __arch_swab32 __arch_swab32
 
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
1.6.0.3.756.gb776d


