Return-Path: <linux-kernel-owner+w=401wt.eu-S1751933AbYJRLvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbYJRLvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 07:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYJRLvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 07:51:03 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:42448 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbYJRLvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 07:51:01 -0400
Date: Sat, 18 Oct 2008 14:50:38 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081018115038.GB6535@cs181140183.pp.htv.fi>
References: <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com> <20081016164602.GA22554@cs181140183.pp.htv.fi> <20081017034717.GA28188@kroah.com> <20081017064751.GE22554@cs181140183.pp.htv.fi> <20081017075544.GB4850@kroah.com> <20081017085604.GA20986@cs181140183.pp.htv.fi> <20081018090117.GR24654@1wt.eu> <20081018100401.GA6535@cs181140183.pp.htv.fi> <20081018110826.GA25503@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081018110826.GA25503@1wt.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 01:08:26PM +0200, Willy Tarreau wrote:
> Hi Adrian,

Hi Willy,

> this is becoming off-topic, but there are some points which need to be
> addressed. Please if you want to reply afterwards, be kind to strip the
> CC list.

sorry, but you can't publically spread misinformation (and even repeat 
wrong things I already replied to earlier in this thread) and then 
demand to not have the reply public.

> On Sat, Oct 18, 2008 at 01:04:01PM +0300, Adrian Bunk wrote:
> > On Sat, Oct 18, 2008 at 11:01:18AM +0200, Willy Tarreau wrote:
> > > On Fri, Oct 17, 2008 at 11:56:04AM +0300, Adrian Bunk wrote:
> > >...
> > > > Building software in a chroot is a common thing if you don't want to 
> > > > setup a dedicated machine for a build environment (and all these hyped 
> > > > virtualization solutions tend to not support architectures like alpha
> > > > or parisc).
> > > 
> > > The chroot is OK when you want to maintain a few packages once in
> > > a while (eg: have it on your notebook to build packages for your
> > > customers' various distros). But it's not suited to maintain full
> > > distros,
> > 
> > You claim Debian was not a full distro?
> 
> I'm not judging that, they build like they want. If they want to build
> on the final target and have as many build machines as they support,
> it's their problem. It's just very amateurish.

Debian does it, it works, and there's nothing amateurish about it - it's 
much easier than coping with all the problems faced with when trying to 
cross-compile > 12.000 source packages.

With <= 3 build machines per architecture.

> I wouldn't like to be
> the guy building the full distro in a chroot on an embedded ARM or MIPS
> just because it's the target.

It's incremental, only a small amount of packages gets changed each day.

> > > nor to cross-compile.
> > 
> > Scratchbox [1], e.g. used for building the software in Nokias Internet 
> > Tablets [2] or the ARM Linux Internet Platform [3], is a chrooted 
> > cross-compilation environment.
> > 
> > Yes, it works.
> 
> I'm not saying it does not work, I'm saying it's far from being practical
> when you want to support multiple architectures or targets, and that it
> will do nasty things under you without letting you know.

Scratchbox easily allows switching between targets, no matter which 
architectures they are for.

Can you describe the problems you have experienced more precisely?

> > And since a few years everyone can buy devices running software built 
> > inside Scratchbox chroots.
> > 
> > > > The OpenSSL 0.9.8 config script is existing userspace, and it will 
> > > > break.
> > > 
> > > And ? All distros shipping version 0.9.8 with a current kernel will
> > > have no problem because they backport fixes only. Once the new kernel
> > > is out, openssl will release a minor update with a few fixes and features,
> > > one of them being tagged as "support for Linux 2.8 and above". New distros
> > > will then have no trouble shipping a standard openssl with a standard
> > > kernel. All software have always worked like this, I really don't see
> > > the problem Adrian.
> > 
> > Since Debian has a "support a release until one year after the next 
> > release" policy, Debian will at some point in the future build security 
> > fixes for OpenSSL 0.9.8g (shipped with Debian 5.0) in chroots on 
> > autobuilders running Debian 6.0 (runing kernel 2010.2.6).
> 
> The process you're describing is frighteningly broken. You're basically
> telling me that the day openssl automatically detects and enables a
> feature in the debian build environment, it will automatically enable
> it for the target environment ?
>...
> A build environment is what it is, a build environment. It contains
> compilers, shells to run scripts, various interpreters and build tools,
> possibily debuggers and editors, versionning systems, etc...

The build environment in the chroot is the correct release.    

But the kernel returns the kernel version in sys_*uname().

> > > > That is one example that "Will" definitely break (no matter how broken 
> > > > or how easy to fix it is).
> > > 
> > > What makes you think that current 0.9.8g will work on 2.6.521 ?
> > >...
> > 
> > Userspace ABIs of the kernel are usually stable.
> 
> Yes but they are not necessarily forward-compatible. If openssl believes
> some feature is present in 2.6.521 because 521 is bigger than 233, you
> will build a broken package which will not work with any distro running
> your long-term 2.6.27 which does not have the feature introduced in .233.

I already addressed this previously in this thread:

I'm not even sure whether OpenSSL actually does anything with the 
information: The script comes from the Apache foundation and
claims to be "Similar to config.guess but much, much smaller."

>...
> And when
> you know how to fix packages so that chroot is not a problem, then you
> know how to fix the package not to require a chroot.

That's complete bullshit:

Packages do not require fixes for being built inside a chroot.

Given:
- some software package of a foobar program
- Scratchbox on an x86 host
- an ARM target that mounts the target filesystem from the host

host   # ./configure && make && make install
target # foobar

The build system of the software thinks it gets built on the target 
architecture.

And due to transparent usage of qemu or sbrsh it also works when the 
package uses a program built for the target during the build.
No matter whether the build system of the package knows anything about 
cross-compilation.

> Willy

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

