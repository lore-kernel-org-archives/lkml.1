Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbZHGXAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbZHGXAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 19:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755396AbZHGXAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 19:00:39 -0400
Received: from kroah.org ([198.145.64.141]:47489 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbZHGXAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 19:00:37 -0400
Date: Fri, 7 Aug 2009 15:24:49 -0700
From: Greg KH <greg@kroah.com>
To: Al Boldi <a1426z@gawab.com>
Cc: Chris Friesen <cfriesen@nortel.com>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
Message-ID: <20090807222449.GA31416@kroah.com>
References: <20090805171513.GA10443@kroah.com>
 <20090807052015.GA24615@kroah.com>
 <4A7C4D6C.6050101@nortel.com>
 <200908080017.31376.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908080017.31376.a1426z@gawab.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 08, 2009 at 12:17:31AM +0300, Al Boldi wrote:
> Chris Friesen wrote:
> > Greg KH wrote:
> > > On Fri, Aug 07, 2009 at 08:04:08AM +0300, Al Boldi wrote:
> > >> The question is, how fast can devtmpfs get the device list from the
> > >> kernel on bootup?  How much faster than udev?  How much slower than
> > >> static /dev?
> > >
> > > It's much faster than udev, and is equivalent to a static /dev with the
> > > exception that the group and permission settings that you are used to.
> > > udev then needs to come along and make those settings, but that's so
> > > frickin fast it's amazing.
> >
> > Earlier in the thread you indicated a 0.5sec speedup over udev.  Is that
> > really considered "much faster"?
> >
> > I do agree that it makes sense to do this, but more from an elegance
> > view than a performance one.
> 
> It's definitely more elegant, but at what cost?

You've seen the patch, you tell me :)

> For devtmpfs to be a realistic replacement for static /dev, it has to
> be comparable to static /dev in both speed and size.

Since when is this requirement necessary?  You want something for free
in both speed and size?  Well, you got it in speed, but not size, it
will take up memory that is swapable, and a tiny ammount of non-swapable
kernel memory for the code.

> WRT speed, there should be no  slowdown and it should be just as fast
> as a "tar -xp < dev.tar".

Again, where is this requirement coming from?

Have you timed devtmpfs?  Have you timed your tar extraction?  What is
the difference, and since when does anyone use tar of a static dev tree
at boot time?

> WRT size, it should not be dependent on hotplug, and instead offer
> hotplug as an option.

Um, again, who made up such a requirement?  Are you running systems
today with CONFIG_HOTPLUG disabled?  If so, how well is that working for
you?

thanks,

greg k-h
