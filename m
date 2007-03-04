Return-Path: <linux-kernel-owner+w=401wt.eu-S1751448AbXCDHFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbXCDHFS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 02:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbXCDHFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 02:05:18 -0500
Received: from mail05.syd.optusnet.com.au ([211.29.132.186]:34739 "EHLO
	mail05.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448AbXCDHFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 02:05:17 -0500
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>
Subject: [PATCH] [RSDL 3/6] sched: remove noninteractive flag
Date: Sun, 4 Mar 2007 18:05:13 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2154
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703041805.14116.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the TASK_NONINTERACTIVE flag as it will no longer be used.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 fs/pipe.c             |    7 +------
 include/linux/sched.h |    3 +--
 2 files changed, 2 insertions(+), 8 deletions(-)

Index: linux-2.6.20-rsdl/fs/pipe.c
===================================================================
--- linux-2.6.20-rsdl.orig/fs/pipe.c	2007-03-04 17:30:25.000000000 +1100
+++ linux-2.6.20-rsdl/fs/pipe.c	2007-03-04 17:30:30.000000000 +1100
@@ -40,12 +40,7 @@ void pipe_wait(struct pipe_inode_info *p
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
Index: linux-2.6.20-rsdl/include/linux/sched.h
===================================================================
--- linux-2.6.20-rsdl.orig/include/linux/sched.h	2007-03-04 17:30:25.000000000 +1100
+++ linux-2.6.20-rsdl/include/linux/sched.h	2007-03-04 17:30:30.000000000 +1100
@@ -149,8 +149,7 @@ extern unsigned long weighted_cpuload(co
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
