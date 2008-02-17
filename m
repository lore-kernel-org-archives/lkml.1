Return-Path: <linux-kernel-owner+w=401wt.eu-S1758914AbYBQPVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914AbYBQPVA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 10:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756791AbYBQPT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 10:19:59 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:31570 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038AbYBQPT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 10:19:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=eVXnG4Kn8950lfUnr5NtaNZaQkzmoy7tI95esIbR4al29gKbAQI5odv/LPeMbfSUOM1UyOWKM8SFekXEnK/WLd1ax3Yw4THDBLHsncKcjc96sGeK0Ecpq9m1wKO1e9m6PlPZTgYwChKB8pHBZKNO7IwINyk2xi/g4XClpcU3OrA=
Message-Id: <20080217151924.985325396@gmail.com>
References: <20080217151716.274134094@gmail.com>
User-Agent: quilt/0.46-1
Date: Sun, 17 Feb 2008 18:17:17 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: ak@suse.de, mingo@elte.hu, sam@ravnborg.org, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 1/2] x86: lds - Use PAGE_SIZE instead of numeric constant
Content-Disposition: inline; filename=ps-x86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's much better to use PAGE_SIZE then magic 4096
(though it's almost synonym in most cases on x86 but
not for *all* cases ;)

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/vmlinux_64.lds.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/vmlinux_64.lds.S	2008-02-09 22:27:13.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/vmlinux_64.lds.S	2008-02-17 18:08:57.000000000 +0300
@@ -37,7 +37,7 @@ SECTIONS
 	KPROBES_TEXT
 	*(.fixup)
 	*(.gnu.warning)
-	_etext = .;			/* End of text section */
+	_etext = .;		/* End of text section */
   } :text = 0x9090
 
   . = ALIGN(16);		/* Exception table */
@@ -60,7 +60,7 @@ SECTIONS
   	__tracedata_end = .;
   }
 
-  . = ALIGN(PAGE_SIZE);        /* Align data segment to page size boundary */
+  . = ALIGN(PAGE_SIZE);		/* Align data segment to page size boundary */
 				/* Data */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
 	DATA_DATA
@@ -119,7 +119,7 @@ SECTIONS
   .vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3))
 		{ *(.vsyscall_3) }
 
-  . = VSYSCALL_VIRT_ADDR + 4096;
+  . = VSYSCALL_VIRT_ADDR + PAGE_SIZE;
 
 #undef VSYSCALL_ADDR
 #undef VSYSCALL_PHYS_ADDR
@@ -134,23 +134,23 @@ SECTIONS
 	*(.data.init_task)
   }:data.init
 
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
 	*(.data.page_aligned)
   }
 
   /* might get freed after init */
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   __smp_alt_begin = .;
   __smp_locks = .;
   .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
 	*(.smp_locks)
   }
   __smp_locks_end = .;
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   __smp_alt_end = .;
 
-  . = ALIGN(4096);		/* Init code and data */
+  . = ALIGN(PAGE_SIZE);		/* Init code and data */
   __init_begin = .;
   .init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
 	_sinittext = .;
@@ -191,7 +191,7 @@ SECTIONS
   .altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
 	*(.altinstructions)
   }
-  __alt_instructions_end = .; 
+  __alt_instructions_end = .;
   .altinstr_replacement : AT(ADDR(.altinstr_replacement) - LOAD_OFFSET) {
 	*(.altinstr_replacement)
   }
@@ -207,25 +207,25 @@ SECTIONS
 /* vdso blob that is mapped into user space */
   vdso_start = . ;
   .vdso  : AT(ADDR(.vdso) - LOAD_OFFSET) { *(.vdso) }
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   vdso_end = .;
 
 #ifdef CONFIG_BLK_DEV_INITRD
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   __initramfs_start = .;
   .init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) { *(.init.ramfs) }
   __initramfs_end = .;
 #endif
 
-  PERCPU(4096)
+  PERCPU(PAGE_SIZE)
 
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   __init_end = .;
 
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   __nosave_begin = .;
   .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) { *(.data.nosave) }
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   __nosave_end = .;
 
   __bss_start = .;		/* BSS */
Index: linux-2.6.git/arch/x86/kernel/vmlinux_32.lds.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/vmlinux_32.lds.S	2008-02-09 22:27:13.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/vmlinux_32.lds.S	2008-02-16 16:34:36.000000000 +0300
@@ -38,7 +38,7 @@ SECTIONS
 
   /* read-only */
   .text : AT(ADDR(.text) - LOAD_OFFSET) {
-	. = ALIGN(4096); /* not really needed, already page aligned */
+	. = ALIGN(PAGE_SIZE); /* not really needed, already page aligned */
 	*(.text.page_aligned)
 	TEXT_TEXT
 	SCHED_TEXT
@@ -70,21 +70,21 @@ SECTIONS
   RODATA
 
   /* writeable */
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   .data : AT(ADDR(.data) - LOAD_OFFSET) {	/* Data */
 	DATA_DATA
 	CONSTRUCTORS
 	} :data
 
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
   	__nosave_begin = .;
 	*(.data.nosave)
-  	. = ALIGN(4096);
+  	. = ALIGN(PAGE_SIZE);
   	__nosave_end = .;
   }
 
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
 	*(.data.page_aligned)
 	*(.data.idt)
@@ -108,7 +108,7 @@ SECTIONS
   }
 
   /* might get freed after init */
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
   	__smp_locks = .;
 	*(.smp_locks)
@@ -120,10 +120,10 @@ SECTIONS
    * after boot. Always make sure that ALIGN() directive is present after
    * the section which contains __smp_alt_end.
    */
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
 
   /* will be freed after init */
-  . = ALIGN(4096);		/* Init code and data */
+  . = ALIGN(PAGE_SIZE);		/* Init code and data */
   .init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
   	__init_begin = .;
 	_sinittext = .;
@@ -174,23 +174,23 @@ SECTIONS
 	EXIT_DATA
   }
 #if defined(CONFIG_BLK_DEV_INITRD)
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   .init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
 	__initramfs_start = .;
 	*(.init.ramfs)
 	__initramfs_end = .;
   }
 #endif
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
 	__per_cpu_start = .;
 	*(.data.percpu)
 	*(.data.percpu.shared_aligned)
 	__per_cpu_end = .;
   }
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   /* freed after init ends here */
-	
+
   .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
 	__init_end = .;
 	__bss_start = .;		/* BSS */
@@ -200,7 +200,7 @@ SECTIONS
 	__bss_stop = .;
   	_end = . ;
 	/* This is where the kernel creates the early boot page tables */
-	. = ALIGN(4096);
+	. = ALIGN(PAGE_SIZE);
 	pg0 = . ;
   }
 

-- 
