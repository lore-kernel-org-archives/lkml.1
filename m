Return-Path: <linux-kernel-owner+w=401wt.eu-S1752343AbXBDN4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbXBDN4L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 08:56:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbXBDN4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 08:56:11 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:51915 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbXBDN4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 08:56:10 -0500
X-Greylist: delayed 1615 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Feb 2007 08:56:09 EST
To: Greg KH <greg@kroah.com>
Cc: Andrew Lyon <andrew.lyon@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
References: <20070130012904.GA9617@kroah.com>
	<f4527be0701301215q11924e3fnaaa5f33e6b6c5b36@mail.gmail.com>
	<20070130203039.GA23370@kroah.com>
From: Christer Weinigel <christer@weinigel.se>
Organization: Weinigel Ingenjorsbyra AB
Date: 04 Feb 2007 14:29:13 +0100
In-Reply-To: <20070130203039.GA23370@kroah.com>
Message-ID: <m3y7neoxue.fsf@zoo.weinigel.se>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> Why would a userspace driver not work out for this.  We already can
> saturate the USB bus with a userspace program

That is unfortunately not quite true.  I have a (unfortunately
proprietary) driver for a USB device that simply cannot be implemented
in userspace.  The USB device is a measurement device that pushes
close to 800 kBytes/second of data through a FT245 chip.  The
measurement device does no flow control at all, it just presents a
sample every 125 us to the FT245 and with only 256 bytes of buffer in
the FT245 the only way to handle that is to have two URBs in flight at
the same time, and I haven't found any way to do that in a robust and
non-racey way from userspace.  So the comment "The USB subsystem has
changed a lot over time, and it has been possible to create userspace
USB drivers using usbfs/libusb/gadgetfs that operate as fast as the
USB bus allows." from feature-removal-schedule.txt is wrong I
think. :-(

Personally I'd much prefer to release the driver as open source, but
as a consultant you don't get to decide what the customer does.  So
now they sit there with a driver that warns them that it'll stop
working after february 2008.

On a different topic, my personal pet peeve is USB scanners.  There
seems to be just a handful of different manufacturers of chips used in
USB scanners: Realtek and Genesys covers 90% of the scanners.  The
SANE team has done a wonderful job of reverse engineering a lot of
scanners, but the models change so fast that there seems to be no
chance of keeping up.  If the chip manufacturers just released specs
for their chips and the scanner manufacturers could then document what
settings to use Linux could have support for almost all USB scanners
on the market, and it would probably cost them very little to do that.
If I could find a good (4800-9600 dpi) scanner which said "supported
by SANE" on the box I'd buy it immedately.

  /Christer

-- 
"Just how much can I get away with and still go to heaven?"

Christer Weinigel <christer@weinigel.se>  http://www.weinigel.se
