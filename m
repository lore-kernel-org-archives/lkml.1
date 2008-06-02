Return-Path: <linux-kernel-owner+w=401wt.eu-S1760804AbYFBNDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760804AbYFBNDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbYFBNDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:03:10 -0400
Received: from rtr.ca ([76.10.145.34]:3835 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391AbYFBNDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:03:09 -0400
Message-ID: <4843EF88.2040606@rtr.ca>
Date: Mon, 02 Jun 2008 09:03:04 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Theodore Tso <tytso@mit.edu>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci: power off unused ports
References: <20080508161008.59361de5@appleyard>	<20080527030854.GC7515@mit.edu>	<20080527143202.4bab5bf0@appleyard>	<20080527225926.GE6843@mit.edu>	<20080527163251.04054a74@appleyard>	<20080531080015.GG5405@ucw.cz>	<4842F5A8.9020708@garzik.org> <20080602080440.25fc663c@core> <4843A4A7.3020809@garzik.org>
In-Reply-To: <4843A4A7.3020809@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Alan Cox wrote:
>>> If you are talking about SATA -- incorrect.
>>>
>>> The patch deals with policy, and the user MUST have the ability to 
>>> control this stuff.  Otherwise you create a situation where the user 
>>> might be denied hotplug use in valid cases, or similar negative 
>>> situations.
>>
>> The policy isn't however complicated. Tejun added the stuff for forcing
>> cable type and mode on setup and has therefore written all the per device
>> setup code we might need. Alternatively a single
>>
>>     foo=1/0
>>
>> option has been fine for acpi and will do fine for this. Total additional
>> cost - 1 line.
> 
> The key requirement is per-port control.  Ideally via hdparm or another 
> userspace tool, but kernel command line (module options) or sysfs would 
> be just fine too.  And agreed, the minimal you need is simply 1/0 for 
> the port's policy.
..

Btw.. hdparm-8.7 (unreleased) can grok /sys now, so that interface is
as good as any from a userspace viewpoint now.

For the power-off of unused ports, the current patch still sounds
extremely vendor-specific (Intel).

Does it actually work (demonstrate, please) on any other hardware ?

I would still like to see a far more generic solution, with periodic polling
and the like, which would permit use on *any* machines (eg. data centers)
without loss of hotplug capability on those ports.

But that's probably just wishful thinking at this point.

Cheers
