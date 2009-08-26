Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbZHZIQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbZHZIQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 04:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbZHZIQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 04:16:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:41059 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbZHZIQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 04:16:33 -0400
Date: Wed, 26 Aug 2009 08:15:44 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       paulmck@linux.vnet.ibm.com, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <20090826015337.GA18904@linux.vnet.ibm.com>
References: <20090826015337.GA18904@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Remove lockdep annotations from RCU's _notrace() API members
Message-ID: <tip-06e799764eb7c2e4640888d438c3524d756613e1@git.kernel.org>
Git-Commit-ID: 06e799764eb7c2e4640888d438c3524d756613e1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 26 Aug 2009 08:15:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  06e799764eb7c2e4640888d438c3524d756613e1
Gitweb:     http://git.kernel.org/tip/06e799764eb7c2e4640888d438c3524d756613e1
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Tue, 25 Aug 2009 18:53:37 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Aug 2009 09:45:41 +0200

rcu: Remove lockdep annotations from RCU's _notrace() API members

The lockdep annotations rcu_read_acquire() and rcu_read_release()
might lead to infinite looping if called from lockdep.  So this patch
removes them.  Formal repost of http://lkml.org/lkml/2009/8/25/309
on the strength of Lai Jiangshan's review.

Suggested-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Suggested-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: josht@linux.vnet.ibm.com
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
LKML-Reference: <20090826015337.GA18904@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/rcupdate.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 8b4422c..95e0615 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -195,7 +195,6 @@ static inline notrace void rcu_read_lock_sched_notrace(void)
 {
 	preempt_disable_notrace();
 	__acquire(RCU_SCHED);
-	rcu_read_acquire();
 }
 
 /*
@@ -211,7 +210,6 @@ static inline void rcu_read_unlock_sched(void)
 }
 static inline notrace void rcu_read_unlock_sched_notrace(void)
 {
-	rcu_read_release();
 	__release(RCU_SCHED);
 	preempt_enable_notrace();
 }
