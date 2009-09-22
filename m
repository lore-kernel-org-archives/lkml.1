Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbZIVRAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbZIVRAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 13:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756594AbZIVRAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 13:00:13 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:50553 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756602AbZIVRAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 13:00:12 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Greg Ungerer <gerg@uclinux.org>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>, Greg Ungerer <gerg@uclinux.org>
Subject: [PATCH v2 2/2] m68knommu: Clean up linker script using new linker script macros.
Date: Tue, 22 Sep 2009 12:56:55 -0400
Message-Id: <1253638615-27009-3-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253638615-27009-1-git-send-email-tabbott@ksplice.com>
References: <1253638615-27009-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Greg Ungerer <gerg@uclinux.org>
---
 arch/m68knommu/kernel/vmlinux.lds.S |   41 +++++++++-------------------------
 1 files changed, 11 insertions(+), 30 deletions(-)

diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
index 2736a5e..b236133 100644
--- a/arch/m68knommu/kernel/vmlinux.lds.S
+++ b/arch/m68knommu/kernel/vmlinux.lds.S
@@ -8,6 +8,8 @@
  */
 
 #include <asm-generic/vmlinux.lds.h>
+#include <asm/page.h>
+#include <asm/thread_info.h>
 
 #if defined(CONFIG_RAMKERNEL)
 #define	RAM_START	CONFIG_KERNELBASE
@@ -147,40 +149,19 @@ SECTIONS {
 		. = ALIGN(4);
 		_sdata = . ;
 		DATA_DATA
-		. = ALIGN(32);
-		*(.data.cacheline_aligned)
-		. = ALIGN(8192) ;
-		*(.data.init_task)
+		CACHELINE_ALIGNED_DATA(32)
+		INIT_TASK_DATA(THREAD_SIZE)
 		_edata = . ;
 	} > DATA
 
-	.init : {
-		. = ALIGN(4096);
+	.init_begin : {
+		. = ALIGN(PAGE_SIZE);
 		__init_begin = .;
-		_sinittext = .;
-		INIT_TEXT
-		_einittext = .;
-		INIT_DATA
-		. = ALIGN(16);
-		__setup_start = .;
-		*(.init.setup)
-		__setup_end = .;
-		__initcall_start = .;
-		INITCALLS
-		__initcall_end = .;
-		__con_initcall_start = .;
-		*(.con_initcall.init)
-		__con_initcall_end = .;
-		__security_initcall_start = .;
-		*(.security_initcall.init)
-		__security_initcall_end = .;
-#ifdef CONFIG_BLK_DEV_INITRD
-		. = ALIGN(4);
-		__initramfs_start = .;
-		*(.init.ramfs)
-		__initramfs_end = .;
-#endif
-		. = ALIGN(4096);
+	} > INIT
+	INIT_TEXT_SECTION(PAGE_SIZE) > INIT
+	INIT_DATA_SECTION(16) > INIT
+	.init_end : {
+		. = ALIGN(PAGE_SIZE);
 		__init_end = .;
 	} > INIT
 
-- 
1.6.3.3

