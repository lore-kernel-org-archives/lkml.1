Return-Path: <linux-kernel-owner+w=401wt.eu-S1763329AbYB1ULW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763329AbYB1ULW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbYB1ULM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:11:12 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32837 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbYB1ULL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:11:11 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5241"; a="988320"
Message-ID: <47C7155C.5060607@qualcomm.com>
Date: Thu, 28 Feb 2008 12:11:08 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Paul Jackson <pj@sgi.com>, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       oleg@tv-sign.ru, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
References: <20080227222103.673194000@chello.nl> <20080228075010.GA28781@elte.hu> <20080228020808.3fd22f77.pj@sgi.com> <20080228090847.GA1133@elte.hu> <20080228031710.3405e405.pj@sgi.com> <20080228104637.GA9129@elte.hu>
In-Reply-To: <20080228104637.GA9129@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Paul Jackson <pj@sgi.com> wrote:
> 
>> But your words sound alot like what we at SGI call a 'boot' cpuset.
>>
>> Our big honkin NUMA customers, who are managing most of the system 
>> either for a few dedicated, very-important jobs, and/or under a batch 
>> scheduler, need to leave a few nodes to run the classic Unix load such 
>> as init, cron, assorted daemons and the admins login shell.
>>
>> So we provide them some init script mechanisms that make it easy to 
>> set this up, which includes moving every task (not many at the low 
>> numbered init script time this runs) that isn't pinned (doesn't have a 
>> restricted Cpus_allowed) into the boot cpuset, conventionally named 
>> /dev/cpuset/boot.
> 
> yes. Ideally Peter's patchset should turn into something equivalent and 
> i very much agree with Peter's arguments. There was never any design 
> level problem with cpusets, and the parallel cpu_isolated_map approach 
> was misdirected IMO.
> 
> There was indeed a problem with the _manageability_ of cpusets in 
> certain (rather new) usecases like real-time or virtualization, and how 
> they are connected to other system resources like IRQs and how easy it 
> is to manage these resources. IRQs should probably be tied to specific 
> cpusets and should migrate together with them, were the span of that 
> cpuset be changed. (by default they'd be tied to the boot cpuset)
> 
> IMO Peter's patchset is a good first step in that it removes the 
> cpu_isolated_map API hack, and i think we should try to go the whole way 
> and just offer a /dev/cpuset/boot/ default set that can then be 
> restricted to isolate the default workloads away from other CPUs.

I like the concept of the "boot" set. But we still need a separate "system"
flag. Users should not have to move cpu back into the "boot" set to allow for
kernel (irqs, etc) activity on it. And it's just more explicit and clear that way.

Max



