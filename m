Return-Path: <linux-kernel-owner+w=401wt.eu-S1761132AbYEILhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761132AbYEILhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbYEILgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:36:54 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:43758 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbYEILgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:36:53 -0400
Date: Fri, 9 May 2008 12:36:00 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Peter Zijlstra <peterz@infradead.org>
cc: Theodore Tso <tytso@MIT.EDU>, Glauber Costa <gcosta@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: Possible regression?  2.6.26-rc1: T61s failure after suspend/resume
In-Reply-To: <1210331774.13978.230.camel@twins>
Message-ID: <Pine.LNX.4.64.0805091231430.18088@blonde.site>
References: <E1JuCBA-0002NZ-4E@closure.thunk.org>  <Pine.LNX.4.64.0805082148060.3994@blonde.site>
  <20080509025956.GC8871@mit.edu> <1210331774.13978.230.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2008, Peter Zijlstra wrote:
> On Thu, 2008-05-08 at 22:59 -0400, Theodore Tso wrote:
> 
> > [    2.097919] =================================
> > [    2.098059] [ INFO: inconsistent lock state ]
> > [    2.098136] 2.6.25-numa-04462-g10c993a #23
> > [    2.098209] ---------------------------------
> > [    2.098284] inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
> > [    2.098359] swapper/0 [HC0[0]:SC0[0]:HE1:SE1] takes:
> > [    2.098434]  (&rq->rq_lock_key){++..}, at: [sched_clock_idle_wakeup_event+67/116] sched_clock_idle_wakeup_event+0x43/0x74
> > [    2.098753] {in-hardirq-W} state was registered at:
> > [    2.098833]   [__lock_acquire+1023/2834] __lock_acquire+0x3ff/0xb12
> > [    2.099082]   [lock_acquire+106/144] lock_acquire+0x6a/0x90
> > [    2.099329]   [_spin_lock+28/73] _spin_lock+0x1c/0x49
> > [    2.099590]   [scheduler_tick+67/443] scheduler_tick+0x43/0x1bb
> > [    2.099836]   [update_process_times+61/73] update_process_times+0x3d/0x49
> > [    2.100083]   [tick_periodic+102/114] tick_periodic+0x66/0x72
> > [    2.100327]   [tick_handle_periodic+25/106] tick_handle_periodic+0x19/0x6a
> > [    2.100574]   [timer_interrupt+72/115] timer_interrupt+0x48/0x73
> > [    2.100822]   [handle_IRQ_event+26/79] handle_IRQ_event+0x1a/0x4f
> > [    2.101064]   [handle_level_irq+127/202] handle_level_irq+0x7f/0xca
> > [    2.101316]   [do_IRQ+169/210] do_IRQ+0xa9/0xd2
> > [    2.101563]   [<ffffffff>] 0xffffffff
> > [    2.101806] irq event stamp: 1772935
> > [    2.101883] hardirqs last  enabled at (1772935): [native_sched_clock+231/255] native_sched_clock+0xe7/0xff
> > [    2.102091] hardirqs last disabled at (1772934): [native_sched_clock+109/255] native_sched_clock+0x6d/0xff
> > [    2.102298] softirqs last  enabled at (1772496): [__do_softirq+249/255] __do_softirq+0xf9/0xff
> > [    2.102501] softirqs last disabled at (1772491): [do_softirq+113/206] do_softirq+0x71/0xce
> > [    2.102708] 
> > [    2.102709] other info that might help us debug this:
> > [    2.102850] no locks held by swapper/0.
> > [    2.102923] 
> > [    2.102924] stack backtrace:
> > [    2.103067] Pid: 0, comm: swapper Not tainted 2.6.25-numa-04462-g10c993a #23
> > [    2.103145]  [print_usage_bug+263/276] print_usage_bug+0x107/0x114
> > [    2.103278]  [mark_lock+491/924] mark_lock+0x1eb/0x39c
> > [    2.103417]  [__lock_acquire+1140/2834] __lock_acquire+0x474/0xb12
> > [    2.103547]  [restore_nocheck+18/21] ? restore_nocheck+0x12/0x15
> > [    2.103740]  [native_sched_clock+231/255] ? native_sched_clock+0xe7/0xff
> > [    2.103929]  [lock_acquire+106/144] lock_acquire+0x6a/0x90
> > [    2.104065]  [sched_clock_idle_wakeup_event+67/116] ? sched_clock_idle_wakeup_event+0x43/0x74
> > [    2.104255]  [_spin_lock+28/73] _spin_lock+0x1c/0x49
> > [    2.104392]  [sched_clock_idle_wakeup_event+67/116] ? sched_clock_idle_wakeup_event+0x43/0x74
> > [    2.104582]  [sched_clock_idle_wakeup_event+67/116] sched_clock_idle_wakeup_event+0x43/0x74
> > [    2.104715]  [<f886c3b3>] acpi_idle_enter_simple+0x19a/0x21b [processor]
> > [    2.104858]  [<f886bfa5>] acpi_idle_enter_bm+0xbe/0x332 [processor]
> > [    2.104999]  [cpuidle_idle_call+99/143] cpuidle_idle_call+0x63/0x8f
> > [    2.105135]  [cpuidle_idle_call+0/143] ? cpuidle_idle_call+0x0/0x8f
> > [    2.105330]  [cpu_idle+182/214] cpu_idle+0xb6/0xd6
> > [    2.105463]  [rest_init+73/75] rest_init+0x49/0x4b
> > [    2.105596]  =======================
> 
> That's not good...
> 
> But I'm failing to see how IRQs get enabled between
> sched_clock_idle_sleep_event() and sched_clock_idle_wakeup_event() in
> acpi_idle_enter_simple().

If this point in Ted's bisection was without your idle irq fixes
(that patch that added trace_hardirqs_on to __sti_mwait, amongst
other things), would that account for it?

Hugh
