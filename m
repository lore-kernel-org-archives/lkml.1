Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbYHVNrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbYHVNrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 09:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbYHVNr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 09:47:27 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51112 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbYHVNr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 09:47:26 -0400
Date: Fri, 22 Aug 2008 06:47:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org
Subject: Re: [PATCH, RFC, tip/core/rcu] scalable classic RCU implementation
Message-ID: <20080822134720.GG6875@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080822043715.GD15212@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822043715.GD15212@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 06:37:15AM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > +#define MAX_RCU_LEVELS 3
> > +#if NR_CPUS <= CONFIG_RCU_FANOUT
> > +#define NUM_RCU_LEVELS 1
> > +#define NUM_RCU_LEVEL_1 1
> > +#define NUM_RCU_LEVEL_2 NR_CPUS
> > +#define NUM_RCU_LEVEL_3 0
> > +#define NUM_RCU_LEVEL_4 0
> > +#define NUM_RCU_NODES NUM_RCU_LEVEL_1
> > +#elif NR_CPUS <= CONFIG_RCU_FANOUT * CONFIG_RCU_FANOUT
> > +#define NUM_RCU_LEVELS 2
> > +#define NUM_RCU_LEVEL_1 1
> > +#define NUM_RCU_LEVEL_2 \
> > +	(((NR_CPUS) + (CONFIG_RCU_FANOUT) - 1) / (CONFIG_RCU_FANOUT))
> > +#define NUM_RCU_LEVEL_3 NR_CPUS
> > +#define NUM_RCU_LEVEL_4 0
> > +#define NUM_RCU_NODES \
> > +	((NUM_RCU_LEVEL_1) + (NUM_RCU_LEVEL_2))
> > +#elif NR_CPUS <= CONFIG_RCU_FANOUT * CONFIG_RCU_FANOUT * CONFIG_RCU_FANOUT
> > +#define NUM_RCU_LEVELS 3
> > +#define RCU_FANOUT_SQ ((CONFIG_RCU_FANOUT) * (CONFIG_RCU_FANOUT))
> > +#define NUM_RCU_LEVEL_1 1
> > +#define NUM_RCU_LEVEL_2 \
> > +	(((NR_CPUS) + (RCU_FANOUT_SQ) - 1) / (RCU_FANOUT_SQ))
> > +#define NUM_RCU_LEVEL_3 \
> > +	((NR_CPUS) + (CONFIG_RCU_FANOUT) - 1) / (CONFIG_RCU_FANOUT)
> > +#define NUM_RCU_LEVEL_4 NR_CPUS
> > +#define NUM_RCU_NODES \
> > +	((NUM_RCU_LEVEL_1) + \
> > +	 (NUM_RCU_LEVEL_2) + \
> > +	 (NUM_RCU_LEVEL_3))
> > +#else
> > +#error "CONFIG_RCU_FANOUT insufficient for NR_CPUS"
> > +#endif
> 
> just a quick stylistic suggestion: if feasible then such sizing ugliness 
> should be hidden in a Kconfig file. (if Kconfig is capable enough for 
> this that is)

I have no idea if Kconfig can do it, but I will check.

							Thanx, Paul
