Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab0BTApv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:45:51 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:63223 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab0BTApu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:45:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NZHIGwk4jp6tn/TPI5UJaNZbEYf0+rm0H1TZZib1/lulE9WJVLpPeevhHHB5SDF5Jn
         74ZdDJN1qFZSl+TT6hsU+6ht3CnqFrV9597wnIa09D4ePokIw0PttoR7gnt5jRjGIbfs
         YykCHtsuJMbqjAdkF/gXzjzqTOQwFJq+KxYR4=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 23/24] Rename special text sections in arch/frv from .text.xxx to .text..xxx.
Date: Sat, 20 Feb 2010 01:45:43 +0100
Message-Id: <1266626743-26519-1-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 arch/frv/kernel/break.S       |    2 +-
 arch/frv/kernel/entry.S       |    2 +-
 arch/frv/kernel/head.S        |    2 +-
 arch/frv/kernel/vmlinux.lds.S |    8 ++++----
 arch/frv/mm/tlb-miss.S        |    2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/frv/kernel/break.S b/arch/frv/kernel/break.S
index c5388b7..cbb6958 100644
--- a/arch/frv/kernel/break.S
+++ b/arch/frv/kernel/break.S
@@ -63,7 +63,7 @@ __break_trace_through_exceptions:
 # entry point for Break Exceptions/Interrupts
 #
 ###############################################################################
-	.section	.text.break
+	.section	.text..break
 	.balign		4
 	.globl		__entry_break
 __entry_break:
diff --git a/arch/frv/kernel/entry.S b/arch/frv/kernel/entry.S
index 189397e..63d579b 100644
--- a/arch/frv/kernel/entry.S
+++ b/arch/frv/kernel/entry.S
@@ -38,7 +38,7 @@
 
 #define nr_syscalls ((syscall_table_size)/4)
 
-	.section	.text.entry
+	.section	.text..entry
 	.balign		4
 
 .macro LEDS val
diff --git a/arch/frv/kernel/head.S b/arch/frv/kernel/head.S
index b825ef3..e9a8cc6 100644
--- a/arch/frv/kernel/head.S
+++ b/arch/frv/kernel/head.S
@@ -542,7 +542,7 @@ __head_end:
 	.size		_boot, .-_boot
 
 	# provide a point for GDB to place a break
-	.section	.text.start,"ax"
+	.section	.text..start,"ax"
 	.globl		_start
 	.balign		4
 _start:
diff --git a/arch/frv/kernel/vmlinux.lds.S b/arch/frv/kernel/vmlinux.lds.S
index 472eb8c..8b973f3 100644
--- a/arch/frv/kernel/vmlinux.lds.S
+++ b/arch/frv/kernel/vmlinux.lds.S
@@ -57,10 +57,10 @@ SECTIONS
   _text = .;
   _stext = .;
   .text : {
-	*(.text.start)
-	*(.text.entry)
-	*(.text.break)
-	*(.text.tlbmiss)
+	*(.text..start)
+	*(.text..entry)
+	*(.text..break)
+	*(.text..tlbmiss)
 	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
diff --git a/arch/frv/mm/tlb-miss.S b/arch/frv/mm/tlb-miss.S
index 7f392bc..f3ac019 100644
--- a/arch/frv/mm/tlb-miss.S
+++ b/arch/frv/mm/tlb-miss.S
@@ -15,7 +15,7 @@
 #include <asm/pgtable.h>
 #include <asm/spr-regs.h>
 
-	.section	.text.tlbmiss
+	.section	.text..tlbmiss
 	.balign		4
 
 	.globl		__entry_insn_mmu_miss
-- 
1.6.2.4

