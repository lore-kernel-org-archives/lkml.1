Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab0CFLS1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 06:18:27 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:40539 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab0CFLSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 06:18:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=UjgXdLTCR2cGoX0eChJazpMu57oJkLIX/KNuY9AEm6MBGFmJURPoWkz4ryQZgYmGjs
         fQvNpV4sVxPHYBOtCJ2JJ6xAx4ITRYyaIRXD0DA9FFMeItxJzYblmWd4XY6mHjrl0keJ
         UvEexX4Gt/elejMFQQPcdjWQY0rfzBlEx+wP8=
Date: Sat, 6 Mar 2010 14:17:52 +0300
From: Dan Carpenter <error27@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, Gautham R Shenoy <ego@in.ibm.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       efault@gmx.de
Subject: [patch] sched: cleanup: remove unused variable in try_to_wake_up()
Message-ID: <20100306111752.GL4958@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, efault@gmx.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We haven't used the "orig_rq" variable since 
055a00865d "Fix/add missing update_rq_clock() calls"

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/kernel/sched.c b/kernel/sched.c
index abb36b1..523c750 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2359,7 +2359,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 {
 	int cpu, orig_cpu, this_cpu, success = 0;
 	unsigned long flags;
-	struct rq *rq, *orig_rq;
+	struct rq *rq;
 
 	if (!sched_feat(SYNC_WAKEUPS))
 		wake_flags &= ~WF_SYNC;
@@ -2367,7 +2367,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	this_cpu = get_cpu();
 
 	smp_wmb();
-	rq = orig_rq = task_rq_lock(p, &flags);
+	rq = task_rq_lock(p, &flags);
 	update_rq_clock(rq);
 	if (!(p->state & state))
 		goto out;
