Return-Path: <linux-kernel-owner+w=401wt.eu-S932853AbZHZBxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853AbZHZBxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 21:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932780AbZHZBxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 21:53:37 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34672 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932631AbZHZBxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 21:53:36 -0400
Date: Tue, 25 Aug 2009 18:53:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org
Subject: [PATCH -tip] Remove lockdep annotations from RCU's _notrace() API
	members
Message-ID: <20090826015337.GA18904@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lockdep annotations rcu_read_acquire() and rcu_read_release()
might lead to infinite looping if called from lockdep.  So this patch
removes them.  Formal repost of http://lkml.org/lkml/2009/8/25/309
on the strength of Lai Jiangshan's review.

Suggested-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Suggested-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcupdate.h |    2 --
 1 file changed, 2 deletions(-)

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
