Return-Path: <linux-kernel-owner+w=401wt.eu-S1760257AbZCYQwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760257AbZCYQwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757563AbZCYQwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:52:10 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46973 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757332AbZCYQwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:52:08 -0400
Date: Wed, 25 Mar 2009 09:52:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, penberg@cs.helsinki.fi,
       eduard.munteanu@linux360.ro, tglx@linutronix.de
Subject: Re: [tip:tracing/kmemtrace] rcutree: fix rcu_tree_trace.c data
	structure dependencies
Message-ID: <20090325165204.GG7297@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1237898630.25315.83.camel@penberg-laptop> <tip-5d957021d326fbfdc1d7a4f11a3da1f6f82d6a36@git.kernel.org> <20090325161147.GA18738@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325161147.GA18738@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 05:11:47PM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Commit-ID:  5d957021d326fbfdc1d7a4f11a3da1f6f82d6a36
> > Gitweb:     http://git.kernel.org/tip/5d957021d326fbfdc1d7a4f11a3da1f6f82d6a36
> > Author:     Ingo Molnar <mingo@elte.hu>
> > AuthorDate: Wed, 25 Mar 2009 16:42:24 +0100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed, 25 Mar 2009 16:42:24 +0100
> > 
> > rcutree: fix rcu_tree_trace.c data structure dependencies
> > 
> > Impact: build fix
> > 
> > We removed rcutree internals from the public rcutree.h file - but
> > kernel/rcutree_trace.c depends on them.
> > 
> > Introduce kernel/rcutree.h for internal definitions. (Probably all
> > the other data types from include/linux/rcutree.h could be
> > moved here too - except rcu_data.)
> 
> Paul ... what do you think? This is just an interim measure to get 
> the build going - i think we could do more cleanups here perhaps, if 
> you agree.

I am generally in favor of this.  I reviewed the above gitweb and it
looks good to me, feel free to append:

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> I think many of the data definitions (and the resulting include file 
> dependencies) in include/linux/rcu*.h could move into kernel/rcu*.h 
> and be privatized that way. 'struct rcu_state' would be an example.
> 
> Agreed?

In principle, yes.  In practice, my attempts to make headway in this
direction have usually collided with the desire to inline some of the
functions that appear on fastpaths, so I would prefer caution when moving
in this direction, especially given my treercu-related todos, to which
"speeding up synchronize_rcu()" just got added.

							Thanx, Paul
