Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbZIVOXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbZIVOXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbZIVOXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:23:34 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:56590 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756693AbZIVOXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:23:33 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH 12/13] h8300: Cleanup linker script using new linker script macros.
Date: Tue, 22 Sep 2009 10:22:26 -0400
Message-Id: <1253629347-23119-13-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253629347-23119-1-git-send-email-tabbott@ksplice.com>
References: <1253629347-23119-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/h8300/kernel/vmlinux.lds.S |   25 +++++++------------------
 1 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/arch/h8300/kernel/vmlinux.lds.S b/arch/h8300/kernel/vmlinux.lds.S
index 662b02e..b9e2490 100644
--- a/arch/h8300/kernel/vmlinux.lds.S
+++ b/arch/h8300/kernel/vmlinux.lds.S
@@ -1,5 +1,6 @@
 #define VMLINUX_SYMBOL(_sym_) _##_sym_
 #include <asm-generic/vmlinux.lds.h>
+#include <asm/page.h>
 
 /* target memory map */
 #ifdef CONFIG_H8300H_GENERIC
@@ -79,11 +80,8 @@ SECTIONS
 	SCHED_TEXT
 	LOCK_TEXT
 	__etext = . ;
-	. = ALIGN(16);          /* Exception table              */
-	___start___ex_table = .;
-		*(__ex_table)
-	___stop___ex_table = .;
 	}
+	EXCEPTION_TABLE(16)
 
 	RODATA
 #if defined(CONFIG_ROMKERNEL)
@@ -100,8 +98,7 @@ SECTIONS
 	__sdata = . ;
 	___data_start = . ;
 
-	. = ALIGN(0x2000) ;
-		*(.data.init_task)
+	INIT_TASK_DATA(0x2000)
 	. = ALIGN(0x4) ;
 		DATA_DATA
 	. = ALIGN(0x4) ;
@@ -114,24 +111,16 @@ SECTIONS
 	__einittext = .; 
 		INIT_DATA
 	. = ALIGN(0x4) ;
+	INIT_SETUP(0x4)
 	___setup_start = .;
 		*(.init.setup)
 	. = ALIGN(0x4) ;
 	___setup_end = .;
-	___initcall_start = .;
-		INITCALLS
-	___initcall_end = .;
-	___con_initcall_start = .;
-		*(.con_initcall.init)
-	___con_initcall_end = .;
+	INIT_CALLS
+	CON_INITCALL
 		EXIT_TEXT
 		EXIT_DATA
-#if defined(CONFIG_BLK_DEV_INITRD)
-		. = ALIGN(4);
-	___initramfs_start = .;
-  		*(.init.ramfs)
-  	___initramfs_end = .;
-#endif
+	INIT_RAM_FS
 	. = ALIGN(0x4) ;
 	___init_end = .;
 	__edata = . ;
-- 
1.6.3.3

