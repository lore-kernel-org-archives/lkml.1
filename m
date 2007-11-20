Return-Path: <linux-kernel-owner+w=401wt.eu-S1751001AbXKTWtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751001AbXKTWtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:49:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762835AbXKTWsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:48:21 -0500
Received: from www.tglx.de ([62.245.132.106]:56257 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761575AbXKTWsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:48:20 -0500
Date: Tue, 20 Nov 2007 23:48:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: nohz and strange sleep latencies
In-Reply-To: <20071120205454.GD10008@elte.hu>
Message-ID: <alpine.LFD.0.9999.0711202345520.25057@localhost.localdomain>
References: <20071119203152.GA1772@elf.ucw.cz> <20071119205555.GA28696@elte.hu> <20071119211142.GA1857@elf.ucw.cz> <20071120085704.GA19950@elte.hu> <20071120105458.GA1597@elf.ucw.cz> <20071120205454.GD10008@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > > and send us the output? (Enabling CONFIG_TIMER_STATS, 
> > > CONFIG_SCHED_DEBUG and CONFIG_SCHEDSTATS would maximize the amount 
> > > of information.)
> > 
> > This was w/o hpet=disable . Do you want me to test with hpet=disable?
> 
> no, this is fine. You've got a hpet clockevents driver and two lapic 
> drivers:
> 
> Clock Event Device: hpet
>  set_next_event: hpet_legacy_next_event
>  set_mode:       hpet_legacy_set_mode
>  event_handler:  tick_handle_oneshot_broadcast
> 
> Clock Event Device: lapic
>  set_next_event: lapic_next_event
>  set_mode:       lapic_timer_setup
>  event_handler:  hrtimer_interrupt
> 
> Clock Event Device: lapic
>  set_next_event: lapic_next_event
>  set_mode:       lapic_timer_setup
>  event_handler:  hrtimer_interrupt
> 
> to me this has the feeling of lapic breakage in C2 mode. Does it get any 
> better if you boot with 'nolapic'? (but that might in turn turn off 
> high-res timers and nohz in essence) Thomas, any ideas?

Hmm, lapic is considered unstable in c2 by default. You have to tell
the kernel that you trust it in C2 on the command line.

/me goes back to read the logs

    tglx
