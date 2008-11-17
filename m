Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbYKQNjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbYKQNjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbYKQNjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:39:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46121 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766AbYKQNjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:39:31 -0500
Date: Mon, 17 Nov 2008 15:39:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>
Cc: Doug Chapman <doug.chapman@hp.com>, Frank Mayhar <fmayhar@google.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] account_steal_time: kill the unneeded
	account_group_system_time()
Message-ID: <20081117143952.GA5367@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't actually understand account_steal_time() and I failed to find the
commit which added account_group_system_time(), but this looks bogus.
In any case rq->idle must be single-threaded, so it can't have ->totals.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- K-28/kernel/sched.c~ACCT_STEAL_KILL_GACCT	2008-11-10 13:05:09.000000000 +0100
+++ K-28/kernel/sched.c	2008-11-16 23:40:05.000000000 +0100
@@ -4198,7 +4198,6 @@ void account_steal_time(struct task_stru
 
 	if (p == rq->idle) {
 		p->stime = cputime_add(p->stime, steal);
-		account_group_system_time(p, steal);
 		if (atomic_read(&rq->nr_iowait) > 0)
 			cpustat->iowait = cputime64_add(cpustat->iowait, tmp);
 		else

