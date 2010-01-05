Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709Ab0AESOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab0AESOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 13:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234Ab0AESOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 13:14:07 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:51452 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab0AESOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 13:14:06 -0500
Date: Tue, 5 Jan 2010 12:13:05 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andi Kleen <andi@firstfloor.org>,
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
In-Reply-To: <alpine.LFD.2.00.1001050950500.3630@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1001051211000.2246@router.home>
References: <20100104182429.833180340@chello.nl> <20100104182813.753545361@chello.nl> <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com> <28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com> <20100105134357.4bfb4951.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.LFD.2.00.1001042052210.3630@localhost.localdomain> <20100105143046.73938ea2.kamezawa.hiroyu@jp.fujitsu.com> <20100105163939.a3f146fb.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1001050707520.3630@localhost.localdomain>
 <alpine.LFD.2.00.1001050810380.3630@localhost.localdomain> <87wrzwbh0z.fsf@basil.nowhere.org> <alpine.LFD.2.00.1001050950500.3630@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010, Linus Torvalds wrote:

> So a spinlock is as cheap as an atomic when there is no contention (which
> is the common single-thread case - the real cost of both lock and atomic
> is simply the fact that CPU serialization is expensive), but when there is
> actual lock contention, I bet the atomic xadd is going to be shown to be
> superior.
>
> Remember: we commonly claim that 'spin_unlock' is basically free on x86 -
> and that's true, but it is _only_ true for the uncontended state.

Its also free if the MESI algorithm has been tuned in such a way that the
exclusive cacheline that was just acquired is not immediately released
after a single access.

If the critical section protected by the spinlock is small then the
delay will keep the cacheline exclusive until we hit the unlock. This
is the case here as far as I can tell.


