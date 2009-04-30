Return-Path: <linux-kernel-owner+w=401wt.eu-S1763539AbZD3Qeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763539AbZD3Qeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 12:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbZD3Qe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 12:34:28 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:20414 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbZD3Qe1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 12:34:27 -0400
MIME-Version: 1.0
In-Reply-To: <1241104684.26576.4.camel@lap75545.ornl.gov>
References: <ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com> 
	<20090428215844.GA1396@sysman-doug.us.dell.com> <ac3eb2510904281842i785ee135h98502522f242f3f6@mail.gmail.com> 
	<437908170904282019h6a10ef9dg594002e22842b366@mail.gmail.com> 
	<ac3eb2510904290330r563f3717ue72029cbe24b39bb@mail.gmail.com> 
	<437908170904291000s10fe6a92q8a595e0bbbd159a6@mail.gmail.com> 
	<ac3eb2510904291210y6d0a4199gc1800d0d02d0d7c6@mail.gmail.com> 
	<437908170904291428k445fc8fdy9b3bb4e78ee91018@mail.gmail.com> 
	<ac3eb2510904291453p4c4ec456u1efd7bc6bbf8f3be@mail.gmail.com> 
	<1241104684.26576.4.camel@lap75545.ornl.gov>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 30 Apr 2009 18:34:06 +0200
Message-ID: <ac3eb2510904300934q4c36d6bdma9e610bfc0acb7bd@mail.gmail.com>
Subject: Re: Class device namespaces
To: David Dillow <dave@thedillows.org>
Cc: Michael Brown <mebrown@michaels-house.net>,
       Doug Warzecha <Douglas_Warzecha@dell.com>,
       Jean Delvare <khali@linux-fr.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Matt Domsch <Matt_Domsch@dell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 17:18, David Dillow <dave@thedillows.org> wrote:
> On Wed, 2009-04-29 at 23:53 +0200, Kay Sievers wrote:
>> On Wed, Apr 29, 2009 at 23:28, Michael Brown <mebrown@michaels-house.net> wrote:
>> > I cant say that I've ever seen any problems due to udev
>> > cancelling a firmware request.  In fact, if I manually trigger a
>> > request using "echo" from the cmdline, I dont see udev take any action
>> > with the dell_rbu device. eg (Fedora 10, udev-127-5.fc10):
>>
>> If you run:
>>   udevmonitor --udev --env
>> at the same time, what does it say?
>>
>> > I dont see any of the behaviour that you have talked about. If I let
>> > it sit there for hours, it will stay at that state. It only closes up
>> > the request_firmware() request when I echo 0 > loading.
>>
>> Udev will run in the moment this sysfs device is created, and it
>> should trigger the removal of the device, if it does not find the
>> requested firmware file.
>
> drivers/firmware/dell_rbu.c does this:
> req_firm_rc = request_firmware_nowait(THIS_MODULE,
>                                FW_ACTION_NOHOTPLUG, "dell_rbu",
>                                &rbu_device->dev, &context,
>                                callbackfn_rbu);
>
> I've not gone looking to verify, but FW_ACTION_NOHOTPLUG implies to me
> that udev never sees a uevent for it.

Ah, I see. Pretty weird idea to do that with polling, should be better
some key that tells udev to ignore the event, and you could listen to
the events yourself, instead of checking for them in sysfs at a
specific path and fixed name. But looks fine:
  if (uevent)
    dev_set_uevent_suppress(f_dev, 0);

Thanks,
Kay
