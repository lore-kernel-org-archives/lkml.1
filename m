Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbZANDbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbZANDbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 22:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbZANDbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 22:31:34 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:47348 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbZANDbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 22:31:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qGIuSMKCJCuKuk8NA48CVgPSGxwAswzY2tC55DHtFDGGqI/lv+Ce28GYabJKOZuwyg
         rKOH6N181Lerc6udbGWKBnRDnhKy4cC5apeABZ+w8fBs2fhSnUy6CEqLipToMJpY9ZRN
         UB18X9PzAyxf/UxSEiuisM8dYcdjKvbIkgFpc=
Subject: Re: [PATCH 1/2] cris: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1231903597.5756.4.camel@brick>
References: <1231903597.5756.4.camel@brick>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 19:31:29 -0800
Message-Id: <1231903889.5756.7.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjust the arch overrides to the new names as well.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Sorry, _this_ is the one that won't break anything.  Previous patch
was incorrect in the defines in arch-v32/swab.h

 arch/cris/include/arch-v10/arch/byteorder.h |   26 -----------------------
 arch/cris/include/arch-v10/arch/swab.h      |   30 +++++++++++++++++++++++++++
 arch/cris/include/arch-v32/arch/byteorder.h |   20 ------------------
 arch/cris/include/arch-v32/arch/swab.h      |   24 +++++++++++++++++++++
 arch/cris/include/asm/Kbuild                |    1 +
 arch/cris/include/asm/byteorder.h           |   20 +-----------------
 arch/cris/include/asm/swab.h                |    8 +++++++
 7 files changed, 64 insertions(+), 65 deletions(-)

diff --git a/arch/cris/include/arch-v10/arch/byteorder.h b/arch/cris/include/arch-v10/arch/byteorder.h
deleted file mode 100644
index 255b646..0000000
--- a/arch/cris/include/arch-v10/arch/byteorder.h
+++ /dev/null
@@ -1,26 +0,0 @@
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
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
-{
-	__asm__ ("swapwb %0" : "=r" (x) : "0" (x));
-  
-	return(x);
-}
-
-static inline __attribute_const__ __u16 ___arch__swab16(__u16 x)
-{
-	__asm__ ("swapb %0" : "=r" (x) : "0" (x));
-	
-	return(x);
-}
-
-#endif
diff --git a/arch/cris/include/arch-v10/arch/swab.h b/arch/cris/include/arch-v10/arch/swab.h
new file mode 100644
index 0000000..e4e847d
--- /dev/null
+++ b/arch/cris/include/arch-v10/arch/swab.h
@@ -0,0 +1,30 @@
+#ifndef _CRIS_ARCH_SWAB_H
+#define _CRIS_ARCH_SWAB_H
+
+#include <asm/types.h>
+#include <linux/compiler.h>
+
+#define __SWAB_64_THRU_32__
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
index 6ef8fb4..0000000
--- a/arch/cris/include/arch-v32/arch/byteorder.h
+++ /dev/null
@@ -1,20 +0,0 @@
-#ifndef _ASM_CRIS_ARCH_BYTEORDER_H
-#define _ASM_CRIS_ARCH_BYTEORDER_H
-
-#include <asm/types.h>
-
-static inline __const__ __u32
-___arch__swab32(__u32 x)
-{
-	__asm__ __volatile__ ("swapwb %0" : "=r" (x) : "0" (x));
-	return (x);
-}
-
-static inline __const__ __u16
-___arch__swab16(__u16 x)
-{
-	__asm__ __volatile__ ("swapb %0" : "=r" (x) : "0" (x));
-	return (x);
-}
-
-#endif /* _ASM_CRIS_ARCH_BYTEORDER_H */
diff --git a/arch/cris/include/arch-v32/arch/swab.h b/arch/cris/include/arch-v32/arch/swab.h
new file mode 100644
index 0000000..9a4ea5e
--- /dev/null
+++ b/arch/cris/include/arch-v32/arch/swab.h
@@ -0,0 +1,24 @@
+#ifndef _ASM_CRIS_ARCH_SWAB_H
+#define _ASM_CRIS_ARCH_SWAB_H
+
+#include <asm/types.h>
+
+#define __SWAB_64_THRU_32__
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
index cc8e418..7678d86 100644
--- a/arch/cris/include/asm/byteorder.h
+++ b/arch/cris/include/asm/byteorder.h
@@ -1,25 +1,7 @@
 #ifndef _CRIS_BYTEORDER_H
 #define _CRIS_BYTEORDER_H
 
-#ifdef __GNUC__
-
-#ifdef __KERNEL__
-#include <arch/byteorder.h>
-
-/* defines are necessary because the other files detect the presence
- * of a defined __arch_swab32, not an inline
- */
-#define __arch__swab32(x) ___arch__swab32(x)
-#define __arch__swab16(x) ___arch__swab16(x)
-#endif /* __KERNEL__ */
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
 
 #endif
diff --git a/arch/cris/include/asm/swab.h b/arch/cris/include/asm/swab.h
new file mode 100644
index 0000000..80668e8
--- /dev/null
+++ b/arch/cris/include/asm/swab.h
@@ -0,0 +1,8 @@
+#ifndef _CRIS_SWAB_H
+#define _CRIS_SWAB_H
+
+#ifdef __KERNEL__
+#include <arch/swab.h>
+#endif /* __KERNEL__ */
+
+#endif /* _CRIS_SWAB_H */
-- 
1.6.1.212.g4b3ec



