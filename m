Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbZITRd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbZITRd0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 13:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbZITRdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 13:33:24 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52570 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754723AbZITRdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 13:33:24 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@sunplusct.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH 3/3] score: Cleanup linker script using new macros.
Date: Sun, 20 Sep 2009 13:32:59 -0400
Message-Id: <1253467979-14110-4-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253467979-14110-1-git-send-email-tabbott@ksplice.com>
References: <1253467979-14110-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 arch/score/kernel/vmlinux.lds.S |   75 ++++-----------------------------------
 1 files changed, 7 insertions(+), 68 deletions(-)

diff --git a/arch/score/kernel/vmlinux.lds.S b/arch/score/kernel/vmlinux.lds.S
index f855698..aab4703 100644
--- a/arch/score/kernel/vmlinux.lds.S
+++ b/arch/score/kernel/vmlinux.lds.S
@@ -49,21 +49,9 @@ SECTIONS
 	. = ALIGN(16);
 	RODATA
 
-	/* Exception table */
-	. = ALIGN(16);
-	__ex_table : {
-		__start___ex_table = .;
-		*(__ex_table)
-		__stop___ex_table = .;
-	}
+	EXCEPTION_TABLE(16)
 
-	/* writeable */
-	.data ALIGN (4096): {
-		*(.data.init_task)
-
-		DATA_DATA
-		CONSTRUCTORS
-	}
+	RW_DATA_SECTION(32, PAGE_SIZE, THREAD_SIZE)
 
 	/* We want the small data sections together, so single-instruction offsets
 	   can access them all, and initialized data all before uninitialized, so
@@ -72,45 +60,14 @@ SECTIONS
 	.sdata : {
 		*(.sdata)
 	}
-
-	. = ALIGN(32);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
-	}
 	_edata =  .;			/* End of data section */
 
 	/* will be freed after init */
-	. = ALIGN(4096);		/* Init code and data */
+	. = ALIGN(PAGE_SIZE);		/* Init code and data */
 	__init_begin = .;
 
-	. = ALIGN(4096);
-	.init.text : {
-		_sinittext = .;
-		INIT_TEXT
-		_einittext = .;
-	}
-	.init.data : {
-		INIT_DATA
-	}
-	. = ALIGN(16);
-	.init.setup : {
-		__setup_start = .;
-		*(.init.setup)
-		__setup_end = .;
-	}
-
-	.initcall.init : {
-		__initcall_start = .;
-		INITCALLS
-		__initcall_end = .;
-	}
-
-	.con_initcall.init : {
-		__con_initcall_start = .;
-		*(.con_initcall.init)
-		__con_initcall_end = .;
-	}
-	SECURITY_INIT
+	INIT_TEXT_SECTION(PAGE_SIZE)
+	INIT_DATA_SECTION(16)
 
 	/* .exit.text is discarded at runtime, not link time, to deal with
 	 * references from .rodata
@@ -121,28 +78,10 @@ SECTIONS
 	.exit.data : {
 		EXIT_DATA
 	}
-#if defined(CONFIG_BLK_DEV_INITRD)
-	.init.ramfs ALIGN(4096): {
-		__initramfs_start = .;
-		*(.init.ramfs)
-		__initramfs_end = .;
-		. = ALIGN(4);
-		LONG(0);
-	}
-#endif
-	. = ALIGN(4096);
+	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
 	/* freed after init ends here */
 
-	__bss_start = .;	/* BSS */
-	.sbss  : {
-		*(.sbss)
-		*(.scommon)
-	}
-	.bss : {
-		*(.bss)
-		*(COMMON)
-	}
-	__bss_stop = .;
+	BSS_SECTION(0, 0, 0)
 	_end = .;
 }
-- 
1.6.3.3

