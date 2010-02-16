Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab0BPQbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 11:31:25 -0500
Received: from www.tglx.de ([62.245.132.106]:41995 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757220Ab0BPQbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 11:31:23 -0500
Date: Tue, 16 Feb 2010 17:30:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: naresh kamboju <naresh.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, ltt-dev@lists.casi.polymtl.ca
Subject: Re: LTTng0.158 Linux-2629-RT kernel BUG: sleeping function called
 from invalid context at kernel/rtmutex.c:685
In-Reply-To: <1266337450.24271.140.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.1002161727570.2811@localhost.localdomain>
References: <f5a7b3811002160717y65b4577buf53e5784c71575c3@mail.gmail.com> <1266337450.24271.140.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010, Steven Rostedt wrote:

> On Tue, 2010-02-16 at 20:47 +0530, naresh kamboju wrote:
> > Hi,
> > 
> > After applying LTTng 0.158 patches on 2.6.29-RT with SMP and NON-SMP
> > found BUG on ARM target.
> > LTTng 0.158 patches with 2.6.29 is working fine.
> > 
> > Linux kernel: 2.6.29-RT
> > RT patches: patch-2.6.29.6-rt24-broken-out.tar.bz2
> > http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29.6-rt24-broken-out.tar.bz2
> > 
> > LTTng 0.158 patches are applied.
> > ARCH: ARM
> > Glibc: 2.9
> > gcc: 4.3.3
> 
> Do you get this without the LTTng patches applied?

I bet you wont.
 
> > 
> > dmesg
> > {{{
> > BUG: sleeping function called from invalid context at kernel/rtmutex.c:685
> > in_atomic(): 1, irqs_disabled(): 128, pid: 720, name: lttd

----------------------------------------------------------^^^^

> > Backtrace:
> > [<c002d434>] (dump_backtrace+0x0/0x10c) from [<c03a75d8>] (dump_stack+0x18/0x1c)
> >  r7:000002ad r6:c045da78 r5:00001116 r4:c04ba400
> > [<c03a75c0>] (dump_stack+0x0/0x1c) from [<c0041028>] (__might_sleep+0x120/0x14c)
> > [<c0040f08>] (__might_sleep+0x0/0x14c) from [<c03a9b18>]
> > (rt_spin_lock+0x38/0x68)
> >  r7:ce319d04 r6:c0763660 r5:c05107a0 r4:c05107a0
> > [<c03a9ae0>] (rt_spin_lock+0x0/0x68) from [<c00570b0>]
> > (lock_timer_base+0x30/0x54)
> >  r4:c05107a0
> > [<c0057080>] (lock_timer_base+0x0/0x54) from [<c00571b4>] (del_timer+0x2c/0x6c)
> >  r8:c0023570 r7:ce319d38 r6:00740000 r5:ceb19ca4 r4:c0763660
> > [<c0057188>] (del_timer+0x0/0x6c) from [<c008e5ec>]
> > (disable_synthetic_tsc_ipi+0x24/0x30)
> >  r5:ceb19ca4 r4:00000001
> > [<c008e5c8>] (disable_synthetic_tsc_ipi+0x0/0x30) from [<c0072e00>]
> > (generic_smp_call_function_single_interrupt+0x98/0xf4)
> > [<c0072d68>] (generic_smp_call_function_single_interrupt+0x0/0xf4)
> > from [<c0028368>] (do_IPI+0xc8/0x15c)
> > [<c00282a0>] (do_IPI+0x0/0x15c) from [<c00280c4>] (_text+0xc4/0x128)

The function is called from an IPI. That's a LTTNG problem, not a RT one.

Thanks,

	tglx
