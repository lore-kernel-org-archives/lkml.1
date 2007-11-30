Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbXK3V0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbXK3V0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 16:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbXK3V0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 16:26:41 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41041 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752779AbXK3V0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 16:26:41 -0500
Date: Fri, 30 Nov 2007 22:27:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Lord <lkml@rtr.ca>
Cc: David Brownell <david-b@pacbell.net>, rtc-linux@googlegroups.com,
       kernel list <linux-kernel@vger.kernel.org>,
       Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: RTC wakealarm write-only, still has 644 permissions
Message-ID: <20071130212722.GB1634@elf.ucw.cz>
References: <20070920103225.GA4410@elf.ucw.cz> <200711291010.12707.david-b@pacbell.net> <20071130203544.GB1677@elf.ucw.cz> <200711301310.40360.david-b@pacbell.net> <47507EBA.6070801@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47507EBA.6070801@rtr.ca>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-11-30 16:20:58, Mark Lord wrote:
> David Brownell wrote:
>> On Friday 30 November 2007, Pavel Machek wrote:
>>>> It's not an issue of accidental writes, it's an issue of there being
>>>> no other synchronization for setting those alarms.  Remember that both
>>>> RTC_WKALM_SET and RTC_ALM_SET ioctls can set that same alarm, and so
>>>> could a different userspace activity ...
>>> We have 3 interfaces to one hardware resource. I do not think kernel
>>> should try to arbitrate it here. There's just one alarm clock with
>>> three interfaces.
>> Having three interfaces is bad enough ... ensuring that none of
>> them can ever be used safely would be stupid.
>>>> As written, this allows one userspace activity to clobber another if
>>>> it does so explicitly, by first disabling the other one and then
>>>> setting its own alarm.  But the idea is to minimize "accidents" like
>>>> unintentionally clobbering an alarm set by someone else.
>>> Well, I could not get it to work with this "avoid-clobber" feature.
>> I had earlier pointed out a different issue, whereby "oneshot"
>> semantics weren't consistently followed.  I've been working on
>> some patches to address that.  The ACPI bits still need work,
>> but I'll forward one part soonish.
>>>>> If I remove "accidental alarm modify" logic, I can actually use rtc to
>>>>> wake up more than once per boot.
>>>> Evidently the alarm isn't being disabled then...
>>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> That's the issue addressed by those patches.  (Specific to rtc-cmos,
>> not to RTCs on saner hardware.)
>>> I think we should just remove the 'avoid-clobber' logic. If userland
>>> wants to somehow arbitrate access, it can.
>> Pray tell, *HOW* could it arbitrate?
> ...
>
> This is really a non-issue in practice.  The thing requires root access,
> and there's only a single user at most for it on a given system.
>
> This is used by media boxes to power off (or suspend) between recording 
> times.
> And similar stuff.
>
> It might be nice to fix it all, but the current state really isn't hurting 
> anything.

Exactly. If you wanted arbitration, just create "rtcd", and make users
talk to it over sockets or something. Actually openmoko has neod,
which does that iirc.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
