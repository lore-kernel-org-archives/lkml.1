Return-Path: <linux-kernel-owner+w=401wt.eu-S1758505AbZKJW2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505AbZKJW2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758483AbZKJW2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:28:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:34928 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758481AbZKJW2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:28:12 -0500
Date: Tue, 10 Nov 2009 22:27:58 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257889042435-git-send-email->
References: <1257889042435-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Enable synchronize_sched_expedited() fastpath
Message-ID: <tip-956539b75921f561c0956c22d37320780e8b4ba1@git.kernel.org>
Git-Commit-ID: 956539b75921f561c0956c22d37320780e8b4ba1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  956539b75921f561c0956c22d37320780e8b4ba1
Gitweb:     http://git.kernel.org/tip/956539b75921f561c0956c22d37320780e8b4ba1
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Tue, 10 Nov 2009 13:37:20 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 22:48:49 +0100

rcu: Enable synchronize_sched_expedited() fastpath

This patch adds a counter increment to enable tasks to actually
take the synchronize_sched_expedited() function's fastpath.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <1257889042435-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
