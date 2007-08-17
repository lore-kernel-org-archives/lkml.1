Return-Path: <linux-kernel-owner+w=401wt.eu-S1760328AbXHQWQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760328AbXHQWQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 18:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbXHQWP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 18:15:58 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:23326 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbXHQWP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 18:15:57 -0400
X-IronPort-AV: i="4.19,277,1183348800"; 
   d="scan'208"; a="48717117:sNHT27631191"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 01/12] Blackfin arch: add peripheral resource allocation support
Date: Fri, 17 Aug 2007 18:15:56 -0400
User-Agent: KMail/1.9.5
Cc: "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       "Bryan Wu" <bryan.wu@analog.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <600D5CB4DFD93545BF61FF01473D11AC0D87BD9F@limkexm2.ad.analog.com> <200708171411.00145.david-b@pacbell.net>
In-Reply-To: <200708171411.00145.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708171815.56323.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 17 Aug 2007 22:15:55.0897 (UTC) FILETIME=[2E823E90:01C7E11C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 17 Aug 2007 17:10, David Brownell pondered:
> On the other hand, maybe you want your "typical" customer to
> be more of a systems integrator than anything else.

We are getting yelled at by our customers (I was on the phone yesterday), 
because the kernel build environment we distribute (the default) was not 
inside Eclipse, and someone couldn't push a button on a GUI rather than 
typing "make".

While Linux and other open source software is free, for some taking advantage 
of its benefits can require a significant investment in time. Linux is 
powerful, rich, and flexible. It is these very characteristics that make 
Linux so appealing that also create a significant level of complexity.

We are seeing more and more "first time buyers" jumping from bare metal - no 
OS, to Linux. For them - the ease of not having to write configuration files 
gives them a warm fuzzy feeling when they boot their board, and it 
just "works".

> > While potentially causing conflicting usage, for someone without
> > detailed hardware knowledge. The platform device board file is a good
> > thing to track conflicting memory or IO space resources as well as
> > IRQs. We also utilize platform device files for exactly these purposes.
> > 
> > The dynamic resource allocation for pinmux and gpio seems to us the
> > best way to handle things. The "resource allocation" mechanism will
> > spill an error and dump in case conflicting usage is detected. It'll
> > also tell you who is causing the conflicting usage.       
> 
> That's your call, of course.  I was pointing out why the "early"
> binding of pin resources is the more usual strategy with Linux.
> A "late" strategy is a bit surprising, and has its own issues.

Agreed - Every implementation has its own issues, but based on what we were 
being asked to do - it was the best way we could accommodate everyone.

> > >That said, how you handle pinmux on Blackfin is your business.
> > >
> > >But you should know that this approach seems idiosyncratic and
> > >more complex than needed:  when pin config is done early and as
> > >part of board setup, drivers don't need to care about it or to
> > >handle any pinmux errors.  And heck, products can sometimes be
> > >shipped with the bootloader having done all pinmux setup, so
> > >Linux won't need to worry about it at all.  That can help ship
> > >multiple board revisions using the same kernel.
> > 
> > This works for fixed function boards.
> 
> That is, for typical products embedding Linux...

We have multiple customers shipping the same bootloader/kernel binary on 
different products, and the only difference is the /etc/rc file - which 
drivers they install, and a few things in userspace.

Could this be smaller - sure - but NAND is cheap (according to them) compared 
to the effort and cost of maintaining and testing multiple kernel versions 
for every product.
 
Could this be faster - sure - but it is done at init - and then never again. 
We have a ~2-3 second boot time - maybe we shave off a few ms - things go 
pretty fast at 600MHz.

-Robin
