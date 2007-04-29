Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114AbXD2LCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbXD2LCv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756343AbXD2LBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:01:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51240 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130AbXD2KxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:02 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Ralf Baechle <ralf@linux-mips.org>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [13/48] x86_64: fix ia32_binfmt.c build error
Message-Id: <20070429105301.7B2A1151CA@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Ralf Baechle <ralf@linux-mips.org>

Reorder code to avoid multiple inclusion of elf.h.

#undef several symbols to avoid build errors over redefinitions.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/ia32/ia32_binfmt.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux/arch/x86_64/ia32/ia32_binfmt.c
===================================================================
--- linux.orig/arch/x86_64/ia32/ia32_binfmt.c
+++ linux/arch/x86_64/ia32/ia32_binfmt.c
@@ -5,6 +5,11 @@
  * This tricks binfmt_elf.c into loading 32bit binaries using lots 
  * of ugly preprocessor tricks. Talk about very very poor man's inheritance.
  */ 
+#define __ASM_X86_64_ELF_H 1
+
+#undef ELF_CLASS
+#define ELF_CLASS ELFCLASS32
+
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/rwsem.h>
@@ -50,9 +55,6 @@ struct elf_phdr; 
 #undef ELF_ARCH
 #define ELF_ARCH EM_386
 
-#undef ELF_CLASS
-#define ELF_CLASS ELFCLASS32
-
 #define ELF_DATA	ELFDATA2LSB
 
 #define USE_ELF_CORE_DUMP 1
@@ -136,7 +138,7 @@ struct elf_prpsinfo
 
 #define user user32
 
-#define __ASM_X86_64_ELF_H 1
+#undef elf_read_implies_exec
 #define elf_read_implies_exec(ex, executable_stack)     (executable_stack != EXSTACK_DISABLE_X)
 //#include <asm/ia32.h>
 #include <linux/elf.h>
