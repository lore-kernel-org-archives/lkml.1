Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbYG3SKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbYG3SKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYG3SKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:10:07 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:50408 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbYG3SKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:10:07 -0400
Date: Wed, 30 Jul 2008 22:13:20 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] wait_task_inactive: don't use the dummy version when !SMP && PREEMPT
Message-ID: <20080730181320.GA18714@tv-sign.ru>
References: <20080730170949.GA18682@tv-sign.ru> <alpine.LFD.1.10.0807301038170.3334@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807301038170.3334@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30, Linus Torvalds wrote:
> 
> On Wed, 30 Jul 2008, Oleg Nesterov wrote:
> >
> > The patch looks monstrous because it moves the (unchanged) definition
> > of wait_task_inactive() outside of "#ifdef CONFIG_SMP", but it is quite
> > trivial.
> 
> Hmm. Doesn't this just deadlock in UP (PREEMPT) if wait_task_interactive() 
> is ever called from a no-preempt context? 

Given that it calls schedule_timeout_uninterruptible(), it can't be used
from the no-preempt context,

> And if that's never the case, the comment should be updated to reflect 
> that (right now it says that it's only invalid to call it with interrupts 
> disabled to avoid cross-IPI deadlocks).

Yes, I think this function is might_sleep(),

> Oh, and shouldn't it do a "yield()" instead of a cpu_relax() on UP?

I _think_ that rq->curr must be == current without CONFIG_SMP, but

> and I want to understand why it's 
> ok (_if_ it's ok).

me too.

Hopefully Ingo can ack/nack.

Oleg.

