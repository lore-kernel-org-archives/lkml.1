Return-Path: <linux-kernel-owner+w=401wt.eu-S932207Ab0AEVBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab0AEVBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929Ab0AEVA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:00:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754505Ab0AEVA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:00:58 -0500
Date: Tue, 5 Jan 2010 13:00:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
In-Reply-To: <alpine.LFD.2.00.1001051241190.3630@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1001051251090.3630@localhost.localdomain>
References: <20100104182429.833180340@chello.nl>  <20100104182813.753545361@chello.nl>  <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com>  <28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com>  <20100105134357.4bfb4951.kamezawa.hiroyu@jp.fujitsu.com>
  <alpine.LFD.2.00.1001042052210.3630@localhost.localdomain>  <20100105143046.73938ea2.kamezawa.hiroyu@jp.fujitsu.com>  <20100105163939.a3f146fb.kamezawa.hiroyu@jp.fujitsu.com>  <alpine.LFD.2.00.1001050707520.3630@localhost.localdomain> 
 <alpine.LFD.2.00.1001050810380.3630@localhost.localdomain>  <87wrzwbh0z.fsf@basil.nowhere.org>  <alpine.LFD.2.00.1001050950500.3630@localhost.localdomain>  <alpine.DEB.2.00.1001051211000.2246@router.home>  <alpine.LFD.2.00.1001051019280.3630@localhost.localdomain>
 <1262723356.4049.11.camel@laptop> <alpine.LFD.2.00.1001051241190.3630@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 5 Jan 2010, Linus Torvalds wrote:
>
> I think you need a "compare-and-exchange-2-separate-words" instruction 
> to make it work (not "cmpxchg8/16b" - literally two _different_ words).

Btw, I might be misremembering - Andy was looking at various lockless 
algorithms too. Maybe the problem was the non-local space requirement. 
There were several spin-lock variants that would be improved if we could 
pass a cookie from the 'lock' to the 'unlock'.

In fact, even the ticket locks would be improved by that, since we could 
then possibly do the unlock as a plain 'store' rather than an 'add', and 
keep the nex-owner cookie in a register over the lock rather than unlock 
by just incrementing it in the nasty lock cacheline.

		Linus
