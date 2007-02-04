Return-Path: <linux-kernel-owner+w=401wt.eu-S1752467AbXBDSUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbXBDSUT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 13:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbXBDSUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 13:20:19 -0500
Received: from cantor.suse.de ([195.135.220.2]:51822 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467AbXBDSUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 13:20:17 -0500
Date: Sun, 4 Feb 2007 10:19:12 -0800
From: Greg KH <greg@kroah.com>
To: Christer Weinigel <christer@weinigel.se>
Cc: Andrew Lyon <andrew.lyon@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070204181912.GA12379@kroah.com>
References: <20070130012904.GA9617@kroah.com> <f4527be0701301215q11924e3fnaaa5f33e6b6c5b36@mail.gmail.com> <20070130203039.GA23370@kroah.com> <m3y7neoxue.fsf@zoo.weinigel.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3y7neoxue.fsf@zoo.weinigel.se>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 04, 2007 at 02:29:13PM +0100, Christer Weinigel wrote:
> Greg KH <greg@kroah.com> writes:
> 
> > Why would a userspace driver not work out for this.  We already can
> > saturate the USB bus with a userspace program
> 
> That is unfortunately not quite true.  I have a (unfortunately
> proprietary) driver for a USB device that simply cannot be implemented
> in userspace.  The USB device is a measurement device that pushes
> close to 800 kBytes/second of data through a FT245 chip.  The
> measurement device does no flow control at all, it just presents a
> sample every 125 us to the FT245 and with only 256 bytes of buffer in
> the FT245 the only way to handle that is to have two URBs in flight at
> the same time, and I haven't found any way to do that in a robust and
> non-racey way from userspace.

People do that today just fine with multiple userspace urbs in flight
using usbfs directly.  So it is possible and can be done.

If there are issues with the usbfs code to prevent you from doing this,
please let us know.

Or perhaps your device just needs to add some flow control to it :)

good luck,

greg k-h
