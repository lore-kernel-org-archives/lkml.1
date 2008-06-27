Return-Path: <linux-kernel-owner+w=401wt.eu-S1763523AbYF0VPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763523AbYF0VPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756349AbYF0VPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:15:13 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53934 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485AbYF0VPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:15:09 -0400
Date: Sat, 28 Jun 2008 00:12:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, dhowells@redhat.com, andi@firstfloor.org,
       "Kirill A. Shutemov" <k.shutemov@gmail.com>, ysato@users.sourceforge.jp,
       takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org, kyle@mcmartin.ca,
       matthew@wil.cx, grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
       lethal@linux-sh.org, linux-sh@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: [2.6 patch] remove unused asm/a.out.h files
Message-ID: <20080627211252.GA16545@cs181140183.pp.htv.fi>
References: <1213565555.26255.522.camel@pmac.infradead.org> <1213604973-7073-1-git-send-email-jacmet@sunsite.dk> <1213617663.26255.708.camel@pmac.infradead.org> <20080616121727.GB10854@cs181133002.pp.htv.fi> <1213619214.26255.721.camel@pmac.infradead.org> <20080617084235.GA20169@cs181133002.pp.htv.fi> <1213696004.26255.960.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1213696004.26255.960.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 10:46:44AM +0100, David Woodhouse wrote:
>...
> I think we can probably get away with removing <asm/a.out.h> from every
> architecture other than Alpha, ARM, m68k and x86,
>...

Patch below.

> dwmw2

cu
Adrian


<--  snip  -->


This patch removes asm/a.out.h from all architectures that do not
provide a.out support.

This patch also includes the required removal of (unused)
#include <asm/a.out.h>'s and #include <linux/a.out.h>'s in the arch/
code for these architectures.

The ppc and v850 architectures that should anyway be removed in 2.6.27 
are not touched by this patch to avoid needless merge conflicts.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/cris/arch-v10/boot/tools/build.c   |    1 
 arch/h8300/kernel/process.c             |    1 
 arch/ia64/mm/init.c                     |    1 
 arch/m68knommu/kernel/process.c         |    1 
 arch/m68knommu/kernel/traps.c           |    1 
 arch/mips/kernel/irixelf.c              |    1 
 arch/mips/kernel/process.c              |    1 
 arch/mips/kernel/syscall.c              |    1 
 arch/powerpc/kernel/softemu8xx.c        |    1 
 arch/powerpc/kernel/traps.c             |    1 
 arch/powerpc/platforms/chrp/setup.c     |    1 
 arch/powerpc/platforms/maple/setup.c    |    1 
 arch/powerpc/platforms/powermac/setup.c |    1 
 arch/powerpc/platforms/pseries/setup.c  |    1 
 include/asm-avr32/a.out.h               |   20 -------------
 include/asm-blackfin/a.out.h            |   19 -------------
 include/asm-cris/a.out.h                |   26 -----------------
 include/asm-h8300/a.out.h               |   20 -------------
 include/asm-ia64/a.out.h                |   32 ---------------------
 include/asm-m32r/a.out.h                |   20 -------------
 include/asm-m68knommu/a.out.h           |    1 
 include/asm-mips/a.out.h                |   35 ------------------------
 include/asm-parisc/a.out.h              |   20 -------------
 include/asm-powerpc/a.out.h             |   20 -------------
 include/asm-sh/a.out.h                  |   20 -------------
 include/asm-xtensa/a.out.h              |   29 -------------------
 26 files changed, 276 deletions(-)

9cd72b780be8d25cd2deb99a923030f2fe2aeba4 diff --git a/arch/cris/arch-v10/boot/tools/build.c b/arch/cris/arch-v10/boot/tools/build.c
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
index ec9aea6..0157b9d 100644
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
diff --git a/arch/mips/kernel/irixelf.c b/arch/mips/kernel/irixelf.c
index 469c723..e068a72 100644
--- a/arch/mips/kernel/irixelf.c
+++ b/arch/mips/kernel/irixelf.c
@@ -18,7 +18,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
-#include <linux/a.out.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/signal.h>
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index 2c09a44..2040fc5 100644
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
index af1bdc8..0d2b609 100644
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
diff --git a/arch/powerpc/kernel/softemu8xx.c b/arch/powerpc/kernel/softemu8xx.c
index 67d6f68..2489493 100644
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
index 4b5b7ff..c7e499e 100644
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
index 116babb..e6b3fac 100644
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
index 00bd016..19c287a 100644
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
index f5d29f5..577efcd 100644
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
diff --git a/include/asm-avr32/a.out.h b/include/asm-avr32/a.out.h
deleted file mode 100644
index e46375a..0000000
--- a/include/asm-avr32/a.out.h
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
diff --git a/include/asm-blackfin/a.out.h b/include/asm-blackfin/a.out.h
deleted file mode 100644
index 6c3d652..0000000
--- a/include/asm-blackfin/a.out.h
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
diff --git a/include/asm-h8300/a.out.h b/include/asm-h8300/a.out.h
deleted file mode 100644
index ded780f..0000000
--- a/include/asm-h8300/a.out.h
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
diff --git a/include/asm-ia64/a.out.h b/include/asm-ia64/a.out.h
deleted file mode 100644
index 193dcfb..0000000
--- a/include/asm-ia64/a.out.h
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
diff --git a/include/asm-m68knommu/a.out.h b/include/asm-m68knommu/a.out.h
deleted file mode 100644
index ce18ef9..0000000
--- a/include/asm-m68knommu/a.out.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/a.out.h>
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
diff --git a/include/asm-powerpc/a.out.h b/include/asm-powerpc/a.out.h
deleted file mode 100644
index 89cead6..0000000
--- a/include/asm-powerpc/a.out.h
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
diff --git a/include/asm-sh/a.out.h b/include/asm-sh/a.out.h
deleted file mode 100644
index 1f93130..0000000
--- a/include/asm-sh/a.out.h
+++ /dev/null
@@ -1,20 +0,0 @@
-#ifndef __ASM_SH_A_OUT_H
-#define __ASM_SH_A_OUT_H
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
-#endif /* __ASM_SH_A_OUT_H */
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

