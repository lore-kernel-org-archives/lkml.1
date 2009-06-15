Return-Path: <linux-kernel-owner+w=401wt.eu-S1763284AbZFOSzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763284AbZFOSzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbZFOSzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:55:36 -0400
Received: from ms01.sssup.it ([193.205.80.99]:54936 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751455AbZFOSzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:55:35 -0400
Date: Mon, 15 Jun 2009 20:56:38 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: mingo@elte.hu, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] Fix rt_rq->pushable_tasks initialization in init_rt_rq()
Message-ID: <20090615185638.GK21741@gandalf.sssup.it>
References: <cover.1245092261.git.fabio@helm.retis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1245092261.git.fabio@helm.retis>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_rt_rq() initializes only rq->rt.pushable_tasks, and not the
pushable_tasks field of the passed rt_rq.  The plist is not used
uninitialized since the only pushable_tasks plists used are the
ones of root rt_rqs; anyway reinitializing the list on every group
creation corrupts the root plist, losing its previous contents.

Signed-off-by: Fabio Checconi <fabio@gandalf.sssup.it>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 6032f51..873b252 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9075,7 +9075,7 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 #ifdef CONFIG_SMP
 	rt_rq->rt_nr_migratory = 0;
 	rt_rq->overloaded = 0;
-	plist_head_init(&rq->rt.pushable_tasks, &rq->lock);
+	plist_head_init(&rt_rq->pushable_tasks, &rq->lock);
 #endif
 
 	rt_rq->rt_time = 0;
-- 
1.6.2.2

