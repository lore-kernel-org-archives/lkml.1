Return-Path: <linux-kernel-owner+w=401wt.eu-S1752690AbZIXOg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbZIXOg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbZIXOg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:36:57 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:33042 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512AbZIXOg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:36:56 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v2 07/11] mn10300: Clean up linker script using higher-level macros.
Date: Thu, 24 Sep 2009 10:36:22 -0400
Message-Id: <1253802986-8132-8-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253802986-8132-1-git-send-email-tabbott@ksplice.com>
References: <1253802986-8132-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/mn10300/kernel/vmlinux.lds.S |   40 +++---------------------------------
 1 files changed, 4 insertions(+), 36 deletions(-)

diff --git a/arch/mn10300/kernel/vmlinux.lds.S b/arch/mn10300/kernel/vmlinux.lds.S
index 76f41bd..10549dc 100644
--- a/arch/mn10300/kernel/vmlinux.lds.S
+++ b/arch/mn10300/kernel/vmlinux.lds.S
@@ -44,24 +44,8 @@ SECTIONS
   RO_DATA(PAGE_SIZE)
 
   /* writeable */
-  .data : {			/* Data */
-	DATA_DATA
-	CONSTRUCTORS
-	}
-
-  .data_nosave : { NOSAVE_DATA; }
-
-  .data.page_aligned : { PAGE_ALIGNED_DATA(PAGE_SIZE); }
-  .data.cacheline_aligned : { CACHELINE_ALIGNED_DATA(32); }
-
-  /* rarely changed data like cpu maps */
-  . = ALIGN(32);
-  .data.read_mostly : AT(ADDR(.data.read_mostly)) {
-	READ_MOSTLY_DATA(32);
-	_edata = .;		/* End of data section */
-  }
-
-  .data.init_task : { INIT_TASK_DATA(THREAD_SIZE); }
+  RW_DATA_SECTION(32, PAGE_SIZE, THREAD_SIZE)
+  _edata = .;
 
   /* might get freed after init */
   . = ALIGN(PAGE_SIZE);
@@ -74,22 +58,8 @@ SECTIONS
   /* will be freed after init */
   . = ALIGN(PAGE_SIZE);		/* Init code and data */
   __init_begin = .;
-  .init.text : {
-	_sinittext = .;
-	INIT_TEXT;
-	_einittext = .;
-  }
-  .init.data : { INIT_DATA; }
-  .setup.init : { INIT_SETUP(16); }
-
-  __initcall_start = .;
-  .initcall.init : {
-	INITCALLS
-  }
-  __initcall_end = .;
-  .con_initcall.init : { CON_INITCALL; }
-
-  SECURITY_INIT
+  INIT_TEXT_SECTION(PAGE_SIZE)
+  INIT_DATA_SECTION(16)
   . = ALIGN(4);
   __alt_instructions = .;
   .altinstructions : { *(.altinstructions) }
@@ -100,8 +70,6 @@ SECTIONS
 	.exit.text : { EXIT_TEXT; }
 	.exit.data : { EXIT_DATA; }
 
-  .init.ramfs : { INIT_RAM_FS; }
-
   PERCPU(32)
   . = ALIGN(PAGE_SIZE);
   __init_end = .;
-- 
1.6.3.3

