Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbYEJRlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbYEJRlj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 13:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbYEJRl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 13:41:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48632 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbYEJRl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 13:41:28 -0400
Date: Sat, 10 May 2008 19:48:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, Vegard Nossum <vegard.nossum@gmail.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       John Reiser <jreiser@BitWagon.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Lameter <clameter@sgi.com>,
       Daniel Walker <dwalker@mvista.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Josh Aune <luken@omner.org>,
       Pekka Paalanen <pq@iki.fi>
Subject: Re: [ANNOUNCE] kmemcheck v7
Message-ID: <20080510174841.GC31954@one.firstfloor.org>
References: <47F630AE.7050801@gmail.com> <e2e108260805100207l13b67706h871f5f1c550e58b3@mail.gmail.com> <482565A5.8010503@cs.helsinki.fi> <e2e108260805100404h63f02194r62e53f79ae2a403f@mail.gmail.com> <19f34abd0805100502k150e3636x33831230d688dd92@mail.gmail.com> <20080510123744.GB19109@one.firstfloor.org> <4825D8B4.3060600@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4825D8B4.3060600@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It tracks changes to the stack pointer, and any memory below it is 
> considered uninitialized.  But, yes, if you mean that if you use the 

But it does not invalidate anything below the stack pointer as soon
as it changes right ?

> variable (or slot) once in a function, then again later, it will still 
> be considered initialized.  But that's no different from any other memory.

What I meant is e.g. 

	f1();
	f2();

both f1 and f2 use the same stack memory, but f2 uses it uninitialized,
then I think valgrind would still think it is initialized in f2 from the
execution of f1. It would only detect such things in f1 (assuming there
were no other users of the stack before that)

In theory it could throw away all stack related uninitizedness on each
SP change, but that would be likely prohibitively expensive and also
it might be hard to know the exact boundaries of the stack.

BTW on running a test program here it doesn't seem to detect any uninitialized
stack frames here with 3.2.3. Test program is http://halobates.de/t10.c 
(should be compiled without optimization) 

-Andi

