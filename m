Return-Path: <linux-kernel-owner+w=401wt.eu-S1760090AbXEWAlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090AbXEWAlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 20:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756985AbXEWAlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 20:41:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60713 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000AbXEWAlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 20:41:31 -0400
Date: Tue, 22 May 2007 17:32:55 -0700
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC PATCH] /sys/block -> /sys/class/block  (Fedora 3 & 4
	testers wanted)
Message-ID: <20070523003255.GA3675@kroah.com>
References: <20070521235353.GA6242@kroah.com> <20070522102501.72f40828@gondolin.boeblingen.de.ibm.com> <20070522182812.79b53880@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522182812.79b53880@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 06:28:12PM +0200, Cornelia Huck wrote:
> On Tue, 22 May 2007 10:25:01 +0200,
> Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> 
> > I tried this on one of our internal drivers, which is based on FC 3 (or
> > 4, can look this up). With s390 defconfig, it is unable to open the
> > root device /dev/dasda1 (which is unsurprising, considering udev (063)
> > decided to create /dev/dasda(1) as a character node instead of a block
> > node).
> 
> Just to be clear, it's fsck that complains:
> 
> Checking filesystems  
> Checking all file systems.  
> [/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a /dev/dasda1   
> fsck.ext3: No such device or address while trying to open /dev/dasda1   
> Possibly non-existent or swap device?  
> [FAILED]   
> 
> (so that is after udev has been started and obviously dasda1 could be
> accessed)

But /dev/dasda1 isn't present?  Or why would fsck be complaining here?

> > When I look at the system, /sys/block/ and /sys/class/block/ look sane
> > at first glance (working on a 3270 console is usally PITA...)
> > 
> > Even more surprisingly, the system comes up fine (once I added ptmx to
> > makedev.d/) with CONFIG_SYSFS_DEPRECATED not set. /sys/block/
> > and /sys/class/block/ look just like expected. (Unfortunately, our
> > lsdasd tool breaks with this...)
> > 
> > I'll see if I can find out more.
> 
> I currently have the inkling that
> 
> lrwxrwxrwx  1 root root    0 May 22 15:59 block:dasda1-> ../../../class/block/dasda1
> 
> in /sys/block/dasda/ is the culprit.

Why?

> In all other versions I've tried (without CONFIG_SYSFS_DEPRECATED, and
> on an older kernel with and without CONFIG_SYSFS_DEPRECATED), it's
> always dasda1.

That's just a back symlink, the real device should still be there.

Oh, and yes, you will probably have to have CONFIG_SYSFS_DEPRECATED
enabaled to have a chance for these to work on Fedora 4 or 3.

> I can continue investigating tomorrow, unless someone has a good idea :)

I don't, but any information you can find out would be greatly
appreciated, especially as it seems like it is working, but something is
still a little bit wrong.

thanks,

greg k-h
