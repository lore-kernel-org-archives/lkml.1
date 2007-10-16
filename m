Return-Path: <linux-kernel-owner+w=401wt.eu-S1765602AbXJPDoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765602AbXJPDoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 23:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765285AbXJPDoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 23:44:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765195AbXJPDoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 23:44:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Cc: Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       linuxppc-dev@ozlabs.org
Subject: [PATCH] powerpc32 vDSO: linker script indentation
X-Shopping-List: (1) Vivacious losers
   (2) Chemical chowder tape
   (3) Anonymous rails
   (4) Flatulent corruption
   (5) Intransigent outrageous bits
Message-Id: <20071016034414.BAB4F4D0389@magilla.localdomain>
Date: Mon, 15 Oct 2007 20:44:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This cleans up the formatting in the vDSO linker script, mostly just the
use of whitespace.  It's intended to approximate the kernel standard
conventions for indenting C, treating elements of the linker script about
like initialized variable definitions.

Signed-off-by: Roland McGrath <roland@redhat.com>
CC: Sam Ravnborg <sam@ravnborg.org>
---
 arch/powerpc/kernel/vdso32/vdso32.lds.S |  219 +++++++++++++++++--------------
 1 files changed, 118 insertions(+), 101 deletions(-)

diff --git a/arch/powerpc/kernel/vdso32/vdso32.lds.S b/arch/powerpc/kernel/vdso32/vdso32.lds.S
index 26e138c..9352ab5 100644
--- a/arch/powerpc/kernel/vdso32/vdso32.lds.S
+++ b/arch/powerpc/kernel/vdso32/vdso32.lds.S
@@ -1,130 +1,147 @@
-
 /*
  * This is the infamous ld script for the 32 bits vdso
  * library
  */
 #include <asm/vdso.h>
 
-/* Default link addresses for the vDSOs */
 OUTPUT_FORMAT("elf32-powerpc", "elf32-powerpc", "elf32-powerpc")
 OUTPUT_ARCH(powerpc:common)
 ENTRY(_start)
 
 SECTIONS
 {
-  . = VDSO32_LBASE + SIZEOF_HEADERS;
-  .hash           : { *(.hash) }			:text
-  .gnu.hash       : { *(.gnu.hash) }
-  .dynsym         : { *(.dynsym) }
-  .dynstr         : { *(.dynstr) }
-  .gnu.version    : { *(.gnu.version) }
-  .gnu.version_d  : { *(.gnu.version_d) }
-  .gnu.version_r  : { *(.gnu.version_r) }
-
-  .note		  : { *(.note.*) } 			:text	:note
-
-  . = ALIGN (16);
-  .text :
-  {
-    *(.text .stub .text.* .gnu.linkonce.t.*)
-  }
-  PROVIDE (__etext = .);
-  PROVIDE (_etext = .);
-  PROVIDE (etext = .);
-
-  . = ALIGN(8);
-  __ftr_fixup : {
-    *(__ftr_fixup)
-  }
+	. = VDSO32_LBASE + SIZEOF_HEADERS;
+
+	.hash          	: { *(.hash) }			:text
+	.gnu.hash      	: { *(.gnu.hash) }
+	.dynsym        	: { *(.dynsym) }
+	.dynstr        	: { *(.dynstr) }
+	.gnu.version   	: { *(.gnu.version) }
+	.gnu.version_d 	: { *(.gnu.version_d) }
+	.gnu.version_r 	: { *(.gnu.version_r) }
+
+	.note		: { *(.note.*) }		:text	:note
+
+	. = ALIGN(16);
+	.text		: {
+		*(.text .stub .text.* .gnu.linkonce.t.*)
+	}
+	PROVIDE(__etext = .);
+	PROVIDE(_etext = .);
+	PROVIDE(etext = .);
+
+	. = ALIGN(8);
+	__ftr_fixup	: { *(__ftr_fixup) }
 
 #ifdef CONFIG_PPC64
-  . = ALIGN(8);
-  __fw_ftr_fixup : {
-    *(__fw_ftr_fixup)
-  }
+	. = ALIGN(8);
+	__fw_ftr_fixup	: { *(__fw_ftr_fixup) }
 #endif
 
-  /* Other stuff is appended to the text segment: */
-  .rodata		: { *(.rodata .rodata.* .gnu.linkonce.r.*) }
-  .rodata1		: { *(.rodata1) }
-
-  .eh_frame_hdr		: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
-  .eh_frame		: { KEEP (*(.eh_frame)) }	:text
-  .gcc_except_table	: { *(.gcc_except_table) }
-  .fixup		: { *(.fixup) }
-
-  .dynamic		: { *(.dynamic) }		:text	:dynamic
-  .got : { *(.got) }
-  .plt : { *(.plt) }
-
-  _end = .;
-  __end = .;
-  PROVIDE (end = .);
-
-
-  /* Stabs debugging sections are here too
-   */
-  .stab 0 : { *(.stab) }
-  .stabstr 0 : { *(.stabstr) }
-  .stab.excl 0 : { *(.stab.excl) }
-  .stab.exclstr 0 : { *(.stab.exclstr) }
-  .stab.index 0 : { *(.stab.index) }
-  .stab.indexstr 0 : { *(.stab.indexstr) }
-  .comment 0 : { *(.comment) }
-  .debug 0 : { *(.debug) }
-  .line 0 : { *(.line) }
-
-  .debug_srcinfo 0 : { *(.debug_srcinfo) }
-  .debug_sfnames 0 : { *(.debug_sfnames) }
-
-  .debug_aranges 0 : { *(.debug_aranges) }
-  .debug_pubnames 0 : { *(.debug_pubnames) }
-
-  .debug_info 0 : { *(.debug_info .gnu.linkonce.wi.*) }
-  .debug_abbrev 0 : { *(.debug_abbrev) }
-  .debug_line 0 : { *(.debug_line) }
-  .debug_frame 0 : { *(.debug_frame) }
-  .debug_str 0 : { *(.debug_str) }
-  .debug_loc 0 : { *(.debug_loc) }
-  .debug_macinfo 0 : { *(.debug_macinfo) }
-
-  .debug_weaknames 0 : { *(.debug_weaknames) }
-  .debug_funcnames 0 : { *(.debug_funcnames) }
-  .debug_typenames 0 : { *(.debug_typenames) }
-  .debug_varnames 0 : { *(.debug_varnames) }
-
-  /DISCARD/ : { *(.note.GNU-stack) }
-  /DISCARD/ : { *(.data .data.* .gnu.linkonce.d.* .sdata*) }
-  /DISCARD/ : { *(.bss .sbss .dynbss .dynsbss) }
+	/*
+	 * Other stuff is appended to the text segment:
+	 */
+	.rodata		: { *(.rodata .rodata.* .gnu.linkonce.r.*) }
+	.rodata1	: { *(.rodata1) }
+
+	.eh_frame_hdr	: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
+	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
+	.gcc_except_table : { *(.gcc_except_table) }
+	.fixup		: { *(.fixup) }
+
+	.dynamic	: { *(.dynamic) }		:text	:dynamic
+	.got		: { *(.got) }
+	.plt		: { *(.plt) }
+
+	_end = .;
+	__end = .;
+	PROVIDE(end = .);
+
+	/*
+	 * Stabs debugging sections are here too.
+	 */
+	.stab 0 : { *(.stab) }
+	.stabstr 0 : { *(.stabstr) }
+	.stab.excl 0 : { *(.stab.excl) }
+	.stab.exclstr 0 : { *(.stab.exclstr) }
+	.stab.index 0 : { *(.stab.index) }
+	.stab.indexstr 0 : { *(.stab.indexstr) }
+	.comment       0 : { *(.comment) }
+
+	/*
+	 * DWARF debug sections.
+	 * Symbols in the DWARF debugging sections are relative to the beginning
+	 * of the section so we begin them at 0.
+	 */
+	/* DWARF 1 */
+	.debug          0 : { *(.debug) }
+	.line           0 : { *(.line) }
+	/* GNU DWARF 1 extensions */
+	.debug_srcinfo  0 : { *(.debug_srcinfo) }
+	.debug_sfnames  0 : { *(.debug_sfnames) }
+	/* DWARF 1.1 and DWARF 2 */
+	.debug_aranges  0 : { *(.debug_aranges) }
+	.debug_pubnames 0 : { *(.debug_pubnames) }
+	/* DWARF 2 */
+	.debug_info     0 : { *(.debug_info .gnu.linkonce.wi.*) }
+	.debug_abbrev   0 : { *(.debug_abbrev) }
+	.debug_line     0 : { *(.debug_line) }
+	.debug_frame    0 : { *(.debug_frame) }
+	.debug_str      0 : { *(.debug_str) }
+	.debug_loc      0 : { *(.debug_loc) }
+	.debug_macinfo  0 : { *(.debug_macinfo) }
+	/* SGI/MIPS DWARF 2 extensions */
+	.debug_weaknames 0 : { *(.debug_weaknames) }
+	.debug_funcnames 0 : { *(.debug_funcnames) }
+	.debug_typenames 0 : { *(.debug_typenames) }
+	.debug_varnames  0 : { *(.debug_varnames) }
+
+	/DISCARD/	: {
+		*(.note.GNU-stack)
+		*(.data .data.* .gnu.linkonce.d.* .sdata*)
+		*(.bss .sbss .dynbss .dynsbss)
+	}
 }
 
+/*
+ * Very old versions of ld do not recognize this name token; use the constant.
+ */
+#define PT_GNU_EH_FRAME	0x6474e550
 
+/*
+ * We must supply the ELF program headers explicitly to get just one
+ * PT_LOAD segment, and set the flags explicitly to make segments read-only.
+ */
 PHDRS
 {
-  text PT_LOAD FILEHDR PHDRS FLAGS(5); /* PF_R|PF_X */
-  note PT_NOTE FLAGS(4); /* PF_R */
-  dynamic PT_DYNAMIC FLAGS(4); /* PF_R */
-  eh_frame_hdr 0x6474e550; /* PT_GNU_EH_FRAME, but ld doesn't match the name */
+	text		PT_LOAD FILEHDR PHDRS FLAGS(5);	/* PF_R|PF_X */
+	dynamic		PT_DYNAMIC FLAGS(4);		/* PF_R */
+	note		PT_NOTE FLAGS(4);		/* PF_R */
+	eh_frame_hdr	PT_GNU_EH_FRAME;
 }
 
-
 /*
  * This controls what symbols we export from the DSO.
  */
 VERSION
 {
-  VDSO_VERSION_STRING {
-    global:
-	__kernel_datapage_offset; /* Has to be there for the kernel to find */
-	__kernel_get_syscall_map;
-	__kernel_gettimeofday;
-	__kernel_clock_gettime;
-	__kernel_clock_getres;
-	__kernel_get_tbfreq;
-	__kernel_sync_dicache;
-	__kernel_sync_dicache_p5;
-	__kernel_sigtramp32;
-	__kernel_sigtramp_rt32;
-    local: *;
-  };
+	VDSO_VERSION_STRING {
+	global:
+		/*
+		 * Has to be there for the kernel to find
+		 */
+		__kernel_datapage_offset;
+
+		__kernel_get_syscall_map;
+		__kernel_gettimeofday;
+		__kernel_clock_gettime;
+		__kernel_clock_getres;
+		__kernel_get_tbfreq;
+		__kernel_sync_dicache;
+		__kernel_sync_dicache_p5;
+		__kernel_sigtramp32;
+		__kernel_sigtramp_rt32;
+
+	local: *;
+	};
 }
