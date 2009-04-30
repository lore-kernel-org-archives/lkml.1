Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbZD3X4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbZD3X4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764380AbZD3XyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:54:09 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60504 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764386AbZD3XyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:54:08 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Hirokazu Takata <takata@linux-m32r.org>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 3/3] m32r: use new macros for .data.init_task.
Date: Thu, 30 Apr 2009 19:48:00 -0400
Message-Id: <1241135280-8333-4-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135280-8333-3-git-send-email-tabbott@mit.edu>
References: <1241135280-8333-1-git-send-email-tabbott@mit.edu>
 <1241135280-8333-2-git-send-email-tabbott@mit.edu>
 <1241135280-8333-3-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Hirokazu Takata <takata@linux-m32r.org>
---
 arch/m32r/kernel/init_task.c   |    3 +--
 arch/m32r/kernel/vmlinux.lds.S |    4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/m32r/kernel/init_task.c b/arch/m32r/kernel/init_task.c
index 016885c..a57c1e3 100644
--- a/arch/m32r/kernel/init_task.c
+++ b/arch/m32r/kernel/init_task.c
@@ -24,8 +24,7 @@ EXPORT_SYMBOL(init_mm);
  * way process stacks are handled. This is done by having a special
  * "init_task" linker map entry..
  */
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+union thread_union init_thread_union __init_task_data =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
diff --git a/arch/m32r/kernel/vmlinux.lds.S b/arch/m32r/kernel/vmlinux.lds.S
index 3e2de1f..655eaf1 100644
--- a/arch/m32r/kernel/vmlinux.lds.S
+++ b/arch/m32r/kernel/vmlinux.lds.S
@@ -51,6 +51,7 @@ SECTIONS
   .data : {			/* Data */
 	*(.spu)
 	*(.spi)
+	INIT_TASK_DATA(8192)
 	NOSAVE_DATA
 	CACHELINE_ALIGNED_DATA(32)
 	DATA_DATA
@@ -58,9 +59,6 @@ SECTIONS
 	}
   _edata = .;			/* End of data section */
 
-  . = ALIGN(8192);		/* init_task */
-  .data.init_task : { *(.data.init_task) }
-
   /* will be freed after init */
   . = ALIGN(4096);		/* Init code and data */
   __init_begin = .;
-- 
1.6.2.1

