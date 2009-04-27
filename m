Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbZD0E4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbZD0E4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 00:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZD0Ez6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 00:55:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:51480 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbZD0Ez4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 00:55:56 -0400
Date: Mon, 27 Apr 2009 04:54:38 GMT
From: tip-bot for Sam Ravnborg <sam@ravnborg.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, sam@ravnborg.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, torvalds@linux-foundation.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090426210742.GA3464@uranus.ravnborg.org>
References: <20090426210742.GA3464@uranus.ravnborg.org>
Subject: [tip:x86/kbuild] x86: beautify vmlinux_64.lds.S
Message-ID: <tip-0a3ec21fcd311b26ab0f249d62960e127bc20ca8@git.kernel.org>
Git-Commit-ID: 0a3ec21fcd311b26ab0f249d62960e127bc20ca8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 27 Apr 2009 04:54:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0a3ec21fcd311b26ab0f249d62960e127bc20ca8
Gitweb:     http://git.kernel.org/tip/0a3ec21fcd311b26ab0f249d62960e127bc20ca8
Author:     Sam Ravnborg <sam@ravnborg.org>
AuthorDate: Sun, 26 Apr 2009 23:07:42 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 27 Apr 2009 06:30:58 +0200

x86: beautify vmlinux_64.lds.S

Beautify vmlinux_64.lds.S:

 - Use tabs for indent
 - Located curly braces like in C code
 - Rearranged a few comments

There is no functional changes in this patch

The beautification is done to prepare a unification
of the _32 and the _64 variants of the linker scripts.

[ Impact: cleanup ]

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <20090426210742.GA3464@uranus.ravnborg.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/vmlinux_64.lds.S |  448 +++++++++++++++++++++-----------------
 1 files changed, 243 insertions(+), 205 deletions(-)

diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index c874250..6d5a5b0 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -15,69 +15,79 @@ OUTPUT_ARCH(i386:x86-64)
 ENTRY(phys_startup_64)
 jiffies_64 = jiffies;
 PHDRS {
-	text PT_LOAD FLAGS(5);	/* R_E */
-	data PT_LOAD FLAGS(7);	/* RWE */
-	user PT_LOAD FLAGS(7);	/* RWE */
+	text PT_LOAD FLAGS(5);		/* R_E */
+	data PT_LOAD FLAGS(7);		/* RWE */
+	user PT_LOAD FLAGS(7);		/* RWE */
 	data.init PT_LOAD FLAGS(7);	/* RWE */
 #ifdef CONFIG_SMP
 	percpu PT_LOAD FLAGS(7);	/* RWE */
 #endif
 	data.init2 PT_LOAD FLAGS(7);	/* RWE */
-	note PT_NOTE FLAGS(0);	/* ___ */
+	note PT_NOTE FLAGS(0);		/* ___ */
 }
 SECTIONS
 {
-  . = __START_KERNEL;
-  phys_startup_64 = startup_64 - LOAD_OFFSET;
-  .text :  AT(ADDR(.text) - LOAD_OFFSET) {
-	_text = .;			/* Text and read-only data */
-	/* First the code that has to be first for bootstrapping */
-	*(.text.head)
-	_stext = .;
-	/* Then the rest */
-	TEXT_TEXT
-	SCHED_TEXT
-	LOCK_TEXT
-	KPROBES_TEXT
-	IRQENTRY_TEXT
-	*(.fixup)
-	*(.gnu.warning)
-	_etext = .;		/* End of text section */
-  } :text = 0x9090
-
-  NOTES :text :note
-
-  . = ALIGN(16);		/* Exception table */
-  __ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
-  	__start___ex_table = .;
-	 *(__ex_table)
-  	__stop___ex_table = .;
-  } :text = 0x9090
-
-  RODATA
-
-  . = ALIGN(PAGE_SIZE);		/* Align data segment to page size boundary */
-				/* Data */
-  .data : AT(ADDR(.data) - LOAD_OFFSET) {
-	DATA_DATA
-	CONSTRUCTORS
-	_edata = .;			/* End of data section */
-	} :data
+	. = __START_KERNEL;
+	phys_startup_64 = startup_64 - LOAD_OFFSET;
+
+	/* Text and read-only data */
+	.text :  AT(ADDR(.text) - LOAD_OFFSET) {
+		_text = .;
+		/* First the code that has to be first for bootstrapping */
+		*(.text.head)
+		_stext = .;
+		/* Then the rest */
+		TEXT_TEXT
+		SCHED_TEXT
+		LOCK_TEXT
+		KPROBES_TEXT
+		IRQENTRY_TEXT
+		*(.fixup)
+		*(.gnu.warning)
+		/* End of text section */
+		_etext = .;
+	} :text = 0x9090
+
+	NOTES :text :note
+
+	/* Exception table */
+	. = ALIGN(16);
+	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
+		__start___ex_table = .;
+		 *(__ex_table)
+		__stop___ex_table = .;
+	} :text = 0x9090
 
+	RODATA
 
-  .data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
+	/* Align data segment to page size boundary */
 	. = ALIGN(PAGE_SIZE);
-	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-	*(.data.cacheline_aligned)
-  }
-  . = ALIGN(CONFIG_X86_INTERNODE_CACHE_BYTES);
-  .data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
-  	*(.data.read_mostly)
-  }
+	/* Data */
+	.data : AT(ADDR(.data) - LOAD_OFFSET) {
+		DATA_DATA
+		CONSTRUCTORS
+		/* End of data section */
+		_edata = .;
+	} :data
+
+
+	.data.cacheline_aligned :
+		AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
+		. = ALIGN(PAGE_SIZE);
+		. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+		*(.data.cacheline_aligned)
+	}
+
+	. = ALIGN(CONFIG_X86_INTERNODE_CACHE_BYTES);
+	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
+		*(.data.read_mostly)
+	}
 
 #define VSYSCALL_ADDR (-10*1024*1024)
-#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data.read_mostly) + SIZEOF(.data.read_mostly) + 4095) & ~(4095))
-#define VSYSCALL_VIRT_ADDR ((ADDR(.data.read_mostly) + SIZEOF(.data.read_mostly) + 4095) & ~(4095))
+#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data.read_mostly) + \
+                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
+#define VSYSCALL_VIRT_ADDR ((ADDR(.data.read_mostly) + \
+                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
 
 #define VLOAD_OFFSET (VSYSCALL_ADDR - VSYSCALL_PHYS_ADDR)
 #define VLOAD(x) (ADDR(x) - VLOAD_OFFSET)
@@ -85,37 +95,53 @@ SECTIONS
 #define VVIRT_OFFSET (VSYSCALL_ADDR - VSYSCALL_VIRT_ADDR)
 #define VVIRT(x) (ADDR(x) - VVIRT_OFFSET)
 
-  . = VSYSCALL_ADDR;
-  .vsyscall_0 :	 AT(VSYSCALL_PHYS_ADDR) { *(.vsyscall_0) } :user
-  __vsyscall_0 = VSYSCALL_VIRT_ADDR;
+	. = VSYSCALL_ADDR;
+	.vsyscall_0 : AT(VSYSCALL_PHYS_ADDR) {
+		*(.vsyscall_0)
+	} :user
+
+	__vsyscall_0 = VSYSCALL_VIRT_ADDR;
+
+	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+	.vsyscall_fn : AT(VLOAD(.vsyscall_fn)) {
+		*(.vsyscall_fn)
+	}
+
+	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+	.vsyscall_gtod_data : AT(VLOAD(.vsyscall_gtod_data)) {
+		*(.vsyscall_gtod_data)
+	}
 
-  . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-  .vsyscall_fn : AT(VLOAD(.vsyscall_fn)) { *(.vsyscall_fn) }
-  . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-  .vsyscall_gtod_data : AT(VLOAD(.vsyscall_gtod_data))
-		{ *(.vsyscall_gtod_data) }
-  vsyscall_gtod_data = VVIRT(.vsyscall_gtod_data);
-  .vsyscall_clock : AT(VLOAD(.vsyscall_clock))
-		{ *(.vsyscall_clock) }
-  vsyscall_clock = VVIRT(.vsyscall_clock);
+	vsyscall_gtod_data = VVIRT(.vsyscall_gtod_data);
+	.vsyscall_clock : AT(VLOAD(.vsyscall_clock)) {
+		*(.vsyscall_clock)
+	}
+	vsyscall_clock = VVIRT(.vsyscall_clock);
 
 
-  .vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1))
-		{ *(.vsyscall_1) }
-  .vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2))
-		{ *(.vsyscall_2) }
+	.vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1)) {
+		*(.vsyscall_1)
+	}
+	.vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2)) {
+		*(.vsyscall_2)
+	}
 
-  .vgetcpu_mode : AT(VLOAD(.vgetcpu_mode)) { *(.vgetcpu_mode) }
-  vgetcpu_mode = VVIRT(.vgetcpu_mode);
+	.vgetcpu_mode : AT(VLOAD(.vgetcpu_mode)) {
+		*(.vgetcpu_mode)
+	}
+	vgetcpu_mode = VVIRT(.vgetcpu_mode);
 
-  . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-  .jiffies : AT(VLOAD(.jiffies)) { *(.jiffies) }
-  jiffies = VVIRT(.jiffies);
+	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+	.jiffies : AT(VLOAD(.jiffies)) {
+		*(.jiffies)
+	}
+	jiffies = VVIRT(.jiffies);
 
-  .vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3))
-		{ *(.vsyscall_3) }
+	.vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3)) {
+		*(.vsyscall_3)
+	}
 
-  . = VSYSCALL_VIRT_ADDR + PAGE_SIZE;
+	. = VSYSCALL_VIRT_ADDR + PAGE_SIZE;
 
 #undef VSYSCALL_ADDR
 #undef VSYSCALL_PHYS_ADDR
@@ -125,156 +151,168 @@ SECTIONS
 #undef VVIRT_OFFSET
 #undef VVIRT
 
-  .data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
-	. = ALIGN(THREAD_SIZE);	/* init_task */
-	*(.data.init_task)
-  }:data.init
+	/* init_task */
+	.data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
+		. = ALIGN(THREAD_SIZE);
+		*(.data.init_task)
+	} :data.init
 
-  .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
-	. = ALIGN(PAGE_SIZE);
-	*(.data.page_aligned)
-  }
+	.data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
+		. = ALIGN(PAGE_SIZE);
+		*(.data.page_aligned)
+	}
 
-  .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
-	/* might get freed after init */
-	. = ALIGN(PAGE_SIZE);
-	__smp_alt_begin = .;
-	__smp_locks = .;
-	*(.smp_locks)
-	__smp_locks_end = .;
+	.smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
+		/* might get freed after init */
+		. = ALIGN(PAGE_SIZE);
+		__smp_alt_begin = .;
+		__smp_locks = .;
+		*(.smp_locks)
+		__smp_locks_end = .;
+		. = ALIGN(PAGE_SIZE);
+		__smp_alt_end = .;
+	}
+
+	/* Init code and data */
 	. = ALIGN(PAGE_SIZE);
-	__smp_alt_end = .;
-  }
-
-  . = ALIGN(PAGE_SIZE);		/* Init code and data */
-  __init_begin = .;	/* paired with __init_end */
-  .init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
-	_sinittext = .;
-	INIT_TEXT
-	_einittext = .;
-  }
-  .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
-	__initdata_begin = .;
-	INIT_DATA
-	__initdata_end = .;
-   }
-
-  .init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
-	. = ALIGN(16);
-	__setup_start = .;
-	*(.init.setup)
-	__setup_end = .;
-  }
-  .initcall.init : AT(ADDR(.initcall.init) - LOAD_OFFSET) {
-	__initcall_start = .;
-	INITCALLS
-	__initcall_end = .;
-  }
-  .con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET) {
-	__con_initcall_start = .;
-	*(.con_initcall.init)
-	__con_initcall_end = .;
-  }
-  .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
-	__x86_cpu_dev_start = .;
-	*(.x86_cpu_dev.init)
-	__x86_cpu_dev_end = .;
-  }
-  SECURITY_INIT
-
-  . = ALIGN(8);
-  .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
-	__parainstructions = .;
-       *(.parainstructions)
-	__parainstructions_end = .;
-  }
-
-  .altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
+	__init_begin = .;	/* paired with __init_end */
+	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
+		_sinittext = .;
+		INIT_TEXT
+		_einittext = .;
+	}
+
+	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
+		__initdata_begin = .;
+		INIT_DATA
+		__initdata_end = .;
+	}
+
+	.init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
+		. = ALIGN(16);
+		__setup_start = .;
+		*(.init.setup)
+		__setup_end = .;
+	}
+
+	.initcall.init : AT(ADDR(.initcall.init) - LOAD_OFFSET) {
+		__initcall_start = .;
+		INITCALLS
+		__initcall_end = .;
+	}
+
+	.con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET) {
+		__con_initcall_start = .;
+		*(.con_initcall.init)
+		__con_initcall_end = .;
+	}
+
+	.x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
+		__x86_cpu_dev_start = .;
+		*(.x86_cpu_dev.init)
+		__x86_cpu_dev_end = .;
+	}
+
+	SECURITY_INIT
+
 	. = ALIGN(8);
-	__alt_instructions = .;
-	*(.altinstructions)
-	__alt_instructions_end = .;
-  }
-  .altinstr_replacement : AT(ADDR(.altinstr_replacement) - LOAD_OFFSET) {
-	*(.altinstr_replacement)
-  }
-  /* .exit.text is discard at runtime, not link time, to deal with references
-     from .altinstructions and .eh_frame */
-  .exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) {
-	EXIT_TEXT
-  }
-  .exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) {
-	EXIT_DATA
-  }
+	.parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
+		__parainstructions = .;
+		*(.parainstructions)
+		__parainstructions_end = .;
+	}
+
+	.altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
+		. = ALIGN(8);
+		__alt_instructions = .;
+		*(.altinstructions)
+		__alt_instructions_end = .;
+	}
+
+	.altinstr_replacement : AT(ADDR(.altinstr_replacement) - LOAD_OFFSET) {
+		*(.altinstr_replacement)
+	}
+
+	/*
+	 * .exit.text is discard at runtime, not link time, to deal with
+	 *  references from .altinstructions and .eh_frame
+	 */
+	.exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) {
+		EXIT_TEXT
+	}
+
+	.exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) {
+		EXIT_DATA
+	}
 
 #ifdef CONFIG_BLK_DEV_INITRD
-  . = ALIGN(PAGE_SIZE);
-  .init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
-	__initramfs_start = .;
-	*(.init.ramfs)
-	__initramfs_end = .;
-  }
+	. = ALIGN(PAGE_SIZE);
+	.init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
+		__initramfs_start = .;
+		*(.init.ramfs)
+		__initramfs_end = .;
+	}
 #endif
 
 #ifdef CONFIG_SMP
-  /*
-   * percpu offsets are zero-based on SMP.  PERCPU_VADDR() changes the
-   * output PHDR, so the next output section - __data_nosave - should
-   * start another section data.init2.  Also, pda should be at the head of
-   * percpu area.  Preallocate it and define the percpu offset symbol
-   * so that it can be accessed as a percpu variable.
-   */
-  . = ALIGN(PAGE_SIZE);
-  PERCPU_VADDR(0, :percpu)
+	/*
+	 * percpu offsets are zero-based on SMP.  PERCPU_VADDR() changes the
+	 * output PHDR, so the next output section - __data_nosave - should
+	 * start another section data.init2.  Also, pda should be at the head of
+	 * percpu area.  Preallocate it and define the percpu offset symbol
+	 * so that it can be accessed as a percpu variable.
+	 */
+	. = ALIGN(PAGE_SIZE);
+	PERCPU_VADDR(0, :percpu)
 #else
-  PERCPU(PAGE_SIZE)
+	PERCPU(PAGE_SIZE)
 #endif
 
-  . = ALIGN(PAGE_SIZE);
-  __init_end = .;
-
-  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
-	. = ALIGN(PAGE_SIZE);
-	__nosave_begin = .;
-	*(.data.nosave)
-	. = ALIGN(PAGE_SIZE);
-	__nosave_end = .;
-  } :data.init2 /* use another section data.init2, see PERCPU_VADDR() above */
-
-  .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
 	. = ALIGN(PAGE_SIZE);
-	__bss_start = .;		/* BSS */
-	*(.bss.page_aligned)
-	*(.bss)
-	__bss_stop = .;
-  }
+	__init_end = .;
+
+	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
+		. = ALIGN(PAGE_SIZE);
+		__nosave_begin = .;
+		*(.data.nosave)
+		. = ALIGN(PAGE_SIZE);
+		__nosave_end = .;
+	} :data.init2
+	/* use another section data.init2, see PERCPU_VADDR() above */
+
+	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {
+		. = ALIGN(PAGE_SIZE);
+		__bss_start = .;		/* BSS */
+		*(.bss.page_aligned)
+		*(.bss)
+		__bss_stop = .;
+	}
 
-  .brk : AT(ADDR(.brk) - LOAD_OFFSET) {
-	. = ALIGN(PAGE_SIZE);
-	__brk_base = . ;
- 	. += 64 * 1024 ;	/* 64k alignment slop space */
-	*(.brk_reservation)	/* areas brk users have reserved */
-	__brk_limit = . ;
-  }
-
-  _end = . ;
-
-  /* Sections to be discarded */
-  /DISCARD/ : {
-	*(.exitcall.exit)
-	*(.eh_frame)
-	*(.discard)
+	.brk : AT(ADDR(.brk) - LOAD_OFFSET) {
+		. = ALIGN(PAGE_SIZE);
+		__brk_base = .;
+		. += 64 * 1024;		/* 64k alignment slop space */
+		*(.brk_reservation)	/* areas brk users have reserved */
+		__brk_limit = .;
 	}
 
-  STABS_DEBUG
+	_end = . ;
 
-  DWARF_DEBUG
+	/* Sections to be discarded */
+	/DISCARD/ : {
+		*(.exitcall.exit)
+		*(.eh_frame)
+		*(.discard)
+	}
+
+	STABS_DEBUG
+	DWARF_DEBUG
 }
 
- /*
-  * Per-cpu symbols which need to be offset from __per_cpu_load
-  * for the boot processor.
-  */
+/*
+ * Per-cpu symbols which need to be offset from __per_cpu_load
+ * for the boot processor.
+ */
 #define INIT_PER_CPU(x) init_per_cpu__##x = per_cpu__##x + __per_cpu_load
 INIT_PER_CPU(gdt_page);
 INIT_PER_CPU(irq_stack_union);
