Return-Path: <linux-kernel-owner+w=401wt.eu-S934215AbYBTUcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215AbYBTUcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934018AbYBTUbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:31:20 -0500
Received: from smtp2.wanadoo.co.uk ([193.252.22.157]:22202 "EHLO
	smtp2.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933971AbYBTUbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:31:18 -0500
X-ME-UUID: 20080220203112618.970B2700008C@mwinf3104.me.freeserve.com
Subject: Re: [Rt2400-devel] 2.6.25-rc2 regression in rt61pci wireless driver
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: Dan Williams <dcbw@redhat.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, chris2553@googlemail.com,
       rt2400-devel@lists.sourceforge.net
In-Reply-To: <1203523555.693.2.camel@localhost.localdomain>
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com>
	 <200802191026.57640.IvDoorn@gmail.com>
	 <200802191900.09543.chris2553@googlemail.com>
	 <200802192046.14184.IvDoorn@gmail.com>
	 <1203462247.6397.15.camel@boulder.homenet>
	 <1203523555.693.2.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 20:27:15 +0000
Message-Id: <1203539235.3189.4.camel@boulder.homenet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-20 at 11:05 -0500, Dan Williams wrote: 
> On Tue, 2008-02-19 at 23:04 +0000, Chris Vine wrote:
> > On Tue, 2008-02-19 at 20:46 +0100, Ivo van Doorn wrote:
> > > Hi,
> > > 
> > > [added rt2400-devel (rt2x00 development mailinglist) to the CC list.]
> > > 
> > > > > > > I have a series of tests I would like to request from you,
> > > > > > > you mentioned you already enabled debugfs, and that is just what we need. ;)
> > > > > > > Please use attached script to create dumps of the hardware register contents.
> > > > > > > 
> > > > > > > There are specific moments that should be dumped:
> > > > > > > - kernel 2.6.24 (last known working version for you).
> > > > > > > - kernel 2.6.25-rc2 (after ifup, before TX dies)
> > > > > > > - kernel 2.6.25-rc2 (after ifup, after TX dies)
> > > > > > >  
> > > > > > 
> > > > > > These diagnostics are attached, with obvious filenames.
> > > > > 
> > > > > Thanks. I think I found something, please test below patch:
> > > > > 
> > > > 
> > > > I've tried the patch but, unfortunately, my wireless LAN still dies after a few pings.
> > 
> > rt2x00 2.0.14 is broken with my rt73 stick in the vanilla 2.6.25-rc2
> > kernel (not wireless-2.6/rt2x00 git).  The modules load when I plug the
> > stick in but I then get a complete kernel lock up with two flashing
> > leds.  Nothing is recorded to system logs.  The last logged messages are
> > that usbcore has registered new interface driver rt73usb, and that the
> > rate control algorithm has been selected on phy0.  This happens whether
> > the simple or pid mac80211 rate control algorithms have been chosen.
> > 
> > This is a shame because 2.0.14 was working really well for me until the
> > mac80211 changes 2 or 3 weeks ago broke it.  (Shortly followed by the
> > release of 2.1.*).
> 
> Switch to a VT with Ctl+Alt+1, then plug the stick in, and take a
> picture of the panic if one shows up.  _Something_ should show up on the
> VT.

I did that yesterday and it just reported a kernel panic on the terminal
with the message:

  Kernel panic - not syncing: Aiee, killing interrupt handler!

There is a complete lock up.  Even the two leds don't send a dump in
morse code (if that is still a feature of the 2.6 kernels).  They just
flash together at 1 second intervals.

However, I do not have debugging enabled on 2.6.25-rc2 (I was just
interested to see how it worked).  If it is thought to be useful I can
recompile the kernel with debugging enabled, but this should be
reproducible by anyone with a rt73 stick.

By way of a further data point, I can scan OK using 2.6.25-rc2 and it
will report all the available access points in my area.  But as soon as
association is attempted, it blows up.

Chris


