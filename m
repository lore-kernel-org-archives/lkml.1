Return-Path: <linux-kernel-owner+w=401wt.eu-S1763573AbXEVVY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763573AbXEVVY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 17:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757054AbXEVVYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 17:24:20 -0400
Received: from rtr.ca ([64.26.128.89]:4460 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756030AbXEVVYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 17:24:20 -0400
Message-ID: <46535F7F.1040504@rtr.ca>
Date: Tue, 22 May 2007 17:24:15 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Race free attributes in sysfs
References: <46502A8B.70803@drzeus.cx> <200705202312.19191.dtor@insightbb.com>
In-Reply-To: <200705202312.19191.dtor@insightbb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Sunday 20 May 2007 07:01, Pierre Ossman wrote:
>> Hi Greg,
>>
>> I'm reworking the sysfs stuff in the MMC layer to be a bit more flexible, but
>> there is one thing that has me baffled; how do you add attributes to an object
>> in a race free manner when you have a dynamic set of attributes.
>>
>> I've looked at other parts of the kernel and they all use:
>>
>> 1. Add object.
>> 2. Add attributes.
>>
>> To me, it seems like there's a window between 1 and 2 where the object is in
>> /sys but doesn't have the proper attributes. Life for user space gets very
>> annoying if it has to add artificial delays to avoid this window.
>>
>> So how do I do this properly? Something like this would, from my point of view,
>> be the sane method:
>>
>> 1. Add hidden object.
>> 2. Add attributes.
>> 3. Show object.
>>
> 
> 1. dev->uevent_suppress = 1;
> 2. device_register(dev);
> 3. device_create_file(dev, ...);
> 4. dev->uevent_suppress = 0;
> 5. kobject_uevent(&dev->kobj, KOBJ_ADD);

I don't see how that prevents an already-running udevd
from seeing the partially filled in /sys/ entry,
if it were.. say.. already doing a /sys scan,
or even just during initial startup.

