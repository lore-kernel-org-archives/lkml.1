Return-Path: <linux-kernel-owner+w=401wt.eu-S1762786AbXGXTsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762786AbXGXTsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbXGXTsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:48:06 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:45523 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbXGXTsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:48:05 -0400
Message-ID: <46A6576A.9020506@nortel.com>
Date: Tue, 24 Jul 2007 13:47:54 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: Tong Li <tong.n.li@intel.com>, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com> <46A53C88.6060006@redhat.com> <Pine.LNX.4.64.0707240954560.8026@tongli.jf.intel.com> <46A64002.8080103@redhat.com>
In-Reply-To: <46A64002.8080103@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2007 19:48:01.0698 (UTC) FILETIME=[8B28F020:01C7CE2B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:

> Concerns aside, I agree that fairness is important, and I'd really like 
> to see a test case that demonstrates the problem.

One place that might be useful is the case of fairness between resource 
groups, where the load balancer needs to consider each group separately.

Now it may be the case that trying to keep the load of each class within 
X% of the other cpus is sufficient, but it's not trivial.

Consider the case where you have a resource group that is allocated 50% 
of each cpu in a dual cpu system, and only have a single task in that 
group.  This means that in order to make use of the full group 
allocation, that task needs to be load-balanced to the other cpu as soon 
as it gets scheduled out.  Most load-balancers can't handle that kind of 
granularity, but I have guys in our engineering team that would really 
like this level of performance.

We currently use CKRM on an SMP machine, but the only way we can get 
away with it is because our main app is affined to one cpu and just 
about everything else is affined to the other.

We have another SMP box that would benefit from group scheduling, but we 
can't use it because the load balancer is not nearly good enough.

Chris
