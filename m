Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbYDVRSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbYDVRSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756232AbYDVRSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:18:25 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:34365 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753AbYDVRSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:18:24 -0400
Date: Tue, 22 Apr 2008 20:23:37 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: paulmck@linux.vnet.ibm.com, hch@lst.de, davem@davemloft.net,
       peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0.01/1] hlist_for_each_entry_xxx: kill the "pos" argument
Message-ID: <20080422162337.GB19909@tv-sign.ru>
References: <20080421151443.GA29670@tv-sign.ru> <20080422013302.GJ9153@linux.vnet.ibm.com> <20080422090921.GA130@tv-sign.ru> <20080422064030.82b37fd9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422064030.82b37fd9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22, Andrew Morton wrote:
>
> > On Tue, 22 Apr 2008 13:09:21 +0400 Oleg Nesterov <oleg@tv-sign.ru> wrote:
> > On 04/21, Paul E. McKenney wrote:
> > >
> > > Might it be better to do this in two
> > > phases to allow these patches to be applied incrementally?
> > >
> > > 1.	Change all to "obsolete" __hlist_for_each_entry_xxx().
> > >
> > > 2.	Incrementally change to hlist_for_each_entry_xxx(), removing
> > > 	the extra variable where possible.
> >
> > Yes sure. Actually this was my initial plan.
> >
> > Andrew, which way do you prefer?
>
> Neither ;)
>
> The smoothest transition would come by adding new macros with new names,
> then migrating all callers over then removing the old macros.

OK, will do, but....

> Preferably after leaving the old, unused macros in place for a kernel
> cycle, but there's not much value in that unless we can make them emil
> warnings when used, which isn't completely trivial.

we can make

	static inline void __deprecated nop_for_hlist_for_each_entry(void) {}

and insert it into the old macro's body

> Plus there is no sensible new name which we can use.  Maybe you can think
> of one, in which case that'd be a nice way to go.

Ah. But this _is_ the problem. There is no a good name for hlist_for_each_entry()
except of course hlist_for_each_entry.

Well. I'll use hnode_for_each_entry_xxx(), but please let me know if you
change your mind ;)

Oleg.

