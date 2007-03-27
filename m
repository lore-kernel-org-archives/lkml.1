Return-Path: <linux-kernel-owner+w=401wt.eu-S933946AbXC0CLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933946AbXC0CLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 22:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933945AbXC0CLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 22:11:44 -0400
Received: from mail31.syd.optusnet.com.au ([211.29.132.102]:58235 "EHLO
	mail31.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933946AbXC0CLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 22:11:43 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH][ 4/5] sched: remove noninteractive flag
Date: Tue, 27 Mar 2007 13:11:20 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1914
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703271211.20868.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the TASK_NONINTERACTIVE flag as it will no longer be used.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---

 fs/pipe.c             |    7 +------
 include/linux/sched.h |    3 +--
 2 files changed, 2 insertions(+), 8 deletions(-)

Index: linux-2.6.21-rc5-sd/fs/pipe.c
===================================================================
--- linux-2.6.21-rc5-sd.orig/fs/pipe.c	2007-03-26 11:03:31.000000000 +1000
+++ linux-2.6.21-rc5-sd/fs/pipe.c	2007-03-27 11:52:55.000000000 +1000
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
Index: linux-2.6.21-rc5-sd/include/linux/sched.h
===================================================================
--- linux-2.6.21-rc5-sd.orig/include/linux/sched.h	2007-03-27 11:52:55.000000000 +1000
+++ linux-2.6.21-rc5-sd/include/linux/sched.h	2007-03-27 11:52:55.000000000 +1000
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
