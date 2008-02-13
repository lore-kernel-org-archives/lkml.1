Return-Path: <linux-kernel-owner+w=401wt.eu-S1764942AbYBMEGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764942AbYBMEGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 23:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbYBMEGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 23:06:10 -0500
Received: from ithilien.qualcomm.com ([129.46.51.59]:47205 "EHLO
	ithilien.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbYBMEGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 23:06:08 -0500
Message-ID: <47B26B21.3000108@qualcomm.com>
Date: Tue, 12 Feb 2008 19:59:29 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>, gregkh@suse.de,
       Rusty Russell <rusty@rustcorp.com.au>, Oleg Nesterov <oleg@tv-sign.ru>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [git pull for -mm] CPU isolation extensions (updated2)
References: <47B11C45.6060408@qualcomm.com> <1202842788.6247.58.camel@lappy>
In-Reply-To: <1202842788.6247.58.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2008-02-11 at 20:10 -0800, Max Krasnyansky wrote:
>> Andrew, looks like Linus decided not to pull this stuff.
>> Can we please put it into -mm then.
>>
>> My tree is here
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/maxk/cpuisol-2.6.git
>> Please use 'master' branch (or 'for-linus' they are identical).
> 
> I'm wondering why you insist on offering a git tree that bypasses the
> regular maintainers. Why not post the patches and walk the normal route?
> 
> To me this feels rather aggressive, which makes me feel less inclined to
> look at it.
Peter, it may sound stupid but I'm honestly not sure what you mean. Please bear
with me I do not mean to sounds arrogant. I'm looking for advice here.
So here are some questions:

- First, who would the regular maintainer be in this case ?
I felt that cpu isolation can just sit in its own tree since it does not seem 
to belong to any existing stuff.
So far people suggested -mm and -shed.
I do not think it has much to do much with the -sched.
-mm seems more general purpose, since Linus did not pull it directly I asked 
Andrew to take this stuff into -mm. He was already ok with the patches when I 
sent original pull request to Linus.

- Is it not easier for a regular maintainer (whoever it turns out to be in this case)
to pull from GIT rather than use patches ?
In any case I did post patches along with pull request. So for example if Andrew 
prefers patches he could take those instead of the git. In fact if you look at my 
email I mentioned that if needed I can repost the patches.

- And last but not least I want to be able to just tell people who want to use CPU 
isolation "Go get get this tree and use it". Git it the best for that.

I can see how pull request to Linus may have been a bit aggressive. But then again
I posted patches (_without_ pull request). Got feedback from You, Paul and couple of 
other guys. Addressed/explained issues/questions. Posted patches again (_without_ 
pull request). Got _zero_ replies even though folks who replied to the first patchset
were replying to other things in the same timeframe. So I figured since I addressed 
everything you guys are happy, why not push it to Linus.

So what did I do wrong ?

Max






>> ----
>>  
>> Diffstat:
>>  Documentation/ABI/testing/sysfs-devices-system-cpu |   41 +++++++
>>  Documentation/cpu-isolation.txt                    |  113 +++++++++++++++++++++
>>  arch/x86/Kconfig                                   |    1 
>>  arch/x86/kernel/genapic_flat_64.c                  |    4 
>>  drivers/base/cpu.c                                 |   48 ++++++++
>>  include/linux/cpumask.h                            |    3 
>>  kernel/Kconfig.cpuisol                             |   42 +++++++
>>  kernel/Makefile                                    |    4 
>>  kernel/cpu.c                                       |   54 ++++++++++
>>  kernel/sched.c                                     |   36 ------
>>  kernel/stop_machine.c                              |    8 +
>>  kernel/workqueue.c                                 |   30 ++++-
>>  12 files changed, 337 insertions(+), 47 deletions(-)
>>
>> This addresses all Andrew's comments for the last submission. Details here:
>>    http://marc.info/?l=linux-kernel&m=120236394012766&w=2
>>
>> There are no code changes since last time, besides minor fix for moving on-stack array 
>> to __initdata as suggested by Andrew. Other stuff is just documentation updates. 
>>
>> List of commits
>>    cpuisol: Make cpu isolation configrable and export isolated map
>>    cpuisol: Do not route IRQs to the CPUs isolated at boot
>>    cpuisol: Do not schedule workqueues on the isolated CPUs
>>    cpuisol: Move on-stack array used for boot cmd parsing into __initdata
>>    cpuisol: Documentation updates
>>    cpuisol: Minor updates to the Kconfig options
>>    cpuisol: Do not halt isolated CPUs with Stop Machine
>>
>> I suggested by Ingo I'm CC'ing everyone who is even remotely connected/affected ;-)
> 
> You forgot Oleg, he does a lot of the workqueue work.
> 
> I'm worried by your approach to never start any workqueue on these cpus.
> Like you said, it breaks Oprofile and others who depend on cpu local
> workqueues being present.
> 
> Under normal circumstances these workqueues will not do any work,
> someone needs to provide work for them. That is, workqueues are passive.
> 
> So I think your approach is the wrong way about. Instead of taking the
> workqueue away, take away those that generate the work.
> 
>> Ingo, Peter - Scheduler.
>>    There are _no_ changes in this area besides moving cpu_*_map maps from kerne/sched.c 
>>    to kernel/cpu.c.
> 
> Ingo (and Thomas) do the genirq bits
> 
> The IRQ isolation in concept isn't wrong. But it seems to me that
> arch/x86/kernel/genapic_flat_64.c isn't the best place to do this.
> It just considers one architecture, if you do this, please make it work
> across all.
> 
>> Paul - Cpuset
>>    Again there are _no_ changes in this area.
>>    For reasons why cpuset is not the right mechanism for cpu isolation see this thread
>>       http://marc.info/?l=linux-kernel&m=120180692331461&w=2
>>
>> Rusty - Stop machine.
>>    After doing a bunch of testing last three days I actually downgraded stop machine 
>>    changes from [highly experimental] to simply [experimental]. Pleas see this thread 
>>    for more info: http://marc.info/?l=linux-kernel&m=120243837206248&w=2
>>    Short story is that I ran several insmod/rmmod workloads on live multi-core boxes 
>>    with stop machine _completely_ disabled and did no see any issues. Rusty did not get
>>    a chance to reply yet, I hopping that we'll be able to make "stop machine" completely
>>    optional for some configurations.
> 
> I too am thinking this is very wrong, stop machine is used by a lot of
> things, including those that modify the kernel code. You really need to
> replace all stop machine users with a more robust solution before you
> can do this.
> 
>> Gerg - ABI documentation.
>>    Nothing interesting here. I simply added 
>> 	Documentation/ABI/testing/sysfs-devices-system-cpu
>>    and documented some of the attributes exposed in there.
>>    Suggested by Andrew.
> 
> Not having seen the latest patches; I'm still not fond of the isolation
> interface.
> 
> 
> 
