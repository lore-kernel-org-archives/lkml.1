Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbZHKOgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbZHKOgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbZHKOgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:36:17 -0400
Received: from smtp.knology.net ([24.214.63.101]:50898 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbZHKOgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:36:16 -0400
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
From: David Dillow <dave@thedillows.org>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
In-Reply-To: <20090810153943.GB7652@kroah.com>
References: <20090805171513.GA10443@kroah.com>
	 <20090805192037.19c54c4d@lxorguk.ukuu.org.uk>
	 <20090805182805.GA7534@kroah.com> <20090805185136.GA21442@kroah.com>
	 <87ljlxhrnr.fsf@basil.nowhere.org>
	 <1249575658.19886.8.camel@lap75545.ornl.gov>
	 <20090806183147.GA28409@suse.de>
	 <1249772876.22248.34.camel@obelisk.thedillows.org>
	 <20090810153943.GB7652@kroah.com>
Content-Type: text/plain
Date: Tue, 11 Aug 2009 10:36:14 -0400
Message-Id: <1250001374.22248.65.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-10 at 08:39 -0700, Greg KH wrote:
> On Sat, Aug 08, 2009 at 07:07:56PM -0400, David Dillow wrote:
> > I followed up with Greg offline to make sure I was looking at the right
> > thing, but the upshot is that Moblin does not use an initrd and devtmpfs
> > does not in any way reduce the amount of code for those distros that
> > want to support more than the root=/dev/blah syntax.
> 
> Like Scott points out, this option now allows distros to use blkid
> directly instead of udev if they want to implement things like this
> without udev.

But they already have that functionality -- RedHat has been doing it for
ages, without devtmpfs. No new kernel code needed.

> > Given Eric and Arjan's numbers about the time it takes to populate /dev
> > from /sys -- pointing the speed problem squarely at udev or the ruleset
> > -- I don't see much of a win for devtmpfs other than avoiding a
> > static /dev to make init=/bin/sh work.
> 
> That's a very big win right there, don't you think?

No, not really. It isn't hard to make a static /dev, or a rescue initrd
for the cases with dynamic device numbers.

> Also, embedded and
> rescue disks also would like it for this very reason.

As a former embedded developer, I'd rather not waste kernel space on
something I can throw away when I've booted. I know where my root is,
and can statically populate /dev. Now, perhaps more embedded devices are
moving to use USB for their root, but then it would seem to make more
sense to use Eric/Arjan's program to populate /dev and do blk_id if I
need to find a label or UUID, and then I can reuse the memory when I'm
done. Perhaps I can find it by path and avoid the blk_id, but I still
can do that without more kernel code.

And I realize that we're not talking about a lot of kernel memory here,
so it depends on one's definition of waste.

> > You cannot rely on it for a hotplug disk such as USB, as it doesn't do
> > the root=LABEL=usbroot that you'd want to do since the location is not
> > stable.
> 
> Again, not all the world requires such labels.

Sure. But it seems the world can get what the best of both worlds from a
simple program to populate /dev from sysfs.

An interesting experiment may be time a boot to initial user space with
and without devtmpfs -- and compare the difference to Eric/Arjan's
program on the same hardware. I wonder how much is really saved.

