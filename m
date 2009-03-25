Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbZCYEkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbZCYEkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 00:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbZCYEkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 00:40:22 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49707 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbZCYEkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 00:40:21 -0400
Date: Wed, 25 Mar 2009 10:10:39 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH -tip] cpuacct: per-cgroup utime/stime statistics - v5
Message-ID: <20090325044039.GB3276@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090324125710.GG3891@in.ibm.com> <49C97F43.7080302@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C97F43.7080302@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 08:48:03AM +0800, Li Zefan wrote:
> > cpuacct: Add stime and utime statistics
> > 
> > Add per-cgroup cpuacct controller statistics like the system and user
> > time consumed by the group of tasks.
> 
> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks.

> 
> except a bug below.
> 
> > +	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
> > +		if (percpu_counter_init(&ca->cpustat[i], 0))
> > +			goto out_free_counters;
> >  
> >  	if (cgrp->parent)
> >  		ca->parent = cgroup_ca(cgrp->parent);
> >  
> >  	return &ca->css;
> > +
> > +out_free_counters:
> > +	i--;
> > +	while (i-- >= 0)
> > +		percpu_counter_destroy(&ca->cpustat[i]);
> 
> replace "i--; while (i-- >=0)" to "while (--i >=0)", otherwise
> you'll be accessing ca->cpustat[-1].

Sorry about this. Posted the fixed version.

Regards,
Bharata.
