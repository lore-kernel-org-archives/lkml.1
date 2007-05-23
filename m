Return-Path: <linux-kernel-owner+w=401wt.eu-S935788AbXEWRUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935788AbXEWRUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 13:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757596AbXEWRUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 13:20:30 -0400
Received: from mail.tmr.com ([64.65.253.246]:44683 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756735AbXEWRU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 13:20:28 -0400
Message-ID: <4654784A.8080800@tmr.com>
Date: Wed, 23 May 2007 13:22:18 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Michael Gerdau <mgd@technosis.de>
CC: Con Kolivas <kernel@kolivas.org>, Miguel Figueiredo <elmig@debianpt.org>,
       Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
References: <464F57DD.2000309@tmr.com> <46538AB8.8030009@tmr.com> <200705241036.45179.kernel@kolivas.org> <200705230723.42400.mgd@technosis.de>
In-Reply-To: <200705230723.42400.mgd@technosis.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Gerdau wrote:
>> That's because the whole premise of your benchmark relies on a workload that 
>> yield()s itself to the eyeballs on most graphic card combinations when using 
>> glxgears. Your test remains a test of sched_yield in the presence of your 
>> workloads rather than anything else. If people like ck2 it's because in the 
>> real world with real workloads it is better, rather than on a yield() based 
>> benchmark. Repeatedly the reports are that 3d apps and games in normal usage 
>> under -ck are better than mainline and cfs.
>>     
>
> While I can't comment on the technical/implementational details of
> Con's claim I definitely have to agree from a users POV.
>
>   
Any of the sd/ck/cfs schedulers are an improvement on the current 
mainline, and hopefully they will continue to cross pollinate and 
evolve. Perhaps by 2.6.23 a clear "best" will emerge, or Linus will 
change his mind and make sd and cfs be compile options at build time.
> All my recent CPU intensive benchmarks show that both ck/sd and cfs
> are very decent scheduler and IMO superior to mainline for all _my_
> usecases. In particular playing supertux while otherwise fully utilizing
> both CPUs on a dualcore works without any glitch and better than
> on mainline for both sd and cfs.
>
>   
I did some kernel compile timing numbers as part of my work with 
ctxbench, and there is little to choose between the schedulers under 
load, although the special case for sched_yield makes some loads perform 
better with cfs. With large memory and fast disk, a kernel make becomes 
a CPU benchmark, there's virtually no iowait not filled with another 
process.
> For me the huge difference you have for sd to the others increases the
> likelyhood the glxgears benchmark does not measure scheduling of graphic
> but something else.
>
>   
The glitch1 script generates a number of CPU bound processes updating 
the screen independently, which stresses both graphics performance and 
scheduler fairness. And once again I note that it's a *characterization* 
rather than a benchmark. The ability of the scheduler to deliver the 
same resources to multiple identical processes, and to keep another CPU 
bound process (glxgears) getting the processor at regular intervals is 
more revealing than the frames per second or loops run.

I would expect sd to be better at this, since it uses a deadline 
concept, but in practice the gears pause, and then move rapidly or 
appear to jump. My reading on this is that the process starves for some 
ms, then gets a lot of CPU because it is "owed" more. I think I see this 
in games, but not being a game player I can't tell from experience if 
it's artifact or the games suck. That's what my test rig, based on a 15 
year old boy and several cans of high caffeine soda, is used for. ;-)
> Anyway, I'm still in the process of collecting data or more precisely
> until recently constantly refined what data to collect and how. I plan
> to provide new benchmark results on CPU intensive tasks in a couple of
> days.
>   
-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

