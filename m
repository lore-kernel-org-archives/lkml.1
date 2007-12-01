Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbXLAXqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbXLAXqt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 18:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbXLAXqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 18:46:42 -0500
Received: from lazybastard.de ([212.112.238.170]:37019 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbXLAXql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 18:46:41 -0500
Date: Sun, 2 Dec 2007 00:41:13 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: J??rn Engel <joern@logfs.org>, Mark Lord <lkml@rtr.ca>,
       Pavel Machek <pavel@ucw.cz>, Mark Lord <liml@rtr.ca>,
       Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071201234112.GA7209@lazybastard.org>
References: <20071115193612.GA751@elte.hu> <20071130125628.GA30773@lazybastard.org> <20071130133546.GB29679@elte.hu> <20071130134312.GA32273@elte.hu> <20071130183510.GA1570@lazybastard.org> <20071130184625.GB9928@elte.hu> <20071201151650.GA5031@lazybastard.org> <20071201183256.GA14052@elte.hu> <20071201204747.GA6458@lazybastard.org> <20071201205456.GA8231@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20071201205456.GA8231@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 December 2007 21:54:56 +0100, Ingo Molnar wrote:
> * J??rn Engel <joern@logfs.org> wrote:
> > 
> > stopped custom tracer.
> > BUG: spinlock recursion on CPU#0, sh/953
> >  lock: c030f280, .magic: dead4ead, .owner: sh/953, .owner_cpu: 0
> > Pid: 953, comm: sh Not tainted 2.6.24-rc3-ge1cca7e8-dirty #2
> >  [<c0103a04>] show_trace_log_lvl+0x35/0x54
> >  [<c010450a>] show_trace+0x2c/0x2e
> >  [<c0104e6d>] dump_stack+0x84/0x8a
> >  [<c01ded7c>] spin_bug+0xa7/0xae
> >  [<c01def14>] _raw_spin_lock+0x45/0xfa
> >  [<c02a02b1>] _spin_lock_irqsave+0x68/0x7a
> >  [<c01087e7>] pit_read+0x14/0x99
> >  [<c0130ee9>] get_monotonic_cycles+0xf/0x2d
> 
> ah. You should mark pit_read() function as notrace. PIT clocksource is 
> rare. (add the 'notrace' word to the function prototype)

Hardly a change at all.  Apart from some offsets, this dump is
identical.

stopped custom tracer.
BUG: spinlock recursion on CPU#0, sh/954
 lock: c030f280, .magic: dead4ead, .owner: sh/954, .owner_cpu: 0
Pid: 954, comm: sh Not tainted 2.6.24-rc3-ge1cca7e8-dirty #3
 [<c0103a04>] show_trace_log_lvl+0x35/0x54
 [<c010450a>] show_trace+0x2c/0x2e
 [<c0104e6d>] dump_stack+0x84/0x8a
 [<c01ded7c>] spin_bug+0xa7/0xae
 [<c01def14>] _raw_spin_lock+0x45/0xfa
 [<c02a02b1>] _spin_lock_irqsave+0x68/0x7a
 [<c01087e2>] pit_read+0xf/0x91
 [<c0130ee1>] get_monotonic_cycles+0xf/0x2d
 [<c013c0e7>] now+0x2a/0x7c
 [<c013c333>] ____trace+0x4d/0x1e8
 [<c013dbeb>] __mcount+0x95/0xa6
 [<c010d354>] mcount+0x14/0x18
 [<c0135a3c>] lock_acquired+0xe/0x1d7
 [<c02a02b9>] _spin_lock_irqsave+0x70/0x7a
 [<c01087e2>] pit_read+0xf/0x91
 [<c0130789>] update_wall_time+0x23/0x692
 [<c012174e>] do_timer+0x24/0xb1
 [<c01331f6>] tick_periodic+0x49/0x84
 [<c0133253>] tick_handle_periodic+0x22/0x73
 [<c0106315>] timer_interrupt+0x4f/0x56
 [<c013e2bf>] handle_IRQ_event+0x24/0x4f
 [<c013f442>] handle_edge_irq+0xb8/0x125
 [<c01054ee>] do_IRQ+0x89/0xa3
 [<c01033df>] common_interrupt+0x23/0x28
 [<c010d354>] mcount+0x14/0x18
 [<c0120130>] sysctl_head_finish+0xc/0x33
 [<c0192d64>] proc_sys_write+0x96/0xa0
 [<c015d91c>] vfs_write+0xa6/0x14c
 [<c015df66>] sys_write+0x4c/0x70
 [<c0102a1f>] syscall_call+0x7/0xb
 =======================

Jörn

-- 
Don't worry about people stealing your ideas. If your ideas are any good,
you'll have to ram them down people's throats.
-- Howard Aiken quoted by Ken Iverson quoted by Jim Horning quoted by
   Raph Levien, 1979
