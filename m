Return-Path: <linux-kernel-owner+w=401wt.eu-S933151AbZD1RGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151AbZD1RGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932827AbZD1RCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:02:43 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54731 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932828AbZD1RCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:02:40 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       David Howells <dhowells@redhat.com>, Tim Abbott <tabbott@MIT.EDU>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2 05/15] x86: Use macros for .bss.page_aligned section.
Date: Tue, 28 Apr 2009 13:00:52 -0400
Message-Id: <1240938062-3264-6-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240938062-3264-5-git-send-email-tabbott@mit.edu>
References: <1240938062-3264-1-git-send-email-tabbott@mit.edu>
 <1240938062-3264-2-git-send-email-tabbott@mit.edu>
 <1240938062-3264-3-git-send-email-tabbott@mit.edu>
 <1240938062-3264-4-git-send-email-tabbott@mit.edu>
 <1240938062-3264-5-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/head_32.S        |    2 +-
 arch/x86/kernel/head_64.S        |    2 +-
 arch/x86/kernel/vmlinux_32.lds.S |    2 +-
 arch/x86/kernel/vmlinux_64.lds.S |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 3068388..8f2a18b 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -618,7 +618,7 @@ ENTRY(_stext)
 /*
  * BSS section
  */
-.section ".bss.page_aligned","wa"
+__PAGE_ALIGNED_BSS
 	.align PAGE_SIZE_asm
 #ifdef CONFIG_X86_PAE
 swapper_pg_pmd:
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 54b29bb..ae9a453 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -419,7 +419,7 @@ ENTRY(phys_base)
 ENTRY(idt_table)
 	.skip IDT_ENTRIES * 16
 
-	.section .bss.page_aligned, "aw", @nobits
+	__PAGE_ALIGNED_BSS
 	.align PAGE_SIZE
 ENTRY(empty_zero_page)
 	.skip PAGE_SIZE
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 62ad500..db882aa 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -185,7 +185,7 @@ SECTIONS
   .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
 	__init_end = .;
 	__bss_start = .;		/* BSS */
-	*(.bss.page_aligned)
+	PAGE_ALIGNED_BSS
 	*(.bss)
 	. = ALIGN(4);
 	__bss_stop = .;
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 6d5a5b0..424fb87 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -283,7 +283,7 @@ SECTIONS
 	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {
 		. = ALIGN(PAGE_SIZE);
 		__bss_start = .;		/* BSS */
-		*(.bss.page_aligned)
+		PAGE_ALIGNED_BSS
 		*(.bss)
 		__bss_stop = .;
 	}
-- 
1.6.2.1

