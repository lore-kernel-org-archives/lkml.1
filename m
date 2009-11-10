Return-Path: <linux-kernel-owner+w=401wt.eu-S1758613AbZKJW7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613AbZKJW7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758456AbZKJW7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:59:12 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57767 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758406AbZKJW7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:59:11 -0500
Date: Tue, 10 Nov 2009 14:59:26 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] rcu: Remove inline from forward-referenced
	functions
Message-ID: <20091110225926.GA8424@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <tip-dbe01350fa8ce0c11948ab7d6be71a4d901be151@git.kernel.org> <1257892710.25443.9.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257892710.25443.9.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 02:38:30PM -0800, Joe Perches wrote:
> On Tue, 2009-11-10 at 22:27 +0000, tip-bot for Paul E. McKenney wrote:
> > rcu: Remove inline from forward-referenced functions
> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > index ef2a58c..c03edf7 100644
> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -33,7 +33,7 @@ DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
> >  /*
> >   * Tell them what RCU they are running.
> >   */
> > -static inline void rcu_bootup_announce(void)
> > +static void rcu_bootup_announce(void)
> >  {
> >  	printk(KERN_INFO
> >  	       "Experimental preemptable hierarchical RCU implementation.\n");
> > @@ -481,7 +481,7 @@ void exit_rcu(void)
> >  /*
> >   * Tell them what RCU they are running.
> >   */
> > -static inline void rcu_bootup_announce(void)
> > +static void rcu_bootup_announce(void)
> >  {
> >  	printk(KERN_INFO "Hierarchical RCU implementation.\n");
> >  }
> 
> non-inline functions in .h files probably aren't a good idea.

;-)

Here are my options:

1.	Have a huge #ifdef in kernel/rcutree.c.  Not going there.

2.	#include kernel/rcutree_plugin.h near the beginning of
	kernel/rcutree.c rather than near the end.  I originally
	had it set up this way, but this results in a large number
	of forward references from kernel/rcutree_plugin.h, which
	turned out to be a real mess.  The current setup is much
	nicer, as the forward references serve to document the
	plug-in functions that are defined in kernel/rcutree_plugin.h.

3.	Leave in the "inline" declarations on the function definitions.
	Although all the compilers that -I- use are quite happy with
	this, some people's compilers complain.  So this is not good,
	either.

Please note that kernel/rcutree_plugin.h is internal to RCU -- only
kernel/rcutree.c includes it, so there is no possibility of conflicting
definitions.

Any options that I am missing?

							Thanx, Paul
