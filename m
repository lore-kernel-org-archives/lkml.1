Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbZD2JFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbZD2JFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754423AbZD2JFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:05:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:60426 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbZD2JFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:05:11 -0400
Date: Wed, 29 Apr 2009 09:03:31 GMT
From: tip-bot for Sam Ravnborg <sam@ravnborg.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, sam@ravnborg.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, torvalds@linux-foundation.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1240991249-27117-1-git-send-email-sam@ravnborg.org>
References: <1240991249-27117-1-git-send-email-sam@ravnborg.org>
Subject: [tip:x86/kbuild] x86: beautify vmlinux_32.lds.S
Message-ID: <tip-aee6a166a5401dcfcb17fcdc055e5edf2a4f4042@git.kernel.org>
Git-Commit-ID: aee6a166a5401dcfcb17fcdc055e5edf2a4f4042
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 09:03:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aee6a166a5401dcfcb17fcdc055e5edf2a4f4042
Gitweb:     http://git.kernel.org/tip/aee6a166a5401dcfcb17fcdc055e5edf2a4f4042
Author:     Sam Ravnborg <sam@ravnborg.org>
AuthorDate: Wed, 29 Apr 2009 09:47:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 10:20:29 +0200

x86: beautify vmlinux_32.lds.S

Beautify vmlinux_32.lds.S:

 - Use tabs for indent
 - Located curly braces like in C code
 - Rearranged a few comments

To see actual differences use "git diff -b" which
ignore 'whitespace' changes.

The beautification is done to prepare a unification
of the _32 and _64 variants of the linker scripts.

[ Impact: cleanup ]

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <1240991249-27117-1-git-send-email-sam@ravnborg.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/vmlinux_32.lds.S |  376 ++++++++++++++++++++------------------
 1 files changed, 200 insertions(+), 176 deletions(-)

diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 62ad500..fffa45a 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -22,196 +22,220 @@ ENTRY(phys_startup_32)
 jiffies = jiffies_64;
 
 PHDRS {
-	text PT_LOAD FLAGS(5);	/* R_E */
-	data PT_LOAD FLAGS(7);	/* RWE */
-	note PT_NOTE FLAGS(0);	/* ___ */
+	text PT_LOAD FLAGS(5);		/* R_E */
+	data PT_LOAD FLAGS(7);		/* RWE */
+	note PT_NOTE FLAGS(0);		/* ___ */
 }
 SECTIONS
 {
-  . = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
-  phys_startup_32 = startup_32 - LOAD_OFFSET;
-
-  .text.head : AT(ADDR(.text.head) - LOAD_OFFSET) {
-  	_text = .;			/* Text and read-only data */
-	*(.text.head)
-  } :text = 0x9090
-
-  /* read-only */
-  .text : AT(ADDR(.text) - LOAD_OFFSET) {
-	. = ALIGN(PAGE_SIZE); /* not really needed, already page aligned */
-	*(.text.page_aligned)
-	TEXT_TEXT
-	SCHED_TEXT
-	LOCK_TEXT
-	KPROBES_TEXT
-	IRQENTRY_TEXT
-	*(.fixup)
-	*(.gnu.warning)
-  	_etext = .;			/* End of text section */
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
-  /* writeable */
-  . = ALIGN(PAGE_SIZE);
-  .data : AT(ADDR(.data) - LOAD_OFFSET) {	/* Data */
-	DATA_DATA
-	CONSTRUCTORS
+	. = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
+	phys_startup_32 = startup_32 - LOAD_OFFSET;
+
+	/* Text and read-only data */
+	.text.head : AT(ADDR(.text.head) - LOAD_OFFSET) {
+		_text = .;
+		*(.text.head)
+	} :text = 0x9090
+
+	/* read-only */
+	.text : AT(ADDR(.text) - LOAD_OFFSET) {
+		/* not really needed, already page aligned */
+		. = ALIGN(PAGE_SIZE);
+		*(.text.page_aligned)
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
+
+	RODATA
+
+	/* writeable */
+	. = ALIGN(PAGE_SIZE);
+	/* Data */
+	.data : AT(ADDR(.data) - LOAD_OFFSET) {
+		DATA_DATA
+		CONSTRUCTORS
 	} :data
 
-  . = ALIGN(PAGE_SIZE);
-  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
-  	__nosave_begin = .;
-	*(.data.nosave)
-  	. = ALIGN(PAGE_SIZE);
-  	__nosave_end = .;
-  }
-
-  . = ALIGN(PAGE_SIZE);
-  .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
-	*(.data.page_aligned)
-	*(.data.idt)
-  }
-
-  . = ALIGN(32);
-  .data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
-	*(.data.cacheline_aligned)
-  }
-
-  /* rarely changed data like cpu maps */
-  . = ALIGN(32);
-  .data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
-	*(.data.read_mostly)
-	_edata = .;		/* End of data section */
-  }
-
-  . = ALIGN(THREAD_SIZE);	/* init_task */
-  .data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
-	*(.data.init_task)
-  }
-
-  /* might get freed after init */
-  . = ALIGN(PAGE_SIZE);
-  .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
-  	__smp_locks = .;
-	*(.smp_locks)
-	__smp_locks_end = .;
-  }
-  /* will be freed after init
-   * Following ALIGN() is required to make sure no other data falls on the
-   * same page where __smp_alt_end is pointing as that page might be freed
-   * after boot. Always make sure that ALIGN() directive is present after
-   * the section which contains __smp_alt_end.
-   */
-  . = ALIGN(PAGE_SIZE);
-
-  /* will be freed after init */
-  . = ALIGN(PAGE_SIZE);		/* Init code and data */
-  .init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
-  	__init_begin = .;
-	_sinittext = .;
-	INIT_TEXT
-	_einittext = .;
-  }
-  .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
-	INIT_DATA
-  }
-  . = ALIGN(16);
-  .init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
-  	__setup_start = .;
-	*(.init.setup)
-  	__setup_end = .;
-   }
-  .initcall.init : AT(ADDR(.initcall.init) - LOAD_OFFSET) {
-  	__initcall_start = .;
-	INITCALLS
-  	__initcall_end = .;
-  }
-  .con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET) {
-  	__con_initcall_start = .;
-	*(.con_initcall.init)
-  	__con_initcall_end = .;
-  }
-  .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
-	__x86_cpu_dev_start = .;
-	*(.x86_cpu_dev.init)
-	__x86_cpu_dev_end = .;
-  }
-  SECURITY_INIT
-  . = ALIGN(4);
-  .altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
-  	__alt_instructions = .;
-	*(.altinstructions)
-	__alt_instructions_end = .;
-  }
-  .altinstr_replacement : AT(ADDR(.altinstr_replacement) - LOAD_OFFSET) {
-	*(.altinstr_replacement)
-  }
-  . = ALIGN(4);
-  .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
-  	__parainstructions = .;
-	*(.parainstructions)
-  	__parainstructions_end = .;
-  }
-  /* .exit.text is discard at runtime, not link time, to deal with references
-     from .altinstructions and .eh_frame */
-  .exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) {
-	EXIT_TEXT
-  }
-  .exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) {
-	EXIT_DATA
-  }
+	. = ALIGN(PAGE_SIZE);
+	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
+		__nosave_begin = .;
+		*(.data.nosave)
+		. = ALIGN(PAGE_SIZE);
+		__nosave_end = .;
+	}
+
+	. = ALIGN(PAGE_SIZE);
+	.data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
+		*(.data.page_aligned)
+		*(.data.idt)
+	}
+
+	. = ALIGN(32);
+	.data.cacheline_aligned :
+		AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
+		*(.data.cacheline_aligned)
+	}
+
+	/* rarely changed data like cpu maps */
+	. = ALIGN(32);
+	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
+		*(.data.read_mostly)
+
+		/* End of data section */
+		_edata = .;
+	}
+
+	/* init_task */
+	. = ALIGN(THREAD_SIZE);
+	.data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
+		*(.data.init_task)
+	}
+
+	. = ALIGN(PAGE_SIZE);
+	.smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
+		/* might get freed after init */
+		__smp_locks = .;
+		*(.smp_locks)
+		__smp_locks_end = .;
+	}
+	/* will be freed after init
+	 * Following ALIGN() is required to make sure no other data falls on the
+	 * same page where __smp_alt_end is pointing as that page might be freed
+	 * after boot. Always make sure that ALIGN() directive is present after
+	 * the section which contains __smp_alt_end.
+	 */
+	. = ALIGN(PAGE_SIZE);
+
+	/* Init code and data - will be freed after init */
+	. = ALIGN(PAGE_SIZE);
+	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
+		__init_begin = .;
+		_sinittext = .;
+		INIT_TEXT
+		_einittext = .;
+	}
+
+	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
+		INIT_DATA
+	}
+
+	. = ALIGN(16);
+	.init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
+		__setup_start = .;
+		*(.init.setup)
+		__setup_end = .;
+	}
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
+	. = ALIGN(4);
+	.altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
+		__alt_instructions = .;
+		*(.altinstructions)
+		__alt_instructions_end = .;
+	}
+
+	.altinstr_replacement : AT(ADDR(.altinstr_replacement) - LOAD_OFFSET) {
+		*(.altinstr_replacement)
+	}
+
+	. = ALIGN(4);
+	.parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
+		__parainstructions = .;
+		*(.parainstructions)
+		__parainstructions_end = .;
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
+
 #if defined(CONFIG_BLK_DEV_INITRD)
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
-  PERCPU(PAGE_SIZE)
-  . = ALIGN(PAGE_SIZE);
-  /* freed after init ends here */
-
-  .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
-	__init_end = .;
-	__bss_start = .;		/* BSS */
-	*(.bss.page_aligned)
-	*(.bss)
-	. = ALIGN(4);
-	__bss_stop = .;
-  }
 
-  .brk : AT(ADDR(.brk) - LOAD_OFFSET) {
+	PERCPU(PAGE_SIZE)
+
 	. = ALIGN(PAGE_SIZE);
-	__brk_base = . ;
- 	. += 64 * 1024 ;	/* 64k alignment slop space */
-	*(.brk_reservation)	/* areas brk users have reserved */
-	__brk_limit = . ;
-  }
+	/* freed after init ends here */
+
+	/* BSS */
+	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {
+		__init_end = .;
+		__bss_start = .;
+		*(.bss.page_aligned)
+		*(.bss)
+		. = ALIGN(4);
+		__bss_stop = .;
+	}
 
-  .end : AT(ADDR(.end) - LOAD_OFFSET) {
-	_end = . ;
-  }
+	.brk : AT(ADDR(.brk) - LOAD_OFFSET) {
+		. = ALIGN(PAGE_SIZE);
+		__brk_base = .;
+		. += 64 * 1024;		/* 64k alignment slop space */
+		*(.brk_reservation)	/* areas brk users have reserved */
+		__brk_limit = .;
+	}
 
-  /* Sections to be discarded */
-  /DISCARD/ : {
-	*(.exitcall.exit)
-	*(.discard)
+	.end : AT(ADDR(.end) - LOAD_OFFSET) {
+		_end = . ;
 	}
 
-  STABS_DEBUG
+	/* Sections to be discarded */
+	/DISCARD/ : {
+		*(.exitcall.exit)
+		*(.discard)
+	}
 
-  DWARF_DEBUG
+	STABS_DEBUG
+	DWARF_DEBUG
 }
 
 /*
