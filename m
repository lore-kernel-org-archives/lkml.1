Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbXGXVX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbXGXVX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbXGXVXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:23:17 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:50800 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbXGXVXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:23:16 -0400
Message-ID: <46A66DB8.4030608@nortel.com>
Date: Tue, 24 Jul 2007 15:23:04 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: "Li, Tong N" <tong.n.li@intel.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com> <46A53C88.6060006@redhat.com> <Pine.LNX.4.64.0707240954560.8026@tongli.jf.intel.com> <46A64002.8080103@redhat.com> <46A6576A.9020506@nortel.com> <46A66393.5000705@redhat.com> <1185310691.7737.40.camel@tongli.jf.intel.com> <46A66A88.8070307@redhat.com>
In-Reply-To: <46A66A88.8070307@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2007 21:23:12.0833 (UTC) FILETIME=[D742FB10:01C7CE38]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:

> I don't think Chris's scenario has much bearing on your patch.  What he 
> wants is to have a task that will always be running, but can't 
> monopolize either CPU. This is useful for certain realtime workloads, 
> but as I've said before, realtime requires explicit resource 
> allocation.  I don't think this is very relevant to SCHED_FAIR balancing.

I'm not actually using the scenario I described, its just sort of a 
worst-case load-balancing thought experiment.

What we want to be able to do is to specify a fraction of each cpu for 
each task group.  We don't want to have to affine tasks to particular cpus.

This means that the load balancer must be group-aware, and must trigger 
a re-balance (possibly just for a particular group) as soon as the cpu 
allocation for that group is used up on a particular cpu.

I haven't tried the latest CFS group scheduler patches, so they may 
provide the sort of accuracy we're looking for.  I'll have to try and 
find some time to test them out.

Chris
