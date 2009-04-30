Return-Path: <linux-kernel-owner+w=401wt.eu-S1759344AbZD3XpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344AbZD3XpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758326AbZD3XoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:44:14 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58862 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758374AbZD3XoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:44:13 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 5/6] arm: use new macros for .data.init_task.
Date: Thu, 30 Apr 2009 19:40:07 -0400
Message-Id: <1241134808-7583-6-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241134808-7583-5-git-send-email-tabbott@mit.edu>
References: <1241134808-7583-1-git-send-email-tabbott@mit.edu>
 <1241134808-7583-2-git-send-email-tabbott@mit.edu>
 <1241134808-7583-3-git-send-email-tabbott@mit.edu>
 <1241134808-7583-4-git-send-email-tabbott@mit.edu>
 <1241134808-7583-5-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/kernel/init_task.c   |    3 +--
 arch/arm/kernel/vmlinux.lds.S |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/init_task.c b/arch/arm/kernel/init_task.c
index e859af3..f3c4aac 100644
--- a/arch/arm/kernel/init_task.c
+++ b/arch/arm/kernel/init_task.c
@@ -28,8 +28,7 @@ EXPORT_SYMBOL(init_mm);
  *
  * The things we do for performance..
  */
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+union thread_union init_thread_union __init_task_data =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index a9bd142..eede3be 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -145,7 +145,7 @@ SECTIONS
 		 * first, the init task union, aligned
 		 * to an 8192 byte boundary.
 		 */
-		*(.data.init_task)
+		INIT_TASK_DATA(THREAD_SIZE)
 
 #ifdef CONFIG_XIP_KERNEL
 		. = ALIGN(4096);
-- 
1.6.2.1

