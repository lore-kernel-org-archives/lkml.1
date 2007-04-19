Return-Path: <linux-kernel-owner+w=401wt.eu-S1766767AbXDSPEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766767AbXDSPEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 11:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766776AbXDSPE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 11:04:29 -0400
Received: from mail15.syd.optusnet.com.au ([211.29.132.196]:54456 "EHLO
	mail15.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766767AbXDSPE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 11:04:28 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Subject: [PATCH] [3/3] sched: increase ksoftirqd priority
Date: Fri, 20 Apr 2007 01:03:51 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704200103.51443.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

More aggressive nice discrimination by the Staircase-Deadline cpu scheduler
means ksoftirqd is getting significantly less cpu than previously. Adjust
nice value accordingly for similar cpu distribution.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 kernel/softirq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21-rc7-sd/kernel/softirq.c
===================================================================
--- linux-2.6.21-rc7-sd.orig/kernel/softirq.c	2007-04-20 00:30:08.000000000 +1000
+++ linux-2.6.21-rc7-sd/kernel/softirq.c	2007-04-20 00:30:31.000000000 +1000
@@ -488,7 +488,7 @@ void __init softirq_init(void)
 
 static int ksoftirqd(void * __bind_cpu)
 {
-	set_user_nice(current, 19);
+	set_user_nice(current, 15);
 	current->flags |= PF_NOFREEZE;
 
 	set_current_state(TASK_INTERRUPTIBLE);

-- 
-ck
