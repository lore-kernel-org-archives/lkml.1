Return-Path: <linux-kernel-owner+w=401wt.eu-S933819AbXCPNwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933819AbXCPNwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 09:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933800AbXCPNwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 09:52:40 -0400
Received: from mail07.syd.optusnet.com.au ([211.29.132.188]:53747 "EHLO
	mail07.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933819AbXCPNwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 09:52:39 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH][RSDL-mm 4/6] sched: dont renice kernel threads
Date: Sat, 17 Mar 2007 00:54:08 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1914
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703170054.08641.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The practice of renicing kernel threads to negative nice values is of
questionable benefit at best, and at worst leads to larger latencies when
kernel threads are busy on behalf of other tasks.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 kernel/workqueue.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.21-rc3-mm2/kernel/workqueue.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/kernel/workqueue.c	2007-03-16 23:27:49.000000000 +1100
+++ linux-2.6.21-rc3-mm2/kernel/workqueue.c	2007-03-16 23:27:51.000000000 +1100
@@ -294,7 +294,6 @@ static int worker_thread(void *__cwq)
 	if (!cwq->wq->freezeable)
 		current->flags |= PF_NOFREEZE;
 
-	set_user_nice(current, -5);
 	/*
 	 * We inherited MPOL_INTERLEAVE from the booting kernel.
 	 * Set MPOL_DEFAULT to insure node local allocations.

-- 
-ck
