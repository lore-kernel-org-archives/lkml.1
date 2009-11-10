Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbZKJXkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbZKJXkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 18:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758703AbZKJXkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 18:40:46 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44431 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757186AbZKJXkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 18:40:45 -0500
Date: Tue, 10 Nov 2009 15:41:01 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] rcu: Remove inline from forward-referenced
	functions
Message-ID: <20091110234101.GB8424@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <tip-dbe01350fa8ce0c11948ab7d6be71a4d901be151@git.kernel.org> <1257892710.25443.9.camel@Joe-Laptop.home> <20091110225926.GA8424@linux.vnet.ibm.com> <1257894380.25443.16.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257894380.25443.16.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 03:06:20PM -0800, Joe Perches wrote:
> On Tue, 2009-11-10 at 14:59 -0800, Paul E. McKenney wrote:
> > > non-inline functions in .h files probably aren't a good idea.
> > ;-)
> > Here are my options:
> []
> > Please note that kernel/rcutree_plugin.h is internal to RCU -- only
> > kernel/rcutree.c includes it, so there is no possibility of conflicting
> > definitions.
> > 
> > Any options that I am missing?
> 
> Maybe something like:
> 
> #ifdef whatever
> #define RCU_ANNOUNCE "Hierarchical RCU implementation.\n"
> ...
> #else
> #define RCU_ANNOUNCE "Experimental preemptable hierarchical RCU implementation.\n"
> ...
> #endif
> 
> Use pr_info(RCU_ANNOUNCE) instead of rcu_bootup_announce();
> 
> ?

This would still be a forward reference, right?  Unless I am missing
something, changing from a static inline to a cpp macro doesn't change
anything.

							Thanx, Paul
