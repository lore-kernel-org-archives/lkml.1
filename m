Return-Path: <linux-kernel-owner+w=401wt.eu-S1760247AbZANW44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247AbZANW44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbZANW4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:56:46 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45455 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570AbZANW4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:56:45 -0500
Subject: Re: PCI, ACPI, IRQ, IOAPIC: reroute PCI interrupt to legacy boot
	interrupt equivalent
From: Jon Masters <jcm@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Stefan Assmann <sassmann@suse.de>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Olaf Dabrunz <od@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Sven Dietrich <sdietrich@novell.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
In-Reply-To: <m11vv5wlug.fsf@frodo.ebiederm.org>
References: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain>
	 <496B24E5.1070804@suse.de> <200901121151.53195.bjorn.helgaas@hp.com>
	 <m1d4esxfk2.fsf@frodo.ebiederm.org>
	 <1231806563.4094.25.camel@perihelion.bos.jonmasters.org>
	 <20090113014723.GA11366@elte.hu> <m1prirx3xn.fsf@frodo.ebiederm.org>
	 <1231820798.4094.34.camel@perihelion.bos.jonmasters.org>
	 <20090114114006.GF8625@elte.hu>
	 <1231960709.23174.0.camel@londonpacket.bos.redhat.com>
	 <m11vv5wlug.fsf@frodo.ebiederm.org>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Wed, 14 Jan 2009 17:56:00 -0500
Message-Id: <1231973760.23174.33.camel@londonpacket.bos.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 14:42 -0800, Eric W. Biederman wrote:
> Jon Masters <jcm@redhat.com> writes:
> 
> > On Wed, 2009-01-14 at 12:40 +0100, Ingo Molnar wrote:
> >
> >> it's not just -rt, but it is also needed for the concept of threaded IRQ 
> >> handlers - which was discussed at the Kernel Summit to be desired for 
> >> mainline.
> >
> > Right. I'm poking at Thomas' patches and hope to post something soon on
> > that front - I'm acutely aware that this will be impacted aswell but
> > because it's vaguely RT related had banded it under that banner.
> 
> Stepping back a moment.  The only way I can see this working reliably
> is if we disable the boot interrupt.  Anything that leaves the boot interrupt
> enabled means that when we disable the primary interrupt the boot interrupt
> will scream, and thus we must disable it as well.
> 
> Which leads to my problem with the entire development process of this feature.
> 
>  People want the feature.
>  People don't want to pay attention to the limits of the hardware.
>  Which leads to countless broken patches proposed.

Is a patch broken because hardware has limitations? If that were always
true then many of the patches we see in the kernel wouldn't be there.

> Which leads me to conclude.
> - IRQ handling in the RT kernel is hopelessly broken.

Nope. It's done in a very similar way to other real time kernels already
out there - really there are only so many ways to do this.

> - IRQ threads are a bad idea.

Why? IRQ threads actually make life so much easier - you have a task
context, you can do everything inside that rather than scheduling all
kinds of deferred work (that in RT will be done in another task later),
and so forth.

> None of this works reliably on level triggered ioapic irqs.

Level triggered IOAPIC IRQs have quirks, film at 11!

Jon.


