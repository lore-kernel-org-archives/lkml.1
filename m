Return-Path: <linux-kernel-owner+w=401wt.eu-S932839AbXH0VaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839AbXH0VaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765178AbXH0V1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:27:46 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58799 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764481AbXH0V1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:27:44 -0400
Date: Mon, 27 Aug 2007 23:27:43 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Olaf Hering <olh@suse.de>
Subject: [-mm patch] make types.h usable for non-gcc C parsers
Message-ID: <20070827212743.GN4121@stusta.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46CC3B27.10604@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46CC3B27.10604@googlemail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 03:33:27PM +0200, Gabriel C wrote:
>...
> WARNING: "div64_64" [net/netfilter/xt_connbytes.ko] has no CRC!
>...

Patch below.

> Regards,
> 
> Gabriel

cu
Adrian


<--  snip  -->


This patch makes the 64bit integers on 32bit architectures usable for
all C parsers that know about "long long".

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/asm-arm/types.h      |   10 +++++++---
 include/asm-avr32/types.h    |   10 +++++++---
 include/asm-blackfin/types.h |   11 +++++++----
 include/asm-cris/types.h     |   10 +++++++---
 include/asm-frv/types.h      |   10 +++++++---
 include/asm-h8300/types.h    |   10 +++++++---
 include/asm-i386/types.h     |   10 +++++++---
 include/asm-m32r/types.h     |   11 ++++++++---
 include/asm-m68k/types.h     |   10 +++++++---
 include/asm-mips/types.h     |   10 +++++++---
 include/asm-parisc/types.h   |   10 +++++++---
 include/asm-powerpc/types.h  |    9 ++++++---
 include/asm-s390/types.h     |    9 ++++++---
 include/asm-sh/types.h       |   10 +++++++---
 include/asm-sh64/types.h     |   10 +++++++---
 include/asm-v850/types.h     |   10 +++++++---
 include/asm-xtensa/types.h   |   10 +++++++---
 17 files changed, 118 insertions(+), 52 deletions(-)

4b6826d7a2f5b54a6a3b1cfa8cd40b1b27621be0 
diff --git a/include/asm-arm/types.h b/include/asm-arm/types.h
index 3141451..1dae25b 100644
--- a/include/asm-arm/types.h
+++ b/include/asm-arm/types.h
@@ -19,11 +19,15 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__)
-__extension__ typedef __signed__ long long __s64;
-__extension__ typedef unsigned long long __u64;
+#if defined(__GNUC__) && defined(__STRICT_ANSI__)
+#define __extension_long_long __extension__
+#else
+#define __extension_long_long
 #endif
 
+__extension_long_long typedef __signed__ long long __s64;
+__extension_long_long typedef unsigned long long __u64;
+
 #endif /* __ASSEMBLY__ */
 
 /*
diff --git a/include/asm-avr32/types.h b/include/asm-avr32/types.h
index 8999a38..2c14f49 100644
--- a/include/asm-avr32/types.h
+++ b/include/asm-avr32/types.h
@@ -25,11 +25,15 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__)
-__extension__ typedef __signed__ long long __s64;
-__extension__ typedef unsigned long long __u64;
+#if defined(__GNUC__) && defined(__STRICT_ANSI__)
+#define __extension_long_long __extension__
+#else
+#define __extension_long_long
 #endif
 
+__extension_long_long typedef __signed__ long long __s64;
+__extension_long_long typedef unsigned long long __u64;
+
 #endif /* __ASSEMBLY__ */
 
 /*
diff --git a/include/asm-blackfin/types.h b/include/asm-blackfin/types.h
index 9785a6d..d0666b9 100644
--- a/include/asm-blackfin/types.h
+++ b/include/asm-blackfin/types.h
@@ -26,12 +26,15 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-/* HK0617   -- Changes to unsigned long temporarily */
-#if defined(__GNUC__)
-__extension__ typedef __signed__ long long __s64;
-__extension__ typedef unsigned long long __u64;
+#if defined(__GNUC__) && defined(__STRICT_ANSI__)
+#define __extension_long_long __extension__
+#else
+#define __extension_long_long
 #endif
 
+__extension_long_long typedef __signed__ long long __s64;
+__extension_long_long typedef unsigned long long __u64;
+
 #endif				/* __ASSEMBLY__ */
 /*
  * These aren't exported outside the kernel to avoid name space clashes
diff --git a/include/asm-cris/types.h b/include/asm-cris/types.h
index 5a21c42..6c46a90 100644
--- a/include/asm-cris/types.h
+++ b/include/asm-cris/types.h
@@ -19,11 +19,15 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__)
-__extension__ typedef __signed__ long long __s64;
-__extension__ typedef unsigned long long __u64;
+#if defined(__GNUC__) && defined(__STRICT_ANSI__)
+#define __extension_long_long __extension__
+#else
+#define __extension_long_long
 #endif
 
+__extension_long_long typedef __signed__ long long __s64;
+__extension_long_long typedef unsigned long long __u64;
+
 #endif /* __ASSEMBLY__ */
 
 /*
diff --git a/include/asm-frv/types.h b/include/asm-frv/types.h
index 767e5ed..728c234 100644
--- a/include/asm-frv/types.h
+++ b/include/asm-frv/types.h
@@ -30,11 +30,15 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__)
-__extension__ typedef __signed__ long long __s64;
-__extension__ typedef unsigned long long __u64;
+#if defined(__GNUC__) && defined(__STRICT_ANSI__)
+#define __extension_long_long __extension__
+#else
+#define __extension_long_long
 #endif
 
+__extension_long_long typedef __signed__ long long __s64;
+__extension_long_long typedef unsigned long long __u64;
+
 #endif /* __ASSEMBLY__ */
 
 /*
diff --git a/include/asm-h8300/types.h b/include/asm-h8300/types.h
index 56566e2..1fc2dd9 100644
--- a/include/asm-h8300/types.h
+++ b/include/asm-h8300/types.h
@@ -27,11 +27,15 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__)
-__extension__ typedef __signed__ long long __s64;
-__extension__ typedef unsigned long long __u64;
+#if defined(__GNUC__) && defined(__STRICT_ANSI__)
+#define __extension_long_long __extension__
+#else
+#define __extension_long_long
 #endif
 
+__extension_long_long typedef __signed__ long long __s64;
+__extension_long_long typedef unsigned long long __u64;
+
 /*
  * These aren't exported outside the kernel to avoid name space clashes
  */
diff --git a/include/asm-i386/types.h b/include/asm-i386/types.h
index faca192..a2c3b35 100644
--- a/include/asm-i386/types.h
+++ b/include/asm-i386/types.h
@@ -19,11 +19,15 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__)
-__extension__ typedef __signed__ long long __s64;
-__extension__ typedef unsigned long long __u64;
+#if defined(__GNUC__) && defined(__STRICT_ANSI__)
+#define __extension_long_long __extension__
+#else
+#define __extension_long_long
 #endif
 
+__extension_long_long typedef __signed__ long long __s64;
+__extension_long_long typedef unsigned long long __u64;
+
 #endif /* __ASSEMBLY__ */
 
 /*
diff --git a/include/asm-m32r/types.h b/include/asm-m32r/types.h
index b64c166..8071e22 100644
--- a/include/asm-m32r/types.h
+++ b/include/asm-m32r/types.h
@@ -19,10 +19,15 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__)
-__extension__ typedef __signed__ long long __s64;
-__extension__ typedef unsigned long long __u64;
+#if defined(__GNUC__) && defined(__STRICT_ANSI__)
+#define __extension_long_long __extension__
+#else
+#define __extension_long_long
 #endif
+
+__extension_long_long typedef __signed__ long long __s64;
+__extension_long_long typedef unsigned long long __u64;
+
 #endif /* __ASSEMBLY__ */
 
 /*
diff --git a/include/asm-m68k/types.h b/include/asm-m68k/types.h
index c35c09d..43e0186 100644
--- a/include/asm-m68k/types.h
+++ b/include/asm-m68k/types.h
@@ -27,11 +27,15 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__)
-__extension__ typedef __signed__ long long __s64;
-__extension__ typedef unsigned long long __u64;
+#if defined(__GNUC__) && defined(__STRICT_ANSI__)
+#define __extension_long_long __extension__
+#else
+#define __extension_long_long
 #endif
 
+__extension_long_long typedef __signed__ long long __s64;
+__extension_long_long typedef unsigned long long __u64;
+
 #endif /* __ASSEMBLY__ */
 
 /*
diff --git a/include/asm-mips/types.h b/include/asm-mips/types.h
index 2dd147f..fe1eb32 100644
--- a/include/asm-mips/types.h
+++ b/include/asm-mips/types.h
@@ -34,11 +34,15 @@ typedef unsigned long __u64;
 
 #else
 
-#if defined(__GNUC__)
-__extension__ typedef __signed__ long long __s64;
-__extension__ typedef unsigned long long __u64;
+#if defined(__GNUC__) && defined(__STRICT_ANSI__)
+#define __extension_long_long __extension__
+#else
+#define __extension_long_long
 #endif
 
+__extension_long_long typedef __signed__ long long __s64;
+__extension_long_long typedef unsigned long long __u64;
+
 #endif
 
 #endif /* __ASSEMBLY__ */
diff --git a/include/asm-parisc/types.h b/include/asm-parisc/types.h
index 56c8480..5df2b11 100644
--- a/include/asm-parisc/types.h
+++ b/include/asm-parisc/types.h
@@ -19,11 +19,15 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__)
-__extension__ typedef __signed__ long long __s64;
-__extension__ typedef unsigned long long __u64;
+#if defined(__GNUC__) && defined(__STRICT_ANSI__)
+#define __extension_long_long __extension__
+#else
+#define __extension_long_long
 #endif
 
+__extension_long_long typedef __signed__ long long __s64;
+__extension_long_long typedef unsigned long long __u64;
+
 #endif /* __ASSEMBLY__ */
 
 /*
diff --git a/include/asm-powerpc/types.h b/include/asm-powerpc/types.h
index 695e2ce..2ce1998 100644
--- a/include/asm-powerpc/types.h
+++ b/include/asm-powerpc/types.h
@@ -40,10 +40,13 @@ typedef unsigned int __u32;
 typedef __signed__ long __s64;
 typedef unsigned long __u64;
 #else
-#if defined(__GNUC__)
-__extension__ typedef __signed__ long long __s64;
-__extension__ typedef unsigned long long __u64;
+#if defined(__GNUC__) && defined(__STRICT_ANSI__)
+#define __extension_long_long __extension__
+#else
+#define __extension_long_long
 #endif
+__extension_long_long typedef __signed__ long long __s64;
+__extension_long_long typedef unsigned long long __u64;
 #endif /* __powerpc64__ */
 
 typedef struct {
diff --git a/include/asm-s390/types.h b/include/asm-s390/types.h
index 2c5879a..9590d00 100644
--- a/include/asm-s390/types.h
+++ b/include/asm-s390/types.h
@@ -28,10 +28,13 @@ typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
 #ifndef __s390x__
-#if defined(__GNUC__)
-__extension__ typedef __signed__ long long __s64;
-__extension__ typedef unsigned long long __u64;
+#if defined(__GNUC__) && defined(__STRICT_ANSI__)
+#define __extension_long_long __extension__
+#else
+#define __extension_long_long
 #endif
+__extension_long_long typedef __signed__ long long __s64;
+__extension_long_long typedef unsigned long long __u64;
 #else /* __s390x__ */
 typedef __signed__ long __s64;
 typedef unsigned long __u64;
diff --git a/include/asm-sh/types.h b/include/asm-sh/types.h
index 7ba69d9..d747b87 100644
--- a/include/asm-sh/types.h
+++ b/include/asm-sh/types.h
@@ -19,11 +19,15 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__)
-__extension__ typedef __signed__ long long __s64;
-__extension__ typedef unsigned long long __u64;
+#if defined(__GNUC__) && defined(__STRICT_ANSI__)
+#define __extension_long_long __extension__
+#else
+#define __extension_long_long
 #endif
 
+__extension_long_long__ typedef __signed__ long long __s64;
+__extension_long_long__ typedef unsigned long long __u64;
+
 #endif /* __ASSEMBLY__ */
 
 /*
diff --git a/include/asm-sh64/types.h b/include/asm-sh64/types.h
index 2c7ad73..e5e90ff 100644
--- a/include/asm-sh64/types.h
+++ b/include/asm-sh64/types.h
@@ -30,11 +30,15 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__)
-__extension__ typedef __signed__ long long __s64;
-__extension__ typedef unsigned long long __u64;
+#if defined(__GNUC__) && defined(__STRICT_ANSI__)
+#define __extension_long_long __extension__
+#else
+#define __extension_long_long
 #endif
 
+__extension_long_long typedef __signed__ long long __s64;
+__extension_long_long typedef unsigned long long __u64;
+
 #endif /* __ASSEMBLY__ */
 
 /*
diff --git a/include/asm-v850/types.h b/include/asm-v850/types.h
index 284bda8..6fac765 100644
--- a/include/asm-v850/types.h
+++ b/include/asm-v850/types.h
@@ -27,11 +27,15 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__)
-__extension__ typedef __signed__ long long __s64;
-__extension__ typedef unsigned long long __u64;
+#if defined(__GNUC__) && defined(__STRICT_ANSI__)
+#define __extension_long_long __extension__
+#else
+#define __extension_long_long
 #endif
 
+__extension_long_long typedef __signed__ long long __s64;
+__extension_long_long typedef unsigned long long __u64;
+
 #endif /* !__ASSEMBLY__ */
 
 /*
diff --git a/include/asm-xtensa/types.h b/include/asm-xtensa/types.h
index 958f362..184c058 100644
--- a/include/asm-xtensa/types.h
+++ b/include/asm-xtensa/types.h
@@ -29,11 +29,15 @@ typedef unsigned short __u16;
 typedef __signed__ int __s32;
 typedef unsigned int __u32;
 
-#if defined(__GNUC__)
-__extension__ typedef __signed__ long long __s64;
-__extension__ typedef unsigned long long __u64;
+#if defined(__GNUC__) && defined(__STRICT_ANSI__)
+#define __extension_long_long __extension__
+#else
+#define __extension_long_long
 #endif
 
+__extension_long_long typedef __signed__ long long __s64;
+__extension_long_long typedef unsigned long long __u64;
+
 /*
  * These aren't exported outside the kernel to avoid name space clashes
  */

