Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbZD0Ufz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbZD0Ufz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760839AbZD0UfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:35:22 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:55802 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760832AbZD0UfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:35:21 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 14/14] x86: Use macros for .data.page_aligned.
Date: Mon, 27 Apr 2009 16:33:08 -0400
Message-Id: <1240864388-26315-15-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240864388-26315-14-git-send-email-tabbott@mit.edu>
References: <1240864388-26315-1-git-send-email-tabbott@mit.edu>
 <1240864388-26315-2-git-send-email-tabbott@mit.edu>
 <1240864388-26315-3-git-send-email-tabbott@mit.edu>
 <1240864388-26315-4-git-send-email-tabbott@mit.edu>
 <1240864388-26315-5-git-send-email-tabbott@mit.edu>
 <1240864388-26315-6-git-send-email-tabbott@mit.edu>
 <1240864388-26315-7-git-send-email-tabbott@mit.edu>
 <1240864388-26315-8-git-send-email-tabbott@mit.edu>
 <1240864388-26315-9-git-send-email-tabbott@mit.edu>
 <1240864388-26315-10-git-send-email-tabbott@mit.edu>
 <1240864388-26315-11-git-send-email-tabbott@mit.edu>
 <1240864388-26315-12-git-send-email-tabbott@mit.edu>
 <1240864388-26315-13-git-send-email-tabbott@mit.edu>
 <1240864388-26315-14-git-send-email-tabbott@mit.edu>
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
 arch/x86/kernel/head_32.S        |    2 +-
 arch/x86/kernel/vmlinux_32.lds.S |    6 +-----
 arch/x86/kernel/vmlinux_64.lds.S |    6 +-----
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 9694aee..ad0510d 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -636,7 +636,7 @@ ENTRY(empty_zero_page)
  * This starts the data section.
  */
 #ifdef CONFIG_X86_PAE
-.section ".data.page_aligned","wa"
+__PAGE_ALIGNED_DATA
 	/* Page-aligned for the benefit of paravirt? */
 	.align PAGE_SIZE_asm
 ENTRY(swapper_pg_dir)
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index a57d39c..b458ab4 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -61,6 +61,7 @@ SECTIONS
   /* writeable */
   . = ALIGN(PAGE_SIZE);
   .data : AT(ADDR(.data) - LOAD_OFFSET) {	/* Data */
+	PAGE_ALIGNED_DATA
 	DATA_DATA
 	CONSTRUCTORS
 	} :data
@@ -73,11 +74,6 @@ SECTIONS
   	__nosave_end = .;
   }
 
-  . = ALIGN(PAGE_SIZE);
-  .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
-	*(.data.page_aligned)
-  }
-
   . = ALIGN(32);
   .data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
 	*(.data.cacheline_aligned)
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 9b52841..056db9a 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -64,6 +64,7 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	/* Data */
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {
+		PAGE_ALIGNED_DATA
 		DATA_DATA
 		CONSTRUCTORS
 		/* End of data section */
@@ -157,11 +158,6 @@ SECTIONS
 		*(.data.init_task)
 	} :data.init
 
-	.data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
-		. = ALIGN(PAGE_SIZE);
-		*(.data.page_aligned)
-	}
-
 	.smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
 		/* might get freed after init */
 		. = ALIGN(PAGE_SIZE);
-- 
1.6.2.1

