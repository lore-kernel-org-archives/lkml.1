Return-Path: <linux-kernel-owner+w=401wt.eu-S1759747AbYA2MV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747AbYA2MV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 07:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbYA2MVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 07:21:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43235 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbYA2MVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 07:21:51 -0500
Subject: Re: scheduler scalability - cgroups, cpusets and load-balancing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Jackson <pj@sgi.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, vatsa@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       ebiederm@xmission.com, akpm@linux-foundation.org, sgrubb@redhat.com,
       rostedt@goodmis.org, ghaskins@novell.com, dmitry.adamushko@gmail.com,
       tong.n.li@intel.com, tglx@linutronix.de, menage@google.com,
       rientjes@google.com
In-Reply-To: <20080129055318.5b669847.pj@sgi.com>
References: <1201600428.28547.87.camel@lappy>
	 <20080129040130.7b2904b6.pj@sgi.com> <1201603816.28547.94.camel@lappy>
	 <20080129051353.4628c9eb.pj@sgi.com> <1201606284.28547.114.camel@lappy>
	 <20080129055318.5b669847.pj@sgi.com>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 13:07:37 +0100
Message-Id: <1201608457.28547.130.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-29 at 05:53 -0600, Paul Jackson wrote:
> Peter wrote;
> > So, I don't think we need that, I think we can do with the single flag,
> > we just need to find these disjoint sets and stick our rt-domain there. 
> 
> Ah - perhaps you don't need that flag - but my other cpuset users do ;).
> 
> You see, there are two very different ways that 'sched_load_balance' is
> used in practice.
> 
> The other way is by big batch schedulers.  They may be placed in charge
> of managing a few hundred CPUs on a system, and might be running a mix
> of many small jobs each covering only a few CPUs.  They routinely setup
> one cpuset for each job, to contain that job to the CPUs and memory
> nodes assigned to it.  This is actually the original motivating use for
> cpusets.
> 
> As a bit of optimization, batch schedulers desire to tell the normal
> kernel scheduler -not- to bother load balancing across the big set of
> CPUs controlled by the batch scheduler, but only to load balance within
> each of the smaller per-job cpusets.  Load balancing across hundreds
> of CPUs when the batch scheduler knows such efforts would be fruitless
> is a waste of good CPU cycles in kernel/sched.c.
> 
> I really doubt we'd want to have such systems triggering the hard RT
> scheduler on whatever CPUs were in the batch schedulers big cpuset
> that didn't happened to have an active job currently assigned to them.

My turn to be confused..

If SD_LOAD_BALANCE is only set on the smaller, per-job, sets, how will
the RT balancer trigger on the large set?


