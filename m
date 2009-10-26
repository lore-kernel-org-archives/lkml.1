Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbZJZCEA (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sun, 25 Oct 2009 22:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbZJZCD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 22:03:59 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60158 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422AbZJZCD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 22:03:58 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, avi@redhat.com,
        mtosatti@redhat.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 5/6] rcu: Improve rcutorture diagnostics when bad torture_type specified
Date: Sun, 25 Oct 2009 19:03:54 -0700
Message-Id: <12565226351868-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091026020253.GA11350@linux.vnet.ibm.com>
References: <20091026020253.GA11350@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Make rcutorture list the available torture_type values when it doesn't
like the one specified.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
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
-- 
1.5.2.5

