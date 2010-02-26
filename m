Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935758Ab0BZJak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:30:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:39903 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935714Ab0BZJag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 04:30:36 -0500
Date: Fri, 26 Feb 2010 09:29:54 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100226030230.GA7743@linux.vnet.ibm.com>
References: <20100226030230.GA7743@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Export rcu_scheduler_active
Message-ID: <tip-f5f654096487c6d526c47bb66308f9de81f091cf@git.kernel.org>
Git-Commit-ID: f5f654096487c6d526c47bb66308f9de81f091cf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 09:29:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5f654096487c6d526c47bb66308f9de81f091cf
Gitweb:     http://git.kernel.org/tip/f5f654096487c6d526c47bb66308f9de81f091cf
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Thu, 25 Feb 2010 19:02:30 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Feb 2010 08:20:46 +0100

rcu: Export rcu_scheduler_active

Kernel modules using rcu_read_lock_sched_held() must now have
access to rcu_scheduler_active, so it must be exported.

This should fix the fix for the boot-time RCU-lockdep splat.

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
LKML-Reference: <20100226030230.GA7743@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcupdate.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 7bfa004..f1125c1 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -64,6 +64,7 @@ EXPORT_SYMBOL_GPL(rcu_sched_lock_map);
 #endif
 
 int rcu_scheduler_active __read_mostly;
+EXPORT_SYMBOL_GPL(rcu_scheduler_active);
 
 /*
  * This function is invoked towards the end of the scheduler's initialization
