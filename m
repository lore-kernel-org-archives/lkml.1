Return-Path: <linux-kernel-owner+w=401wt.eu-S1751801AbZFHEh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbZFHEh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 00:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbZFHEhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 00:37:16 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:39093 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbZFHEhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 00:37:15 -0400
Date: Mon, 8 Jun 2009 10:07:06 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, kvm@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       bharata@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] CPU hard limits
Message-ID: <20090608043705.GC16211@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20090604053649.GA3701@in.ibm.com> <6599ad830906050153i1afd104fqe70f681317349142@mail.gmail.com> <20090605113217.GA20786@in.ibm.com> <6599ad830906050518t6cd7d477h36a187f2eaf55578@mail.gmail.com> <20090607101120.GB16211@in.ibm.com> <661de9470906070835l383cd388h67e40a31be07aef6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <661de9470906070835l383cd388h67e40a31be07aef6@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 09:05:23PM +0530, Balbir Singh wrote:
> > On further thinking, this is not as simple as that. In above example of
> > 5 tasks on 4 CPUs, we could cap each task at a hard limit of 80%
> > (4 CPUs/5 tasks), which is still not sufficient to ensure that each
> > task gets the perfect fairness of 80%! Not just that, hard-limit
> > for a group (on each CPU) will have to be adjusted based on its task
> > distribution. For ex: a group that has a hard-limit of 25% on a 4-cpu
> > system and that has a single task, is entitled to claim a whole CPU. So
> > the per-cpu hard-limit for the group should be 100% on whatever CPU the
> > task is running. This adjustment of per-cpu hard-limit should happen
> > whenever the task distribution of the group across CPUs change - which
> > in theory would require you to monitor every task exit/migration
> > event and readjust limits, making it very complex and high-overhead.
> >
> 
> We already do that for shares right? I mean instead of 25% hard limit,
> if the group had 25% of the shares the same thing would apply - no?

yes and no. we do rebalance shares based on task distribution, but not
upon every task fork/exit/wakeup/migration event. Its done once in a while,
frequent enough to give "decent" fairness!

> > Balbir,
> >        I dont think guarantee can be met easily thr' hard-limits in
> > case of CPU resource. Atleast its not as straightforward as in case of
> > memory!
> 
> OK, based on the discussion - leaving implementation issues out,
> speaking of whether it is possible to implement guarantees using
> shares? My answer would be
> 
> 1. Yes - but then the hard limits will prevent you and can cause idle
> times, some of those can be handled in the implementation. There might
> be other fairness and SMP concerns about the accuracy of the fairness,
> thank you for that data.
> 2. We'll update the RFC (second version) with the findings and send it
> out, so that the expectations are clearer
> 3. From what I've read and seen there seems to be no strong objection
> to hard limits, but some reservations (based on 1) about using them
> for guarantees and our RFC will reflect that.
> 
> Do you agree?

Well yes, guarantee is not a good argument for providing hard limits.
Pay-per-use kind of usage would be a better argument IMHO.

- vatsa
