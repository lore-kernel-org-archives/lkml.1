Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbXFFHfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbXFFHfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 03:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbXFFHfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 03:35:06 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59664 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbXFFHfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 03:35:03 -0400
Date: Wed, 6 Jun 2007 13:13:17 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS scheduler, -v15
Message-ID: <20070606074317.GB3274@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070531150908.GA23538@elte.hu> <20070606064228.GA22443@in.ibm.com> <20070606070143.GA7375@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606070143.GA7375@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 09:01:43AM +0200, Ingo Molnar wrote:
> [...] and my tree already contains the fixes for rt task's 
> exec_start. 

Can I have this snapshot pls? I have to deal with the same issue when 
the current task switches groups and I was planning to fix it by
introducing a set_curr_task() method in fair_sched_class which
initializes exec_start and other fields for that task.

> > Also, real-time tasks are currently influencing fair clock 
> > calculations (because there is only one raw_weighted_load field per 
> > runqueue). Is that intentional?
> 
> yep - the 'fair clock' in essence freezes when RT tasks are running (but 
> not completely). Can you think of any bad effect from this perhaps?

hmm ..i was thinking of the case where currently running task belongs to 
fair_sched class but the raw_weighted_load field of runqueue includes
weight from real time tasks (which would have affected the delta_mine
calculation). Now I realize that it is not possible because real-time
tasks always preempt fair-sched tasks. So possibly this is not an issue.

> It's useful to have unified load-balancing (smpnice-driven) between the RT 
> and fair classes.

Sure ..the unified weight number is usefull to pick the busiest
group/queue during load balance. I am retaining this aspect in my
patches (which I am preparing to send against -v15 atm).

-- 
Regards,
vatsa
