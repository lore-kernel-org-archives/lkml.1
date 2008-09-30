Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395AbYI3FEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbYI3FEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 01:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbYI3FEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 01:04:36 -0400
Received: from SMTP.andrew.cmu.edu ([128.2.10.85]:42794 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbYI3FEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 01:04:35 -0400
Message-ID: <48E1B35A.1040103@cmu.edu>
Date: Tue, 30 Sep 2008 01:04:26 -0400
From: George Nychis <gnychis@cmu.edu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: help finding entry point of USB data in the kernel, not drivers/usb/core/devio.c?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am trying to find the entry point of USB data in the kernel.  I have a 
USB device and I would like to find the latency between the time the 
data enters the kernel, and I read it in userspace.  My first goal is to 
find where it actually enters the kernel.

The host device driver obtains a URB and reads the data from urb->buffer.

 From digging around the kernel code, I had assumed the entry point for 
all USB data was in drivers/usb/core/devio.c::usbdev_read() ... but it 
seems as though that is not the case.

Right after the device is locked in this function, I added a simple 
printk:   printk("Reading %d bytes\n", nbytes); // Line 135

Then around line 154 after it reads the usb device descriptor, I added:
     if(temp_desc.idVendor==0xfffe && temp_desc.idProduct==0x0002) {
       printk("...Data from USRP\n");
     }

That gives me an idea that the data is coming from the device I am 
looking for.

But, it seems as though this method is only related to control 
information to/from the USB device?  Whenever I start my application, I 
get about 1614 total bytes read from my first printout, and I see only 
one of my second printout messages.  Whereas, I am reading a total of 
about 8MB from the USB device over the period of time.  So I think I am 
completely missing my actual data entry point.

Additionally, lsusb generates this same exact amount 1614 total bytes of 
data... so it seems to be control related to me.

I'd greatly appreciate any guidance.

Thanks!
George
