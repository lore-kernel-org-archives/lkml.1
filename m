Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbYG3Azr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbYG3Azr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbYG3AzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:55:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:59233 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbYG3AzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:55:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=oXd7H9Io8n/wJsg7N3TiTTmoxjDnRUbZPbOBWpLS1MKXsxwea8thz15lCoORQpEuvd
         sotF7IlnLlMlGy/XltGrRpnTnYpS65G8TYkFBiSHjteVHuFROibA6eUKHlTJ2LPz9uzz
         3AcWw3g8pKm3pb55s+89Rsv/eKJgvHIfLq+54=
Subject: [PATCH 02/24] alpha: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "rth@twiddle.net" <rth@twiddle.net>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 17:55:17 -0700
Message-Id: <1217379317.23389.113.camel@brick>
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
1.6.0.rc1.154.ge3fc


