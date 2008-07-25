Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbYGYLsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbYGYLsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 07:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYGYLsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 07:48:16 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:33599 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbYGYLsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 07:48:15 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4889BD88.1050905@cam.ac.uk>
Date: Fri, 25 Jul 2008 12:48:24 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [patch 2.6.26] gpio: pcf857x handle pca9500 and pca9501
References: <4888A8E5.6050700@gmail.com> <200807241817.04624.david-b@pacbell.net>
In-Reply-To: <200807241817.04624.david-b@pacbell.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear David,
> On Thursday 24 July 2008, Jonathan Cameron wrote:
>   
>> These two chips have two elements (on different i2c addresses),
>> the first is a clone of the pcf8574 and the second 2kBit eeprom.
>>     
>
> That is, NXP documents say it's a pcf8582 eeprom, which
> is software-compatible with what Linux calls a 24c02 chip.
>
> It'd be worth sending a patch so drivers/i2c/chips/at24.c
> can handle those EEPROMs ...
>   
Thanks, hadn't realized that it was compatible with that driver.
Given the approach that seems to have been taken there, is it not
the case that the changes should all be in the board config anyway
to support a new chip? As the board config in question isn't going
to be in mainline for a while anyway (awaiting da9030 driver) this
means that no such patch would be needed.
>> Seems easiest to support these separately so main query about
>> this patch is should the device naming reflect this dual 
>> functionality. 
>>
>> I've been using the pcf857x driver with a 9500 for several
>> months without problems and just want this in to clean up
>> a confusing element in a board config. 
>>     
>
> Hmm, well I don't really see a way around having two entries
> in the relevant boards' i2c board info ... so this patch just
> ensures that *one* entry can list the actual part.
>   
Indeed, I was merely advocating listing the actual part number so that
the board config corresponds to the chips in front of the person using it.
Not exactly important though as a comment explaining what is going on
will do instead.
> I'm curious why you added this chp to the pcf857x driver
> rather than to the at24 driver ... since it's quite obvious
> from docs that the chip is pcf8574-compatible, but only the
> pca9500 lists the EEPROM compatibility.
>   
Sorry, simply wasn't aware that the at24 driver would work with it
and am currently running 2.6.26 meaning it wasn't actually there.
I'm cynical and tend to wait for a release candidate or two before
moving to a new kernel series!
> I guess given my druthers I'd update Kconfig for both drivers
> to mention these parts (and their need for two drivers), plus
> add them to the at24 driver (rather than pcf857x) purely because
> the docs are, overall, more clear about the GPIO compatibility
> than about the EEPROM.
>   
Makes a certain amount of sense but given that the at24 driver is quite
specific about the use of generic chip names, whereas the pcf857x is
listing devices would it not make more sense to add it there with help
text explaining that eeprom is supported by the at24 driver?

Pesky dual purpose chips get in the way of nice clean naming conventions!
>   
>> As the Kconfig title for these is getting a bit long and the
>> datasheet for these starts with stating they are pcf957x
>> compatible so I haven't changed it. 
>>     
>
> Right; helptext can have a sentence.
>   
Indeed.

Actually that's looking to be the only bit of the patch that will be needed.

--
Jonathan
