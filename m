Return-Path: <linux-kernel-owner+w=401wt.eu-S933096AbXHKTJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096AbXHKTJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764144AbXHKTBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 15:01:36 -0400
Received: from 1wt.eu ([62.212.114.60]:1627 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764109AbXHKTBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 15:01:34 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184831.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:47:56 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 04/28] make freezeable workqueues singlethread
Content-Disposition: inline; filename=0004-PATCH-make-freezeable-workqueues-singlethread.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It is a known fact that freezeable multithreaded workqueues doesn't like
CPU_DEAD. We keep them only for the incoming CPU-hotplug rework.

Sadly, we can't just kill create_freezeable_workqueue() right now, make
them singlethread.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/workqueue.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 2a7b38d..1a76bda 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -162,7 +162,7 @@ extern struct workqueue_struct *__create_workqueue(const char *name,
 						    int singlethread,
 						    int freezeable);
 #define create_workqueue(name) __create_workqueue((name), 0, 0)
-#define create_freezeable_workqueue(name) __create_workqueue((name), 0, 1)
+#define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1)
 #define create_singlethread_workqueue(name) __create_workqueue((name), 1, 0)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
-- 
1.5.2.4

-- 
