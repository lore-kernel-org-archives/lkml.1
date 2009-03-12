Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbZCLScX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbZCLScX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 14:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756707AbZCLScE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 14:32:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49173 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497AbZCLScB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 14:32:01 -0400
Date: Thu, 12 Mar 2009 14:29:50 -0400
From: Jason Baron <jbaron@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, fweisbec@gmail.com,
       fche@redhat.com, peterz@infradead.org, compudj@krystal.dyndns.org
Subject: [Patch 0/2] tracepoints for softirq entry/exit
Message-ID: <20090312182950.GA3352@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

Somewhat analogous to the hard irq entry/exit tracepoints. This patch
series introduces tracepoints for softirq entry/exit points.

These tracepoints are useful for augmenting the various tracers (sample
output below), and for understanding frequencies and timings for
softirqs. Very similar tracepoints are also in Mathieu's lttng tree.

thanks,

-Jason


 0)               |                                  /* irq_softirq_entry: softirq=1 action=TIMER_SOFTIRQ */
 0)               |                                  run_timer_softirq() {
 0)   1.032 us    |                                    hrtimer_run_pending();
 0)   0.796 us    |                                    _spin_lock_irq();
 0)   4.593 us    |                                  }
 0)               |                                  /* irq_softirq_exit: softirq=1 action=TIMER_SOFTIRQ */
 0)               |                                  /* irq_softirq_entry: softirq=6 action=SCHED_SOFTIRQ */
 0)               |                                  run_rebalance_domains() {
 0)               |                                    rebalance_domains() {
 0)   0.868 us    |                                      msecs_to_jiffies();
 0)   1.014 us    |                                      msecs_to_jiffies();
 0)   5.947 us    |                                    }
 0)   7.779 us    |                                  }
 0)               |                                  /* irq_softirq_exit: softirq=6 action=SCHED_SOFTIRQ */
 0)               |                                  /* irq_softirq_entry: softirq=8 action=RCU_SOFTIRQ */
 0)               |                                  rcu_process_callbacks() {
 0)               |                                    __rcu_process_callbacks() {
 0)   0.882 us    |                                      force_quiescent_state();
 0)   0.995 us    |                                      rcu_process_gp_end();
 0)   0.740 us    |                                      check_for_new_grace_period();
 0)               |                                      cpu_quiet() {
 0)   0.815 us    |                                        _spin_lock_irqsave();
 0)   0.939 us    |                                        _spin_unlock_irqrestore();
 0)   4.208 us    |                                      }
 0) + 12.257 us   |                                    }
 0)               |                                    __rcu_process_callbacks() {
 0)   0.547 us    |                                      force_quiescent_state();
 0)   0.917 us    |                                      rcu_process_gp_end();
 0)   0.744 us    |                                      check_for_new_grace_period();
 0)   5.879 us    |                                    }
 0) + 20.994 us   |                                  }
 0)               |                                  /* irq_softirq_exit: softirq=8 action=RCU_SOFTIRQ */

