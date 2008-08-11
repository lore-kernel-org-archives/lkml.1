Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbYHKNb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbYHKNb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 09:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYHKNbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 09:31:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52052 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbYHKNbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 09:31:44 -0400
Date: Mon, 11 Aug 2008 15:31:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [revert] mysql+oltp regression
Message-ID: <20080811133126.GC14474@elte.hu>
References: <1218454322.25098.24.camel@marge.simson.net> <20080811114324.GA23529@elte.hu> <48A03049.202@novell.com> <20080811124857.GD10082@elte.hu> <48A038A6.4010104@novell.com> <20080811131400.GA909@elte.hu> <48A03C6E.60303@novell.com> <48A03E28.9040801@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A03E28.9040801@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gregory Haskins <ghaskins@novell.com> wrote:

> Gregory Haskins wrote:
>> Ingo Molnar wrote:
>>> * Gregory Haskins <ghaskins@novell.com> wrote:
>>>
>>>  
>>>>>> Speaking of this: Another patch I submitted to you Ingo (had to 
>>>>>> do with updating the load_weight inside task_setprio) seems to 
>>>>>> also have this phenomenon: e.g. its technically correct but 
>>>>>> further testing has revealed negative repercussions elsewhere.  
>>>>>> So please ignore that patch (or revert if you already pulled 
>>>>>> in, but I don't think you have).  Ill try to look into this 
>>>>>> issue as well.
>>>>>>         
>>>>> ok, under which thread/subject is that? Not queued in tip/sched/* 
>>>>> yet, correct?
>>>>>         
>>>> Here is the original thread:
>>>>
>>>> http://lkml.org/lkml/2008/7/3/416
>>>>
>>>> I do not believe you have queued it anywhere (public anyway) yet.
>>>>
>>>> Note I have already invalidated 1/2, and now I am retracting 2/2 as 
>>>> well.  (1/2 is actually a bogus patch, 2/2 is "technically correct" 
>>>> but causes ripples in the load balancer that need to be sorted out  
>>>> first.
>>>>     
>>>
>>> ok, thanks. I'm curious, what are those ripple effects? Stability or  
>>> performance?
>>>   
>>
>> Performance.  I found it while working on my pi series (which fyi I  
>> should have a v2 refresh for soon, probably today...i am hoping to get  
>> some review feedback from you on that as well, time permitting of  
>> course ;).
>>
>> Basically the behavior I was observing was that kernel builds via  
>> distcc would cluster all the cc1 jobs on a single core.  At first I  
>> thought my pi-series was screwed up, but then I realized I had applied  
>> the patch referenced above earlier in my development tree, and  
>> removing it allowed pi to work fine.
>>
>> I found the problem with in once boot cycle with ftrace (thanks Steve!).
>
> Hmm..Im not sure what went wrong between brain and hand above, but of 
> course I meant to say ".. within one boot cycle ..", not "with in 
> once".  Heh.

my second reading of that sentence auto-corrected it to your intented 
version ;-)

	Ingo
