Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbXD0SWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbXD0SWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756984AbXD0SWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:22:37 -0400
Received: from mail.tmr.com ([64.65.253.246]:48597 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbXD0SWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:22:36 -0400
Message-ID: <46323F6F.6070903@tmr.com>
Date: Fri, 27 Apr 2007 14:22:39 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: Ingo Molnar <mingo@elte.hu>, Ed Tomlinson <edt@aei.ca>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [REPORT] First "glitch1" results, 2.6.21-rc7-git6-CFSv5 + SD
  0.46
References: <462D2BDD.4040406@tmr.com> <20070424065709.GB19802@elte.hu> <46312116.1030506@tmr.com> <200704270856.17210.kernel@kolivas.org>
In-Reply-To: <200704270856.17210.kernel@kolivas.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> On Friday 27 April 2007 08:00, Bill Davidsen wrote:
>   
>> Ingo Molnar wrote:
>>     
>>> * Ed Tomlinson <edt@aei.ca> wrote:
>>>       
>>>>> SD 0.46		1-2 FPS
>>>>> cfs v5 nice -19	219-233 FPS
>>>>> cfs v5 nice 0 	1000-1996
>>>>>           
>>>>    cfs v5 nice -10  60-65 FPS
>>>>         
>>> the problem is, the glxgears portion of this test is an _inverse_
>>> testcase.
>>>
>>> The reason? glxgears on true 3D hardware will _not_ use X, it will
>>> directly use the 3D driver of the kernel. So by renicing X to -19 you
>>> give the xterms more chance to show stuff - the performance of the
>>> glxgears will 'degrade' - but that is what you asked for: glxgears is
>>> 'just another CPU hog' that competes with X, it's not a "true" X client.
>>>
>>> if you are after glxgears performance in this test then you'll get the
>>> best performance out of this by renicing X to +19 or even SCHED_BATCH.
>>>       
>> Several points on this...
>>
>> First, I don't think this is accelerated in the way you mean, the
>> machine is a test server, with motherboard video using the 945G video
>> driver. Given the limitations of the support in that setup, I don't
>> think it qualified as "true 3D hardware," although I guess I could try
>> using the vesafb version as a test.
>>
>> The 2nd thing I note is that on FC6 this scheduler seems to confuse
>> 'top' to some degree, since the glxgears is shown as taking 51% of the
>> CPU (one core), while the state breakdown shows about 73% in idle,
>> waitio, and int. image attached.
>>     
>
> top by itself certainly cannot be trusted to give true representation of the 
> cpu usage I'm afraid. It's not as convoluted as, say, trying to track memory 
> usage of an application, but top's resolution being tied to HZ accounting 
> makes it not reliable in that regard.
>   
>> After I upgrade the kernel and cfs to the absolute latest I'll repeat
>> this, as well as test with vesafb, and my planned run under heavy load.
>>     
>
> I have a problem with your test case Bill. Its behaviour would depend on how 
> gpu bound vs cpu bound vs accelerated vs non-accelerated your graphics card 
> is. I get completely different results to those of the other testers given 
> the different hardware configuration and I don't think my results are 
> valuable. My problem with this testcase is - What would you define 
> as "perfect" behaviour for your test case? It seems far too arbitrary.
>
>   
It was more intended to give an immediate feedback on gross behavior. On 
some old schedulers (2.4.x) it visibly ran one xterm after the other, 
while on 2.6.2[01] that behavior is gone and all schedulers give equal 
time as seen by the eye. Looking at the behavior with line and jump 
scroll, under load or not, X nice or nasty, allows a quick check on 
where the bad cases are if any exist.

I intended it as a quick way to determine really, visibly, bad 
scheduling, not a a test for quantifying performance. The fact that fps 
varies by almost an order of magnitude with some earlier versions of the 
schedulers is certainly a red flag to me that there's a corner case, and 
something I care more about than glxgears will be inconsistent as well.

Hopefully in that context, as a relatively quick way to try nice and 
load values, it's a useful tool.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

