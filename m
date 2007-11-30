Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbXK3VVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbXK3VVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 16:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752405AbXK3VVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 16:21:00 -0500
Received: from rtr.ca ([76.10.145.34]:1609 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbXK3VVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 16:21:00 -0500
Message-ID: <47507EBA.6070801@rtr.ca>
Date: Fri, 30 Nov 2007 16:20:58 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
Cc: Pavel Machek <pavel@ucw.cz>, rtc-linux@googlegroups.com,
       kernel list <linux-kernel@vger.kernel.org>,
       Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: RTC wakealarm write-only, still has 644 permissions
References: <20070920103225.GA4410@elf.ucw.cz> <200711291010.12707.david-b@pacbell.net> <20071130203544.GB1677@elf.ucw.cz> <200711301310.40360.david-b@pacbell.net>
In-Reply-To: <200711301310.40360.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Friday 30 November 2007, Pavel Machek wrote:
>>> It's not an issue of accidental writes, it's an issue of there being
>>> no other synchronization for setting those alarms.  Remember that both
>>> RTC_WKALM_SET and RTC_ALM_SET ioctls can set that same alarm, and so
>>> could a different userspace activity ...
>> We have 3 interfaces to one hardware resource. I do not think kernel
>> should try to arbitrate it here. There's just one alarm clock with
>> three interfaces.
> 
> Having three interfaces is bad enough ... ensuring that none of
> them can ever be used safely would be stupid.
> 
> 
>>> As written, this allows one userspace activity to clobber another if
>>> it does so explicitly, by first disabling the other one and then
>>> setting its own alarm.  But the idea is to minimize "accidents" like
>>> unintentionally clobbering an alarm set by someone else.
>> Well, I could not get it to work with this "avoid-clobber" feature.
> 
> I had earlier pointed out a different issue, whereby "oneshot"
> semantics weren't consistently followed.  I've been working on
> some patches to address that.  The ACPI bits still need work,
> but I'll forward one part soonish.
> 
> 
>>>> If I remove "accidental alarm modify" logic, I can actually use rtc to
>>>> wake up more than once per boot.
>>> Evidently the alarm isn't being disabled then...
> 
>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> That's the issue addressed by those patches.  (Specific to rtc-cmos,
> not to RTCs on saner hardware.)
> 
> 
>> I think we should just remove the 'avoid-clobber' logic. If userland
>> wants to somehow arbitrate access, it can.
> 
> Pray tell, *HOW* could it arbitrate?
...

This is really a non-issue in practice.  The thing requires root access,
and there's only a single user at most for it on a given system.

This is used by media boxes to power off (or suspend) between recording times.
And similar stuff.

It might be nice to fix it all, but the current state really isn't hurting anything.

Cheers
