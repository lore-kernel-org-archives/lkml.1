Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbXKWLpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbXKWLpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 06:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbXKWLpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 06:45:39 -0500
Received: from ns2.suse.de ([195.135.220.15]:41487 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829AbXKWLpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 06:45:38 -0500
Message-ID: <47480F2D.3030408@suse.de>
Date: Sat, 24 Nov 2007 17:16:53 +0530
From: Nikanth Karthikesan <knikanth@suse.de>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: mingo@elte.hu
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com
Subject: [PATCH] sched: minor optimization
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As an optimization, if all tasks are in the fair class, the next task is
directly picked from fair_sched_class. But, if it returns no task we go
through again from sched_class_highest which could be avoided and
instead return the idle task directly.


Signed-off-by : Nikanth Karthikesan <knikanth@suse.de>
---
 kernel/sched.c |    2 ++
 1 file changed, 2 insertions(+)

Index: b/kernel/sched.c
===================================================================
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3449,6 +3449,8 @@ pick_next_task(struct rq *rq, struct tas
 		p = fair_sched_class.pick_next_task(rq);
 		if (likely(p))
 			return p;
+		else /* rq->nr_running is zero */
+			return idle_sched_class.pick_next_task(rq);
 	}

 	class = sched_class_highest;
