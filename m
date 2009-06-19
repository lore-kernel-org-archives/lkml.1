Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbZFSA4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbZFSA4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 20:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZFSA4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 20:56:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60285 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbZFSA4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 20:56:01 -0400
Date: Fri, 19 Jun 2009 02:51:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH] trivial, update the comment in kthread_stop()
Message-ID: <20090619005113.GA12208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"kthreads: rework kthread_stop()"
commit 63706172f332fd3f6e7458ebfb35fa6de9c21dc5 removed the limitation,
but forgot to update the comment.

Since that commit it is OK to use kthread_stop() even if kthread can exit
itself.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -180,10 +180,12 @@ EXPORT_SYMBOL(kthread_bind);
  * @k: thread created by kthread_create().
  *
  * Sets kthread_should_stop() for @k to return true, wakes it, and
- * waits for it to exit.  Your threadfn() must not call do_exit()
- * itself if you use this function!  This can also be called after
- * kthread_create() instead of calling wake_up_process(): the thread
- * will exit without calling threadfn().
+ * waits for it to exit. This can also be called after kthread_create()
+ * instead of calling wake_up_process(): the thread will exit without
+ * calling threadfn().
+ *
+ * If threadfn() may call do_exit() itself, the caller must ensure
+ * task_struct can't go away.
  *
  * Returns the result of threadfn(), or %-EINTR if wake_up_process()
  * was never called.

