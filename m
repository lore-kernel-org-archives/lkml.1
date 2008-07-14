Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbYGNOmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbYGNOmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 10:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbYGNOmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 10:42:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36074 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733AbYGNOmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 10:42:13 -0400
Date: Mon, 14 Jul 2008 16:41:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] core/rodata change for v2.6.27
Message-ID: <20080714144156.GA20420@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core/rodata git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/rodata

moves BUG_TABLE into RODATA where it belongs.

Thanks,

	Ingo

------------------>
Jan Beulich (1):
      move BUG_TABLE into RODATA


 arch/avr32/kernel/vmlinux.lds.S   |    2 --
 arch/parisc/kernel/vmlinux.lds.S  |    1 -
 arch/powerpc/kernel/vmlinux.lds.S |    2 --
 arch/s390/kernel/vmlinux.lds.S    |    1 -
 arch/sh/kernel/vmlinux_32.lds.S   |    1 -
 arch/sh/kernel/vmlinux_64.lds.S   |    1 -
 arch/x86/kernel/vmlinux_32.lds.S  |    8 +++-----
 arch/x86/kernel/vmlinux_64.lds.S  |   10 ++++------
 include/asm-generic/vmlinux.lds.h |    6 ++++++
 9 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/arch/avr32/kernel/vmlinux.lds.S b/arch/avr32/kernel/vmlinux.lds.S
index 481cfd4..bc932c9 100644
--- a/arch/avr32/kernel/vmlinux.lds.S
+++ b/arch/avr32/kernel/vmlinux.lds.S
@@ -93,8 +93,6 @@ SECTIONS
 		__stop___ex_table = .;
 	}
 
-	BUG_TABLE
-
 	RODATA
 
 	. = ALIGN(THREAD_SIZE);
diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index 2e516b8..1a3b6cc 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -67,7 +67,6 @@ SECTIONS
 	_etext = .;
 
 	RODATA
-	BUG_TABLE
 
 	/* writeable */
 	/* Make sure this is page aligned so
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 0c3000b..53d57d1 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -64,8 +64,6 @@ SECTIONS
 
 	NOTES
 
-	BUG_TABLE
-
 /*
  * Init sections discarded at runtime
  */
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index b460715..76c1e60 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -40,7 +40,6 @@ SECTIONS
 	_etext = .;		/* End of text section */
 
 	NOTES :text :note
-	BUG_TABLE :text
 
 	RODATA
 
diff --git a/arch/sh/kernel/vmlinux_32.lds.S b/arch/sh/kernel/vmlinux_32.lds.S
index c711378..7b4b82b 100644
--- a/arch/sh/kernel/vmlinux_32.lds.S
+++ b/arch/sh/kernel/vmlinux_32.lds.S
@@ -44,7 +44,6 @@ SECTIONS
 
 	_etext = .;			/* End of text section */
 
-	BUG_TABLE
 	NOTES
 	RO_DATA(PAGE_SIZE)
 
diff --git a/arch/sh/kernel/vmlinux_64.lds.S b/arch/sh/kernel/vmlinux_64.lds.S
index d1e1770..33fa464 100644
--- a/arch/sh/kernel/vmlinux_64.lds.S
+++ b/arch/sh/kernel/vmlinux_64.lds.S
@@ -65,7 +65,6 @@ SECTIONS
 
 	_etext = .;			/* End of text section */
 
-	BUG_TABLE
 	NOTES 
 	RO_DATA(PAGE_SIZE)
 
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index ce5ed08..aa08554 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -49,16 +49,14 @@ SECTIONS
   	_etext = .;			/* End of text section */
   } :text = 0x9090
 
+  NOTES :text :note
+
   . = ALIGN(16);		/* Exception table */
   __ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
   	__start___ex_table = .;
 	 *(__ex_table)
   	__stop___ex_table = .;
-  }
-
-  NOTES :text :note
-
-  BUG_TABLE :text
+  } :text = 0x9090
 
   . = ALIGN(4);
   .tracedata : AT(ADDR(.tracedata) - LOAD_OFFSET) {
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index fad3674..d123747 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -19,7 +19,7 @@ PHDRS {
 	data PT_LOAD FLAGS(7);	/* RWE */
 	user PT_LOAD FLAGS(7);	/* RWE */
 	data.init PT_LOAD FLAGS(7);	/* RWE */
-	note PT_NOTE FLAGS(4);	/* R__ */
+	note PT_NOTE FLAGS(0);	/* ___ */
 }
 SECTIONS
 {
@@ -40,16 +40,14 @@ SECTIONS
 	_etext = .;		/* End of text section */
   } :text = 0x9090
 
+  NOTES :text :note
+
   . = ALIGN(16);		/* Exception table */
   __ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
   	__start___ex_table = .;
 	 *(__ex_table)
   	__stop___ex_table = .;
-  }
-
-  NOTES :text :note
-
-  BUG_TABLE :text
+  } :text = 0x9090
 
   RODATA
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f054778..dd2cc81 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -67,6 +67,8 @@
 		*(.rodata1)						\
 	}								\
 									\
+	BUG_TABLE							\
+									\
 	/* PCI quirks */						\
 	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start_pci_fixups_early) = .;		\
@@ -310,6 +312,7 @@
 		.stab.indexstr 0 : { *(.stab.indexstr) }		\
 		.comment 0 : { *(.comment) }
 
+#ifdef CONFIG_GENERIC_BUG
 #define BUG_TABLE							\
 	. = ALIGN(8);							\
 	__bug_table : AT(ADDR(__bug_table) - LOAD_OFFSET) {		\
@@ -317,6 +320,9 @@
 		*(__bug_table)						\
 		__stop___bug_table = .;					\
 	}
+#else
+#define BUG_TABLE
+#endif
 
 #define NOTES								\
 	.notes : AT(ADDR(.notes) - LOAD_OFFSET) {			\
