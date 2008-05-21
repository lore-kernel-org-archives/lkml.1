Return-Path: <linux-kernel-owner+w=401wt.eu-S936366AbYEUR6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936366AbYEUR6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933984AbYEUR6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:58:13 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27839 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932912AbYEUR6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:58:11 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5300"; a="3124121"
Message-ID: <483462B1.6050501@qualcomm.com>
Date: Wed, 21 May 2008 10:58:09 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: a.p.zijlstra@chello.nl, menage@google.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: IRQ affinities
References: <47D73086.2030008@qualcomm.com>	<6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>	<47D7411E.1000009@qualcomm.com>	<6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>	<47D74595.4080100@qualcomm.com>	<6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>	<20080311235939.1ebee8e3.pj@sgi.com>	<47D81FE1.6030205@qualcomm.com>	<20080312135746.89456f2a.pj@sgi.com>	<47D82AD2.1070108@qualcomm.com>	<20080312143253.3dd72c7f.pj@sgi.com>	<47D83858.4030806@qualcomm.com>	<20080312153712.bc5df7a1.pj@sgi.com>	<47D8593A.6040503@qualcomm.com>	<20080312183059.6716d630.pj@sgi.com>	<47D87BE5.4010702@qualcomm.com>	<20080313020300.92244956.pj@sgi.com>	<47FE5655.10900@qualcomm.com>	<20080414133902.7878cfce.pj@sgi.com>	<1210329926.13978.224.camel@twins>	<20080509061727.5057de1f.pj@sgi.com>	<48337792.20606@qualcomm.com> <20080521013424.6600780a.pj@sgi.com>
In-Reply-To: <20080521013424.6600780a.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Paul Jackson wrote:
> Max wrote:
>> What I realized now is that all I need is
>> /proc/irq/default_smp_affinity.
> 
> I suspect that something like you're proposing to do here will answer
> your needs, to "tell the kernel to not route IRQs to certain CPUs."
> 
> I suspect that other folks will have some additional needs, that perhaps
> my idea of May 9, 2008:
> 
>        How about this.  We add two files to each cpuset:
>        
>            irq_affinity_include	# IRQs to direct to CPUs in this cpuset
>            irq_affinity_exclude	# IRQs -not- to direct to these CPUs
>        
>        where irq_affinity_exclude overrides irq_affinity_include.
> 
> could meet.

I saw your earlier email with that proposal. Just had to digest it a bit :) 
(still catching up with things after vacation).

> So, to determine to which CPUs a given interrupt (IRQ) can be directed:
>  1) Combine (union) the 'cpus' of all the cpusets for which
>     that IRQ is in that cpusets irq_affinity_include, then
>  2) Remove (set substraction) the 'cpus' of any cpuset for which
>     that IRQ is in that cpusets irq_affinity_exclude.

That would work. But wouldn't it be hard for the users to debug things ? I 
mean if you have a complex cpuset hierarchy it may be hard to figure out why a 
certain irq is not getting to cpuX and vice versa.
btw How would we represent "all irqs", are you implying that those files 
contain masks ?
We'll also need to handle conflicts like "irq excluded from all cpusets", etc.
I still prefer "irq as a task" approach. It's very simple and straightforward 
  mapping of an irq -> cpuset, no conflicts, etc. Easy to figure out for the 
user where an irq will end up.

btw I did not quite get the idea behind the "exclude" part. Why is "include" 
not enough ? Can you give me an example.

> It makes sense to me to deal with your "default_smp_affinity" patch
> first, and then come back around and see what remains to be done, and
> how to do it, perhaps with additional cpuset based mechanisms such as
> the above two irq_affinity_* IRQ masks.
> 
>> I'm in the process of making a patch for exposing default affinity mask.
> 
> Peter, et al: how does Max's planned "default_smp_affinity" patch sound
> to you, as the next step we take on this?

I think it makes sense regardless of the cpuset based approach. Seems like a 
logical extension of the existing interface (ie per IRQ mask plus the default).

Max


