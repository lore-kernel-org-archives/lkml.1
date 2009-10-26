Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbZJZLiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbZJZLiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 07:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755856AbZJZLis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 07:38:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:57274 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810AbZJZLiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 07:38:46 -0400
Date: Mon, 26 Oct 2009 11:37:43 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, josh@joshtriplett.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, josh@joshtriplett.org,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <12565226351868-git-send-email->
References: <12565226351868-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Improve rcutorture diagnostics when bad torture_type specified
Message-ID: <tip-cf886c44ec418a01b2c52493465accb81acbf930@git.kernel.org>
Git-Commit-ID: cf886c44ec418a01b2c52493465accb81acbf930
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf886c44ec418a01b2c52493465accb81acbf930
Gitweb:     http://git.kernel.org/tip/cf886c44ec418a01b2c52493465accb81acbf930
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sun, 25 Oct 2009 19:03:54 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 26 Oct 2009 09:40:31 +0100

rcu: Improve rcutorture diagnostics when bad torture_type specified

Make rcutorture list the available torture_type values when it
doesn't like the one specified.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
Cc: avi@redhat.com
Cc: mtosatti@redhat.com
LKML-Reference: <12565226351868-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutorture.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 14480e8..3dd0ca2 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -1129,8 +1129,12 @@ rcu_torture_init(void)
 			break;
 	}
 	if (i == ARRAY_SIZE(torture_ops)) {
-		printk(KERN_ALERT "rcutorture: invalid torture type: \"%s\"\n",
+		printk(KERN_ALERT "rcu-torture: invalid torture type: \"%s\"\n",
 		       torture_type);
+		printk(KERN_ALERT "rcu-torture types:");
+		for (i = 0; i < ARRAY_SIZE(torture_ops); i++)
+			printk(KERN_ALERT " %s", torture_ops[i]->name);
+		printk(KERN_ALERT "\n");
 		mutex_unlock(&fullstop_mutex);
 		return -EINVAL;
 	}
