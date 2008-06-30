Return-Path: <linux-kernel-owner+w=401wt.eu-S932159AbYF3Ped@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbYF3Ped (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 11:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762357AbYF3Pbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 11:31:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55498 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbYF3Pbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:31:41 -0400
Date: Mon, 30 Jun 2008 17:31:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes
Message-ID: <20080630153124.GA21919@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest scheduler fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

Thanks,

	Ingo

------------------>
Dmitry Adamushko (1):
      sched: fix cpu hotplug

 kernel/sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3aaa5c8..a66e856 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5887,6 +5887,7 @@ static void migrate_dead_tasks(unsigned int dead_cpu)
 		next = pick_next_task(rq, rq->curr);
 		if (!next)
 			break;
+		next->sched_class->put_prev_task(rq, next);
 		migrate_dead(dead_cpu, next);
 
 	}
