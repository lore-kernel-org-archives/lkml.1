Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab0BAKNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 05:13:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:55306 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab0BAKNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 05:13:45 -0500
Subject: [PATCH] sched: Remove unused update_shares_locked()
From: Peter Zijlstra <peterz@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100201182204.cc53b339.sfr@canb.auug.org.au>
References: <20100201182204.cc53b339.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 11:13:39 +0100
Message-ID: <1265019219.24455.128.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 18:22 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next build (powerpc allyesconfig) produced this warning:
> 
> kernel/sched.c:1636: warning: 'update_shares_locked' defined but not used
> 
> Introduced by commit f492e12ef050e02bf0185b6b57874992591b9be1 ("sched:
> Remove load_balance_newidle()").

Hmm, you're quite right indeed, that removed the only user of that
function.

---
Subject: sched: Remove unused update_shares_locked()

Commit f492e12ef050e02bf0185b6b57874992591b9be1 ("sched: Remove
load_balance_newidle()") removed the only user of this function, so
remove it too.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 876e7c1..b5c8b44 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1633,16 +1633,6 @@ static void update_shares(struct sched_domain *sd)
 	}
 }
 
-static void update_shares_locked(struct rq *rq, struct sched_domain *sd)
-{
-	if (root_task_group_empty())
-		return;
-
-	raw_spin_unlock(&rq->lock);
-	update_shares(sd);
-	raw_spin_lock(&rq->lock);
-}
-
 static void update_h_load(long cpu)
 {
 	if (root_task_group_empty())
@@ -1657,10 +1647,6 @@ static inline void update_shares(struct sched_domain *sd)
 {
 }
 
-static inline void update_shares_locked(struct rq *rq, struct sched_domain *sd)
-{
-}
-
 #endif
 
 #ifdef CONFIG_PREEMPT


