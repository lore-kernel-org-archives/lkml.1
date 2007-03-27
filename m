Return-Path: <linux-kernel-owner+w=401wt.eu-S933929AbXC0CJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933929AbXC0CJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 22:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933944AbXC0CJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 22:09:05 -0400
Received: from mail28.syd.optusnet.com.au ([211.29.133.169]:54220 "EHLO
	mail28.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933929AbXC0CJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 22:09:01 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH][ 1/5] sched: dont renice kernel threads
Date: Tue, 27 Mar 2007 13:08:47 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1914
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703271208.47198.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The practice of renicing kernel threads to negative nice values is of
questionable benefit at best, and at worst leads to larger latencies when
kernel threads are busy on behalf of other tasks.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
---

 kernel/workqueue.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6.21-rc5-sd/kernel/workqueue.c
===================================================================
--- linux-2.6.21-rc5-sd.orig/kernel/workqueue.c	2007-03-26 11:03:31.000000000 +1000
+++ linux-2.6.21-rc5-sd/kernel/workqueue.c	2007-03-27 11:52:54.000000000 +1000
@@ -355,8 +355,6 @@ static int worker_thread(void *__cwq)
 	if (!cwq->freezeable)
 		current->flags |= PF_NOFREEZE;
 
-	set_user_nice(current, -5);
-
 	/* Block and flush all signals */
 	sigfillset(&blocked);
 	sigprocmask(SIG_BLOCK, &blocked, NULL);

-- 
-ck
