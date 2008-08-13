Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbYHMAcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbYHMAcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbYHMA1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:27:20 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:33264 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024AbYHMA1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:27:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=SK8n2eEuP9xyjotSws+S1GkJfAKirp+62rGu7QF0i7uZqfXjfaXFuyX1NHhIeG5X1t
         pmyBFxilREa21abeBqIpDvNXrCqM1AHxo8Gk1gdGdlB6ZOpfvoq7WGcVt6s0papgzZwW
         sQVZ+jpJ+UTsoiJ7JxgdkUj+GUSVsra9V9Dsw=
Subject: [PATCH 18/22] sparc: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 17:27:14 -0700
Message-Id: <1218587234.30194.92.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
The prerequisite patches have landed in Linus' tree now.

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
1.6.0.rc2.233.g3cb9d


