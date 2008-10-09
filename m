Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbYJIWvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbYJIWvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 18:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbYJIWvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 18:51:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44936 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbYJIWvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 18:51:41 -0400
Message-ID: <48EE8AB2.5000302@redhat.com>
Date: Thu, 09 Oct 2008 18:50:26 -0400
From: Chris Snook <csnook@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Alok kataria <alokkataria1@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jeff Hansen <x@jeffhansen.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH] Re: x86_32 tsc/pit and hrtimers
References: <Pine.LNX.4.64.0810071640110.25661@ren>	 <48ED1728.5060708@redhat.com> <Pine.LNX.4.64.0810081542300.14815@ren>	 <48ED2A89.3000902@redhat.com> <Pine.LNX.4.64.0810081554380.14982@ren>	 <alpine.LFD.2.00.0810090910510.3237@apollo>	 <48EE4FC4.7070902@redhat.com>	 <alpine.LFD.2.00.0810092118100.3271@apollo>	 <Pine.LNX.4.64.0810091344250.24851@ren>	 <alpine.LFD.2.00.0810092152410.3271@apollo>	 <35f686220810091345h253d71e8s4fe9d7ea8e636ccc@mail.gmail.com>	 <48EE71A9.2010907@redhat.com> <1223589220.32639.24.camel@alok-dev1>
In-Reply-To: <1223589220.32639.24.camel@alok-dev1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> On Thu, 2008-10-09 at 14:03 -0700, Chris Snook wrote:
>> Alok kataria wrote:
>>> On Thu, Oct 9, 2008 at 12:53 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>>>> On Thu, 9 Oct 2008, Jeff Hansen wrote:
>>>>
>>>>> OK, so are we all agreed that something like clocksource_trust=tsc would be
>>>>> the best?
>>>> No, it's per affected device: tsc=trust or tsc=stable or whatever
>>>> unintuitive name we want to come up. And it is a modification to TSC
>>>> not to the clocksource layer.
>>> Yep, this is cool. I too have a patch in my local tree which does a
>>> similar thing i have a tsc_reliable flag which is set right now only
>>> when we are running under a VMware hypervisor.
>>> Along with marking the no_verify flag for TSC, this patch of mine also
>>> skips the TSC synchornization checks.
>>>
>>>         The TSC synchronization loop which is run whenever a new cpu is
>>> brought up is not actually needed on systems which are known to have a
>>> reliable TSC. TSC between 2 cpus can be off by a marginal value on such
>>> systems and thats okay for timekeeping, since we do check for tsc going
>>> back in read_tsc.
>>>
>>> Can this reasoning be included and synchronization skipped for all
>>> these systems with reliable aka trustworthy TSC's  ?
>> In general, no.  Not all hardware/hypervisors behave this way, even when the TSC
>> is otherwise stable once synchronized.
> 
> I agree that in general this should be no, but since this is a
> commandline variable it will be normally set for only those systems
> which have only TSC as a option or know that the TSC is reliable.
> wouldn't doing this be ok for such systems ? 

Hardware doesn't deliberately do any TSC synchronization, though you might get 
it by accident in some configurations.  A VMware guest gets it for free thanks 
to the hypervisor doing it in software, but we need to run the check when we're 
booting on bare metal.  Jeff's patch enables the feature with as little risk as 
possible.  TSC sync is pretty cheap, so it's not worth it to add a more 
dangerous special case just for guests of certain hypervisors.

-- Chris
