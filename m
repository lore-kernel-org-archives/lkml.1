Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbYBFN5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbYBFN5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 08:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbYBFN5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 08:57:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47597 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752140AbYBFN5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 08:57:32 -0500
Date: Wed, 6 Feb 2008 13:57:30 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux01@architechnical.net
Cc: linux-kernel@vger.kernel.org, liam.girdwood@wolfsonmicro.com
Subject: Re: [UPDATED v4] WM97xx touchscreen drivers
Message-ID: <20080206135730.GA11117@rakim.wolfsonmicro.main>
Mail-Followup-To: linux01@architechnical.net, linux-kernel@vger.kernel.org,
	liam.girdwood@wolfsonmicro.com
References: <3713.69.30.58.166.1202151624.squirrel@architechnical.net> <20080204213100.GA30382@sirena.org.uk> <54602.69.30.123.189.1202253615.squirrel@architechnical.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54602.69.30.123.189.1202253615.squirrel@architechnical.net>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 06:20:15PM -0500, linux01@architechnical.net wrote:

> > The expectation of this driver is that the battery monitor driver will
> > register as the "wm97xx-battery" device and use the wm97xx_read_aux_adc()
> > function exported by the wm97xx-core driver to access the ADC.  Is your
> > driver using this interface?

> Yes, but this makes the wm97xx-battery device depend on configuring in the
> touchscreen.

Indeed.  Could you expand on why this is a problem?

> The problem we're having is that when we updated wm97xx-core.c from
> version 0.62 to 0.65 the ADC values returned by wm97xx_read_aux_adc() to
> the battery driver changed.  We did modify both versions to make the

Version 0.62 predates our git history so I don't have the old version to
hand.  I can't spot anything obvious in the information I do have except
perhaps something introduced when the drivers were split to start
pulling out the codec parts.

> struct wm97xx * global so the battery monitor could pass it to
> wm97xx_read_aux_adc() (is there a better way?).

Well, other than using wm97xx-battery to find it not really.  To be
honest I don't really see what this buys you over using the battery
device since what you suggest means you need to wait until it is
registered anyway.

> > The intention is that these drivers should be able to coexist with the
> > existing ASoC drivers as-is.  We do have existing users doing this - the

> They don't just coexist with soc, they depend on it.  If you configure out
> the AC97 driver under soc the touchscreen and battery drivers won't work
> (but they'll build).

What sorts of problems are you seeing?  I've done a very large
proportion of my touchscreen work with ASoC completely disabled and
haven't noticed any issues.  In this case I was using the non-ASoC
PXA AC97 driver (CONFIG_SND_AC97_CODEC, sound/arm/pxa2xx-ac97.c).
Within ASoC it should be possible to use the generic AC97 codec driver
but I can't say I've ever tested that.

>                       We used the same architecture as tosa and retained
> the OH guys for the app framework (and platform assistance - thanks RP :).

OK, that's good - sounds like you're doing something fairly standard.

> The first release is publicly available; the release I'm working on was
> aimed for the 2.6.24 merge window but some key stuff (ARM clock/power
> management, USB gadget) changed causing me to re-engineer.  I'm still
> troubleshooting some 2.6.18-->24 port issues here (pxa27x_ac97 errors on
> resume - we use deep sleep, not sleep on the pxa270), but can publicize a
> source tarball and send you the link.

Yes, that'd be really helpful.  I don't have the hardware so any non
working stuff isn't going to affect me too much :) .
