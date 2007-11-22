Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbXKVSvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbXKVSvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 13:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbXKVSvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 13:51:15 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:35230 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbXKVSvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 13:51:15 -0500
Date: Thu, 22 Nov 2007 19:51:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: nohz and strange sleep latencies
Message-ID: <20071122185121.GA1803@elf.ucw.cz>
References: <20071119203152.GA1772@elf.ucw.cz> <20071119205555.GA28696@elte.hu> <20071119211142.GA1857@elf.ucw.cz> <20071120085704.GA19950@elte.hu> <20071120105458.GA1597@elf.ucw.cz> <20071120205454.GD10008@elte.hu> <alpine.LFD.0.9999.0711202345520.25057@localhost.localdomain> <20071120225246.GA24380@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120225246.GA24380@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Clock Event Device: hpet
> > >  set_next_event: hpet_legacy_next_event
> > >  set_mode:       hpet_legacy_set_mode
> > >  event_handler:  tick_handle_oneshot_broadcast
> > > 
> > > Clock Event Device: lapic
> > >  set_next_event: lapic_next_event
> > >  set_mode:       lapic_timer_setup
> > >  event_handler:  hrtimer_interrupt
> > > 
> > > Clock Event Device: lapic
> > >  set_next_event: lapic_next_event
> > >  set_mode:       lapic_timer_setup
> > >  event_handler:  hrtimer_interrupt
> > > 
> > > to me this has the feeling of lapic breakage in C2 mode. Does it get any 
> > > better if you boot with 'nolapic'? (but that might in turn turn off 
> > > high-res timers and nohz in essence) Thomas, any ideas?
> > 
> > Hmm, lapic is considered unstable in c2 by default. You have to tell 
> > the kernel that you trust it in C2 on the command line.
> 
> yeah, i was wondering about that too. ACPI enumerated them properly at a 
> certain stage:
> 
>  ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
>  ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
> 
> but perhaps somehow we miss this fact and fail to turn off the lapic 
> clockevents drivers?

I can confirm that setting max-cstate=1 helps. (Plus, problem gets
_way_ more visible with stripped down config. With usb and irda off,
time sleep .01 easily takes 2 seconds).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
