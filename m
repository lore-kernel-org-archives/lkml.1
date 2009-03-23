Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbZCWQDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbZCWQDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759437AbZCWQBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:01:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38203 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759399AbZCWQBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:01:09 -0400
Date: Mon, 23 Mar 2009 16:53:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, roland@redhat.com, efault@gmx.de, rjw@sisk.pl,
       jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       stable@kernel.org
Subject: Re: [patch] fix ptrace slowness
Message-ID: <20090323155303.GA5528@redhat.com>
References: <E1LllkK-0000zF-1h@pomaz-ex.szeredi.hu> <20090323151954.GC21267@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323151954.GC21267@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23, Ingo Molnar wrote:
>
> There's an alternative patch
> below. Would you mind to give it a test? Chances are that it will
> make UML even faster than your fix.
>
> 	Ingo
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 3e827b8..2d60f23 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2119,7 +2119,8 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
>  		 * yield - it could be a while.
>  		 */
>  		if (unlikely(on_rq)) {
> -			schedule_timeout_uninterruptible(1);
> +			cpu_relax();
> +			cond_resched();

What if the caller is a realtime task? We can spin "forever", no?

Oleg.

