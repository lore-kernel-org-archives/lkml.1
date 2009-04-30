Return-Path: <linux-kernel-owner+w=401wt.eu-S1755644AbZD3X5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbZD3X5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763102AbZD3XyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:54:10 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60506 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764360AbZD3XyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:54:09 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Greg Ungerer <gerg@uclinux.org>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 2/2] m68knommu: use new macros for .data.init_task.
Date: Thu, 30 Apr 2009 19:50:12 -0400
Message-Id: <1241135412-8636-3-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135412-8636-2-git-send-email-tabbott@mit.edu>
References: <1241135412-8636-1-git-send-email-tabbott@mit.edu>
 <1241135412-8636-2-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Greg Ungerer <gerg@uclinux.org>
---
 arch/m68knommu/kernel/init_task.c   |    3 +--
 arch/m68knommu/kernel/vmlinux.lds.S |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/m68knommu/kernel/init_task.c b/arch/m68knommu/kernel/init_task.c
index fe282de..8b81092 100644
--- a/arch/m68knommu/kernel/init_task.c
+++ b/arch/m68knommu/kernel/init_task.c
@@ -35,7 +35,6 @@ EXPORT_SYMBOL(init_task);
  * way process stacks are handled. This is done by having a special
  * "init_task" linker map entry..
  */
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+union thread_union init_thread_union __init_task_data =
 		{ INIT_THREAD_INFO(init_task) };
 
diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
index f5154d9..9616d7a 100644
--- a/arch/m68knommu/kernel/vmlinux.lds.S
+++ b/arch/m68knommu/kernel/vmlinux.lds.S
@@ -146,10 +146,9 @@ SECTIONS {
 	.data DATA_ADDR : {
 		. = ALIGN(4);
 		_sdata = . ;
+		INIT_TASK_DATA(8192)
 		DATA_DATA
 		CACHELINE_ALIGNED_DATA(32)
-		. = ALIGN(8192) ;
-		*(.data.init_task)
 		_edata = . ;
 	} > DATA
 
-- 
1.6.2.1

