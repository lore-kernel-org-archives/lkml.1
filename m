Return-Path: <linux-kernel-owner+w=401wt.eu-S939862AbXFHH4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939862AbXFHH4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967094AbXFHHZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:25:31 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55372 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938042AbXFHHZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:25:28 -0400
Message-Id: <20070608072150.486289000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:35 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@tv-sign.ru>,
       Gautham R Shenoy <ego@in.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 08/54] make freezeable workqueues singlethread
Content-Disposition: inline; filename=make-freezeable-workqueues-singlethread.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Oleg Nesterov <oleg@tv-sign.ru>

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
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.21.4.orig/include/linux/workqueue.h
+++ linux-2.6.21.4/include/linux/workqueue.h
@@ -162,7 +162,7 @@ extern struct workqueue_struct *__create
 						    int singlethread,
 						    int freezeable);
 #define create_workqueue(name) __create_workqueue((name), 0, 0)
-#define create_freezeable_workqueue(name) __create_workqueue((name), 0, 1)
+#define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1)
 #define create_singlethread_workqueue(name) __create_workqueue((name), 1, 0)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);

-- 
