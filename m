Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbZAFVcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbZAFVcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbZAFVcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:32:05 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:9512 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbZAFVcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:32:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=x6K59FKboCjCQp37Bzyt5kIqRbl9rlAWuGDjXMEw6wG6S+P6/1KLLpQq3D2hSUwuIB
         8xIeNw0Fo45VPCG5Tgo/B2jqkSIAxSaXHXwQL+zUR3WN0OE7hMYLAKZ5MkW5U0uspePU
         6DR9p/wfEuD+rmM8tDB7JaIhXEOIc4tFQ5YvM=
Subject: [PATCH 03/23] cris: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesper Nilsson <jesper.nilsson@axis.com>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 13:30:46 -0800
Message-Id: <1231277446.964.260.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cris holds its arch overrides in an arch/ folder, rename these
byteorder.h files to swab.h and include them from asm/swab.h

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/cris/include/arch-v10/arch/byteorder.h |   28 ---------------------------
 arch/cris/include/arch-v10/arch/swab.h      |   28 +++++++++++++++++++++++++++
 arch/cris/include/arch-v32/arch/byteorder.h |   22 ---------------------
 arch/cris/include/arch-v32/arch/swab.h      |   22 +++++++++++++++++++++
 arch/cris/include/asm/Kbuild                |    1 +
 arch/cris/include/asm/byteorder.h           |   10 +-------
 arch/cris/include/asm/swab.h                |   12 +++++++++++
 7 files changed, 65 insertions(+), 58 deletions(-)

diff --git a/arch/cris/include/arch-v10/arch/byteorder.h b/arch/cris/include/arch-v10/arch/byteorder.h
deleted file mode 100644
index ffbd667..0000000
--- a/arch/cris/include/arch-v10/arch/byteorder.h
+++ /dev/null
@@ -1,28 +0,0 @@
-#ifndef _CRIS_ARCH_BYTEORDER_H
-#define _CRIS_ARCH_BYTEORDER_H
-
-#include <asm/types.h>
-#include <linux/compiler.h>
-
-/* we just define these two (as we can do the swap in a single
- * asm instruction in CRIS) and the arch-independent files will put
- * them together into ntohl etc.
- */
-
-static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
-{
-	__asm__ ("swapwb %0" : "=r" (x) : "0" (x));
-
-	return(x);
-}
-#define __arch_swab32 __arch_swab32
-
-static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
-{
-	__asm__ ("swapb %0" : "=r" (x) : "0" (x));
-
-	return(x);
-}
-#define __arch_swab16 __arch_swab16
-
-#endif
diff --git a/arch/cris/include/arch-v10/arch/swab.h b/arch/cris/include/arch-v10/arch/swab.h
new file mode 100644
index 0000000..3eb0993
--- /dev/null
+++ b/arch/cris/include/arch-v10/arch/swab.h
@@ -0,0 +1,28 @@
+#ifndef _CRIS_ARCH_SWAB_H
+#define _CRIS_ARCH_SWAB_H
+
+#include <asm/types.h>
+#include <linux/compiler.h>
+
+/* we just define these two (as we can do the swap in a single
+ * asm instruction in CRIS) and the arch-independent files will put
+ * them together into ntohl etc.
+ */
+
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
+{
+	__asm__ ("swapwb %0" : "=r" (x) : "0" (x));
+
+	return(x);
+}
+#define __arch_swab32 __arch_swab32
+
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
+{
+	__asm__ ("swapb %0" : "=r" (x) : "0" (x));
+
+	return(x);
+}
+#define __arch_swab16 __arch_swab16
+
+#endif
diff --git a/arch/cris/include/arch-v32/arch/byteorder.h b/arch/cris/include/arch-v32/arch/byteorder.h
deleted file mode 100644
index fb76087..0000000
--- a/arch/cris/include/arch-v32/arch/byteorder.h
+++ /dev/null
@@ -1,22 +0,0 @@
-#ifndef _ASM_CRIS_ARCH_BYTEORDER_H
-#define _ASM_CRIS_ARCH_BYTEORDER_H
-
-#include <asm/types.h>
-
-static inline __const__ __u32
-__arch_swab32(__u32 x)
-{
-	__asm__ __volatile__ ("swapwb %0" : "=r" (x) : "0" (x));
-	return (x);
-}
-#define __arch_swab32 __arch_swab32
-
-static inline __const__ __u16
-__arch_swab16(__u16 x)
-{
-	__asm__ __volatile__ ("swapb %0" : "=r" (x) : "0" (x));
-	return (x);
-}
-#define __arch_swab16 __arch_swab16
-
-#endif /* _ASM_CRIS_ARCH_BYTEORDER_H */
diff --git a/arch/cris/include/arch-v32/arch/swab.h b/arch/cris/include/arch-v32/arch/swab.h
new file mode 100644
index 0000000..ed1f280
--- /dev/null
+++ b/arch/cris/include/arch-v32/arch/swab.h
@@ -0,0 +1,22 @@
+#ifndef _ASM_CRIS_ARCH_SWAB_H
+#define _ASM_CRIS_ARCH_SWAB_H
+
+#include <asm/types.h>
+
+static inline __const__ __u32
+__arch_swab32(__u32 x)
+{
+	__asm__ __volatile__ ("swapwb %0" : "=r" (x) : "0" (x));
+	return (x);
+}
+#define __arch_swab32 __arch_swab32
+
+static inline __const__ __u16
+__arch_swab16(__u16 x)
+{
+	__asm__ __volatile__ ("swapb %0" : "=r" (x) : "0" (x));
+	return (x);
+}
+#define __arch_swab16 __arch_swab16
+
+#endif /* _ASM_CRIS_ARCH_SWAB_H */
diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index d5b6319..b79b7c6 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -9,3 +9,4 @@ header-y += sync_serial.h
 
 unifdef-y += etraxgpio.h
 unifdef-y += rs485.h
+unifdef-y += swab.h
diff --git a/arch/cris/include/asm/byteorder.h b/arch/cris/include/asm/byteorder.h
index 420c030..7678d86 100644
--- a/arch/cris/include/asm/byteorder.h
+++ b/arch/cris/include/asm/byteorder.h
@@ -1,14 +1,8 @@
 #ifndef _CRIS_BYTEORDER_H
 #define _CRIS_BYTEORDER_H
 
-#define __LITTLE_ENDIAN
-#define __SWAB_64_THRU_32__
-
-#ifdef __KERNEL__
-# include <arch/byteorder.h>
-#endif
-
-#include <linux/byteorder.h>
+#include <asm/swab.h>
+#include <linux/byteorder/little_endian.h>
 
 #endif
 
diff --git a/arch/cris/include/asm/swab.h b/arch/cris/include/asm/swab.h
new file mode 100644
index 0000000..9a0ad25
--- /dev/null
+++ b/arch/cris/include/asm/swab.h
@@ -0,0 +1,12 @@
+#ifndef _CRIS_SWAB_H
+#define _CRIS_SWAB_H
+
+#define __SWAB_64_THRU_32__
+
+#ifdef __KERNEL__
+# include <arch/swab.h>
+#endif
+
+#endif
+
+
-- 
1.6.1.94.g9388


