Return-Path: <linux-kernel-owner+w=401wt.eu-S933668AbZEAAab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933668AbZEAAab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765698AbZEAAHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:07:21 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61966 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765685AbZEAAHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:07:20 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH] um: use new macros for .data.init_task.
Date: Thu, 30 Apr 2009 19:59:46 -0400
Message-Id: <1241135986-10051-2-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135986-10051-1-git-send-email-tabbott@mit.edu>
References: <1241135986-10051-1-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: user-mode-linux-devel@lists.sourceforge.net
---
 arch/um/kernel/dyn.lds.S   |    3 +--
 arch/um/kernel/init_task.c |    3 +--
 arch/um/kernel/uml.lds.S   |    3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/um/kernel/dyn.lds.S b/arch/um/kernel/dyn.lds.S
index 9975e1a..901f703 100644
--- a/arch/um/kernel/dyn.lds.S
+++ b/arch/um/kernel/dyn.lds.S
@@ -96,8 +96,7 @@ SECTIONS
   .init_array     : { *(.init_array) }
   .fini_array     : { *(.fini_array) }
   .data           : {
-    . = ALIGN(KERNEL_STACK_SIZE);		/* init_task */
-    *(.data.init_task)
+    INIT_TASK_DATA(KERNEL_STACK_SIZE)
     . = ALIGN(KERNEL_STACK_SIZE);
     *(.data.init_irqstack)
     DATA_DATA
diff --git a/arch/um/kernel/init_task.c b/arch/um/kernel/init_task.c
index 806d381..0d4657f 100644
--- a/arch/um/kernel/init_task.c
+++ b/arch/um/kernel/init_task.c
@@ -33,8 +33,7 @@ EXPORT_SYMBOL(init_task);
  * "init_task" linker map entry..
  */
 
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+union thread_union init_thread_union __init_task_data =
 		{ INIT_THREAD_INFO(init_task) };
 
 union thread_union cpu0_irqstack
diff --git a/arch/um/kernel/uml.lds.S b/arch/um/kernel/uml.lds.S
index 11b8352..e4394a5 100644
--- a/arch/um/kernel/uml.lds.S
+++ b/arch/um/kernel/uml.lds.S
@@ -52,8 +52,7 @@ SECTIONS
   init.data : { INIT_DATA }
   .data    :
   {
-    . = ALIGN(KERNEL_STACK_SIZE);		/* init_task */
-    *(.data.init_task)
+    INIT_TASK_DATA(KERNEL_STACK_SIZE)
     . = ALIGN(KERNEL_STACK_SIZE);
     *(.data.init_irqstack)
     DATA_DATA
-- 
1.6.2.1

