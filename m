Return-Path: <linux-kernel-owner+w=401wt.eu-S1422663AbXC2WQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422663AbXC2WQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 18:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422684AbXC2WQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 18:16:52 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:45183 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422663AbXC2WQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 18:16:51 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 29 Mar 2007 15:16:49 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Nick Piggin <npiggin@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       Ingo Molnar <mingo@elte.hu>, Nikita Danilov <nikita@clusterfs.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] queued spinlocks (i386)
In-Reply-To: <20070329184213.GA83@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0703291215440.1199@alien.or.mcafeemobile.com>
References: <20070325155407.GA497@tv-sign.ru> <20070328070459.GC12508@wotan.suse.de>
 <20070329184213.GA83@tv-sign.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2007, Oleg Nesterov wrote:

> On 03/28, Nick Piggin wrote:
> >
> > Well with my queued spinlocks, all that lockbreak stuff can just come out
> > of the spin_lock, break_lock out of the spinlock structure, and
> > need_lockbreak just becomes (lock->qhead - lock->qtail > 1).
> 
> Q: queued spinlocks are not CONFIG_PREEMPT friendly,

Why? Is CONFIG_PREEMPT friendly to anyone? :)



> > +       asm volatile(LOCK_PREFIX "xaddw %0, %1\n\t"
> > +                    : "+r" (pos), "+m" (lock->qhead) : : "memory");
> > +       while (unlikely(pos != lock->qtail))
> > +               cpu_relax();
> 
> once we incremented lock->qhead, we have no optiion but should spin with
> preemption disabled until pos == lock->qtail, yes?

Yes, preemption and deterministic spinlock policies are not friends.



- Davide


