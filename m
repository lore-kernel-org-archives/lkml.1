Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbXFWVDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbXFWVDW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 17:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbXFWVDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 17:03:15 -0400
Received: from www.osadl.org ([213.239.205.134]:53326 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751768AbXFWVDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 17:03:14 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
To: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>
Subject: Re: Linux on XScale 270
Date: Sat, 23 Jun 2007 23:07:11 +0200
User-Agent: KMail/1.9.6
Cc: Wolfgang Draxinger <wdraxinger@darkstargames.de>,
       linux-kernel@vger.kernel.org
References: <200706231618.44659.wdraxinger@darkstargames.de> <467D8141.7040604@gmail.com>
In-Reply-To: <467D8141.7040604@gmail.com>
Organization: Linutronix
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706232307.11726.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 23 Juni 2007 schrieb Dmitry Krivoschekov:
> Wolfgang Draxinger wrote:
> > Typing "Linux XScale 270 or 27x" brings you a lot of pages but not an
>
> Probably "XScale 270" is not the best word combination for this,
> the exact processor name is PXA270 (formerly Intel, now Marvell).
>
> > in depth doc/HOWTO how to compile your own kernel and make a boot
> > image for that arch. The vendor from which I get the XScale sponsored
> > has ready to use Linux images and source on his webpage, but they're
> > kinda old and dusty.
> > http://www.toradex.ch/colibri_downloads/Linux/
> >
> > So what are the steps I've to take, to get a Linux Kernel on a XScale?
>
> Assuming the mainline kernel already includes support for your machine,

It doesn't. I'm currently working on board support for the Toradex Colibri
module, plus one board that uses that module. It works for me now, but 
still needs some testing and cleanup. I'll probably post my patch to the
linux-arm-kernel list next week and try to get it into mainline.

>
> 1. get the latest stable Linux kernel

Yes - please _don't_ use the 2.6.12-something stuff available somewhere
for the Colibri. It contains a serious bug that cost me days to find,
and it's hopelessly out of date.

Step 1.1: Apply my board support patch. Either wait until I post it to
the list or contact me by private mail.

Step 1.2: If your board has an LCD or other extra hardware, add support 
for it in colibri.c.

> 2. compile the kernel:
>     make ARCH=arm CROSS_COMPILE=<your_crosscompiler_prefix>
> <your_machine_name>_defconfig
>     make <kernel_image_name>
>
>     For example, to compile the kernel for Mainstone platform
>     with blob flashed, do the following:
>
>     make ARCH=arm CROSS_COMPILE=arm-linux- mainstone_defconfig
>     make zImage

Depending on your bootloader, you might need to perform extra 
steps, e.g. for U-Boot you need to convert zImage to uImage.

>
> 3. boot the image as appropriate for your bootloader
>
> > It's obvious that I need a cross compiler for ARM, bootloader images
> > and so on, but it's the gory details I'm curios about.
> >
> > Links to HOWTOs, documentation highly appreciated. And probably
> > there's also a better suited maillist than LKML for this, to a
> > pointer to that (if existing) would be nice, too.

I'd recommend to ask this question again on the linux-arm-kernel
list. We shouldn't flood linux-kernel list with arch specific stuff.
It would also be interesting to know which toolchain and/or
distribution you intend to use. Note that you do not only need
a kernel, but also a root file system. The colibri module has only
32MB flash, which means you have to handcraft a small rfs. If you
don't have any plans yet, have a look at www.busybox.net, and
www.scratchbox.org. I used scratchbox to cross compile my kernel
and the packages for my root file system.

>
> linux-arm-kernel@lists.arm.linux.org.uk   - for kernel-specific issues
> linux-arm@lists.arm.linux.org.uk          - for general questions
>
> these are the most appropriate lists for your questions
> (your subscription is required).

True. See you there,
Hans


