Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbYHMA0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbYHMA0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYHMA0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:26:34 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:49095 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbYHMA0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:26:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=p+BmmaSJgh+0LJVPWyAgG/N/BkfCMBiw1xEsYfP3S9mpOhU6J5s10qqLd0FCAYpj7V
         r3uVeyk+9dp6ADeJYAE05At3lYATIMaywxFFVstNLdwhY+c1qK+Js6HvgzKiVREGe6S0
         Fgc8yLDDB+nXAusKF1Pzr4/MFtGPZ/ZdIWuiY=
Subject: [PATCH 01/22] alpha: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "rth@twiddle.net" <rth@twiddle.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 17:26:34 -0700
Message-Id: <1218587194.30194.74.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
The prerequisite patches have landed in Linus' tree now.

 include/asm-alpha/byteorder.h |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/include/asm-alpha/byteorder.h b/include/asm-alpha/byteorder.h
index 58e958f..0e6996f 100644
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
1.6.0.rc2.233.g3cb9d


