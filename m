Return-Path: <linux-kernel-owner+w=401wt.eu-S934176AbXCVSSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176AbXCVSSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 14:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964785AbXCVSSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 14:18:12 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2902 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176AbXCVSSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 14:18:11 -0400
Message-ID: <4602C83B.20608@shadowen.org>
Date: Thu, 22 Mar 2007 18:17:31 +0000
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, "Martin J. Bligh" <mbligh@mbligh.org>
Subject: Re: 2.6.21-rc4-mm1
References: <20070319205623.299d0378.akpm@linux-foundation.org> <4602413C.6000504@shadowen.org> <46025100.7060103@shadowen.org> <200703222104.06507.kernel@kolivas.org> <4602B7D3.4030108@shadowen.org>
In-Reply-To: <4602B7D3.4030108@shadowen.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> Con Kolivas wrote:
>> On Thursday 22 March 2007 20:48, Andy Whitcroft wrote:
>>> Andy Whitcroft wrote:
>>>> Andy Whitcroft wrote:
>>>>> Andrew Morton wrote:
>>>>>> Temporarily at
>>>>>>
>>>>>>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
>>>>>>
>>>>>> Will appear later at
>>>>>>
>>>>>>  
>>>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc
>>>>>> 4/2.6.21-rc4-mm1/
>>>>> [All of the below is from the pre hot-fix runs.  The very few results
>>>>> which are in for the hot-fix runs seem worse if anything.  :(  All
>>>>> results should be out on TKO.]
>>>>>
>>>>>> - Restored the RSDL CPU scheduler (a new version thereof)
>>>>> Unsure if the above is the culprit but there seems to be a smattering of
>>>>> BUG's in kernbench from the schedular on several systems, and panics
>>>>> which do not fully dump out.
>>>>>
>>>>> elm3b239 is about 2/4 kernbench being the test in progress when we
>>>>> blammo in both failed tests, elm3b234 doesn't boot at all.
>>>> Well I have one result through for backing RSDL out on elm3b239 and that
>>>> does indeed seem to give us a successful boot and test.  peterz has
>>>> pointed me to an incremental patch from Con which I'll push through
>>>> testing and see if that sorts it out.
>>> Ok, tested the patch below on top of 2.6.21-rc4-mm1 and this seems to
>>> fix the problem:
>>>
>>> http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc4-mm1-rsdl-0.32.p
>>> atch
>>>
>>> Hard to tell from that patch whether it will be fixed in the changes
>>> already committed to the next -mm.
>>>
>>> Its possible that it may be fixed by the following patch:
>>>
>>>     sched-rsdl-improvements.patch
>>>
>>> Which has the following slipped in at the end of the changelog:
>>>
>>>     A tiny change checking for MAX_PRIO in normal_prio()
>>>     may prevent oopses on bootup on large SMP due to
>>>     forking off the idle task.
>>>
>>> Con, are all the changes in the 0.32 patch above with akpm?
>> Yes he's queued everything in that patch you tested for the next -mm. Thanks 
>> very much for testing it.
> 
> No worries.  I've just got through the results on the other machine in
> the mix.  That machine seems to be fixed by backing out RSDL and not by
> the fixup 0.32 patch ...
> 
> This second machine seems to had hard very soon after user space starts
> executing but without a panic.  I can't say that the symptoms are very
> definitive, but I do have a good result from that machine without RSDL
> and not with rsdl-0.32.
> 
> The machine is a dual-core x86_64 machine: Dual Core AMD Opteron(tm)
> Processor 275.
> 
> I'll let you know if I find out anything else.  Shout if you want any
> information or have anything you want poked or tested.

Ok, I have yet a third x86_64 machine is is blowing up with the latest
2.6.21-rc4-mm1+hotfixes+rsdl-0.32 but working with
2.6.21-rc4-mm1+hotfixes-RSDL.  I have results on various hotfix levels
so I have just fired off a set of tests across the affected machines on
that latest hotfix stack plus the RSDL backout and the results should be
in in the next hour or two.

I think there is a strong correlation between RSDL and these hangs.  Any
suggestions as to the next step.

-apw
