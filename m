Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881Ab0AHSey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab0AHSey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 13:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508Ab0AHSex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 13:34:53 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:59359 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab0AHSex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 13:34:53 -0500
Date: Fri, 8 Jan 2010 12:33:52 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
In-Reply-To: <alpine.LFD.2.00.1001080950120.7821@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1001081229450.23727@router.home>
References: <20100104182429.833180340@chello.nl>  <20100104182813.753545361@chello.nl>  <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com>  <28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com>  <20100105134357.4bfb4951.kamezawa.hiroyu@jp.fujitsu.com>
  <alpine.LFD.2.00.1001042052210.3630@localhost.localdomain>  <20100105143046.73938ea2.kamezawa.hiroyu@jp.fujitsu.com>  <20100105163939.a3f146fb.kamezawa.hiroyu@jp.fujitsu.com>  <alpine.LFD.2.00.1001050707520.3630@localhost.localdomain> 
 <20100106092212.c8766aa8.kamezawa.hiroyu@jp.fujitsu.com>  <alpine.LFD.2.00.1001051718100.3630@localhost.localdomain>  <20100106115233.5621bd5e.kamezawa.hiroyu@jp.fujitsu.com>  <alpine.LFD.2.00.1001051917000.3630@localhost.localdomain> 
 <20100106125625.b02c1b3a.kamezawa.hiroyu@jp.fujitsu.com>  <alpine.LFD.2.00.1001052007090.3630@localhost.localdomain> <alpine.DEB.2.00.1001081138260.23727@router.home> <alpine.LFD.2.00.1001080950120.7821@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jan 2010, Linus Torvalds wrote:

> I bet it won't be a problem. It's when things go cross-socket that they
> suck. So 16 cpu's across two sockets I wouldn't worry about.
>
> > > Because let's face it - if your workload does several million page faults
> > > per second, you're just doing something fundamentally _wrong_.
> >
> > You may just want to get your app running and its trying to initialize
> > its memory in parallel on all threads. Nothing wrong with that.
>
> Umm. That's going to be limited by the memset/memcpy, not the rwlock, I
> bet.

That may be true for a system with 2 threads. As the number of threads
increases so does the cacheline contention. In larger systems the
memset/memcpy is negligible.

> The benchmark in question literally did a single byte write to each page
> in order to show just the kernel component. That really isn't realistic
> for any real load.

Each anon fault also includes zeroing the page before its ready to be
written to. The cachelines will be hot after a fault and initialization of
any variables in the page will be fast due to that warming up effect.


