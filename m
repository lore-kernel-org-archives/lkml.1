Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab0CDQck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:32:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:48475 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755735Ab0CDQcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:32:36 -0500
Date: Thu, 4 Mar 2010 16:32:03 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267631219-8713-3-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1267631219-8713-3-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu, cgroup: Relax the check in task_subsys_state() as early boot is now handled by lockdep-RCU
Message-ID: <tip-5ed42b8113667c06a6ff2c72717395b5044d30a1@git.kernel.org>
Git-Commit-ID: 5ed42b8113667c06a6ff2c72717395b5044d30a1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Mar 2010 16:32:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ed42b8113667c06a6ff2c72717395b5044d30a1
Gitweb:     http://git.kernel.org/tip/5ed42b8113667c06a6ff2c72717395b5044d30a1
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 3 Mar 2010 07:46:58 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Mar 2010 12:07:31 +0100

rcu, cgroup: Relax the check in task_subsys_state() as early boot is now handled by lockdep-RCU

This patch removes the check for !rcu_scheduler_active because
this check has been incorporated into rcu_dereference_check().

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
LKML-Reference: <1267631219-8713-3-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/cgroup.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index a73e1ce..c9bbcb2 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -489,7 +489,6 @@ static inline struct cgroup_subsys_state *task_subsys_state(
 {
 	return rcu_dereference_check(task->cgroups->subsys[subsys_id],
 				     rcu_read_lock_held() ||
-				     !rcu_scheduler_active ||
 				     cgroup_lock_is_held());
 }
 
