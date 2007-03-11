Return-Path: <linux-kernel-owner+w=401wt.eu-S932985AbXCKECQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbXCKECQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 23:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932927AbXCKECQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 23:02:16 -0500
Received: from mail01.syd.optusnet.com.au ([211.29.132.182]:56167 "EHLO
	mail01.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932908AbXCKECO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 23:02:14 -0500
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH][RSDL-mm 5/7] sched dont renice kernel threads
Date: Sun, 11 Mar 2007 15:01:56 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1914
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703111501.56589.kernel@kolivas.org>
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
--- linux-2.6.21-rc3-mm2.orig/kernel/workqueue.c	2007-03-11 14:47:57.000000000 +1100
+++ linux-2.6.21-rc3-mm2/kernel/workqueue.c	2007-03-11 14:47:59.000000000 +1100
@@ -294,7 +294,6 @@ static int worker_thread(void *__cwq)
 	if (!cwq->wq->freezeable)
 		current->flags |= PF_NOFREEZE;
 
-	set_user_nice(current, -5);
 	/*
 	 * We inherited MPOL_INTERLEAVE from the booting kernel.
 	 * Set MPOL_DEFAULT to insure node local allocations.

-- 
-ck
