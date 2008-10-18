Return-Path: <linux-kernel-owner+w=401wt.eu-S1752033AbYJRJBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbYJRJBj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 05:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbYJRJBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 05:01:31 -0400
Received: from 1wt.eu ([62.212.114.60]:4818 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbYJRJBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 05:01:31 -0400
Date: Sat, 18 Oct 2008 11:01:18 +0200
From: Willy Tarreau <w@1wt.eu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081018090117.GR24654@1wt.eu>
References: <20081016002509.GA25868@kroah.com> <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com> <20081016164602.GA22554@cs181140183.pp.htv.fi> <20081017034717.GA28188@kroah.com> <20081017064751.GE22554@cs181140183.pp.htv.fi> <20081017075544.GB4850@kroah.com> <20081017085604.GA20986@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017085604.GA20986@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 11:56:04AM +0300, Adrian Bunk wrote:
> On Fri, Oct 17, 2008 at 12:55:44AM -0700, Greg KH wrote:
> > On Fri, Oct 17, 2008 at 09:47:51AM +0300, Adrian Bunk wrote:
> >...
> > > Packages are built in a chroot with the correct release installed.
> > 
> > Then why would this break if they are being built against the correct,
> > older, kernel?
> 
> How could you build userspace "against a kernel"?
> 
> sys_*uname() returns the version of the running kernel.

Which is why you don't want your build scripts to rely on that, but
on the target kernel version instead. It's quite common in distros
to patch makefiles and build scripts to force some constants instead
of calls to nasty or misplaced commands. Uname certainly is one of
them.

> > But not against the proper kernel it will be run on, which sounds
> > broken.
> 
> Building software in a chroot is a common thing if you don't want to 
> setup a dedicated machine for a build environment (and all these hyped 
> virtualization solutions tend to not support architectures like alpha
> or parisc).

The chroot is OK when you want to maintain a few packages once in
a while (eg: have it on your notebook to build packages for your
customers' various distros). But it's not suited to maintain full
distros, nor to cross-compile.

> The OpenSSL 0.9.8 config script is existing userspace, and it will 
> break.

And ? All distros shipping version 0.9.8 with a current kernel will
have no problem because they backport fixes only. Once the new kernel
is out, openssl will release a minor update with a few fixes and features,
one of them being tagged as "support for Linux 2.8 and above". New distros
will then have no trouble shipping a standard openssl with a standard
kernel. All software have always worked like this, I really don't see
the problem Adrian.

> That is one example that "Will" definitely break (no matter how broken 
> or how easy to fix it is).

What makes you think that current 0.9.8g will work on 2.6.521 ? One day
you might have to upgrade your openssl anyway. What is important is that
the upgrade follows a smooth path. Adding a two-liner patch in a minor
release to support new versions is smooth.

> > And hey, if it's a problem, just fix userspace reporting to always say
> > we are the 2.6.30 release and go on our merry way, perhaps providing
> > another sysctl if it's really needed (glibc probably wants it, so it
> > would be easy to add.)
> > 
> > That's just a minor technical thing that can be trivially fixed _IF_ we
> > decide it is something that we want to do.
> 
> If we do not continue to report the correct version in sys_*uname()
> (and therefore in "uname -r") we break standard POSIX behavior.

I would not like it if uname -r would not report real version. I'd
better get a tool to force the version if this is needed (ala cpuid).
It reminds me that I had this for years under DOS :-)

Regards,
Willy

