Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbYHSAsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbYHSAsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbYHSArv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:47:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:56504 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbYHSAru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:47:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=MPKkH1HABrtiRxnRR8WfPolSv80ZtEGqTBOVQRWVy9eq/U+hYIxDe66bwl9WjZ8QIg
         MHySq219LQc8obJcIvaRCVe/UqRBH6wxm+p6az8qKgkMlBZ+fsPgRELsi64pMHK6MiE9
         MTql8BEuScouKXNyHycFnQhk46FSOxrFvCRck=
Subject: [PATCH 01/23] alpha: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "rth@twiddle.net" <rth@twiddle.net>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 17:47:48 -0700
Message-Id: <1219106868.17033.54.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
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
1.6.0.274.g8aacc


