Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbYJCPNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbYJCPNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbYJCPNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:13:11 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49578 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbYJCPNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:13:10 -0400
Date: Fri, 3 Oct 2008 08:13:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       akpm@linux-foundation.org, laijs@cn.fujitsu.com,
       manfred@colorfullife.com, dipankar@in.ibm.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, josht@linux.vnet.ibm.com,
       ltt-dev@lists.casi.polymtl.ca
Subject: Re: [PATCH tip/master] RCU-based detection of stalled CPUs for
	Classic RCU
Message-ID: <20081003151306.GB6246@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081002003628.GA7877@linux.vnet.ibm.com> <20081002080726.GB17695@elte.hu> <20081002140507.GB6729@linux.vnet.ibm.com> <20081002151046.GB2473@Krystal> <20081002174318.GB7324@linux.vnet.ibm.com> <20081002185115.GA11047@Krystal> <20081002225537.GA6706@linux.vnet.ibm.com> <20081002230639.GA7522@linux.vnet.ibm.com> <20081003083947.GB7636@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003083947.GB7636@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 10:39:47AM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Hello!
> > 
> > This patch adds stalled-CPU detection to Classic RCU.  This capability 
> > is enabled by a new config variable CONFIG_RCU_CPU_STALL_DETECTOR, 
> > which defaults disabled.  This is a debugging feature to detect 
> > infinite loops in kernel code, not something that non-kernel-hackers 
> > would be expected to care about.  This feature can detect looping CPUs 
> > in !PREEMPT builds and looping CPUs with preemption disabled in 
> > PREEMPT builds.  This is essentially a port of this functionality from 
> > the treercu patch, replacing the stall debug patch that is already in 
> > tip/core/rcu (commit 67182ae1c4).
> > 
> > The changes from the patch in tip/core/rcu include making the config 
> > variable name match that in treercu, changing from seconds to jiffies 
> > to avoid spurious warnings, and printing a boot message when this 
> > feature is enabled.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> applied to tip/core/rcu, thanks Paul!
> 
> i tidied up two tiny details noticed by scripts/checkpatch.pl:
> 
> > +#define RCU_SECONDS_TILL_STALL_CHECK	3 * HZ	/* for rcp->jiffies_stall */
> > +#define RCU_SECONDS_TILL_STALL_RECHECK	30 * HZ	/* for rcp->jiffies_stall */
> 
> adding paranthesis around the expression.
> 
> > +	if (cpu_isset(smp_processor_id(), rcp->cpumask) && delta >= 0) {
> > +		
> 
> and have removed the two tailing tabs from this line.

<red face>  checkpatch.pl...  I have heard of it!  :-)

							Thanx, Paul
