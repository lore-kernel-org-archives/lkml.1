Return-Path: <linux-kernel-owner+w=401wt.eu-S1751891AbYB0VCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbYB0VCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758552AbYB0VAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:00:47 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:11750 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758063AbYB0VAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:00:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=kp0/BUb9pO9KsiSIEdHJ1KLfMHtGy7lm9myW4KxcksubiCy30/7WMoQTDIjigkNoNfQOu08mAKvdvNXIE0gaUr8zBh6GJX3XJe0HvUcbV5M8isk0tly3NrYAUZa73qoVvMeYhp12DmkQ/Ff4aWVUhqgvFrqzC97Yw6Y6iHxfcbQ=
Message-Id: <20080227210003.484325295@gmail.com>
References: <20080227205831.150784453@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 27 Feb 2008 23:58:36 +0300
From: gorcunov@gmail.com
To: rth@twiddle.net, chris@zankel.net, jdike@addtoit.com,
       linuxppc-dev@ozlabs.org, paulus@samba.org, dhowells@redhat.com,
       zippel@linux-m68k.org, geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org,
       linux-kernel@vger.kernel.org
Cc: gorcunov@gmail.com, sam@ravnborg.org
Subject: [RFC 05/10] mn10300: vmlinux.lds.S cleanup - use PAGE_SIZE, PERCPU macroses
Content-Disposition: inline; filename=mn10300-vmlinux
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes page.h header into liker script that
allow us to use PAGE_SIZE macro instead of numeric constant

Also PERCPU macro is used instead of explicit section definition

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

WARNING: COMPLETELY UNTESTED !!!

 vmlinux.lds.S |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

Index: linux-2.6.git/arch/mn10300/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.git.orig/arch/mn10300/kernel/vmlinux.lds.S	2008-02-21 22:26:02.000000000 +0300
+++ linux-2.6.git/arch/mn10300/kernel/vmlinux.lds.S	2008-02-27 21:30:34.000000000 +0300
@@ -11,6 +11,7 @@
 #define __VMLINUX_LDS__
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/thread_info.h>
+#include <asm/page.h>
 
 OUTPUT_FORMAT("elf32-am33lin", "elf32-am33lin", "elf32-am33lin")
 OUTPUT_ARCH(mn10300)
@@ -55,13 +56,13 @@ SECTIONS
 	CONSTRUCTORS
 	}
 
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   __nosave_begin = .;
   .data_nosave : { *(.data.nosave) }
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   __nosave_end = .;
 
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   .data.page_aligned : { *(.data.idt) }
 
   . = ALIGN(32);
@@ -78,7 +79,7 @@ SECTIONS
   .data.init_task : { *(.data.init_task) }
 
   /* might get freed after init */
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
   	__smp_locks = .;
 	*(.smp_locks)
@@ -86,7 +87,7 @@ SECTIONS
   }
 
   /* will be freed after init */
-  . = ALIGN(4096);		/* Init code and data */
+  . = ALIGN(PAGE_SIZE);		/* Init code and data */
   __init_begin = .;
   .init.text : {
 	_sinittext = .;
@@ -120,17 +121,14 @@ SECTIONS
   .exit.data : { *(.exit.data) }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   __initramfs_start = .;
   .init.ramfs : { *(.init.ramfs) }
   __initramfs_end = .;
 #endif
 
-  . = ALIGN(32);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
-  . = ALIGN(4096);
+  PERCPU(32)
+  . = ALIGN(PAGE_SIZE);
   __init_end = .;
   /* freed after init ends here */
 
@@ -145,7 +143,7 @@ SECTIONS
   _end = . ;
 
   /* This is where the kernel creates the early boot page tables */
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   pg0 = .;
 
   /* Sections to be discarded */

-- 
