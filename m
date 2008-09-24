Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbYIXKW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbYIXKW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 06:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbYIXKWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 06:22:49 -0400
Received: from www.tglx.de ([62.245.132.106]:57177 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbYIXKWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 06:22:48 -0400
Date: Wed, 24 Sep 2008 12:22:31 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: Paul Mundt <lethal@linux-sh.org>, hjk@linutronix.de, gregkh@suse.de,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: UIO device name
Message-ID: <20080924102230.GB2973@local>
References: <1222248093.12624.188.camel@gentoo-jocke.transmode.se> <20080924093551.GB7591@linux-sh.org> <1222250279.12624.195.camel@gentoo-jocke.transmode.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222250279.12624.195.camel@gentoo-jocke.transmode.se>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 11:57:59AM +0200, Joakim Tjernlund wrote:
> On Wed, 2008-09-24 at 18:35 +0900, Paul Mundt wrote:
> > On Wed, Sep 24, 2008 at 11:21:33AM +0200, Joakim Tjernlund wrote:
> > > As far as I can see there isn't a way to name the /dev/uio%d device file
> > > to something more useful, is that so?
> > > I would like to name the device file from within the kernel so I can
> > > find the correct device from userspace.
> > > The very least is to control the minor(%d) number.
> > > 
> > You have a couple of options for this:
> > 
> > 	- the 'name' sysfs entry for each of the uio devices, which
> > 	  corresponds to the uio device name.
> > 	- extracting the relevant data from things like 'lsuio'.
> > 	- hooking in the pretty mame through udev to create an alias.
> 
> Right, but I want to do it from within the kernel when I create the
> device because that the only place I truly know what HW the uio maps to.

Set info->name to something that's useful for the userspace part of the
driver. You can create an individual string for each HW so userspace can
easily identify the devices. The string in info->name can be anything
you like, it's only used as info given in the "name" sysfs file.

> 
> I found that this works:
>  struct uio_info *info,
>  struct uio_device *idev;
> 
>  idev = info->uio_dev;
>  device_rename(idev->dev, "irq4");
> 
> but then I have to copy the private uio_device struct from uio.c

That's a clear sign that the UIO authors didn't want people to do that
;-)

> Is there a better way to get at idev->dev?

No hackery, please. The "name" attribute is there for this purpose, use
it. Or use one of the other possibilities Paul mentioned.

Thanks,
Hans

