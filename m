Return-Path: <linux-kernel-owner+w=401wt.eu-S1758088AbZABPn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbZABPn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 10:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756417AbZABPnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 10:43:15 -0500
Received: from rtr.ca ([76.10.145.34]:43060 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837AbZABPnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 10:43:14 -0500
Message-ID: <495E366C.9050309@rtr.ca>
Date: Fri, 02 Jan 2009 10:44:44 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jan Scholz <scholz@fias.uni-frankfurt.de>, Greg KH <gregkh@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: libusb broken on 2.6.28 x86_64 ?
References: <Pine.LNX.4.44L0.0901020820500.22914-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0901020820500.22914-100000@netrider.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Fri, 2 Jan 2009, Mark Lord wrote:
..
>> This patch, below, FIXES it for me, by undoing a change from 2.6.28.
>>
>> Signed-off-by: Mark Lord <mlord@pobox.com>
>>
>> --- old/drivers/usb/core/driver.c	2008-12-24 18:26:37.000000000 -0500
>> +++ linux/drivers/usb/core/driver.c	2009-01-02 04:34:11.000000000 -0500
>> @@ -279,9 +279,7 @@
>>  	 * altsetting means creating new endpoint device entries).
>>  	 * When either of these happens, defer the Set-Interface.
>>  	 */
>> -	if (intf->cur_altsetting->desc.bAlternateSetting == 0)
>> -		;	/* Already in altsetting 0 so skip Set-Interface */
>> -	else if (!error && intf->dev.power.status == DPM_ON)
>> +	if (!error && intf->dev.power.status == DPM_ON)
>>  		usb_set_interface(udev, intf->altsetting[0].
>>  				desc.bInterfaceNumber, 0);
>>  	else
> 
> For a proper fix, see
> 
> 	http://bugzilla.kernel.org/show_bug.cgi?id=12301#c13
> 
> A corresponding patch has been posted to linux-usb here:
> 
> 	http://marc.info/?l=linux-usb&m=123074111001861&w=2
..

Mmm.. too bad linux-kernel wasn't CC'd on that, or I might have
found the patch and saved some sleep.  Good to see that it has
been fixed down in a subsystem tree, though.

> I have no idea what's going on with the 64-bit vs. 32-bit stuff, though.
..

Yeah, something is very broken somewhere, because the _compat ioctl()s
should really produce the same behaviour as the 64-bit ones.

Looking forward to seeing this regression fixed in mainline ASAP.

Cheers
