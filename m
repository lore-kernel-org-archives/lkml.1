Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbZHaGvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbZHaGvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 02:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbZHaGvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 02:51:11 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:38191 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523AbZHaGvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 02:51:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wh0sNivGy+po/Y8XEtfsnmaixmviAEzY2G10W+eGMwrAt5giZalUdWW64pQD+xS2ov
         AWRDImsq4WU5oRU0HXXsD77/r77OZSug5KqDEmMXlRbTbdBusAS2NdWRYC0sfDUAssVx
         fse2uWTI//DPcGxSTsbrteInm6hyVEZ1VJXCk=
MIME-Version: 1.0
In-Reply-To: <200908292302.34282.linux@rainbow-software.org>
References: <7eb6a4d80908230546tc246dbdq33ffadcdce9a605a@mail.gmail.com>
	 <200908292302.34282.linux@rainbow-software.org>
Date: Mon, 31 Aug 2009 08:51:10 +0200
Message-ID: <7eb6a4d80908302351if418c44v10d581d2859904d2@mail.gmail.com>
Subject: Re: New ark3116 driver - testers needed
From: Bart Hartgers <bart.hartgers@gmail.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-usb@vger.kernel.org, ark3116_driver@auctionant.de,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/29 Ondrej Zary <linux@rainbow-software.org>:
> On Sunday 23 August 2009 14:46:16 Bart Hartgers wrote:
>> Hi All,
>>
>> I managed to write an improved ark3116 driver after I figured out that
>> it is just an 16450 UART with some USB glue logic.
>>
>> Compared to the old ark3116 driver it offers the following improvements:
>> - cts/rts handshake support
>> - break signalling
>> - line error detection
>>
>> Since it is a big step from the previous driver, it made little sense
>> to modify that one, so I created new driver, named ark316new. Also
>> this means that both could coexist if the new one doesn't work for
>> someone.
>>
>> I have no datasheet, so the driver is entirely based on reverse
>> engineering, and some testing by others would be a good idea.
>>
>> I also tried to include the IrDA fixes for the old ark3116.c driver
>> that were posted on this list recently, but I could not test if
>> these work, since I don't have the proper hardware.
>>
>> Because of this, I would appreciate reports of both success and
>> failure in using this driver.
>
> Tested the driver today with that Gembird UIR-22.
>
> It did not compile neither in 2.6.30.1 nor in 2.6.31-rc8 with the following
> error:
>
> ark3116new.c:790: error: unknown field shutdown specified in initializer
> ark3116new/ark3116new.c:790: warning: initialization from incompatible pointer
> type
>
> Commenting that line produced a module that worked:
> usb 1-1: new full speed USB device using uhci_hcd and address 2
> usb 1-1: configuration #0 chosen from 1 choice
> usb 1-1: config 0 descriptor??
> usbcore: registered new interface driver usbserial
> usbserial: USB Serial Driver core
> USB Serial support registered for ARK3116 RS232/IrDA
> ark3116new 1-1:0.0: ARK3116 RS232/IrDA converter detected
> usb 1-1: ark3116new using IrDA mode
> usb 1-1: ARK3116 RS232/IrDA converter now attached to ttyUSB0
> usbcore: registered new interface driver ark3116new
> ark3116new:v0.1:USB ARK3116 serial/IrDA driver
> usb 1-1: ark3116new don't know how to do software flow control
> NET: Registered protocol family 23
>
> Ran "irattach /dev/ttyUSB0 -s" and then "obexftp -i -l" to list files on Nokia
> 6230i. It worked fine and file transfer too. So the IrDA mode works.
>
> When I unplugged the device, irattach remained running and some error message
> was written to console every few seconds (sorry, I haven't recorded it).
> Killing irattach then resulted in oops. But this might be expected as the
> shutdown function was commented out.
>
Hi Ondrej,

Thanks for testing this!

I later discovered that there is a change with respect to
shutdown-functionality between 2.6.28 (on which I made the driver) and
2.6.31. I have to update the driver to 2.6.current anyway.

> I think that this driver should replace current ark3116 driver. Having two
> drivers for the same hardware is a bad thing.

I agree. However, given the experimental nature of the driver, I would
prefer some more testing. Then again, the original driver is lacks
some features, and making ark3116new default would increase its
exposure ;-).

Groeten,
Bart

>
> --
> Ondrej Zary
>



-- 
Bart Hartgers - New e-mail: bart.hartgers@gmail.com
