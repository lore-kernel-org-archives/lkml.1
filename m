Return-Path: <linux-kernel-owner+w=401wt.eu-S1758039AbYIDI3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbYIDI3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757723AbYIDI1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:27:20 -0400
Received: from www.tglx.de ([62.245.132.106]:47017 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758069AbYIDI1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:27:16 -0400
Date: Thu, 4 Sep 2008 10:27:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andreas Mohr <andi@lisas.de>
cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, shaohua.li@intel.com
Subject: Re: [PATCH] Prevent clockevent event_handler ending up
 handler_noop
In-Reply-To: <20080904081535.GA593@rhlx01.hs-esslingen.de>
Message-ID: <alpine.LFD.1.10.0809041023570.3243@apollo.tec.linutronix.de>
References: <20080903164356.GA31969@rhlx01.hs-esslingen.de> <alpine.LFD.1.10.0809031908270.3243@apollo.tec.linutronix.de> <20080903173627.GA7767@rhlx01.hs-esslingen.de> <alpine.LFD.1.10.0809032058380.3243@apollo.tec.linutronix.de>
 <20080904081535.GA593@rhlx01.hs-esslingen.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008, Andreas Mohr wrote:
> We'll see rather soon, since integration is finished, however I get
> MODPOST symbol link errors for clockevents_register_device() and another
> clockevent function which I forgot.
> Most certainly we should have had an EXPORT_SYMBOL_GPL() for
> these? Or are you going to tell me that modular registration won't work
> at all (yet?) for clock_event_device, as opposed to clocksource?

Should work fine. We just did not have a user yet.
 
> Anything else I need to take into account, other than applying the
> fixup patch in the parent post and exporting these symbols?
> And how to unregister the event device on module unload?

Not implemented :) Shouldnt be that hard, but is it worth the trouble ?
 
> Oh, and another question:
> Since this timer hardware was previously hooked up to an ALSA snd_timer
> (struct snd_timer_hardware), do you think changing this into
> clock_event_device provides almost equivalent service quality?
> snd_timer is used for precise MIDI timestamping (and not much else,
> thus this valuable timer was entirely unused/idle, read: wasted), I think,
> so I wonder what kind of accuracy loss (jitter, additional timer/IRQ load)
> I'd have for MIDI operation if I used this timer for the entire system's
> highres timer wheel. If you believe this is even remotely comparably robust
> as using a snd_timer-only construct, then I'm more than happy to rip out
> snd_timer and _always_ go with clock_event_device instead.

I think it should be pretty robust.

Thanks,

	tglx
