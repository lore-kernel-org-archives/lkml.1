Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbZAVCbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbZAVCbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 21:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbZAVCbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 21:31:23 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:14410 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307AbZAVCbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 21:31:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XO2TYTELDAzm+Vkie2YT64ZsW/1VzIBskx6wkfKhcldXmwM3qGCp4yj/Bht+0yexZf
         /UseDwsadDcpcufuaJGSw0Wx84GFQW/551FD3BbVWHIMLTG/VcPeV8FFNX9utlxksUsc
         1lktHtsQuynMkdo4gikNSnlnxPBX0HMZvTBJk=
MIME-Version: 1.0
In-Reply-To: <20090121162345.GB22615@kroah.com>
References: <497638FF.8050805@msgid.tls.msk.ru>
	 <20090120210254.GA5609@kroah.com>
	 <d82e647a0901210744t1655bacesf23bcd54e30002e9@mail.gmail.com>
	 <20090121162345.GB22615@kroah.com>
Date: Thu, 22 Jan 2009 10:31:19 +0800
Message-ID: <d82e647a0901211831k214f730aj4e8fb92cbb6ef43@mail.gmail.com>
Subject: Re: "permanently" unbind a device from a driver?
From: Ming Lei <tom.leiming@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       Linux USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/22 Greg KH <greg@kroah.com>:
> On Wed, Jan 21, 2009 at 11:44:03PM +0800, Ming Lei wrote:
>> 2009/1/21 Greg KH <greg@kroah.com>:
>> > On Tue, Jan 20, 2009 at 11:50:07PM +0300, Michael Tokarev wrote:
>> >> Is there a way to stop a module from claiming a
>> >> given device no matter how/when it gets plugged?
>> >>
>> >> For example, there's a series of power supplies
>> >> (UPSes) with USB connection (common nowadays)
>> >> which, by default, gets claimed by usbhid module.
>> >> But it does not work as a HID device, instead it
>> >> uses a serial line logic and has a USB<=>serial
>> >> converter inside, which works just fine with
>> >> cypress_m8 usbserial driver.
>> >>
>> >> usbhid module is loaded on startup (to handle
>> >> usb keyboards/mouses), and it claims this device
>> >> too.  Using /sys/bus/.../drivers/usbhid/unbind
>> >> releases it, after which cypress_m8 works as
>> >> expected.  But after re-plugging it gets claimed
>> >> by usbhid again.
>> >
>> > Just add a blacklist rule to the usbhid driver for this device.  There
>> > are a number of devices out there that need this functionality, which is
>> > why there is such a list.
>>
>> Is it possible to implement a generic blacklist mechanism in driver core
>> to support the function for all kinds of drivers? or is it necessary to do that?
>
> It's not necessary as the hid core already supports this very thing due
> to the need for it (it's the easiest way to write a userspace Windows
> driver, so lots of manufacturers lie about their devices in order to
> work around having to write a Windows kernel driver.)
>
> So just add this device to the hid core blacklist, and you are all set.

Yes.

>
> Care to send a patch?

Each low level subsystem(pci/usb/...) has its own
device id format and binding way, so it is impossible
to implement a generic blacklist mechanism in driver core.

It is even difficult to do the blacklist in low level
subsystem of usb. Quirk tables in drivers of  high level
subsystem(hid/bt/...) contain information specific to
the high level subsystem,some of which is used to
ignore the device by driver, some of which is used to
do some fixes to support the device.

Maybe we can provide a blacklist mechanism in usb subsystem
to ignore some broken device for driver,but it can not replace the
existing quirks in drivers of high level subsystem.


>
> thanks,
>
> greg k-h
>



-- 
Lei Ming
