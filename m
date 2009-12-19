Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbZLSWnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbZLSWnw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 17:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbZLSWnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 17:43:51 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:47468 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbZLSWnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 17:43:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=xhfc/hmgarasWqoqYpMtJU6ltaJURrfXXxcHYXQAdi8+zs6zro94ZbXvB4qfaHrJoi
         BeRBpVvxFB5NWBQ30KbSU6JbHeYRWiiDFk+OsiliuR9a3bmc3zjhnj04DzDYCd+Rx8S3
         0hFlnAfip5/X9704faHnfL0R2M1Sw50Krn0Ew=
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <20091219195935.GB4073@core.coreip.homeip.net> <200912192233.44575.rjw@sisk.pl> <200912192329.03251.rjw@sisk.pl>
Message-Id: <4282441C-9294-4C16-B1EB-7BCBEA755140@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <200912192329.03251.rjw@sisk.pl>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7C144)
Mime-Version: 1.0 (iPhone Mail 7C144)
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Sat, 19 Dec 2009 14:43:25 -0800
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 19, 2009, at 2:29 PM, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Saturday 19 December 2009, Rafael J. Wysocki wrote:
>> On Saturday 19 December 2009, Dmitry Torokhov wrote:
>>> On Fri, Dec 18, 2009 at 11:43:29PM +0100, Rafael J. Wysocki wrote:
>>>> On Wednesday 16 December 2009, Dmitry Torokhov wrote:
>>>>> On Wed, Dec 16, 2009 at 03:11:05AM +0100, Rafael J. Wysocki wrote:
>>>>>> On Tuesday 15 December 2009, Linus Torvalds wrote:
>>>>>>>
>>>>>>> On Tue, 15 Dec 2009, Rafael J. Wysocki wrote:
>>>>>>>>>
>>>>>>>>> Give a real example that matters.
>>>>>>>>
>>>>>>>> I'll try.  Let -> denote child-parent relationships and  
>>>>>>>> assume dpm_list looks
>>>>>>>> like this:
>>>>>>>
>>>>>>> No.
>>>>>>>
>>>>>>> I mean something real - something like
>>>>>>>
>>>>>>> - if you run on a non-PC with two USB buses behind non-PCI  
>>>>>>> controllers.
>>>>>>>
>>>>>>> - device xyz.
>>>>>>>
>>>>>>>> If this applies to _resume_ only, then I agree, but the  
>>>>>>>> Arjan's data clearly
>>>>>>>> show that serio devices take much more time to suspend than  
>>>>>>>> USB.
>>>>>>>
>>>>>>> I mean in general - something where you actually have hard  
>>>>>>> data that some
>>>>>>> device really needs anythign more than my one-liner, and  
>>>>>>> really _needs_
>>>>>>> some complex infrastructure.
>>>>>>>
>>>>>>> Not "let's imagine a case like xyz".
>>>>>>
>>>>>> As I said I would, I made some measurements.
>>>>>>
>>>>>> I measured the total time of suspending and resuming devices as  
>>>>>> shown by the
>>>>>> code added by this patch:
>>>>>> http://git.kernel.org/?p=linux/kernel/git/rafael/suspend-2.6.git;a=commitdiff_plain;h=c1b8fc0a8bff7707c10f31f3d26bfa88e18ccd94;hp=087dbf5f079f1b55cbd3964c9ce71268473d5b67
>>>>>> on two boxes, HP nx6325 and MSI Wind U100 (hardware-wise they  
>>>>>> are quite
>>>>>> different and the HP was running 64-bit kernel and user space).
>>>>>>
>>>>>> I took four cases into consideration:
>>>>>> (1) synchronous suspend and resume (/sys/power/pm_async = 0)
>>>>>> (2) asynchronous suspend and resume as introduced by the async  
>>>>>> branch at:
>>>>>>    http://git.kernel.org/?p=linux/kernel/git/rafael/suspend-2.6.git;a=shortlog;h=refs/heads/async
>>>>>> (3) asynchronous suspend and resume like in (2), but with your  
>>>>>> one-liner setting
>>>>>>    the power.async_suspend flag for PCI bridges on top
>>>>>> (4) asynchronous suspend and resume like in (2), but with an  
>>>>>> extra patch that
>>>>>>    is appended on top
>>>>>>
>>>>>> For those tests I set power.async_suspend for all USB devices,  
>>>>>> all serio input
>>>>>> devices, the ACPI battery and the USB PCI controllers (to see  
>>>>>> the impact of the
>>>>>> one-liner, if any).
>>>>>>
>>>>>> I carried out 5 consecutive suspend-resume cycles (started from  
>>>>>> under X) on
>>>>>> each box in each case, and the raw data are here (all times in  
>>>>>> milliseconds):
>>>>>> http://www.sisk.pl/kernel/data/async-suspend.pdf
>>>>>>
>>>>>> The summarized data are below (the "big" numbers are averages  
>>>>>> and the +/-
>>>>>> numbers are standard deviations, all in milliseconds):
>>>>>>
>>>>>>            HP nx6325        MSI Wind U100
>>>>>>
>>>>>> sync suspend        1482 (+/- 40)    1180 (+/- 24)
>>>>>> sync resume        2955 (+/- 2)    3597 (+/- 25)
>>>>>>
>>>>>> async suspend        1553 (+/- 49)    1177 (+/- 32)
>>>>>> async resume        2692 (+/- 326)    3556  (+/- 33)
>>>>>>
>>>>>> async+one-liner suspend    1600 (+/- 39)    1212 (+/- 41)
>>>>>> async+one-liner resume    2692 (+/- 324)    3579 (+/- 24)
>>>>>>
>>>>>> async+extra suspend    1496 (+/- 37)    1217 (+/- 38)
>>>>>> async+extra resume    1859 (+/- 114)    1923 (+/- 35)
>>>>>>
>>>>>> So, in my opinion, with the above set of "async" devices, it  
>>>>>> doesn't
>>>>>> make sense to do async suspend at all, because the sync suspend  
>>>>>> is actually
>>>>>> the fastest on both machines.
>>>>>
>>>>> I think the async suspend is not asynchronous enough then - what  
>>>>> kind of
>>>>> time do you get if you simply comment out call to psmouse_reset 
>>>>> () in
>>>>> drivers/input/mouse/psmouse-base.c:psmouse_cleanup()?  (Just for  
>>>>> testing
>>>>> purposes only, I don't think we want to do that by default.)
>>>>
>>>> The problem apparently is that the i8042 suspend/resume is  
>>>> synchronous.
>>>>
>>>> Do you think it's safe to mark it as asynchronous?
>>>>
>>>
>>> Umm.. there lie dragons. There is an implicit relationship between  
>>> i8042
>>> and PNP/ACPI devices representing keyboard and mouse ports, and I  
>>> am not
>>> sure how happy i8042 (and most importantly the BIOS) will be if  
>>> they get
>>> shut down before i8042. Also there is EC which is in theory  
>>> independent
>>> but in practice not so much.
>>
>> I see.
>>
>> Is this possible to identify ACPI devices that should wait for the  
>> i8042
>> suspend and that should be waited for by it on resume?
>
> Wait, if you look at the logs at
>
> http://www.sisk.pl/kernel/data/nx6325/
> http://www.sisk.pl/kernel/data/wind/
>
> you'll see that the i8042 suspend is called before any ACPI devices  
> are
> suspended anyway.  In fact, it is suspended right after its serio  
> children
> which is very early in the suspend sequence.

Right, and we do want to "suspend" i8042 (well, reset to the initial  
state we found it at bootup) before touching ACPI.

If i8042 is async, given the fact that psmouse reset takes a long  
time, it is possible that we start suspending PNP before we are done  
with i8042.

-- 
>

Dmitry
