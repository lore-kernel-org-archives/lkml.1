Return-Path: <linux-kernel-owner+w=401wt.eu-S1759195AbXEVV0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195AbXEVV0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 17:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758468AbXEVVZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 17:25:54 -0400
Received: from rtr.ca ([64.26.128.89]:3181 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757137AbXEVVZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 17:25:53 -0400
Message-ID: <46535FDD.3030801@rtr.ca>
Date: Tue, 22 May 2007 17:25:49 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>
Subject: Re: Race free attributes in sysfs
References: <46502A8B.70803@drzeus.cx>	 <3ae72650705211050p6b6cefbdya70dd4e0a27e2d1b@mail.gmail.com>	 <4651E866.5010304@drzeus.cx> <1179775695.3320.82.camel@lov.localdomain> <46530F02.7010802@drzeus.cx>
In-Reply-To: <46530F02.7010802@drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> Kay Sievers wrote:
>> We could change the driver-core to suppress the creation of an attribute
>> if the attribute's show() or store() method returns something like
>> -ENOENT at registration time?
>> The driver would pass _all_ possible attributes of the device at
>> registration time, but the core would only create the attributes which
>> are implemented for this particular device? Would that work for you?
>>   
> 
> Not sure. Not in an obvious way at least.
> 
> It also doesn't feel like "the kernel way". Generally you can
> create/allocate an object, assign attributes to it, then activate it.
> Couldn't it be done so that I can add sysfs stuff to a device after I
> just initialized it? (but before I add it).
> 
>> You can assign any number of attribute groups to the device. If they
>> don't have a group name, they will all be created directly at the device
>> level. Would that work for you?
>>
> I've had a look at sysfs groups and the biggest beef I have with those
> is that they're too low level. In order to use them I first need to
> create device attributes, then create an array of pointers to each attr
> member. It would be nice if I could just feed an array of device
> attributes (i.e. I want wrappers).

And how does this help to avoid the race condition?
Just curious.
