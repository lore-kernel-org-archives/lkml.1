Return-Path: <linux-kernel-owner+w=401wt.eu-S1762610AbXKMXrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762610AbXKMXrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 18:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759409AbXKMXrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 18:47:13 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49474 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762095AbXKMXrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 18:47:11 -0500
Date: Tue, 13 Nov 2007 23:40:33 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Mark Lord <liml@rtr.ca>
Cc: Ingo Molnar <mingo@elte.hu>, alsa-devel@alsa-project.org,
       netdev@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org, protasnb@gmail.com,
       linux-ide@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071113234033.GL1356@flint.arm.linux.org.uk>
Mail-Followup-To: Mark Lord <liml@rtr.ca>, Ingo Molnar <mingo@elte.hu>,
	alsa-devel@alsa-project.org, netdev@vger.kernel.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	protasnb@gmail.com, linux-ide@vger.kernel.org,
	bugme-daemon@bugzilla.kernel.org,
	linux-input@atrey.karlin.mff.cuni.cz,
	Andrew Morton <akpm@linux-foundation.org>,
	David Miller <davem@davemloft.net>
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org> <20071113.033946.114918709.davem@davemloft.net> <20071113034916.2556edd7.akpm@linux-foundation.org> <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca> <20071113193750.GD1356@flint.arm.linux.org.uk> <473A067F.3090007@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473A067F.3090007@rtr.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 03:18:07PM -0500, Mark Lord wrote:
> Russell King wrote:
> > On Tue, Nov 13, 2007 at 09:08:32AM -0500, Mark Lord wrote:
> >> Ingo Molnar wrote:
> >> ..
> >>> This is all QA-101 that _cannot be argued against on a rational basis_, 
> >>> it's just that these sorts of things have been largely ignored for 
> >>> years, in favor of the all-too-easy "open source means many eyeballs and 
> >>> that is our QA" answer, which is a _good_ answer but by far not the most 
> >>> intelligent answer! Today "many eyeballs" is simply not good enough and 
> >>> nature (and other OS projects) will route us around if we dont change.
> >> ..
> >>
> >> QA-101 and "many eyeballs" are not at all in opposition.
> >> The latter is how we find out about bugs on uncommon hardware,
> >> and the former is what we need to track them and overall quality.
> >>
> >> A HUGE problem I have with current "efforts", is that once someone
> >> reports a bug, the onus seems to be 99% on the *reporter* to find
> >> the exact line of code or commit.  Ghad what a repressive method.
> > 
> > 99% on the reporter?  Is that why I always try to understand the
> > reporters problem (*provided* it's in an area I know about) and come
> > up with a patch to test a theory or fix the issue?
> ..
> 
> Same here.
> 
> I just find it weird that something can be known broken for several -rc*
> kernels before I happen to install it, discover it's broken on my own machine,
> and then I track it down, fix it, and submit the patch, generally all within a
> couple of hours.  Where the heck was the dude(ess) that broke it ??  AWOL.

Same thing can be said for compile breakages as well.  Looking at the
latest kautobuild output:

ARM ep93xx defconfig has been broken since 2.6.23-git1 due to:

drivers/net/arm/ep93xx_eth.c:420: error: implicit declaration of function '__netif_rx_schedule_prep'

caused by: [NET]: Make NAPI polling independent of struct net_device objects.

ARM netx defconfig has been broken since 2.6.23-git1 due to:

drivers/net/netx-eth.c: In function 'netx_eth_hard_start_xmit':
drivers/net/netx-eth.c:131: error: 'dev' undeclared (first use in this function)
drivers/net/netx-eth.c:131: error: (Each undeclared identifier is reported only once
drivers/net/netx-eth.c:131: error: for each function it appears in.)
drivers/net/netx-eth.c: In function 'netx_eth_receive':
drivers/net/netx-eth.c:158: error: 'dev' undeclared (first use in this function)

caused by: [NET] drivers/net: statistics cleanup #1 -- save memory and shrink code

Haven't got a report for either of those, but Kautobuild lets people
know if folk can be bothered to subscribe to its mailing list and/or
look at the site occasionally.

I suspect the maintainers of the above drivers aren't aware that their
drivers are broken.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
