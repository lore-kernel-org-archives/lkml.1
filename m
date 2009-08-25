Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZHYHNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZHYHNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 03:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbZHYHNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 03:13:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:40400 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbZHYHNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 03:13:43 -0400
Date: Tue, 25 Aug 2009 07:13:02 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, laijs@cn.fujitsu.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, laijs@cn.fujitsu.com,
       mingo@elte.hu
In-Reply-To: <12511321213243-git-send-email->
References: <12511321213243-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Add "notrace" to RCU function headers used by ftrace
Message-ID: <tip-7c614d6461399acca5c0ba444f5db49cb332fc08@git.kernel.org>
Git-Commit-ID: 7c614d6461399acca5c0ba444f5db49cb332fc08
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 25 Aug 2009 07:13:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7c614d6461399acca5c0ba444f5db49cb332fc08
Gitweb:     http://git.kernel.org/tip/7c614d6461399acca5c0ba444f5db49cb332fc08
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 24 Aug 2009 09:42:00 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 24 Aug 2009 20:37:04 +0200

rcu: Add "notrace" to RCU function headers used by ftrace

Both rcu_read_lock_sched_notrace() and
rcu_read_unlock_sched_notrace() are used by ftrace, and thus
need to be marked "notrace".

Unfortunately, my naive assumption that gcc would see the inner
"notrace" does not hold.

Kudos to Lai Jiangshan for noting this.

Reported-by: Ingo Molnar <mingo@elte.hu>
Bug-spotted-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josht@linux.vnet.ibm.com
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
LKML-Reference: <12511321213243-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
