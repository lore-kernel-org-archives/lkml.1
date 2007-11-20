Return-Path: <linux-kernel-owner+w=401wt.eu-S1763619AbXKTUzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763619AbXKTUzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbXKTUzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:55:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47984 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbXKTUzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:55:08 -0500
Date: Tue, 20 Nov 2007 21:54:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Subject: Re: nohz and strange sleep latencies
Message-ID: <20071120205454.GD10008@elte.hu>
References: <20071119203152.GA1772@elf.ucw.cz> <20071119205555.GA28696@elte.hu> <20071119211142.GA1857@elf.ucw.cz> <20071120085704.GA19950@elte.hu> <20071120105458.GA1597@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120105458.GA1597@elf.ucw.cz>
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


* Pavel Machek <pavel@ucw.cz> wrote:

> > and send us the output? (Enabling CONFIG_TIMER_STATS, 
> > CONFIG_SCHED_DEBUG and CONFIG_SCHEDSTATS would maximize the amount 
> > of information.)
> 
> This was w/o hpet=disable . Do you want me to test with hpet=disable?

no, this is fine. You've got a hpet clockevents driver and two lapic 
drivers:

Clock Event Device: hpet
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast

Clock Event Device: lapic
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Clock Event Device: lapic
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

to me this has the feeling of lapic breakage in C2 mode. Does it get any 
better if you boot with 'nolapic'? (but that might in turn turn off 
high-res timers and nohz in essence) Thomas, any ideas?

	Ingo
