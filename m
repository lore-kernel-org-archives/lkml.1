Return-Path: <linux-kernel-owner+w=401wt.eu-S1761204AbYD2NAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761204AbYD2NAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757443AbYD2NAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:00:05 -0400
Received: from twin.jikos.cz ([213.151.79.26]:44850 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757250AbYD2NAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:00:04 -0400
Date: Tue, 29 Apr 2008 14:43:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Peter Zijlstra <peterz@infradead.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Nick Piggin <npiggin@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: futex code and barriers
In-Reply-To: <1209470236.13978.55.camel@twins>
Message-ID: <Pine.LNX.4.64.0804291442050.22014@twin.jikos.cz>
References: <1209470236.13978.55.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008, Peter Zijlstra wrote:

> While looking through the futex code I stumbled upon the following bit:
> kernel/futex.c:
> 	/* add_wait_queue is the barrier after __set_current_state. */
> 	__set_current_state(TASK_INTERRUPTIBLE);
> 	add_wait_queue(&q.waiters, &wait);
> However,
> void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
> {
> 	unsigned long flags;
> 
> 	wait->flags &= ~WQ_FLAG_EXCLUSIVE;
> 	spin_lock_irqsave(&q->lock, flags);
> 	__add_wait_queue(q, wait);
> 	spin_unlock_irqrestore(&q->lock, flags);
> }
[ ... ]
> Non of which implies a full barrier.

Well I am probably missing the point, but what about the lock and unlock 
of the spinlock?

-- 
Jiri Kosina
SUSE Labs

