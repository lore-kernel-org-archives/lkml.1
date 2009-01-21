Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbZAUVYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbZAUVYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 16:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbZAUVYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 16:24:24 -0500
Received: from hobbit.corpit.ru ([81.13.33.150]:21326 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbZAUVYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 16:24:23 -0500
Message-ID: <49779284.50603@msgid.tls.msk.ru>
Date: Thu, 22 Jan 2009 00:24:20 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Sam Liddicott <sam@liddicott.com>, Ming Lei <tom.leiming@gmail.com>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       Linux USB list <linux-usb@vger.kernel.org>
Subject: Re: "permanently" unbind a device from a driver?
References: <497638FF.8050805@msgid.tls.msk.ru> <20090120210254.GA5609@kroah.com> <d82e647a0901210744t1655bacesf23bcd54e30002e9@mail.gmail.com> <20090121162345.GB22615@kroah.com> <4977596D.409@liddicott.com> <20090121181124.GA17410@kroah.com>
In-Reply-To: <20090121181124.GA17410@kroah.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Jan 21, 2009 at 05:20:45PM -0000, Sam Liddicott wrote:
>> * Greg KH wrote, On 21/01/09 16:23:
>>> On Wed, Jan 21, 2009 at 11:44:03PM +0800, Ming Lei wrote:
>>>   
>>>> 2009/1/21 Greg KH <greg@kroah.com>:
>>>>     
>>>>> Just add a blacklist rule to the usbhid driver for this device.  There
>>>>> are a number of devices out there that need this functionality, which is
>>>>> why there is such a list.
>>>>>       
>>>> Is it possible to implement a generic blacklist mechanism in driver core
>>>> to support the function for all kinds of drivers? or is it necessary to do that?
>>>>     
>>> It's not necessary as the hid core already supports this very thing due
>>> to the need for it (it's the easiest way to write a userspace Windows
>>> driver, so lots of manufacturers lie about their devices in order to
>>> work around having to write a Windows kernel driver.)
>>>
>>> So just add this device to the hid core blacklist, and you are all set.
>>>
>>> Care to send a patch?

Ok, I'm looking at this now, but have a question:
which quirk code(s)/bits should I use for that?
Assuming the table in question is in
 drivers/hid/usbhid/hid-quirks.c
file.
What's needed is to stop usbhid module from claiming this device in the
first place.

>> I've often felt that a /proc or /sys interface to allow blacklist
>> additions or quirk addition would be great.
> 
> Some subsystems support this, like the HID subsystem :)

Oh, I didn't know.  In fact, that's exactly what I was asking in my
first email in this thread - to have some module parameter or a sysfs
file which can be touched to stop the module from claiming the device.
This also helps to debug it, to know the right bits to use.. which I
don't know...  ;)

The device in question which I'm dealing with is an UPS by Powercom,
Imperial series (they sold other series with UPS support too, namely
some KING PRO ones, which has exactly the same "interface").  It's

 Bus 001 Device 002: ID 0d9f:0002 Powercom Co., Ltd  Serial to USB adaptor

and this vendor:device is known to cypress_m8 driver, in
drivers/usb/serial/cypress_m8.[ch]:

 /* Powercom UPS, chip CY7C63723 */
 #define VENDOR_ID_POWERCOM               0x0d9f
 #define PRODUCT_ID_UPS                   0x0002

So here we go - I only need to know which quirk to use ;)

What I do *not* know is if there are other UPS model from the same
vendor with the same product ID but which really ARE HID devices.
But having in mind amount of questions asked about this very device,
all with the same answer (before it was "use this custom binary kernel
module", since 2.6.25 it's "use cypress_m8 driver"), i think it does
not matter anymore... ;)

Thanks!

/mjt
