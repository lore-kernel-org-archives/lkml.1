Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab0BWBHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:07:04 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49398 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917Ab0BWBFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:05:18 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dan Carpenter <error27@gmail.com>
Subject: [PATCH tip/core/rcu 20/21] rcu: fix rcutorture mod_timer argument to delay one jiffy
Date: Mon, 22 Feb 2010 17:05:04 -0800
Message-Id: <1266887105-1528-20-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100223010435.GA666@linux.vnet.ibm.com>
References: <20100223010435.GA666@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current "mod_timer(&t, 1)" potentially makes the timer fire immediately,
change this to wait one jiffy.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 5f43f30..258cdf0 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -853,7 +853,7 @@ rcu_torture_reader(void *arg)
 	do {
 		if (irqreader && cur_ops->irq_capable) {
 			if (!timer_pending(&t))
-				mod_timer(&t, 1);
+				mod_timer(&t, jiffies + 1);
 		}
 		idx = cur_ops->readlock();
 		completed = cur_ops->completed();
-- 
1.6.6

