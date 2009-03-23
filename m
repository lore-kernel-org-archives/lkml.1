Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZCWQV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZCWQV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbZCWQVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:21:16 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:57397 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbZCWQVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:21:15 -0400
Date: Mon, 23 Mar 2009 21:51:23 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH -tip] cpuacct: per-cgroup utime/stime statistics - v4
Message-ID: <20090323162123.GA3858@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090323043538.GB3306@in.ibm.com> <20090323042123.87a673ac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323042123.87a673ac.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 04:21:23AM -0700, Andrew Morton wrote:
> On Mon, 23 Mar 2009 10:05:38 +0530 Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:
> 
> > +static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
> > +		struct cgroup_map_cb *cb)
> > +{
> > +	struct cpuacct *ca = cgroup_ca(cgrp);
> > +	int i;
> > +
> > +	for (i = 0; i < CPUACCT_STAT_NSTATS; i++) {
> > +		s64 val = percpu_counter_read(&ca->cpustat[i]);
> > +		val = cputime_to_clock_t(val);
> > +		cb->fill(cb, cpuacct_stat_desc[i], val);
> > +	}
> > +	return 0;
> > +}
> 
> I'd have expected `val' to have type clock_t.  But clock_t is 32-bit on
> 32-bit x86.
> 
> Is it correct to pass a 64-bit value to a function which takes a 32-bit
> value and to then copy the 32-bit return value into a 64-bit variable?

Yes, doesn't look neat. Since the accumulated stat(val here) is of 64bit type,
I could use cputime64_to_clock_t(val) in the above code. Storing the resulting
32bit clock_t in a 64 bit variable(which will be used by cb->fill) should be
fine I believe. Let me know if I got this right.

Regards,
Bharata.
