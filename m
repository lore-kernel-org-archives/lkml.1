Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbZKLXxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbZKLXxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbZKLXxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:53:40 -0500
Received: from www.tglx.de ([62.245.132.106]:33423 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755520AbZKLXxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:53:39 -0500
Date: Fri, 13 Nov 2009 00:53:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: Justin Piszcz <jpiszcz@lucidpixels.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Venkatesch Pallipadi <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: 2.6.31.4: WARNING: at arch/x86/kernel/hpet.c:390
 hpet_next_event+0x70/0x80() [occurs when ACPI_PROCESSOR=y]
In-Reply-To: <1258069232.14894.9.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0911130045070.24119@localhost.localdomain>
References: <alpine.DEB.2.00.0911080932590.4556@p34.internal.lan>  <20091111195016.GB22225@redhat.com>  <alpine.DEB.2.00.0911111608020.5456@p34.internal.lan>  <alpine.DEB.2.00.0911121120330.6976@p34.internal.lan>  <alpine.DEB.2.00.0911121127500.6976@p34.internal.lan>
  <1f1b08da0911121513l32d47b4x8b9722ad3440ceb6@mail.gmail.com>  <alpine.DEB.2.00.0911121824290.2852@p34.internal.lan> <1258069232.14894.9.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009, john stultz wrote:

> Forgot to CC lkml, re-adding.

Added more CCs
 
> On Thu, 2009-11-12 at 18:25 -0500, Justin Piszcz wrote:
> > On Thu, 12 Nov 2009, john stultz wrote:
> > > On Thu, Nov 12, 2009 at 8:33 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> > >> On Thu, 12 Nov 2009, Justin Piszcz wrote:
> > >>> On Wed, 11 Nov 2009, Justin Piszcz wrote:
> > >>> Again, the problem:
> > >>> [    3.318770] cpuidle: using governor ladder
> > >>> [    3.321556] ------------[ cut here ]------------
> > >>> [    3.321560] WARNING: at arch/x86/kernel/hpet.c:390
> > >>> hpet_next_event+0x70/0x80()
> > >>> [    3.321561] Hardware name:
> > >>> [    3.321562] Modules linked in:
> > >>> [    3.321564] Pid: 0, comm: swapper Not tainted 2.6.31.5 #17
> > >>> [    3.321565] Call Trace:
> > >>> [    3.321567]  [<ffffffff81042f00>] ? hpet_next_event+0x70/0x80
> > >>> [    3.321568]  [<ffffffff81042f00>] ? hpet_next_event+0x70/0x80
> > >>> [    3.321571]  [<ffffffff81056724>] ? warn_slowpath_common+0x74/0xd0
> > >>> [    3.321573]  [<ffffffff81042f00>] ? hpet_next_event+0x70/0x80
> > >>> [    3.321576]  [<ffffffff81077696>] ? tick_dev_program_event+0x36/0xb0
> > >>> [    3.321578]  [<ffffffff81077079>] ?
> > >>> tick_broadcast_oneshot_control+0x119/0x120
> > >>> [    3.321579]  [<ffffffff8107683d>] ? tick_notify+0x22d/0x420
> > >>> [    3.321581]  [<ffffffff8106fe37>] ? notifier_call_chain+0x37/0x70
> > >>> [    3.321583]  [<ffffffff8107612b>] ? clockevents_notify+0x2b/0x90
> > >>> [    3.321586]  [<ffffffff81244848>] ? acpi_idle_enter_bm+0x15f/0x2d3
> > >>> [    3.321587]  [<ffffffff812446de>] ? acpi_idle_enter_c1+0xf1/0xfc
> > >>> [    3.321590]  [<ffffffff812e6d7a>] ? cpuidle_idle_call+0xba/0x120
> > >>> [    3.321593]  [<ffffffff8102b832>] ? cpu_idle+0x62/0xc0
> > >>> [    3.321596] ---[ end trace cac202f11005305c ]---
> > >>> [    3.553852] cpuidle: using governor menu
> > >>
> > >> Other user with this problem:
> > >> http://lkml.org/lkml/2009/10/2/330 - Nobody responded to his report.
> > >>
> > >> This has been also been reported on other forums with no fix / conclusion on
> > >> any type of fix or work-around.
> > >
> > > Looks like your hpet is busted, or maybe something is resetting the
> > > hpet at exactly the wrong time.
> > >
> > > What does booting with the attached patch do?
> > 
> > Unfortunately I cannot login fast enough to get a full dmesg:
> 
> So if you comment out the printk I added, does it boot?
> 
> > It continually scrolls with this:
> > 
> > [   11.463500] hpet_next_event: hpet_writel failed: 0x9c90955 != 0xa0e8b7b
> > [   11.463972] hpet_next_event: hpet_writel failed: 0xa0e8b7b != 0x9cb9398
> > [   11.475121] hpet_next_event: hpet_writel failed: 0x9cb9398 != 0xa0e8b71
> > [   11.475144] hpet_next_event: hpet_writel failed: 0xa0e8b71 != 0x9ce0459
> > [   11.486274] hpet_next_event: hpet_writel failed: 0x9ce0459 != 0xa0e8b61
> > [   11.486343] hpet_next_event: hpet_writel failed: 0xa0e8b61 != 0x9d076c0
> > [   11.497492] hpet_next_event: hpet_writel failed: 0x9d076c0 != 0xa0e8b4c
> > [   11.497962] hpet_next_event: hpet_writel failed: 0xa0e8b4c != 0x9d30119
> > [   11.509111] hpet_next_event: hpet_writel failed: 0x9d30119 != 0xa0e8b3c
> > [   11.509134] hpet_next_event: hpet_writel failed: 0xa0e8b3c != 0x9d571a9
> > [   11.520275] hpet_next_event: hpet_writel failed: 0x9d571a9 != 0xa0e8b2f
> > [   11.520293] hpet_next_event: hpet_writel failed: 0xa0e8b2f != 0x9d7e24d
> > [   11.531443] hpet_next_event: hpet_writel failed: 0x9d7e24d != 0xa0e8b1d
> > [   11.531947] hpet_next_event: hpet_writel failed: 0xa0e8b1d != 0x9da6e46
> > [   11.543095] hpet_next_event: hpet_writel failed: 0x9da6e46 != 0xa0e8b0c
> 
> Huh. That's sort of crazy. It almost seems as though you have two offset
> HPET timers at one timer location that are switching back and forth.
> Looks like either very busted hardware, or something new the kernel
> doesn't expect.
>
> > When I do not load processor.ko though, the error does not occur?

Please boot w/o loading that module and post your full bootlog.

Thanks,

	tglx
