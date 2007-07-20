Return-Path: <linux-kernel-owner+w=401wt.eu-S1763076AbXGTDdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763076AbXGTDdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757932AbXGTDdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:33:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35617 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762899AbXGTDdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:33:08 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 3/8] m68k: use .text.head
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Message-Id: <E1IBjEq-0004ks-5L@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 20 Jul 2007 04:33:08 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


i.e. tell modpost that entry point code (that has to be outside
of .init.text for external reasons) is OK to refer to .init.*

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/m68k/kernel/head.S           |    2 +-
 arch/m68k/kernel/sun3-head.S      |    2 +-
 arch/m68k/kernel/vmlinux-std.lds  |    1 +
 arch/m68k/kernel/vmlinux-sun3.lds |    2 +-
 4 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/kernel/head.S b/arch/m68k/kernel/head.S
index 05741f2..faa6764 100644
--- a/arch/m68k/kernel/head.S
+++ b/arch/m68k/kernel/head.S
@@ -577,7 +577,7 @@ func_define	putn,1
 #endif
 .endm
 
-.text
+.section ".text.head","ax"
 ENTRY(_stext)
 /*
  * Version numbers of the bootinfo interface
diff --git a/arch/m68k/kernel/sun3-head.S b/arch/m68k/kernel/sun3-head.S
index 4b5f050..aad0159 100644
--- a/arch/m68k/kernel/sun3-head.S
+++ b/arch/m68k/kernel/sun3-head.S
@@ -29,7 +29,7 @@ kernel_pmd_table:              .skip 0x2000
 .globl kernel_pg_dir
 .equ    kernel_pg_dir,kernel_pmd_table
 
-	.section .head
+	.section .text.head
 ENTRY(_stext)
 ENTRY(_start)
 
diff --git a/arch/m68k/kernel/vmlinux-std.lds b/arch/m68k/kernel/vmlinux-std.lds
index 40f02b1..c422457 100644
--- a/arch/m68k/kernel/vmlinux-std.lds
+++ b/arch/m68k/kernel/vmlinux-std.lds
@@ -11,6 +11,7 @@ SECTIONS
   . = 0x1000;
   _text = .;			/* Text and read-only data */
   .text : {
+	*(.text.head)
 	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
diff --git a/arch/m68k/kernel/vmlinux-sun3.lds b/arch/m68k/kernel/vmlinux-sun3.lds
index f06425b..4adffef 100644
--- a/arch/m68k/kernel/vmlinux-sun3.lds
+++ b/arch/m68k/kernel/vmlinux-sun3.lds
@@ -11,7 +11,7 @@ SECTIONS
   . = 0xE002000;
   _text = .;			/* Text and read-only data */
   .text : {
-	*(.head)
+	*(.text.head)
 	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
-- 
1.5.3.GIT


