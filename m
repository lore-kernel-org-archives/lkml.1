Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbYDZPsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbYDZPsR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 11:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbYDZPsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 11:48:05 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:55389 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753467AbYDZPsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 11:48:04 -0400
Date: Sat, 26 Apr 2008 17:48:01 +0200
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [ASYNC_TX] don't include <asm/> headers
Message-ID: <20080426154801.GA18712@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Siewior <sebastian@breakpoint.cc>

Including arch dependent header files from arch indepent .c code
causes randconfig builds to fail. This patch fixes build problems on
arches which are not tested by Adrian like m68knommu.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 arch/alpha/Kconfig        |    1 +
 arch/arm/Kconfig          |    1 +
 arch/ia64/Kconfig         |    1 +
 arch/sparc/Kconfig        |    1 +
 arch/sparc64/Kconfig      |    2 ++
 arch/x86/Kconfig          |    2 +-
 crypto/Kconfig            |    3 +++
 crypto/xor.c              |    1 -
 include/asm-avr32/xor.h   |    6 ------
 include/asm-frv/xor.h     |    1 -
 include/asm-m32r/xor.h    |    6 ------
 include/asm-m68k/xor.h    |    1 -
 include/asm-mips/xor.h    |    1 -
 include/asm-mn10300/xor.h |    1 -
 include/asm-parisc/xor.h  |    1 -
 include/asm-powerpc/xor.h |    1 -
 include/asm-s390/xor.h    |    1 -
 include/asm-sh/xor.h      |    1 -
 include/asm-um/xor.h      |    6 ------
 include/asm-xtensa/xor.h  |   16 ----------------
 include/linux/raid/xor.h  |    6 ++++++
 21 files changed, 16 insertions(+), 44 deletions(-)
 delete mode 100644 include/asm-avr32/xor.h
 delete mode 100644 include/asm-frv/xor.h
 delete mode 100644 include/asm-m32r/xor.h
 delete mode 100644 include/asm-m68k/xor.h
 delete mode 100644 include/asm-mips/xor.h
 delete mode 100644 include/asm-mn10300/xor.h
 delete mode 100644 include/asm-parisc/xor.h
 delete mode 100644 include/asm-powerpc/xor.h
 delete mode 100644 include/asm-s390/xor.h
 delete mode 100644 include/asm-sh/xor.h
 delete mode 100644 include/asm-um/xor.h
 delete mode 100644 include/asm-xtensa/xor.h

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 729cdbd..04b318a 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -7,6 +7,7 @@ config ALPHA
 	default y
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_ARCH_XOR
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index d8d2532..fa22db3 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -13,6 +13,7 @@ config ARM
 	select HAVE_OPROFILE
 	select HAVE_KPROBES if (!XIP_KERNEL)
 	select HAVE_KRETPROBES if (HAVE_KPROBES)
+	select HAVE_ARCH_XOR
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index cd13e13..4b18d6e 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -19,6 +19,7 @@ config IA64
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select HAVE_ARCH_XOR
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 49590f8..dd3e949 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -73,6 +73,7 @@ config SPARC
 config SPARC32
 	bool
 	default y
+	select HAVE_ARCH_XOR
 	help
 	  SPARC is a family of RISC microprocessors designed and marketed by
 	  Sun Microsystems, incorporated.  They are very widely found in Sun
diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index 8acc5cc..ee659a8 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -11,12 +11,14 @@ config SPARC
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select HAVE_ARCH_XOR
 
 config SPARC64
 	bool
 	default y
 	select HAVE_IDE
 	select HAVE_LMB
+	select HAVE_ARCH_XOR
 	help
 	  SPARC is a family of RISC microprocessors designed and marketed by
 	  Sun Microsystems, incorporated.  This port covers the newer 64-bit
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4d350b5..b43095f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -24,7 +24,7 @@ config X86
 	select HAVE_KRETPROBES
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
-
+	select HAVE_ARCH_XOR
 
 config GENERIC_LOCKBREAK
 	def_bool n
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 864456c..9a49abd 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1,6 +1,9 @@
 #
 # Generic algorithms support
 #
+config HAVE_ARCH_XOR
+	bool
+
 config XOR_BLOCKS
 	tristate
 
diff --git a/crypto/xor.c b/crypto/xor.c
index b2e6db0..1992a34 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -20,7 +20,6 @@
 #include <linux/module.h>
 #include <linux/raid/md.h>
 #include <linux/raid/xor.h>
-#include <asm/xor.h>
 
 /* The xor routines to use.  */
 static struct xor_block_template *active_template;
diff --git a/include/asm-avr32/xor.h b/include/asm-avr32/xor.h
deleted file mode 100644
index 99c87aa..0000000
--- a/include/asm-avr32/xor.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_XOR_H
-#define _ASM_XOR_H
-
-#include <asm-generic/xor.h>
-
-#endif
diff --git a/include/asm-frv/xor.h b/include/asm-frv/xor.h
deleted file mode 100644
index c82eb12..0000000
--- a/include/asm-frv/xor.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/xor.h>
diff --git a/include/asm-m32r/xor.h b/include/asm-m32r/xor.h
deleted file mode 100644
index 6d52525..0000000
--- a/include/asm-m32r/xor.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_M32R_XOR_H
-#define _ASM_M32R_XOR_H
-
-#include <asm-generic/xor.h>
-
-#endif  /* _ASM_M32R_XOR_H */
diff --git a/include/asm-m68k/xor.h b/include/asm-m68k/xor.h
deleted file mode 100644
index c82eb12..0000000
--- a/include/asm-m68k/xor.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/xor.h>
diff --git a/include/asm-mips/xor.h b/include/asm-mips/xor.h
deleted file mode 100644
index c82eb12..0000000
--- a/include/asm-mips/xor.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/xor.h>
diff --git a/include/asm-mn10300/xor.h b/include/asm-mn10300/xor.h
deleted file mode 100644
index c82eb12..0000000
--- a/include/asm-mn10300/xor.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/xor.h>
diff --git a/include/asm-parisc/xor.h b/include/asm-parisc/xor.h
deleted file mode 100644
index c82eb12..0000000
--- a/include/asm-parisc/xor.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/xor.h>
diff --git a/include/asm-powerpc/xor.h b/include/asm-powerpc/xor.h
deleted file mode 100644
index c82eb12..0000000
--- a/include/asm-powerpc/xor.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/xor.h>
diff --git a/include/asm-s390/xor.h b/include/asm-s390/xor.h
deleted file mode 100644
index c82eb12..0000000
--- a/include/asm-s390/xor.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/xor.h>
diff --git a/include/asm-sh/xor.h b/include/asm-sh/xor.h
deleted file mode 100644
index c82eb12..0000000
--- a/include/asm-sh/xor.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/xor.h>
diff --git a/include/asm-um/xor.h b/include/asm-um/xor.h
deleted file mode 100644
index a19db3e..0000000
--- a/include/asm-um/xor.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __UM_XOR_H
-#define __UM_XOR_H
-
-#include "asm-generic/xor.h"
-
-#endif
diff --git a/include/asm-xtensa/xor.h b/include/asm-xtensa/xor.h
deleted file mode 100644
index e7b1f08..0000000
--- a/include/asm-xtensa/xor.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * include/asm-xtensa/xor.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_XOR_H
-#define _XTENSA_XOR_H
-
-#include <asm-generic/xor.h>
-
-#endif
diff --git a/include/linux/raid/xor.h b/include/linux/raid/xor.h
index 3e12058..51e8ae9 100644
--- a/include/linux/raid/xor.h
+++ b/include/linux/raid/xor.h
@@ -21,4 +21,10 @@ struct xor_block_template {
 		     unsigned long *, unsigned long *, unsigned long *);
 };
 
+#ifdef CONFIG_HAVE_ARCH_XOR
+#include <asm/xor.h>
+#else
+#include <asm-generic/xor.h>
+#endif
+
 #endif
-- 
1.5.4.5

