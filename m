Return-Path: <linux-kernel-owner+w=401wt.eu-S1760999AbXEMVwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760999AbXEMVwb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 17:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757542AbXEMVwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 17:52:23 -0400
Received: from mail.screens.ru ([213.234.233.54]:41660 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904AbXEMVwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 17:52:22 -0400
Date: Mon, 14 May 2007 01:52:26 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alex Dubov <oakad@yahoo.com>, Pierre Ossman <drzeus@drzeus.cx>
Subject: [PATCH] for 2.6.22, make freezeable workqueues singlethread
Message-ID: <20070513215226.GB3198@tv-sign.ru>
References: <200705132132.08546.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705132132.08546.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It is a known fact that freezeable multithreaded workqueues doesn't like
CPU_DEAD. We keep them only for the incoming CPU-hotplug rework.

Sadly, we can't just kill create_freezeable_workqueue() right now, make
them singlethread.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- OLD/include/linux/workqueue.h~	2007-05-01 21:52:47.000000000 +0400
+++ OLD/include/linux/workqueue.h	2007-05-14 00:41:58.000000000 +0400
@@ -122,7 +122,7 @@ extern struct workqueue_struct *__create
 						    int singlethread,
 						    int freezeable);
 #define create_workqueue(name) __create_workqueue((name), 0, 0)
-#define create_freezeable_workqueue(name) __create_workqueue((name), 0, 1)
+#define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1)
 #define create_singlethread_workqueue(name) __create_workqueue((name), 1, 0)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);

