Return-Path: <linux-kernel-owner+w=401wt.eu-S1762298AbXKDCDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762298AbXKDCDA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 22:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759337AbXKDCCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 22:02:43 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46730 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758750AbXKDCCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 22:02:41 -0400
Date: Sun, 4 Nov 2007 03:02:17 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas =?utf-8?Q?B=C3=A4chler?= <thomas@archlinux.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: 2.6.24-rc1-82798a1 compile failure (x86_64)
Message-ID: <20071104020217.GJ12045@stusta.de>
References: <fg5kar$d70$1@ger.gmane.org> <alpine.LFD.0.9999.0710292310040.3186@localhost.localdomain> <47266BF6.6070206@archlinux.org> <alpine.LFD.0.9999.0710300033470.3186@localhost.localdomain> <4726F510.9060207@archlinux.org> <472C47B4.4030808@archlinux.org> <20071103121149.GA22149@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071103121149.GA22149@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2007 at 01:11:49PM +0100, Sam Ravnborg wrote:
> On Sat, Nov 03, 2007 at 11:04:36AM +0100, Thomas Bächler wrote:
> > Thomas Bächler schrieb:
> > > 
> > > I just remembered, a friend of mine got it to compile with the exact
> > > same toolchain, but with a different configuration (which I don't have).
> > > He used a snapshot tarball from yesterday though, not the git tree.
> > > 
> > 
> > I found the problem and eliminated it. While this is my own fault, it is
> > still a bug in either the kernel or the build system: I had CFLAGS set
> > to "-Wall -O3 -march=native -pipe". I always thought the kernel would
> > ignore those and set its own CFLAGS, but I was wrong. Either the -O3 or
> > the -march=native break the build process on gcc 4.2.2.
> > 
> The kernel will now honour the users CFLAGS setting as you just discovered.
> The flags will be appended to the flags specified by the kernel.
>...

I think this should be changed:

I also have CFLAGS set on some computers in my environments since for 
packages using GNU autoconf that's the correct way to set the compiler 
flags.

The kernel already sets all flags correctly, and a user wanting to 
change the flags for the kernel is an exception with very special needs
(I'd even claim so special that he could simply edit the Makefile...).

Using the *FLAGS automatically in the kernel doesn't sound right, can we 
prefix all environment variables the kernel honours with KERNEL_ ?

> 	Sam 

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

