Return-Path: <linux-kernel-owner+w=401wt.eu-S1759309AbXENGJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309AbXENGJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 02:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757941AbXENGJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 02:09:43 -0400
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:3450 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757722AbXENGJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 02:09:43 -0400
Date: Mon, 14 May 2007 08:10:22 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Antonino Ingargiola" <tritemio@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc1
Message-ID: <20070514081022.7fcee97f@hyperion.delvare>
In-Reply-To: <5486cca80705131150u313eeb43i30bf040e160ac419@mail.gmail.com>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
	<5486cca80705131010h2011487dnc948a3c57ce6decc@mail.gmail.com>
	<alpine.LFD.0.98.0705131046400.6739@woody.linux-foundation.org>
	<5486cca80705131150u313eeb43i30bf040e160ac419@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antonino, hi Linus,

On Sun, 13 May 2007 20:50:54 +0200, Antonino Ingargiola wrote:
> 2007/5/13, Linus Torvalds <torvalds@linux-foundation.org>:
> > On Sun, 13 May 2007, Antonino Ingargiola wrote:
> > >
> > > On my desktop pc with Debian Etch and 2.6.22-rc1 the gnome panel
> > > applet "Sensors Applet" give an error message "No chip detected".
> > > Works fine on 2.6.21.1 (it show cpu temperature) with the same config
> > > (I've only only done  make oldconfig).

I am not familiar with the gnome sensors applet. Does it say where it
is getting the data (driver name, device name...)?

> > One thing to check is that "make oldconfig" can actually change the
> > configuration if things were moved behind a new top-level configuration
> > parameter or such. I'm not saying that's the case here, but it's possible
> > that things like the i2c changes might have made you inadvertedly changed
> > some config option.
> 
> I suspected so. However the acpi and i2c section of the two config are
> identical. I report the only selected options:
> 
> Power management options (ACPI, APM)  --->
>   [*] Power Management support
>   [*]   Software Suspend (Hibernation)
>   ACPI (Advanced Configuration and Power Interface) Support  --->
>     [*] ACPI Support
>     [*]   Sleep States
>     <M>   Button
>     <M>   Video
>     <M>   Fan
>     <M>   Processor
>     <M>     Thermal Zone
>     (0)   Disable ACPI for systems before Jan 1st this year
> 
> Device Drivers  --->
>   I2C support  --->
>     <M>   I2C device interface
>     I2C Hardware Bus support  --->
>       <M> VIA VT82C596/82C686/82xx and CX700

You forgot to list the Hardware Monitoring support options.

> > > Is this considered a regression or can be due to userland incompatibilities?
> >
> > It's a regression, although I'd like to know more about your cases. It's
> > just hard to tell what happened: was it a i2c/hwmon driver that got
> > broken, or is it some sysfs file that got buggered, or what..
> >
> > For example, "dmesg" output before and after (preferably as a diff between
> > the two), and what modules you had loaded in the working/nonworking case.
> 
> The first column of lsmod list the same modules in both kernels. The
> diff-ed dmesg is attached.

Please provide the output of lsmod.

If you are using one of the following drivers: lm78, smsc47b397,
smsc47m1, w83627hf or w83781d, you need lm_sensors >= 2.10.1
(libsensors.so.3.1.1 or later).

-- 
Jean Delvare
