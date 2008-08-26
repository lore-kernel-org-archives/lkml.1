Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbYHZUn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbYHZUn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbYHZUnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:43:49 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:46458 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbYHZUns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:43:48 -0400
Date: Tue, 26 Aug 2008 13:43:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] rcu: fix sparse shadowed variable warning
Message-ID: <20080826204333.GI6656@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1219780844.6069.6.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219780844.6069.6.camel@brick>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 01:00:44PM -0700, Harvey Harrison wrote:
> kernel/rcuclassic.c:564:18: warning: symbol 'flags' shadows an earlier one
> kernel/rcuclassic.c:527:16: originally declared here

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> It would be safe in this case to just remove the second declaration of flags
> and reuse it as it is outside the local_irq_save/restore pair.  I did it this
> way in case there are future changes that might mix up the use of flags.
> 
> Feel free to just remove the second flags declaration if you'd rather do it
> that way.
> 
>  kernel/rcuclassic.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
> index 743cf05..ed15128 100644
> --- a/kernel/rcuclassic.c
> +++ b/kernel/rcuclassic.c
> @@ -561,15 +561,15 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
>  		local_irq_restore(flags);
> 
>  		if (rcu_batch_after(rdp->batch, rcp->pending)) {
> -			unsigned long flags;
> +			unsigned long flags2;
> 
>  			/* and start it/schedule start if it's a new batch */
> -			spin_lock_irqsave(&rcp->lock, flags);
> +			spin_lock_irqsave(&rcp->lock, flags2);
>  			if (rcu_batch_after(rdp->batch, rcp->pending)) {
>  				rcp->pending = rdp->batch;
>  				rcu_start_batch(rcp);
>  			}
> -			spin_unlock_irqrestore(&rcp->lock, flags);
> +			spin_unlock_irqrestore(&rcp->lock, flags2);
>  		}
>  	}
> 
> -- 
> 1.6.0.340.g84854
> 
