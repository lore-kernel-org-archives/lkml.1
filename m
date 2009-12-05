Return-Path: <linux-kernel-owner+w=401wt.eu-S932898AbZLEUGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898AbZLEUGN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 15:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932887AbZLEUGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 15:06:07 -0500
Received: from hera.cwi.nl ([192.16.191.8]:37816 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932869AbZLEUGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 15:06:05 -0500
Date: Sat, 5 Dec 2009 21:06:06 +0100
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ed Tomlinson <edt@aei.ca>, Andries Brouwer <Andries.Brouwer@cwi.nl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [BUG] 2.6.32 - Sddr-09 SM reader resets endlessly
Message-ID: <20091205200606.GA23243@mette>
References: <200912042344.21996.edt@aei.ca> <Pine.LNX.4.44L0.0912051246580.15558-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0912051246580.15558-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 05, 2009 at 12:55:40PM -0500, Alan Stern wrote:

> > [ 1259.709281] usb 3-1: new full speed USB device using ohci_hcd and address 4
> > [ 1259.867687] usb 3-1: New USB device found, idVendor=0781, idProduct=0200
> 
> Not shown explicitly, the bcdDevice value is 0208.
> 
> > [ 1259.874603] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> > [ 1259.881956] usb 3-1: Product: USB SSFDC
> > [ 1259.881958] usb 3-1: Manufacturer: SanDisk

> > [ 1266.830235] sddr09: could not read card info
> > [ 1266.847287] sddr09: could not read card info

> Skipping to the important part, where the sddr09 driver implements TEST 
> UNIT READY:
> 
> > ffff8801571e5240 2548283209 S Co:3:004:0 s 41 00 0000 0000 000c 12 = 00200000 00000000 00000000
> > ffff8801571e5240 2548536793 C Co:3:004:0 -32 12 >
> 
> That failure is responsible for the resets.
> 
> Andries, do you have any idea what's going on?  Evidently this device 
> doesn't accept the protocol used by the sddr09 driver.

Hi Alan,

Sorry, no - I have no memory and worked on these USB drivers
years ago. Forgot all details. Also my last sddr09 device broke
some time ago.

Looking at my old files I do not see the Vendor Id 0781, so maybe
this is a device I never encountered.
These old files also discuss some trickery with multi-lun devices
where the driver needed depends on the lun. This is not a reader
of multiple types of card?

Many of my SM readers worked with either sddr09 or sddr55.
Does the unusual devices section today say that such a device
needs sddr09?

Found a 2.6.31 source tree. Yes,

UNUSUAL_DEV(  0x0781, 0x0200, 0x0000, 0x9999,
                "Sandisk",
                "ImageMate SDDR-09",
                US_SC_SCSI, US_PR_EUSB_SDDR09, usb_stor_sddr09_init,
                0),

Is it known who added this? Is 0208 in the interval of known devices
for which sddr09 works?

Andries

