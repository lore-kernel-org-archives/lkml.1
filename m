Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbZICJLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbZICJLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 05:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbZICJLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 05:11:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45311 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079AbZICJLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 05:11:40 -0400
Date: Thu, 3 Sep 2009 19:11:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Anirban Sinha <ASinha@zeugmasystems.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the percpu tree with the tip tree
Message-Id: <20090903191138.be02fc01.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the percpu tree got a conflict in
kernel/sched.c between commit 84e9dabf6e6a78928c6a1a8ba235c9fb0908d0f8
("sched: Rename init_cfs_rq => init_tg_cfs_rq") from the tip tree and
commit b9bf3121af348d9255f1c917830fe8c2df52efcb ("percpu: use
DEFINE_PER_CPU_SHARED_ALIGNED()") from the percpu tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/sched.c
index 4061929,d3d7e76..0000000
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@@ -318,7 -318,7 +318,7 @@@ struct task_group root_task_group
  /* Default task group's sched entity on each cpu */
  static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
  /* Default task group's cfs_rq on each cpu */
- static DEFINE_PER_CPU(struct cfs_rq, init_tg_cfs_rq) ____cacheline_aligned_in_smp;
 -static DEFINE_PER_CPU_SHARED_ALIGNED(struct cfs_rq, init_cfs_rq);
++static DEFINE_PER_CPU_SHARED_ALIGNED(struct cfs_rq, init_tg_cfs_rq);
  #endif /* CONFIG_FAIR_GROUP_SCHED */
  
  #ifdef CONFIG_RT_GROUP_SCHED
