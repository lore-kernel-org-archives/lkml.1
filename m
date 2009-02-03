Return-Path: <linux-kernel-owner+w=401wt.eu-S1753032AbZBDAF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbZBDAF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 19:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbZBDAFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 19:05:15 -0500
Received: from kroah.org ([198.145.64.141]:42718 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751117AbZBDAFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 19:05:14 -0500
Date: Tue, 3 Feb 2009 15:58:14 -0800
From: Greg KH <greg@kroah.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: wgreathouse@smva.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] usb-serial : fix the nousb oops
Message-ID: <20090203235814.GA22380@kroah.com>
References: <49857F23.3090208@gmail.com> <20090201155117.GA10018@kroah.com> <a8e1da0902011743o47764edfjf53a397b5a4aeeef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0902011743o47764edfjf53a397b5a4aeeef@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 09:43:04AM +0800, Dave Young wrote:
> On Sun, Feb 1, 2009 at 11:51 PM, Greg KH <greg@kroah.com> wrote:
> > On Sun, Feb 01, 2009 at 06:53:23PM +0800, Dave Young wrote:
> >>
> >> In case with "nousb" booting, serial drivers will trigger kernel oops.
> >
> > They will?  What is the oops message?
> 
> Yes, they will, at lease I saw usb_serial/aircable/ftdi_sio oops. I
> will manage to copy the oops message later.
> 
> >
> >> Here add usb_disabled() check in usb_serial_init and usb_serial_register
> >
> > This is odd, is it something new?  Why is usb-serial the only driver
> > that needs such a thing?
> 
> No, it is not new thing.  usb serial drivers normally call
> usb_serial_register first, then usb_register, usb_register will fail
> due to "nousb" checking, but usb_serial_register no.

But as usb_register will fail, shouldn't they properly back out and no
oopses happen?  This sounds like a simple fix to the drivers that are
failing here, not changing the usb-serial core.

And this should only be an issue if you build your drivers into the
kernel, right?

thanks,

greg k-h
