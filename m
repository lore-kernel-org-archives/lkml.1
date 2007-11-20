Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbXKTWxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbXKTWxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbXKTWwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:52:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39240 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbXKTWwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:52:50 -0500
Date: Tue, 20 Nov 2007 23:52:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: nohz and strange sleep latencies
Message-ID: <20071120225246.GA24380@elte.hu>
References: <20071119203152.GA1772@elf.ucw.cz> <20071119205555.GA28696@elte.hu> <20071119211142.GA1857@elf.ucw.cz> <20071120085704.GA19950@elte.hu> <20071120105458.GA1597@elf.ucw.cz> <20071120205454.GD10008@elte.hu> <alpine.LFD.0.9999.0711202345520.25057@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0711202345520.25057@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 20 Nov 2007, Ingo Molnar wrote:
> > 
> > * Pavel Machek <pavel@ucw.cz> wrote:
> > 
> > > > and send us the output? (Enabling CONFIG_TIMER_STATS, 
> > > > CONFIG_SCHED_DEBUG and CONFIG_SCHEDSTATS would maximize the amount 
> > > > of information.)
> > > 
> > > This was w/o hpet=disable . Do you want me to test with hpet=disable?
> > 
> > no, this is fine. You've got a hpet clockevents driver and two lapic 
> > drivers:
> > 
> > Clock Event Device: hpet
> >  set_next_event: hpet_legacy_next_event
> >  set_mode:       hpet_legacy_set_mode
> >  event_handler:  tick_handle_oneshot_broadcast
> > 
> > Clock Event Device: lapic
> >  set_next_event: lapic_next_event
> >  set_mode:       lapic_timer_setup
> >  event_handler:  hrtimer_interrupt
> > 
> > Clock Event Device: lapic
> >  set_next_event: lapic_next_event
> >  set_mode:       lapic_timer_setup
> >  event_handler:  hrtimer_interrupt
> > 
> > to me this has the feeling of lapic breakage in C2 mode. Does it get any 
> > better if you boot with 'nolapic'? (but that might in turn turn off 
> > high-res timers and nohz in essence) Thomas, any ideas?
> 
> Hmm, lapic is considered unstable in c2 by default. You have to tell 
> the kernel that you trust it in C2 on the command line.

yeah, i was wondering about that too. ACPI enumerated them properly at a 
certain stage:

 ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
 ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])

but perhaps somehow we miss this fact and fail to turn off the lapic 
clockevents drivers?

	Ingo
