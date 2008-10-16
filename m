Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbYJPMuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbYJPMuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 08:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbYJPMt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 08:49:56 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54400 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbYJPMt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 08:49:56 -0400
Date: Thu, 16 Oct 2008 15:49:43 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081016124943.GE23630@cs181140183.pp.htv.fi>
References: <20081016002509.GA25868@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081016002509.GA25868@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 05:25:09PM -0700, Greg KH wrote:
> Hi,

Hi Greg,

>...
> Yes, we can handle the major/minor macros in the kernel to provide a
> compatible number so that automated scripts will not break, that's not a
> big deal.
> 
> Any thoughts?
>...

how much of userspace breaks when we suddenly "just for fun" change the 
version numbering scheme in a very radical way?

I'm not thinking of scripts for building the kernel.

I'm thinking of the fact that starting with glibc different pieces of 
userspace software interpret the kernel version number they get from 
various sources like e.g. <linux/version.h>, "uname -r" or an ioctl.

As a random example, the "config" script of OpenSSL 0.9.8g contains the 
following:

<--  snip  -->

...
RELEASE=`(uname -r) 2>/dev/null` || RELEASE="unknown"
...
case "${SYSTEM}:${RELEASE}:${VERSION}:${MACHINE}" in
...
    Linux:[2-9].*)
        echo "${MACHINE}-whatever-linux2"; exit 0
        ;;

    Linux:1.*)
        echo "${MACHINE}-whatever-linux1"; exit 0
        ;;
...

<--  snip  -->


Change the version number of the kernel in the way you suggest, and 
trying to build it will fail with:

<--  snip  -->

$ ./config
Operating system: x86_64-whatever-Linux
This system (Linux) is not supported. See file INSTALL for details.
$ 

<--  snip  -->


If a distribution will try to autobuild an urgent OpenSSL security 
update for their stable release in a chroot on a machine running
kernel 2009.2.3 they will surely love you for being responsible
for this...


> thanks,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

