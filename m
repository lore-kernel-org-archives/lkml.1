Return-Path: <linux-kernel-owner+w=401wt.eu-S1750914AbXEXOIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750914AbXEXOIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 10:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbXEXOIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 10:08:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:50443 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbXEXOIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 10:08:46 -0400
Subject: Re: [RFC PATCH] /sys/block -> /sys/class/block  (Fedora 3 &
	4	testers wanted)
From: Kay Sievers <kay.sievers@vrfy.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4654A581.6010201@msgid.tls.msk.ru>
References: <20070521235353.GA6242@kroah.com>
	 <20070522102501.72f40828@gondolin.boeblingen.de.ibm.com>
	 <20070522182812.79b53880@gondolin.boeblingen.de.ibm.com>
	 <20070523003255.GA3675@kroah.com>
	 <20070523073959.0f5cb104@gondolin.boeblingen.de.ibm.com>
	 <20070523180842.GA11999@kroah.com>  <4654A581.6010201@msgid.tls.msk.ru>
Content-Type: text/plain
Date: Thu, 24 May 2007 16:07:08 +0200
Message-Id: <1180015628.3579.41.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+Fr3UNDhUdYd4UXSzadhQo6CdOcBM0I6OZZ0t
 sutp7VYq2Uu0+jfUJGmP00IFGfF8FFg+38nSJAMsh6gHtJ/upZ
 8Ybp1SeMBpEDj/nlVUwZBzvqRBanRwO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-24 at 00:35 +0400, Michael Tokarev wrote:
> Greg KH wrote:
> []
> > From: Kay Sievers <kay.sievers@vrfy.org>
> > Subject: Driver core: convert block from raw kobjects to core devices
> > 
> > This moves the block devices to /sys/class/block. It will create a
> > flat list of all block devices, with the disks and partitions in one
> > directory. For compatibility /sys/block is created and contains symlinks
> > to the disks.
> 
> What's the proper way now to figure out which device type it is --
> block or char?

>From the "subsystem" value of the device, only if it's "block" it's a
block node, everything else is a char node.

> Before, I had a function (in my udev-alike userspace app), something akin
> sysfs_scan_devices(char *topdir, mode_t type), and called it twice --
> 
>   sysfs_scan_devices("/block", S_IFBLK);
>   sysfs_scan_devices("/devices", S_IFCHR);
> 
> How it's supposed to work now?

You need to resolve the symlink, back to the originating subsystem the
device belongs to.
Just better read the flat directories /sys/bus/*/devices/*, /sys/class/*/*,
and you get the subsystem values for free, instead of searching through
the directory tree in /sys/devices/.

> (Note that it skips symlinks for obvious
> reason, hence it can't find anything in /sys/block, even with the compat
> "layer" in place)

Everything can be a symlink or a directory, you can't assume one or the
other. You better start from the buses and classes. The udevtrigger code
or the HAL coldplug code work with all versions of sysfs, just look at
these as an example.

Thanks,
Kay

