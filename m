Return-Path: <linux-kernel-owner+w=401wt.eu-S1765065AbZEAABe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765065AbZEAABe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbZD3X4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:56:35 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60937 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764831AbZD3X4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:56:34 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 3/4] mips: use new macros for .data.init_task.
Date: Thu, 30 Apr 2009 19:53:29 -0400
Message-Id: <1241135610-9012-4-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135610-9012-3-git-send-email-tabbott@mit.edu>
References: <1241135610-9012-1-git-send-email-tabbott@mit.edu>
 <1241135610-9012-2-git-send-email-tabbott@mit.edu>
 <1241135610-9012-3-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/kernel/init_task.c   |    5 ++---
 arch/mips/kernel/vmlinux.lds.S |    3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/mips/kernel/init_task.c b/arch/mips/kernel/init_task.c
index 149cd91..30051b4 100644
--- a/arch/mips/kernel/init_task.c
+++ b/arch/mips/kernel/init_task.c
@@ -25,9 +25,8 @@ EXPORT_SYMBOL(init_mm);
  *
  * The things we do for performance..
  */
-union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"),
-	               __aligned__(THREAD_SIZE))) =
+union thread_union init_thread_union __init_task_data
+	__attribute__((__aligned__(THREAD_SIZE))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index ba459cb..85085e3 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -76,8 +76,7 @@ SECTIONS
 		 * of ‘init_thread_union’ is greater than maximum
 		 * object file alignment.  Using 32768
 		 */
-		. = ALIGN(_PAGE_SIZE);
-		*(.data.init_task)
+		INIT_TASK_DATA(_PAGE_SIZE)
 		NOSAVE_DATA
 		CACHELINE_ALIGNED_DATA(1 << CONFIG_MIPS_L1_CACHE_SHIFT)
 		DATA_DATA
-- 
1.6.2.1

