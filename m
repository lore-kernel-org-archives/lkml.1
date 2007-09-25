Return-Path: <linux-kernel-owner+w=401wt.eu-S1751917AbXIYJe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbXIYJe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 05:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbXIYJeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 05:34:21 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:60731 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbXIYJeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 05:34:20 -0400
Date: Tue, 25 Sep 2007 15:14:40 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20070925094440.GK26289@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070924214537.GA18980@elte.hu> <1190700652.6482.7.camel@Homer.simpson.net> <1190705759.11910.10.camel@Homer.simpson.net> <1190709207.11226.6.camel@Homer.simpson.net> <20070925091331.GA22905@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925091331.GA22905@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 11:13:31AM +0200, Ingo Molnar wrote:
> ok, i'm too seeing some sort of latency weirdness with 
> CONFIG_FAIR_GROUP_SCHED enabled, _if_ there's Xorg involved which runs 
> under root uid on my box - and hence gets 50% of all CPU time.
> 
> Srivatsa, any ideas? It could either be an accounting buglet (less 
> likely, seems like the group scheduling bits stick to the 50% splitup 
> nicely), or a preemption buglet. One potential preemption buglet would 
> be for the group scheduler to not properly preempt a running task when a 
> task from another uid is woken?

Yep, I noticed that too.

check_preempt_wakeup()
{
	...

	if (is_same_group(curr, p)) {
	    ^^^^^^^^^^^^^

		resched_task();
	}

}

Will try a fix to check for preemption at higher levels ..

-- 
Regards,
vatsa
