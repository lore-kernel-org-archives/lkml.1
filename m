Return-Path: <linux-kernel-owner+w=401wt.eu-S1756013AbZCJO0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbZCJO0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbZCJO0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:26:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:38473 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbZCJO0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:26:42 -0400
Subject: Re: cgroup, balance RT bandwidth
From: Peter Zijlstra <peterz@infradead.org>
To: Rolando Martins <rolando.martins@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <b6a2d2e20903100449k7bb325eau26ad724e6303080b@mail.gmail.com>
References: <b6a2d2e20903100449k7bb325eau26ad724e6303080b@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 15:26:38 +0100
Message-Id: <1236695198.25234.329.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 11:49 +0000, Rolando Martins wrote:
> Just to confirm, cpuset.sched_load_balance doesn't work with RT, right?

It should. It should split the RT balance domain just the same.

> You cannot have tasks for sub-domain 2 to utilize bandwidth of
> sub-domain 3, right?

If you disabled load-balancing on your root domain (1 below) then
indeed, tasks from 2 will not be able to consume bandwidth from tasks in
3.

The available bandwidth is related to the number of cpus in the balance
domain.

> 
>                               __1__
>                              /        \
>                             2         3
>                       (50% rt)  (50% rt )
> 
> For my application domain it would be interesting to have
> rt_runtime_ns as a min. of allocated rt and not a max.

> Ex. If an application of domain 2 needs to go up to 100% and domain 3
> is idle, then it would be cool to let it utilize the full bandwidth.

> (we also could have a hard upper limit in each sub-domain, like
> hard_up=0.8, i.e. even if we could get 100%, we will only utilize
> 80%); in other words, rt having the same cpu bandwidth management behavior
> as the "best-effort" tasks.
> 
> Could this be done?

Possibly, but since RT scheduling is all about determinism, I see no use
in adding something best-effort -- that simply defeats the purpose.

