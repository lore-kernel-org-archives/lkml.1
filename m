Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968260Ab0B0M4t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 07:56:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:45155 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968209Ab0B0M4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 07:56:47 -0500
Date: Sat, 27 Feb 2010 12:56:16 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267231138-27856-2-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1267231138-27856-2-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Make non-RCU_PROVE_LOCKING rcu_read_lock_sched_held() understand boot
Message-ID: <tip-0b1c87278a8c7e394022ec184a0b44a3886b6fde@git.kernel.org>
Git-Commit-ID: 0b1c87278a8c7e394022ec184a0b44a3886b6fde
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 27 Feb 2010 12:56:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0b1c87278a8c7e394022ec184a0b44a3886b6fde
Gitweb:     http://git.kernel.org/tip/0b1c87278a8c7e394022ec184a0b44a3886b6fde
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Fri, 26 Feb 2010 16:38:57 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 27 Feb 2010 09:53:52 +0100

rcu: Make non-RCU_PROVE_LOCKING rcu_read_lock_sched_held() understand boot

Before the scheduler starts, all tasks are non-preemptible by
definition. So, during that time, rcu_read_lock_sched_held()
needs to always return "true".  This patch makes that be so
for RCU_PROVE_LOCKING=n.

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
LKML-Reference: <1267231138-27856-2-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/rcupdate.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index fcea332..c843736 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -166,7 +166,7 @@ static inline int rcu_read_lock_bh_held(void)
 
 static inline int rcu_read_lock_sched_held(void)
 {
-	return preempt_count() != 0;
+	return preempt_count() != 0 || !rcu_scheduler_active;
 }
 
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
