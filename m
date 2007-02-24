Return-Path: <linux-kernel-owner+w=401wt.eu-S933586AbXBXXBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586AbXBXXBe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 18:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933588AbXBXXBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 18:01:33 -0500
Received: from pool-71-111-73-6.ptldor.dsl-w.verizon.net ([71.111.73.6]:6494
	"EHLO IBM-8EC8B5596CA.beaverton.ibm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933586AbXBXXBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 18:01:32 -0500
Date: Sat, 24 Feb 2007 14:36:55 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, dipankar@in.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: PREEMPT_RCU breaks anon_vma locking ?
Message-ID: <20070224223655.GG5049@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070223212303.GA423@tv-sign.ru> <20070223224145.GD1630@linux.vnet.ibm.com> <Pine.LNX.4.64.0702242204220.4370@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702242204220.4370@blonde.wat.veritas.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 24, 2007 at 10:10:57PM +0000, Hugh Dickins wrote:
> On Fri, 23 Feb 2007, Paul E. McKenney wrote:
> > 
> > This look like a valid fix to me, at least as long as the lock is never
> > dropped in the meantime (e.g., to do I/O).  If the lock -is- dropped in
> > the meantime, then presumably whatever is done to keep the page from
> > vanishing should allow an rcu_read_unlock() to be placed after each
> > spin_unlock(&...->lock) and an rcu_read_lock() to be placed before each
> > spin_lock(&...->lock).
> 
> Thankfully no complications of that kind, page_lock_anon_vma is static
> to mm/rmap.c, and only used to hold the spin lock while examining page
> tables of the vmas in the list, never a need to drop that lock at all.
> (Until the day when someone reports such a long list that we start to
> worry about the latency.)

Whew!!!  For now, anyway!  ;-)

						Thanx, Paul
