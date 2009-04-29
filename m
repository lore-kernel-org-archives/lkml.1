Return-Path: <linux-kernel-owner+w=401wt.eu-S1757739AbZD2Vyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739AbZD2Vyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 17:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757211AbZD2VyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 17:54:20 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:48544 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850AbZD2VyT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 17:54:19 -0400
MIME-Version: 1.0
In-Reply-To: <437908170904291428k445fc8fdy9b3bb4e78ee91018@mail.gmail.com>
References: <ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com> 
	<20090428173929.GA5006@sysman-doug.us.dell.com> <ac3eb2510904281046i6e9899acg89f7606da783f72c@mail.gmail.com> 
	<20090428215844.GA1396@sysman-doug.us.dell.com> <ac3eb2510904281842i785ee135h98502522f242f3f6@mail.gmail.com> 
	<437908170904282019h6a10ef9dg594002e22842b366@mail.gmail.com> 
	<ac3eb2510904290330r563f3717ue72029cbe24b39bb@mail.gmail.com> 
	<437908170904291000s10fe6a92q8a595e0bbbd159a6@mail.gmail.com> 
	<ac3eb2510904291210y6d0a4199gc1800d0d02d0d7c6@mail.gmail.com> 
	<437908170904291428k445fc8fdy9b3bb4e78ee91018@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 29 Apr 2009 23:53:58 +0200
Message-ID: <ac3eb2510904291453p4c4ec456u1efd7bc6bbf8f3be@mail.gmail.com>
Subject: Re: Class device namespaces
To: Michael Brown <mebrown@michaels-house.net>
Cc: Doug Warzecha <Douglas_Warzecha@dell.com>,
       Jean Delvare <khali@linux-fr.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Matt Domsch <Matt_Domsch@dell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 23:28, Michael Brown <mebrown@michaels-house.net> wrote:
> On Wed, Apr 29, 2009 at 2:10 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> Udev runs exactly at the time you create the device, and is not
>> unlikely faster than your polling, at least not predictable slower.
>> And it will cancel all requests which can not be fulfilled by udev
>> itself.
>>
>> I strongly recommend switching to a different solution, you can not
>> use the firmware_class interface on any udev system, the interface is
>> already taken, and it's a single-user interface the way it is
>> implemented today. That it seems to work for you, is pure luck, I
>> guess. :)
>
> Is there a safe/easy way to tell udev that we will handle a particular
> request?

No, not with the current interface.

> I cant say that I've ever seen any problems due to udev
> cancelling a firmware request.  In fact, if I manually trigger a
> request using "echo" from the cmdline, I dont see udev take any action
> with the dell_rbu device. eg (Fedora 10, udev-127-5.fc10):

If you run:
  udevmonitor --udev --env
at the same time, what does it say?

> I dont see any of the behaviour that you have talked about. If I let
> it sit there for hours, it will stay at that state. It only closes up
> the request_firmware() request when I echo 0 > loading.

Udev will run in the moment this sysfs device is created, and it
should trigger the removal of the device, if it does not find the
requested firmware file.

> At this point, we have had this interface in the upstream kernel.org
> kernel since 2.6.14 and have a pretty huge legacy codebase that relies
> on this behaviour. We need to make sure that the current behaviour
> remains.

If we are talking about the same thing, which I'm not really sure
anymore, then you can not be sure that this will work in the future.
You can not reliably take over requests for the firmware class with
custom tools while udev is running.

Kay
