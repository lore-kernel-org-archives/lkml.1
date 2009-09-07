Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbZIGDKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbZIGDKH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 23:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758752AbZIGDKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 23:10:06 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60797 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758721AbZIGDKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 23:10:05 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>,
       Bryan Wu <cooloney@kernel.org>, uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH] blackfin: Cleanup linker script using new linker script macros.
Date: Sun,  6 Sep 2009 23:05:53 -0400
Message-Id: <1252292753-11792-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 arch/blackfin/kernel/vmlinux.lds.S |   54 +++--------------------------------
 1 files changed, 5 insertions(+), 49 deletions(-)

diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index 6ac307c..91f5057 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -96,8 +96,7 @@ SECTIONS
 	{
 		__sdata = .;
 		/* This gets done first, so the glob doesn't suck it in */
-		. = ALIGN(32);
-		*(.data.cacheline_aligned)
+		CACHELINE_ALIGNED_DATA(32)
 
 #if !L1_DATA_A_LENGTH
 		. = ALIGN(32);
@@ -116,12 +115,7 @@ SECTIONS
 		DATA_DATA
 		CONSTRUCTORS
 
-		/* make sure the init_task is aligned to the
-		 * kernel thread size so we can locate the kernel
-		 * stack properly and quickly.
-		 */
-		. = ALIGN(THREAD_SIZE);
-		*(.init_task.data)
+		INIT_TASK_DATA(THREAD_SIZE)
 
 		__edata = .;
 	}
@@ -134,39 +128,10 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	___init_begin = .;
 
-	.init.text :
-	{
-		. = ALIGN(PAGE_SIZE);
-		__sinittext = .;
-		INIT_TEXT
-		__einittext = .;
-	}
-	.init.data :
-	{
-		. = ALIGN(16);
-		INIT_DATA
-	}
-	.init.setup :
-	{
-		. = ALIGN(16);
-		___setup_start = .;
-		*(.init.setup)
-		___setup_end = .;
-	}
-	.initcall.init :
-	{
-		___initcall_start = .;
-		INITCALLS
-		___initcall_end = .;
-	}
-	.con_initcall.init :
-	{
-		___con_initcall_start = .;
-		*(.con_initcall.init)
-		___con_initcall_end = .;
-	}
+	INIT_TEXT_SECTION(PAGE_SIZE)
+	. = ALIGN(16);
+	INIT_DATA_SECTION(16)
 	PERCPU(4)
-	SECURITY_INIT
 
 	/* we have to discard exit text and such at runtime, not link time, to
 	 * handle embedded cross-section references (alt instructions, bug
@@ -181,15 +146,6 @@ SECTIONS
 		EXIT_DATA
 	}
 
-	.init.ramfs :
-	{
-		. = ALIGN(4);
-		___initramfs_start = .;
-		*(.init.ramfs)
-		. = ALIGN(4);
-		___initramfs_end = .;
-	}
-
 	__l1_lma_start = .;
 
 	.text_l1 L1_CODE_START : AT(LOADADDR(.init.ramfs) + SIZEOF(.init.ramfs))
-- 
1.6.3.3

