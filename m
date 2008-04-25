Return-Path: <linux-kernel-owner+w=401wt.eu-S1759218AbYDYO7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218AbYDYO7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 10:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbYDYO7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 10:59:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41888 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbYDYO7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 10:59:44 -0400
Subject: Re: [ INFO: iconsistent lock state ]
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       "Brown, Len" <len.brown@intel.com>
In-Reply-To: <dd18b0c30804250747u4168bafsccc6feec0ba78c26@mail.gmail.com>
References: <dd18b0c30804241724t2dcc044dvab4a5ad506255d8d@mail.gmail.com>
	 <1209125470.24931.10.camel@lappy>
	 <dd18b0c30804250747u4168bafsccc6feec0ba78c26@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 25 Apr 2008 16:59:09 +0200
Message-Id: <1209135549.32291.5.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-25 at 14:47 +0000, Justin Mattock wrote:
> On Fri, Apr 25, 2008 at 12:11 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Fri, 2008-04-25 at 00:24 +0000, Justin Mattock wrote:
> >
> >  > [   13.269763] =================================
> >  > [   13.270954] [ INFO: inconsistent lock state ]
> >  > [   13.271865] 2.6.25-04569-gb69d398 #3
> >
> >  What tree is that? git checkout gb69d398 doesn't want to happen here.

Argh, s/g// so the hash is: b69d398

Could we make that -git-# ?

> >  > [   13.272614] ---------------------------------
> >  > [   13.273521] inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
> >  > [   13.274745] swapper/0 [HC0[0]:SC0[0]:HE1:SE1] takes:
> >  > [   13.275787]  (&rq->rq_lock_key){++..}, at: [<c01208e9>] sched_clock_idle_wakeup_event+0x43/0x74
> >  > [   13.276859] {in-hardirq-W} state was registered at:
> >  > [   13.276859]   [<c01423d8>] __lock_acquire+0x419/0xb70
> >  > [   13.276859]   [<c0142bae>] lock_acquire+0x7f/0xa6
> >  > [   13.280188]   [<c0394132>] _spin_lock+0x1c/0x49
> >  > [   13.280188]   [<c0121c44>] scheduler_tick+0x43/0x1bd
> >  > [   13.280188]   [<c012d99f>] update_process_times+0x3d/0x49
> >  > [   13.283524]   [<c013daf6>] tick_periodic+0x66/0x72
> >  > [   13.283524]   [<c013db1b>] tick_handle_periodic+0x19/0x6a
> >  > [   13.283524]   [<c0105a87>] timer_interrupt+0x47/0x4e
> >  > [   13.286855]   [<c015cf64>] handle_IRQ_event+0x1a/0x4f
> >  > [   13.286855]   [<c015e3e9>] handle_level_irq+0x7f/0xca
> >  > [   13.286855]   [<c0105a27>] do_IRQ+0x71/0x8a
> >  > [   13.290190]   [<c01043fe>] common_interrupt+0x2e/0x34
> >  > [   13.290190]   [<c038bd6f>] calibrate_delay+0x8f/0x276
> >  > [   13.290190]   [<c04f0883>] start_kernel+0x27c/0x2f8
> >  > [   13.293520]   [<c04f0008>] __init_begin+0x8/0xa
> >  > [   13.293520]   [<ffffffff>] 0xffffffff
> >  > [   13.293520] irq event stamp: 253965
> >  > [   13.296856] hardirqs last  enabled at (253965): [<c0108069>] native_sched_clock+0xe7/0xff
> >  > [   13.296856] hardirqs last disabled at (253964): [<c0107fef>] native_sched_clock+0x6d/0xff
> >  > [   13.300190] softirqs last  enabled at (253958): [<c0129cea>] __do_softirq+0xf9/0xff
> >  > [   13.300190] softirqs last disabled at (253953): [<c0129d3d>] do_softirq+0x4d/0x79
> >  > [   13.303522]
> >  > [   13.303522] other info that might help us debug this:
> >  > [   13.303522] no locks held by swapper/0.
> >  > [   13.303522]
> >  > [   13.303522] stack backtrace:
> >  > [   13.306852] Pid: 0, comm: swapper Not tainted 2.6.25-04569-gb69d398 #3
> >  > [   13.336851]  [<c01409f9>] print_usage_bug+0x106/0x113
> >  > [   13.340185]  [<c0141823>] mark_lock+0x1ed/0x3a5
> >  > [   13.343519]  [<c014244d>] __lock_acquire+0x48e/0xb70
> >  > [   13.346852]  [<c0142bae>] lock_acquire+0x7f/0xa6
> >  > [   13.350185]  [<c01208e9>] ? sched_clock_idle_wakeup_event+0x43/0x74
> >  > [   13.353519]  [<c0394132>] _spin_lock+0x1c/0x49
> >  > [   13.360185]  [<c01208e9>] ? sched_clock_idle_wakeup_event+0x43/0x74
> >  > [   13.363518]  [<c01208e9>] sched_clock_idle_wakeup_event+0x43/0x74

Got it:

  acpi_idle_do_entry()
    acpi_processor_ffh_cstate_enter()
      mwait_idle_with_hints() (32 bit)
        local_irq_enable()

  sched_clock_idle_wakeup_event()


I think my recent idle patches should address this, no?

> >  > [   13.366851]  [<f883919b>] acpi_idle_enter_bm+0x2b3/0x333 [processor]
> >  > [   13.370184]  [<c02e5ec1>] cpuidle_idle_call+0x63/0x92
> >  > [   13.373517]  [<c02e5e5e>] ? cpuidle_idle_call+0x0/0x92
> >  > [   13.380184]  [<c010257d>] cpu_idle+0xb6/0xd6
> >  > [   13.383517]  [<c0387071>] rest_init+0x49/0x4b
> >  > [   13.386850]  =======================
> >
> >  looking at current -linus I'm not directly seeing how we can get there
> >  with interrupts enabled.
> >

