Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab0BSTxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 14:53:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:54311 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614Ab0BSTxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 14:53:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,505,1262592000"; 
   d="scan'208";a="597456083"
Subject: Re: change in sched cpu_power causing regressions with SCHED_MC
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "ego@in.ibm.com" <ego@in.ibm.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
In-Reply-To: <1266608875.1529.749.camel@laptop>
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
	 <1266024679.2808.153.camel@sbs-t61.sc.intel.com>
	 <1266057388.557.59599.camel@twins>
	 <1266545807.2909.46.camel@sbs-t61.sc.intel.com>
	 <1266588316.1529.370.camel@laptop>
	 <1266604594.2814.37.camel@sbs-t61.sc.intel.com>
	 <1266608875.1529.749.camel@laptop>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 19 Feb 2010 11:50:29 -0800
Message-Id: <1266609029.4729.1.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-19 at 11:47 -0800, Peter Zijlstra wrote:
> On Fri, 2010-02-19 at 10:36 -0800, Suresh Siddha wrote:
> > exec/fork balance is not broken. i.e., during exec/fork we balance the
> > load equally among sockets/cores etc. What is broken is:
> > 
> > a) In SMT case, once we end up in a situation where both the threads of
> > the core are busy , with another core completely idle, load balance is
> > not moving one of the threads to the idle core. This unbalanced
> > situation can happen because of a previous wake-up decision and/or
> > threads on other core went to sleep/died etc. Once we end up in this
> > unbalanced situation, we continue in that state with out fixing it.
> > 
> > b) Similar to "a", this is MC case where we end up four cores busy in
> > one socket with other 4 cores in another socket completely idle. And
> > this is the situation which we are trying to solve in this patch.
> > 
> > In your above example, we test mostly fork/exec balance but not the
> > above sleep/wakeup scenarios. 
> 
> Ah, indeed. Let me extend my script to cover that.
> 
> The below script does indeed show a change, but the result still isn't
> perfect, when I do ./show-loop 8, it starts 8 loops nicely spread over 2
> sockets, the difference is that all 4 remaining would stay on socket 0,
> the patched kernel gets 1 over to socket 1.

Peter, Have you applied both my smt patch and mc patch?

thanks,
suresh

