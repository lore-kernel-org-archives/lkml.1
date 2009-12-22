Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbZLVRXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbZLVRXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 12:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbZLVRXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 12:23:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753693AbZLVRXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 12:23:18 -0500
Date: Tue, 22 Dec 2009 09:20:40 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       mingo@elte.hu, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net
Subject: Re: workqueue thing
In-Reply-To: <1261480220.4937.24.camel@laptop>
Message-ID: <alpine.LFD.2.00.0912220917270.31313@localhost.localdomain>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>  <1261143924.20899.169.camel@laptop> <20091218135033.GB8678@basil.fritz.box>  <4B2B9949.1000608@linux.intel.com> <20091221091754.GG4489@kernel.dk>  <4B2F57E6.7020504@linux.intel.com>
 <4B2F768C.1040704@kernel.org>  <4B2F7DD2.2080902@linux.intel.com> <4B2F83F6.2040705@kernel.org>  <4B2F9212.3000407@linux.intel.com>  <4B300C01.8080904@kernel.org> <1261480220.4937.24.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Dec 2009, Peter Zijlstra wrote:

> On Tue, 2009-12-22 at 09:00 +0900, Tejun Heo wrote:
> > 
> > Yeah, sure, it's not suited for offloading CPU intensive workloads
> > (checksumming and encryption basically).  Workqueue interface was
> > never meant to be used by them - it has strong cpu affinity.  We need
> > something which is more parallelism aware for those. 
> 
> Right, so what about cleaning that up first, then looking how many
> workqueues can be removed by converting to threaded interrupts and then
> maybe look again at some of your async things?

Peter - nobody is interested in that.

People use workqueues for other things _today_, and they have annoying 
problems as they stand. It would be nice to get rid of the deadlock 
issue, for example - right now the tty driver literally does crazy things, 
and drops locks that it shouldn't drop due to the fact that it needs to 
wait for queued work - even if the queued work it is actually waiting for 
isn't the one that takes the lock!

So why do you argue about all those irrelevant things, and ask Tejun to 
clean up stuff that nobody cares about, when our existing workqueues have 
problems that people -do- care about and that his patches address?

So stop arguing about irrelevancies. Nobody uses workqueues for RT or for 
CPU-intensive crap. It's not what they were designed for, or used for.

If you _want_ to use them for that, that is _your_ problem. Not Tejuns.

			Linus
