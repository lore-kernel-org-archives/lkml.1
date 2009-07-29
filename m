Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbZG2Mmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbZG2Mmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZG2Mmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:42:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56211 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754624AbZG2Mme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:42:34 -0400
Date: Wed, 29 Jul 2009 13:42:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Ian Molton <ian@mnementh.co.uk>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Subject: Re: MMC: Make the configuration memory resource optional
Message-ID: <20090729124233.GA12802@rakim.wolfsonmicro.main>
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>
 <4A6F033B.7030302@mnementh.co.uk>
 <aec7e5c30907281948s2a0dcd0csd3e580251d6c4f5a@mail.gmail.com>
 <20090729115817.GA12223@rakim.wolfsonmicro.main>
 <aec7e5c30907290527w39a89895n285e932459e6c953@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aec7e5c30907290527w39a89895n285e932459e6c953@mail.gmail.com>
X-Cookie: Keep away from edge.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 09:27:54PM +0900, Magnus Damm wrote:
> On Wed, Jul 29, 2009 at 8:58 PM, Mark
> Brown<broonie@opensource.wolfsonmicro.com> wrote:

> > While it's true that this doesn't bother SoCs the fact that most clock
> > API implementations don't allow any off-chip drivers to register clocks
> > renders the clock API essentially unusable for fairly large parts of the

> Yeah, clocks outside the SoC are not well supported today. From what
> I've seen, most embedded boards come with external chips for cameras,
> audio codecs and/or phy devices. These devices often get their clocks
> from the main SoC. Allowing the drivers for such chips to use the
> clock framework to register clocks for internal divisors would allow
> driver writers to write better code which in turn would make life
> easier for most people hacking on embedded kernels.

That's not actually abundantly clear for the audio stuff, or rather the
audio stuff would like additional features like constraint based
configuration.

> The problem with the clock framework API is that the data structures
> varies depending on implementation. So the ops callback structure on
> SuperH is different compared to ARM. I suspect that adding generic
> clocklib support across the architectures will take quite a bit of
> time to implement propely.

Indeed.  It's actually much worse than you say, each individual ARM
architecture has its own clock API implementation of varying quality and
of course there are architectures that don't do the clock API at all.
