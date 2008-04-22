Return-Path: <linux-kernel-owner+w=401wt.eu-S933601AbYDVPKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933601AbYDVPKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762494AbYDVPJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:09:56 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:15459 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611AbYDVPJz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:09:55 -0400
Message-Id: <480E1BEE.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 22 Apr 2008 16:10:06 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] move BUG_TABLE into RODATA
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
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

--- linux-2.6.25/arch/avr32/kernel/vmlinux.lds.S	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-bug-table-rodata/arch/avr32/kernel/vmlinux.lds.S	2008-03-04 11:14:13.000000000 +0100
@@ -93,8 +93,6 @@ SECTIONS
 		__stop___ex_table = .;
 	}
 
-	BUG_TABLE
-
 	RODATA
 
 	. = ALIGN(THREAD_SIZE);
--- linux-2.6.25/arch/parisc/kernel/vmlinux.lds.S	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-bug-table-rodata/arch/parisc/kernel/vmlinux.lds.S	2008-03-04 11:14:13.000000000 +0100
@@ -66,7 +66,6 @@ SECTIONS
 	_etext = .;
 
 	RODATA
-	BUG_TABLE
 
 	/* writeable */
 	/* Make sure this is page aligned so
--- linux-2.6.25/arch/powerpc/kernel/vmlinux.lds.S	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-bug-table-rodata/arch/powerpc/kernel/vmlinux.lds.S	2008-03-04 11:14:13.000000000 +0100
@@ -66,8 +66,6 @@ SECTIONS
 
 	NOTES
 
-	BUG_TABLE
-
 /*
  * Init sections discarded at runtime
  */
--- linux-2.6.25/arch/s390/kernel/vmlinux.lds.S	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-bug-table-rodata/arch/s390/kernel/vmlinux.lds.S	2008-03-04 11:14:50.000000000 +0100
@@ -40,7 +40,6 @@ SECTIONS
 	_etext = .;		/* End of text section */
 
 	NOTES :text :note
-	BUG_TABLE :text
 
 	RODATA
 
--- linux-2.6.25/arch/sh/kernel/vmlinux_32.lds.S	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-bug-table-rodata/arch/sh/kernel/vmlinux_32.lds.S	2008-03-04 11:15:48.000000000 +0100
@@ -44,7 +44,6 @@ SECTIONS
 
 	_etext = .;			/* End of text section */
 
-	BUG_TABLE
 	NOTES
 	RO_DATA(PAGE_SIZE)
 
--- linux-2.6.25/arch/sh/kernel/vmlinux_64.lds.S	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-bug-table-rodata/arch/sh/kernel/vmlinux_64.lds.S	2008-03-04 11:15:53.000000000 +0100
@@ -65,7 +65,6 @@ SECTIONS
 
 	_etext = .;			/* End of text section */
 
-	BUG_TABLE
 	NOTES 
 	RO_DATA(PAGE_SIZE)
 
--- linux-2.6.25/arch/x86/kernel/vmlinux_32.lds.S	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-bug-table-rodata/arch/x86/kernel/vmlinux_32.lds.S	2008-03-04 11:14:13.000000000 +0100
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
--- linux-2.6.25/arch/x86/kernel/vmlinux_64.lds.S	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-bug-table-rodata/arch/x86/kernel/vmlinux_64.lds.S	2008-03-04 11:14:13.000000000 +0100
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
 
--- linux-2.6.25/include/asm-generic/vmlinux.lds.h	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-bug-table-rodata/include/asm-generic/vmlinux.lds.h	2008-03-04 11:14:13.000000000 +0100
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


