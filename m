Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbZEVThq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbZEVThq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 15:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757151AbZEVThj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 15:37:39 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:41779 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010AbZEVThi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 15:37:38 -0400
Date: Fri, 22 May 2009 15:36:17 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Bill Davidsen <davidsen@tmr.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "make config" to another architecture doesn't relink
 include/asm
In-Reply-To: <4A16F2C9.1000600@tmr.com>
Message-ID: <alpine.LFD.2.00.0905221533550.5168@localhost.localdomain>
References: <alpine.LFD.2.00.0905221219500.13933@localhost.localdomain> <4A16F2C9.1000600@tmr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009, Bill Davidsen wrote:

> Robert P. J. Day wrote:
> >   should i expect this with a fresh tree on x86_64?
> >
> > $ make distclean
> > $ make defconfig
> > $ make modules_prepare
> > $ ls -l include/asm
> > lrwxrwxrwx    1 rpjday rpjday     7 2009-05-22 12:24 asm -> asm-x86
> > $
> >
> >   oh, wait, i changed my mind, i want to switch architectures so start
> > over:
> >
> > $ make clean
> > $ make ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- omap3_beagle_defconfig
> > $ make ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- uImage
> > scripts/kconfig/conf -s arch/arm/Kconfig
> > include/config/auto.conf:15:warning: symbol value
> > 'arch/x86/configs/x86_64_defconfig' invalid for ARCH_DEFCONFIG
> >   CHK     include/linux/version.h
> > make[1]: `include/asm-arm/mach-types.h' is up to date.
> >   CHK     include/linux/utsrelease.h
> >   UPD     include/linux/utsrelease.h
> > ERROR: the symlink include/asm points to asm-x86 but asm-arm was expected
> >        set ARCH or save .config and run 'make mrproper' to fix it
> > make: *** [include/asm] Error 1
> >
> > $ ls -l include/asm
> > lrwxrwxrwx 1 rpjday rpjday 7 2009-05-22 12:24 include/asm -> asm-x86
> > $
> >
> >   shouldn't it be sufficient that, if i do another "make ??_defconfig"
> > to another architecture, all traces of the previous configure are
> > erased and include/asm should be relinked automatically?
> >
> Does "make distclean" (or maybe "make mrproper") get you to really clean
> status?

  yes, but the issue is that "make clean" should still have the same
effect WRT to resetting that symlink, especially since the error
message tells the user to set ARCH and the user (i.e., me) *has* set
ARCH.  put another way, if i do a config with a specific setting for
ARCH, it seems non-intuitive to *not* reset the symlink representing
that architecture.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
