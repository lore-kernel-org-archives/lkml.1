Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZAFVjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZAFVjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbZAFVci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:32:38 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:13123 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbZAFVch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:32:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=q43cJ2I4Ue3YtX7q4nJ53wg0zL/bfZk4a2pLgNwmtnCC9v4x0PPbGHpdmTSOihJpyc
         liT1Ht1a1xhPwC6X68lYjRCMdbTwYzvMKQsicqUs+K8Inu2GTFrq9mwRfdzUJKjuLWLZ
         rAJi0D28DoxNMoLrOPj4oHEgPLKhGBdHugo64=
Subject: [PATCH 21/23] mn10300: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 13:30:56 -0800
Message-Id: <1231277456.964.278.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-mn10300/Kbuild      |    1 +
 include/asm-mn10300/byteorder.h |   41 +-------------------------------------
 include/asm-mn10300/swab.h      |   42 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 40 deletions(-)

diff --git a/include/asm-mn10300/Kbuild b/include/asm-mn10300/Kbuild
index c68e168..27b108a 100644
--- a/include/asm-mn10300/Kbuild
+++ b/include/asm-mn10300/Kbuild
@@ -1 +1,2 @@
 include include/asm-generic/Kbuild.asm
+unifdef-y += swab.h
diff --git a/include/asm-mn10300/byteorder.h b/include/asm-mn10300/byteorder.h
index 3c993cc..45b18de 100644
--- a/include/asm-mn10300/byteorder.h
+++ b/include/asm-mn10300/byteorder.h
@@ -1,46 +1,7 @@
-/* MN10300 Byte-order primitive construction
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
 #ifndef _ASM_BYTEORDER_H
 #define _ASM_BYTEORDER_H
 
-#include <asm/types.h>
-
-#ifdef __GNUC__
-
-static inline __attribute__((const))
-__u32 ___arch__swab32(__u32 x)
-{
-	__u32 ret;
-	asm("swap %1,%0" : "=r" (ret) : "r" (x));
-	return ret;
-}
-
-static inline __attribute__((const))
-__u16 ___arch__swab16(__u16 x)
-{
-	__u16 ret;
-	asm("swaph %1,%0" : "=r" (ret) : "r" (x));
-	return ret;
-}
-
-#define __arch__swab32(x) ___arch__swab32(x)
-#define __arch__swab16(x) ___arch__swab16(x)
-
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#endif /* __GNUC__ */
-
+#include <asm/swab.h>
 #include <linux/byteorder/little_endian.h>
 
 #endif /* _ASM_BYTEORDER_H */
diff --git a/include/asm-mn10300/swab.h b/include/asm-mn10300/swab.h
new file mode 100644
index 0000000..4504d1b
--- /dev/null
+++ b/include/asm-mn10300/swab.h
@@ -0,0 +1,42 @@
+/* MN10300 Byte-order primitive construction
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef _ASM_SWAB_H
+#define _ASM_SWAB_H
+
+#include <asm/types.h>
+
+#ifdef __GNUC__
+
+static inline __attribute__((const))
+__u32 __arch_swab32(__u32 x)
+{
+	__u32 ret;
+	asm("swap %1,%0" : "=r" (ret) : "r" (x));
+	return ret;
+}
+#define __arch_swab32 __arch_swab32
+
+static inline __attribute__((const))
+__u16 __arch_swab16(__u16 x)
+{
+	__u16 ret;
+	asm("swaph %1,%0" : "=r" (ret) : "r" (x));
+	return ret;
+}
+#define __arch_swab32 __arch_swab32
+
+#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
+#  define __SWAB_64_THRU_32__
+#endif
+
+#endif /* __GNUC__ */
+
+#endif /* _ASM_SWAB_H */
-- 
1.6.1.94.g9388


