Return-Path: <linux-kernel-owner+w=401wt.eu-S1751831AbZICEQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbZICEQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 00:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbZICEQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 00:16:11 -0400
Received: from kroah.org ([198.145.64.141]:34331 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbZICEQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 00:16:10 -0400
Date: Wed, 2 Sep 2009 21:14:30 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Staging tree status for the .32 kernel merge
Message-ID: <20090903041429.GA29875@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here's a summary of the state of the drivers/staging/ tree, basically
what will be coming in the 2.6.32 merge, and what the status of the
different drivers are so far.

First off, drivers/staging/ is NOT a dumping ground for dead code.  If
no one steps up to maintain and work to get the code merged into the
main portion of the kernel, the drivers will be removed.

As proof of that, the EPL (Ethernet Power Link) driver will be removed
in the .32 kernel, as no one is working on it, the upstream developers
never respond to my emails, and no one seems to care about it.

The pata_rdc driver is also going to be removed, as there is a "better"
one being merged through the libata tree for this hardware.

So, taking the drivers in chunks, here's some that have had active
development on for the .32 release:
	- rt* wireless drivers.  Bart has done amazing work merging all
	  of these together into something much better than they
	  originally were.  And even better, they still work!   Great
	  job Bart!

	- rtl* wireless drivers.  Again, Bart has been doing great work
	  here.

	- wlan-ng driver: a bit of work here, but this seems to be
	  dropping off, with the loss of a test platform for the driver.
	  Hopefully someone has a device around and can help out here.

	- comedi drivers had only a bit of work done, lots more is
	  needed here, let's not loose the fact that this is getting
	  closer to a mergable shape.

	- Android drivers have had a bit of work done, but upstream
	  seems to not care at all about what is going on here, as they
	  are working to forward port their code to the 2.6.29! kernel.
	  {sigh}.  If this keeps up, the drivers will be dropped in the
	  2.6.32 kernel release.
	  Note, Pavel has been adding some of the Dream hardware
	  drivers, which are separate from the core Android drivers.  I
	  have no objection to those, but they should work to get merged
	  to their "correct" places in the tree in another release or
	  so.

	- w35und driver.  It's slowly being worked on.

	- echo driver.  This one is now in good enough shape to merge
	  into the main kernel tree.  I'll send out review patches soon
	  for this.

	- eth131x driver. Alan Cox is working on fixing up the issues in
	  this driver.  Hopefully it will get into mergable shape soon.

New drivers that will show up in the .32 kernel release:
	- vt66* wireless drivers.  These VIA drivers are being actively
	  worked on to get into a much better shape.  Nice job.

	- new rt3090, and rtl8192e wireless drivers have been added and
	  worked on cleaning up issues involved in them.

	- Microsoft Hyper-V drivers.  Over 200 patches make up the
	  massive cleanup effort needed to just get this code into a
	  semi-sane kernel coding style (someone owes me a bit bottle of
	  rum for that work!)  Unfortunately the Microsoft developers
	  seem to have disappeared, and no one is answering my emails.
	  If they do not show back up to claim this driver soon, it will
	  be removed in the 2.6.33 release.  So sad...

	- quatech_usb2 driver.  I don't know if it quite works, but
	  someone is developing it, so I'm not complaining :)

	- VME bus drivers.  Yeah!  They are progressing nicely.

	- SEP and RAR drivers.  Alan Cox has been working on cleaning
	  these up a lot.

	- IIO (Industrial I/O), these are new drivers that are being
	  actively worked on.

	- pohmelfs and dst.  It seems that DST is dead, so I think I
	  will remove it in .33.  pohmelfs is under active development
	  outside of the tree, and hopefully patches start moving in
	  here to help out with keeping it up to date.

	- cowloop.  Yes, another COW driver!  :)  Seriously, this does
	  things that DM can't do, so it might be useful.  The upstream
	  developer is interested in getting this merged properly, and
	  is working on cleaning it up.

Drivers not being actively worked on:
	- otus.  This is sitting here until a "real" wireless driver
	  will be merged through the wireless tree.  Hopefully that
	  happens soon.

	- agnx wireless driver.  No one seems to care about it.  If no
	  one steps up soon, it will be removed in .33.

	- altpciechdma.  Upstream developers seem to have disappeared.
	  Again, if no one steps up, it will be removed in .33

	- asus_oled.  This only needs minor cleanups to get merged
	  properly into the main tree.  If someone wants an easy
	  project, this would be it.

	- at76_usb wireless driver.  Again, no one working on it, it
	  will be dropped in .33.

	- b3dfg.  I really do not think anyone cares about this.  again,
	  will be dropped if this is true in .33.

	- cpc-usb.  After the initial flurry of development, everyone
	  seems to have run away.  Was it the fact that I hadn't
	  showered in a few days?  Again, will be removed if no one
	  comes back.  And I am wearing deodorant now...

	- frontier.  A nice driver, again, should not be hard to get
	  merged into the main tree, if someone wants an easy project...

	- go7007.  Ugh.  Unless someone steps up now to take this over,
	  it's going to be removed in .33.  There is no hardware made
	  with this anymore, and no specs around that I know of, and the
	  code isn't the nicest in the world.

	- heci.  A wonderful example of a company throwing code over the
	  wall, watching it get rejected, and then running away as fast
	  as possible, all the while yelling over their shoulder, "it's
	  required on all new systems, you will love it!"  We don't, it
	  sucks, either fix it up, or I am removing it.

	- line6.  Another nice driver that should be simple to get
	  merged.  Please, if you are looking for something to do, this
	  is it.

	- me4000 and meilhaus.  They work on the same hardware, and they
	  duplicate the existing COMEDI drivers.  Someone thinks that
	  custom userspace interfaces are fun and required.  Turns out
	  that being special and unique is not what to do here, use the
	  COMEDI drivers instead.  These will be removed.  Heck, I'll go
	  remove them for .32, there is no reason these should still be
	  around, except to watch the RT guys squirm as they try to
	  figure out the byzantine locking and build logic here (which
	  certainly does count for something, cheap entertainment is
	  always good.)

	- mimio.  Another driver that should be simple to get merged.
	  Someone just step up to do this please, there are users of
	  this hardware out there.

	- p9auth.  While it seemed like a good idea, I don't think that
	  anyone actually uses this.  It will be removed in .33 unless
	  someone comes forward.

	- panel.  Another one that should be simple to merge.  Anyone?

	- phison.  What?  I thought I asked for this to be merged a
	  while ago, sorry about that, no reason it should still be in
	  staging anymore, it's just so small it slipped through the
	  cracks...

	- poch.  A long-suffering company is enduring the slowest
	  developers in the world here.  Hopefully the code will be
	  replaced with a UIO driver, but testing the userspace side
	  seems to be difficult and slow.  I have to give Redrapids
	  major credit for being patient here, they are being amazing.

	- rspiusb.  A weird, very expensive camera, from a company that
	  does not want to release the specs, and wants custom userspace
	  interfaces.  The code hasn't built since the 2.6.20 days.
	  I'll go delete it now from .32, it doesn't deserve to live as
	  no one cares about it, least of all, the original authors of
	  the code :(

	- slicoss and sxg.  These are being developed by a consulting
	  company for the main producer of the chips.  Yet they seem to
	  have disappeared half-way through the job.  Odd.  Hopefully
	  they come back soon.

	- stlc45xx.  Another wireless driver that no one seems to care
	  about.  So sad.  I guess no one will miss it when it goes away
	  in .33.

	- udlfb.  Video over USB, it doesn't get anymore whacked than
	  that.  This is still being developed but the developer doesn't
	  like to do incremental updates for some odd reason.  Hopefully
	  he pops up again with an update.  But for now, it is quite
	  workable for a number of developers.

	- usbip.  USB over IP.  I guess if you ran video over IP to your
	  USB device, that would be more whacked than just video over
	  USB.  This did get one big update during the .32 development
	  cycle, hopefully the developer can come back again when they
	  get some free time to continue working on it.  Rumor has it
	  that some major distros are starting to rely on this code, so
	  it would be nice to get their help to get it working better...

That should cover all of the 600+ patches in the staging tree for the
.32 kernel merge, and the existing drivers/staging/ tree.  If I missed
anything, please let me know.

Any questions?

thanks for making it this far,

greg k-h
