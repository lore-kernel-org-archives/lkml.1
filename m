Return-Path: <linux-kernel-owner+w=401wt.eu-S1760781AbZBEADj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760781AbZBEADj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757996AbZBEADN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:03:13 -0500
Received: from kroah.org ([198.145.64.141]:45766 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757678AbZBEADM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:03:12 -0500
Date: Wed, 4 Feb 2009 15:59:49 -0800
From: Greg KH <greg@kroah.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] usb-serial : fix the nousb oops
Message-ID: <20090204235949.GA300@kroah.com>
References: <49857F23.3090208@gmail.com> <20090201155117.GA10018@kroah.com> <a8e1da0902011743o47764edfjf53a397b5a4aeeef@mail.gmail.com> <20090203235814.GA22380@kroah.com> <a8e1da0902031710u2ebd69b0r4de5916fab2d3cba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0902031710u2ebd69b0r4de5916fab2d3cba@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 09:10:20AM +0800, Dave Young wrote:
> remove wgreathouse@smva.com in cc-list because this mail will be
> rejected by the smva.com email server.
> 
> On Wed, Feb 4, 2009 at 7:58 AM, Greg KH <greg@kroah.com> wrote:
> > On Mon, Feb 02, 2009 at 09:43:04AM +0800, Dave Young wrote:
> >> On Sun, Feb 1, 2009 at 11:51 PM, Greg KH <greg@kroah.com> wrote:
> >> > On Sun, Feb 01, 2009 at 06:53:23PM +0800, Dave Young wrote:
> >> >>
> >> >> In case with "nousb" booting, serial drivers will trigger kernel oops.
> >> >
> >> > They will?  What is the oops message?
> >>
> >> Yes, they will, at lease I saw usb_serial/aircable/ftdi_sio oops. I
> >> will manage to copy the oops message later.
> >>
> >> >
> >> >> Here add usb_disabled() check in usb_serial_init and usb_serial_register
> >> >
> >> > This is odd, is it something new?  Why is usb-serial the only driver
> >> > that needs such a thing?
> >>
> >> No, it is not new thing.  usb serial drivers normally call
> >> usb_serial_register first, then usb_register, usb_register will fail
> >> due to "nousb" checking, but usb_serial_register no.
> >
> > But as usb_register will fail, shouldn't they properly back out and no
> > oopses happen?  This sounds like a simple fix to the drivers that are
> > failing here, not changing the usb-serial core.
> 
> Hi greg
> 
> I think all usb serial drivers which call usb_serial_register will
> oops, so IMHO usb core should be fixed.
> 
> I think maybe you missed my another reply, copy the content here again.

No, I got it.

I'm more interested in why usb-serial is oopsing, as it should't be.

> ---
> hand copy part of the oops message:

Can you take a picture of the oops?

thanks,

greg k-h
