Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbZAUS0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbZAUS0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 13:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZAUS0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 13:26:00 -0500
Received: from kroah.org ([198.145.64.141]:54430 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753541AbZAUSZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 13:25:59 -0500
Date: Wed, 21 Jan 2009 10:11:24 -0800
From: Greg KH <greg@kroah.com>
To: Sam Liddicott <sam@liddicott.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Michael Tokarev <mjt@tls.msk.ru>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       Linux USB list <linux-usb@vger.kernel.org>
Subject: Re: "permanently" unbind a device from a driver?
Message-ID: <20090121181124.GA17410@kroah.com>
References: <497638FF.8050805@msgid.tls.msk.ru> <20090120210254.GA5609@kroah.com> <d82e647a0901210744t1655bacesf23bcd54e30002e9@mail.gmail.com> <20090121162345.GB22615@kroah.com> <4977596D.409@liddicott.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4977596D.409@liddicott.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 05:20:45PM -0000, Sam Liddicott wrote:
> * Greg KH wrote, On 21/01/09 16:23:
> > On Wed, Jan 21, 2009 at 11:44:03PM +0800, Ming Lei wrote:
> >   
> >> 2009/1/21 Greg KH <greg@kroah.com>:
> >>     
> >>> Just add a blacklist rule to the usbhid driver for this device.  There
> >>> are a number of devices out there that need this functionality, which is
> >>> why there is such a list.
> >>>       
> >> Is it possible to implement a generic blacklist mechanism in driver core
> >> to support the function for all kinds of drivers? or is it necessary to do that?
> >>     
> >
> > It's not necessary as the hid core already supports this very thing due
> > to the need for it (it's the easiest way to write a userspace Windows
> > driver, so lots of manufacturers lie about their devices in order to
> > work around having to write a Windows kernel driver.)
> >
> > So just add this device to the hid core blacklist, and you are all set.
> >
> > Care to send a patch?
> >   
> 
> I've often felt that a /proc or /sys interface to allow blacklist
> additions or quirk addition would be great.

Some subsystems support this, like the HID subsystem :)

It is a subsystem-specific thing as they all do their binding in
different ways, we can't make this "generic" very easily, sorry.

> Hacking of new devices often runs faster than distro's kernel releases;
> it will often be very simple to distribute a 1 liner to make some
> hardware available than tell people to wait until the next major release
> of their distro.
> 
> As a point in instance, a couple of years ago I gave up trying to get
> some quirks added for usb dual and quad joystick adaptors. I got them
> added for one of them but not the other. It was just too much hard work.

Where did you send them?  That shouldn't happen, sorry about that.

> An user-space post-boot uploadable quirk/blacklist would be great and
> IMHO result in a bigger supply of quirks.

Again, some subsystems, like HID already support this.

thanks,

greg k-h
