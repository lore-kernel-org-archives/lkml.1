Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbXFLDoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbXFLDoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 23:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbXFLDop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 23:44:45 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55678 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbXFLDop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 23:44:45 -0400
Date: Tue, 12 Jun 2007 09:22:45 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: vatsa@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, wli@holomorphy.com,
       ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com, efault@gmx.de,
       pwil3058@bigpond.net.au, kernel@kolivas.org,
       linux-kernel@vger.kernel.org, dmitry.adamushko@gmail.com,
       tingy@cs.umass.edu, tong.n.li@intel.com, containers@lists.osdl.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [ckrm-tech] [RFC][PATCH 1/6] Introduce struct sched_entity and struct lrq
Message-ID: <20070612035245.GA3942@in.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070611154724.GA32435@in.ibm.com> <20070611155046.GA2109@in.ibm.com> <466E01DF.6080500@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466E01DF.6080500@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 07:45:59AM +0530, Balbir Singh wrote:
> > +/* CFS-related fields in a runqueue */
> > +struct lrq {
> > +	unsigned long raw_weighted_load;
> > +	#define CPU_LOAD_IDX_MAX 5
> > +	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
> > +	unsigned long nr_load_updates;
> > +
> > +	u64 fair_clock, delta_fair_clock;
> > +	u64 exec_clock, delta_exec_clock;
> > +	s64 wait_runtime;
> > +	unsigned long wait_runtime_overruns, wait_runtime_underruns;
> > +
> > +	struct rb_root tasks_timeline;
> > +	struct rb_node *rb_leftmost;
> > +	struct rb_node *rb_load_balance_curr;
> > +};
> > +
> 
> Shouldn't the rq->lock move into lrq?

Right now, the per-cpu rq lock protects all (local) runqueues attached with the 
cpu. At some point, for scalability reasons, we may want to split that to
be per-cpu per-local runqueue (as you point out). I will put that in my todo
list of things to consider. Thanks for the review!

-- 
Regards,
vatsa
