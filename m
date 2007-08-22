Return-Path: <linux-kernel-owner+w=401wt.eu-S933800AbXHVWTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933800AbXHVWTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762528AbXHVWTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:19:34 -0400
Received: from canuck.infradead.org ([209.217.80.40]:37067 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761637AbXHVWTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:19:33 -0400
Date: Wed, 22 Aug 2007 14:47:12 -0700
From: Greg KH <greg@kroah.com>
To: Nate <stoddarn@msoe.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Restricting CDC-ACM devices
Message-ID: <20070822214712.GA4046@kroah.com>
References: <1187716018.731090.165620@j4g2000prf.googlegroups.com> <20070821171018.C964B5F778@attila.bofh.it> <39877.198.169.188.225.1187733834.squirrel@myweb.msoe.edu> <20070822054615.GA23336@kroah.com> <45719.198.169.188.225.1187793693.squirrel@myweb.msoe.edu> <20070822185544.GA6002@kroah.com> <17603.12.191.136.2.1187819526.squirrel@myweb.msoe.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17603.12.191.136.2.1187819526.squirrel@myweb.msoe.edu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 04:52:06PM -0500, Nate wrote:
> Thank you for your responses.  Please don't take my repeated questioning
> of your answers as me being difficult, I'm just trying to get a better
> understanding.
> 
> 
> > Well, just messing with the device ids is not that tough of a patch to
> > keep up to date over time, so you might just try that if necessary.
> 
> That is a good point.  I may also be adding some extra logic to check
> other fields to confirm compatibility before allowing a usb device to be
> bound to the CDC-ACM driver.  That is still probably pretty small piece of
> code in the probe function, but I'm just concerned that over time more
> logic would be added and other developers will be maintaining the code.

Well, this is of course the easiest way to achive what you are wanting
to do.  Only you can answer the "how I'm going to maintain this in the
future" question :)

> > Yes.  You can manually bind and unbind all PCI and USB devices from
> > their drivers from userspace.  So you do have full control over this
> > already, no kernel changes needed.
> 
> Does this require my userspace applications to poll the USB devices
> (/proc/bus/usb/devices) and then disconnect/connect my driver every time a
> USB device using CDC-ACM is connected?  Is this what is normally done? 
> Does this cause a noticeable performance hit when the driver is cycled
> like this?  If I don't enable CDC-ACM in make menuconfig, can I still bind
> it to a USB device from userspace?

No, you still need the driver to be around :)

Anyway, you can get a notification from udev whenever a device is bound
to the cdc-acm driver, and then trigger your "disconnect/connect" script
on that.

> I don't know if this matters, but I wanted to add some use case details:
> This driver will be running on a <200 MHz processor and there can be a
> number of connects/disconnect of the device in a short time from the
> users.

I don't know how fast the above will all work out, you are going to have
to test it yourself, sorry.

hope this helps,

greg k-h
