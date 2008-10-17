Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbYJQI41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbYJQI41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 04:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYJQI4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 04:56:19 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:39283 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbYJQI4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 04:56:18 -0400
Date: Fri, 17 Oct 2008 11:56:04 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081017085604.GA20986@cs181140183.pp.htv.fi>
References: <20081016002509.GA25868@kroah.com> <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com> <20081016164602.GA22554@cs181140183.pp.htv.fi> <20081017034717.GA28188@kroah.com> <20081017064751.GE22554@cs181140183.pp.htv.fi> <20081017075544.GB4850@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081017075544.GB4850@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 12:55:44AM -0700, Greg KH wrote:
> On Fri, Oct 17, 2008 at 09:47:51AM +0300, Adrian Bunk wrote:
>...
> > Packages are built in a chroot with the correct release installed.
> 
> Then why would this break if they are being built against the correct,
> older, kernel?

How could you build userspace "against a kernel"?

sys_*uname() returns the version of the running kernel.

> > > and that build would be
> > > determining things based on the system it is built on, not what it is
> > > being built for?
> > 
> > No.
> > 
> > In the example I gave it is OpenSSL that parses the version number of 
> > the kernel.
> 
> The running kernel, with the expectation that this is the kernel it is
> going to be running on after it is built, right?  Sounds like to ensure
> this is correct, you better be building it on the kernel that you are
> going to run it on, or its build process is broken.

I'm not even sure whether OpenSSL actually does anything with the 
information: The script comes from the Apache foundation and
claims to be "Similar to config.guess but much, much smaller."

BTW: Apache 1.3 seems to ship and use the same script.

>...
> > Building in a chroot is hardly "very broken".
> > 
> > And it does build against the correct
> > libraries/kernel headers/gcc/glibc/etc .
> 
> But not against the proper kernel it will be run on, which sounds
> broken.

Building software in a chroot is a common thing if you don't want to 
setup a dedicated machine for a build environment (and all these hyped 
virtualization solutions tend to not support architectures like alpha
or parisc).

>...
> > And this was just one example.
> > 
> > What does userspace with the kernel version returned by GDTIOCTL_OSVERS?
> 
> I don't know, hopefully not much if anything.  glibc does things with
> it, but that is usually to turn off emulation of various features that
> are in the kernel in newer releases.
> 
> > I don't know whether it just displays the number, or whether it 
> > determines anything based on it.
> > 
> > Or what else might parse the version number?
> > 
> > What if some proprietary userspace software like Skype or Flash or 
> > whatever parses the kernel version number at runtime and barfs on 
> > 2009.2.3 in a way similar to the OpenSSL build system?
> > 
> > WHAT YOU SUGGEST WILL BREAK EXISTING USERSPACE SOFTWARE.
> > 
> > Please admit this fact.
> 
> "Might" I will give you, "Will", I will not without actually testing.

The OpenSSL 0.9.8 config script is existing userspace, and it will 
break.

That is one example that "Will" definitely break (no matter how broken 
or how easy to fix it is).

> And hey, if it's a problem, just fix userspace reporting to always say
> we are the 2.6.30 release and go on our merry way, perhaps providing
> another sysctl if it's really needed (glibc probably wants it, so it
> would be easy to add.)
> 
> That's just a minor technical thing that can be trivially fixed _IF_ we
> decide it is something that we want to do.

If we do not continue to report the correct version in sys_*uname()
(and therefore in "uname -r") we break standard POSIX behavior.

The implementation might be trivial, but choosing between breaking 
existing userspace and breaking longexisting and standardized UNIX
behavior is not a nice choice.

> And to get back to the original point, Linus had expressed such an
> interest in changing this a while ago, so I was bringing it up, saying
> that I to thought we should change this, and proposed one such naming
> change.

Was he aware of the consequences?

>...
> thanks,
> 
> greg "take a chill pill" k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

