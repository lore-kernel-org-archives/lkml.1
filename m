Return-Path: <linux-kernel-owner+w=401wt.eu-S932600AbYGQTY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600AbYGQTY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932310AbYGQTWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:22:50 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:53926 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759064AbYGQTWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:22:44 -0400
Message-Id: <20080717191750.535418653@mail.of.borg>
References: <20080717191607.955742542@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 21:16:11 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 04/29] m68k: vmlinux-std/sun3.lds.S cleanup - use PAGE_SIZE macro
Content-Disposition: inline; filename=m68k-vmlinux-std_sun3.lds.S_cleanup_use_PAGE_SIZE_macro.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch includes page.h header into linker script that
allow us to use PAGE_SIZE macro instead of numeric constant

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/kernel/vmlinux-std.lds  |    3 ++-
 arch/m68k/kernel/vmlinux-sun3.lds |    7 ++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/arch/m68k/kernel/vmlinux-std.lds
+++ b/arch/m68k/kernel/vmlinux-std.lds
@@ -1,6 +1,7 @@
 /* ld script to make m68k Linux kernel */
 
 #include <asm-generic/vmlinux.lds.h>
+#include <asm/page.h>
 
 OUTPUT_FORMAT("elf32-m68k", "elf32-m68k", "elf32-m68k")
 OUTPUT_ARCH(m68k)
@@ -41,7 +42,7 @@ SECTIONS
   _edata = .;			/* End of data section */
 
   /* will be freed after init */
-  . = ALIGN(4096);		/* Init code and data */
+  . = ALIGN(PAGE_SIZE);		/* Init code and data */
   __init_begin = .;
   .init.text : {
 	_sinittext = .;
--- a/arch/m68k/kernel/vmlinux-sun3.lds
+++ b/arch/m68k/kernel/vmlinux-sun3.lds
@@ -1,6 +1,7 @@
 /* ld script to make m68k Linux kernel */
 
 #include <asm-generic/vmlinux.lds.h>
+#include <asm/page.h>
 
 OUTPUT_FORMAT("elf32-m68k", "elf32-m68k", "elf32-m68k")
 OUTPUT_ARCH(m68k)
@@ -34,7 +35,7 @@ SECTIONS
   _edata = .;
 
   /* will be freed after init */
-  . = ALIGN(8192);	/* Init code and data */
+  . = ALIGN(PAGE_SIZE);	/* Init code and data */
 __init_begin = .;
 	.init.text : {
 		_sinittext = .;
@@ -61,12 +62,12 @@ __init_begin = .;
 	}
 	SECURITY_INIT
 #ifdef CONFIG_BLK_DEV_INITRD
-	. = ALIGN(8192);
+	. = ALIGN(PAGE_SIZE);
 	__initramfs_start = .;
 	.init.ramfs : { *(.init.ramfs) }
 	__initramfs_end = .;
 #endif
-	. = ALIGN(8192);
+	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
 	.data.init.task : { *(.data.init_task) }
 

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

