Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYHXI73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYHXI73 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 04:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbYHXI7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 04:59:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60913 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbYHXI7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 04:59:20 -0400
Date: Sun, 24 Aug 2008 11:01:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] smp_call_function: use rwlocks on queues rather than rcu
Message-ID: <20080824090133.GA26610@one.firstfloor.org>
References: <20080822062800.GQ14110@elte.hu> <84144f020808220006n25d684b1n9db306ddc4f58c4c@mail.gmail.com> <48AEC6B2.1080701@linux-foundation.org> <20080822151156.GA6744@linux.vnet.ibm.com> <48AEF3FD.70906@linux-foundation.org> <20080822182915.GG6744@linux.vnet.ibm.com> <20080822183346.GS23334@one.firstfloor.org> <48AF0702.8040303@goop.org> <20080823073457.GV23334@one.firstfloor.org> <48B0E9CA.4040808@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B0E9CA.4040808@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Ah so it was already 25% slower even without kmalloc? I thought
> > that was with already. That doesn't sound good. Any idea where that slowdown 
> > comes from?
> 
> Just longer code path, I think.  It calls the generic

I did IPI measurements quite some time ago and what I remember
from them is that IPI latencies were in the low multiple thousands cycle
ballpark.

> smp_call_function_mask(), which then does a popcount on the cpu mask
> (which it needs to do anyway), sees only one bit set, and then punts to
> the smp_call_function_single() path.  

But that is more in the a few tens of cycles (or maybe 1-2 hundreds
if you have a NR_CPU==4096 kernel with really large cpumask)

Doesn't really explain a 25% slowdown I would say. 

Are you sure there isn't a new cache miss in there or something? Actually
it must be even multiple ones to account for such a slow down.

-Andi

-- 
ak@linux.intel.com
