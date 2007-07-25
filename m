Return-Path: <linux-kernel-owner+w=401wt.eu-S1764635AbXGYWYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764635AbXGYWYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 18:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbXGYWYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 18:24:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbXGYWYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 18:24:33 -0400
Message-ID: <46A7CD97.4020903@redhat.com>
Date: Wed, 25 Jul 2007 18:24:23 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Li, Tong N" <tong.n.li@intel.com>
CC: Chris Friesen <cfriesen@nortel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com>	 <20070725110159.GA15076@elte.hu> <20070725120358.GA30755@elte.hu>	 <Pine.LNX.4.64.0707251014520.14515@tongli.jf.intel.com>	 <20070725192442.GC4463@elte.hu> <46A7B4DE.4030301@nortel.com>	 <46A7B8A9.4040400@redhat.com> <1185398148.3162.5.camel@tongli.jf.intel.com>
In-Reply-To: <1185398148.3162.5.camel@tongli.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Li, Tong N wrote:
> On Wed, 2007-07-25 at 16:55 -0400, Chris Snook wrote:
>> Chris Friesen wrote:
>>> Ingo Molnar wrote:
>>>
>>>> the 3s is the problem: change that to 60s! We no way want to 
>>>> over-migrate for SMP fairness, the change i did gives us reasonable 
>>>> long-term SMP fairness without the need for high-rate rebalancing.
>>> Actually, I do have requirements from our engineering guys for 
>>> short-term fairness.  They'd actually like decent fairness over even 
>>> shorter intervals...1 second would be nice, 2 is acceptable.
>>>
>>> They are willing to trade off random peak performance for predictability.
>>>
>>> Chris
>>>
>> The sysctls for CFS have nanosecond resolution.  They default to 
>> millisecond-order values, but you can set them much lower.  See sched_fair.c for 
>> the knobs and their explanations.
>>
>> 	-- Chris
> 
> This is incorrect. Those knobs control local-CPU fairness granularity
> but have no control over fairness across CPUs.
> 
> I'll do some benchmarking as Ingo suggested.
> 
>   tong

CFS naturally enforces cross-CPU fairness anyway, as Ingo demonstrated. 
Lowering the local CPU parameters should cause system-wide fairness to converge 
faster.  It might be worthwhile to create a more explicit knob for this, but I'm 
inclined to believe we could do it in much less than 700 lines.  Ingo's 
one-liner to improve the 10/8 balancing case, and the resulting improvement, 
were exactly what I was saying should be possible and desirable.  TCP Nagle 
aside, it generally shouldn't take 700 lines of code to speed up the rate of 
convergence of something that already converges.

Until now I've been watching the scheduler rewrite from the sidelines, but I'm 
digging into it now.  I'll try to give some more constructive criticism soon.

	-- Chris
