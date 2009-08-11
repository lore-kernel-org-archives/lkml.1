Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbZHKMoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbZHKMoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZHKMoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:44:23 -0400
Received: from kroah.org ([198.145.64.141]:41377 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbZHKMlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:41:35 -0400
Date: Mon, 10 Aug 2009 21:04:31 -0700
From: Greg KH <greg@kroah.com>
To: Al Boldi <a1426z@gawab.com>
Cc: Chris Friesen <cfriesen@nortel.com>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
Message-ID: <20090811040431.GA1178@kroah.com>
References: <20090805171513.GA10443@kroah.com>
 <200908082155.24686.a1426z@gawab.com>
 <20090810154029.GC7652@kroah.com>
 <200908110648.26191.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908110648.26191.a1426z@gawab.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 06:48:26AM +0300, Al Boldi wrote:
> Greg KH wrote:
> > On Sat, Aug 08, 2009 at 09:55:24PM +0300, Al Boldi wrote:
> > > Greg KH wrote:
> > > > On Sat, Aug 08, 2009 at 12:14:39PM +0300, Al Boldi wrote:
> > > > > Greg KH wrote:
> > > > > > On Sat, Aug 08, 2009 at 12:17:31AM +0300, Al Boldi wrote:
> > > > > > > For devtmpfs to be a realistic replacement for static /dev, it
> > > > > > > has to be comparable to static /dev in both speed and size.
> > > > > >
> > > > > > Since when is this requirement necessary?  You want something for
> > > > > > free in both speed and size?  Well, you got it in speed, but not
> > > > > > size, it will take up memory that is swapable, and a tiny ammount
> > > > > > of non-swapable kernel memory for the code.
> > > > >
> > > > > Not so tiny when you count in the hotplug dependency.
> > > >
> > > > devtmpfs does not rely on hotplug at all.
> > >
> > > Are you sure?
> > >
> > > This is from the patch of this thread:
> > > > +config DEVTMPFS
> > > > +       bool "Create a kernel maintained /dev tmpfs (EXPERIMENTAL)"
> > > > +       depends on HOTPLUG && SHMEM && TMPFS
> >
> > Ah, you're right.
> >
> > Ok then, since you don't run CONFIG_HOTPLUG kernels, why are you worried
> > about this code at all?
> >
> > confused,
> 
> Linux used to be lean and mean which made it fun to work with, and which made 
> the switch from the competition easy.  Nowadays I see a lot of bloat going 
> into the kernel which may indicate that Linux is starting to run out of 
> steam.

That doesn't seem to make sense, if more development is happening, and
our number of contributors, different companies, and rate of change is
increasing, how are we "running out of steam"?

What specific development number is proof of us slowing down?  I see
nothing but the exact, and extreme, opposite thing happening.

> devtmpfs seems bloaty due to the hotplug dependency.

Would you use it if we fix it to remove this dependancy?

Remember, the dependancy is the other way around here, if you don't want
a CONFIG_HOTPLUG system (and honestly, I really can't believe that you
run a system that interacts with the real world in a non-embedded manner
that way), then you do not also have the devtmpfs code.  So your system
will be "light and tight", right?

So what really is your objection here?  That we did not let devtmpfs
work within a CONFIG_HOTPLUG=n type system?  Or that devtmpfs works with
the existing CONFIG_HOTPLUG=y systems (i.e. 99% of the world)?

greg k-h
