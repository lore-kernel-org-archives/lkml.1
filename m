Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322Ab0AHWsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab0AHWsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 17:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251Ab0AHWsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 17:48:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753520Ab0AHWsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 17:48:19 -0500
Date: Fri, 8 Jan 2010 14:43:02 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Christoph Lameter <cl@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
In-Reply-To: <alpine.DEB.2.00.1001081544260.29503@router.home>
Message-ID: <alpine.LFD.2.00.1001081439470.7821@localhost.localdomain>
References: <20100104182429.833180340@chello.nl>  <20100104182813.753545361@chello.nl>  <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com>  <28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com>  <20100105134357.4bfb4951.kamezawa.hiroyu@jp.fujitsu.com>
  <alpine.LFD.2.00.1001042052210.3630@localhost.localdomain>  <20100105143046.73938ea2.kamezawa.hiroyu@jp.fujitsu.com>  <20100105163939.a3f146fb.kamezawa.hiroyu@jp.fujitsu.com>  <alpine.LFD.2.00.1001050707520.3630@localhost.localdomain> 
 <20100106092212.c8766aa8.kamezawa.hiroyu@jp.fujitsu.com>  <alpine.LFD.2.00.1001051718100.3630@localhost.localdomain>  <20100106115233.5621bd5e.kamezawa.hiroyu@jp.fujitsu.com>  <alpine.LFD.2.00.1001051917000.3630@localhost.localdomain> 
 <20100106125625.b02c1b3a.kamezawa.hiroyu@jp.fujitsu.com>  <alpine.LFD.2.00.1001052007090.3630@localhost.localdomain> <alpine.LFD.2.00.1001081307330.7821@localhost.localdomain> <alpine.DEB.2.00.1001081544260.29503@router.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 Jan 2010, Christoph Lameter wrote:
> 
> And I made the point that starvation was a hardware issue due to immature
> cacheline handling. Now the software patchup job for the hardware breakage
> is causing regressions for everyone.

Well, in all fairness, (a) existing hardware doesn't do a good job, and 
would have a really hard time doing so in general (ie the whole issue of 
on-die vs directly-between-sockets vs between-complex-fabric), and (b) in 
this case, the problem really was that the x86-64 rwsems were badly 
implemented.

The fact that somebody _thought_ that it might be ok to do them with 
spinlocks and had done some limited testing without ever hitting the 
problem spot (probably never having tested any amount of contention at 
all) is immaterial. We should have had real native rwsemaphores for 
x86-64, and complaining about the fallback sucking under load is kind of 
pointless.

			Linus
