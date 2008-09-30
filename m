Return-Path: <linux-kernel-owner+w=401wt.eu-S1752453AbYI3FO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbYI3FO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 01:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYI3FOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 01:14:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:51363 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbYI3FOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 01:14:48 -0400
Date: Mon, 29 Sep 2008 22:12:58 -0700
From: Greg KH <greg@kroah.com>
To: George Nychis <gnychis@cmu.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: help finding entry point of USB data in the kernel, not
	drivers/usb/core/devio.c?
Message-ID: <20080930051258.GA6764@kroah.com>
References: <48E1B35A.1040103@cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E1B35A.1040103@cmu.edu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 01:04:26AM -0400, George Nychis wrote:
> Hi all,
>
> I am trying to find the entry point of USB data in the kernel.  I have a 
> USB device and I would like to find the latency between the time the data 
> enters the kernel, and I read it in userspace.  My first goal is to find 
> where it actually enters the kernel.

I suggest asking this on the linux-usb mailing list instead, it would
reach the main Linux USB developers.

> The host device driver obtains a URB and reads the data from urb->buffer.

Wait, which way are you sending this data?  To or from the device?

> From digging around the kernel code, I had assumed the entry point for all 
> USB data was in drivers/usb/core/devio.c::usbdev_read() ... but it seems as 
> though that is not the case.

No, that entry point is for usbfs, not the individual drivers, and not
the core.

> Right after the device is locked in this function, I added a simple printk: 
>   printk("Reading %d bytes\n", nbytes); // Line 135
>
> Then around line 154 after it reads the usb device descriptor, I added:
>     if(temp_desc.idVendor==0xfffe && temp_desc.idProduct==0x0002) {
>       printk("...Data from USRP\n");
>     }
>
> That gives me an idea that the data is coming from the device I am looking 
> for.
>
> But, it seems as though this method is only related to control information 
> to/from the USB device?  Whenever I start my application, I get about 1614 
> total bytes read from my first printout, and I see only one of my second 
> printout messages.  Whereas, I am reading a total of about 8MB from the USB 
> device over the period of time.  So I think I am completely missing my 
> actual data entry point.

Are you watching all of the different USB device endpoints?

thanks,

greg k-h
