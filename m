Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbYKXVr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbYKXVr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 16:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYKXVrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 16:47:17 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33156 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbYKXVrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 16:47:16 -0500
X-IronPort-AV: E=McAfee;i="5300,2777,5444"; a="13431113"
Message-ID: <492B20E3.5000900@qualcomm.com>
Date: Mon, 24 Nov 2008 13:47:15 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Dimitri Sivanich <sivanich@sgi.com>
CC: Li Zefan <lizf@cn.fujitsu.com>, Gregory Haskins <ghaskins@novell.com>,
       Derek Fults <dfults@sgi.com>, Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: RT sched: cpupri_vec lock contention with def_root_domain and
 no load balance
References: <20081104144017.GB30855@sgi.com> <4910634C.1020207@novell.com> <49246DD0.3010509@qualcomm.com> <4924762B.8000108@novell.com> <4924C770.7050107@qualcomm.com> <4926158B.9020909@novell.com> <49271449.2030804@qualcomm.com> <20081121211800.GA16647@sgi.com> <4927AECA.2040707@qualcomm.com> <4927C055.8030009@cn.fujitsu.com> <20081124151113.GB2292@sgi.com>
In-Reply-To: <20081124151113.GB2292@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitri Sivanich wrote:
> On Sat, Nov 22, 2008 at 04:18:29PM +0800, Li Zefan wrote:
>> Max Krasnyansky wrote:
>>> Dimitri Sivanich wrote:
>>>> Which is the way sched_load_balance is supposed to work. You need to set
>>>> sched_load_balance=0 for all cpusets containing any cpu you want to disable
>>>> balancing on, otherwise some balancing will happen.
>>> It won't be much of a balancing in this case because this just one cpu per
>>> domain.
>>> In other words no that's not how it supposed to work. There is code in
>>> cpu_attach_domain() that is supposed to remove redundant levels
>>> (sd_degenerate() stuff). There is an explicit check in there for numcpus == 1.
>>> btw The reason you got a different result that I did is because you have a
>>> NUMA box where is mine is UMA. I was able to reproduce the problem though by
>>> enabling multi-core scheduler. In which case I also get one redundant domain
>>> level CPU, with a single CPU in it.
>>> So we definitely need to fix this. I'll try to poke around tomorrow and figure
>>> out why redundant level is not dropped.
>>>
>> You were not using latest kernel, were you?
>>
>> There was a bug in sd degenerate code, and it has already been fixed:
>> 	http://lkml.org/lkml/2008/11/8/10
> 
> With the above patch added, we now see the results that Max is
> showing as far as individual root domains being created with a span
> of just their own cpu when sched_load_balance is turned off.

Nice.

Max
