Return-Path: <linux-kernel-owner+w=401wt.eu-S1765224AbXJPDoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765224AbXJPDoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 23:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757836AbXJPDoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 23:44:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758124AbXJPDoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 23:44:09 -0400
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
Subject: [PATCH] powerpc64 vDSO: linker script indentation
X-Shopping-List: (1) Braille L'eggs Stones
   (2) Intergalactic Poppin-Fresh wavechord lesions
   (3) Imperious holidays
   (4) Dexterous aspersions
   (5) Petrified detention
Message-Id: <20071016034333.19BEE4D0389@magilla.localdomain>
Date: Mon, 15 Oct 2007 20:43:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This cleans up the formatting in the vDSO linker script, mostly just the
use of whitespace.  It's intended to approximate the kernel standard
conventions for indenting C, treating elements of the linker script about
like initialized variable definitions.

Signed-off-by: Roland McGrath <roland@redhat.com>
CC: Sam Ravnborg <sam@ravnborg.org>
---
 arch/powerpc/kernel/vdso64/vdso64.lds.S |  225 +++++++++++++++++--------------
 1 files changed, 122 insertions(+), 103 deletions(-)

diff --git a/arch/powerpc/kernel/vdso64/vdso64.lds.S b/arch/powerpc/kernel/vdso64/vdso64.lds.S
index 2d70f35..932b3fd 100644
--- a/arch/powerpc/kernel/vdso64/vdso64.lds.S
+++ b/arch/powerpc/kernel/vdso64/vdso64.lds.S
@@ -10,100 +10,114 @@ ENTRY(_start)
 
 SECTIONS
 {
-  . = VDSO64_LBASE + SIZEOF_HEADERS;
-  .hash           : { *(.hash) }		:text
-  .gnu.hash       : { *(.gnu.hash) }
-  .dynsym         : { *(.dynsym) }
-  .dynstr         : { *(.dynstr) }
-  .gnu.version    : { *(.gnu.version) }
-  .gnu.version_d  : { *(.gnu.version_d) }
-  .gnu.version_r  : { *(.gnu.version_r) }
-
-  .note		  : { *(.note.*) }		:text	:note
-
-  . = ALIGN (16);
-  .text           :
-  {
-    *(.text .stub .text.* .gnu.linkonce.t.*)
-    *(.sfpr .glink)
-  }						:text
-  PROVIDE (__etext = .);
-  PROVIDE (_etext = .);
-  PROVIDE (etext = .);
-
-  . = ALIGN(8);
-  __ftr_fixup : {
-    *(__ftr_fixup)
-  }
-
-  . = ALIGN(8);
-  __fw_ftr_fixup : {
-    *(__fw_ftr_fixup)
-  }
-
-  /* Other stuff is appended to the text segment: */
-  .rodata         : { *(.rodata .rodata.* .gnu.linkonce.r.*) }
-  .rodata1        : { *(.rodata1) }
-  .eh_frame_hdr   : { *(.eh_frame_hdr) }	:text	:eh_frame_hdr
-  .eh_frame       : { KEEP (*(.eh_frame)) }	:text
-  .gcc_except_table   : { *(.gcc_except_table) }
-
-  .opd           ALIGN(8) : { KEEP (*(.opd)) }
-  .got		 ALIGN(8) : { *(.got .toc) }
-  .rela.dyn	 ALIGN(8) : { *(.rela.dyn) }
-
-  .dynamic        : { *(.dynamic) }		:text	:dynamic
-
-  _end = .;
-  PROVIDE (end = .);
-
-  /* Stabs debugging sections are here too
-   */
-  .stab          0 : { *(.stab) }
-  .stabstr       0 : { *(.stabstr) }
-  .stab.excl     0 : { *(.stab.excl) }
-  .stab.exclstr  0 : { *(.stab.exclstr) }
-  .stab.index    0 : { *(.stab.index) }
-  .stab.indexstr 0 : { *(.stab.indexstr) }
-  .comment       0 : { *(.comment) }
-  /* DWARF debug sectio/ns.
-     Symbols in the DWARF debugging sections are relative to the beginning
-     of the section so we begin them at 0.  */
-  /* DWARF 1 */
-  .debug          0 : { *(.debug) }
-  .line           0 : { *(.line) }
-  /* GNU DWARF 1 extensions */
-  .debug_srcinfo  0 : { *(.debug_srcinfo) }
-  .debug_sfnames  0 : { *(.debug_sfnames) }
-  /* DWARF 1.1 and DWARF 2 */
-  .debug_aranges  0 : { *(.debug_aranges) }
-  .debug_pubnames 0 : { *(.debug_pubnames) }
-  /* DWARF 2 */
-  .debug_info     0 : { *(.debug_info .gnu.linkonce.wi.*) }
-  .debug_abbrev   0 : { *(.debug_abbrev) }
-  .debug_line     0 : { *(.debug_line) }
-  .debug_frame    0 : { *(.debug_frame) }
-  .debug_str      0 : { *(.debug_str) }
-  .debug_loc      0 : { *(.debug_loc) }
-  .debug_macinfo  0 : { *(.debug_macinfo) }
-  /* SGI/MIPS DWARF 2 extensions */
-  .debug_weaknames 0 : { *(.debug_weaknames) }
-  .debug_funcnames 0 : { *(.debug_funcnames) }
-  .debug_typenames 0 : { *(.debug_typenames) }
-  .debug_varnames  0 : { *(.debug_varnames) }
-
-  /DISCARD/ : { *(.note.GNU-stack) }
-  /DISCARD/ : { *(.branch_lt) }
-  /DISCARD/ : { *(.data .data.* .gnu.linkonce.d.*) }
-  /DISCARD/ : { *(.bss .sbss .dynbss .dynsbss) }
+	. = VDSO64_LBASE + SIZEOF_HEADERS;
+
+	.hash		: { *(.hash) }			:text
+	.gnu.hash	: { *(.gnu.hash) }
+	.dynsym		: { *(.dynsym) }
+	.dynstr		: { *(.dynstr) }
+	.gnu.version	: { *(.gnu.version) }
+	.gnu.version_d	: { *(.gnu.version_d) }
+	.gnu.version_r	: { *(.gnu.version_r) }
+
+	.note		: { *(.note.*) }		:text	:note
+
+	. = ALIGN(16);
+	.text		: {
+		*(.text .stub .text.* .gnu.linkonce.t.*)
+		*(.sfpr .glink)
+	}						:text
+	PROVIDE(__etext = .);
+	PROVIDE(_etext = .);
+	PROVIDE(etext = .);
+
+	. = ALIGN(8);
+	__ftr_fixup	: { *(__ftr_fixup) }
+
+	. = ALIGN(8);
+	__fw_ftr_fixup	: { *(__fw_ftr_fixup) }
+
+	/*
+	 * Other stuff is appended to the text segment:
+	 */
+	.rodata		: { *(.rodata .rodata.* .gnu.linkonce.r.*) }
+	.rodata1	: { *(.rodata1) }
+
+	.eh_frame_hdr	: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
+	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
+	.gcc_except_table : { *(.gcc_except_table) }
+
+	.opd ALIGN(8)	: { KEEP (*(.opd)) }
+	.got ALIGN(8)	: { *(.got .toc) }
+	.rela.dyn ALIGN(8) : { *(.rela.dyn) }
+
+	.dynamic	: { *(.dynamic) }		:text	:dynamic
+
+	_end = .;
+	PROVIDE(end = .);
+
+	/*
+	 * Stabs debugging sections are here too.
+	 */
+	.stab          0 : { *(.stab) }
+	.stabstr       0 : { *(.stabstr) }
+	.stab.excl     0 : { *(.stab.excl) }
+	.stab.exclstr  0 : { *(.stab.exclstr) }
+	.stab.index    0 : { *(.stab.index) }
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
+		*(.branch_lt)
+		*(.data .data.* .gnu.linkonce.d.* .sdata*)
+		*(.bss .sbss .dynbss .dynsbss)
+	}
 }
 
+/*
+ * Very old versions of ld do not recognize this name token; use the constant.
+ */
+#define PT_GNU_EH_FRAME	0x6474e550
+
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
 
 /*
@@ -111,17 +125,22 @@ PHDRS
  */
 VERSION
 {
-  VDSO_VERSION_STRING {
-    global:
-	__kernel_datapage_offset; /* Has to be there for the kernel to find */
-	__kernel_get_syscall_map;
-    	__kernel_gettimeofday;
-	__kernel_clock_gettime;
-	__kernel_clock_getres;
-	__kernel_get_tbfreq;
-	__kernel_sync_dicache;
-	__kernel_sync_dicache_p5;
-	__kernel_sigtramp_rt64;
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
+		__kernel_sigtramp_rt64;
+
+	local: *;
+	};
 }
