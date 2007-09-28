Return-Path: <linux-kernel-owner+w=401wt.eu-S1760957AbXI1C34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760957AbXI1C34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 22:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757045AbXI1C3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 22:29:48 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58527 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbXI1C3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 22:29:48 -0400
Date: Fri, 28 Sep 2007 08:10:26 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, randy.dunlap@oracle.com,
       mingo@elte.hu, dmitry.adamushko@gmail.com, efault@gmx.de,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [PATCH -mm] Hook up group scheduler with control groups
Message-ID: <20070928024026.GA1044@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070927150624.GG4415@linux.vnet.ibm.com> <20070927104005.2ed0b81d.randy.dunlap@oracle.com> <20070927180415.GC5715@linux.vnet.ibm.com> <20070927120033.45915a61.randy.dunlap@oracle.com> <20070927193512.GD5715@linux.vnet.ibm.com> <20070927164241.ca034043.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927164241.ca034043.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 04:42:41PM -0700, Andrew Morton wrote:
> > @@ -219,6 +225,9 @@ static inline struct task_grp *task_grp(
> >  
> >  #ifdef CONFIG_FAIR_USER_SCHED
> >  	tg = p->user->tg;
> > +#elif CONFIG_FAIR_CGROUP_SCHED
> > +	tg = container_of(task_subsys_state(p, cpu_cgroup_subsys_id),
> > +				struct task_grp, css);
> >  #else
> >  	tg  = &init_task_grp;
> >  #endif
> 
> that's a bit funny-looking.  Are CONFIG_FAIR_CGROUP_SCHED and
> CONFIG_FAIR_USER_SCHED mutually exclusive?

Yes. While configuring kernel, user can choose only one of those options
and not both.

>  Doesn't seem that way.

Hmm ..why do you say that?

> if
> they're both defined then CONFIG_FAIR_USER_SCHED "wins".
> Anyway, please confirm that this is correct?

They can't both be defined.

> I'll switch that to `#elif defined(CONFIG_FAIR_CGROUP_SCHED)'.  We can get
> gcc warnings with `#if CONFIG_FOO', and people should be using `#ifdef
> CONFIG_FOO', so I assume the same applies to #elif.

Thx for fixing it!

-- 
Regards,
vatsa
