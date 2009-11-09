Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbZKIJoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbZKIJoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbZKIJoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:44:32 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:59061 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737AbZKIJob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:44:31 -0500
Date: Mon, 9 Nov 2009 15:14:25 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: specjbb2005 and aim7 regression with 2.6.32-rc kernels
Message-ID: <20091109094425.GA26733@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <1257493130.16282.109.camel@ymzhang> <20091106080418.GB28227@elte.hu> <1257747597.16282.120.camel@ymzhang> <1257750573.6414.29.camel@marge.simson.net> <1257758104.4108.152.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257758104.4108.152.camel@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 10:15:04AM +0100, Peter Zijlstra wrote:
> On Mon, 2009-11-09 at 08:09 +0100, Mike Galbraith wrote:
> > +       smp_read_barrier_depends();
> >         cpumask_setall(cpus);
> > +       cpumask_and(cpus, cpus, cpu_online_mask);
> 
> 
> how about: cpumask_copy(cpus, cpu_online_mask); ?
> 
> Also, iirc cpu_online_mask is guaranteed stable when preemption is
> disabled, otherwise you need to use get/put_online_cpus(), an
> rmb_depends() won't do.

preempt_disable() guarantees that any cpus won't go offline, since we
use stop_machine() to take CPUs offline. I don't think it provides cover
against new cpus coming online.

-- 
Thanks and Regards
gautham
