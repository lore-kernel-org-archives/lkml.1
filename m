Return-Path: <linux-kernel-owner+w=401wt.eu-S936211AbXFGCNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936211AbXFGCNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 22:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935495AbXFGCN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 22:13:27 -0400
Received: from ozlabs.org ([203.10.76.45]:47261 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759462AbXFGCN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 22:13:26 -0400
Subject: Re: [PATCH 3/6] lguest suppress IDE probing
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bzolnier@gmail.com, Matt Mackall <mpm@selenic.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <20070606112308.49a652f6@the-village.bc.nu>
References: <1181055308.14054.36.camel@localhost.localdomain>
	 <1181055396.14054.38.camel@localhost.localdomain>
	 <1181055483.14054.40.camel@localhost.localdomain>
	 <20070605170747.256f6631@the-village.bc.nu>
	 <1181092258.14054.87.camel@localhost.localdomain>
	 <20070606112308.49a652f6@the-village.bc.nu>
Content-Type: text/plain
Date: Thu, 07 Jun 2007 12:13:07 +1000
Message-Id: <1181182387.14054.157.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 11:23 +0100, Alan Cox wrote:
> > > Better yet just don't compile in the old IDE stuff, lguest doesn't have a
> > > PCI or ISA bus anyway.
> > 
> > Sure, but the "run the same kernel as guest and host" is a really nice
> > feature.
> 
> Modules dear boy, modules ;)

For some reason, pulling half the kernel's brains out into a separately
maintained userspace seems to make things less reliable.  I always build
in everything I need to boot.

Perhaps this makes me an old-timer.

> > > Alternatively make the IDE I/O space return 0xFF and it'll skip them
> > > anyway.
> > 
> > Hmm, every "in" should be returning 0xFFs, but I still get the delay and
> > the probing.  Xen domU gets it too.
> 
> Can you see in a debugger where it is spending the time. 0xFF should be
> taken as "no port, move on nothing to see"

Well, the code is a little opaque to me, but do_probe() calls msleep(50)
three times.  According to gdb this gets called 27 times -> 4.05
seconds.

Cheers,
Rusty.


