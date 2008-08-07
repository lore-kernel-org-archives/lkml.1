Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbYHGDTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbYHGDTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 23:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbYHGDTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 23:19:24 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:40287 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbYHGDTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 23:19:23 -0400
Date: Wed, 6 Aug 2008 20:19:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Gautham Shenoy <ego@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/2] rcu classic: new algorithm for
	callbacks-processing(v2)
Message-ID: <20080807031920.GB6910@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <48708F2F.2060406@cn.fujitsu.com> <20080718140930.GT6875@elte.hu> <20080721100433.GC8384@linux.vnet.ibm.com> <20080801211053.GZ14851@linux.vnet.ibm.com> <489565BC.3000408@cn.fujitsu.com> <20080804225438.GA18866@linux.vnet.ibm.com> <48994DDA.70205@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48994DDA.70205@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 03:08:10PM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> [...]
> > 
> > Tell me more about percpu_ptr().
> 
> Sorry about this. percpu_ptr is used for dynamic allocation percpu pointer.

Yep, that I knew.

> It seems that we cannot get a pointer from a static declare percpu data
> which can be used as a dynamic allocation percpu data's pointer. 

Sad but true...  Ran into this with SRCU a couple of years back.  :-/

> > 
> [...]
> > 
> > I have a somewhat different goal here.  I want to simplify the memory
> > ordering design without giving up too much performance -- the current
> > state in mainline is much too fragile, in my opinion, especially given
> > that the grace-period code paths are not fastpaths.
> > 
> > Next step -- hierarchical grace-period detection to handle the 4096-CPU
> > machines that I was being buttonholed about at OLS...
> > 
> > Would you be interested in applying your multi-tailed list change to
> > preemptable RCU?
> > 
> It's not necessary. Actually I like one tail per list which is good for
> readability. 
> 
> But in my patch, the most work is combining lists, not
> moving a list to next list, so i use multi-tailed simplify this works
> and others(etc: "if (rdp->nxtlist)" will be changed to be a more
> complex and less readability statement if i use one-tail-per-list)
> 
> These not means multi-tailed is good thing.

It does indeed depend on the details of the implementation.

							Thanx, Paul
