Return-Path: <linux-kernel-owner+w=401wt.eu-S1752909AbXFNU5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbXFNU5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbXFNU5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:57:34 -0400
Received: from comtv.ru ([217.10.32.17]:58141 "EHLO comtv.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbXFNU5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:57:33 -0400
X-UCL: actv
Date: Fri, 15 Jun 2007 00:56:27 +0400 (MSD)
From: malc <av1474@comtv.ru>
X-X-Sender: malc@linmac.oyster.ru
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] sched: accurate user accounting
In-Reply-To: <20070614204253.GA14076@elte.hu>
Message-ID: <Pine.LNX.4.64.0706150052190.3404@linmac.oyster.ru>
References: <200703251159.03616.kernel@kolivas.org>
 <Pine.LNX.4.64.0703252107590.31900@linmac.oyster.ru> <200703260901.54943.kernel@kolivas.org>
 <200703260957.34798.kernel@kolivas.org> <Pine.LNX.4.64.0703261439270.2621@linmac.oyster.ru>
 <20070328113743.GA5615@elte.hu> <Pine.LNX.4.64.0706142149020.2991@linmac.oyster.ru>
 <20070614204253.GA14076@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007, Ingo Molnar wrote:

>
> * Vassili Karpov <av1474@comtv.ru> wrote:
>
>> Hello Ingo and others,
>>
>> After reading http://lwn.net/Articles/236485/ and noticing few
>> refernces to accounting i decided to give CFS a try. With
>> sched-cfs-v2.6.21.4-16 i get pretty weird results, it seems like
>> scheduler is dead set on trying to move the processes to different
>> CPUs/cores all the time. And with hog (manually tweaking the amount
>> iterations) i get fairly strange resuls, first of all the process is
>> split between two cores, secondly while integral load provided by the
>> kernel looks correct, it's off by good 20 percent on each idividial
>> core.
>>
>> (http://www.boblycat.org/~malc/apc/hog-cfs-v16.png)
>>
>> Thought this information might be of some interest.
>
> hm - what does 'hog' do, can i download hog.c from somewhere?

http://www.boblycat.org/~malc/apc/hog.c and also a in
Documentation/cpu-load.txt.

>
> the alternating balancing might be due to an uneven number of tasks
> perhaps? If you have 3 tasks on 2 cores then there's no other solution
> to achieve even performance of each task but to rotate them amongst the
> cores.

One task, one thread. I have also tried to watch fairly demanding video
(Elephants Dream in 1920x1080/MPEG4) with mplayer, and CFS moves the
only task between cores almost every second.

>> P.S. How come the /proc/stat information is much closer to reality
>>      now? Something like what Con Kolivas suggested was added to
>>      sched.c?
>
> well, precise/finegrained accounting patches have been available for
> years, the thing with CFS is that there we get them 'for free', because
> CFS needs those metrics for its own logic. That's why this information
> is much closer to reality now. But note: right now what is affected by
> the changes in the CFS patches is /proc/PID/stat (i.e. the per-task
> information that 'top' and 'ps' displays, _not_ /proc/stat) - but more
> accurate /proc/stat could certainly come later on too.

Aha. I see, it's just that integral load for hog is vastly improved
compared to vanilla 2.6.21 (then again some other tests are off by a few
percent (at least), though they were fine with Con's patch (which was
announced at the beginning of this thread))

-- 
vale
