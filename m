Return-Path: <linux-kernel-owner+w=401wt.eu-S1757673AbXGQEyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbXGQEyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 00:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbXGQEyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 00:54:40 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:55929
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbXGQEyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 00:54:39 -0400
Date: Mon, 16 Jul 2007 21:45:23 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Stern <stern@rowland.harvard.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
In-Reply-To: <Pine.LNX.4.44L0.0707161015490.3410-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.64.0707162137220.19248@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707161015490.3410-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007, Alan Stern wrote:

> On Sun, 15 Jul 2007 david@lang.hm wrote:
>
>> then we need a third mode of operation.
>>
>> mode 1: Suspend-to-ram
>>
>>    the system is paused and put into a low-power mode but data remains in
>> memory and the system stays awake enough to keep the memory refreshed.
>>
>> mode 2: new
>>
>>    the system is paused, data is stored to permanent media, and the system
>> is put into a ultra-low power mode.
>>
>> mode 3: hibernate
>>
>>    the system is paused, data is stored to permanent media, and the system
>> is powered off
>>
>> with mode 3 there are no requirements or limitations about what can be
>> done with the hardware before a resume (the resume could even take place
>> on a different piece of identical hardware)
>>
>> mode 2 could be what you are talking about doing, although I don't see any
>> advantage of creating it in additon to mode 3, it doesn't use any less
>> power and it locks the system so that it can't be used for anything else
>> in the meantime. I guess if it was significantly faster to do then mode 3
>> there may be _some_ reason to consider it, but I don't see the speed
>> difference.
>
> Part of the problem here is that ACPI already has its own terminology,
> and you're trying to invent a new one instead of using the existing
> one.
>
> I agree, it would be good to have a non-ACPI-specific hibernation mode,
> something which would look to ACPI like a normal shutdown.  But I'm not
> so sure this is possible.

why would it not be possible?

> You have to understand that the ACPI spec is weird and complex.  The
> mere fact that you have written a system image to disk changes the way
> ACPI regards the shutdown procedure.  Even though you may treat all the
> devices and the rest of the hardware exactly the same, it's a different
> operation as far as ACPI is concerned, with different requirements.
>
> Yes, it's bizarre.  Why do you think so many people have complained so
> vehemently about ACPI for all these years?

so let's act as if ACPI doesn't exist and make a suspend-to-disk that 
works without it and looks to ACPI like a complete power off/on cycle (but 
looks to the user like a suspend/resume cycle)

this should avoid all the headaches about ACPI completely becouse you just 
don't make any ACPI calls at all.

this will also work on any type of system, and it will work in the 
presence of dead batteries, failed components, booting other OS's, moveing 
the image to different hardware, etc.

I can't think of anything much more frustrating then thinking that I 
suspended a system and then discovering that becouse the battery went dead 
(a complete power loss) that the system wouldn't boot up properly. to me 
this would be a fairly common condition (when I'm mobile I use the machine 
until I am out of battery, then stop and it may be a long time (days) 
before I can charge the thing up again) this would not be a reliable 
suspend as far as I'm concerned.

for suspend-to-ram you have to worry about ACPI states and what you are 
doing with them, for suspend-to-disk you can ignore them and completely 
power the system off instead.

David Lang
