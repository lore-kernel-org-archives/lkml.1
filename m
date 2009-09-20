Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbZITRdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbZITRdv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 13:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbZITRdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 13:33:49 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52622 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754932AbZITRdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 13:33:49 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@sunplusct.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH 2/3] Make THREAD_SIZE available to assembly files.
Date: Sun, 20 Sep 2009 13:32:58 -0400
Message-Id: <1253467979-14110-3-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253467979-14110-1-git-send-email-tabbott@ksplice.com>
References: <1253467979-14110-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 arch/score/include/asm/thread_info.h |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/score/include/asm/thread_info.h b/arch/score/include/asm/thread_info.h
index 3a11228..5593999 100644
--- a/arch/score/include/asm/thread_info.h
+++ b/arch/score/include/asm/thread_info.h
@@ -7,6 +7,15 @@
 #define KU_USER	0x08
 #define KU_KERN	0x00
 
+#include <asm/page.h>
+#include <linux/const.h>
+
+/* thread information allocation */
+#define THREAD_SIZE_ORDER 	(1)
+#define THREAD_SIZE 		(PAGE_SIZE << THREAD_SIZE_ORDER)
+#define THREAD_MASK 		(THREAD_SIZE - _AC(1,UL))
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
 #ifndef __ASSEMBLY__
 
 #include <asm/processor.h>
@@ -62,12 +71,6 @@ struct thread_info {
 register struct thread_info *__current_thread_info __asm__("r28");
 #define current_thread_info()	__current_thread_info
 
-/* thread information allocation */
-#define THREAD_SIZE_ORDER 	(1)
-#define THREAD_SIZE 		(PAGE_SIZE << THREAD_SIZE_ORDER)
-#define THREAD_MASK 		(THREAD_SIZE - 1UL)
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
 #define alloc_thread_info(tsk) kmalloc(THREAD_SIZE, GFP_KERNEL)
 #define free_thread_info(info) kfree(info)
 
-- 
1.6.3.3

