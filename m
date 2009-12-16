Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbZLPPwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbZLPPwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbZLPPwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:52:23 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40242 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751123AbZLPPwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:52:22 -0500
Date: Wed, 16 Dec 2009 10:52:21 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: Oliver Neukum <oliver@neukum.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] Warn about flush_scheduled_work()
In-Reply-To: <4B26BE67.5060107@kernel.org>
Message-ID: <Pine.LNX.4.44L0.0912161051160.2909-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1319) adds kerneldoc and a pointed warning to
flush_scheduled_work().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/kernel/workqueue.c
===================================================================
--- usb-2.6.orig/kernel/workqueue.c
+++ usb-2.6/kernel/workqueue.c
@@ -720,6 +720,30 @@ int schedule_on_each_cpu(work_func_t fun
 	return 0;
 }
 
+/**
+ * flush_scheduled_work - ensure that any scheduled work has run to completion.
+ *
+ * Forces execution of the kernel-global workqueue and blocks until its
+ * completion.
+ *
+ * Think twice before calling this function!  It's very easy to get into
+ * trouble if you don't take great care.  Either of the following situations
+ * will lead to deadlock:
+ *
+ *	One of the work items currently on the workqueue needs to acquire
+ *	a lock held by your code or its caller.
+ *
+ *	Your code is running in the context of a work routine.
+ *
+ * They will be detected by lockdep when they occur, but the first might not
+ * occur very often.  It depends on what work items are on the workqueue and
+ * what locks they need, which you have no control over.
+ *
+ * In most situations flushing the entire workqueue is overkill; you merely
+ * need to know that a particular work item isn't queued and isn't running.
+ * In such cases you should use cancel_delayed_work_sync() or
+ * cancel_work_sync() instead.
+ */
 void flush_scheduled_work(void)
 {
 	flush_workqueue(keventd_wq);

