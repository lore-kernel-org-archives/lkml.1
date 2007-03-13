Return-Path: <linux-kernel-owner+w=401wt.eu-S933148AbXCMUKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148AbXCMUKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 16:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933094AbXCMUKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 16:10:47 -0400
Received: from gw.goop.org ([64.81.55.164]:37248 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933148AbXCMUKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 16:10:46 -0400
Message-ID: <45F70540.8090506@goop.org>
Date: Tue, 13 Mar 2007 13:10:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: davids@webmaster.com
CC: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
References: <MDEHLPKNGKAHNMBLJOLKIELACDAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKIELACDAC.davids@webmaster.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz wrote:
>> There's a distinction between giving it more cpu and giving it higher
>> priority: the important part about having high priority is getting low
>> latency access to the cpu when its needed.
>>     
>
> I agree. Tasks that voluntarily relinquish their timeslices should get lower
> latency compared to other processes at the same static priority.
>
>   
>> This really seems like the wrong approach to me.  The implication here
>> and in other mails is that fairness is an inherently good thing which
>> should obviously take preference over any other property.
>>     
>
> Yes, that is the implication. The alternative to fairness is arbitrary
> unfairness. "Rational unfairness" is a form of fairness.
>
>   
>> The old unix-style dynamic priority scheme was designed to give
>> interactive processes high priorities, by using the observation that
>> "interactive" means "spends a lot of time blocked waiting for input".
>> That model of interactive is way too simple now, and the attempts to try
>> an find an equivalent heuristic have been flawed and lead to - in some
>> cases - wildly bad behaviours.  I'm guessing the emphasis on "fairness"
>> is in reaction to this, which is fair enough.
>>     
>
> I don't think it makes sense for the scheduler to look for some hint that
> the user would prefer a task to get more CPU and try to give it more. That's
> what 'nice' is for.
>
>   
>> But saying that the user needs to explicitly hold the schedulers hand
>> and nice everything to tell it how to schedule seems to be an abdication
>> of duty, an admission of failure.  We can't expect users to finesse all
>> their processes with nice, and it would be a bad user interface to ask
>> them to do so.
>>     
>
> Then you will always get cases where the scheduler does not do what the user
> wants because the scheduler does not *know* what the user wants. You always
> have to tell a computer what you want it to do, and the best it can do is
> faithfully follow your request.
>   

Hm, well.  The general preference has been for the kernel to do a
good-enough job on getting the common cases right without tuning, and
then only add knobs for the really tricky cases it can't do well.  But
the impression I'm getting here is that you often get sucky behaviours
without tuning.

> I think it's completely irrational to ask for a scheduler that automatically
> gives more CPU time to CPU hogs.
>   

Well, it doesn't have to.  It could give good low latency with short
timeslices to things which appear to be interactive.  If the interactive
program doesn't make good use of its low latency, then it will suck. 
But that's largely independent of how much overall CPU you give it.

> I agree. I'm not claiming to have the perfect solution. Let's not let the
> perfect be the enemy of the good though.
>   

For all its faults, the current scheduler mostly does a good job without
much tuning - I normally only use "nice" to run cpu-bound things without
jacking the cpu speed up.  Certainly in my normal interactive use of
compiz vs make -j4 on a dual-core generally gets pretty pretty good
results.  I plan on testing the new scheduler soon though.

    J
