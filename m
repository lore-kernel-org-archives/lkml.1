Return-Path: <linux-kernel-owner+w=401wt.eu-S1758624AbZJEHvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbZJEHvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 03:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758611AbZJEHvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 03:51:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53463 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758525AbZJEHvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 03:51:18 -0400
Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to
 get to performance counters
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20091001085330.GC15345@elte.hu>
References: <20090925122556.2f8bd939@infradead.org>
	 <y0mhbuplmlr.fsf@fche.csb> <20090926183246.GA4141@in.ibm.com>
	 <20090926204848.0b2b48d2@infradead.org> <20091001072518.GA1502@elte.hu>
	 <20091001081616.GA3636@in.ibm.com>  <20091001085330.GC15345@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 05 Oct 2009 09:53:30 +0200
Message-Id: <1254729210.26976.15.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 10:53 +0200, Ingo Molnar wrote:
> i'd suggest you extend perf events with a 'system 
> wide' event abstraction, which:
> 
>  - Enumerates such registered events (via a list)
> 
>  - Adds a CPU hotplug handler (which clones those events over to a new
>    CPU and directs it back to the ring-buffer of the existing event(s)
>    [if any])
> 
>  - Plus a state field that allows the filtering out of stray/premature
>    events.
> 
> Such an add-on layer/abstraction would sure be useful in other cases as 
> well. It might make sense to expose it to user-space and make perf top 
> use it by default.

Non-trivial.

Something like this would imply a single output channel for all these
CPUs, and we've already seen that stuffing too many CPUs down one such
channel (using -M) leads to significant performance issues.

Therefore I would strongly argue to let the kernel interface be what it
is and solve this in a userspace library for those who care.

We really cannot sanely support an all-CPUs abstraction without running
into trouble.


