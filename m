Return-Path: <linux-kernel-owner+w=401wt.eu-S933323AbZEAAY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323AbZEAAY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763835AbZEAAFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:05:21 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62259 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761719AbZEAAFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:05:20 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>, linux-sh@vger.kernel.org
Subject: [PATCH 5/7] sh: use new macros for .data.init_task.
Date: Thu, 30 Apr 2009 19:58:01 -0400
Message-Id: <1241135883-9766-6-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135883-9766-5-git-send-email-tabbott@mit.edu>
References: <1241135883-9766-1-git-send-email-tabbott@mit.edu>
 <1241135883-9766-2-git-send-email-tabbott@mit.edu>
 <1241135883-9766-3-git-send-email-tabbott@mit.edu>
 <1241135883-9766-4-git-send-email-tabbott@mit.edu>
 <1241135883-9766-5-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
---
 arch/sh/kernel/init_task.c      |    3 +--
 arch/sh/kernel/vmlinux_32.lds.S |    3 +--
 arch/sh/kernel/vmlinux_64.lds.S |    3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/sh/kernel/init_task.c b/arch/sh/kernel/init_task.c
index 80c35ff..9522d9a 100644
--- a/arch/sh/kernel/init_task.c
+++ b/arch/sh/kernel/init_task.c
@@ -20,8 +20,7 @@ EXPORT_SYMBOL(init_mm);
  * way process stacks are handled. This is done by having a special
  * "init_task" linker map entry..
  */
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+union thread_union init_thread_union __init_task_data =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
diff --git a/arch/sh/kernel/vmlinux_32.lds.S b/arch/sh/kernel/vmlinux_32.lds.S
index eabb0bb..7a0f3c4 100644
--- a/arch/sh/kernel/vmlinux_32.lds.S
+++ b/arch/sh/kernel/vmlinux_32.lds.S
@@ -59,9 +59,8 @@ SECTIONS
 	.uncached.data : { *(.uncached.data) }
 	__uncached_end = .;
 
-	. = ALIGN(THREAD_SIZE);
 	.data : {			/* Data */
-		*(.data.init_task)
+		INIT_TASK_DATA(THREAD_SIZE)
 
 		. = ALIGN(L1_CACHE_BYTES);
 		*(.data.read_mostly)
diff --git a/arch/sh/kernel/vmlinux_64.lds.S b/arch/sh/kernel/vmlinux_64.lds.S
index e0e2e1b..5cd3e78 100644
--- a/arch/sh/kernel/vmlinux_64.lds.S
+++ b/arch/sh/kernel/vmlinux_64.lds.S
@@ -68,9 +68,8 @@ SECTIONS
 	NOTES 
 	RO_DATA(PAGE_SIZE)
 
-	. = ALIGN(THREAD_SIZE);
 	.data : C_PHYS(.data) {			/* Data */
-		*(.data.init_task)
+		INIT_TASK_DATA(THREAD_SIZE)
 
 		. = ALIGN(L1_CACHE_BYTES);
 		*(.data.read_mostly)
-- 
1.6.2.1

