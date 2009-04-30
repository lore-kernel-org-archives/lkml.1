Return-Path: <linux-kernel-owner+w=401wt.eu-S1761318AbZD3XsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761318AbZD3XsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760260AbZD3XqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:46:25 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59279 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757271AbZD3XqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:46:24 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 1/2] h8300: use new macros for .data.init_task.
Date: Thu, 30 Apr 2009 19:46:14 -0400
Message-Id: <1241135175-8183-2-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135175-8183-1-git-send-email-tabbott@mit.edu>
References: <1241135175-8183-1-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---
 arch/h8300/kernel/init_task.c   |    3 +--
 arch/h8300/kernel/vmlinux.lds.S |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/h8300/kernel/init_task.c b/arch/h8300/kernel/init_task.c
index cb5dc55..b90e371 100644
--- a/arch/h8300/kernel/init_task.c
+++ b/arch/h8300/kernel/init_task.c
@@ -35,7 +35,6 @@ EXPORT_SYMBOL(init_task);
  * way process stacks are handled. This is done by having a special
  * "init_task" linker map entry..
  */
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+union thread_union init_thread_union __init_task_data =
 		{ INIT_THREAD_INFO(init_task) };
 
diff --git a/arch/h8300/kernel/vmlinux.lds.S b/arch/h8300/kernel/vmlinux.lds.S
index 43a87b9..33a562c 100644
--- a/arch/h8300/kernel/vmlinux.lds.S
+++ b/arch/h8300/kernel/vmlinux.lds.S
@@ -100,8 +100,7 @@ SECTIONS
 	__sdata = . ;
 	___data_start = . ;
 
-	. = ALIGN(0x2000) ;
-		*(.data.init_task)
+		INIT_TASK_DATA(0x2000)
 	. = ALIGN(0x4) ;
 		DATA_DATA
 	. = ALIGN(0x4) ;
-- 
1.6.2.1

