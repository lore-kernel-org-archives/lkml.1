Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935071Ab0BZDCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 22:02:37 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39492 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935031Ab0BZDCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 22:02:35 -0500
Date: Thu, 25 Feb 2010 19:02:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu] rcu: export rcu_scheduler_active
Message-ID: <20100226030230.GA7743@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100225220624.GA7013@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100225220624.GA7013@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel modules using rcu_read_lock_sched_held() must now have access
to rcu_scheduler_active, so it must be exported.

This should fix the fix for the boot-time RCU-lockdep splat.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcupdate.c |    1 +
 1 file changed, 1 insertion(+)

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
