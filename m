Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbZAFViZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbZAFViZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750709AbZAFVcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:32:33 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:9249 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbZAFVcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:32:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=C9lnM2VxalceCtI2YQRba1uvl3huNf7WOblHKCoGXbMhMxPX0qIkITLovGkusFNYhc
         EEosduvSD+JaD1YXAhOPoQjqk7Nh1jGqSt9/4VdJ/W/3wkqpMAayP9aKIZ6Jj4iqVQsB
         qMeov0ZwYgzcAxKNI4NGgoDivAmzNSA6HvgL4=
Subject: [PATCH 18/23] m68knommu: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 13:30:55 -0800
Message-Id: <1231277455.964.275.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the new-style arch overrides as well.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/m68knommu/include/asm/Kbuild      |    2 ++
 arch/m68knommu/include/asm/byteorder.h |   22 +---------------------
 arch/m68knommu/include/asm/swab.h      |   24 ++++++++++++++++++++++++
 3 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/arch/m68knommu/include/asm/Kbuild b/arch/m68knommu/include/asm/Kbuild
index c68e168..58c02a4 100644
--- a/arch/m68knommu/include/asm/Kbuild
+++ b/arch/m68knommu/include/asm/Kbuild
@@ -1 +1,3 @@
 include include/asm-generic/Kbuild.asm
+
+unifdef-y += swab.h
diff --git a/arch/m68knommu/include/asm/byteorder.h b/arch/m68knommu/include/asm/byteorder.h
index 20bb442..a6f0b8f 100644
--- a/arch/m68knommu/include/asm/byteorder.h
+++ b/arch/m68knommu/include/asm/byteorder.h
@@ -1,27 +1,7 @@
 #ifndef _M68KNOMMU_BYTEORDER_H
 #define _M68KNOMMU_BYTEORDER_H
 
-#include <linux/types.h>
-
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#if defined (__mcfisaaplus__) || defined (__mcfisac__)
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 val)
-{
-	asm(
-			"byterev %0"
-			: "=d" (val)
-			: "0" (val)
-	   );
-	return val;
-}
-
-#define __arch__swab32(x) ___arch__swab32(x)
-#endif
-
+#include <asm/swab.h>
 #include <linux/byteorder/big_endian.h>
 
 #endif /* _M68KNOMMU_BYTEORDER_H */
diff --git a/arch/m68knommu/include/asm/swab.h b/arch/m68knommu/include/asm/swab.h
new file mode 100644
index 0000000..e582257
--- /dev/null
+++ b/arch/m68knommu/include/asm/swab.h
@@ -0,0 +1,24 @@
+#ifndef _M68KNOMMU_SWAB_H
+#define _M68KNOMMU_SWAB_H
+
+#include <linux/types.h>
+
+#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
+#  define __SWAB_64_THRU_32__
+#endif
+
+#if defined (__mcfisaaplus__) || defined (__mcfisac__)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
+{
+	asm(
+			"byterev %0"
+			: "=d" (val)
+			: "0" (val)
+	   );
+	return val;
+}
+
+#define __arch_swab32 __arch_swab32
+#endif
+
+#endif /* _M68KNOMMU_SWAB_H */
-- 
1.6.1.94.g9388


