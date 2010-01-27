Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033Ab0A0KBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab0A0KBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 05:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735Ab0A0KBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 05:01:41 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59616 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab0A0KBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 05:01:40 -0500
Date: Wed, 27 Jan 2010 02:01:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu] accelerate grace period if last
	non-dynticked CPU
Message-ID: <20100127100136.GM6807@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100125034816.GA14043@linux.vnet.ibm.com> <873a1sft9q.fsf@basil.nowhere.org> <20100127052050.GC6807@linux.vnet.ibm.com> <20100127094336.GA12522@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100127094336.GA12522@basil.fritz.box>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 10:43:36AM +0100, Andi Kleen wrote:
> On Tue, Jan 26, 2010 at 09:20:50PM -0800, Paul E. McKenney wrote:
> > On Tue, Jan 26, 2010 at 10:30:57PM +0100, Andi Kleen wrote:
> > > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> > > 
> > > Kind of offtopic to the original patch, but I couldn't 
> > > resist...
> > > 
> > > > +config RCU_FAST_NO_HZ
> > > > +	bool "Accelerate last non-dyntick-idle CPU's grace periods"
> > > > +	depends on TREE_RCU && NO_HZ && SMP
> > > 
> > > Having such a thing as a config option doesn't really make 
> > > any sense to me. Who would want to recompile their kernel
> > > to enable/disable this? If anything it should be runtime, or better
> > > just unconditionally on.
> > 
> > It adds significant overhead on entry to dyntick-idle mode for systems
> > with large numbers of CPUs.  :-(
> 
> Can't you simply check that at runtime then?
> 
> if (num_possible_cpus() > 20) 
> 	...
> 
> BTW the new small is large. This years high end desktop PC will come with 
> upto 12 CPU threads. It would likely be challenging to find a good
> number for 20 that holds up with the future.

And this was another line of reasoning that lead me to the extra kernel
config parameter.

> Or better perhaps have some threshold that you don't do it 
> that often, or only do it when you expect to be idle for a long
> enough time that the CPU can enter deeper idle states
> 
> (I higher idle states some more wakeups typically don't matter
> that much)
> 
> The cpufreq/cstate governour have a reasonable good idea
> now how "idle" the system is and will be. Maybe you can reuse
> that information somehow.

My first thought was to find an existing "I am a small device running on
battery power" or "low power consumption is critical to me" config
parameter.  I didn't find anything that looked like that.  If there was
one, I would make RCU_FAST_NO_HZ depend on it.

Or did I miss some kernel parameter or API?

							Thanx, Paul
