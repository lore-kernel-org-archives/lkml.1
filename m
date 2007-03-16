Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbXCPNwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbXCPNwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 09:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933773AbXCPNwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 09:52:21 -0400
Received: from mail04.syd.optusnet.com.au ([211.29.132.185]:59441 "EHLO
	mail04.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932344AbXCPNwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 09:52:20 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH][RSDL-mm 3/6] sched: remove noninteractive flag
Date: Sat, 17 Mar 2007 00:53:27 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1914
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703170053.27695.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Con Kolivas <kernel@kolivas.org>

Remove the TASK_NONINTERACTIVE flag as it will no longer be used.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c             |    7 +------
 include/linux/sched.h |    3 +--
 2 files changed, 2 insertions(+), 8 deletions(-)

Index: linux-2.6.21-rc3-mm2/fs/pipe.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/fs/pipe.c	2007-03-16 23:27:49.000000000 +1100
+++ linux-2.6.21-rc3-mm2/fs/pipe.c	2007-03-16 23:27:51.000000000 +1100
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
Index: linux-2.6.21-rc3-mm2/include/linux/sched.h
===================================================================
--- linux-2.6.21-rc3-mm2.orig/include/linux/sched.h	2007-03-16 23:27:49.000000000 +1100
+++ linux-2.6.21-rc3-mm2/include/linux/sched.h	2007-03-16 23:27:51.000000000 +1100
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
