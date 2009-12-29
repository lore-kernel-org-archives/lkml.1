Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbZL2Jyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbZL2Jyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 04:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbZL2Jyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 04:54:52 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:44623 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbZL2Jyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 04:54:51 -0500
Date: Tue, 29 Dec 2009 15:24:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org
Subject: Re: [RFC PATCH] asynchronous page fault.
Message-ID: <20091229095441.GP3601@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091225105140.263180e8.kamezawa.hiroyu@jp.fujitsu.com>
 <1261912796.15854.25.camel@laptop>
 <20091228005746.GE3601@balbir.in.ibm.com>
 <1261989173.7135.5.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1261989173.7135.5.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2009-12-28 09:32:53]:

> On Mon, 2009-12-28 at 06:27 +0530, Balbir Singh wrote:
> > * Peter Zijlstra <peterz@infradead.org> [2009-12-27 12:19:56]:
> > 
> > > Your changelog states as much.
> > > 
> > > "Even if RB-tree rotation occurs while we walk tree for look-up, we just
> > > miss vma without oops."
> > > 
> > > However, since this is the case, do we still need the
> > > rcu_assign_pointer() conversion your patch does? All I can see it do is
> > > slow down all RB-tree users, without any gain.
> > 
> > Don't we need the rcu_assign_pointer() on the read side primarily to
> > make sure the pointer is still valid and assignments (writes) are not
> > re-ordered? Are you suggesting that the pointer assignment paths be
> > completely atomic?
> 
> rcu_assign_pointer() is the write side, but if you need a barrier, you
> can make do with a single smp_wmb() after doing the rb-tree op. There is
> no need to add multiple in the tree-ops themselves.
>

Yes, that makes sense.
 
> You cannot make the assignment paths atomic (without locks) that's the
> whole problem.
>

True, but pre-emption can be nasty in some cases. But I am no expert
in the atomicity of operations like assignments across architectures.
I assume all word, long assignments are.

-- 
	Balbir
