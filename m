Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbYDGSCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbYDGSCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 14:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbYDGSB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 14:01:57 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:64501 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbYDGSB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 14:01:56 -0400
Date: Mon, 7 Apr 2008 10:56:49 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: David Brownell <david-b@pacbell.net>
cc: Ben Nizette <bn@niasdigital.com>, Trent Piepho <tpiepho@freescale.com>,
       Jean Delvare <khali@linux-fr.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: userspace GPIO access (WAS: [patch/rfc 2/4] pcf875x ...)
In-Reply-To: <200804042105.47687.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.64.0804052100580.15143@t2.domain.actdsltmp>
References: <200710291809.29936.david-b@pacbell.net>
 <Pine.LNX.4.64.0804032014190.20532@t2.domain.actdsltmp>
 <1207285076.4082.75.camel@moss.renham> <200804042105.47687.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2008, David Brownell wrote:
>
> - Trent's gpio_class exposes all GPIOs, even ones
>   that are claimed by kernel drivers ... and thus
>   makes it easy to clobber kernel driver state.

This was intentional.  When you're developing said kernel drivers, or
connecting hardware they're supposed to drive, it's very handy to be able
to set and read the GPIOs from userspace.  At least, when writing a
gpiolib driver and code that used gpiolib, I found this ability very
useful, so I thought other developers might as well.

I suppose one could make the sys files read-only once a kernel driver
allocates a gpio.  But it would be nice to have the ability to make them
writable, if one really wants that.

>   (Plus it won't work on most built-in GPIOs, since
>   they by and large don't have parent devices.)

Couldn't they always add one?  My GPIO driver is part of the CPU/SoC, and
it has a device node.  It's pretty easy to add a platform device, and
probably cleaner than not associating a device with the gpio driver. 
>From my understanding of sysfs, it seems any sysfs based approach has to
be based on a device.

> What I'd like to see is userspace config commands to
> cause the gpio_request() ... *maybe* something like

Suppose I took the code I had, and make the label file writable?  Writing
to it allocates the gpio with the written label?  That would be
relatively simple to add.  Is there any reason why the GPIOs should
appear in sysfs by default?  They are devices, and most other devices
appear in sysfs.

> Plus, there should be some way to cause gpio_free() too.

Write a blank label?  Too bad one can't "rm" sysfs files, that would be a
neat way to trigger stuff.  I can see it used to hot-unplug a pci device,
just delete the slot.
