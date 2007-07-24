Return-Path: <linux-kernel-owner+w=401wt.eu-S1761874AbXGXGqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761874AbXGXGqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 02:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbXGXGp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 02:45:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38958 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbXGXGp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 02:45:56 -0400
Date: Mon, 23 Jul 2007 23:38:18 -0700
From: Greg KH <greg@kroah.com>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Rob Landley <rob@landley.net>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel@vger.kernel.org, Michael-Luke Jones <mlj28@cam.ac.uk>,
       Krzysztof Halasa <khc@pm.waw.pl>, Rod Whitby <rod@whitby.id.au>,
       Russell King <rmk@arm.linux.org.uk>, david@lang.hm
Subject: Re: Documentation for sysfs, hotplug, and firmware loading.
Message-ID: <20070724063818.GB31806@kroah.com>
References: <8I2t1-7jt-5@gated-at.bofh.it> <8IlPa-3Gl-61@gated-at.bofh.it> <8IzyM-86P-47@gated-at.bofh.it> <8Jb1c-7vL-3@gated-at.bofh.it> <8Jbuh-84N-3@gated-at.bofh.it> <E1ICDr7-0000e9-P4@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ICDr7-0000e9-P4@be1.lrz>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 02:14:41PM +0200, Bodo Eggert wrote:
> Greg KH <greg@kroah.com> wrote:
> > On Fri, Jul 20, 2007 at 08:21:39PM -0400, Rob Landley wrote:
> 
> >> I'm not trying to document /sys/devices.  I'm trying to document hotplug,
> >> populating /dev, and things like firmware loading that fall out of that.
> >> This requires use of sysfs, and I'm only trying to document as much of sysfs
> >> as you need to do that.
> > 
> > Like I stated before, you do not need to even have sysfs mounted to have
> > a dynamic /dev.
> > 
> > And why do you need to document populating /dev dynamically?  udev
> > already solves this problem for you, it's not like people are going off
> > and reinventing udev for their own enjoyment would not at least look at
> > how it solves this problem first.
> 
> Turning your words around, you get: "Whatever one of these programs does
> documents how dynamic devices should be handled." If this is true, any
> change that makes one of these programs break is a kernel bug.

Not at all.  The kernel changed things numerous times that showed up as
bugs in udev, and I fully admit that (and have in the past, numerous
times.)

> Besides that: How am I supposed to be able to correctly change udev if
> there is no document telling me what would work and what happens to
> work by accident?

Um, the same way you change any codebase?  :)

> > To do otherwise would be foolish :)
> 
> Some people like to fool around and create even smaller wheels.
> E.g. I'm changing the ACPI button driver to just call Ctrl_alt_del
> in order not to have an extra process running and free 0.2 % of my RAM.

That's great, and I have nothing against that, and encourage you to do
so.

But I don't suppose you are trying to complain to the ACPI developers
about this whole thing now are you?  Are you hasseling them and
demanding that they fully document their interfaces that you need to use
so that you can hook into their code differently than they wish you to
do so?

> > Firmware loading is fine to document if you wish to do so.  But again,
> > why?  We already have multiple userspace programs that provide this
> > feature for them.  Perhaps you want to document how to add firmware to a
> > system in order for these different programs to pick them up?
> 
> I once tried to install a firmware for hotplug. Even finding the place whre
> I'm supposed to put it was harder than rewriting that *beep* from start,
> but I could not rewrite it because I didn't have any documentation.

The firmware layer has never been fully documented, and the maintainer
of the code died a few years ago.  It has been well known that this is
one area of the kernel that needs a lot of attention and help.  Please
feel free to chip in if you can do so.

> Even digging in that pile of wrapper scrips in order to debug that thing
> was a nightmare. (Having a number of places where the firmware will be
> expected in one of many versions and formats stored using one of many
> filenames can drive you nuts.)

I fully agree.

> > Or perhaps you want to document how to add this kind of functionality to
> > your kernel driver so that it can handle firmware loading by using the
> > firmware interface that the kernel provides?
> 
> I suppose that's missing, too. Or scattered in a number of contradicting
> and mostly outdated howtos across the internet.

Ir proably is, hence my suggestion on something that would be very
valuable to have documented.

> > If you just want to document the hotplug/uevent api, then do just that.
> > However I think you are overreaching with your scope here and getting
> > mighty confused in the process.
> 
> In other words: Grasping sysfs is not a feasible task? If this is true,
> how can anybody reliably use sysfs?

Huh, I never stated that at all.  If you wish to fully document sysfs
and how it works, then great, do that.  But that was not the stated
intent of this document, and is why I think the author got confused as
he was attempting to put a narrow portion of how sysfs works as a
reflection on how the whole of the body works.

thanks,

greg k-h
