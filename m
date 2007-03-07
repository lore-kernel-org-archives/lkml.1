Return-Path: <linux-kernel-owner+w=401wt.eu-S1161159AbXCGBnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161159AbXCGBnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 20:43:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161161AbXCGBms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 20:42:48 -0500
Received: from mail32.syd.optusnet.com.au ([211.29.132.63]:60403 "EHLO
	mail32.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161148AbXCGBm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 20:42:29 -0500
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
Subject: [PATCH] [RSDL-mm 3/6] sched: remove noninteractive flag
Date: Wed, 7 Mar 2007 12:27:37 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2098
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703071227.37976.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the TASK_NONINTERACTIVE flag as it will no longer be used.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 fs/pipe.c             |    7 +------
 include/linux/sched.h |    3 +--
 2 files changed, 2 insertions(+), 8 deletions(-)

Index: linux-2.6.21-rc2-mm2/fs/pipe.c
===================================================================
--- linux-2.6.21-rc2-mm2.orig/fs/pipe.c	2007-03-07 11:20:58.000000000 +1100
+++ linux-2.6.21-rc2-mm2/fs/pipe.c	2007-03-07 11:22:59.000000000 +1100
@@ -41,12 +41,7 @@ void pipe_wait(struct pipe_inode_info *p
 {
 	DEFINE_WAIT(wait);
 
-	/*
-	 * Pipes are system-local resources, so sleeping on them
-	 * is considered a noninteractive wait:
-	 */
-	prepare_to_wait(&pipe->wait, &wait,
-			TASK_INTERRUPTIBLE | TASK_NONINTERACTIVE);
+	prepare_to_wait(&pipe->wait, &wait, TASK_INTERRUPTIBLE);
 	if (pipe->inode)
 		mutex_unlock(&pipe->inode->i_mutex);
 	schedule();
Index: linux-2.6.21-rc2-mm2/include/linux/sched.h
===================================================================
--- linux-2.6.21-rc2-mm2.orig/include/linux/sched.h	2007-03-07 11:21:15.000000000 +1100
+++ linux-2.6.21-rc2-mm2/include/linux/sched.h	2007-03-07 11:22:59.000000000 +1100
@@ -150,8 +150,7 @@ extern unsigned long weighted_cpuload(co
 #define EXIT_ZOMBIE		16
 #define EXIT_DEAD		32
 /* in tsk->state again */
-#define TASK_NONINTERACTIVE	64
-#define TASK_DEAD		128
+#define TASK_DEAD		64
 
 #define __set_task_state(tsk, state_value)		\
 	do { (tsk)->state = (state_value); } while (0)

-- 
-ck
