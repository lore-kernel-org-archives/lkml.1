Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbXHUL7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbXHUL7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 07:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbXHUL7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 07:59:44 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:14124 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbXHUL7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 07:59:44 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [accounting regression since rc1]  scheduler updates
Date: Tue, 21 Aug 2007 13:58:52 +0200
User-Agent: KMail/1.9.7
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
References: <20070812163225.GA11996@elte.hu> <200708211324.13442.borntraeger@de.ibm.com> <20070821113037.GA2390@elte.hu>
In-Reply-To: <20070821113037.GA2390@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708211358.52916.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> what do you think about the rq_clock() #ifdef i did in the previous mail 
> plus you making sched_clock() virtual? That way you can keep 
> scheduler_tick() driven by real-time, although that generally will cause 
> artifacts with SMP load-balancing too. (that was true in the past too)

I just has a test run with a virtual sched_clock and your patch. 
Unfortunately, it doesnt work. top shows 100% for a cpu bound process, but 
steal time shows about 5% stolen cpu.

This brings me to another problem: runtime.
Let me give an example. You get 90% cpu from your hipervisor in a shared 
environment. If you now start a cpu bound task that gets the full cpu for 
lets say 10 minutes. I REALLY want to see 9 minutes in ps and top because my 
department might pay for used cpu cycles. 

> 
> but i dont mind your patch either - it's really the architecture's 
> choice how visible it wants to make external load to the task stats of 
> its virtual machines. I think it is more logical to say that 100% CPU 
> time displayed in 'top' means that the task got all the CPU time it 
> asked for from the virtual machine. (and if you are curious about how 
> much time was stolen from the virtual box altogether you look at the 
> stolen-time stats in isolation.)

Well, as I said we started with the same approach (virtual cpu) but we learned 
that these numbers have no meaning at all because the hypervisor does have 
different scheduling timeslices and having 100% inside the guest can still 
result in almost nothing if the system is really loaded.


Christian
