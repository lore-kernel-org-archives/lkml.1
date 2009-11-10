Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311AbZKJVhV (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 10 Nov 2009 16:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758298AbZKJVhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:37:17 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48883 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758294AbZKJVhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:37:15 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/4] rcu: enable synchronize_sched_expedited() fastpath
Date: Tue, 10 Nov 2009 13:37:20 -0800
Message-Id: <1257889042435-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091110213651.GA21411@linux.vnet.ibm.com>
References: <20091110213651.GA21411@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

This patch adds a counter increment to enable tasks to actually take
the synchronize_sched_expedited() function's fastpath.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 76c0e96..e69fee4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -10865,6 +10865,7 @@ void synchronize_sched_expedited(void)
 		spin_unlock_irqrestore(&rq->lock, flags);
 	}
 	rcu_expedited_state = RCU_EXPEDITED_STATE_IDLE;
+	synchronize_sched_expedited_count++;
 	mutex_unlock(&rcu_sched_expedited_mutex);
 	put_online_cpus();
 	if (need_full_sync)
-- 
1.5.2.5

