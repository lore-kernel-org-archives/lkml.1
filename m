Return-Path: <linux-kernel-owner+w=401wt.eu-S933959AbZLQIyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933959AbZLQIyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 03:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933573AbZLQIyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 03:54:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40391 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464AbZLQIyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 03:54:32 -0500
Date: Thu, 17 Dec 2009 09:54:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>, minchan.kim@gmail.com,
       paulmck@linux.vnet.ibm.com
Subject: Re: [mm][RFC][PATCH 0/11] mm accessor updates.
Message-ID: <20091217085430.GG9804@basil.fritz.box>
References: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com> <20091216101107.GA15031@basil.fritz.box> <20091216191312.f4655dac.kamezawa.hiroyu@jp.fujitsu.com> <20091216102806.GC15031@basil.fritz.box> <20091216193109.778b881b.kamezawa.hiroyu@jp.fujitsu.com> <1261004224.21028.500.camel@laptop> <20091217084046.GA9804@basil.fritz.box> <1261039534.27920.67.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261039534.27920.67.camel@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 09:45:34AM +0100, Peter Zijlstra wrote:
> On Thu, 2009-12-17 at 09:40 +0100, Andi Kleen wrote:
> > On Wed, Dec 16, 2009 at 11:57:04PM +0100, Peter Zijlstra wrote:
> > > On Wed, 2009-12-16 at 19:31 +0900, KAMEZAWA Hiroyuki wrote:
> > > 
> > > > The problem of range locking is more than mmap_sem, anyway. I don't think
> > > > it's possible easily.
> > > 
> > > We already have a natural range lock in the form of the split pte lock.
> > > 
> > > If we make the vma lookup speculative using RCU, we can use the pte lock
> > 
> > One problem is here that mmap_sem currently contains sleeps
> > and RCU doesn't work for blocking operations until a custom
> > quiescent period is defined.
> 
> Right, so one thing we could do is always have preemptible rcu present
> in another RCU flavour, like
> 
> rcu_read_lock_sleep()
> rcu_read_unlock_sleep()
> call_rcu_sleep()
> 
> or whatever name that would be, and have PREEMPT_RCU=y only flip the
> regular rcu implementation between the sched/sleep one.

That could work yes.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
