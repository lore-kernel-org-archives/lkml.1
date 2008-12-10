Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbYLJWPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbYLJWPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 17:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbYLJWPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 17:15:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37707 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbYLJWPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 17:15:06 -0500
Date: Wed, 10 Dec 2008 23:14:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] scheduler fixes
Message-ID: <20081210221454.GA20274@elte.hu>
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
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Brian King (1):
      sched: CPU remove deadlock fix


 kernel/sched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b7480fb..e4bb1dd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6587,7 +6587,9 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 			req = list_entry(rq->migration_queue.next,
 					 struct migration_req, list);
 			list_del_init(&req->list);
+			spin_unlock_irq(&rq->lock);
 			complete(&req->done);
+			spin_lock_irq(&rq->lock);
 		}
 		spin_unlock_irq(&rq->lock);
 		break;
