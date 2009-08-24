Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbZHXQmI (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 24 Aug 2009 12:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbZHXQmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 12:42:06 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50126 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbZHXQmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 12:42:01 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
   akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
   josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
   tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
   "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH -tip 1/2] Add "notrace" to RCU function headers used by ftrace.
Date: Mon, 24 Aug 2009 09:42:00 -0700
Message-Id: <12511321213243-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090824164112.GA13693@linux.vnet.ibm.com>
References: <20090824164112.GA13693@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both rcu_read_lock_sched_notrace() and rcu_read_unlock_sched_notrace()
are used by ftrace, and thus need to be marked "notrace".  Unfortunately,
my naive assumption that gcc would see the inner "notrace" does not hold.
Kudos to Lai Jiangshan for noting this.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index ec90fc3..8b4422c 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -191,7 +191,7 @@ static inline void rcu_read_lock_sched(void)
 	__acquire(RCU_SCHED);
 	rcu_read_acquire();
 }
-static inline void rcu_read_lock_sched_notrace(void)
+static inline notrace void rcu_read_lock_sched_notrace(void)
 {
 	preempt_disable_notrace();
 	__acquire(RCU_SCHED);
@@ -209,7 +209,7 @@ static inline void rcu_read_unlock_sched(void)
 	__release(RCU_SCHED);
 	preempt_enable();
 }
-static inline void rcu_read_unlock_sched_notrace(void)
+static inline notrace void rcu_read_unlock_sched_notrace(void)
 {
 	rcu_read_release();
 	__release(RCU_SCHED);
-- 
1.5.2.5

