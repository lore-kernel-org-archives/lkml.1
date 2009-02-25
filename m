Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbZBYNYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbZBYNYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 08:24:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbZBYNXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 08:23:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58869 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865AbZBYNXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 08:23:52 -0500
Date: Wed, 25 Feb 2009 14:23:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during
	suspend-resume
Message-ID: <20090225132325.GB30206@elte.hu>
References: <200902221837.49396.rjw@sisk.pl> <200902250007.13069.rjw@sisk.pl> <20090224230935.GA15165@elte.hu> <200902250029.16107.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902250029.16107.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Wednesday 25 February 2009, Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > On Tuesday 24 February 2009, Linus Torvalds wrote:
> > > > 
> > > > On Tue, 24 Feb 2009, Rafael J. Wysocki wrote:
> > > > >
> > > > > > The only safe way on x86 to shutdown a level triggered ioapic irq
> > > > > > outside of irq context is for the driver to program the hardware to
> > > > > > not generate an irq.
> > > > > 
> > > > > Well, that changes things quite a bit, because it means we can't change the
> > > > > suspend-resume sequence in a way we thought we could without fixing all
> > > > > drivers first, but this is exactly what we'd like to avoid by changing the
> > > > > core.
> > > > 
> > > > Calling "disable_irq()" is perfectly fine.
> > > > 
> > > > What is not possible on that broken IO-APIC (among other 
> > > > things) is to actually turn the interrupts off at the apic 
> > > > (ie the whole ->shutdown() thing). But that's not what we 
> > > > even want to do. What we care about is just disabling the 
> > > > interrupt from a drievr perspective.
> > > > 
> > > > IOW, the patches I have seen are fine, and all the comments 
> > > > from Eric are just confusion about what we want done.
> > > 
> > > Ah, OK.  Thanks for the explanation, I got confused too.
> > > 
> > > > WE DO NOT WANT TO TURN OFF THE IO-APIC. That may or may 
> > > > happen later, but that's totally unrelated to this whole 
> > > > "suspend_device_irq()" thing.
> > > 
> > > Yeah.
> > 
> > We definitely dont want to turn off x86 IO-APICs - the timer IRQ 
> > goes via one of them.
> 
> No, we don't.  At least not at this point.
> 
> BTW, appended is the current (3rd) version of the $subject patch with some
> of your comments taken into account.  In particular, I did the following:
> - moved [suspend|resume]_device_irqs() to a separate file (pm.c)
> - fixed interrupt.h so that their headers are at a better place
> - made enable_irq() clear IRQ_SUSPENDED
> - made device_power_down() and device_power_up() call
>   suspend_device_irqs() and resume_device_irqs(), respectively, which
>   simplified the callers quite a bit (it changed the Xen code ordering, though,
>   but I _think_ it still should work).
> 
> Please have a look.

Looks good, thanks Rafael!

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
