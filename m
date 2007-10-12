Return-Path: <linux-kernel-owner+w=401wt.eu-S1759553AbXJLLr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553AbXJLLr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 07:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbXJLLrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 07:47:48 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:64143 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbXJLLrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 07:47:47 -0400
Date: Fri, 12 Oct 2007 07:47:15 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Gregory Haskins <ghaskins@novell.com>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] RT: (RFC) RT-Overload/Sched enhancements
In-Reply-To: <1192184985.27435.17.camel@twins>
Message-ID: <Pine.LNX.4.58.0710120745310.8793@gandalf.stny.rr.com>
References: <20071011213916.27097.42597.stgit@novell1.haskins.net>
 <1192184985.27435.17.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--

On Fri, 12 Oct 2007, Peter Zijlstra wrote:

>
> And for that, steve's rq->curr_prio field seems quite suitable.
>
> so instead of the:
>   for (3 tries)
>     find lowest cpu
>     try push
>
> we do:
>
>   cpu_hotplug_lock();
>   cpus_and(mask, p->cpus_allowed, online_cpus);
>   for_each_cpu_mask(i, mask) {
>     if (cpu_rq(i)->curr_prio > p->prio && push_task(p, i))
>       break;
>   }
>   cpu_hotplug_unlock();

The thing I'm worried about is that we pushed off a rt task that is higher
in prio than another rt task on another cpu, and we'll cause a bunch of
rt task bouncing.  That is what I'm trying to avoid.

BTW, my logging has showed that I have yet to hit a 2cd try (but I admit,
this is a very limited test set).

-- Steve
