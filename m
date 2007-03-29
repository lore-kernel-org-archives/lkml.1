Return-Path: <linux-kernel-owner+w=401wt.eu-S934307AbXC2Sml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934307AbXC2Sml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 14:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934311AbXC2Sml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 14:42:41 -0400
Received: from mail.screens.ru ([213.234.233.54]:57491 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934307AbXC2Smk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 14:42:40 -0400
Date: Thu, 29 Mar 2007 22:42:13 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Nick Piggin <npiggin@suse.de>
Cc: Ravikiran G Thirumalai <kiran@scalex86.org>, Ingo Molnar <mingo@elte.hu>,
       Nikita Danilov <nikita@clusterfs.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] queued spinlocks (i386)
Message-ID: <20070329184213.GA83@tv-sign.ru>
References: <20070325155407.GA497@tv-sign.ru> <20070328070459.GC12508@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328070459.GC12508@wotan.suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28, Nick Piggin wrote:
>
> Well with my queued spinlocks, all that lockbreak stuff can just come out
> of the spin_lock, break_lock out of the spinlock structure, and
> need_lockbreak just becomes (lock->qhead - lock->qtail > 1).

Q: queued spinlocks are not CONFIG_PREEMPT friendly,

> +       asm volatile(LOCK_PREFIX "xaddw %0, %1\n\t"
> +                    : "+r" (pos), "+m" (lock->qhead) : : "memory");
> +       while (unlikely(pos != lock->qtail))
> +               cpu_relax();

once we incremented lock->qhead, we have no optiion but should spin with
preemption disabled until pos == lock->qtail, yes?

Oleg.

