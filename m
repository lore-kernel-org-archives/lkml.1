Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440Ab0A2Sew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab0A2Sew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 13:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974Ab0A2Sev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 13:34:51 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43654 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923Ab0A2Seu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 13:34:50 -0500
Message-ID: <4B632A47.4070103@austin.ibm.com>
Date: Fri, 29 Jan 2010 12:34:47 -0600
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>, ego@in.ibm.com,
       linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/2] powerpc: implement arch_scale_smt_power for Power7
References: <1264017638.5717.121.camel@jschopp-laptop>	 <1264017847.5717.132.camel@jschopp-laptop>	 <1264548495.12239.56.camel@jschopp-laptop>	 <1264720855.9660.22.camel@jschopp-laptop>	 <1264721088.10385.1.camel@jschopp-laptop>	 <1264728185.20211.34.camel@pasglop> <1264760027.4283.2164.camel@laptop>
In-Reply-To: <1264760027.4283.2164.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> That said, I'm still not entirely convinced I like this usage of
> cpupower, its supposed to be a normalization scale for load-balancing,
> not a placement hook.
>   
Even if you do a placement hook you'll need to address it in the load 
balancing as well.  Consider a single 4 thread SMT core with 4 running 
tasks.  If 2 of them exit the remaining 2 will need to be load balanced 
within the core in a way that takes into account the dynamic nature of 
the thread power.  This patch does that.
> I'd be much happier with a SD_GROUP_ORDER or something like that, that
> works together with SD_PREFER_SIBLING to pack active tasks to cpus in
> ascending group order.
>
>   
I don't see this load-balancing patch as mutually exclusive with a patch 
to fix placement.  But even if it is a mutually exclusive solution there 
is no reason we can't fix things now with this patch and then later take 
it out when it's fixed another way.  This patch series is 
straightforward, non-intrusive, and without it the scheduler is broken 
on this processor. 
