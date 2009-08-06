Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbZHFUxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbZHFUxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 16:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756232AbZHFUxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 16:53:38 -0400
Received: from kroah.org ([198.145.64.141]:39639 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756181AbZHFUxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 16:53:37 -0400
Date: Thu, 6 Aug 2009 13:49:11 -0700
From: Greg KH <greg@kroah.com>
To: Al Boldi <a1426z@gawab.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
Message-ID: <20090806204911.GA14025@kroah.com>
References: <20090805171513.GA10443@kroah.com>
 <200908062006.16263.a1426z@gawab.com>
 <20090806183653.GC28433@kroah.com>
 <200908062318.05478.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908062318.05478.a1426z@gawab.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 11:18:05PM +0300, Al Boldi wrote:
> Greg KH wrote:
> > On Thu, Aug 06, 2009 at 08:06:16PM +0300, Al Boldi wrote:
> > > Andi Kleen wrote:
> > > > Greg KH <greg@kroah.com> writes:
> > > > > It makes the userspace boot process much simpler and easier to
> > > > > maintain, as well as providing a way to handle rescue disks and
> > > > > images trivially, and it makes the kernel _less_ dependant on the
> > > > > early userspace bootup scripts.
> > > >
> > > > As a initrd less kernel user I can really only agree: getting rid
> > > > of the udev-in-initrd requirement would be a big step forward
> > > > in usability. Typically I always have to pre populate
> > > > a on disk /dev manually first to get my kernels to boot.
> > >
> > > Oh good, I thought I was the only one doing that.
> > >
> > > The reason I don't like udev is that it's just to slow; something like a
> > > 5-10s delay on each boot.  No idea why it should be so slow, but it's
> > > probably probing the kernel for all available devices at boot, when it
> > > could be much quicker by probing for the device on access.
> >
> > Like Kay stated, this sounds like a misconfiguration of your distro's
> > udev setup, as the ones I use (openSUSE and Gentoo) do not have this
> > problem at all.
> 
> Maybe they are using the same trick as Ubuntu and Debian, as they run udev in 
> the background to hide the slowness.  Both Fedora and Mandriva run udev in 
> the foreground where the slowness is visible.

No, Gentoo and openSUSE do not run udev in the background.  It's all due
to the different scripts the udev rules call.  Fedora was known for
having some pretty horrible scripts in older releases, which have
hopefully been fixed in the latest releases.

> So really, if devtmpfs compares to udev speeds then this just looks like a 
> devfs comeback.  Remember, devfs was really slow.

Again, there is no "speed" for devtmpfs on its own, the device nodes
just appear when the devices are added to the kernel, the speed of that
depends on the device discovery within the kernel, nothing else.

And devfs was slow?  How was that measured?  That's not why it was
removed from the kernel, that was due to a wide variety of other
reasons.

thanks,

greg k-h
