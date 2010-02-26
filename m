Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964931Ab0BZOrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 09:47:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34858 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964921Ab0BZOq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 09:46:59 -0500
Date: Fri, 26 Feb 2010 15:46:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/2] rcu: fixes for RCU lockdep
Message-ID: <20100226144619.GA4327@elte.hu>
References: <20100225220624.GA7013@linux.vnet.ibm.com>
 <20100226115018.GA4519@elte.hu>
 <20100226131931.GA19695@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100226131931.GA19695@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


plus:

skge eth0: Link is up at 1000 Mbps, full duplex, flow control both

=================================
[ INFO: inconsistent lock state ]
2.6.33-tip+ #10436
---------------------------------
inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
swapper/0 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&(&base->lock)->rlock){+.?.-.}, at: [<ffffffff8107c688>] get_next_timer_interrupt+0x35/0x214
{IN-SOFTIRQ-W} state was registered at:
  [<ffffffff81099096>] mark_irqflags+0x75/0x125
  [<ffffffff8109a749>] __lock_acquire+0x207/0x368
  [<ffffffff8109a986>] lock_acquire+0xdc/0x102
  [<ffffffff81ee928c>] _raw_spin_lock_irq+0x42/0x77
  [<ffffffff8107bdaa>] run_timer_softirq+0x4f/0x2c1
  [<ffffffff81077716>] __do_softirq+0xf8/0x1cd
  [<ffffffff81029bbc>] call_softirq+0x1c/0x28
  [<ffffffff8102b6ab>] do_softirq+0x4b/0x92
  [<ffffffff8107735c>] irq_exit+0x4a/0x8c
  [<ffffffff81eea4f4>] do_IRQ+0xac/0xc3
  [<ffffffff81ee9d53>] ret_from_intr+0x0/0x16
  [<ffffffff81ee9b23>] _raw_spin_unlock_irqrestore+0x51/0x56
  [<ffffffff810b782a>] __setup_irq+0x220/0x2c6
  [<ffffffff810b7a1a>] setup_irq+0x23/0x28
  [<ffffffff82b99220>] setup_default_timer_irq+0x12/0x14
  [<ffffffff82b99239>] hpet_time_init+0x17/0x19
  [<ffffffff82b99207>] x86_late_time_init+0xa/0x11
  [<ffffffff82b95cfe>] start_kernel+0x2c1/0x34e
  [<ffffffff82b952a0>] x86_64_start_reservations+0xa7/0xab
  [<ffffffff82b9539c>] x86_64_start_kernel+0xf8/0x107
irq event stamp: 342029
hardirqs last  enabled at (342029): [<ffffffff810ba87b>] rcu_do_batch+0x1e4/0x20f
hardirqs last disabled at (342028): [<ffffffff810ba7a2>] rcu_do_batch+0x10b/0x20f
softirqs last  enabled at (342026): [<ffffffff81d26ade>] __dst_free+0xb4/0xb8
softirqs last disabled at (342025): [<ffffffff81ee945f>] _raw_spin_lock_bh+0x1c/0x6e

other info that might help us debug this:
no locks held by swapper/0.

stack backtrace:
Pid: 0, comm: swapper Not tainted 2.6.33-tip+ #10436
Call Trace:
 [<ffffffff81098d80>] print_usage_bug+0x154/0x165
 [<ffffffff810997fb>] ? check_usage_backwards+0x0/0x81
 [<ffffffff81098de0>] valid_state+0x4f/0x5a
 [<ffffffff81098e34>] mark_lock_irq+0x49/0xef
 [<ffffffff81098fbd>] mark_lock+0xe3/0x147
 [<ffffffff810990fc>] mark_irqflags+0xdb/0x125
 [<ffffffff8109a749>] __lock_acquire+0x207/0x368
 [<ffffffff81077573>] ? _local_bh_enable_ip+0xbc/0xc5
 [<ffffffff81077573>] ? _local_bh_enable_ip+0xbc/0xc5
 [<ffffffff8109a986>] lock_acquire+0xdc/0x102
 [<ffffffff8107c688>] ? get_next_timer_interrupt+0x35/0x214
 [<ffffffff810ba87b>] ? rcu_do_batch+0x1e4/0x20f
 [<ffffffff81ee918b>] _raw_spin_lock+0x36/0x69
 [<ffffffff8107c688>] ? get_next_timer_interrupt+0x35/0x214
 [<ffffffff8107c688>] get_next_timer_interrupt+0x35/0x214
 [<ffffffff810ba940>] ? __rcu_process_callbacks+0x9a/0x9f
 [<ffffffff8109623b>] tick_nohz_stop_sched_tick+0x38f/0x3b8
 [<ffffffff81027d57>] cpu_idle+0x2f/0xbf
 [<ffffffff81e61bef>] rest_init+0xc3/0xca
 [<ffffffff81e61b2c>] ? rest_init+0x0/0xca
 [<ffffffff82b95d83>] start_kernel+0x346/0x34e
 [<ffffffff82b952a0>] x86_64_start_reservations+0xa7/0xab
 [<ffffffff82b9539c>] x86_64_start_kernel+0xf8/0x107

