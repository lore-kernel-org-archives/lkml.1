Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbZAUQ1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbZAUQ1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 11:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbZAUQ1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 11:27:34 -0500
Received: from kroah.org ([198.145.64.141]:59459 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750880AbZAUQ1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 11:27:33 -0500
Date: Wed, 21 Jan 2009 08:23:45 -0800
From: Greg KH <greg@kroah.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       Linux USB list <linux-usb@vger.kernel.org>
Subject: Re: "permanently" unbind a device from a driver?
Message-ID: <20090121162345.GB22615@kroah.com>
References: <497638FF.8050805@msgid.tls.msk.ru> <20090120210254.GA5609@kroah.com> <d82e647a0901210744t1655bacesf23bcd54e30002e9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d82e647a0901210744t1655bacesf23bcd54e30002e9@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 11:44:03PM +0800, Ming Lei wrote:
> 2009/1/21 Greg KH <greg@kroah.com>:
> > On Tue, Jan 20, 2009 at 11:50:07PM +0300, Michael Tokarev wrote:
> >> Is there a way to stop a module from claiming a
> >> given device no matter how/when it gets plugged?
> >>
> >> For example, there's a series of power supplies
> >> (UPSes) with USB connection (common nowadays)
> >> which, by default, gets claimed by usbhid module.
> >> But it does not work as a HID device, instead it
> >> uses a serial line logic and has a USB<=>serial
> >> converter inside, which works just fine with
> >> cypress_m8 usbserial driver.
> >>
> >> usbhid module is loaded on startup (to handle
> >> usb keyboards/mouses), and it claims this device
> >> too.  Using /sys/bus/.../drivers/usbhid/unbind
> >> releases it, after which cypress_m8 works as
> >> expected.  But after re-plugging it gets claimed
> >> by usbhid again.
> >
> > Just add a blacklist rule to the usbhid driver for this device.  There
> > are a number of devices out there that need this functionality, which is
> > why there is such a list.
> 
> Is it possible to implement a generic blacklist mechanism in driver core
> to support the function for all kinds of drivers? or is it necessary to do that?

It's not necessary as the hid core already supports this very thing due
to the need for it (it's the easiest way to write a userspace Windows
driver, so lots of manufacturers lie about their devices in order to
work around having to write a Windows kernel driver.)

So just add this device to the hid core blacklist, and you are all set.

Care to send a patch?

thanks,

greg k-h
