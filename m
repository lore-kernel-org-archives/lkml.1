Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbZHWJCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbZHWJCx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 05:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755914AbZHWJCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 05:02:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:36950 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755916AbZHWJCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 05:02:50 -0400
Date: Sun, 23 Aug 2009 09:02:19 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12509746132841-git-send-email->
References: <12509746132841-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Fix online/offline indication for rcudata.csv trace file
Message-ID: <tip-5699ed8fcb0c32ca699e2a27ad716eb70b367dbf@git.kernel.org>
Git-Commit-ID: 5699ed8fcb0c32ca699e2a27ad716eb70b367dbf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 23 Aug 2009 09:02:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5699ed8fcb0c32ca699e2a27ad716eb70b367dbf
Gitweb:     http://git.kernel.org/tip/5699ed8fcb0c32ca699e2a27ad716eb70b367dbf
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sat, 22 Aug 2009 13:56:48 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 23 Aug 2009 10:32:38 +0200

rcu: Fix online/offline indication for rcudata.csv trace file

The heading said "Online?", but the column had "Y" for offline
CPUs and "N" for online CPUs.  Swap the "Y" and "N" to match
the heading.

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
LKML-Reference: <12509746132841-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/rcutree_trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 236c050..ea4a474 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -103,7 +103,7 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		return;
 	seq_printf(m, "%d,%s,%ld,%ld,%d,%ld,%d",
 		   rdp->cpu,
-		   cpu_is_offline(rdp->cpu) ? "\"Y\"" : "\"N\"",
+		   cpu_is_offline(rdp->cpu) ? "\"N\"" : "\"Y\"",
 		   rdp->completed, rdp->gpnum,
 		   rdp->passed_quiesc, rdp->passed_quiesc_completed,
 		   rdp->qs_pending);
