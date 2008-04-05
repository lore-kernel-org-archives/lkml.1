Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbYDEU7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbYDEU7f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 16:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbYDEU70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 16:59:26 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:38280 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbYDEU7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 16:59:25 -0400
Date: Sun, 6 Apr 2008 02:29:14 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Balaji Rao <balajirrao@gmail.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.osdl.org, menage@google.com,
       a.p.zijlstra@chello.nl, balbir@in.ibm.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [RFC][-mm] [1/2] Simple stats for cpu resource controller
Message-ID: <20080405205914.GA25009@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <200804052339.46632.balajirrao@gmail.com> <20080405194041.GB21279@linux.vnet.ibm.com> <200804060201.52726.balajirrao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804060201.52726.balajirrao@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2008 at 02:01:52AM +0530, Balaji Rao wrote:
> On Sunday 06 April 2008 01:10:41 am Dhaval Giani wrote:
> > > +};
> > > +
> > > +struct cpu_cgroup_stat_cpu {
> > > +	s64 count[CPU_CGROUP_STAT_NSTATS];
> > 
> > u64? time does not go negative :)
> Right. But these stats are not only going to measure time. We need the same 
> variables for measuring other stats as well. I'm not sure if we would 
> encounter scheduler stats that would count negative.
> 
> Balbir, what do you say ?

I would prefer to keep the stats logically separate. So something like
struct cpu_cgroup_stat_cpu {
	u64 time[];
	s64 some_other_stat;
}
and so on. (I am not sure, is there some advantage gained by using
structs?) Makes the code more maintainable imho.

> 
> > count also is not very clear? Can you give a more descriptive name?
> > 
> ok. How does 'value' look  ?
> 
> <snip>
> 
> > > +static s64 cpu_cgroup_read_stat(struct cpu_cgroup_stat *stat,
> > > +		enum cpu_cgroup_stat_index idx)
> > > +{
> > > +	int cpu;
> > > +	s64 ret = 0;
> > > +	unsigned long flags;
> > 
> > > +
> > > +	local_irq_save(flags);
> > 
> > I am just wondering. Is local_irq_save() enough?
> > 
> Hmmm.. You are right.This does not prevent concurrent updates on other CPUs 
> from crossing a 32bit boundary. Am not sure how to do this in a safe way. I 
> can only think of using atomic64_t now..
> 

I am going to answer that one when I am awake :-)

-- 
regards,
Dhaval
