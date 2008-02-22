Return-Path: <linux-kernel-owner+w=401wt.eu-S1759128AbYBVSIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128AbYBVSIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 13:08:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbYBVSHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 13:07:52 -0500
Received: from mail.lang.hm ([64.81.33.126]:33357 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbYBVSHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 13:07:51 -0500
Date: Fri, 22 Feb 2008 11:23:48 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Mark Lord <lkml@rtr.ca>, Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       linux-acpi@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk.
 Screen becomes green.
In-Reply-To: <200802221844.31579.rjw@sisk.pl>
Message-ID: <alpine.DEB.1.00.0802221114350.17357@asgard.lang.hm>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802221802.18640.rjw@sisk.pl> <47BF071C.6040308@rtr.ca> <200802221844.31579.rjw@sisk.pl>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2008, Rafael J. Wysocki wrote:

> On Friday, 22 of February 2008, Mark Lord wrote:
>> Rafael J. Wysocki wrote:
>>> On Friday, 22 of February 2008, Mark Lord wrote:
>>>> david@lang.hm wrote:
>>>> ..
>>>>> I've been watching for kexec hibernate for a little while now, and the
>>>>> last I saw was that acpi was incompatible with the kexec hibernate (but
>>>>> the suspend folks were still claiming that devices needed to be put in
>>>>> the 'right mode' not just powered off. I've been waiting to see this
>>>>> resolved.
>>>> ..
>>>>
>>>> Yeah, exactly.  What's so special about poweroff on hibernation?
>>>> Why even bother with the special "S4" state there?
>>>
>>> (1) To be able to wake up with the help of devices that can't wake
>>>     the system up from S5 (power off)
>>> (2) To handle some platform devices appropriately over the cycle
>> ..
>>
>> That's the theory.  I've read about it, but have yet to imagine
>> any real-life situation where it applies.
>>
>> But this isn't my speciality, so.. do you have experience with any real examples?
>
> Yup.  The fan in my notebook behaves incorrectly after a resume from
> hibernation if S5 is entered instead of S4 during it.

so if you power off your laptop the fan doesn't work when you turn it back 
on?????

> I don't know why exactly it happens, but that's how it goes.
>
> Also, some machines are reported to behave incorrectly after a "shutdown"
> mode hibernation, while the same machines work just fine after a "platform"
> mode hibernation.  So at least for these machines it seems to matter.

given that we don't have a pure "shutdown" option available to try I don't 
see how this can be said to have been tested.

currently any attempts to do a shutdown type hibernate are tangled in the 
other code that is there for the suspend modes. this makes it _very_ hard 
to say that the hardware requires something as opposed to the strong 
possibility that the software is doing something wrong.

there are also a _lot_ of people who are not able to reliably use the 
existing "platform" mode hibernation, so it's not a fair statement to say 
that it's the 'right' thing to do. If you want to make it an option, fine. 
But please give those of us who don't care about these other wakeup 
options, and who want to be able to use other OS's while linux is stopped 
an option as well.

David Lang
