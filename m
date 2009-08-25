Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbZHYPk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbZHYPk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 11:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbZHYPk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 11:40:27 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46005 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbZHYPk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 11:40:26 -0400
Date: Tue, 25 Aug 2009 08:40:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH -tip 0/2] Temporary RCU fixes for notrace and hotplug CPU
Message-ID: <20090825154025.GD6616@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090824164112.GA13693@linux.vnet.ibm.com> <20090825065501.GA29162@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825065501.GA29162@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 08:55:01AM +0200, Ingo Molnar wrote:
> 
> FYI, -tip testing found a new build warning on SH caused by the RCU 
> tree (i suspect this warning triggers on other architectures as 
> well):
> 
> /home/mingo/tip/kernel/rcutree.c:88: warning: '__rcu_offline_cpu' 
> declared 'static' but never defined

<red face>

> it's harmless, but since we are generally trying to fix all warnings 
> and gravitate towards more and more -Werror subsystems, it would be 
> nice to fix this.

Indeed, and I have updated my build-output-check script to alert me to
warning messages from my multiple-configuration test runs.  Please see
below for patch.

						Thanx, Paul

------------------------------------------------------------------------

Add #ifdef to suppress __rcu_offline_cpu() warning in !HOTPLUG_CPU builds

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcutree.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 000b076..fee6316 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -84,7 +84,9 @@ extern long rcu_batches_completed_sched(void);
 static void cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp,
 			  struct rcu_node *rnp, unsigned long flags);
 static void cpu_quiet_msk_finish(struct rcu_state *rsp, unsigned long flags);
+#ifdef CONFIG_HOTPLUG_CPU
 static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp);
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
 static void __rcu_process_callbacks(struct rcu_state *rsp,
 				    struct rcu_data *rdp);
 static void __call_rcu(struct rcu_head *head,
