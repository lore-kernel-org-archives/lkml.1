Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbYJPPXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbYJPPXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 11:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbYJPPXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 11:23:14 -0400
Received: from kroah.org ([198.145.64.141]:32982 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753581AbYJPPXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 11:23:13 -0400
Date: Thu, 16 Oct 2008 08:17:48 -0700
From: Greg KH <greg@kroah.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081016151748.GA31075@kroah.com>
References: <20081016002509.GA25868@kroah.com> <20081016124943.GE23630@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016124943.GE23630@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 03:49:43PM +0300, Adrian Bunk wrote:
> On Wed, Oct 15, 2008 at 05:25:09PM -0700, Greg KH wrote:
> > Hi,
> 
> Hi Greg,
> 
> >...
> > Yes, we can handle the major/minor macros in the kernel to provide a
> > compatible number so that automated scripts will not break, that's not a
> > big deal.
> > 
> > Any thoughts?
> >...
> 
> how much of userspace breaks when we suddenly "just for fun" change the 
> version numbering scheme in a very radical way?
> 
> I'm not thinking of scripts for building the kernel.
> 
> I'm thinking of the fact that starting with glibc different pieces of 
> userspace software interpret the kernel version number they get from 
> various sources like e.g. <linux/version.h>, "uname -r" or an ioctl.
> 
> As a random example, the "config" script of OpenSSL 0.9.8g contains the 
> following:
> 
> <--  snip  -->
> 
> ...
> RELEASE=`(uname -r) 2>/dev/null` || RELEASE="unknown"
> ...
> case "${SYSTEM}:${RELEASE}:${VERSION}:${MACHINE}" in
> ...
>     Linux:[2-9].*)
>         echo "${MACHINE}-whatever-linux2"; exit 0
>         ;;
> 
>     Linux:1.*)
>         echo "${MACHINE}-whatever-linux1"; exit 0
>         ;;
> ...
> 
> <--  snip  -->
> 
> 
> Change the version number of the kernel in the way you suggest, and 
> trying to build it will fail with:
> 
> <--  snip  -->
> 
> $ ./config
> Operating system: x86_64-whatever-Linux
> This system (Linux) is not supported. See file INSTALL for details.
> $ 
> 
> <--  snip  -->
> 
> 
> If a distribution will try to autobuild an urgent OpenSSL security 
> update for their stable release in a chroot on a machine running
> kernel 2009.2.3 they will surely love you for being responsible
> for this...

Distros properly patch things and backport "urgent OpenSSL security
updates" to older versions of packages, so they would not run into this
problem.

Newer releases would run into this problem, but as almost all distros
have huge, easy to run, build systems, a change like this would show up
immediately and be fixed in a matter of hours, with the needed fixes
being pushed upstream to the various packages as needed.

So I really don't think this is much of a problem.

It's interesting that openssl doesn't just check for Linux 1.x and
assumes that Linux 9.23.12 will work just fine with what they are doing :)

thanks,

greg k-h
