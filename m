Return-Path: <linux-kernel-owner+w=401wt.eu-S1759019AbZCRUhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019AbZCRUhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 16:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbZCRUcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 16:32:03 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:56243 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753998AbZCRUbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 16:31:46 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 16/57] microblaze_v7: vmlinux.lds.S - linker script
Date: Wed, 18 Mar 2009 21:30:43 +0100
Message-Id: <eb4ccc67cf39abc816c8d7653fdc7561d14c1da2.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <69ef4f976d86c870a97fbe4974c242c74acc477d.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
 <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
 <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
 <eaa0169a360a328883ab0eabd2a189c21bad4c30.1237407249.git.monstr@monstr.eu>
 <20227d6f2615060d6560785090513e251cbe2654.1237407249.git.monstr@monstr.eu>
 <69ef4f976d86c870a97fbe4974c242c74acc477d.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/vmlinux.lds.S |  163 ++++++++++++++++++++++++++++++++++
 1 files changed, 163 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/vmlinux.lds.S

diff --git a/arch/microblaze/kernel/vmlinux.lds.S b/arch/microblaze/kernel/vmlinux.lds.S
new file mode 100644
index 0000000..67c0e24
--- /dev/null
+++ b/arch/microblaze/kernel/vmlinux.lds.S
@@ -0,0 +1,163 @@
+/*
+ * Copyright (C) 2008 Michal Simek
+ * Copyright (C) 2008 PetaLogix
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+OUTPUT_FORMAT("elf32-microblaze", "elf32-microblaze", "elf32-microblaze")
+OUTPUT_ARCH(microblaze)
+ENTRY(_start)
+
+#include <asm-generic/vmlinux.lds.h>
+
+jiffies = jiffies_64 + 4;
+
+SECTIONS {
+	. = CONFIG_KERNEL_BASE_ADDR;
+
+	.text : {
+		_text = . ;
+		_stext = . ;
+        	*(.text .text.*)
+		*(.fixup)
+
+		*(.exitcall.exit)
+		SCHED_TEXT
+		LOCK_TEXT
+		KPROBES_TEXT
+		. = ALIGN (4) ;
+		_etext = . ;
+	}
+
+	. = ALIGN (4) ;
+	_fdt_start = . ; /* place for fdt blob */
+	. = . + 0x4000;
+	_fdt_end = . ;
+
+	. = ALIGN(16);
+	RODATA
+	. = ALIGN(16);
+	__ex_table : { 
+		__start___ex_table = .;
+		*(__ex_table) 
+		__stop___ex_table = .;
+	}
+
+	/*
+	 * sdata2 section can go anywhere, but must be word aligned
+	 * and SDA2_BASE must point to the middle of it
+	 */
+	.sdata2 : {
+		_ssrw = .;
+		. = ALIGN(4096); /* page aligned when MMU used - origin 0x8 */
+		*(.sdata2)
+	. = ALIGN(8);
+	_essrw = .;
+	_ssrw_size = _essrw - _ssrw;
+	_KERNEL_SDA2_BASE_ = _ssrw + (_ssrw_size / 2);
+	}
+
+	_sdata = . ;
+	.data ALIGN (4096) : { /* page aligned when MMU used - origin 0x4 */
+        	*(.data)
+	}
+	. = ALIGN(32);
+	.data.cacheline_aligned : { *(.data.cacheline_aligned) }
+	_edata = . ;
+
+	/* Reserve some low RAM for r0 based memory references */
+	. = ALIGN(0x4) ;
+	r0_ram = . ;
+	. = . +  4096;	/* a page should be enough */
+
+	/* The initial task */
+	. = ALIGN(8192);
+	.data.init_task : { *(.data.init_task) }
+
+	/* Under the microblaze ABI, .sdata and .sbss must be contiguous */
+	. = ALIGN(8);
+	.sdata : {
+		_ssro = .;
+		*(.sdata)
+	}
+
+	.sbss :	{
+		_ssbss = .;
+		*(.sbss)
+		_esbss = .;
+		_essro = .;
+		_ssro_size = _essro - _ssro ;
+		_KERNEL_SDA_BASE_ = _ssro + (_ssro_size / 2) ;
+	}
+
+	__init_begin = .;
+
+	. = ALIGN(4096);
+	.init.text : {
+		_sinittext = . ;
+		*(.init.text)
+		*(.exit.text)
+		*(.exit.data)
+		_einittext = .;
+	}
+
+	.init.data : { *(.init.data) }
+
+	. = ALIGN(4);
+	.init.ivt : {
+		__ivt_start = .;
+		*(.init.ivt)
+		__ivt_end = .;
+	}
+
+	.init.setup : {
+		__setup_start = .;
+		*(.init.setup)
+		__setup_end = .;
+	}
+
+	.initcall.init : {
+		__initcall_start = .;
+		INITCALLS
+		__initcall_end = .;
+	}
+
+	.con_initcall.init : {
+		__con_initcall_start = .;
+		*(.con_initcall.init)
+		__con_initcall_end = .;
+	}
+
+	__init_end_before_initramfs = .;
+
+	.init.ramfs ALIGN(4096) : {
+		__initramfs_start = .;
+		*(.init.ramfs)
+		__initramfs_end = .;
+		. = ALIGN(4);
+		LONG(0);
+/*
+ * FIXME this can break initramfs for MMU.
+ * Pad init.ramfs up to page boundary,
+ * so that __init_end == __bss_start. This will make image.elf
+ * consistent with the image.bin
+ */
+		/* . = ALIGN(4096); */
+	}
+	__init_end = .;
+
+	.bss ALIGN (4096) : { /* page aligned when MMU used */
+		__bss_start = . ;
+			*(.bss*)
+			*(COMMON)
+		. = ALIGN (4) ;
+		__bss_stop = . ;
+		_ebss = . ;
+	}
+	. = ALIGN(4096);
+	_end = .;
+}
-- 
1.5.5.1

