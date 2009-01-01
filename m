Return-Path: <linux-kernel-owner+w=401wt.eu-S1756594AbZAARaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbZAARaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 12:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbZAAR3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 12:29:54 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2266 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751081AbZAAR3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 12:29:53 -0500
Date: Thu, 1 Jan 2009 12:29:51 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Yan Li <elliot.li.tech@gmail.com>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: Enable CONFIG_USB_SUSPEND by default or some mobile HD can't be
 unplugged safely
In-Reply-To: <20090101160343.GA4278@thyme.bj.intel.com>
Message-ID: <Pine.LNX.4.44L0.0901011225400.32126-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Jan 2009, Yan Li wrote:

> Hello List,
> 
> By default CONFIG_USB_SUSPEND is not enabled and today I got bite by
> this when I got a new WDC My Book hard drive. I have no way to unplug
> it safely, according to it's manual, with a kernel that doesn't have
> CONFIG_USB_SUSPEND=y.
> 
> On it's manual read "you should unplug and remove the device only when
> the light is off."

It's not clear whether you should believe this.  The manual may have 
overstated things.  Still, better to be safe.

>  On Linux unmounting it won't turn it's light off
> and I can feel it's motor is still running.  The only way to unplug it
> properly on a Linux system, as to my knowledge, is to echo `suspend'
> to `/sys/bus/usb/devices/$DEV/power/level'. And one has to have
> CONFIG_USB_SUSPEND=y to do this.
> 
> On Windows and Mac OS, `safely remove this device' function effectly
> turns it into `suspend' mode, and it's light off.

Yes -- but they don't suspend the device; instead they disable its 
upstream port.  As far as the device is concerned, there's no 
difference.  However the Linux API doesn't include any way to disable a 
USB port.  Maybe we should add one...

> I'm new in this field and I understood people's concern on enabling
> autosuspend.  As to my understanding, `enabling suspend' and `enabling
> autosuspend' should be controlled by two different knobs.

They are.

>  I did a
> quick search in LKML and haven't found specific oppose to enable USB
> suspend by default, and Debian has started shipping a kernel with
> it turned on since 2.6.26.
> 
> Perhaps we should consider turning it on by default?  Thanks!

That is indeed the next step to take.

Alan Stern

