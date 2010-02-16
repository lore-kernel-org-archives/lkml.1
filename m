Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957Ab0BPStS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 13:49:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:38564 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368Ab0BPStQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 13:49:16 -0500
Subject: Re: [patch] sched: fix SMT scheduler regression in
 find_busiest_queue()
From: Peter Zijlstra <peterz@infradead.org>
To: svaidy@linux.vnet.ibm.com
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, ego@in.ibm.com
In-Reply-To: <20100216182346.GA19327@dirshya.in.ibm.com>
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
	 <20100213182748.GB5882@dirshya.in.ibm.com>
	 <20100213202552.GI5882@dirshya.in.ibm.com>
	 <20100213203611.GJ5882@dirshya.in.ibm.com>
	 <1266142318.5273.407.camel@laptop>
	 <20100215123538.GE8006@dirshya.in.ibm.com>
	 <1266238843.15770.323.camel@laptop>
	 <20100216155906.GC8777@dirshya.in.ibm.com>
	 <1266341325.9432.283.camel@laptop>
	 <20100216182346.GA19327@dirshya.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Feb 2010 19:48:55 +0100
Message-ID: <1266346135.9432.370.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-16 at 23:55 +0530, Vaidyanathan Srinivasan wrote:
> The sched_domain will be rebuilt with the sched_group_cpus()
> representing only online siblings right?  sched_group_cpus(group) will
> always be a subset of cpu_active_mask.  Can please explain your
> comment. 

__build_*_sched_domain() seems to only rebuild the sd->span, not the
sched_group's mask, cpu_to_*_group() only picks an existing group based
on the cpumask passed in, it doesn't change sg->cpumask afaict.

That is also the reason we drag load_balance_tmpmask all through
load_balance() afaict.




