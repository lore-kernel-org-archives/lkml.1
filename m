Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbYIERR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbYIERR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 13:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbYIERRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 13:17:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:49032 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbYIERRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 13:17:16 -0400
Subject: [PATCH 3/2] Remove asm/a.out.h files for all architectures without
	a.out support.
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Kyle McMartin <kyle@mcmartin.ca>, Adrian Bunk <bunk@kernel.org>
In-Reply-To: <20080905162831.GA13801@phobos.i.cabal.ca>
References: <20080905162831.GA13801@phobos.i.cabal.ca>
Content-Type: text/plain
Date: Fri, 05 Sep 2008 18:17:11 +0100
Message-Id: <1220635031.2985.366.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

This patch also includes the required removal of (unused) inclusion of
<asm/a.out.h> <linux/a.out.h>'s in the arch/ code for these
architectures.

[dwmw2: updated for 2.6.27-rc]
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 arch/avr32/include/asm/a.out.h          |   20 -----------------
 arch/blackfin/include/asm/a.out.h       |   19 ----------------
 arch/cris/arch-v10/boot/tools/build.c   |    1 -
 arch/h8300/include/asm/a.out.h          |   20 -----------------
 arch/h8300/kernel/process.c             |    1 -
 arch/ia64/include/asm/a.out.h           |   32 ----------------------------
 arch/ia64/mm/init.c                     |    1 -
 arch/m68knommu/include/asm/a.out.h      |    1 -
 arch/m68knommu/kernel/process.c         |    1 -
 arch/m68knommu/kernel/traps.c           |    1 -
 arch/mips/kernel/process.c              |    1 -
 arch/mips/kernel/syscall.c              |    1 -
 arch/powerpc/include/asm/a.out.h        |   20 -----------------
 arch/powerpc/kernel/softemu8xx.c        |    1 -
 arch/powerpc/kernel/traps.c             |    1 -
 arch/powerpc/platforms/chrp/setup.c     |    1 -
 arch/powerpc/platforms/maple/setup.c    |    1 -
 arch/powerpc/platforms/powermac/setup.c |    1 -
 arch/powerpc/platforms/pseries/setup.c  |    1 -
 include/asm-cris/a.out.h                |   26 -----------------------
 include/asm-m32r/a.out.h                |   20 -----------------
 include/asm-mips/a.out.h                |   35 -------------------------------
 include/asm-parisc/a.out.h              |   20 -----------------
 include/asm-xtensa/a.out.h              |   29 -------------------------
 24 files changed, 0 insertions(+), 255 deletions(-)
 delete mode 100644 arch/avr32/include/asm/a.out.h
 delete mode 100644 arch/blackfin/include/asm/a.out.h
 delete mode 100644 arch/h8300/include/asm/a.out.h
 delete mode 100644 arch/ia64/include/asm/a.out.h
 delete mode 100644 arch/m68knommu/include/asm/a.out.h
 delete mode 100644 arch/powerpc/include/asm/a.out.h
 delete mode 100644 include/asm-cris/a.out.h
 delete mode 100644 include/asm-m32r/a.out.h
 delete mode 100644 include/asm-mips/a.out.h
 delete mode 100644 include/asm-parisc/a.out.h
 delete mode 100644 include/asm-xtensa/a.out.h

diff --git a/arch/avr32/include/asm/a.out.h b/arch/avr32/include/asm/a.out.h
deleted file mode 100644
index e46375a..0000000
--- a/arch/avr32/include/asm/a.out.h
+++ /dev/null
@@ -1,20 +0,0 @@
-#ifndef __ASM_AVR32_A_OUT_H
-#define __ASM_AVR32_A_OUT_H
-
-struct exec
-{
-  unsigned long a_info;		/* Use macros N_MAGIC, etc for access */
-  unsigned a_text;		/* length of text, in bytes */
-  unsigned a_data;		/* length of data, in bytes */
-  unsigned a_bss;		/* length of uninitialized data area for file, in bytes */
-  unsigned a_syms;		/* length of symbol table data in file, in bytes */
-  unsigned a_entry;		/* start address */
-  unsigned a_trsize;		/* length of relocation info for text, in bytes */
-  unsigned a_drsize;		/* length of relocation info for data, in bytes */
-};
-
-#define N_TRSIZE(a)	((a).a_trsize)
-#define N_DRSIZE(a)	((a).a_drsize)
-#define N_SYMSIZE(a)	((a).a_syms)
-
-#endif /* __ASM_AVR32_A_OUT_H */
diff --git a/arch/blackfin/include/asm/a.out.h b/arch/blackfin/include/asm/a.out.h
deleted file mode 100644
index 6c3d652..0000000
--- a/arch/blackfin/include/asm/a.out.h
+++ /dev/null
@@ -1,19 +0,0 @@
-#ifndef __BFIN_A_OUT_H__
-#define __BFIN_A_OUT_H__
-
-struct exec {
-	unsigned long a_info;	/* Use macros N_MAGIC, etc for access */
-	unsigned a_text;	/* length of text, in bytes */
-	unsigned a_data;	/* length of data, in bytes */
-	unsigned a_bss;		/* length of uninitialized data area for file, in bytes */
-	unsigned a_syms;	/* length of symbol table data in file, in bytes */
-	unsigned a_entry;	/* start address */
-	unsigned a_trsize;	/* length of relocation info for text, in bytes */
-	unsigned a_drsize;	/* length of relocation info for data, in bytes */
-};
-
-#define N_TRSIZE(a)	((a).a_trsize)
-#define N_DRSIZE(a)	((a).a_drsize)
-#define N_SYMSIZE(a)	((a).a_syms)
-
-#endif				/* __BFIN_A_OUT_H__ */
diff --git a/arch/cris/arch-v10/boot/tools/build.c b/arch/cris/arch-v10/boot/tools/build.c
index 2f9bbb2..c8adef3 100644
--- a/arch/cris/arch-v10/boot/tools/build.c
+++ b/arch/cris/arch-v10/boot/tools/build.c
@@ -30,7 +30,6 @@
 #include <sys/sysmacros.h>
 #include <unistd.h>	/* contains read/write */
 #include <fcntl.h>
-#include <linux/a.out.h>
 #include <errno.h>
 
 #define MINIX_HEADER 32
diff --git a/arch/h8300/include/asm/a.out.h b/arch/h8300/include/asm/a.out.h
deleted file mode 100644
index ded780f..0000000
--- a/arch/h8300/include/asm/a.out.h
+++ /dev/null
@@ -1,20 +0,0 @@
-#ifndef __H8300_A_OUT_H__
-#define __H8300_A_OUT_H__
-
-struct exec
-{
-  unsigned long a_info;		/* Use macros N_MAGIC, etc for access */
-  unsigned a_text;		/* length of text, in bytes */
-  unsigned a_data;		/* length of data, in bytes */
-  unsigned a_bss;		/* length of uninitialized data area for file, in bytes */
-  unsigned a_syms;		/* length of symbol table data in file, in bytes */
-  unsigned a_entry;		/* start address */
-  unsigned a_trsize;		/* length of relocation info for text, in bytes */
-  unsigned a_drsize;		/* length of relocation info for data, in bytes */
-};
-
-#define N_TRSIZE(a)	((a).a_trsize)
-#define N_DRSIZE(a)	((a).a_drsize)
-#define N_SYMSIZE(a)	((a).a_syms)
-
-#endif /* __H8300_A_OUT_H__ */
diff --git a/arch/h8300/kernel/process.c b/arch/h8300/kernel/process.c
index dfbe7ab..a8ef654 100644
--- a/arch/h8300/kernel/process.c
+++ b/arch/h8300/kernel/process.c
@@ -34,7 +34,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/interrupt.h>
 #include <linux/reboot.h>
 #include <linux/fs.h>
diff --git a/arch/ia64/include/asm/a.out.h b/arch/ia64/include/asm/a.out.h
deleted file mode 100644
index 193dcfb..0000000
--- a/arch/ia64/include/asm/a.out.h
+++ /dev/null
@@ -1,32 +0,0 @@
-#ifndef _ASM_IA64_A_OUT_H
-#define _ASM_IA64_A_OUT_H
-
-/*
- * No a.out format has been (or should be) defined so this file is
- * just a dummy that allows us to get binfmt_elf compiled.  It
- * probably would be better to clean up binfmt_elf.c so it does not
- * necessarily depend on there being a.out support.
- *
- * Modified 1998-2002
- *	David Mosberger-Tang <davidm@hpl.hp.com>, Hewlett-Packard Co.
- */
-
-#include <linux/types.h>
-
-struct exec {
-	unsigned long a_info;
-	unsigned long a_text;
-	unsigned long a_data;
-	unsigned long a_bss;
-	unsigned long a_entry;
-};
-
-#define N_TXTADDR(x)	0
-#define N_DATADDR(x)	0
-#define N_BSSADDR(x)	0
-#define N_DRSIZE(x)	0
-#define N_TRSIZE(x)	0
-#define N_SYMSIZE(x)	0
-#define N_TXTOFF(x)	0
-
-#endif /* _ASM_IA64_A_OUT_H */
diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index 200100e..f482a90 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -21,7 +21,6 @@
 #include <linux/bitops.h>
 #include <linux/kexec.h>
 
-#include <asm/a.out.h>
 #include <asm/dma.h>
 #include <asm/ia32.h>
 #include <asm/io.h>
diff --git a/arch/m68knommu/include/asm/a.out.h b/arch/m68knommu/include/asm/a.out.h
deleted file mode 100644
index ce18ef9..0000000
--- a/arch/m68knommu/include/asm/a.out.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/a.out.h>
diff --git a/arch/m68knommu/kernel/process.c b/arch/m68knommu/kernel/process.c
index 47502d5..3f2d774 100644
--- a/arch/m68knommu/kernel/process.c
+++ b/arch/m68knommu/kernel/process.c
@@ -25,7 +25,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/interrupt.h>
 #include <linux/reboot.h>
 #include <linux/fs.h>
diff --git a/arch/m68knommu/kernel/traps.c b/arch/m68knommu/kernel/traps.c
index 46f8f9d..5d5d56b 100644
--- a/arch/m68knommu/kernel/traps.c
+++ b/arch/m68knommu/kernel/traps.c
@@ -22,7 +22,6 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/types.h>
-#include <linux/a.out.h>
 #include <linux/user.h>
 #include <linux/string.h>
 #include <linux/linkage.h>
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index b16facd..17edc69 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -22,7 +22,6 @@
 #include <linux/personality.h>
 #include <linux/sys.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/init.h>
 #include <linux/completion.h>
 #include <linux/kallsyms.h>
diff --git a/arch/mips/kernel/syscall.c b/arch/mips/kernel/syscall.c
index 343015a..37970d9 100644
--- a/arch/mips/kernel/syscall.c
+++ b/arch/mips/kernel/syscall.c
@@ -7,7 +7,6 @@
  * Copyright (C) 1999, 2000 Silicon Graphics, Inc.
  * Copyright (C) 2001 MIPS Technologies, Inc.
  */
-#include <linux/a.out.h>
 #include <linux/capability.h>
 #include <linux/errno.h>
 #include <linux/linkage.h>
diff --git a/arch/powerpc/include/asm/a.out.h b/arch/powerpc/include/asm/a.out.h
deleted file mode 100644
index 89cead6..0000000
--- a/arch/powerpc/include/asm/a.out.h
+++ /dev/null
@@ -1,20 +0,0 @@
-#ifndef _ASM_POWERPC_A_OUT_H
-#define _ASM_POWERPC_A_OUT_H
-
-struct exec
-{
-	unsigned long a_info;	/* Use macros N_MAGIC, etc for access */
-	unsigned a_text;	/* length of text, in bytes */
-	unsigned a_data;	/* length of data, in bytes */
-	unsigned a_bss;		/* length of uninitialized data area for file, in bytes */
-	unsigned a_syms;	/* length of symbol table data in file, in bytes */
-	unsigned a_entry;	/* start address */
-	unsigned a_trsize;	/* length of relocation info for text, in bytes */
-	unsigned a_drsize;	/* length of relocation info for data, in bytes */
-};
-
-#define N_TRSIZE(a)	((a).a_trsize)
-#define N_DRSIZE(a)	((a).a_drsize)
-#define N_SYMSIZE(a)	((a).a_syms)
-
-#endif /* _ASM_POWERPC_A_OUT_H */
diff --git a/arch/powerpc/kernel/softemu8xx.c b/arch/powerpc/kernel/softemu8xx.c
index c906c4b..23c8c5e 100644
--- a/arch/powerpc/kernel/softemu8xx.c
+++ b/arch/powerpc/kernel/softemu8xx.c
@@ -23,7 +23,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/interrupt.h>
 
 #include <asm/pgtable.h>
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 81ccb8d..f5def6c 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -23,7 +23,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/module.h>
diff --git a/arch/powerpc/platforms/chrp/setup.c b/arch/powerpc/platforms/chrp/setup.c
index 1ba7ce5..272d79a 100644
--- a/arch/powerpc/platforms/chrp/setup.c
+++ b/arch/powerpc/platforms/chrp/setup.c
@@ -17,7 +17,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/tty.h>
 #include <linux/major.h>
 #include <linux/interrupt.h>
diff --git a/arch/powerpc/platforms/maple/setup.c b/arch/powerpc/platforms/maple/setup.c
index 3647147..d4c61c3 100644
--- a/arch/powerpc/platforms/maple/setup.c
+++ b/arch/powerpc/platforms/maple/setup.c
@@ -23,7 +23,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/tty.h>
 #include <linux/string.h>
 #include <linux/delay.h>
diff --git a/arch/powerpc/platforms/powermac/setup.c b/arch/powerpc/platforms/powermac/setup.c
index 88ccf3a..82c14d2 100644
--- a/arch/powerpc/platforms/powermac/setup.c
+++ b/arch/powerpc/platforms/powermac/setup.c
@@ -33,7 +33,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/tty.h>
 #include <linux/string.h>
 #include <linux/delay.h>
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index 7b01d67..ec34170 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -25,7 +25,6 @@
 #include <linux/unistd.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/tty.h>
 #include <linux/major.h>
 #include <linux/interrupt.h>
diff --git a/include/asm-cris/a.out.h b/include/asm-cris/a.out.h
deleted file mode 100644
index c82e9f9..0000000
--- a/include/asm-cris/a.out.h
+++ /dev/null
@@ -1,26 +0,0 @@
-#ifndef __CRIS_A_OUT_H__
-#define __CRIS_A_OUT_H__
-
-/* we don't support a.out binaries on Linux/CRIS anyway, so this is
- * not really used but still needed because binfmt_elf.c for some reason
- * wants to know about a.out even if there is no interpreter available...
- */
-
-struct exec
-{
-  unsigned long a_info;		/* Use macros N_MAGIC, etc for access */
-  unsigned a_text;		/* length of text, in bytes */
-  unsigned a_data;		/* length of data, in bytes */
-  unsigned a_bss;		/* length of uninitialized data area for file, in bytes */
-  unsigned a_syms;		/* length of symbol table data in file, in bytes */
-  unsigned a_entry;		/* start address */
-  unsigned a_trsize;		/* length of relocation info for text, in bytes */
-  unsigned a_drsize;		/* length of relocation info for data, in bytes */
-};
-
-
-#define N_TRSIZE(a)	((a).a_trsize)
-#define N_DRSIZE(a)	((a).a_drsize)
-#define N_SYMSIZE(a)	((a).a_syms)
-
-#endif
diff --git a/include/asm-m32r/a.out.h b/include/asm-m32r/a.out.h
deleted file mode 100644
index ab150f5..0000000
--- a/include/asm-m32r/a.out.h
+++ /dev/null
@@ -1,20 +0,0 @@
-#ifndef _ASM_M32R_A_OUT_H
-#define _ASM_M32R_A_OUT_H
-
-struct exec
-{
-  unsigned long a_info;		/* Use macros N_MAGIC, etc for access */
-  unsigned a_text;		/* length of text, in bytes */
-  unsigned a_data;		/* length of data, in bytes */
-  unsigned a_bss;		/* length of uninitialized data area for file, in bytes */
-  unsigned a_syms;		/* length of symbol table data in file, in bytes */
-  unsigned a_entry;		/* start address */
-  unsigned a_trsize;		/* length of relocation info for text, in bytes */
-  unsigned a_drsize;		/* length of relocation info for data, in bytes */
-};
-
-#define N_TRSIZE(a)	((a).a_trsize)
-#define N_DRSIZE(a)	((a).a_drsize)
-#define N_SYMSIZE(a)	((a).a_syms)
-
-#endif /* _ASM_M32R_A_OUT_H */
diff --git a/include/asm-mips/a.out.h b/include/asm-mips/a.out.h
deleted file mode 100644
index cad8371..0000000
--- a/include/asm-mips/a.out.h
+++ /dev/null
@@ -1,35 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 1994 - 1999, 2003 by Ralf Baechle
- */
-#ifndef _ASM_A_OUT_H
-#define _ASM_A_OUT_H
-
-#ifdef __KERNEL__
-
-
-#endif
-
-struct exec
-{
-	unsigned long a_info;	/* Use macros N_MAGIC, etc for access */
-	unsigned a_text;	/* length of text, in bytes */
-	unsigned a_data;	/* length of data, in bytes */
-	unsigned a_bss;		/* length of uninitialized data area for
-				    file, in bytes */
-	unsigned a_syms;	/* length of symbol table data in file,
-				   in bytes */
-	unsigned a_entry;	/* start address */
-	unsigned a_trsize;	/* length of relocation info for text, in
-				    bytes */
-	unsigned a_drsize;	/* length of relocation info for data, in bytes */
-};
-
-#define N_TRSIZE(a)	((a).a_trsize)
-#define N_DRSIZE(a)	((a).a_drsize)
-#define N_SYMSIZE(a)	((a).a_syms)
-
-#endif /* _ASM_A_OUT_H */
diff --git a/include/asm-parisc/a.out.h b/include/asm-parisc/a.out.h
deleted file mode 100644
index eb04e34..0000000
--- a/include/asm-parisc/a.out.h
+++ /dev/null
@@ -1,20 +0,0 @@
-#ifndef __PARISC_A_OUT_H__
-#define __PARISC_A_OUT_H__
-
-struct exec
-{
-  unsigned int a_info;		/* Use macros N_MAGIC, etc for access */
-  unsigned a_text;		/* length of text, in bytes */
-  unsigned a_data;		/* length of data, in bytes */
-  unsigned a_bss;		/* length of uninitialized data area for file, in bytes */
-  unsigned a_syms;		/* length of symbol table data in file, in bytes */
-  unsigned a_entry;		/* start address */
-  unsigned a_trsize;		/* length of relocation info for text, in bytes */
-  unsigned a_drsize;		/* length of relocation info for data, in bytes */
-};
-
-#define N_TRSIZE(a)	((a).a_trsize)
-#define N_DRSIZE(a)	((a).a_drsize)
-#define N_SYMSIZE(a)	((a).a_syms)
-
-#endif /* __A_OUT_GNU_H__ */
diff --git a/include/asm-xtensa/a.out.h b/include/asm-xtensa/a.out.h
deleted file mode 100644
index fdf1370..0000000
--- a/include/asm-xtensa/a.out.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
- * include/asm-xtensa/a.out.h
- *
- * Dummy a.out file. Xtensa does not support the a.out format, but the kernel
- * seems to depend on it.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_A_OUT_H
-#define _XTENSA_A_OUT_H
-
-struct exec
-{
-  unsigned long a_info;
-  unsigned a_text;
-  unsigned a_data;
-  unsigned a_bss;
-  unsigned a_syms;
-  unsigned a_entry;
-  unsigned a_trsize;
-  unsigned a_drsize;
-};
-
-#endif /* _XTENSA_A_OUT_H */
-- 
1.5.5.1
-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



