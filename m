Return-Path: <linux-kernel-owner+w=401wt.eu-S1030517AbXDMWiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030517AbXDMWiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030865AbXDMWiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:38:10 -0400
Received: from 1wt.eu ([62.212.114.60]:1803 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030517AbXDMWiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:38:09 -0400
Date: Sat, 14 Apr 2007 00:37:36 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070413223736.GB1642@1wt.eu>
References: <20070413202100.GA9957@elte.hu> <1176502546.3129.79.camel@imap.mvista.com> <20070413223017.GA8961@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413223017.GA8961@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2007 at 12:30:17AM +0200, Ingo Molnar wrote:
> 
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > I'm not in love with the current or other schedulers, so I'm 
> > indifferent to this change. However, I was reviewing your release 
> > notes and the patch and found myself wonder what the logarithmic 
> > complexity of this new scheduler is .. I assumed it would also be 
> > constant time , but the __enqueue_task_fair doesn't appear to be 
> > constant time (rbtree insert complexity).. [...]
> 
> i've been worried about that myself and i've done extensive measurements 
> before choosing this implementation. The rbtree turned out to be a quite 
> compact data structure: we get it quite cheaply as part of the task 
> structure cachemisses - which have to be touched anyway. For 1000 tasks 
> it's a loop of ~10 - that's still very fast and bound in practice.

I'm not worried at all by O(log(n)) algorithms, and generally prefer smart log(n)
than dumb O(1).

In a userland TCP stack I started to write 2 years ago, I used a comparable
scheduler and could reach a sustained rate of 145000 connections/s at 4
millions of concurrent connections. And yes, each time a packet was sent or
received, a task was queued/dequeued (so about 450k/s with 4 million tasks,
on an athlon 1.5 GHz). So that seems much higher than what we currently need.

Regards,
Willy

