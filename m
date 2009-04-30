Return-Path: <linux-kernel-owner+w=401wt.eu-S1757864AbZD3Xn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864AbZD3Xn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757467AbZD3Xm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:42:58 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58699 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757412AbZD3Xm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:42:57 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Tim Abbott <tabbott@MIT.EDU>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH 3/3] avr32: use new macros for .data.init_task.
Date: Thu, 30 Apr 2009 19:42:39 -0400
Message-Id: <1241134959-7735-4-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241134959-7735-3-git-send-email-tabbott@mit.edu>
References: <1241134959-7735-1-git-send-email-tabbott@mit.edu>
 <1241134959-7735-2-git-send-email-tabbott@mit.edu>
 <1241134959-7735-3-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 arch/avr32/kernel/init_task.c   |    3 +--
 arch/avr32/kernel/vmlinux.lds.S |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/avr32/kernel/init_task.c b/arch/avr32/kernel/init_task.c
index 993d56e..3533d6f 100644
--- a/arch/avr32/kernel/init_task.c
+++ b/arch/avr32/kernel/init_task.c
@@ -22,8 +22,7 @@ EXPORT_SYMBOL(init_mm);
 /*
  * Initial thread structure. Must be aligned on an 8192-byte boundary.
  */
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+union thread_union init_thread_union __init_task_data =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
diff --git a/arch/avr32/kernel/vmlinux.lds.S b/arch/avr32/kernel/vmlinux.lds.S
index 21fb7b2..2789c60 100644
--- a/arch/avr32/kernel/vmlinux.lds.S
+++ b/arch/avr32/kernel/vmlinux.lds.S
@@ -95,7 +95,7 @@ SECTIONS
 		/*
 		 * First, the init task union, aligned to an 8K boundary.
 		 */
-		*(.data.init_task)
+		INIT_TASK_DATA(THREAD_SIZE)
 
 		/* Then, the page-aligned data */
 		PAGE_ALIGNED_DATA
-- 
1.6.2.1

