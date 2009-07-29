Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbZG2URJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbZG2URJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 16:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbZG2URI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 16:17:08 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:49800 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624AbZG2URH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 16:17:07 -0400
Date: Thu, 30 Jul 2009 05:17:05 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ian Molton <ian@mnementh.co.uk>
Cc: Magnus Damm <magnus.damm@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
       Magnus Damm <damm@opensource.se>
Subject: Re: MMC: Make the configuration memory resource optional
Message-ID: <20090729201702.GA28202@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ian Molton <ian@mnementh.co.uk>,
	Magnus Damm <magnus.damm@gmail.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>,
	Magnus Damm <damm@opensource.se>
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange> <4A6F033B.7030302@mnementh.co.uk> <aec7e5c30907281948s2a0dcd0csd3e580251d6c4f5a@mail.gmail.com> <20090729115817.GA12223@rakim.wolfsonmicro.main> <aec7e5c30907290527w39a89895n285e932459e6c953@mail.gmail.com> <20090729124233.GA12802@rakim.wolfsonmicro.main> <aec7e5c30907290551y77edc6d7qb7b3d787215c2b4@mail.gmail.com> <4A704777.70001@mnementh.co.uk> <aec7e5c30907290608i43a80fe1xe4ef0f3847855709@mail.gmail.com> <4A7053E8.8050303@mnementh.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7053E8.8050303@mnementh.co.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 02:51:36PM +0100, Ian Molton wrote:
> Magnus Damm wrote:
> >Note that I don't need clocklib to get the tmio_mmc driver working for
> >my platform. It's something _you_ need for the MFD chips. But you seem
> >to want me to fix it for you even though I don't have any particular
> >need for it.
> 
> Actually, the tmio-mmc driver works perfectly on the MFD chips right 
> now. These are the chips it was written to handle.
> 
And these patches are fixing up the mmc driver to support the non-MFD
case. If you want to fix up the MFD driver to expose a similar interface
to the mmc one as what we are doing with the clock framework, that is
fine, but is likewise an unrelated change.

Lets evaluate the clock options we have today:

	1) clock framework
	2) clkdev
	3) clocklib

#1 is what these patches are written for, and the only standard in-tree
interface that we have cross platform today. #2 could be generalized, but
that needs discussion by itself, as it was never proposed as a standard
interface and never submitted to l-k for review. #3 is not in the kernel
today and it's not clear that it ever will be.

> YOU want to change it, not me. Don't try to turn the argument around.
> 
We wish to make constructive changes to the MMC driver to accomodate
devices you hadn't considered. It is not an MFD in our case, we have no
ability to test the MFD code, and we will not be making any changes to
the MFD code. You are the one with the MFD, you get to handle it. While
we will work with you to make sure nothing on the MFD side breaks,
holding the MMC driver hostage until MFD is reworked or some random bits
of unrelated infrastructure are merged is not constructive.

If you can show what is wrong with how the clock framework is being used
in the patch that Guennadi posted, we will certainly rework it as
necessary. However, I will not at this point be merging clkdev in to my
architecture tree, and clocklib I have never supported. These are things
that can be done and supported incrementally, but making these
prerequisites is simply blocking progress, especially when there is no
consensus on the clkdev/clocklib parts.

> Can we keep it technical now, please?
> 
So far you have not produced a technical rebuttal to any of the patches.

You object to #1 because you think it confuses things, despite the fact
that in our case this cnf window just doesn't exist at all, and there are
plenty of existing cases in the kernel today where variable number of
resources are handled for fairly similar situations. We have no intention
of pretending the resource exists when it does not. However you want to
rework the MFD driver to support clocks and power control is entirely up
to you, but none of that has any real bearing on the MMC driver.

Your objections to #2 are non-obvious, since you haven't stated any other
than the fact you would like to see it solved using APIs that do not
exist in the kernel. Perhaps in the long term we can move towards clkdev
or clocklib if they are proposed as generic interfaces and merged in to
the kernel at some point in the future, but today the clock framework is
what we have to work with, and that is what we will be working with.

If you don't want to expand on either one of those points, then I can
just include your NAKed-by in the commit logs and we can take it from
there. You can always maintain a local patchset that drops support for
non-MFD chips.
