Return-Path: <linux-kernel-owner+w=401wt.eu-S1758845AbYB0VDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbYB0VDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758806AbYB0VAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:00:54 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:12213 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757878AbYB0VAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:00:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=gT8wyJSwh2zxEs0pzTj5voXmwnLPu54uYq9gbYAX0uaemJkCidTfGHCYa7RzsdOy+Qv9ieU2RDu+WC5mymgI4phulVLaNJVt/4PgBRKnSKc7cg0O5iZbhumLH7mcpfG6PoR+y9MciPAT84KbReL4DCIG2tX5CUQuTTMQG1NxP44=
Message-Id: <20080227210004.189002678@gmail.com>
References: <20080227205831.150784453@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 27 Feb 2008 23:58:39 +0300
From: gorcunov@gmail.com
To: rth@twiddle.net, chris@zankel.net, jdike@addtoit.com,
       linuxppc-dev@ozlabs.org, paulus@samba.org, dhowells@redhat.com,
       zippel@linux-m68k.org, geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org,
       linux-kernel@vger.kernel.org
Cc: gorcunov@gmail.com, sam@ravnborg.org
Subject: [RFC 08/10] um: dyn/uml.lds.S cleanup - use PAGE_SIZE macro
Content-Disposition: inline; filename=um-vmlinux
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes page.h header into liker scripts that
allow us to use PAGE_SIZE macro instead of numeric constant.

To be able to include page.h into linker scripts page.h is
needed for some modification - i.e. we need to use __ASSEMBLY__
and _AC macro

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

WARNING: COMPLETELY UNTESTED !!!

 arch/um/kernel/dyn.lds.S |    7 ++++---
 arch/um/kernel/uml.lds.S |    7 ++++---
 include/asm-um/page.h    |   17 +++++++++++------
 3 files changed, 19 insertions(+), 12 deletions(-)

Index: linux-2.6.git/arch/um/kernel/dyn.lds.S
===================================================================
--- linux-2.6.git.orig/arch/um/kernel/dyn.lds.S	2008-01-29 18:03:46.000000000 +0300
+++ linux-2.6.git/arch/um/kernel/dyn.lds.S	2008-02-27 21:38:48.000000000 +0300
@@ -1,4 +1,5 @@
 #include <asm-generic/vmlinux.lds.h>
+#include <asm/page.h>
 
 OUTPUT_FORMAT(ELF_FORMAT)
 OUTPUT_ARCH(ELF_ARCH)
@@ -21,7 +22,7 @@ SECTIONS
 	_einittext = .;
   }
 
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
 
   /* Read-only sections, merged into text segment: */
   .hash           : { *(.hash) }
@@ -68,9 +69,9 @@ SECTIONS
     /* .gnu.warning sections are handled specially by elf32.em.  */
     *(.gnu.warning)
 
-    . = ALIGN(4096);
+    . = ALIGN(PAGE_SIZE);
   } =0x90909090
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   .syscall_stub : {
 	__syscall_stub_start = .;
 	*(.__syscall_stub*)
Index: linux-2.6.git/arch/um/kernel/uml.lds.S
===================================================================
--- linux-2.6.git.orig/arch/um/kernel/uml.lds.S	2008-01-29 18:03:46.000000000 +0300
+++ linux-2.6.git/arch/um/kernel/uml.lds.S	2008-02-27 21:38:53.000000000 +0300
@@ -1,4 +1,5 @@
 #include <asm-generic/vmlinux.lds.h>
+#include <asm/page.h>
 
 OUTPUT_FORMAT(ELF_FORMAT)
 OUTPUT_ARCH(ELF_ARCH)
@@ -26,7 +27,7 @@ SECTIONS
 	INIT_TEXT
 	_einittext = .;
   }
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
 
   .text      :
   {
@@ -39,7 +40,7 @@ SECTIONS
     *(.gnu.linkonce.t*)
   }
 
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   .syscall_stub : {
 	__syscall_stub_start = .;
 	*(.__syscall_stub*)
@@ -79,7 +80,7 @@ SECTIONS
   .sdata     : { *(.sdata) }
   _edata  =  .;
   PROVIDE (edata = .);
-  . = ALIGN(0x1000);
+  . = ALIGN(PAGE_SIZE);
   .sbss      :
   {
    __bss_start = .;
Index: linux-2.6.git/include/asm-um/page.h
===================================================================
--- linux-2.6.git.orig/include/asm-um/page.h	2008-02-09 12:09:29.000000000 +0300
+++ linux-2.6.git/include/asm-um/page.h	2008-02-27 21:42:17.000000000 +0300
@@ -7,16 +7,20 @@
 #ifndef __UM_PAGE_H
 #define __UM_PAGE_H
 
-struct page;
-
-#include <linux/types.h>
-#include <asm/vm-flags.h>
+#include <linux/const.h>
 
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	12
-#define PAGE_SIZE	(1UL << PAGE_SHIFT)
+#define PAGE_SIZE	(_AC(1, UL) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
+#ifndef __ASSEMBLY__
+
+struct page;
+
+#include <linux/types.h>
+#include <asm/vm-flags.h>
+
 /*
  * These are used to make use of C type-checking..
  */
@@ -120,4 +124,5 @@ extern struct page *arch_validate(struct
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
-#endif
+#endif	/* __ASSEMBLY__ */
+#endif	/* __UM_PAGE_H */

-- 
