Return-Path: <linux-kernel-owner+w=401wt.eu-S932720AbZEAAOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720AbZEAAOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZEAACf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:02:35 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61795 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762923AbZEAACe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:02:34 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 03/11] x86: Use macros for .data.page_aligned.
Date: Thu, 30 Apr 2009 20:01:30 -0400
Message-Id: <1241136098-10376-4-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241136098-10376-3-git-send-email-tabbott@mit.edu>
References: <1241136098-10376-1-git-send-email-tabbott@mit.edu>
 <1241136098-10376-2-git-send-email-tabbott@mit.edu>
 <1241136098-10376-3-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.page_aligned should not need a separate output section.  So, as
part of this cleanup I moved it into the .data output section in the
linker scripts in order to eliminate unnecessary references to the
section name.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/kernel/head_32.S     |    2 +-
 arch/x86/kernel/vmlinux.lds.S |    6 +-----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index a420002..d251f71 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -629,7 +629,7 @@ ENTRY(empty_zero_page)
  * This starts the data section.
  */
 #ifdef CONFIG_X86_PAE
-.section ".data.page_aligned","wa"
+__PAGE_ALIGNED_DATA
 	/* Page-aligned for the benefit of paravirt? */
 	.align PAGE_SIZE_asm
 ENTRY(swapper_pg_dir)
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 037df73..6f73355 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -108,6 +108,7 @@ SECTIONS
 	/* Data */
 	. = ALIGN(PAGE_SIZE);
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {
+		PAGE_ALIGNED_DATA
 		DATA_DATA
 		CONSTRUCTORS
 
@@ -128,11 +129,6 @@ SECTIONS
 	}
 #endif
 
-	. = ALIGN(PAGE_SIZE);
-	.data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
-		*(.data.page_aligned)
-	}
-
 #ifdef CONFIG_X86_32
 	. = ALIGN(32);
 #else
-- 
1.6.2.1

