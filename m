Return-Path: <linux-kernel-owner+w=401wt.eu-S1757102AbXKAOvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbXKAOvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbXKAOv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:51:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40798 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752229AbXKAOv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:51:26 -0400
Date: Thu, 1 Nov 2007 10:51:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Steven King <sfking@fdwdc.com>
cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
       <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] ti_usb_3410_5052 breakage in 2.6.24-rc1
In-Reply-To: <200711010325.55147.sfking@fdwdc.com>
Message-ID: <Pine.LNX.4.44L0.0711011049140.4146-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007, Steven King wrote:

> Per a suggestion by David Brownwell, rebuilt with CONFIG_USB_DEBUG enabled and 
> loading usbserial and ti_usb_3410_5052 with debug=1, I see in 'dmesg'
> 
> 'drivers/usb/serial/usb-serial.c: wrong number of endpoints'
> 
>  which is pretty much what I expected, throwing some more printk's in 
> usb-serial gives:
> 
> drivers/usb/serial/usb-serial.c: num_interrupt_in = 0, expected 1
> drivers/usb/serial/usb-serial.c: num_interrupt_out = 0, expected 0
> drivers/usb/serial/usb-serial.c: num_bulk_in = 0, expected 1
> drivers/usb/serial/usb-serial.c: num_bulk_out = 1, expected 1
> 
> Okay, so
> ---
> 
> Changing num_interrupt_in and num_bulk_in from 1 to NUM_DONT_CARE makes 
> ti_usb_3410_5052 work again, but is it the right thing to do?

It may or may not be the right thing to do, but it definitely isn't
the correct way to solve your problem.

The real question is why 2.6.24-rc1 doesn't like the second 
configuration descriptor.  To answer it, you should see what shows up 
in the dmesg log when you first plug in the device on a kernel with 
CONFIG_USB_DEBUG enabled.

Alan Stern

