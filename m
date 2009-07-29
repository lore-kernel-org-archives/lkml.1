Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbZG2VDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbZG2VDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 17:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbZG2VDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 17:03:21 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:38480 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbZG2VDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 17:03:20 -0400
Date: Thu, 30 Jul 2009 06:03:19 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: pHilipp Zabel <philipp.zabel@gmail.com>
Cc: Ian Molton <ian@mnementh.co.uk>, Magnus Damm <magnus.damm@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Subject: Re: MMC: Make the configuration memory resource optional
Message-ID: <20090729210319.GB28753@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	pHilipp Zabel <philipp.zabel@gmail.com>,
	Ian Molton <ian@mnementh.co.uk>,
	Magnus Damm <magnus.damm@gmail.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
	Magnus Damm <damm@opensource.se>
References: <aec7e5c30907281948s2a0dcd0csd3e580251d6c4f5a@mail.gmail.com> <20090729115817.GA12223@rakim.wolfsonmicro.main> <aec7e5c30907290527w39a89895n285e932459e6c953@mail.gmail.com> <20090729124233.GA12802@rakim.wolfsonmicro.main> <aec7e5c30907290551y77edc6d7qb7b3d787215c2b4@mail.gmail.com> <4A704777.70001@mnementh.co.uk> <aec7e5c30907290608i43a80fe1xe4ef0f3847855709@mail.gmail.com> <4A7053E8.8050303@mnementh.co.uk> <20090729201702.GA28202@linux-sh.org> <74d0deb30907291355n39df7db0v1d7afc93917adc14@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74d0deb30907291355n39df7db0v1d7afc93917adc14@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 10:55:31PM +0200, pHilipp Zabel wrote:
> On Wed, Jul 29, 2009 at 10:17 PM, Paul Mundt<lethal@linux-sh.org> wrote:
> > On Wed, Jul 29, 2009 at 02:51:36PM +0100, Ian Molton wrote:
> >> Magnus Damm wrote:
> >> >Note that I don't need clocklib to get the tmio_mmc driver working for
> >> >my platform. It's something _you_ need for the MFD chips. But you seem
> >> >to want me to fix it for you even though I don't have any particular
> >> >need for it.
> >>
> >> Actually, the tmio-mmc driver works perfectly on the MFD chips right
> >> now. These are the chips it was written to handle.
> >>
> > And these patches are fixing up the mmc driver to support the non-MFD
> > case. If you want to fix up the MFD driver to expose a similar interface
> > to the mmc one as what we are doing with the clock framework, that is
> > fine, but is likewise an unrelated change.
> >
> > Lets evaluate the clock options we have today:
> >
> > ? ? ? ?1) clock framework
> > ? ? ? ?2) clkdev
> 
> 2) is nothing more than an implementation detail of 1). How clk_get
> looks up the struct clk internally should not be of any concern to the
> consumer.
> 
For the sake of the driver, sure. On the architecture side it's a bit
more work. It is on my TODO list to add to the SH clock framework, but it
will take some work, and is out of scope for 2.6.32.

> [...]
> > If you can show what is wrong with how the clock framework is being used
> > in the patch that Guennadi posted, we will certainly rework it as
> > necessary. However, I will not at this point be merging clkdev in to my
> > architecture tree, and clocklib I have never supported. These are things
> > that can be done and supported incrementally, but making these
> > prerequisites is simply blocking progress, especially when there is no
> > consensus on the clkdev/clocklib parts.
> 
> Providing the clock consumer ID via platform data is wrong. As I
> understand it, that ID should be either NULL if the clock can be
> determined from the struct device pointer (i.e. if it's the only clock
> provided to that device), or it should be used to distinguish the
> device's clock input pins (in the tmio-mmc case that would be 'hclk'
> or 'clk32' if I remember the datasheet correctly).
> 
If that's the only issue, then yes, no problem. I agree that passing in
the clock string is not something we really want to be doing, so using
the virtualized clock name here sounds fine. We can mangle it on the
platform side until the clkdev implementation is completed, but none of
that matters to the driver at that point.

This should be taken care of in the next iteration of the patch. Thanks
for your comments!
