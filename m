Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbYAUSgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbYAUSgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 13:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYAUSgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 13:36:41 -0500
Received: from slowhand.arndnet.de ([88.198.19.76]:44623 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752007AbYAUSgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 13:36:41 -0500
Message-ID: <4794E664.6020209@i4.informatik.rwth-aachen.de>
Date: Mon, 21 Jan 2008 19:37:24 +0100
From: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jordan Crouse <jordan.crouse@amd.com>
CC: Andres Salomon <dilinger@queued.net>, marc.jones@amd.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, wim@iguana.be
Subject: Re: Geode GX/LX watchdog timer (RESEND)
References: <20080116165606.3ebc06a4@ephemeral> <478F25D6.3060503@i4.informatik.rwth-aachen.de> <20080117134032.4cc1a1cf@ephemeral> <478FB255.5040001@i4.informatik.rwth-aachen.de> <20080117211917.GF8244@cosmic.amd.com> <478FCDB6.4010708@i4.informatik.rwth-aachen.de> <20080117223644.GK8244@cosmic.amd.com> <478FDC12.6020505@i4.informatik.rwth-aachen.de> <20080119010624.GA25328@cosmic.amd.com> <47934B2E.3020707@i4.informatik.rwth-aachen.de> <20080121170700.GC6884@cosmic.amd.com>
In-Reply-To: <20080121170700.GC6884@cosmic.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jordan Crouse schrieb:
> On 20/01/08 14:22 +0100, Arnd Hannemann wrote:
>> Hi,
>>
>> Jordan Crouse wrote:
>>> On 17/01/08 23:52 +0100, Arnd Hannemann wrote:
>>>>>> Watchdog for the new API would be great :-)
>>>>> Coming soon.
>>> As promised, a watchdog driver for the Geode GX/LX processors is attached.
>>> I basically just ported the previous patch forward to 2.6.24.
>> Great work!
>>
>>> I also have good news or bad news depending on your perspective.  I wanted
>>> to test this against 2.6.24, and OLPC is stuck at an older kernel version,
>>> so I had to test this with coreboot (LinuxBIOS) on another Geode 
>>> platform.  Like all BIOSen execpt for the OLPC firmware, coreboot uses
>>> VSA (SMM handler) which consumes all the timers.
>>>
>>> So I used the magical MSR and surprise! - the timer tick hung.  
>>> I compiled out the timer tick, and tested the watchdog timer instead,
>>> and it worked fine on timer 0.  So I don't think the MFGPTs themselves
>>> have anything to do with this problem, but I do think it might be 
>>> related to VSA and possibly interrupts too.  I'm going to invoke the
>>> strong BIOS fu of our LinuxBIOS / BIOS expert Marc Jones, and see what
>>> he comes up with.
>>>
>>> I don't know how much of a hassle it would be for Andres to get a 2.6.24
>>> kernel running on the OLPC to make sure that this isn't a regression
>>> in the timer tick code (I suspect it isn't a regression, but you never
>>> know).  I also think that it would probably be in our best interest to
>>> default CONFIG_GEODE_MFGPT_TIMER to 'n' until we get this figured
>>> out.  Since most BIOSen don't have timers available, that shouldn't affect
>>> too many people.
>>>
>>> So, anyway, enjoy the watchdog timer - I hope it meets everybody's
>>> expectations for the 2.6.25 kernel.
>> Thanks a lot for this, it works great! (with CONFIG_GEODE_MFGPT_TIMER
>> not set).
>> However some minor issues:
>> Could the name of the /dev entry perhaps be changed from
>> "geode-watchdog" to "watchdog" instead?
>> I think all other watchdogs use "watchdog", and using two different
>> watchdogs in the same machine won't work anyway, because of the same
>> minor number, right?
>>
>> As a second point my gcc (4.1.2) issues a warning:
>>
>> drivers/watchdog/geodewdt.c: In function ‘geodewdt_remove’:
>> drivers/watchdog/geodewdt.c:256: warning: control reaches end of
>> non-void function
>>
>> which I think is a valid one.
> 
> Resending with Arnd's concern's addressed.  Thanks.  

I can confirm that it is still working fine :-)

> 
> Jordan
> 
Greetings,
Arnd
