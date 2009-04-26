Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbZDZCYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbZDZCYV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 22:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbZDZCYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 22:24:01 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54700 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752476AbZDZCYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 22:24:00 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, "Theodore Ts'o" <tytso@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       =?utf-8?q?Am=C3=A9rico=20Wang?= <xiyou.wangcong@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       David Howells <dhowells@redhat.com>, Tim Abbott <tabbott@MIT.EDU>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 14/15] x86: convert to use __HEAD and HEAD_TEXT macros.
Date: Sat, 25 Apr 2009 22:11:09 -0400
Message-Id: <1240711870-30505-14-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240711870-30505-13-git-send-email-tabbott@mit.edu>
References: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu>
 <1240711870-30505-1-git-send-email-tabbott@mit.edu>
 <1240711870-30505-2-git-send-email-tabbott@mit.edu>
 <1240711870-30505-3-git-send-email-tabbott@mit.edu>
 <1240711870-30505-4-git-send-email-tabbott@mit.edu>
 <1240711870-30505-5-git-send-email-tabbott@mit.edu>
 <1240711870-30505-6-git-send-email-tabbott@mit.edu>
 <1240711870-30505-7-git-send-email-tabbott@mit.edu>
 <1240711870-30505-8-git-send-email-tabbott@mit.edu>
 <1240711870-30505-9-git-send-email-tabbott@mit.edu>
 <1240711870-30505-10-git-send-email-tabbott@mit.edu>
 <1240711870-30505-11-git-send-email-tabbott@mit.edu>
 <1240711870-30505-12-git-send-email-tabbott@mit.edu>
 <1240711870-30505-13-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has the consequence of changing the section name use for head
code from ".text.head" to ".head.text".  Since this commit changes all
users in the architecture, this change should be harmless.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/Makefile         |    2 +
 arch/x86/boot/compressed/head_32.S        |    3 +-
 arch/x86/boot/compressed/head_64.S        |    3 +-
 arch/x86/boot/compressed/vmlinux_32.lds   |   43 -------------------------
 arch/x86/boot/compressed/vmlinux_32.lds.S |   45 ++++++++++++++++++++++++++
 arch/x86/boot/compressed/vmlinux_64.lds   |   48 ---------------------------
 arch/x86/boot/compressed/vmlinux_64.lds.S |   50 +++++++++++++++++++++++++++++
 arch/x86/kernel/head_32.S                 |    2 +-
 arch/x86/kernel/head_64.S                 |    2 +-
 arch/x86/kernel/vmlinux_32.lds.S          |    4 +-
 arch/x86/kernel/vmlinux_64.lds.S          |    2 +-
 11 files changed, 106 insertions(+), 98 deletions(-)
 delete mode 100644 arch/x86/boot/compressed/vmlinux_32.lds
 create mode 100644 arch/x86/boot/compressed/vmlinux_32.lds.S
 delete mode 100644 arch/x86/boot/compressed/vmlinux_64.lds
 create mode 100644 arch/x86/boot/compressed/vmlinux_64.lds.S

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 65551c9..617c939 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -19,6 +19,8 @@ KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
 LDFLAGS := -m elf_$(UTS_MACHINE)
 LDFLAGS_vmlinux := -T
 
+CPPFLAGS_vmlinux_$(BITS).lds += -P -U$(UTS_MACHINE)
+
 $(obj)/vmlinux: $(src)/vmlinux_$(BITS).lds $(obj)/head_$(BITS).o $(obj)/misc.o $(obj)/piggy.o FORCE
 	$(call if_changed,ld)
 	@:
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 3a8a866..a7c7a42 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -23,13 +23,14 @@
  */
 .text
 
+#include <linux/init.h>
 #include <linux/linkage.h>
 #include <asm/segment.h>
 #include <asm/page_types.h>
 #include <asm/boot.h>
 #include <asm/asm-offsets.h>
 
-.section ".text.head","ax",@progbits
+__HEAD
 ENTRY(startup_32)
 	cld
 	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index ed4a829..a788a91 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -24,6 +24,7 @@
 .code32
 .text
 
+#include <linux/init.h>
 #include <linux/linkage.h>
 #include <asm/segment.h>
 #include <asm/pgtable_types.h>
@@ -33,7 +34,7 @@
 #include <asm/processor-flags.h>
 #include <asm/asm-offsets.h>
 
-.section ".text.head"
+__HEAD
 	.code32
 ENTRY(startup_32)
 	cld
diff --git a/arch/x86/boot/compressed/vmlinux_32.lds b/arch/x86/boot/compressed/vmlinux_32.lds
deleted file mode 100644
index bb3c483..0000000
--- a/arch/x86/boot/compressed/vmlinux_32.lds
+++ /dev/null
@@ -1,43 +0,0 @@
-OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
-OUTPUT_ARCH(i386)
-ENTRY(startup_32)
-SECTIONS
-{
-	/* Be careful parts of head_32.S assume startup_32 is at
-	 * address 0.
-	 */
-	. = 0;
-	.text.head : {
-		_head = . ;
-		*(.text.head)
-		_ehead = . ;
-	}
-	.rodata.compressed : {
-		*(.rodata.compressed)
-	}
-	.text :	{
-		_text = .; 	/* Text */
-		*(.text)
-		*(.text.*)
-		_etext = . ;
-	}
-	.rodata : {
-		_rodata = . ;
-		*(.rodata)	 /* read-only data */
-		*(.rodata.*)
-		_erodata = . ;
-	}
-	.data :	{
-		_data = . ;
-		*(.data)
-		*(.data.*)
-		_edata = . ;
-	}
-	.bss : {
-		_bss = . ;
-		*(.bss)
-		*(.bss.*)
-		*(COMMON)
-		_end = . ;
-	}
-}
diff --git a/arch/x86/boot/compressed/vmlinux_32.lds.S b/arch/x86/boot/compressed/vmlinux_32.lds.S
new file mode 100644
index 0000000..73b3c58
--- /dev/null
+++ b/arch/x86/boot/compressed/vmlinux_32.lds.S
@@ -0,0 +1,45 @@
+#include <asm-generic/vmlinux.lds.h>
+
+OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
+OUTPUT_ARCH(i386)
+ENTRY(startup_32)
+SECTIONS
+{
+	/* Be careful parts of head_32.S assume startup_32 is at
+	 * address 0.
+	 */
+	. = 0;
+	HEAD_TEXT_SECTION : {
+		_head = . ;
+		HEAD_TEXT
+		_ehead = . ;
+	}
+	.rodata.compressed : {
+		*(.rodata.compressed)
+	}
+	.text :	{
+		_text = .; 	/* Text */
+		*(.text)
+		*(.text.*)
+		_etext = . ;
+	}
+	.rodata : {
+		_rodata = . ;
+		*(.rodata)	 /* read-only data */
+		*(.rodata.*)
+		_erodata = . ;
+	}
+	.data :	{
+		_data = . ;
+		*(.data)
+		*(.data.*)
+		_edata = . ;
+	}
+	.bss : {
+		_bss = . ;
+		*(.bss)
+		*(.bss.*)
+		*(COMMON)
+		_end = . ;
+	}
+}
diff --git a/arch/x86/boot/compressed/vmlinux_64.lds b/arch/x86/boot/compressed/vmlinux_64.lds
deleted file mode 100644
index bef1ac8..0000000
--- a/arch/x86/boot/compressed/vmlinux_64.lds
+++ /dev/null
@@ -1,48 +0,0 @@
-OUTPUT_FORMAT("elf64-x86-64", "elf64-x86-64", "elf64-x86-64")
-OUTPUT_ARCH(i386:x86-64)
-ENTRY(startup_64)
-SECTIONS
-{
-	/* Be careful parts of head_64.S assume startup_32 is at
-	 * address 0.
-	 */
-	. = 0;
-	.text.head : {
-		_head = . ;
-		*(.text.head)
-		_ehead = . ;
-	}
-	.rodata.compressed : {
-		*(.rodata.compressed)
-	}
-	.text :	{
-		_text = .; 	/* Text */
-		*(.text)
-		*(.text.*)
-		_etext = . ;
-	}
-	.rodata : {
-		_rodata = . ;
-		*(.rodata)	 /* read-only data */
-		*(.rodata.*)
-		_erodata = . ;
-	}
-	.data :	{
-		_data = . ;
-		*(.data)
-		*(.data.*)
-		_edata = . ;
-	}
-	.bss : {
-		_bss = . ;
-		*(.bss)
-		*(.bss.*)
-		*(COMMON)
-		. = ALIGN(8);
-		_end_before_pgt = . ;
-		. = ALIGN(4096);
-		pgtable = . ;
-		. = . + 4096 * 6;
-		_ebss = .;
-	}
-}
diff --git a/arch/x86/boot/compressed/vmlinux_64.lds.S b/arch/x86/boot/compressed/vmlinux_64.lds.S
new file mode 100644
index 0000000..9235b15
--- /dev/null
+++ b/arch/x86/boot/compressed/vmlinux_64.lds.S
@@ -0,0 +1,50 @@
+#include <asm-generic/vmlinux.lds.h>
+
+OUTPUT_FORMAT("elf64-x86-64", "elf64-x86-64", "elf64-x86-64")
+OUTPUT_ARCH(i386:x86-64)
+ENTRY(startup_64)
+SECTIONS
+{
+	/* Be careful parts of head_64.S assume startup_32 is at
+	 * address 0.
+	 */
+	. = 0;
+	HEAD_TEXT_SECTION : {
+		_head = . ;
+		HEAD_TEXT
+		_ehead = . ;
+	}
+	.rodata.compressed : {
+		*(.rodata.compressed)
+	}
+	.text :	{
+		_text = .; 	/* Text */
+		*(.text)
+		*(.text.*)
+		_etext = . ;
+	}
+	.rodata : {
+		_rodata = . ;
+		*(.rodata)	 /* read-only data */
+		*(.rodata.*)
+		_erodata = . ;
+	}
+	.data :	{
+		_data = . ;
+		*(.data)
+		*(.data.*)
+		_edata = . ;
+	}
+	.bss : {
+		_bss = . ;
+		*(.bss)
+		*(.bss.*)
+		*(COMMON)
+		. = ALIGN(8);
+		_end_before_pgt = . ;
+		. = ALIGN(4096);
+		pgtable = . ;
+		. = . + 4096 * 6;
+		_ebss = .;
+	}
+}
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 3068388..a299ecc 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -80,7 +80,7 @@ RESERVE_BRK(pagetables, INIT_MAP_SIZE)
  * any particular GDT layout, because we load our own as soon as we
  * can.
  */
-.section .text.head,"ax",@progbits
+__HEAD
 ENTRY(startup_32)
 	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
 		us to not reload segments */
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 54b29bb..dbb6fb5 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -41,7 +41,7 @@ L4_START_KERNEL = pgd_index(__START_KERNEL_map)
 L3_START_KERNEL = pud_index(__START_KERNEL_map)
 
 	.text
-	.section .text.head
+	__HEAD
 	.code64
 	.globl startup_64
 startup_64:
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 62ad500..2e364e7 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -31,9 +31,9 @@ SECTIONS
   . = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
   phys_startup_32 = startup_32 - LOAD_OFFSET;
 
-  .text.head : AT(ADDR(.text.head) - LOAD_OFFSET) {
+  HEAD_TEXT_SECTION : AT(ADDR(HEAD_TEXT_SECTION) - LOAD_OFFSET) {
   	_text = .;			/* Text and read-only data */
-	*(.text.head)
+	HEAD_TEXT
   } :text = 0x9090
 
   /* read-only */
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index c874250..2dcd7c9 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -32,7 +32,7 @@ SECTIONS
   .text :  AT(ADDR(.text) - LOAD_OFFSET) {
 	_text = .;			/* Text and read-only data */
 	/* First the code that has to be first for bootstrapping */
-	*(.text.head)
+	HEAD_TEXT
 	_stext = .;
 	/* Then the rest */
 	TEXT_TEXT
-- 
1.6.2.1

