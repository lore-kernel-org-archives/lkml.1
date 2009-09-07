Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbZIGDGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbZIGDGx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 23:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758616AbZIGDGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 23:06:52 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60257 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758611AbZIGDGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 23:06:52 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>,
       Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, dev-etrax@axis.com
Subject: [PATCH] cris: Cleanup linker script using new linker script macros.
Date: Sun,  6 Sep 2009 23:06:33 -0400
Message-Id: <1252292793-12674-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: dev-etrax@axis.com
---
 arch/cris/kernel/vmlinux.lds.S |   41 +++++++--------------------------------
 1 files changed, 8 insertions(+), 33 deletions(-)

diff --git a/arch/cris/kernel/vmlinux.lds.S b/arch/cris/kernel/vmlinux.lds.S
index 0d2adfc..bb44ae5 100644
--- a/arch/cris/kernel/vmlinux.lds.S
+++ b/arch/cris/kernel/vmlinux.lds.S
@@ -51,61 +51,40 @@ SECTIONS
 	_etext = . ;			/* End of text section. */
 	__etext = .;
 
-	. = ALIGN(4);			/* Exception table. */
-	__start___ex_table = .;
-	__ex_table : { *(__ex_table) }
-	__stop___ex_table = .;
+	EXCEPTION_TABLE(4)
 
 	RODATA
 
 	. = ALIGN (4);
 	___data_start = . ;
 	__Sdata = . ;
-	.data : {			/* Data */
-		DATA_DATA
-	}
+	RW_DATA_SECTION(0, PAGE_SIZE, PAGE_SIZE)
 	__edata = . ;			/* End of data section. */
 	_edata = . ;
 
-	. = ALIGN(PAGE_SIZE);	/* init_task and stack, must be aligned. */
-	.data.init_task : { *(.data.init_task) }
-
 	. = ALIGN(PAGE_SIZE);		/* Init code and data. */
 	__init_begin = .;
-	.init.text : {
-		   _sinittext = .;
-		   INIT_TEXT
-		   _einittext = .;
-	}
+	INIT_TEXT_SECTION(PAGE_SIZE)
 	.init.data : { INIT_DATA }
-	. = ALIGN(16);
-	__setup_start = .;
-	.init.setup : { *(.init.setup) }
-	__setup_end = .;
+	.init.setup : { INIT_SETUP(16) }
 #ifdef CONFIG_ETRAX_ARCH_V32
 	__start___param = .;
 	__param : { *(__param) }
 	__stop___param = .;
 #endif
 	.initcall.init : {
-		__initcall_start = .;
-		INITCALLS
-		__initcall_end = .;
+		INIT_CALLS
 	}
 
 	.con_initcall.init : {
-		__con_initcall_start = .;
-		*(.con_initcall.init)
-		__con_initcall_end = .;
+		CON_INITCALL
 	}
 	SECURITY_INIT
 
 #ifdef CONFIG_ETRAX_ARCH_V10
 #ifdef CONFIG_BLK_DEV_INITRD
 	.init.ramfs : {
-		__initramfs_start = .;
-		*(.init.ramfs)
-		__initramfs_end = .;
+		INIT_RAM_FS
 	}
 #endif
 #endif
@@ -130,11 +109,7 @@ SECTIONS
 	__init_end = .;
 
 	__data_end = . ;		/* Move to _edata ? */
-	__bss_start = .;		/* BSS. */
-	.bss : {
-		*(COMMON)
-		*(.bss)
-	}
+	BSS_SECTION(0, 0, 0)
 
 	. =  ALIGN (0x20);
 	_end = .;
-- 
1.6.3.3

