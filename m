Return-Path: <linux-kernel-owner+w=401wt.eu-S1751697AbZHMLeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbZHMLeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 07:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbZHMLeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 07:34:03 -0400
Received: from cantor.suse.de ([195.135.220.2]:36399 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbZHMLeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 07:34:01 -0400
Date: Thu, 13 Aug 2009 13:33:59 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "Zeisel, Michael" <michael.zeisel@philips.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: PROBLEM: full speed HID device with payload of 64 bytes
In-Reply-To: <A3467C2CEA21E3469A3218B394AD2534C3B9CE2C68@NLCLUEXM09.connect1.local>
Message-ID: <alpine.LRH.2.00.0908131331030.11142@twin.jikos.cz>
References: <A3467C2CEA21E3469A3218B394AD2534C3B9CE2C68@NLCLUEXM09.connect1.local>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added linux-usb to CC ]

On Thu, 13 Aug 2009, Zeisel, Michael wrote:

> We experienced those problems with one of our devices, the Digital 
> Pocket Memo 3 (DPM), by simply trying to receive button events via the
> 
> Cat /dev/usb/hiddev0
> 
> Command -> no success. The only difference between this device and older 
> ones (which work on this kernel version) in the USB descriptor is the 
> data payload which is 64 byte.
> 
> To narrow down the cause for that behavior we simply took the same 
> device, put in a FW with a low speed device protocol with a data payload 
> of 8 byte and plugged it again to the PC.
> 
> Now the button events produced some symbols in the "terminal", which 
> proves that the device was recognized correctly and works.
> 
> According to the USB 2.0 specification under
> 
> http://www.usb.org/developers/docs/
> 
> USB 2.0 specification, Chapter 5.7.4: Interrupt Transfer Bus Access Constraints
> 
> A full speed device should support a maximum data payload of 64 bytes 
> (Table 5-7. Full-speed Interrupt Transaction Limits: max.payload 64 
> bytes x max.transfers 19 = max. 1216bytes/frame)
> 
> To us it seems that the current implementation of the HID device support 
> in LINUX just supports the protocol for low speed devices (Table 5-6. 
> Low-speed Interrupt Transaction Limits: max.payload 8 bytes x 
> max.transfers 6 = max. 48bytes/frame)
> 
> On Windows OS and Mac OS all our devices work properly.

Could you please compile your kernel with CONFIG_USB_DEBUG and 
CONFIG_HID_DEBUG enabled, modprobe the 'hid' module with 'debug=2' 
parameter, and post the dmesg output that appears when you connect the 
device and press the buttons?

> I think it is a good idea, if you would have a Digital Pocket Memo to 
> experience the described behavior- so to whom I should send that device?

Let's see if something obvious pops out from the kernel debugging logs 
first.

Thanks,

-- 
Jiri Kosina
SUSE Labs

