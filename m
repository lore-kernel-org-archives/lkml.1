Return-Path: <linux-kernel-owner+w=401wt.eu-S1767289AbXDTWTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767289AbXDTWTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 18:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767290AbXDTWTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 18:19:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51644 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767289AbXDTWTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 18:19:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] freezer: Document task_lock in thaw_process
Date: Sat, 21 Apr 2007 00:23:19 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704210023.19825.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The task_lock() in include/linux/freezer.h:thaw_process() looks as though it
were protecting p->flags, which is not the case.  Add a comment that explains
why it's there.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/freezer.h |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6.21-rc6-mm1/include/linux/freezer.h
===================================================================
--- linux-2.6.21-rc6-mm1.orig/include/linux/freezer.h	2007-04-09 15:24:25.000000000 +0200
+++ linux-2.6.21-rc6-mm1/include/linux/freezer.h	2007-04-21 00:17:30.000000000 +0200
@@ -37,6 +37,12 @@ static inline void do_not_freeze(struct 
 
 /*
  * Wake up a frozen process
+ *
+ * task_lock() is taken to prevent the race with refrigerator() which may
+ * occur if the freezing of tasks fails.  Namely, without the lock, if the
+ * freezing of tasks failed, thaw_tasks() might have run before a task in
+ * refrigerator() could call frozen_process(), in which case the task would be
+ * frozen and no one would thaw it.
  */
 static inline int thaw_process(struct task_struct *p)
 {
