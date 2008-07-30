Return-Path: <linux-kernel-owner+w=401wt.eu-S1759004AbYG3Rqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004AbYG3Rqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 13:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYG3Rq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 13:46:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751819AbYG3RqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 13:46:25 -0400
Date: Wed, 30 Jul 2008 10:42:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] wait_task_inactive: don't use the dummy version when
 !SMP && PREEMPT
In-Reply-To: <20080730170949.GA18682@tv-sign.ru>
Message-ID: <alpine.LFD.1.10.0807301038170.3334@nehalem.linux-foundation.org>
References: <20080730170949.GA18682@tv-sign.ru>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Jul 2008, Oleg Nesterov wrote:
>
> The patch looks monstrous because it moves the (unchanged) definition
> of wait_task_inactive() outside of "#ifdef CONFIG_SMP", but it is quite
> trivial.

Hmm. Doesn't this just deadlock in UP (PREEMPT) if wait_task_interactive() 
is ever called from a no-preempt context? 

And if that's never the case, the comment should be updated to reflect 
that (right now it says that it's only invalid to call it with interrupts 
disabled to avoid cross-IPI deadlocks).

Oh, and shouldn't it do a "yield()" instead of a cpu_relax() on UP?

Inquiring minds want to know. That function was very much expressly 
designed for SMP, not for preemption, and I want to understand why it's 
ok (_if_ it's ok).

		Linus
