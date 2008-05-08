Return-Path: <linux-kernel-owner+w=401wt.eu-S1761844AbYEHKHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761844AbYEHKHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 06:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757342AbYEHKHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 06:07:11 -0400
Received: from www.tglx.de ([62.245.132.106]:46685 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756992AbYEHKHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 06:07:09 -0400
Date: Thu, 8 May 2008 12:06:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
cc: Pierre Peiffer <peifferp@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: futex: priority wakeup miss ordering
In-Reply-To: <1210195378.17132.237.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.10.0805081156450.3318@apollo.tec.linutronix.de>
References: <1210195378.17132.237.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008, Daniel Walker wrote:
> 
> from commit ec92d08292d3e9b0823eba138a4564d2d39f25c7
> 
> The wakeup ordering should be in priority order. However if the priority
> of a task is modified while it's waiting on the futex you will get an
> out of order wakeup.
> 
> If you use a priority inheriting mutex this is correct. It's because the
> rtmutex hooks into sched_setscheduler to catch any priority changes,
> then re-queues with the new priority.. But the futex doesn't have this
> hook.
> 
> Was this intentionally left out of this priority wake up patch? I
> thought I would let you know in case you had a specific reason for not
> handling this.. 

IIRC this has been discussed before. The priority ordering of the
plain mutex waiters is an optimization without guarantees of
correctness across a priority change. It's simply not worth the
additional complexity and overhead for that corner case.

Thanks,

	tglx
