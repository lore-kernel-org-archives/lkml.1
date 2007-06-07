Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbXFGOpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbXFGOpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 10:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756555AbXFGOpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 10:45:33 -0400
Received: from waste.org ([66.93.16.53]:43562 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756393AbXFGOpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 10:45:32 -0400
Date: Thu, 7 Jun 2007 09:45:08 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bzolnier@gmail.com, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 3/6] lguest suppress IDE probing
Message-ID: <20070607144508.GV11115@waste.org>
References: <1181055308.14054.36.camel@localhost.localdomain> <1181055396.14054.38.camel@localhost.localdomain> <1181055483.14054.40.camel@localhost.localdomain> <20070605170747.256f6631@the-village.bc.nu> <1181092258.14054.87.camel@localhost.localdomain> <20070606112308.49a652f6@the-village.bc.nu> <1181182387.14054.157.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181182387.14054.157.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 12:13:07PM +1000, Rusty Russell wrote:
> On Wed, 2007-06-06 at 11:23 +0100, Alan Cox wrote:
> > > > Better yet just don't compile in the old IDE stuff, lguest doesn't have a
> > > > PCI or ISA bus anyway.
> > > 
> > > Sure, but the "run the same kernel as guest and host" is a really nice
> > > feature.
> > 
> > Modules dear boy, modules ;)
> 
> For some reason, pulling half the kernel's brains out into a separately
> maintained userspace seems to make things less reliable.  I always build
> in everything I need to boot.
> 
> Perhaps this makes me an old-timer.
> 
> > > > Alternatively make the IDE I/O space return 0xFF and it'll skip them
> > > > anyway.
> > > 
> > > Hmm, every "in" should be returning 0xFFs, but I still get the delay and
> > > the probing.  Xen domU gets it too.
> > 
> > Can you see in a debugger where it is spending the time. 0xFF should be
> > taken as "no port, move on nothing to see"
> 
> Well, the code is a little opaque to me, but do_probe() calls msleep(50)
> three times.  According to gdb this gets called 27 times -> 4.05
> seconds.

Yep. libata somehow manages to avoid most of these, it'd be
interesting to work out why.

-- 
Mathematics is the supreme nostalgia of our time.
