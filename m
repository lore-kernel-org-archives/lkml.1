Return-Path: <linux-kernel-owner+w=401wt.eu-S1762813AbZBYLZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762813AbZBYLZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 06:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760842AbZBYLZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 06:25:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:36115 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759820AbZBYLZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 06:25:42 -0500
Subject: Re: [RFC PATCH 2/2] Add per-cgroup CPU controller statistics
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090225112003.GD4008@in.ibm.com>
References: <20090225105730.GA4008@in.ibm.com>
	 <20090225105920.GC4008@in.ibm.com> <1235559850.4645.3210.camel@laptop>
	 <20090225112003.GD4008@in.ibm.com>
Content-Type: text/plain
Date: Wed, 25 Feb 2009 12:24:58 +0100
Message-Id: <1235561098.4645.3237.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-25 at 16:50 +0530, Bharata B Rao wrote:
> On Wed, Feb 25, 2009 at 12:04:10PM +0100, Peter Zijlstra wrote:
> > On Wed, 2009-02-25 at 16:29 +0530, Bharata B Rao wrote:
> > > From: Balaji Rao <balajirrao@gmail.com>
> > > 
> > > sched: Add cpu controller statistics
> > > 
> > > Add per-cgroup cpu controller statistics like system time and user time
> > > consumed by groups of tasks.
> > 
> > Do we want this unconditionally?
> 
> Not sure if I understand you correctly here, but we are collecting
> stats only when CONFIG_CGROUP_SCHED.
> 
> Or do you mean we need a config option to enable stats collection ?
> If so, we have memory controller already providing stats unconditionally.

OK, I guess so ;-)

> > >  
> > > +#ifdef CONFIG_CGROUP_SCHED
> > > +static void account_task_group_time(struct task_struct *p,
> > > +			enum cpu_cgroup_stat_index idx, int val)
> > > +{
> > > +	struct task_group *tg = task_group(p);
> > > +
> > > +	if (likely(tg->stat))
> > > +		percpu_counter_add(&tg->stat->cpustat[idx], val);
> > > +}
> > > +#else
> > > +#define account_task_group_time(x, y, z)	{ 0; }
> > 
> > inline please, so we get argument validation.
> 
> Actually wanted to inline, but one of the arguments (cpu_cgroup_stat_index)
> is defined only CONFIG_CGROUP_SCHED. Hence didn't want argument
> validation here.

Just pull the enum outside of the ifdef?

