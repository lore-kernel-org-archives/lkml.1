Return-Path: <linux-kernel-owner+w=401wt.eu-S1761968AbZD3JCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761968AbZD3JCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 05:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbZD3JCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 05:02:06 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:47464 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbZD3JCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 05:02:05 -0400
Date: Thu, 30 Apr 2009 14:32:00 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v2] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu
	cputime count
Message-ID: <20090430090200.GF4430@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090430061806.GC4430@balbir.in.ibm.com> <1241081240.4756.38.camel@laptop> <20090430175112.D225.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090430175112.D225.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-04-30 17:52:16]:

> > > >  	for (i = 0; i < CPUACCT_STAT_NSTATS; i++) {
> > > > -		s64 val = percpu_counter_read(&ca->cpustat[i]);
> > > > +		s64 val = percpu_counter_sum(&ca->cpustat[i]);
> > > >  		val = cputime64_to_clock_t(val);
> > > >  		cb->fill(cb, cpuacct_stat_desc[i], val);
> > > >  	}
> > > 
> > > What do the test results look like with this? I'll see if I can find
> > > some time to test this patch. On a patch read level this seems much better
> > > to me, Peter?
> > 
> > I don't really fancy percpu_counter_sum() usage. I'm thinking its ok to
> > degrate accuracy on larger machines and simply use
> > percpu_counter_read().
> 
> I have same opinion with peter. Balbir, What do you think?
>

Sure, but the larger the delta gets, the less useful the metric gets
:) I am OK with going back to percpu_counter_read() if that is the
consensus. 

-- 
	Balbir
