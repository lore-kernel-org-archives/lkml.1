Return-Path: <linux-kernel-owner+w=401wt.eu-S1764429AbXJPDmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764429AbXJPDmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 23:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757372AbXJPDmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 23:42:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758456AbXJPDmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 23:42:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH] SH vDSO: linker script indentation
X-Shopping-List: (1) Hypothetical Arctic carrion
   (2) Skeptical grief
   (3) Asymmetrical salads
   (4) Luminous destroyer fads
Message-Id: <20071016034202.108754D0389@magilla.localdomain>
Date: Mon, 15 Oct 2007 20:42:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This cleans up the formatting in the vDSO linker script, mostly just the
use of whitespace.  It's intended to approximate the kernel standard
conventions for indenting C, treating elements of the linker script about
like initialized variable definitions.

Signed-off-by: Roland McGrath <roland@redhat.com>
CC: Sam Ravnborg <sam@ravnborg.org>
---
 arch/sh/kernel/vsyscall/vsyscall.lds.S |   77 +++++++++++++++++--------------
 1 files changed, 42 insertions(+), 35 deletions(-)

diff --git a/arch/sh/kernel/vsyscall/vsyscall.lds.S b/arch/sh/kernel/vsyscall/vsyscall.lds.S
index b13c3d4..c9bf2af 100644
--- a/arch/sh/kernel/vsyscall/vsyscall.lds.S
+++ b/arch/sh/kernel/vsyscall/vsyscall.lds.S
@@ -17,45 +17,52 @@ ENTRY(__kernel_vsyscall);
 
 SECTIONS
 {
-  . = SIZEOF_HEADERS;
+	. = SIZEOF_HEADERS;
 
-  .hash           : { *(.hash) }		:text
-  .gnu.hash       : { *(.gnu.hash) }
-  .dynsym         : { *(.dynsym) }
-  .dynstr         : { *(.dynstr) }
-  .gnu.version    : { *(.gnu.version) }
-  .gnu.version_d  : { *(.gnu.version_d) }
-  .gnu.version_r  : { *(.gnu.version_r) }
+	.hash		: { *(.hash) }			:text
+	.gnu.hash	: { *(.gnu.hash) }
+	.dynsym		: { *(.dynsym) }
+	.dynstr		: { *(.dynstr) }
+	.gnu.version	: { *(.gnu.version) }
+	.gnu.version_d	: { *(.gnu.version_d) }
+	.gnu.version_r	: { *(.gnu.version_r) }
 
-  /* This linker script is used both with -r and with -shared.
-     For the layouts to match, we need to skip more than enough
-     space for the dynamic symbol table et al.  If this amount
-     is insufficient, ld -shared will barf.  Just increase it here.  */
-  . = 0x400;
+	/*
+	 * This linker script is used both with -r and with -shared.
+	 * For the layouts to match, we need to skip more than enough
+	 * space for the dynamic symbol table et al.  If this amount
+	 * is insufficient, ld -shared will barf.  Just increase it here.
+	 */
+	. = 0x400;
 
-  .text           : { *(.text) }		:text =0x90909090
-  .note		  : { *(.note.*) }		:text :note
-  .eh_frame_hdr   : { *(.eh_frame_hdr) }	:text :eh_frame_hdr
-  .eh_frame       : { KEEP (*(.eh_frame)) }	:text
-  .dynamic        : { *(.dynamic) }		:text :dynamic
-  .useless        : {
-  	*(.got.plt) *(.got)
-	*(.data .data.* .gnu.linkonce.d.*)
-	*(.dynbss)
-	*(.bss .bss.* .gnu.linkonce.b.*)
-  }						:text
+	.text		: { *(.text) } 			:text	=0x90909090
+	.note		: { *(.note.*) }		:text	:note
+	.eh_frame_hdr	: { *(.eh_frame_hdr ) }		:text	:eh_frame_hdr
+	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
+	.dynamic	: { *(.dynamic) }		:text	:dynamic
+	.useless	: {
+	      *(.got.plt) *(.got)
+	      *(.data .data.* .gnu.linkonce.d.*)
+	      *(.dynbss)
+	      *(.bss .bss.* .gnu.linkonce.b.*)
+	}						:text
 }
 
 /*
+ * Very old versions of ld do not recognize this name token; use the constant.
+ */
+#define PT_GNU_EH_FRAME	0x6474e550
+
+/*
  * We must supply the ELF program headers explicitly to get just one
  * PT_LOAD segment, and set the flags explicitly to make segments read-only.
  */
 PHDRS
 {
-  text PT_LOAD FILEHDR PHDRS FLAGS(5); /* PF_R|PF_X */
-  dynamic PT_DYNAMIC FLAGS(4); /* PF_R */
-  note PT_NOTE FLAGS(4); /* PF_R */
-  eh_frame_hdr 0x6474e550; /* PT_GNU_EH_FRAME, but ld doesn't match the name */
+	text		PT_LOAD FILEHDR PHDRS FLAGS(5);	/* PF_R|PF_X */
+	dynamic		PT_DYNAMIC FLAGS(4);		/* PF_R */
+	note		PT_NOTE FLAGS(4);		/* PF_R */
+	eh_frame_hdr	PT_GNU_EH_FRAME;
 }
 
 /*
@@ -63,12 +70,12 @@ PHDRS
  */
 VERSION
 {
-  LINUX_2.6 {
-    global:
-    	__kernel_vsyscall;
-    	__kernel_sigreturn;
-    	__kernel_rt_sigreturn;
+	LINUX_2.6 {
+	global:
+		__kernel_vsyscall;
+		__kernel_sigreturn;
+		__kernel_rt_sigreturn;
 
-    local: *;
-  };
+	local: *;
+	};
 }
