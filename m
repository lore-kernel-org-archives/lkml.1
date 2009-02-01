Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbZBAK5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbZBAK5h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 05:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbZBAK53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 05:57:29 -0500
Received: from ozlabs.org ([203.10.76.45]:49270 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbZBAK52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 05:57:28 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sched_rt: don't use first_cpu on cpumask created with cpumask_and.
Date: Sun, 1 Feb 2009 21:27:16 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Steven Rostedt <rostedt@goodmis.org>
References: <200901312321.25344.rusty@rustcorp.com.au> <20090131134947.GA23973@elte.hu>
In-Reply-To: <20090131134947.GA23973@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902012127.17150.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 February 2009 00:19:47 Ingo Molnar wrote:
> 
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > Ingo, please apply to tip/urgent.
> > 
> > cpumask_and() only initializes nr_cpu_ids bits, so the (deprecated)
> > first_cpu() might find one of those uninitialized bits if nr_cpu_ids
> > is less than NR_CPUS (as it can be for CONFIG_CPUMASK_OFFSTACK).
> > 
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > ---
> >  kernel/sched_rt.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Applied to tip/sched/urgent, thanks Rusty!
> 
> Also, Git sorted out the same-content merge with this commit in cpus4096 
> just fine:
> 
>   d38b223: cpumask: reduce stack usage in find_lowest_rq
> 
> (this commit is where you backported it from i suspect?)

No, this was a clean audit on current Linus' tree.  I wanted to make sure that
what Linus had worked...

Thanks,
Rusty.
