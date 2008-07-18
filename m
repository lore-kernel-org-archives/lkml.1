Return-Path: <linux-kernel-owner+w=401wt.eu-S934046AbYGRAQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934046AbYGRAQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 20:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761178AbYGRAKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 20:10:20 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:12092 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243AbYGRAKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 20:10:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=jSsay8FhiKoq9L8noi6e+q0wt2WMWF1/bpUXmVxAgIIh0AARhUA8ZUTgYrUZuPEgJe
         Zh07dbH5a5Ly7gNoLg+ToEtcZuctojPxoEpzYnvgQB+9oFm8pPWmDqpewUatXCqeDX85
         RcOAVNXH4hkJkmSCSfpTUzZZFvH/TyoHG6vNw=
Subject: [PATCH 18/20] sparc: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 17:09:45 -0700
Message-Id: <1216339785.6029.129.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-sparc/byteorder.h |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/include/asm-sparc/byteorder.h b/include/asm-sparc/byteorder.h
index bcd83aa..9195613 100644
--- a/include/asm-sparc/byteorder.h
+++ b/include/asm-sparc/byteorder.h
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
+#define HAVE_ARCH_SWAB16P
 
-static inline __u32 ___arch__swab32p(const __u32 *addr)
+static inline __u32 __arch_swab32p(const __u32 *addr)
 {
 	__u32 ret;
 
@@ -31,8 +31,9 @@ static inline __u32 ___arch__swab32p(const __u32 *addr)
 			      : "r" (addr), "i" (ASI_PL));
 	return ret;
 }
+#define HAVE_ARCH_SWAB32P
 
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
+#define HAVE_ARCH_SWAB64P
 
 #endif /* CONFIG_SPARC64 */
 
-#define __BYTEORDER_HAS_U64__
-
-#endif
-
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _SPARC_BYTEORDER_H */
-- 
1.5.6.3.569.ga9185


