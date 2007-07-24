Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbXGXVJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbXGXVJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbXGXVJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:09:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbXGXVJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:09:38 -0400
Message-ID: <46A66A88.8070307@redhat.com>
Date: Tue, 24 Jul 2007 17:09:28 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Li, Tong N" <tong.n.li@intel.com>
CC: Chris Friesen <cfriesen@nortel.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com>	 <46A53C88.6060006@redhat.com>	 <Pine.LNX.4.64.0707240954560.8026@tongli.jf.intel.com>	 <46A64002.8080103@redhat.com> <46A6576A.9020506@nortel.com>	 <46A66393.5000705@redhat.com> <1185310691.7737.40.camel@tongli.jf.intel.com>
In-Reply-To: <1185310691.7737.40.camel@tongli.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Li, Tong N wrote:
> On Tue, 2007-07-24 at 16:39 -0400, Chris Snook wrote:
> 
>> Divining the intentions of the administrator is an AI-complete problem and we're 
>> not going to try to solve that in the kernel.  An intelligent administrator 
>> could also allocate 50% of each CPU to a resource group containing all the 
>> *other* processes.  Then, when the other processes are scheduled out, your 
>> single task will run on whichever CPU is idle.  This will very quickly 
>> equilibrate to the scheduling ping-pong you seem to want.  The scheduler 
>> deliberately avoids this kind of migration by default because it hurts cache and 
>> TLB performance, so if you want to override this very sane default behavior, 
>> you're going to have to explicitly configure it yourself.
>>
> 
> Well, the admin wouldn't specifically ask for 50% of each CPU. He would
> just allocate 50% of total CPU time---it's up to the scheduler to
> fulfill that. If a task is entitled to one CPU, then it'll stay there
> and have no migration. Migration occurs only if there's overload, in
> which case I think you agree in your last email that the cache and TLB
> impact is not an issue (at least in SMP).

I don't think Chris's scenario has much bearing on your patch.  What he wants is 
to have a task that will always be running, but can't monopolize either CPU. 
This is useful for certain realtime workloads, but as I've said before, realtime 
requires explicit resource allocation.  I don't think this is very relevant to 
SCHED_FAIR balancing.

	-- Chris
