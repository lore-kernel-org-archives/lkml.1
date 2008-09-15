Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbYIOQeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbYIOQeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 12:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbYIOQed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 12:34:33 -0400
Received: from mail2.shareable.org ([80.68.89.115]:45142 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbYIOQec (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 12:34:32 -0400
Date: Mon, 15 Sep 2008 17:34:21 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Jared Hulbert <jaredeh@gmail.com>
Cc: Greg Ungerer <gerg@snapgear.com>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Message-ID: <20080915163421.GA13631@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6934efce0809121452kd20deb6m268715f6ed83a71e@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jared Hulbert wrote:
> >> > What kind of NOR you using?  That is not what I measure with fast
> >> > synchronous burst NOR's.
> >>
> >> I think the "fast" in "fast synchronous" gives it away :-)
> >>
> >> I'm using Spansion MirrorBit S29GL128N, which reads at about 0.6 MByte/s.
> >
> > By the way, what speeds do you get on fast synchronous burst NORs - and
> > which chips are those?
> 
> I am only familiar with the Numonyx product line up.
> 
> If you are using a GL, you'll probably find our P33 a good fit and at
> competitive prices to GL as I understand it.  That's I think 50Mhz.

What's a GL?  Never heard of it - all I can think of is OpenGL :-)

I'm using a Sigma Designs 862x media processor.  It clocks at 166MHz
to main RAM, has an ARM internally to run Linux, and the intensive
work happens in coprocessors.  The NOR is not on the RAM bus, it's on
a "peripheral bus".  About the only thing I know about the bus is it's
16 bits wide - I have the schematic, but only the board supplier has
access to Sigma chip documentation.

> A rule of thumb is to say that copying to RAM will reduce this value
> less than 50% because RAM should be at least a little faster than NOR.

In our case, RAM is at least 100x faster :-)

> Nevertheless, If you can't use a simple calculation like this to
> explain the numbers then you have a poorly configured bus timings or
> have your cache off.

I'm not sure if cache is an option with this device - but would it
make a difference anyway?  Launching executables like Busybox - those
are much larger than the cache anyway, so launch time is dominated by
bulk streaming copy speed.  Thanks for the idea, I'll look into
whether it's possible to access this 'peripheral bus' through the
ARM's cache and see if that speeds up streaming read time.

> So, If you are only getting 0.6MB/s out of your NOR..... You're
> using it wrong.

Interesting, thanks.  I'm not sure it's possible to change the way NOR
is being used with this chip, and it'll be a while before it's
economical to replace the board with a new design.

This is all very interesting - I had no prior experience with NOR, so
didn't know that 0.6MB/s was slow.  It's fast compared with older
EEPROMs after all, and had imagined that people wanting fast flash
would use NAND.

On looking at the datasheet, I see it's quite a lot faster.  I'm
suspecting the Sigma Designs perpheral bus and the way it's wired up
not doing it any favours.  We already have the weirdness that we have
to patch the Linux CFI-0002 MTD code: the CPU locks up when polling
the erase status byte, until erase is finished.  Unfortunately this is
difficult to change now - I'm programming hardware which is already
out in the field and cannot be redesigned.

Thanks for your thoughts.

-- Jamie
