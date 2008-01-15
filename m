Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbYAOJ2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbYAOJ2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 04:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbYAOJ2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 04:28:40 -0500
Received: from mail.gmx.net ([213.165.64.20]:38347 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751076AbYAOJ2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 04:28:38 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+sRN4Gc06sVKEBLXiJfgvpsoBZJ8Zgu2BhHeFVtN
	mVssQoIyTR+XHn
Subject: Re: 2.6.24-rc7-rt1
From: Mike Galbraith <efault@gmx.de>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>
In-Reply-To: <1200384437.4113.16.camel@homer.simson.net>
References: <1200250801.9190.7.camel@localhost.localdomain>
	 <200801132143.34889.m.kozlowski@tuxland.pl>
	 <Pine.LNX.4.58.0801131552350.10093@gandalf.stny.rr.com>
	 <1200299260.4665.17.camel@homer.simson.net>
	 <478B0B7C.BA47.005A.0@novell.com>
	 <1200317101.3733.14.camel@homer.simson.net>
	 <1200384437.4113.16.camel@homer.simson.net>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 10:28:35 +0100
Message-Id: <1200389315.4130.3.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


debug resume trace

static inline int pick_optimal_cpu(int this_cpu, cpumask_t *mask)
{
	int first;

	/* "this_cpu" is cheaper to preempt than a remote processor */
	if ((this_cpu != -1) && cpu_isset(this_cpu, *mask))
		return this_cpu;

	first = first_cpu(*mask);
	if (first != NR_CPUS) {
		if (!cpu_online(first)) {
			WARN_ON_ONCE(1);
			return -1;
		}
		return first;
	}

	return -1;
}

[  156.344352] CPU1 is down
[    3.726557] Intel machine check architecture supported.
[    3.726565] Intel machine check reporting enabled on CPU#0.
[    3.726567] CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
[    3.726570] CPU0: Thermal monitoring enabled
[    3.726576] Back to C!
[    3.727107] Force enabled HPET at resume
[    3.727193] Enabling non-boot CPUs ...
[    3.727446] CPU0 attaching NULL sched-domain.
[    3.727550] WARNING: at kernel/sched_rt.c:385 pick_optimal_cpu()
[    3.727553] Pid: 27, comm: events/0 Not tainted 2.6.24-rt2-smp #73
[    3.727556]  [<b010522a>] show_trace_log_lvl+0x1a/0x30
[    3.727564]  [<b0105ccd>] show_trace+0x12/0x14
[    3.727567]  [<b010641f>] dump_stack+0x6c/0x72
[    3.727569]  [<b0120b0f>] find_lowest_rq+0x199/0x1af
[    3.727573]  [<b0120beb>] push_rt_task+0x6e/0x1ed
[    3.727575]  [<b01276a3>] switched_to_rt+0x39/0x55
[    3.727579]  [<b0128cd1>] task_setprio+0xbf/0x18f
[    3.727581]  [<b014c21e>] __rt_mutex_adjust_prio+0x19/0x1c
[    3.727585]  [<b014c943>] task_blocks_on_rt_mutex+0x14e/0x17e
[    3.727588]  [<b02f2e18>] rt_spin_lock_slowlock+0xed/0x16a
[    3.727593]  [<b02f351a>] __rt_spin_lock+0x41/0x48
[    3.727596]  [<b02f3529>] rt_spin_lock+0x8/0xa
[    3.727598]  [<b013f2c2>] finish_wait+0x25/0x49
[    3.727602]  [<b013c746>] worker_thread+0x64/0xe1
[    3.727605]  [<b013efb2>] kthread+0x39/0x5b
[    3.727607]  [<b0104e83>] kernel_thread_helper+0x7/0x14
[    3.727610]  =======================
[    3.727624] SMP alternatives: switching to SMP code
[    3.728314] Booting processor 1/1 eip 3000


