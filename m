Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbXJAF5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbXJAF5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 01:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbXJAFxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 01:53:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:56802 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754554AbXJAFxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 01:53:16 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19VRxQSfD5Vw7PZCIXIsNANXQUkKnuuwhOY6kRGqr
	HXOiorigcxkF3N
Subject: Re: [git] CFS-devel, latest code
From: Mike Galbraith <efault@gmx.de>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <1191179736.6417.10.camel@earth>
References: <1191179736.6417.10.camel@earth>
Content-Type: text/plain
Date: Mon, 01 Oct 2007 07:53:13 +0200
Message-Id: <1191217993.28797.5.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-30 at 21:15 +0200, Dmitry Adamushko wrote:
> 
> remove obsolete code -- calc_weighted()
> 

Here's another piece of low hanging obsolete fruit.

Remove obsolete TASK_NONINTERACTIVE.

Signed-off-by: Mike Galbraith <efault@gmx.de>

diff -uprNX /root/dontdiff git/linux-2.6.sched-devel/fs/pipe.c linux-2.6.23-rc8.d/fs/pipe.c
--- git/linux-2.6.sched-devel/fs/pipe.c	2007-10-01 06:59:51.000000000 +0200
+++ linux-2.6.23-rc8.d/fs/pipe.c	2007-10-01 07:41:17.000000000 +0200
@@ -45,8 +45,7 @@ void pipe_wait(struct pipe_inode_info *p
 	 * Pipes are system-local resources, so sleeping on them
 	 * is considered a noninteractive wait:
 	 */
-	prepare_to_wait(&pipe->wait, &wait,
-			TASK_INTERRUPTIBLE | TASK_NONINTERACTIVE);
+	prepare_to_wait(&pipe->wait, &wait, TASK_INTERRUPTIBLE);
 	if (pipe->inode)
 		mutex_unlock(&pipe->inode->i_mutex);
 	schedule();
diff -uprNX /root/dontdiff git/linux-2.6.sched-devel/include/linux/sched.h linux-2.6.23-rc8.d/include/linux/sched.h
--- git/linux-2.6.sched-devel/include/linux/sched.h	2007-10-01 07:00:25.000000000 +0200
+++ linux-2.6.23-rc8.d/include/linux/sched.h	2007-10-01 07:25:25.000000000 +0200
@@ -174,8 +174,7 @@ print_cfs_rq(struct seq_file *m, int cpu
 #define EXIT_ZOMBIE		16
 #define EXIT_DEAD		32
 /* in tsk->state again */
-#define TASK_NONINTERACTIVE	64
-#define TASK_DEAD		128
+#define TASK_DEAD		64
 
 #define __set_task_state(tsk, state_value)		\
 	do { (tsk)->state = (state_value); } while (0)


