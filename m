Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbZALMO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbZALMO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbZALMOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:14:49 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:43256 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbZALMOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:14:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cDYUa/X7K5HHaHMso5v5hdMqsuZYJD2owzPgvnF2klNXCcH7aRfbkIHdmCyDhPmk0k
         5kI7ErLL4stvb+LRxG5vncjERXQzE3BVkJrsG0in4ji/JJ8ux0MNnMKzhtpUfu5NAo8J
         Bm1AjckdM1+CB7taFHvygCNlA7T4ACzYxKBG8=
Message-ID: <c4e36d110901120414q22d76501r10d643efeea8c65c@mail.gmail.com>
Date: Mon, 12 Jan 2009 13:14:45 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.29-rc1 does not resume on Lenove T61
Cc: "Maciej Rutecki" <maciej.rutecki@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
In-Reply-To: <200901120903.20371.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com>
	 <8db1092f0901111215m5712caccvc0d2e5e7cb7e8f7@mail.gmail.com>
	 <c4e36d110901111459p6d02892fwce0d89c52e62385e@mail.gmail.com>
	 <200901120903.20371.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/12 Rafael J. Wysocki <rjw@sisk.pl>:
> On Sunday 11 January 2009, Zdenek Kabelac wrote:
>> 2009/1/11 Maciej Rutecki <maciej.rutecki@gmail.com>:
>> > 2009/1/11 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
>> >> Hi
>> >>
>> >> I've booted and tested 2.6.29-rc1 (c59765042f53a79a7a65585042ff463b69cb248c)
>> >>
>> >> I've observed that suspend is unusable - it goes to sleep - the sleep
>> >> LED is on. After few secs system turns on back itself - and stays in
>> >> some frozen state
>> >
>> > A have similar situation, one difference: I get blank screen during
>> > resume from suspend to ram. Also sometimes, like You, system turns on
>> > back itself.
>> >
>>
>> So it looks like reverting this commit:
>>
>> http://marc.info/?l=linux-kernel&m=123140019117968&w=4
>> (6fd9086a518d4f14213a32fe6c9ac17fabebbc1e)
>> (which is already a tracked regression)
>> fixes the problem with auto-resume
>>
>> But the problem with deadlock in the resume phase is still there.
>
> Please check if unloading all of the USB controller modules before suspend
> helps.

I've booted to single mode without   usbcore module (thus any load of
other usb modules fails)
(removed from initramdisk as well)

This time the resume stops with these 3 lines (I'm using
no_console_suspend kernel option):

....
thinkpad_acpi  thinkpad_acpi: EARLY resume
thinkpad_hwmon  thinkpad_hwmon: EARLY resume
Enabling non-boot CPUs...

And after this it stays in deadlock -  LED for sleep is still being on

Zdenek
