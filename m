Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbYHSAyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbYHSAyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756549AbYHSAsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:48:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:56504 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009AbYHSAsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:48:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=D4vlw/T1lZjUfSfZh0cjn1tNQrWno+GWYaEdcknW+SiFXM3k6irA+URVzzW7AHUnVZ
         cK711aqxhYXe57/F30xDlipgub/cJdeVpni+mZpa1ELzlL8oFAIHCUSpHeCSEe+4u0UG
         t2ruioCtlyCTYswi0EnZMvWZCQtqG04hAuwnU=
Subject: [PATCH 18/23] sparc: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 17:48:17 -0700
Message-Id: <1219106897.17033.71.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/sparc/include/asm/byteorder.h |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/arch/sparc/include/asm/byteorder.h b/arch/sparc/include/asm/byteorder.h
index bcd83aa..5a70f13 100644
--- a/arch/sparc/include/asm/byteorder.h
+++ b/arch/sparc/include/asm/byteorder.h
@@ -4,15 +4,14 @@
 #include <asm/types.h>
 #include <asm/asi.h>
 
-#ifdef __GNUC__
+#define __BIG_ENDIAN
 
 #ifdef CONFIG_SPARC32
 #define __SWAB_64_THRU_32__
 #endif
 
 #ifdef CONFIG_SPARC64
-
-static inline __u16 ___arch__swab16p(const __u16 *addr)
+static inline __u16 __arch_swab16p(const __u16 *addr)
 {
 	__u16 ret;
 
@@ -21,8 +20,9 @@ static inline __u16 ___arch__swab16p(const __u16 *addr)
 			      : "r" (addr), "i" (ASI_PL));
 	return ret;
 }
+#define __arch_swab16p __arch_swab16p
 
-static inline __u32 ___arch__swab32p(const __u32 *addr)
+static inline __u32 __arch_swab32p(const __u32 *addr)
 {
 	__u32 ret;
 
@@ -31,8 +31,9 @@ static inline __u32 ___arch__swab32p(const __u32 *addr)
 			      : "r" (addr), "i" (ASI_PL));
 	return ret;
 }
+#define __arch_swab32p __arch_swab32p
 
-static inline __u64 ___arch__swab64p(const __u64 *addr)
+static inline __u64 __arch_swab64p(const __u64 *addr)
 {
 	__u64 ret;
 
@@ -41,17 +42,10 @@ static inline __u64 ___arch__swab64p(const __u64 *addr)
 			      : "r" (addr), "i" (ASI_PL));
 	return ret;
 }
-
-#define __arch__swab16p(x) ___arch__swab16p(x)
-#define __arch__swab32p(x) ___arch__swab32p(x)
-#define __arch__swab64p(x) ___arch__swab64p(x)
+#define __arch_swab64p __arch_swab64p
 
 #endif /* CONFIG_SPARC64 */
 
-#define __BYTEORDER_HAS_U64__
-
-#endif
-
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _SPARC_BYTEORDER_H */
-- 
1.6.0.274.g8aacc


