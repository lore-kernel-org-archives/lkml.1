Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbZBBKLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbZBBKLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 05:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbZBBKLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 05:11:38 -0500
Received: from rv-out-0506.google.com ([209.85.198.226]:14042 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZBBKLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 05:11:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KFCxen/1cUsxeFHKPsvsk2bK8cc5hwltKWgaS3pS9hGKqnJS3gqSQkYr8i/B46Ae9c
         7aax9HE9hrozNPUqCpTfHStBQQvgBNLIVRrH4yLxOIVEYus2bL37aY8HGho9spNrgbZo
         OWUPeAlaGmWR8zE9BlTUX/dM4oZwzPknZKZXw=
MIME-Version: 1.0
In-Reply-To: <a8e1da0902011743o47764edfjf53a397b5a4aeeef@mail.gmail.com>
References: <49857F23.3090208@gmail.com> <20090201155117.GA10018@kroah.com>
	 <a8e1da0902011743o47764edfjf53a397b5a4aeeef@mail.gmail.com>
Date: Mon, 2 Feb 2009 18:11:36 +0800
Message-ID: <a8e1da0902020211p56ab93fnf459c591eec54b41@mail.gmail.com>
Subject: Re: [PATCH 1/2] usb-serial : fix the nousb oops
From: Dave Young <hidave.darkstar@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: wgreathouse@smva.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 2, 2009 at 9:43 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
> On Sun, Feb 1, 2009 at 11:51 PM, Greg KH <greg@kroah.com> wrote:
>> On Sun, Feb 01, 2009 at 06:53:23PM +0800, Dave Young wrote:
>>>
>>> In case with "nousb" booting, serial drivers will trigger kernel oops.
>>
>> They will?  What is the oops message?
>
> Yes, they will, at lease I saw usb_serial/aircable/ftdi_sio oops. I
> will manage to copy the oops message later.

I can not copy the oops message, so I just hand copy something here:

BUG: unable to handle kernel NULL pointer dereference at 00000001
IP: [<c0527636>] kset_find_obj+0x3b/0x5c
*pde = 00000000
Oops: 0000 [#1] SMP

[snip...]

EIP is at kset_find_obj+0x3b/0x5c
EAX:00000001

[snip...]

Call Trace:
driver_register
destruct_tty_driver
usb_serial_bus_register
usb_serial_register
aircable_init
_stext
aircable_init
restore_nocheck_notrace
pci_arch_init

[snip...]

Actually, after the usb_serial_init failed, the usb_serial_bus_type
will be unregistered.

So when  serial dirvers call usb_serial_register (then
usb_serial_bus_register, and then driver_register),  due to the bus
kset already unregistered kernel will oops.

>
>>
>>> Here add usb_disabled() check in usb_serial_init and usb_serial_register
>>
>> This is odd, is it something new?  Why is usb-serial the only driver
>> that needs such a thing?
>
> No, it is not new thing.  usb serial drivers normally call
> usb_serial_register first, then usb_register, usb_register will fail
> due to "nousb" checking, but usb_serial_register no.
>
>>
>> confused,
>>
>> greg k-h
>>
>
>
>
> --
> Regards
> dave
>



-- 
Regards
dave
