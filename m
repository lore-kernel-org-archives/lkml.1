Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbYG2Q7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbYG2Q7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 12:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYG2Q7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 12:59:08 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47280 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbYG2Q7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 12:59:07 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5349"; a="5145418"
Message-ID: <488F4C58.10705@qualcomm.com>
Date: Tue, 29 Jul 2008 09:59:04 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, pj@sgi.com,
       menage@google.com, vegard.nossum@gmail.com,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
References: <1216852381-23445-1-git-send-email-maxk@qualcomm.com>	 <488B7DC5.20302@qualcomm.com>  <20080728140748.GB18144@elte.hu> <1217313654.18049.59.camel@twins>
In-Reply-To: <1217313654.18049.59.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2008-07-28 at 16:07 +0200, Ingo Molnar wrote:
>> * Max Krasnyansky <maxk@qualcomm.com> wrote:
>>
>>> Max Krasnyansky wrote:
>>>> This is an updated version of my previous cpuset patch:
>>>>   "Make rebuild_sched_domains() usable from any context (take 2)"
>>> Folks,
>>>
>>> Any comments on this patch ? We need this to complete sched domain 
>>> handling fixes/improvements that we started with the cpu_active_map, 
>>> and to avoid circular locking issues in the cpu hotplug -> 
>>> rebuild_sched_domains path.
>> Paul, Peter, any comments?
> 
> I'm really not that at home with all that cgroup fiddling, so I'd like a
> word from the two Pauls..
> 
> Questions I have at the moment:
> 
>  -  do we really need a new workqueue for this? Can't we use the regular
> keventd stuff, now that Oleg fixed the get_online_cpus() thing?
> (3da1c84c00c7e5fa8348336bd8c342f9128b0f14)
No we do not. I was not sure when that will workqueue fix would go in.
I'll send a delta patch on top.

> - aren't there funny races with the async_rebuild_sched_domains()
> stuff? 
Rebuilds via cpu hotplug path are synchronous, which I believe is 
important.
Rebuilds caused by writes into /dev/cpuset do not have to be.  I cannot 
think of a scenario where race in that path would be an issue.

Max
