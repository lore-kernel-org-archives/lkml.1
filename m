Return-Path: <linux-kernel-owner+w=401wt.eu-S932616AbZEAANd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616AbZEAANd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764426AbZEAACJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:02:09 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61736 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763600AbZEAACI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:02:08 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 01/11] x86: Use macros for .bss.page_aligned section.
Date: Thu, 30 Apr 2009 20:01:28 -0400
Message-Id: <1241136098-10376-2-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241136098-10376-1-git-send-email-tabbott@mit.edu>
References: <1241136098-10376-1-git-send-email-tabbott@mit.edu>
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
 arch/x86/kernel/head_32.S     |    2 +-
 arch/x86/kernel/head_64.S     |    2 +-
 arch/x86/kernel/vmlinux.lds.S |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index dc5ed4b..a420002 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -611,7 +611,7 @@ ENTRY(initial_code)
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
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 4c85b2e..10edb97 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -366,8 +366,8 @@ SECTIONS
 	/* BSS */
 	. = ALIGN(PAGE_SIZE);
 	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {
-		__bss_start = .;
-		*(.bss.page_aligned)
+		__bss_start = .;		/* BSS */
+		PAGE_ALIGNED_BSS
 		*(.bss)
 		. = ALIGN(4);
 		__bss_stop = .;
-- 
1.6.2.1

