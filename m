Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbZKKBDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbZKKBDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 20:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbZKKBDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 20:03:37 -0500
Received: from mail.perches.com ([173.55.12.10]:1329 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbZKKBDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 20:03:37 -0500
Subject: Re: [tip:core/rcu] rcu: Remove inline from forward-referenced
 functions
From: Joe Perches <joe@perches.com>
To: paulmck@linux.vnet.ibm.com
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <20091110234101.GB8424@linux.vnet.ibm.com>
References: <tip-dbe01350fa8ce0c11948ab7d6be71a4d901be151@git.kernel.org>
	 <1257892710.25443.9.camel@Joe-Laptop.home>
	 <20091110225926.GA8424@linux.vnet.ibm.com>
	 <1257894380.25443.16.camel@Joe-Laptop.home>
	 <20091110234101.GB8424@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Nov 2009 17:03:41 -0800
Message-ID: <1257901421.25443.34.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 15:41 -0800, Paul E. McKenney wrote:
> On Tue, Nov 10, 2009 at 03:06:20PM -0800, Joe Perches wrote:
> > On Tue, 2009-11-10 at 14:59 -0800, Paul E. McKenney wrote:
> > > > non-inline functions in .h files probably aren't a good idea.
> > > ;-)
> > > Here are my options:
> > []
> > > Please note that kernel/rcutree_plugin.h is internal to RCU -- only
> > > kernel/rcutree.c includes it, so there is no possibility of conflicting
> > > definitions.
> > > Any options that I am missing?
> > Maybe something like:
> > #ifdef whatever
> > #define RCU_ANNOUNCE "Hierarchical RCU implementation.\n"
> > ...
> > #else
> > #define RCU_ANNOUNCE "Experimental preemptable hierarchical RCU implementation.\n"
> > ...
> > #endif
> > Use pr_info(RCU_ANNOUNCE) instead of rcu_bootup_announce();
> > ?
> This would still be a forward reference, right?

No, what I suggest would delete the forward reference and
the  rcu_bootup_announce function altogether.

The single caller of rcu_bootup_announce in __rcu_init
would become printk(KERN_INFO RCU_ANNOUNCE);

I wrote the original quoted content above without looking
at the file, just the submitted patch.  After looking the
the rcutree files, another option is to do what Ingo did
with sched.c and finesse the #include ".h".

$ grep "include.*\.c" sched.c
#include "sched_idletask.c"
#include "sched_fair.c"
#include "sched_rt.c"
# include "sched_debug.c"

So maybe rename rcutree_plugin.h to rcutree_plugin.c and
#include "rcutree_plugin.c" in rcutree.c instead.

cheers, Joe

