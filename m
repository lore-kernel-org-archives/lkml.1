Return-Path: <linux-kernel-owner+w=401wt.eu-S1761683AbZEMW5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761683AbZEMW5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbZEMW4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:56:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51308 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZEMW4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:56:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: [PATCH 02/15] asm-generic: introduce asm/bitsperlong.h
Date: Wed, 13 May 2009 22:56:25 +0000
Message-Id: <1242255398-23779-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1242255398-23779-1-git-send-email-arnd@arndb.de>
References: <1242255398-23779-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+aeDpmLeVPcnKOY1+V1ZeOErT0BpDPabECcCh
 2ylVnAqxpuTwiiazjWHuWPrUygs5M9oJIMdTOZId8WQ4Lfy/um
 oZbybqxGQLoOnUUBCy3hQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides a reliable way for asm-generic/types.h and other
files to find out if it is running on a 32 or 64 bit platform.

We cannot use CONFIG_64BIT for this in headers that are included
from user space because CONFIG symbols are not available there.
We also cannot do it inside of asm/types.h because some headers
need the word size but cannot include types.h.

The solution is to introduce a new header <asm/bitsperlong.h>
that defines both __BITS_PER_LONG for user space and
BITS_PER_LONG for usage in the kernel. The asm-generic
version falls back to 32 bit unless the architecture overrides
it, which I did for all 64 bit platforms.

Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/alpha/include/asm/bitsperlong.h      |    8 +++++++
 arch/alpha/include/asm/types.h            |    3 --
 arch/arm/include/asm/bitsperlong.h        |    1 +
 arch/avr32/include/asm/bitsperlong.h      |    1 +
 arch/blackfin/include/asm/bitsperlong.h   |    1 +
 arch/cris/include/asm/bitsperlong.h       |    1 +
 arch/frv/include/asm/bitsperlong.h        |    1 +
 arch/h8300/include/asm/bitsperlong.h      |    1 +
 arch/ia64/include/asm/bitsperlong.h       |    8 +++++++
 arch/ia64/include/asm/types.h             |    7 ------
 arch/m32r/include/asm/bitsperlong.h       |    1 +
 arch/m68k/include/asm/bitsperlong.h       |    1 +
 arch/microblaze/include/asm/bitsperlong.h |    1 +
 arch/mips/include/asm/bitsperlong.h       |    8 +++++++
 arch/mips/include/asm/types.h             |    3 --
 arch/mn10300/include/asm/bitsperlong.h    |    1 +
 arch/parisc/include/asm/bitsperlong.h     |   20 ++++++++++++++++++
 arch/parisc/include/asm/types.h           |    8 -------
 arch/powerpc/include/asm/bitsperlong.h    |   12 ++++++++++
 arch/powerpc/include/asm/types.h          |    9 --------
 arch/s390/include/asm/bitsperlong.h       |   13 +++++++++++
 arch/s390/include/asm/types.h             |    6 -----
 arch/sh/include/asm/bitsperlong.h         |    1 +
 arch/sparc/include/asm/bitsperlong.h      |   13 +++++++++++
 arch/sparc/include/asm/types.h            |    4 ---
 arch/x86/include/asm/bitsperlong.h        |   13 +++++++++++
 arch/x86/include/asm/types.h              |    6 -----
 arch/xtensa/include/asm/bitsperlong.h     |    1 +
 include/asm-generic/Kbuild                |    1 +
 include/asm-generic/Kbuild.asm            |    1 +
 include/asm-generic/bitsperlong.h         |   32 +++++++++++++++++++++++++++++
 include/asm-generic/int-l64.h             |    2 +
 include/asm-generic/int-ll64.h            |    2 +
 33 files changed, 145 insertions(+), 46 deletions(-)
 create mode 100644 arch/alpha/include/asm/bitsperlong.h
 create mode 100644 arch/arm/include/asm/bitsperlong.h
 create mode 100644 arch/avr32/include/asm/bitsperlong.h
 create mode 100644 arch/blackfin/include/asm/bitsperlong.h
 create mode 100644 arch/cris/include/asm/bitsperlong.h
 create mode 100644 arch/frv/include/asm/bitsperlong.h
 create mode 100644 arch/h8300/include/asm/bitsperlong.h
 create mode 100644 arch/ia64/include/asm/bitsperlong.h
 create mode 100644 arch/m32r/include/asm/bitsperlong.h
 create mode 100644 arch/m68k/include/asm/bitsperlong.h
 create mode 100644 arch/microblaze/include/asm/bitsperlong.h
 create mode 100644 arch/mips/include/asm/bitsperlong.h
 create mode 100644 arch/mn10300/include/asm/bitsperlong.h
 create mode 100644 arch/parisc/include/asm/bitsperlong.h
 create mode 100644 arch/powerpc/include/asm/bitsperlong.h
 create mode 100644 arch/s390/include/asm/bitsperlong.h
 create mode 100644 arch/sh/include/asm/bitsperlong.h
 create mode 100644 arch/sparc/include/asm/bitsperlong.h
 create mode 100644 arch/x86/include/asm/bitsperlong.h
 create mode 100644 arch/xtensa/include/asm/bitsperlong.h
 create mode 100644 include/asm-generic/bitsperlong.h

diff --git a/arch/alpha/include/asm/bitsperlong.h b/arch/alpha/include/asm/bitsperlong.h
new file mode 100644
index 0000000..ad57f78
--- /dev/null
+++ b/arch/alpha/include/asm/bitsperlong.h
@@ -0,0 +1,8 @@
+#ifndef __ASM_ALPHA_BITSPERLONG_H
+#define __ASM_ALPHA_BITSPERLONG_H
+
+#define __BITS_PER_LONG 64
+
+#include <asm-generic/bitsperlong.h>
+
+#endif /* __ASM_ALPHA_BITSPERLONG_H */
diff --git a/arch/alpha/include/asm/types.h b/arch/alpha/include/asm/types.h
index f072f34..bd621ec 100644
--- a/arch/alpha/include/asm/types.h
+++ b/arch/alpha/include/asm/types.h
@@ -25,9 +25,6 @@ typedef unsigned int umode_t;
  * These aren't exported outside the kernel to avoid name space clashes
  */
 #ifdef __KERNEL__
-
-#define BITS_PER_LONG 64
-
 #ifndef __ASSEMBLY__
 
 typedef u64 dma_addr_t;
diff --git a/arch/arm/include/asm/bitsperlong.h b/arch/arm/include/asm/bitsperlong.h
new file mode 100644
index 0000000..6dc0bb0
--- /dev/null
+++ b/arch/arm/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
diff --git a/arch/avr32/include/asm/bitsperlong.h b/arch/avr32/include/asm/bitsperlong.h
new file mode 100644
index 0000000..6dc0bb0
--- /dev/null
+++ b/arch/avr32/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
diff --git a/arch/blackfin/include/asm/bitsperlong.h b/arch/blackfin/include/asm/bitsperlong.h
new file mode 100644
index 0000000..6dc0bb0
--- /dev/null
+++ b/arch/blackfin/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
diff --git a/arch/cris/include/asm/bitsperlong.h b/arch/cris/include/asm/bitsperlong.h
new file mode 100644
index 0000000..6dc0bb0
--- /dev/null
+++ b/arch/cris/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
diff --git a/arch/frv/include/asm/bitsperlong.h b/arch/frv/include/asm/bitsperlong.h
new file mode 100644
index 0000000..6dc0bb0
--- /dev/null
+++ b/arch/frv/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
diff --git a/arch/h8300/include/asm/bitsperlong.h b/arch/h8300/include/asm/bitsperlong.h
new file mode 100644
index 0000000..6dc0bb0
--- /dev/null
+++ b/arch/h8300/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
diff --git a/arch/ia64/include/asm/bitsperlong.h b/arch/ia64/include/asm/bitsperlong.h
new file mode 100644
index 0000000..ec4db3c
--- /dev/null
+++ b/arch/ia64/include/asm/bitsperlong.h
@@ -0,0 +1,8 @@
+#ifndef __ASM_IA64_BITSPERLONG_H
+#define __ASM_IA64_BITSPERLONG_H
+
+#define __BITS_PER_LONG 64
+
+#include <asm-generic/bitsperlong.h>
+
+#endif /* __ASM_IA64_BITSPERLONG_H */
diff --git a/arch/ia64/include/asm/types.h b/arch/ia64/include/asm/types.h
index e36b371..fbf1ed3 100644
--- a/arch/ia64/include/asm/types.h
+++ b/arch/ia64/include/asm/types.h
@@ -19,10 +19,6 @@
 # define __IA64_UL(x)		(x)
 # define __IA64_UL_CONST(x)	x
 
-# ifdef __KERNEL__
-#  define BITS_PER_LONG 64
-# endif
-
 #else
 # define __IA64_UL(x)		((unsigned long)(x))
 # define __IA64_UL_CONST(x)	x##UL
@@ -34,10 +30,7 @@ typedef unsigned int umode_t;
  */
 # ifdef __KERNEL__
 
-#define BITS_PER_LONG 64
-
 /* DMA addresses are 64-bits wide, in general.  */
-
 typedef u64 dma_addr_t;
 
 # endif /* __KERNEL__ */
diff --git a/arch/m32r/include/asm/bitsperlong.h b/arch/m32r/include/asm/bitsperlong.h
new file mode 100644
index 0000000..6dc0bb0
--- /dev/null
+++ b/arch/m32r/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
diff --git a/arch/m68k/include/asm/bitsperlong.h b/arch/m68k/include/asm/bitsperlong.h
new file mode 100644
index 0000000..6dc0bb0
--- /dev/null
+++ b/arch/m68k/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
diff --git a/arch/microblaze/include/asm/bitsperlong.h b/arch/microblaze/include/asm/bitsperlong.h
new file mode 100644
index 0000000..6dc0bb0
--- /dev/null
+++ b/arch/microblaze/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
diff --git a/arch/mips/include/asm/bitsperlong.h b/arch/mips/include/asm/bitsperlong.h
new file mode 100644
index 0000000..3e4c10a
--- /dev/null
+++ b/arch/mips/include/asm/bitsperlong.h
@@ -0,0 +1,8 @@
+#ifndef __ASM_MIPS_BITSPERLONG_H
+#define __ASM_MIPS_BITSPERLONG_H
+
+#define __BITS_PER_LONG _MIPS_SZLONG
+
+#include <asm-generic/bitsperlong.h>
+
+#endif /* __ASM_MIPS_BITSPERLONG_H */
diff --git a/arch/mips/include/asm/types.h b/arch/mips/include/asm/types.h
index 7956e69..544a285 100644
--- a/arch/mips/include/asm/types.h
+++ b/arch/mips/include/asm/types.h
@@ -31,9 +31,6 @@ typedef unsigned short umode_t;
  * These aren't exported outside the kernel to avoid name space clashes
  */
 #ifdef __KERNEL__
-
-#define BITS_PER_LONG _MIPS_SZLONG
-
 #ifndef __ASSEMBLY__
 
 #if (defined(CONFIG_HIGHMEM) && defined(CONFIG_64BIT_PHYS_ADDR)) \
diff --git a/arch/mn10300/include/asm/bitsperlong.h b/arch/mn10300/include/asm/bitsperlong.h
new file mode 100644
index 0000000..6dc0bb0
--- /dev/null
+++ b/arch/mn10300/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
diff --git a/arch/parisc/include/asm/bitsperlong.h b/arch/parisc/include/asm/bitsperlong.h
new file mode 100644
index 0000000..75196b4
--- /dev/null
+++ b/arch/parisc/include/asm/bitsperlong.h
@@ -0,0 +1,20 @@
+#ifndef __ASM_PARISC_BITSPERLONG_H
+#define __ASM_PARISC_BITSPERLONG_H
+
+/*
+ * using CONFIG_* outside of __KERNEL__ is wrong,
+ * __LP64__ was also removed from headers, so what
+ * is the right approach on parisc?
+ *	-arnd
+ */
+#if (defined(__KERNEL__) && defined(CONFIG_64BIT)) || defined (__LP64__)
+#define __BITS_PER_LONG 64
+#define SHIFT_PER_LONG 6
+#else
+#define __BITS_PER_LONG 32
+#define SHIFT_PER_LONG 5
+#endif
+
+#include <asm-generic/bitsperlong.h>
+
+#endif /* __ASM_PARISC_BITSPERLONG_H */
diff --git a/arch/parisc/include/asm/types.h b/arch/parisc/include/asm/types.h
index 7f5a39b..20135cc 100644
--- a/arch/parisc/include/asm/types.h
+++ b/arch/parisc/include/asm/types.h
@@ -14,14 +14,6 @@ typedef unsigned short umode_t;
  */
 #ifdef __KERNEL__
 
-#ifdef CONFIG_64BIT
-#define BITS_PER_LONG 64
-#define SHIFT_PER_LONG 6
-#else
-#define BITS_PER_LONG 32
-#define SHIFT_PER_LONG 5
-#endif
-
 #ifndef __ASSEMBLY__
 
 /* Dma addresses are 32-bits wide.  */
diff --git a/arch/powerpc/include/asm/bitsperlong.h b/arch/powerpc/include/asm/bitsperlong.h
new file mode 100644
index 0000000..5f16590
--- /dev/null
+++ b/arch/powerpc/include/asm/bitsperlong.h
@@ -0,0 +1,12 @@
+#ifndef __ASM_POWERPC_BITSPERLONG_H
+#define __ASM_POWERPC_BITSPERLONG_H
+
+#if defined(__powerpc64__)
+# define __BITS_PER_LONG 64
+#else
+# define __BITS_PER_LONG 32
+#endif
+
+#include <asm-generic/bitsperlong.h>
+
+#endif /* __ASM_POWERPC_BITSPERLONG_H */
diff --git a/arch/powerpc/include/asm/types.h b/arch/powerpc/include/asm/types.h
index 7ce27a5..a5aea0c 100644
--- a/arch/powerpc/include/asm/types.h
+++ b/arch/powerpc/include/asm/types.h
@@ -40,15 +40,6 @@ typedef struct {
 #endif /* __ASSEMBLY__ */
 
 #ifdef __KERNEL__
-/*
- * These aren't exported outside the kernel to avoid name space clashes
- */
-#ifdef __powerpc64__
-#define BITS_PER_LONG 64
-#else
-#define BITS_PER_LONG 32
-#endif
-
 #ifndef __ASSEMBLY__
 
 typedef __vector128 vector128;
diff --git a/arch/s390/include/asm/bitsperlong.h b/arch/s390/include/asm/bitsperlong.h
new file mode 100644
index 0000000..6b235ae
--- /dev/null
+++ b/arch/s390/include/asm/bitsperlong.h
@@ -0,0 +1,13 @@
+#ifndef __ASM_S390_BITSPERLONG_H
+#define __ASM_S390_BITSPERLONG_H
+
+#ifndef __s390x__
+#define __BITS_PER_LONG 32
+#else
+#define __BITS_PER_LONG 64
+#endif
+
+#include <asm-generic/bitsperlong.h>
+
+#endif /* __ASM_S390_BITSPERLONG_H */
+
diff --git a/arch/s390/include/asm/types.h b/arch/s390/include/asm/types.h
index 3dc3fc2..04d6b95 100644
--- a/arch/s390/include/asm/types.h
+++ b/arch/s390/include/asm/types.h
@@ -28,12 +28,6 @@ typedef __signed__ long saddr_t;
  */
 #ifdef __KERNEL__
 
-#ifndef __s390x__
-#define BITS_PER_LONG 32
-#else
-#define BITS_PER_LONG 64
-#endif
-
 #ifndef __ASSEMBLY__
 
 typedef u64 dma64_addr_t;
diff --git a/arch/sh/include/asm/bitsperlong.h b/arch/sh/include/asm/bitsperlong.h
new file mode 100644
index 0000000..6dc0bb0
--- /dev/null
+++ b/arch/sh/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
diff --git a/arch/sparc/include/asm/bitsperlong.h b/arch/sparc/include/asm/bitsperlong.h
new file mode 100644
index 0000000..40dcaa3
--- /dev/null
+++ b/arch/sparc/include/asm/bitsperlong.h
@@ -0,0 +1,13 @@
+#ifndef __ASM_ALPHA_BITSPERLONG_H
+#define __ASM_ALPHA_BITSPERLONG_H
+
+#if defined(__sparc__) && defined(__arch64__)
+#define __BITS_PER_LONG 64
+#else
+#define __BITS_PER_LONG 32
+#endif
+
+#include <asm-generic/bitsperlong.h>
+
+#endif /* __ASM_ALPHA_BITSPERLONG_H */
+
diff --git a/arch/sparc/include/asm/types.h b/arch/sparc/include/asm/types.h
index 2237118..de671d7 100644
--- a/arch/sparc/include/asm/types.h
+++ b/arch/sparc/include/asm/types.h
@@ -21,8 +21,6 @@ typedef unsigned short umode_t;
 
 #ifdef __KERNEL__
 
-#define BITS_PER_LONG 64
-
 #ifndef __ASSEMBLY__
 
 /* Dma addresses come in generic and 64-bit flavours.  */
@@ -46,8 +44,6 @@ typedef unsigned short umode_t;
 
 #ifdef __KERNEL__
 
-#define BITS_PER_LONG 32
-
 #ifndef __ASSEMBLY__
 
 typedef u32 dma_addr_t;
diff --git a/arch/x86/include/asm/bitsperlong.h b/arch/x86/include/asm/bitsperlong.h
new file mode 100644
index 0000000..b0ae1c4
--- /dev/null
+++ b/arch/x86/include/asm/bitsperlong.h
@@ -0,0 +1,13 @@
+#ifndef __ASM_X86_BITSPERLONG_H
+#define __ASM_X86_BITSPERLONG_H
+
+#ifdef __x86_64__
+# define __BITS_PER_LONG 64
+#else
+# define __BITS_PER_LONG 32
+#endif
+
+#include <asm-generic/bitsperlong.h>
+
+#endif /* __ASM_X86_BITSPERLONG_H */
+
diff --git a/arch/x86/include/asm/types.h b/arch/x86/include/asm/types.h
index e6f7363..09b9774 100644
--- a/arch/x86/include/asm/types.h
+++ b/arch/x86/include/asm/types.h
@@ -14,12 +14,6 @@ typedef unsigned short umode_t;
  */
 #ifdef __KERNEL__
 
-#ifdef CONFIG_X86_32
-# define BITS_PER_LONG 32
-#else
-# define BITS_PER_LONG 64
-#endif
-
 #ifndef __ASSEMBLY__
 
 typedef u64 dma64_addr_t;
diff --git a/arch/xtensa/include/asm/bitsperlong.h b/arch/xtensa/include/asm/bitsperlong.h
new file mode 100644
index 0000000..6dc0bb0
--- /dev/null
+++ b/arch/xtensa/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
index 460b08d..cbb4378 100644
--- a/include/asm-generic/Kbuild
+++ b/include/asm-generic/Kbuild
@@ -1,3 +1,4 @@
+header-y += bitsperlong.h
 header-y += errno-base.h
 header-y += errno.h
 header-y += fcntl.h
diff --git a/include/asm-generic/Kbuild.asm b/include/asm-generic/Kbuild.asm
index 70d1855..290910e 100644
--- a/include/asm-generic/Kbuild.asm
+++ b/include/asm-generic/Kbuild.asm
@@ -9,6 +9,7 @@ unifdef-y += a.out.h
 endif
 unifdef-y += auxvec.h
 unifdef-y += byteorder.h
+unifdef-y += bitsperlong.h
 unifdef-y += errno.h
 unifdef-y += fcntl.h
 unifdef-y += ioctl.h
diff --git a/include/asm-generic/bitsperlong.h b/include/asm-generic/bitsperlong.h
new file mode 100644
index 0000000..4ae54e0
--- /dev/null
+++ b/include/asm-generic/bitsperlong.h
@@ -0,0 +1,32 @@
+#ifndef __ASM_GENERIC_BITS_PER_LONG
+#define __ASM_GENERIC_BITS_PER_LONG
+
+/*
+ * There seems to be no way of detecting this automatically from user
+ * space, so 64 bit architectures should override this in their
+ * bitsperlong.h. In particular, an architecture that supports
+ * both 32 and 64 bit user space must not rely on CONFIG_64BIT
+ * to decide it, but rather check a compiler provided macro.
+ */
+#ifndef __BITS_PER_LONG
+#define __BITS_PER_LONG 32
+#endif
+
+#ifdef __KERNEL__
+
+#ifdef CONFIG_64BIT
+#define BITS_PER_LONG 64
+#else
+#define BITS_PER_LONG 32
+#endif /* CONFIG_64BIT */
+
+/*
+ * FIXME: The check currently breaks x86-64 build, so it's
+ * temporarily disabled. Please fix x86-64 and reenable
+ */
+#if 0 && BITS_PER_LONG != __BITS_PER_LONG
+#error Inconsistent word size. Check asm/bitsperlong.h
+#endif
+
+#endif /* __KERNEL__ */
+#endif /* __ASM_GENERIC_BITS_PER_LONG */
diff --git a/include/asm-generic/int-l64.h b/include/asm-generic/int-l64.h
index 2af9b75..1ca3efc 100644
--- a/include/asm-generic/int-l64.h
+++ b/include/asm-generic/int-l64.h
@@ -8,6 +8,8 @@
 #ifndef _ASM_GENERIC_INT_L64_H
 #define _ASM_GENERIC_INT_L64_H
 
+#include <asm/bitsperlong.h>
+
 #ifndef __ASSEMBLY__
 /*
  * __xx is ok: it doesn't pollute the POSIX namespace. Use these in the
diff --git a/include/asm-generic/int-ll64.h b/include/asm-generic/int-ll64.h
index f9bc9ac..f394147 100644
--- a/include/asm-generic/int-ll64.h
+++ b/include/asm-generic/int-ll64.h
@@ -8,6 +8,8 @@
 #ifndef _ASM_GENERIC_INT_LL64_H
 #define _ASM_GENERIC_INT_LL64_H
 
+#include <asm/bitsperlong.h>
+
 #ifndef __ASSEMBLY__
 /*
  * __xx is ok: it doesn't pollute the POSIX namespace. Use these in the
-- 
1.6.0.4

