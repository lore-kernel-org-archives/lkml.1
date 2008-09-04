Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbYIDIPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbYIDIPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbYIDIPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:15:38 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:49686 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbYIDIPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:15:36 -0400
Date: Thu, 4 Sep 2008 10:15:35 +0200
From: Andreas Mohr <andi@lisas.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Mohr <andi@lisas.de>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, shaohua.li@intel.com
Subject: Re: [PATCH] Prevent clockevent event_handler ending up handler_noop
Message-ID: <20080904081535.GA593@rhlx01.hs-esslingen.de>
References: <20080903164356.GA31969@rhlx01.hs-esslingen.de> <alpine.LFD.1.10.0809031908270.3243@apollo.tec.linutronix.de> <20080903173627.GA7767@rhlx01.hs-esslingen.de> <alpine.LFD.1.10.0809032058380.3243@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809032058380.3243@apollo.tec.linutronix.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 03, 2008 at 09:01:35PM +0200, Thomas Gleixner wrote:
> When you register something better than PIT, then the PIT is
> disabled completely. No more interrupts from there.

GOOD.

> > Out of interest: how big would you believe the benefit to be?
> > (overall system performance gains and ACPI PM benefits)
> 
> Hard to tell, your milage can vary.

ACPI PM benefits exclusively depend on whether I can make my system go
below 20 wakeups/s at all or not, otherwise there won't be any improvement
of course.

I/O overhead due to PIT ISA access _might_ be a couple % of overall
system performance, but as you say, this is hard to tell, admittedly.

We'll see rather soon, since integration is finished, however I get
MODPOST symbol link errors for clockevents_register_device() and another
clockevent function which I forgot.
Most certainly we should have had an EXPORT_SYMBOL_GPL() for
these? Or are you going to tell me that modular registration won't work
at all (yet?) for clock_event_device, as opposed to clocksource?

Anything else I need to take into account, other than applying the
fixup patch in the parent post and exporting these symbols?
And how to unregister the event device on module unload?

Oh, and another question:
Since this timer hardware was previously hooked up to an ALSA snd_timer
(struct snd_timer_hardware), do you think changing this into
clock_event_device provides almost equivalent service quality?
snd_timer is used for precise MIDI timestamping (and not much else,
thus this valuable timer was entirely unused/idle, read: wasted), I think,
so I wonder what kind of accuracy loss (jitter, additional timer/IRQ load)
I'd have for MIDI operation if I used this timer for the entire system's
highres timer wheel. If you believe this is even remotely comparably robust
as using a snd_timer-only construct, then I'm more than happy to rip out
snd_timer and _always_ go with clock_event_device instead.


Looking forward to getting my box crashed, hard ;)

Thanks!

Andreas
