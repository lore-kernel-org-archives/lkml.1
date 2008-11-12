Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054AbYKLKxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbYKLKxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 05:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbYKLKwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 05:52:53 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:59376 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbYKLKww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 05:52:52 -0500
Date: Wed, 12 Nov 2008 16:19:00 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Vaidyanathan S <svaidyan@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [PATCH][mmotm] Sched fix stale value in average load per task
Message-ID: <20081112104900.GA13896@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Dhaval Giani <dhaval@linux.vnet.ibm.com>,
	Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
	Vaidyanathan S <svaidyan@in.ibm.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Bharata B Rao <bharata@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_avg_load_per_task() returns a stale value when nr_running is 0. It returns
an older stale (caculated when nr_running was non zero) value. This patch
returns and sets rq->avg_load_per_task to zero when nr_running is 0.

Compile and boot tested on a x86_64 box.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 kernel/sched.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/sched.c~sched-fix-stale-load-avg kernel/sched.c
--- linux-2.6.28-rc4/kernel/sched.c~sched-fix-stale-load-avg	2008-11-12 15:55:38.000000000 +0530
+++ linux-2.6.28-rc4-balbir/kernel/sched.c	2008-11-12 15:56:09.000000000 +0530
@@ -1430,6 +1430,8 @@ static unsigned long cpu_avg_load_per_ta
 
 	if (rq->nr_running)
 		rq->avg_load_per_task = rq->load.weight / rq->nr_running;
+	else
+		rq->avg_load_per_task = 0;
 
 	return rq->avg_load_per_task;
 }
_

-- 
	Balbir
