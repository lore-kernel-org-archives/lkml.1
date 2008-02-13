Return-Path: <linux-kernel-owner+w=401wt.eu-S1760929AbYBMW06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760929AbYBMW06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbYBMW0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:26:41 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:50490 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbYBMW0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:26:39 -0500
Date: Wed, 13 Feb 2008 14:26:27 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] fib_trie: print statistics for multiple tables
Message-ID: <20080213222627.GI12393@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080213005042.150212716@vyatta.com> <20080213005122.805195833@vyatta.com> <20080212183521.2c19e2a0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212183521.2c19e2a0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 06:35:21PM -0800, Andrew Morton wrote:
> On Tue, 12 Feb 2008 16:50:45 -0800 Stephen Hemminger <shemminger@vyatta.com> wrote:
> 
> > +/**
> > + * hlist_for_each_entry_continue_rcu - iterate over rcu hlist after current point
> > + * @tpos:	the type * to use as a loop cursor.
> > + * @pos:	the &struct hlist_node to use as a loop cursor.
> > + * @member:	the name of the hlist_node within the struct.
> > + */
> > +#define hlist_for_each_entry_continue_rcu(tpos, pos, member)		\
> > +	for (pos = (pos)->next;						\
> > +	     rcu_dereference(pos) && ({ prefetch(pos->next); 1;}) &&	\
> > +		     ({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
> > +	     pos = pos->next)
> 
> Is the compiler allowed to look at a term such as
> 
> 	({ prefetch(pos->next); 1;})
> 
> and, when it is used as a truth value, say "hey, that's always true" and
> then elide the call to prefetch()?  We've no way of telling because this
> remains gcc-specific territory, afaik.

The prefetch() definitions I found are "asm volatile".  So, as I
understand it, the compiler is not supposed to remove it, just as it
would not be permitted to remove something that could have a side effect.

> (cc Paul for rcu stuff)

Given my track record with simple functions of late :-/ I will beat this
one up a bit...

							Thanx, Paul
