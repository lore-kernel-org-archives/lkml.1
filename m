Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbZHGFDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbZHGFDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 01:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbZHGFDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 01:03:34 -0400
Received: from mailhost3.gawab.com ([66.220.20.3]:51639 "HELO info8.gawab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750822AbZHGFDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 01:03:34 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based /dev
Date: Fri, 7 Aug 2009 08:04:08 +0300
User-Agent: KMail/1.5
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
References: <20090805171513.GA10443@kroah.com> <200908070703.40706.a1426z@gawab.com> <20090807042544.GA24299@kroah.com>
In-Reply-To: <20090807042544.GA24299@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908070804.08156.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Aug 07, 2009 at 07:03:40AM +0300, Al Boldi wrote:
> > Greg KH wrote:
> > > On Thu, Aug 06, 2009 at 11:18:05PM +0300, Al Boldi wrote:
> > > > So really, if devtmpfs compares to udev speeds then this just looks
> > > > like a devfs comeback.  Remember, devfs was really slow.
> > >
> > > Again, there is no "speed" for devtmpfs on its own, the device nodes
> > > just appear when the devices are added to the kernel, the speed of that
> > > depends on the device discovery within the kernel, nothing else.
> >
> > So on bootup this would mean a lot of discovery.
>
> Yes, all of this happens within the kernel, like normal.  What are you
> getting at?

I am getting at boot delay.  A lot of discovery means a lot of delay.
A lot of delay means people will stick with static /dev.

> > I think we could get some big speedup, by just dumping the possible
> > non-realized device list on bootup, and then just refine it on physical
> > access.  This could make devtmpfs an acceptable replacement to static
> > /dev.
>
> Um, that's exactly what devtmpfs does, it creates the nodes based on
> the fact that the devices were physically (or virtually for some
> devices) discovered and registered with the kernel.  This happens at the
> same time the existing uevents are generated and sent out to userspace.

The question is, how fast can devtmpfs get the device list from the kernel on 
bootup?  How much faster than udev?  How much slower than static /dev?


Thanks!

--
Al

