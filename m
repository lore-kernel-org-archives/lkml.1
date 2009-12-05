Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbZLEVe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbZLEVe0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 16:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756641AbZLEVeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 16:34:22 -0500
Received: from netrider.rowland.org ([192.131.102.5]:50767 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756627AbZLEVeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 16:34:21 -0500
Date: Sat, 5 Dec 2009 16:34:26 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Ed Tomlinson <edt@aei.ca>, "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [BUG] 2.6.32 - Sddr-09 SM reader resets endlessly
In-Reply-To: <20091205200606.GA23243@mette>
Message-ID: <Pine.LNX.4.44L0.0912051623020.18442-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Dec 2009, Andries E. Brouwer wrote:

> > Andries, do you have any idea what's going on?  Evidently this device 
> > doesn't accept the protocol used by the sddr09 driver.
> 
> Hi Alan,
> 
> Sorry, no - I have no memory and worked on these USB drivers
> years ago. Forgot all details. Also my last sddr09 device broke
> some time ago.
> 
> Looking at my old files I do not see the Vendor Id 0781, so maybe
> this is a device I never encountered.
> These old files also discuss some trickery with multi-lun devices
> where the driver needed depends on the lun. This is not a reader
> of multiple types of card?
> 
> Many of my SM readers worked with either sddr09 or sddr55.
> Does the unusual devices section today say that such a device
> needs sddr09?
> 
> Found a 2.6.31 source tree. Yes,
> 
> UNUSUAL_DEV(  0x0781, 0x0200, 0x0000, 0x9999,
>                 "Sandisk",
>                 "ImageMate SDDR-09",
>                 US_SC_SCSI, US_PR_EUSB_SDDR09, usb_stor_sddr09_init,
>                 0),
> 
> Is it known who added this? Is 0208 in the interval of known devices
> for which sddr09 works?

The entry was added before 2.5.0 (more than 7 years ago), and I can't 
tell who added it.  And the entry doesn't say anything about DPCM 
(multiple-LUN trickery).

Ed, it looks like you're out of luck.  Unless you can figure out the 
vendor-specific protocol used by that device, and modify the sddr09 
driver to support it, you won't be able to use the device under Linux.

Or am I completely off base?  Did it used to work with an earlier
kernel?  If it did, can you get a usbmon trace of it?

Alan Stern

