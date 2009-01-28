Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbZA1GZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbZA1GZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 01:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbZA1GY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 01:24:59 -0500
Received: from kroah.org ([198.145.64.141]:45882 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751866AbZA1GY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 01:24:58 -0500
Date: Tue, 27 Jan 2009 22:19:40 -0800
From: Greg KH <greg@kroah.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Sam Liddicott <sam@liddicott.com>, Ming Lei <tom.leiming@gmail.com>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       Linux USB list <linux-usb@vger.kernel.org>
Subject: Re: "permanently" unbind a device from a driver?
Message-ID: <20090128061940.GA14275@kroah.com>
References: <497638FF.8050805@msgid.tls.msk.ru> <20090120210254.GA5609@kroah.com> <d82e647a0901210744t1655bacesf23bcd54e30002e9@mail.gmail.com> <20090121162345.GB22615@kroah.com> <4977596D.409@liddicott.com> <20090121181124.GA17410@kroah.com> <49779284.50603@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49779284.50603@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 12:24:20AM +0300, Michael Tokarev wrote:
> Greg KH wrote:
> > On Wed, Jan 21, 2009 at 05:20:45PM -0000, Sam Liddicott wrote:
> >> * Greg KH wrote, On 21/01/09 16:23:
> >>> On Wed, Jan 21, 2009 at 11:44:03PM +0800, Ming Lei wrote:
> >>>   
> >>>> 2009/1/21 Greg KH <greg@kroah.com>:
> >>>>     
> >>>>> Just add a blacklist rule to the usbhid driver for this device.  There
> >>>>> are a number of devices out there that need this functionality, which is
> >>>>> why there is such a list.
> >>>>>       
> >>>> Is it possible to implement a generic blacklist mechanism in driver core
> >>>> to support the function for all kinds of drivers? or is it necessary to do that?
> >>>>     
> >>> It's not necessary as the hid core already supports this very thing due
> >>> to the need for it (it's the easiest way to write a userspace Windows
> >>> driver, so lots of manufacturers lie about their devices in order to
> >>> work around having to write a Windows kernel driver.)
> >>>
> >>> So just add this device to the hid core blacklist, and you are all set.
> >>>
> >>> Care to send a patch?
> 
> Ok, I'm looking at this now, but have a question:
> which quirk code(s)/bits should I use for that?
> Assuming the table in question is in
>  drivers/hid/usbhid/hid-quirks.c
> file.
> What's needed is to stop usbhid module from claiming this device in the
> first place.

No, add the device to the hid_ignore_list[] table in
drivers/hid/hid-core.c.

> >> I've often felt that a /proc or /sys interface to allow blacklist
> >> additions or quirk addition would be great.
> > 
> > Some subsystems support this, like the HID subsystem :)
> 
> Oh, I didn't know.  In fact, that's exactly what I was asking in my
> first email in this thread - to have some module parameter or a sysfs
> file which can be touched to stop the module from claiming the device.
> This also helps to debug it, to know the right bits to use.. which I
> don't know...  ;)

There is some way to do this, but I can't recall how at the moment.  Try
asking the HID maintainer about this.

good luck,

greg k-h
