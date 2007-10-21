Return-Path: <linux-kernel-owner+w=401wt.eu-S1752369AbXJUJUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbXJUJUx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 05:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbXJUJUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 05:20:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:60824 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbXJUJUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 05:20:42 -0400
Date: Sun, 21 Oct 2007 11:20:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: rt2400-devel@lists.sourceforge.net,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, mwallis@serialmonkey.com
Subject: Re: [Rt2400-devel] rt73usb: support for wireless in Kohjinsha
	subnotebook
Message-ID: <20071021092048.GA25270@elf.ucw.cz>
References: <20071020184100.GA11640@elf.ucw.cz> <200710210012.37547.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710210012.37547.IvDoorn@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I did this on 2.6.23-rc8-mm1 kernel (The RT hack may not be
> > neccessary), but then it oopses somewhere in softmac layer. I'll try
> > to play with it some more.
> > 
> > If you have any ideas, let me know.
> > 								Pavel
> > 
> > --- clean-mm/drivers/net/wireless/rt2x00/rt73usb.c	2007-10-09 09:32:08.000000000 +0200
> > +++ linux-mm/drivers/net/wireless/rt2x00/rt73usb.c	2007-10-19 22:19:45.000000000 +0200
> > @@ -1580,7 +1580,6 @@
> >  
> >  	if (!rt2x00_rev(&rt2x00dev->chip, 0x25730)) {
> >  		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
> > -		return -ENODEV;
> >  	}
> >  
> >  	if (!rt2x00_rf(&rt2x00dev->chip, RF5226) &&
> > @@ -1588,7 +1587,6 @@
> >  	    !rt2x00_rf(&rt2x00dev->chip, RF5225) &&
> >  	    !rt2x00_rf(&rt2x00dev->chip, RF2527)) {
> >  		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
> > -		return -ENODEV;
> >  	}
> 
> Both removals of -ENODEV are completely wrong. If the device does not pass the above
> 2 checks it is _not_ a rt73usb device. And forcing the driver to work with the device will
> result in all kinds of problems.

Of course they are :-).

> If rt2x00 is loaded and detected the device, it should print out a debug message that starts with:
> "Chipset detected - " What is in your case the complete line?

Ok, I guess I should include more complete debug output.

phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x09 failed for offset 0x0000 with error -32
phy0 -> rt73usb_validate_eeprom: EEPROM recover - MAC: 66:76:2b:e8:68:e7
phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x3000 with error -32
phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 1300, rf: 0000, rev: c03c0ae0
phy0 -> rt73usb_init_eeprom: Error - Invalid RF chipset detected

...so, I think hardware is indeed quite similar to what rt73usb driver
expects...?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
