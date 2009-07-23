Return-Path: <linux-kernel-owner+w=401wt.eu-S1752276AbZGWONp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbZGWONp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbZGWONo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:13:44 -0400
Received: from ozlabs.org ([203.10.76.45]:54329 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbZGWONo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:13:44 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] update the comment in kthread_stop()
Date: Thu, 23 Jul 2009 23:43:37 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907232343.37783.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Fri, 19 Jun 2009 02:51:13 +0200
From: Oleg Nesterov <oleg@redhat.com>

"kthreads: rework kthread_stop()"
commit 63706172f332fd3f6e7458ebfb35fa6de9c21dc5 removed the limitation,
but forgot to update the comment.

Since that commit it is OK to use kthread_stop() even if kthread can exit
itself.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/kthread.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -u
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
