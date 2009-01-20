Return-Path: <linux-kernel-owner+w=401wt.eu-S1762254AbZATVEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762254AbZATVEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 16:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758132AbZATVEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 16:04:13 -0500
Received: from kroah.org ([198.145.64.141]:35773 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758174AbZATVEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 16:04:12 -0500
Date: Tue, 20 Jan 2009 13:02:54 -0800
From: Greg KH <greg@kroah.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
       Linux USB list <linux-usb@vger.kernel.org>
Subject: Re: "permanently" unbind a device from a driver?
Message-ID: <20090120210254.GA5609@kroah.com>
References: <497638FF.8050805@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497638FF.8050805@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 11:50:07PM +0300, Michael Tokarev wrote:
> Is there a way to stop a module from claiming a
> given device no matter how/when it gets plugged?
> 
> For example, there's a series of power supplies
> (UPSes) with USB connection (common nowadays)
> which, by default, gets claimed by usbhid module.
> But it does not work as a HID device, instead it
> uses a serial line logic and has a USB<=>serial
> converter inside, which works just fine with
> cypress_m8 usbserial driver.
> 
> usbhid module is loaded on startup (to handle
> usb keyboards/mouses), and it claims this device
> too.  Using /sys/bus/.../drivers/usbhid/unbind
> releases it, after which cypress_m8 works as
> expected.  But after re-plugging it gets claimed
> by usbhid again.

Just add a blacklist rule to the usbhid driver for this device.  There
are a number of devices out there that need this functionality, which is
why there is such a list.

> I understand that it's easy to write an udev rule
> (I don't use udev but that's another story) to
> unbind the device from the driver and bind it to
> another driver automatically.  That's basically
> what I have for now (handling hidraw* device).
> But that seems somewhat... ugly, at best.
> 
> The question is: is it possible to tell usbhid
> to STOP claiming devices with given vendor:device
> identifier, from now on?
> 
> I also understand that to do it permanently the
> given vendor:device has to be blacklisted in the
> driver source.  But I don't think it's worth the
> effort.

Why wouldn't it be worth the effort?  It's obviously a problem.

thanks,

greg k-h
