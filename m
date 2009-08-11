Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbZHKVGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbZHKVGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 17:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbZHKVGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 17:06:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57624 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754371AbZHKVGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 17:06:16 -0400
Date: Tue, 11 Aug 2009 17:06:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] Add kerneldoc for flush_scheduled_work()
Message-ID: <Pine.LNX.4.44L0.0908111659510.5845-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1279) adds kerneldoc for flush_scheduled_work()
containing a stern warning that the function should be avoided.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/kernel/workqueue.c
===================================================================
--- usb-2.6.orig/kernel/workqueue.c
+++ usb-2.6/kernel/workqueue.c
@@ -739,6 +739,24 @@ int schedule_on_each_cpu(work_func_t fun
 	return 0;
 }
 
+/**
+ * flush_scheduled_work - ensure that all work scheduled on keventd_wq has run to completion.
+ *
+ * Blocks until all works on the keventd_wq global workqueue have completed.
+ * We sleep until all works present upon entry have been handled, but we
+ * are not livelocked by new incoming ones.
+ *
+ * Use of this function is discouraged, as it is highly prone to deadlock.
+ * It should never be called from within a work routine on the global
+ * queue, and it should never be called while holding a mutex required
+ * by one of the works on the global queue.  But the fact that keventd_wq
+ * _is_ global means that it can contain works requiring practically any
+ * mutex.  Hence this routine shouldn't be called while holding any mutex.
+ *
+ * Consider using cancel_work_sync() or cancel_delayed_work_sync() instead.
+ * They don't do the same thing (they cancel the work instead of waiting
+ * for it to complete), but in most cases they will suffice.
+ */
 void flush_scheduled_work(void)
 {
 	flush_workqueue(keventd_wq);

