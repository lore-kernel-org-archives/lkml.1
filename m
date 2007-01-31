Return-Path: <linux-kernel-owner+w=401wt.eu-S933208AbXAaNfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208AbXAaNfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 08:35:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933217AbXAaNfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 08:35:09 -0500
Received: from vms040pub.verizon.net ([206.46.252.40]:11403 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933208AbXAaNfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 08:35:06 -0500
Date: Wed, 31 Jan 2007 08:34:21 -0500
From: David Hollis <dhollis@davehollis.com>
Subject: Re: Free Linux Driver Development!
In-reply-to: <45BFC99A.8040805@garzik.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Trent Waddington <trent.waddington@gmail.com>,
       Dave Airlie <airlied@gmail.com>, Roland Dreier <rdreier@cisco.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Message-id: <1170250461.12914.33.camel@dhollis-lnx.sunera.com>
MIME-version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6)
Content-type: text/plain
Content-transfer-encoding: 7bit
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
	<20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com>
	<45BFA087.6020905@garzik.org> <ada4pq8qjpd.fsf@cisco.com>
	<20070130214759.GA12477@kroah.com> <adar6tcp43r.fsf@cisco.com>
	<21d7e9970701301414s251b584mbee85ecd6909febf@mail.gmail.com>
	<3d57814d0701301424m67d22cdbg7afc0a1dab29c152@mail.gmail.com>
	<45BFC99A.8040805@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-01-30 at 17:41 -0500, Jeff Garzik wrote:
> 
> I think this is a quite fair criticism, and I would love to see
> someone 
> step up and help with this sort of organization.
> 
> For example, I didn't know that XGI graphics specs were available at 
> all, otherwise it might have been something fun to tackle 

Just to pony up my experience in all of this, which I think is probably
quite representative of many other drivers:

A bunch of years ago I picked up a USB Ethernet device at the store
because it seemed really cool and I hoped it worked under Linux.  Turns
out that it didn't.  I had never written a kernel driver before, and
dealing with USB was an alien concept to me.  I searched around and
found that FreeBSD had a driver and I tried to use that in combination
with other USB Ethernet drivers in the kernel as reference to get
something working.  There was a basic spec sheet from the vendor, but a
lot of detail was missing and for someone who was new to spec sheets and
such, it wasn't much of a source.  I wound up coming across a driver
that Tivo had written for the device so I started working to hammer that
into shape to be added to the kernel.  The driver was quite a mess and
had a lot of issues and took a good amount of work, but eventually I was
able to get it to give me basic operation.  As I published updates and
such, I found that there were a lot of folks that were wanting these
devices to work.

I eventually was contacted by the manufacturer to add support to their
newer chips and they even provided some code to make the devices work.
The code was not suitable for inclusion because it was circuitous,
spaghetti, impossible to understand, brute-force style code that just
could not be maintained (which I think is quite common with vendor
drivers, and really makes me shudder when I think of what the code
behind many Windows drivers must look like).  I kept hammering on the
code to get it to be understandable and modular and got it sent
upstream.  For one of the chips, it wound up taking a lot longer than I
had hoped, mainly due to a lack of time on my end and lack of interest
from the community - I wasn't seeing much of a 'Hey, can we get this
chip working?' so it seemed that the devices weren't out there in many
hands.

At this point, the driver supports 19 devices and seems to work quite
well on x86 and x86_64, but big-endian systems seem to show some issues
which are being worked out.  The endian-issues drive me mad since I
don't have access to any big-endian systems and have little experience
with it but I'm determined to get them resolved.  For a vendor, they
likely would care less if it doesn't work on big-endian.  If it works on
Windows, that's all that matters.  

The driver has been upstream for 3+ years or so and is included in all
distros that I'm aware of so for most people, they can go out to
BestBuy, buy the device and plug it into their Linux box and it just
works, and that is what we all want in the end.

Conversely, I've seen many cases of drivers that are developed by the
community, but kept out-of-kernel forever due to various reasons.  Some
of them are due to the code quality and the developers not accepting the
feedback to get the drivers into shape to be 'kernel worthy', sometimes
it seems to be a lack of interest from the developers to merge upstream.
Maybe because they think they would lose control or something?
Sometimes it may just be that they don't realize that they can do that.
Thankfully, these tend to be somewhat fringe devices though all would
benefit at their being upstream to make everyones lives easier.


-- 
David Hollis <dhollis@davehollis.com>

