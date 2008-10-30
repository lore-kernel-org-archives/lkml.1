Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbYJ3RQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbYJ3RQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbYJ3RQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:16:36 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:58195 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYJ3RQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:16:35 -0400
Date: Thu, 30 Oct 2008 22:46:22 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, bharata@linux.vnet.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting
	controller
Message-ID: <20081030171622.GA19872@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20081023054335.GC3280@in.ibm.com> <6599ad830810230849x71961a0asd7f00d3baa2f2271@mail.gmail.com> <20081024050830.GA4387@in.ibm.com> <6599ad830810241037h575ec17bgb43f750d99bd1518@mail.gmail.com> <20081025060157.GA4614@in.ibm.com> <6599ad830810250838q3f96644bm6dfee8ba9f35dfa3@mail.gmail.com> <20081027101703.e954071d.kamezawa.hiroyu@jp.fujitsu.com> <20081027044319.GA4386@in.ibm.com> <661de9470810262357y6c560facl87dcaea3ce35e3ac@mail.gmail.com> <49057ADD.1050705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49057ADD.1050705@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 04:25:01PM +0800, Li Zefan wrote:
> >>>> So in technical terms this patch looks fine now. There's still the
> >>>> question of whether it's OK to change the existing API, since it's
> >>>> been in the kernel in its currently (non-hierarchical) form for
> >>>> several releases now.
> >> Hmm... Can we consider this as an API change ? Currently cpuacct.usage
> >> readers of a parent accounting group are missing the usage contributions
> >> from its children groups. I would consider this patch as fixing the
> >> above problem by correctly reflecting the cpu usage for every accounting
> >> group.
> >>
> > 
> > If a particular application desires to derive the usage of its
> > immediate tasks and does not care about subcgroups, it is a simple
> > iteration (after this fix)
> > 
> > cpuacct - sigma(cpuacct_child)
> > 
> > and currently if we cared about child accounting, we could do
> > 
> > cpuacct + recursively(sigma(cpuacct_child))
> > 
> > In that sense this fix makes more sense, but like Paul said we need to
> > figure out if it is an API change. My take is that it is a BUG fix,
> > since we do care about child subgroups in accounting.
> > 
> 
> cpuacct was designed to count cpu usage of a group of tasks, and now some people
> want it to also take child group's usage into account, so I think this is a feature
> request but not a bug fix.
> 

I disagree. The child is a part of the parent's hierarchy, and therefore
its usage should reflect in the parent's usage.

Thanks,
-- 
regards,
Dhaval
