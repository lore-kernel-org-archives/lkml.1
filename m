Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449AbZHVU4z (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 22 Aug 2009 16:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526AbZHVU4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 16:56:53 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51041 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbZHVU4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 16:56:52 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
   akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
   josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
   tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
   "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH -tip] v3 Fix online/offline indication for rcudata.csv trace file
Date: Sat, 22 Aug 2009 13:56:48 -0700
Message-Id: <12509746132841-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090727181401.GA14120@linux.vnet.ibm.com>
References: <20090727181401.GA14120@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

The heading said "Online?", but the column had "Y" for offline CPUs
and "N" for online CPUs.  Swap the "Y" and "N" to match the heading.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
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
-- 
1.5.2.5

