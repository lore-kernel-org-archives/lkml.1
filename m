Return-Path: <linux-kernel-owner+w=401wt.eu-S965965AbXDCOel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965965AbXDCOel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 10:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966172AbXDCOek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 10:34:40 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:11958 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965965AbXDCOek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 10:34:40 -0400
Date: Tue, 03 Apr 2007 08:33:39 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: OHCI: USB webcam works, but not on USB Hub
In-reply-to: <fa.R4OJEk76c3blNmi9oUs1xDRZGis@ifi.uio.no>
To: Michael Bueker <m.bueker@berlin.de>
Cc: linux-kernel@vger.kernel.org
Message-id: <461265C3.4060900@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.R4OJEk76c3blNmi9oUs1xDRZGis@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Bueker wrote:
> [please CC me on this thread]
> 
> Hi everyone,
> 
> My system has an nForce4 motherboard with an OHCI USB controller.
> 
> I'm using a USB Webcam with the gspca driver (from
> http://mxhaard.free.fr/download.html), which has been working fine with the
> latest kernels.
> 
> Today, I connected a USB Hub and the camera to it, after which it stopped
> working with the error message:
>> ERROR opening V4L interface
>> : Function not implemented
> However, it works fine when not connected to the Hub, but a motherboard's own
> USB port. The Hub also works fine with any other USB device.
> 
> I googled around for a solution and found one for an older version of my
> driver, where the (apparently very ugly) fix was to manually set a fixed
> bandwidth for the USB device, instead of using a somehow other determined
> value. See this posting for a more elaborate description:
> http://lists.zerezo.com/spca50x-devs/msg00664.html
> 
> Now, I'm writing to this list because one of the followups to that post
> (http://lists.zerezo.com/spca50x-devs/msg00665.html) states that this is due
> to a problem with the Linux USB layer:
>> pls file a bug "ohci driver can't handle low+fullspeed devices on the same
>> root hub" to linux usb devel list.
> 
> That's about all I can tell you for now. I've attached two outputs of
> lsusb -vv, one with the hub attached, with the camera and a USB stick
> connected (notice the error message), and one without the hub and the
> camera connected directly (which is the setup where it works fine).

I looked into this at one point previously with spca5xx. Certainly in my 
case it was no fault of the kernel. The isochronous descriptor that the 
driver was deciding to use required so much bandwidth that it couldn't 
be accomodated if anything else was using timeslots on the bus - even a 
USB keyboard/mouse on the same hub would prevent it from getting enough 
bandwidth.

Essentially the driver should fallback to a lower-bandwidth descriptor 
if the one it tries to use fails rather than just bailing out.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

