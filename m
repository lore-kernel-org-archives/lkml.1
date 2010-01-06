Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322Ab0AFEVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab0AFEVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 23:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774Ab0AFEVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 23:21:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754732Ab0AFEVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 23:21:34 -0500
Date: Tue, 5 Jan 2010 20:20:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Minchan Kim <minchan.kim@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
In-Reply-To: <20100106125625.b02c1b3a.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.LFD.2.00.1001052007090.3630@localhost.localdomain>
References: <20100104182429.833180340@chello.nl> <20100104182813.753545361@chello.nl> <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com> <28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com> <20100105134357.4bfb4951.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.LFD.2.00.1001042052210.3630@localhost.localdomain> <20100105143046.73938ea2.kamezawa.hiroyu@jp.fujitsu.com> <20100105163939.a3f146fb.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1001050707520.3630@localhost.localdomain>
 <20100106092212.c8766aa8.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1001051718100.3630@localhost.localdomain> <20100106115233.5621bd5e.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1001051917000.3630@localhost.localdomain>
 <20100106125625.b02c1b3a.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 Jan 2010, KAMEZAWA Hiroyuki wrote:
> > 
> > Of course, your other load with MADV_DONTNEED seems to be horrible, and 
> > has some nasty spinlock issues, but that looks like a separate deal (I 
> > assume that load is just very hard on the pgtable lock).
> 
> It's zone->lock, I guess. My test program avoids pgtable lock problem.

Yeah, I should have looked more at your callchain. That's nasty. Much 
worse than the per-mm lock. I thought the page buffering would avoid the 
zone lock becoming a huge problem, but clearly not in this case.

		Linus
