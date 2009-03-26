Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbZCZDee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbZCZDee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 23:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbZCZDeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 23:34:25 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:32998 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbZCZDeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 23:34:24 -0400
Date: Wed, 25 Mar 2009 20:34:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, penberg@cs.helsinki.fi,
       eduard.munteanu@linux360.ro, tglx@linutronix.de
Subject: Re: [tip:tracing/kmemtrace] rcutree: fix rcu_tree_trace.c data
	structure dependencies
Message-ID: <20090326033400.GI7297@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1237898630.25315.83.camel@penberg-laptop> <tip-5d957021d326fbfdc1d7a4f11a3da1f6f82d6a36@git.kernel.org> <20090325161147.GA18738@elte.hu> <20090325165204.GG7297@linux.vnet.ibm.com> <20090325165713.GA14250@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325165713.GA14250@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 05:57:13PM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > > I think many of the data definitions (and the resulting include 
> > > file dependencies) in include/linux/rcu*.h could move into 
> > > kernel/rcu*.h and be privatized that way. 'struct rcu_state' 
> > > would be an example.
> > > 
> > > Agreed?
> > 
> > In principle, yes.  In practice, my attempts to make headway in 
> > this direction have usually collided with the desire to inline 
> > some of the functions that appear on fastpaths, so I would prefer 
> > caution when moving in this direction, especially given my 
> > treercu-related todos, to which "speeding up synchronize_rcu()" 
> > just got added.
> 
> I think there's a solution, for example the quiescent-state inlines 
> could still be offered in a kernel/rcupdate_internals.h header to be 
> included by kernel/softirq.c et al directly.

Could definitely do this, as I used to do it this way in a former life.
As long as we are now OK with creating an additional header file or two
per flavor of RCU.

> Otherwise ... i think it generally is not worth the trouble to put 
> huge data types into common headers just to be able to inline into a 
> small number of callsites.

Information hiding can indeed be a good thing.

							Thanx, Paul
