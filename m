Return-Path: <linux-kernel-owner+w=401wt.eu-S1759957AbZCWQRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957AbZCWQRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759637AbZCWQRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:17:13 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52430 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758930AbZCWQRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:17:11 -0400
To: mingo@elte.hu
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org, oleg@redhat.com,
       peterz@infradead.org, roland@redhat.com, efault@gmx.de, rjw@sisk.pl,
       jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       stable@kernel.org
In-reply-to: <20090323151954.GC21267@elte.hu> (message from Ingo Molnar on
	Mon, 23 Mar 2009 16:19:54 +0100)
Subject: Re: [patch] fix ptrace slowness
References: <E1LllkK-0000zF-1h@pomaz-ex.szeredi.hu> <20090323151954.GC21267@elte.hu>
Message-Id: <E1Llmpk-0001A3-2E@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 23 Mar 2009 17:17:04 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Mar 2009, Ingo Molnar wrote:
> * Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > This one incorporates comments from Oleg and Ingo.  Please apply 
> > to 2.6.29 and 2.6.2[78]-stable trees.
> 
> The fix first needs to go upstream. There's an alternative patch 
> below. Would you mind to give it a test? Chances are that it will 
> make UML even faster than your fix.

Just the opposite.  With my patch a UML image boots in 17 seconnds,
with your patch it boots in 33 seconds.  Without either patch it boots
in about 5 minutes.

Thanks,
Miklos

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
>  			continue;
>  		}
>  
> 
