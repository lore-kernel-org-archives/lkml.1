Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbZAFVho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbZAFVho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZAFVca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:32:30 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:9512 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbZAFVc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:32:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=xgLz4+Q98TaE3eR8wA+OTpO2nasHWPVTkBIfY4Fpr4U64V8ygttxUX3vIR43ErGlym
         AEwKITJ96/tAr4o9+vcW873SxvxD4QT3mI9yPAsC0Jx3W3JXx+v9yM5yx8kV2BB1s+wn
         ppzZPiDbp5He2tISKKv1NiRgQn/5bO1Tk8lJo=
Subject: [PATCH 17/23] ia64: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "tony.luck" <tony.luck@intel.com>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 13:30:54 -0800
Message-Id: <1231277454.964.274.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/ia64/include/asm/Kbuild      |    1 +
 arch/ia64/include/asm/byteorder.h |   37 +------------------------------------
 arch/ia64/include/asm/swab.h      |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/arch/ia64/include/asm/Kbuild b/arch/ia64/include/asm/Kbuild
index ccbe8ae..3b25bd9 100644
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@ -14,3 +14,4 @@ unifdef-y += gcc_intrin.h
 unifdef-y += intrinsics.h
 unifdef-y += perfmon.h
 unifdef-y += ustack.h
+unifdef-y += swab.h
diff --git a/arch/ia64/include/asm/byteorder.h b/arch/ia64/include/asm/byteorder.h
index 69bd41d..0f84c5c 100644
--- a/arch/ia64/include/asm/byteorder.h
+++ b/arch/ia64/include/asm/byteorder.h
@@ -1,42 +1,7 @@
 #ifndef _ASM_IA64_BYTEORDER_H
 #define _ASM_IA64_BYTEORDER_H
 
-/*
- * Modified 1998, 1999
- *	David Mosberger-Tang <davidm@hpl.hp.com>, Hewlett-Packard Co.
- */
-
-#include <asm/types.h>
-#include <asm/intrinsics.h>
-#include <linux/compiler.h>
-
-static __inline__ __attribute_const__ __u64
-__ia64_swab64 (__u64 x)
-{
-	__u64 result;
-
-	result = ia64_mux1(x, ia64_mux1_rev);
-	return result;
-}
-
-static __inline__ __attribute_const__ __u32
-__ia64_swab32 (__u32 x)
-{
-	return __ia64_swab64(x) >> 32;
-}
-
-static __inline__ __attribute_const__ __u16
-__ia64_swab16(__u16 x)
-{
-	return __ia64_swab64(x) >> 48;
-}
-
-#define __arch__swab64(x) __ia64_swab64(x)
-#define __arch__swab32(x) __ia64_swab32(x)
-#define __arch__swab16(x) __ia64_swab16(x)
-
-#define __BYTEORDER_HAS_U64__
-
+#include <asm/swab.h>
 #include <linux/byteorder/little_endian.h>
 
 #endif /* _ASM_IA64_BYTEORDER_H */
diff --git a/arch/ia64/include/asm/swab.h b/arch/ia64/include/asm/swab.h
new file mode 100644
index 0000000..6aa58b6
--- /dev/null
+++ b/arch/ia64/include/asm/swab.h
@@ -0,0 +1,34 @@
+#ifndef _ASM_IA64_SWAB_H
+#define _ASM_IA64_SWAB_H
+
+/*
+ * Modified 1998, 1999
+ *	David Mosberger-Tang <davidm@hpl.hp.com>, Hewlett-Packard Co.
+ */
+
+#include <asm/types.h>
+#include <asm/intrinsics.h>
+#include <linux/compiler.h>
+
+static __inline__ __attribute_const__ __u64 __arch_swab64(__u64 x)
+{
+	__u64 result;
+
+	result = ia64_mux1(x, ia64_mux1_rev);
+	return result;
+}
+#define __arch_swab64 __arch_swab64
+
+static __inline__ __attribute_const__ __u32 __arch_swab32(__u32 x)
+{
+	return __arch_swab64(x) >> 32;
+}
+#define __arch_swab32 __arch_swab32
+
+static __inline__ __attribute_const__ __u16 __arch_swab16(__u16 x)
+{
+	return __arch_swab64(x) >> 48;
+}
+#define __arch_swab16 __arch_swab16
+
+#endif /* _ASM_IA64_SWAB_H */
-- 
1.6.1.94.g9388


