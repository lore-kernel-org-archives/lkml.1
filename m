Return-Path: <linux-kernel-owner+w=401wt.eu-S1755079Ab0AERuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab0AERuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 12:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915Ab0AERuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 12:50:18 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:52023 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab0AERuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 12:50:16 -0500
Date: Tue, 5 Jan 2010 11:47:49 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
In-Reply-To: <87wrzwbh0z.fsf@basil.nowhere.org>
Message-ID: <alpine.DEB.2.00.1001051145070.2246@router.home>
References: <20100104182429.833180340@chello.nl> <20100104182813.753545361@chello.nl> <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com> <28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com> <20100105134357.4bfb4951.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.LFD.2.00.1001042052210.3630@localhost.localdomain> <20100105143046.73938ea2.kamezawa.hiroyu@jp.fujitsu.com> <20100105163939.a3f146fb.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1001050707520.3630@localhost.localdomain>
 <alpine.LFD.2.00.1001050810380.3630@localhost.localdomain> <87wrzwbh0z.fsf@basil.nowhere.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010, Andi Kleen wrote:

> > Oh well. Somebody who is bored might look at trying to make the wrapper
> > code in arch/x86/lib/semaphore_32.S work on x86-64 too. It should make the
> > successful rwsem cases much faster.
>
> Maybe, maybe not.

What we saw in the past was that the cost of acquiring exclusive
access to the contended cachelines containing mmap_sem and rss counters
was most important.

