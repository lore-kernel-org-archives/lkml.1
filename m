Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbZFXGvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbZFXGvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 02:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbZFXGu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 02:50:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:51699 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbZFXGuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 02:50:55 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, kyle@mcmartin.ca, cl@linux-foundation.org,
       Jesper.Nilsson@axis.com, benh@kernel.crashing.org,
       paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: Tejun Heo <tj@kernel.org>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>,
       Russell King <linux@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Bryan Wu <cooloney@kernel.org>, Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Tony Luck <tony.luck@intel.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
       Chris Zankel <chris@zankel.net>
Subject: [PATCH 02/10] linker script: throw away .discard section
Date: Wed, 24 Jun 2009 15:45:16 +0900
Message-Id: <1245825924-30412-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245825924-30412-1-git-send-email-tj@kernel.org>
References: <1245825924-30412-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 24 Jun 2009 06:45:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 throws away .discard section but no other archs do.  Also,
.discard is not thrown away while linking modules.  Make every arch
and module linking throw it away.  This will be used to define dummy
variables for percpu declarations and definitions.

This patch is based on Ivan Kokshaysky's alpha percpu patch.

[ Impact: always throw away everything in .discard ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
---
 Makefile                             |    2 +-
 arch/alpha/kernel/vmlinux.lds.S      |    1 +
 arch/arm/kernel/vmlinux.lds.S        |    1 +
 arch/avr32/kernel/vmlinux.lds.S      |    1 +
 arch/blackfin/kernel/vmlinux.lds.S   |    1 +
 arch/cris/kernel/vmlinux.lds.S       |    1 +
 arch/frv/kernel/vmlinux.lds.S        |    2 ++
 arch/h8300/kernel/vmlinux.lds.S      |    1 +
 arch/ia64/kernel/vmlinux.lds.S       |    1 +
 arch/m32r/kernel/vmlinux.lds.S       |    1 +
 arch/m68k/kernel/vmlinux-std.lds     |    1 +
 arch/m68k/kernel/vmlinux-sun3.lds    |    1 +
 arch/m68knommu/kernel/vmlinux.lds.S  |    1 +
 arch/microblaze/kernel/vmlinux.lds.S |    2 ++
 arch/mips/kernel/vmlinux.lds.S       |    1 +
 arch/mn10300/kernel/vmlinux.lds.S    |    1 +
 arch/parisc/kernel/vmlinux.lds.S     |    1 +
 arch/powerpc/kernel/vmlinux.lds.S    |    1 +
 arch/s390/kernel/vmlinux.lds.S       |    1 +
 arch/sh/kernel/vmlinux.lds.S         |    1 +
 arch/sparc/kernel/vmlinux.lds.S      |    1 +
 arch/um/kernel/dyn.lds.S             |    2 ++
 arch/um/kernel/uml.lds.S             |    2 ++
 arch/xtensa/kernel/vmlinux.lds.S     |    1 +
 include/asm-generic/vmlinux.lds.h    |    8 ++++++++
 scripts/module-common.lds            |    8 ++++++++
 26 files changed, 44 insertions(+), 1 deletions(-)
 create mode 100644 scripts/module-common.lds

diff --git a/Makefile b/Makefile
index 46e1c9d..12245be 100644
--- a/Makefile
+++ b/Makefile
@@ -327,7 +327,7 @@ CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
 MODFLAGS	= -DMODULE
 CFLAGS_MODULE   = $(MODFLAGS)
 AFLAGS_MODULE   = $(MODFLAGS)
-LDFLAGS_MODULE  =
+LDFLAGS_MODULE  = -T $(srctree)/scripts/module-common.lds
 CFLAGS_KERNEL	=
 AFLAGS_KERNEL	=
 CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
index b9d6568..75fe1d6 100644
--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -139,6 +139,7 @@ SECTIONS
 		EXIT_TEXT
 		EXIT_DATA
 		*(.exitcall.exit)
+		*(.discard)
 	}
 
 	.mdebug 0 : {
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 6c07797..e256c57 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -82,6 +82,7 @@ SECTIONS
 		EXIT_TEXT
 		EXIT_DATA
 		*(.exitcall.exit)
+		*(.discard)
 		*(.ARM.exidx.exit.text)
 		*(.ARM.extab.exit.text)
 #ifndef CONFIG_MMU
diff --git a/arch/avr32/kernel/vmlinux.lds.S b/arch/avr32/kernel/vmlinux.lds.S
index 7910d41..b832460 100644
--- a/arch/avr32/kernel/vmlinux.lds.S
+++ b/arch/avr32/kernel/vmlinux.lds.S
@@ -131,6 +131,7 @@ SECTIONS
 	/DISCARD/       	: {
 		EXIT_DATA
 		*(.exitcall.exit)
+		*(.discard)
 	}
 
 	DWARF_DEBUG
diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index 6ac307c..6e8eabd 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -280,5 +280,6 @@ SECTIONS
 	/DISCARD/ :
 	{
 		*(.exitcall.exit)
+		*(.discard)
 	}
 }
diff --git a/arch/cris/kernel/vmlinux.lds.S b/arch/cris/kernel/vmlinux.lds.S
index 0d2adfc..a3175eb 100644
--- a/arch/cris/kernel/vmlinux.lds.S
+++ b/arch/cris/kernel/vmlinux.lds.S
@@ -145,6 +145,7 @@ SECTIONS
 		EXIT_TEXT
 		EXIT_DATA
 		*(.exitcall.exit)
+		*(.discard)
         }
 
 	dram_end = dram_start + (CONFIG_ETRAX_DRAM_SIZE - __CONFIG_ETRAX_VMEM_SIZE)*1024*1024;
diff --git a/arch/frv/kernel/vmlinux.lds.S b/arch/frv/kernel/vmlinux.lds.S
index 22d9787..64b5a5e 100644
--- a/arch/frv/kernel/vmlinux.lds.S
+++ b/arch/frv/kernel/vmlinux.lds.S
@@ -177,6 +177,8 @@ SECTIONS
   .debug_ranges		0 : { *(.debug_ranges) }
 
   .comment 0 : { *(.comment) }
+
+  /DISCARD/ : { *(.discard) }
 }
 
 __kernel_image_size_no_bss = __bss_start - __kernel_image_start;
diff --git a/arch/h8300/kernel/vmlinux.lds.S b/arch/h8300/kernel/vmlinux.lds.S
index 43a87b9..03d6c0d 100644
--- a/arch/h8300/kernel/vmlinux.lds.S
+++ b/arch/h8300/kernel/vmlinux.lds.S
@@ -154,6 +154,7 @@ SECTIONS
 	}
 	/DISCARD/ : {
 		*(.exitcall.exit)
+		*(.discard)
 	}
         .romfs :	
 	{
diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
index 4a95e86..13d9589 100644
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -29,6 +29,7 @@ SECTIONS
 	EXIT_TEXT
 	EXIT_DATA
 	*(.exitcall.exit)
+	*(.discard)
 	*(.IA_64.unwind.exit.text)
 	*(.IA_64.unwind_info.exit.text)
 	}
diff --git a/arch/m32r/kernel/vmlinux.lds.S b/arch/m32r/kernel/vmlinux.lds.S
index 4179adf..480a499 100644
--- a/arch/m32r/kernel/vmlinux.lds.S
+++ b/arch/m32r/kernel/vmlinux.lds.S
@@ -125,6 +125,7 @@ SECTIONS
 	EXIT_TEXT
 	EXIT_DATA
 	*(.exitcall.exit)
+	*(.discard)
 	}
 
   /* Stabs debugging sections.  */
diff --git a/arch/m68k/kernel/vmlinux-std.lds b/arch/m68k/kernel/vmlinux-std.lds
index 01d212b..905a797 100644
--- a/arch/m68k/kernel/vmlinux-std.lds
+++ b/arch/m68k/kernel/vmlinux-std.lds
@@ -87,6 +87,7 @@ SECTIONS
 	EXIT_TEXT
 	EXIT_DATA
 	*(.exitcall.exit)
+	*(.discard)
 	}
 
   /* Stabs debugging sections.  */
diff --git a/arch/m68k/kernel/vmlinux-sun3.lds b/arch/m68k/kernel/vmlinux-sun3.lds
index c192f77..47d04be 100644
--- a/arch/m68k/kernel/vmlinux-sun3.lds
+++ b/arch/m68k/kernel/vmlinux-sun3.lds
@@ -82,6 +82,7 @@ __init_begin = .;
 	EXIT_TEXT
 	EXIT_DATA
 	*(.exitcall.exit)
+	*(.discard)
 	}
 
   .crap : {
diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
index b7fe505..68111a6 100644
--- a/arch/m68knommu/kernel/vmlinux.lds.S
+++ b/arch/m68knommu/kernel/vmlinux.lds.S
@@ -188,6 +188,7 @@ SECTIONS {
 		EXIT_TEXT
 		EXIT_DATA
 		*(.exitcall.exit)
+		*(.discard)
 	}
 
 	.bss : {
diff --git a/arch/microblaze/kernel/vmlinux.lds.S b/arch/microblaze/kernel/vmlinux.lds.S
index d34d38d..a207543 100644
--- a/arch/microblaze/kernel/vmlinux.lds.S
+++ b/arch/microblaze/kernel/vmlinux.lds.S
@@ -162,4 +162,6 @@ SECTIONS {
 	}
 	. = ALIGN(4096);
 	_end = .;
+
+	/DISCARD/ : { *(.discard) }
 }
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index 58738c8..4590160 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -179,6 +179,7 @@ SECTIONS
 	/* Sections to be discarded */
 	/DISCARD/ : {
 		*(.exitcall.exit)
+		*(.discard)
 
 		/* ABI crap starts here */
 		*(.MIPS.options)
diff --git a/arch/mn10300/kernel/vmlinux.lds.S b/arch/mn10300/kernel/vmlinux.lds.S
index 24de6b9..5d9f2f9 100644
--- a/arch/mn10300/kernel/vmlinux.lds.S
+++ b/arch/mn10300/kernel/vmlinux.lds.S
@@ -146,6 +146,7 @@ SECTIONS
   /* Sections to be discarded */
   /DISCARD/ : {
 	*(.exitcall.exit)
+	*(.discard)
 	}
 
   STABS_DEBUG
diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index fd2cc4f..ccf5834 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -240,6 +240,7 @@ SECTIONS
 	/* Sections to be discarded */
 	/DISCARD/ : {
 		*(.exitcall.exit)
+		*(.discard)
 #ifdef CONFIG_64BIT
 		/* temporary hack until binutils is fixed to not emit these
 	 	 * for static binaries
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 8ef8a14..7fca935 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -40,6 +40,7 @@ SECTIONS
 	/* Sections to be discarded. */
 	/DISCARD/ : {
 	*(.exitcall.exit)
+	*(.discard)
 	EXIT_DATA
 	}
 
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index a53db23..98867df 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -161,6 +161,7 @@ SECTIONS
 	/DISCARD/ : {
 		EXIT_DATA
 		*(.exitcall.exit)
+		*(.discard)
 	}
 
 	/* Debugging sections.	*/
diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
index f53c76a..766976d 100644
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -171,6 +171,7 @@ SECTIONS
 	 */
 	/DISCARD/ : {
 		*(.exitcall.exit)
+		*(.discard)
 	}
 
 	STABS_DEBUG
diff --git a/arch/sparc/kernel/vmlinux.lds.S b/arch/sparc/kernel/vmlinux.lds.S
index fcbbd00..d63cf91 100644
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -175,6 +175,7 @@ SECTIONS
 		EXIT_TEXT
 		EXIT_DATA
 		*(.exitcall.exit)
+		*(.discard)
 	}
 
 	STABS_DEBUG
diff --git a/arch/um/kernel/dyn.lds.S b/arch/um/kernel/dyn.lds.S
index 9975e1a..2916d6e 100644
--- a/arch/um/kernel/dyn.lds.S
+++ b/arch/um/kernel/dyn.lds.S
@@ -156,4 +156,6 @@ SECTIONS
   STABS_DEBUG
 
   DWARF_DEBUG
+
+  /DISCARD/	: { *(.discard) }
 }
diff --git a/arch/um/kernel/uml.lds.S b/arch/um/kernel/uml.lds.S
index 11b8352..1f8a622 100644
--- a/arch/um/kernel/uml.lds.S
+++ b/arch/um/kernel/uml.lds.S
@@ -100,4 +100,6 @@ SECTIONS
   STABS_DEBUG
 
   DWARF_DEBUG
+
+  /DISCARD/	: { *(.discard) }
 }
diff --git a/arch/xtensa/kernel/vmlinux.lds.S b/arch/xtensa/kernel/vmlinux.lds.S
index 41c159c..b1e2463 100644
--- a/arch/xtensa/kernel/vmlinux.lds.S
+++ b/arch/xtensa/kernel/vmlinux.lds.S
@@ -287,6 +287,7 @@ SECTIONS
 	EXIT_TEXT
 	EXIT_DATA
         *(.exitcall.exit)
+	*(.discard)
   }
 
   .xt.lit : { *(.xt.lit) }
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 55413e5..a19120c 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -628,6 +628,14 @@
 #define INITRAMFS
 #endif
 
+#define DISCARDS							\
+	/DISCARD/ : {							\
+	EXIT_TEXT							\
+	EXIT_DATA							\
+	*(.exitcall.exit)						\
+	*(.discard)							\
+	}
+
 /**
  * PERCPU_VADDR - define output section for percpu area
  * @vaddr: explicit base address (optional)
diff --git a/scripts/module-common.lds b/scripts/module-common.lds
new file mode 100644
index 0000000..47a1f9a
--- /dev/null
+++ b/scripts/module-common.lds
@@ -0,0 +1,8 @@
+/*
+ * Common module linker script, always used when linking a module.
+ * Archs are free to supply their own linker scripts.  ld will
+ * combine them automatically.
+ */
+SECTIONS {
+	/DISCARD/ : { *(.discard) }
+}
-- 
1.6.0.2

