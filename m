Return-Path: <linux-kernel-owner+w=401wt.eu-S1760670AbZBMDJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760670AbZBMDJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 22:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755152AbZBMDJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 22:09:26 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:33492 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbZBMDJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 22:09:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=knDj5oyx5/Dor3uYqm7KRLo4uJB+J2KRED1BVWYxS5/LgrYLl4i+qPSX8jiZaIfFMF
         NuFur8AlM6a18swDWXPWz/PlGksQCew0Ldgg+0mTJmAD0qEDFS+fY0J4CqmcYPuN7zKA
         Ff+8AcoQioW9PRO+xFFNlPhk+avfi+avbn/24=
Date: Fri, 13 Feb 2009 04:09:20 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Gleixner <tglx@tglx.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
Subject: Re: [Announce] 2.6.29-rc4-rt2
Message-ID: <20090213030919.GA5826@nowhere>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain> <20090213004812.GA5824@nowhere> <20090213021626.GA5807@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213021626.GA5807@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 03:16:26AM +0100, Frederic Weisbecker wrote:
> On Fri, Feb 13, 2009 at 01:48:12AM +0100, Frederic Weisbecker wrote:
> > On Thu, Feb 12, 2009 at 11:56:38PM +0100, Thomas Gleixner wrote:
> > > We are pleased to announce the first update to our new preempt-rt
> > > series. It fixes the reported bugs and some more.
> > > 
> > > Download locations:
> > > 
> > >    http://rt.et.redhat.com/download/
> > >    http://www.kernel.org/pub/linux/kernel/projects/rt/
> > >  
> > > Information on the RT patch can be found at:
> > > 
> > >   http://rt.wiki.kernel.org/index.php/Main_Page
> > > 
> > > to build the 2.6.29-rc4-rt2 tree, the following patches should be
> > > applied:
> > > 
> > >   http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.29-rc4.tar.bz2
> > >   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29-rc4-rt2.bz2
> > > 
> > > The broken out patches are also available at the same download
> > > locations.
> > > 
> > > Enjoy !
> > > 
> > >       Thomas, Ingo
> > 
> > 
> > Hi,
> > 
> > It fixes the rt-concerned warning I had.
> > Now, a new little lockdep info, tell me if you need my config, I changed
> > it a bit:
> > 
> > [    0.012874] INFO: trying to register non-static key.
> > [    0.012940] the code is fine but needs lockdep annotation.
> > [    0.013008] turning off the locking correctness validator.
> > [    0.013847] Pid: 0, comm: swapper Not tainted 2.6.29-rc4-rt2-tip #2
> > [    0.013917] Call Trace:
> > [    0.013981]  [<ffffffff80285985>] __lock_acquire+0x1825/0x1b20
> > [    0.014053]  [<ffffffff802846fb>] ? __lock_acquire+0x59b/0x1b20
> > [    0.014125]  [<ffffffff80283326>] ? mark_held_locks+0x56/0xa0
> > [    0.014197]  [<ffffffff80285d1f>] lock_acquire+0x9f/0xe0
> > [    0.014267]  [<ffffffff80780ea8>] ? rt_spin_lock_slowlock+0x38/0x310
> > [    0.014342]  [<ffffffff80783211>] __spin_lock_irqsave+0x51/0x70
> > [    0.014415]  [<ffffffff80780ea8>] ? rt_spin_lock_slowlock+0x38/0x310
> > [    0.014489]  [<ffffffff80780ea8>] rt_spin_lock_slowlock+0x38/0x310
> > [    0.014562]  [<ffffffff802836dc>] ? debug_check_no_locks_freed+0x9c/0x160
> > [    0.014636]  [<ffffffff80781edc>] rt_spin_lock+0x4c/0xa0
> > [    0.014706]  [<ffffffff80276f51>] compat_down_timeout+0x21/0x60
> > [    0.014780]  [<ffffffff804910ca>] acpi_os_wait_semaphore+0x4e/0x5d
> > [    0.014853]  [<ffffffff804aafa9>] acpi_ut_acquire_mutex+0x43/0x87
> > [    0.014926]  [<ffffffff804a06cd>] acpi_ns_root_initialize+0x28/0x2ab
> > [    0.014999]  [<ffffffff80449d88>] ? __raw_spin_lock_init+0x38/0x70
> > [    0.015073]  [<ffffffff80acbd6a>] acpi_initialize_subsystem+0x69/0x91
> > [    0.015147]  [<ffffffff80acc24a>] acpi_early_init+0x50/0xf5
> > [    0.015219]  [<ffffffff80aa1ea5>] start_kernel+0x3d2/0x4ca
> > [    0.015290]  [<ffffffff80aa12b9>] x86_64_start_reservations+0x99/0xb9
> > [    0.015362]  [<ffffffff80aa13d5>] x86_64_start_kernel+0xfc/0x10b
> > [    0.015436]  [<ffffffff80aa1140>] ? early_idt_handler+0x0/0x71
> > 
> > Oh and I just tested the tracers.
> > It seems to run fine for all of them except sysprof.
> > It passes the self-test but doesn't produce any trace when I manually try.
> > 
> > Not completely sure this is only in -rt so I'm pulling very latest -tip
> > and will see if I find the same problem there.
> 
> 
> About sysprof, it's an -rt problem, I don't see it on -tip.
> The sysprof hrtimer callback is never called.
> 
> I'm digging to see what is happening.

I didn't put my ftrace_printk at the right place.
It doesn't come from hrtimer.
The problem comes from get_irq_regs() which always returns NULL on the
sysprof hrtimer calback, then the trace is immediately dropped
by sysprof.

That's weird, smp_apic_timer_interrupt() calls set_irq_regs() so
it should find it.

Now I'm preempted by my bed.

