Return-Path: <linux-kernel-owner+w=401wt.eu-S1161324AbXBGOLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161324AbXBGOLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 09:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161325AbXBGOLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 09:11:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48107 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161324AbXBGOLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 09:11:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [patch 1/1] PM: Adds remount fs ro at suspend
Date: Wed, 7 Feb 2007 15:10:12 +0100
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Andrew Morton <akpm@linux-foundation.org>, akuster@mvista.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <20070202235132.EDBDF1C448@hermes.mvista.com> <1170848593.9827.24.camel@nigel.suspend2.net> <20070207120500.GF8148@khazad-dum.debian.net>
In-Reply-To: <20070207120500.GF8148@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702071510.13566.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 7 February 2007 13:05, Henrique de Moraes Holschuh wrote:
> On Wed, 07 Feb 2007, Nigel Cunningham wrote:
> > > We don't cope okay with the power going out, at all.  And as an user case, a
> > > need for fsck if you do something that is a reasonable use case (unplugging
> > > devices while suspended) is not okay, either.
> > 
> > Maybe it depends on the filesystem you use. I've used ext3 for 6 or so
> > years of development on Suspend2, and it's never given me a single
> > problem, despite the fact that I've sometimes done the equivalent of
> > pulling the plug without a sync or unmount. I did try XFS at one stage.
> > It's performance was better, but it did give problems. Nevertheless, I'm
> > more than happy to make the above claim about ext3.
> 
> XFS comes to mind, indeed. But as I said, a need for fsck and unclean
> partitions are enough to label it as an "unsuitable" solution.
> 
> > > > Likewise with changes in hardware. Once hotplugging support is mature,
> > > > suspending, switching around hardware and resuming should just result in
> > > > hot[un]plug events.
> > > 
> > > Well, if we add *move* events for when someone unplugs a usb stick in one
> > > port and replugs it in another while the system is in lala-land... maybe :-)
> > > It would be normal to do it, when dealing with docks.
> > 
> > Isn't that part of the point to having those uuid thingys? I hate them
> > at the moment (from the point of view of suspend code), but hopefully
> > they'll end up being nicer to deal with.
> 
> When you have files open for writing (thus neither mount R/O or umount will
> suceed)?   No, you really need kernel support for this, and yes, I imagine
> it is a royal pain to deal with these cases, they clearly belong on the "20%
> of stuff that causes 80% of the work" side :-)

However, there are devices that don't need such handling.  This means there is
a clear distinction between the devices (or filesystems) that are not going to
"move" at run time or when the machine is suspended (think PATA hard disks)
and the devices that can be "moved".

IMO the userland should be able to tell the kernel "this filesystem is movable"
to indicate that it needs special handling during the suspend etc., but none of
the existing filesystems implements something like that AFAICS.

Alternatively, if freeze_bdev() is made available to the userland somehow,
we could be able to handle the "removable filesystems" from the userland too.

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
