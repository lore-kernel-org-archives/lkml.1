Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbXEXUJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbXEXUJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbXEXUJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:09:41 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41450 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbXEXUJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:09:39 -0400
Date: Thu, 24 May 2007 22:10:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       sparclinux@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] sparc64: ident vmlinux.lds.S
Message-ID: <20070524201038.GC1109@uranus.ravnborg.org>
References: <20070524200440.GA1109@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524200440.GA1109@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This introduce a style similar to C code.
No functional changes.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/sparc64/kernel/vmlinux.lds.S |  239 ++++++++++++++++++++++---------------
 1 files changed, 142 insertions(+), 97 deletions(-)

diff --git a/arch/sparc64/kernel/vmlinux.lds.S b/arch/sparc64/kernel/vmlinux.lds.S
index fb648de..6f924fd 100644
--- a/arch/sparc64/kernel/vmlinux.lds.S
+++ b/arch/sparc64/kernel/vmlinux.lds.S
@@ -9,105 +9,150 @@ ENTRY(_start)
 jiffies = jiffies_64;
 SECTIONS
 {
-  swapper_low_pmd_dir = 0x0000000000402000;
-  . = 0x4000;
-  .text 0x0000000000404000 :
-  {
-    _text = .;
-    TEXT_TEXT
-    SCHED_TEXT
-    LOCK_TEXT
-    KPROBES_TEXT
-    *(.gnu.warning)
-  } =0
-  _etext = .;
-  PROVIDE (etext = .);
-
-  RODATA
-
-  .data    :
-  {
-    DATA_DATA
-    CONSTRUCTORS
-  }
-  .data1   : { *(.data1) }
-  . = ALIGN(64);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
-  . = ALIGN(64);
-  .data.read_mostly : { *(.data.read_mostly) }
-  _edata  =  .;
-  PROVIDE (edata = .);
-  .fixup   : { *(.fixup) }
-
-  . = ALIGN(16);
-  __start___ex_table = .;
-  __ex_table : { *(__ex_table) }
-  __stop___ex_table = .;
-
-  . = ALIGN(8192);
-  __init_begin = .;
-  .init.text : { 
-	_sinittext = .;
-	*(.init.text)
-	_einittext = .;
-  }
-  .init.data : { *(.init.data) }
-  . = ALIGN(16);
-  __setup_start = .;
-  .init.setup : { *(.init.setup) }
-  __setup_end = .;
-  __initcall_start = .;
-  .initcall.init : {
-	INITCALLS
-  }
-  __initcall_end = .;
-  __con_initcall_start = .;
-  .con_initcall.init : { *(.con_initcall.init) }
-  __con_initcall_end = .;
-  SECURITY_INIT
-  . = ALIGN(4);
-  __tsb_ldquad_phys_patch = .;
-  .tsb_ldquad_phys_patch : { *(.tsb_ldquad_phys_patch) }
-  __tsb_ldquad_phys_patch_end = .;
-  __tsb_phys_patch = .;
-  .tsb_phys_patch : { *(.tsb_phys_patch) }
-  __tsb_phys_patch_end = .;
-  __cpuid_patch = .;
-  .cpuid_patch : { *(.cpuid_patch) }
-  __cpuid_patch_end = .;
-  __sun4v_1insn_patch = .;
-  .sun4v_1insn_patch : { *(.sun4v_1insn_patch) }
-  __sun4v_1insn_patch_end = .;
-  __sun4v_2insn_patch = .;
-  .sun4v_2insn_patch : { *(.sun4v_2insn_patch) }
-  __sun4v_2insn_patch_end = .;
+	swapper_low_pmd_dir = 0x0000000000402000;
+	. = 0x4000;
+	.text 0x0000000000404000 : {
+		_text = .;
+		TEXT_TEXT
+		SCHED_TEXT
+		LOCK_TEXT
+		KPROBES_TEXT
+		*(.gnu.warning)
+	} =0
+	_etext = .;
+	PROVIDE (etext = .);
+
+	RODATA
+
+	.data : {
+		DATA_DATA
+		CONSTRUCTORS
+	}
+	.data1 : {
+		*(.data1)
+	}
+
+	. = ALIGN(64);
+	.data.cacheline_aligned : {
+		*(.data.cacheline_aligned)
+	}
+
+	. = ALIGN(64);
+	.data.read_mostly : {
+		*(.data.read_mostly)
+	}
+	_edata  =  .;
+	PROVIDE (edata = .);
+	.fixup : {
+		*(.fixup)
+	}
+
+	. = ALIGN(16);
+	__start___ex_table = .;
+	__ex_table : {
+		*(__ex_table)
+	}
+	__stop___ex_table = .;
+
+	. = ALIGN(8192);
+	__init_begin = .;
+	.init.text : {
+		_sinittext = .;
+		*(.init.text)
+		_einittext = .;
+	}
+
+	.init.data : {
+		*(.init.data)
+	}
+
+	. = ALIGN(16);
+	__setup_start = .;
+	.init.setup : {
+		*(.init.setup)
+	}
+	__setup_end = .;
+
+	__initcall_start = .;
+	.initcall.init : {
+		INITCALLS
+	}
+	__initcall_end = .;
+
+	__con_initcall_start = .;
+	.con_initcall.init : {
+		*(.con_initcall.init)
+	}
+	__con_initcall_end = .;
+	SECURITY_INIT
+
+	. = ALIGN(4);
+	__tsb_ldquad_phys_patch = .;
+	.tsb_ldquad_phys_patch : {
+		*(.tsb_ldquad_phys_patch)
+	}
+	__tsb_ldquad_phys_patch_end = .;
+
+	__tsb_phys_patch = .;
+	.tsb_phys_patch : {
+		*(.tsb_phys_patch)
+	}
+	__tsb_phys_patch_end = .;
+
+	__cpuid_patch = .;
+	.cpuid_patch : {
+		*(.cpuid_patch)
+	}
+	__cpuid_patch_end = .;
+
+	__sun4v_1insn_patch = .;
+	.sun4v_1insn_patch : {
+		*(.sun4v_1insn_patch)
+	}
+	__sun4v_1insn_patch_end = .;
+	__sun4v_2insn_patch = .;
+	.sun4v_2insn_patch : {
+		*(.sun4v_2insn_patch)
+	}
+	__sun4v_2insn_patch_end = .;
 
 #ifdef CONFIG_BLK_DEV_INITRD
-  . = ALIGN(8192); 
-  __initramfs_start = .;
-  .init.ramfs : { *(.init.ramfs) }
-  __initramfs_end = .;
+	. = ALIGN(8192);
+	__initramfs_start = .;
+	.init.ramfs : {
+		*(.init.ramfs)
+	}
+	__initramfs_end = .;
 #endif
 
-  . = ALIGN(8192);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
-  . = ALIGN(8192);
-  __init_end = .;
-  __bss_start = .;
-  .sbss      : { *(.sbss) *(.scommon) }
-  .bss       :
-  {
-   *(.dynbss)
-   *(.bss)
-   *(COMMON)
-  }
-  _end = . ;
-  PROVIDE (end = .);
-  /DISCARD/ : { *(.exit.text) *(.exit.data) *(.exitcall.exit) }
-
-  STABS_DEBUG
-
-  DWARF_DEBUG
+	. = ALIGN(8192);
+	__per_cpu_start = .;
+	.data.percpu  : {
+		*(.data.percpu)
+	}
+	__per_cpu_end = .;
+	. = ALIGN(8192);
+	__init_end = .;
+
+	__bss_start = .;
+	.sbss : {
+		*(.sbss)
+		*(.scommon)
+	}
+	.bss : {
+		*(.dynbss)
+		*(.bss)
+		*(COMMON)
+	}
+	_end = . ;
+	PROVIDE (end = .);
+
+	/DISCARD/ : {
+		*(.exit.text)
+		*(.exit.data)
+		*(.exitcall.exit)
+	}
+
+	STABS_DEBUG
+	DWARF_DEBUG
 }
-- 
1.5.1.rc3.20.gaa453

