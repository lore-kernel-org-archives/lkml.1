Return-Path: <linux-kernel-owner+w=401wt.eu-S964961AbXGUWP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964961AbXGUWP5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 18:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936104AbXGUWP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 18:15:29 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:50915
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936086AbXGUWP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 18:15:28 -0400
Date: Sat, 21 Jul 2007 15:14:02 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pavel Machek <pavel@ucw.cz>
cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
In-Reply-To: <20070721194906.GC3701@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0707211510390.6577@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707171010490.3551-100000@iolanthe.rowland.org>
 <200707171802.30903.rjw@sisk.pl> <Pine.LNX.4.64.0707170959160.2467@asgard.lang.hm>
 <200707172150.44417.rjw@sisk.pl> <Pine.LNX.4.64.0707171302430.2467@asgard.lang.hm>
 <20070721102520.GE1902@elf.ucw.cz> <87ps2lojlc.fsf@jbms.ath.cx>
 <20070721175639.GA3701@elf.ucw.cz> <Pine.LNX.4.64.0707211232580.6577@asgard.lang.hm>
 <20070721194906.GC3701@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007, Pavel Machek wrote:

>>>>> So it will be break at least battery status and "AC plugged in"
>>>>> status, because those are handled by ACPI and we do not know how to
>>>>> control them by hand.
>>>>
>>>> It seems that it should be possible to initialize ACPI as if the system
>>>> just booted up normally.  Then battery status and such should be
>>>> correct, since they are correct after normal initialization.
>>>>
>>>> It should be possible to make hibernate look just like a reboot to all
>>>> of the devices, including ACPI stuff.
>>>
>>> Patch to make that work with swsusp/shutdown method would be indeed
>>> welcome. It does not work today.
>>
>> is this a problem in the restore path?
>>
>> with the kexec approach (and ignoring suspend to ram and disk for the
>> moment) the system will actually get shutdown completely after the image
>> is written. on resume it gets cold booted. at this point the ACPI stuff
>> should have no problem
>>
>> now if the ACPI drivers are storing something in ram about the battery
>> status and AC power status, but don't re-check after the resume, it
>> seems
>
> That seems to be the problem. They store something in ram, and we
> don't tell them that we resumed. That's why platform mode is
> important, and way to go on ACPI systems.

this sounds like the few drivers that do this sort of thing (and this 
should only be the things that report status, drivers that enable devices 
should be taken care of) need a 'forget what you think you know, check the 
reality of the hardware' function.

even without suspend I've sen these drivers get out of sync with reality, 
and so such a function call would be useful to get them back in sync in 
any case.

if such a 'check reality' function was available it should be 
straightforward to call it after a non-ACPI hibrnate/resume

David Lang
