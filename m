Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537Ab0AYKgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab0AYKgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 05:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348Ab0AYKgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 05:36:48 -0500
Received: from www.tglx.de ([62.245.132.106]:37892 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab0AYKgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 05:36:47 -0500
Date: Mon, 25 Jan 2010 11:35:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Shawn Starr <shawn.starr@rogers.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14859] System timer firing too much without cause
In-Reply-To: <201001241734.50803.shawn.starr@rogers.com>
Message-ID: <alpine.LFD.2.00.1001251103200.2906@localhost.localdomain>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <hE3x9c-4KZM.A.Z6G.gLMXLB@chimera> <201001241734.50803.shawn.starr@rogers.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jan 2010, Shawn Starr wrote:

> On Sunday 24 January 2010 17:04:33 Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).

Why is this on the regression list at all ? The report says that this
is happening with 33-rcX, but there is no comparison to the behaviour
of 32 or earlier kernels on that machine. Instead we have a comparison
of apples and oranges:

> As a comparsion my quad core box has no such issue: (Running 2.6.32-rc7) 
> x86_64
>   0:         42          4          1          1   IO-APIC-edge      timer
>
> my Lenovo ThinkPad W500 (latest BIOS 3.11) laptop shows the system timer 
> flooding the bus (Running 2.6.33-rc1) x86_64
>   0:      66775      70429   IO-APIC-edge      timer <-- keeps rising, rapidly 

So we look at a quad core desktop machine which probably has no deeper
power states and therefor does not use the broadcast timer and compare
it to a laptop which has deeper power states and needs to use the
broadcast timer, which of course increases the number of IRQ0
events. What a surprise.

Can we please remove this from the regression list unless Shawn
confirms that 32 or earlier kernels do not show that behaviour on the
laptop?

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14859
> > Subject		: System timer firing too much without cause
> > Submitter	: Shawn Starr <shawn.starr@rogers.com>
> > Date		: 2009-12-21 19:16 (35 days old)
> 
> Continues with -rc5, I  really cannot use Dynamic ticks at all, it has to be 
> disabled.

Shawn, why can't you use dynamic ticks ? In the bugzilla I just see
that you worry about the IRQ0 interrupts (which are correct and
necessary when the system is in nohz mode) and the extra rescheduling
interrupts. How is the system misbehaving ?

Thanks,

	tglx
