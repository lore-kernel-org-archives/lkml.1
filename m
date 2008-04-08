Return-Path: <linux-kernel-owner+w=401wt.eu-S1752419AbYDHPfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbYDHPfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 11:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYDHPfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 11:35:08 -0400
Received: from rtr.ca ([76.10.145.34]:1905 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbYDHPfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:35:07 -0400
Message-ID: <47FB90A8.3050604@rtr.ca>
Date: Tue, 08 Apr 2008 11:35:04 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, david-b@pacbell.net,
       oliver@neukum.org, Alan Stern <stern@rowland.harvard.edu>,
       Dave Airlie <airlied@linux.ie>, Jesse Barnes <jesse.barnes@intel.com>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.25-rc7/8: Another resume regression
References: <200803220259.48534.rjw@sisk.pl> <200804071251.03147.rjw@sisk.pl> <47FA430A.2030908@rtr.ca> <200804071940.28738.rjw@sisk.pl>
In-Reply-To: <200804071940.28738.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Monday, 7 of April 2008, Mark Lord wrote:
>> Rafael J. Wysocki wrote:
>>> On Saturday, 5 of April 2008, Mark Lord wrote:
>>>> Mark Lord wrote:
>>>>> Hi,
>>>>>
>>>>> Okay, USB now works fine on resume after fixing the iaa_watchdog issue.
>>>>>
>>>>> But twice now, once before that fix, and again just a minute ago,
>>>>> my machine has failed completely to resume after suspend-to-RAM.
>>>>>
>>>>> Again, resume here is 100% reliable in 2.6.24 and earlier.
>>>>>
>>>>> Symptoms: the usual:
>>>>>
>>>>>  -- 2.6.25-rc8 (and -rc7 earlier), plus USB fix.
>>>>>  -- not reproduceable on demand.
>>>>>  -- black screen of death -- no backlight, no kernel messages.
>>>>>  -- no hard drive activity.
>>>>>  -- no alt-sysrq-anything.
>>>>>  -- 5 second hold of the power button to poweroff and then recover.
>>>>>
>>>>> Not much info to go on, but it's worth knowing there's an issue here 
>>>>> somewhere.
>>>> ..
>>>>
>>>> Mmmm... Now that 2.6.25-rc* is usable here, there's another symptom
>>>> that's been happening regularly enough that it's got to be a regression
>>>> of some sort.
>>>>
>>>> This machine has an ATI X1400 video card, which doesn't work with any
>>>> open source X server that I know of.  Maybe latest RadeonHD would work
>>>> but it didn't when I tried it in January.
>>>>
>>>> So I'm using the ATI binary fglrx X server, but without their kernel module,
>>>> so no 3D acceleration (fine.. only affects Google Earth, really).
>>>>
>>>> Now.. on 2.6.25, after a suspend/resume cycle (or three), the framebuffer
>>>> frequently starts going wonky.  "snowy" pixels appear, and stay.
>>>> Just a moment ago here, the entire background changed to zebra stripes.
>>>>
>>>> And so on..  Peculiar stuff.
>>>>
>>>> I'm wondering if something to do with video mode switching,
>>>> or video register save/restore, has changed since 2.6.24.
>>>> Because it's broken in 2.6.25, yet works fine in all earlier kernels.
>>> Yes, that's probably related.
>>>
>>> However, I'm unable to reproduce the breakage.  If you can do that, it would
>>> probably help a lot if you identified the commit causing that to happen.
>> ..
>>
>> Well, it would help then if you identified the commits which hacked
>> at the video mode switching.  Then I can revert those and see what happens.
>> There's probably not many commits there, and since it doesn't do it consistently
>> (and sometimes the machine just doesn't resume at all with 2.6.25), 
>> it is tricky to bisect.
>>
>> Works perfectly in 2.6.24, though, which is what I'm now running again.
> 
> I guess this is related to http://bugzilla.kernel.org/show_bug.cgi?id=10319 .
> 
> I have no idea what can cause that to happen.  It apparently is not related to
> CONFIG_DRM (that actually may help if you have an Intel graphics adapter),
> so it looks like an ACPI issue.
..

Something's weird there.  I poked at my suspend/resume script again this morning,
and discovered that it did have some vbetool hacks to deal with textmode on earlier
kernels.

So I wrapped those vbetool hacks with some logic to prevent them on 2.6.25,
and for now suspend/resume seem to be working with good video on -rc8.
It'll take a bit longer to know for sure, but by the end of today we'll see.

cheers
