Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbZAUPoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbZAUPoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 10:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZAUPoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 10:44:07 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:37550 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbZAUPoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 10:44:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tcpUOhY7kNNudylzGotD1dSpc/0/MuDE1Zq7BCspGHXMnFS0LPP2wwot2fzASnv6Sr
         a273F9HSSKGSONBWq6z2hvWhh06TOH9r29fi1BXMWGK8kU9N4DlzgyoC4OEDpqTjtf4J
         1ogKD9aR/p7hYvc0DOt41m/iNmvGlsX7K6RM0=
MIME-Version: 1.0
In-Reply-To: <20090120210254.GA5609@kroah.com>
References: <497638FF.8050805@msgid.tls.msk.ru>
	 <20090120210254.GA5609@kroah.com>
Date: Wed, 21 Jan 2009 23:44:03 +0800
Message-ID: <d82e647a0901210744t1655bacesf23bcd54e30002e9@mail.gmail.com>
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

2009/1/21 Greg KH <greg@kroah.com>:
> On Tue, Jan 20, 2009 at 11:50:07PM +0300, Michael Tokarev wrote:
>> Is there a way to stop a module from claiming a
>> given device no matter how/when it gets plugged?
>>
>> For example, there's a series of power supplies
>> (UPSes) with USB connection (common nowadays)
>> which, by default, gets claimed by usbhid module.
>> But it does not work as a HID device, instead it
>> uses a serial line logic and has a USB<=>serial
>> converter inside, which works just fine with
>> cypress_m8 usbserial driver.
>>
>> usbhid module is loaded on startup (to handle
>> usb keyboards/mouses), and it claims this device
>> too.  Using /sys/bus/.../drivers/usbhid/unbind
>> releases it, after which cypress_m8 works as
>> expected.  But after re-plugging it gets claimed
>> by usbhid again.
>
> Just add a blacklist rule to the usbhid driver for this device.  There
> are a number of devices out there that need this functionality, which is
> why there is such a list.

Is it possible to implement a generic blacklist mechanism in driver core
to support the function for all kinds of drivers? or is it necessary to do that?

Thanks!

>
>> I understand that it's easy to write an udev rule
>> (I don't use udev but that's another story) to
>> unbind the device from the driver and bind it to
>> another driver automatically.  That's basically
>> what I have for now (handling hidraw* device).
>> But that seems somewhat... ugly, at best.
>>
>> The question is: is it possible to tell usbhid
>> to STOP claiming devices with given vendor:device
>> identifier, from now on?
>>
>> I also understand that to do it permanently the
>> given vendor:device has to be blacklisted in the
>> driver source.  But I don't think it's worth the
>> effort.
>
> Why wouldn't it be worth the effort?  It's obviously a problem.
>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Lei Ming
