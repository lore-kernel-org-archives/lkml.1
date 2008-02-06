Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbYBFSd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbYBFSd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 13:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbYBFSds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 13:33:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39962 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754133AbYBFSdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 13:33:47 -0500
Date: Wed, 6 Feb 2008 10:32:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
Cc: Chris Rankin <rankincj@yahoo.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-acpi@vger.kernel.org
Subject: Re: [BUG] 2.6.24 refuses to boot - NMI watchdog problem?
Message-Id: <20080206103252.d1eb300d.akpm@linux-foundation.org>
In-Reply-To: <200802061322.27174.lenb@kernel.org>
References: <123100.29626.qm@web52901.mail.re2.yahoo.com>
	<20080205153243.dadaace8.akpm@linux-foundation.org>
	<200802061322.27174.lenb@kernel.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008 13:22:26 -0500 Len Brown <lenb@kernel.org> wrote:

> On Tuesday 05 February 2008 18:32, Andrew Morton wrote:
> > On Sat, 2 Feb 2008 23:36:42 +0000 (GMT)
> > Chris Rankin <rankincj@yahoo.com> wrote:
> > 
> > > Hi,
> > > 
> > > I have a 1 GHz Coppermine PC with 512 MB RAM, and it is failing to boot with the nmi_watchdog=1
> > > option. This kernel was rebuilt after doing a "make mrproper". The dmesg log follows:
> > 
> > Can you tell us if earlier kernels worked OK, and if so which version(s)?
> > >From your other mail it appears that 2.6.23 was OK?
> > 
> > > ...
> > >
> > > ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> > > WARNING: at arch/x86/kernel/smp_32.c:561 native_smp_call_function_mask()
> > > Pid: 1, comm: swapper Not tainted 2.6.24 #1
> > >  [<c0112a37>] native_smp_call_function_mask+0x43/0x114
> > >  [<c01149f2>] enable_NMI_through_LVT0+0x0/0x26
> > >  [<c01049b3>] common_interrupt+0x23/0x28
> > >  [<c01149f2>] enable_NMI_through_LVT0+0x0/0x26
> > >  [<c01149f2>] enable_NMI_through_LVT0+0x0/0x26
> > >  [<c0113c07>] smp_call_function+0x1c/0x1f
> > >  [<c01244e2>] on_each_cpu+0x28/0x54
> > >  [<c0115eee>] setup_nmi+0x30/0x47
> > >  [<c032a820>] setup_IO_APIC+0x88c/0xe49
> > >  [<c01b2166>] number+0x159/0x22f
> > >  [<c0103078>] __switch_to+0x23/0x133
> > >  [<c0282231>] _spin_unlock_irq+0xe/0x22
> > >  [<c011bd5a>] finish_task_switch+0x1c/0x50
> > >  [<c02807a5>] schedule+0x527/0x541
> > >  [<c02821a6>] _spin_unlock+0xd/0x21
> > >  [<c028083e>] preempt_schedule+0x43/0x54
> > >  [<c0120c92>] vprintk+0x2c1/0x2fc
> > >  [<c020c610>] device_add+0x318/0x541
> > >  [<c0328084>] native_smp_prepare_cpus+0x45f/0x46f
> > >  [<c01e0b07>] acpi_ns_get_device_callback+0xfe/0x11c
> > >  [<c0282087>] _spin_lock+0xd/0x5a
> > >  [<c011a998>] task_rq_lock+0x28/0x4b
> > >  [<c028220f>] _spin_unlock_irqrestore+0xf/0x23
> > >  [<c011c13f>] set_cpus_allowed+0x86/0x8e
> > >  [<c020e0d9>] __driver_attach+0x0/0x7f
> > >  [<c0209860>] serial8250_set_termios+0x2b4/0x2c8
> > >  [<c031f349>] kernel_init+0x0/0x2b2
> > >  [<c031f39b>] kernel_init+0x52/0x2b2
> > >  [<c0282231>] _spin_unlock_irq+0xe/0x22
> > >  [<c011bd5a>] finish_task_switch+0x1c/0x50
> > >  [<c011cced>] schedule_tail+0x17/0x51
> > >  [<c0103ec2>] ret_from_fork+0x6/0x1c
> > >  [<c031f349>] kernel_init+0x0/0x2b2
> > >  [<c031f349>] kernel_init+0x0/0x2b2
> > >  [<c0104bc3>] kernel_thread_helper+0x7/0x10
> > >  =======================
> > 
> > I think we've fixed that now.  Len: if so, has that fix been sent in for
> > 2.6.24.1?
> 
> No, I don't know of any 2.6.24 oops fixes that aren't already in 2.6.24 --
> at least I can't think of any right now.

Actually on closer inspection I'd say that acpi_ns_get_device_callback is
stack gunk and it isn't involved here.

It isn't clear (to me) where in this mess we disabled interrupts around the
set_cpus_allowed().  Chris, if this is repeatable it would be helpful to
set CONFIG_FRAME_POINTER=y which hopefully will get us a cleaner trace,
thanks.


