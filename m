Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbYBGSr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbYBGSr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 13:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbYBGSrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 13:47:21 -0500
Received: from mga03.intel.com ([143.182.124.21]:40319 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbYBGSrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 13:47:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,316,1199692800"; 
   d="scan'208";a="376377415"
Message-ID: <47AB509B.4030401@intel.com>
Date: Thu, 07 Feb 2008 10:40:27 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Max Krasnyansky <maxk@qualcomm.com>
CC: Pavel Machek <pavel@ucw.cz>, e1000-devel@lists.sourceforge.net,
       jesse.brandeburg@intel.com, kernel list <linux-kernel@vger.kernel.org>,
       john.ronciak@intel.com, jeffrey.t.kirsher@intel.com
Subject: Re: [E1000-devel] e1000 1sec latency problem
References: <20080207141718.GA2030@elf.ucw.cz> <47AB38AB.8050001@qualcomm.com> <47AB3EEF.6050005@intel.com> <47AB48B0.10403@qualcomm.com> <47AB49F3.301@intel.com> <47AB4E30.3060409@qualcomm.com>
In-Reply-To: <47AB4E30.3060409@qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Krasnyansky wrote:
> 
> Kok, Auke wrote:
>> Max Krasnyansky wrote:
>>> Kok, Auke wrote:
>>>> Max Krasnyansky wrote:
>>>>> So you don't think it's related to the interrupt coalescing by any chance ?
>>>>> I'd suggest to try and disable the coalescing and see if it makes any difference.
>>>>> We've had lots of issues with coalescing misbehavior. Not this bad (ie 1 second) though.
>>>>>
>>>>> Add this to modprobe.conf and reload e1000 module
>>>>>
>>>>> options e1000 RxIntDelay=0,0 RxAbsIntDelay=0,0 InterruptThrottleRate=0,0 TxIntDelay=0,0 TxAbsIntDelay=0,0
>>>> that can't be the problem. irq moderation would only account for 2-3ms variance
>>>> maximum.
>>> Oh, I've definitely seen worse than that. Not as bad as a 1second though. Plus you're talking
>>> about the case when coalescing logic is working as designed ;-). What if there is some kind of 
>>> bug where timer did not expire or something.
>> we don't use a software timer in e1000 irq coalescing/moderation, it's all in
>> hardware, so we don't have that problem at all. And I certainly have never seen
>> anything you are referring to with e1000 hardware, and I do not know of any bug
>> related to this.
>>
>> are you maybe confused with other hardware ?
>>
>> feel free to demonstrate an example...
> 
> Just to give you a background. I wrote and maintain http://libe1000.sf.net
> So I know E1000 HW and SW in and out.

wow, even I do not dare to say that!

> And no I'm not confused with other HW and I know that we're
> not using SW timers for the coalescing. HW can be buggy as well. Note that I'm not saying that I
> know for sure that the problem is coalescing, I'm just suggesting to take it out of the equation
> while Pavel is investigating.
> 
> Unfortunately I cannot demonstrate an example but I've seen unexplained packet delays in the range 
> of 1-20 milliseconds on E1000 HW (and boy ... I do have a lot of it in my labs). Once coalescing 
> was disabled those problems have gone away.

this sounds like you have some sort of PCI POST-ing problem and those can indeed
be worse if you use any form of interrupt coalescing. In any case that is largely
irrelevant to the in-kernel drivers, and as I said we definately have no open
issues on that right now, and I really do not recollect any as well either (other
than the issue of interference when both ends are irq coalescing)

Cheers,

Auke
