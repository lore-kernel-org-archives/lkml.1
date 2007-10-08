Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbXJHR2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbXJHR2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 13:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbXJHR2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 13:28:02 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48664 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbXJHR2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 13:28:00 -0400
Date: Mon, 8 Oct 2007 10:24:24 -0700
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Gregory Haskins <ghaskins@novell.com>, stable <stable@kernel.org>,
       mingo@elte.hu, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [PATCH] lockdep: fix mismatched
	lockdep_depth/curr_chain_hash
Message-ID: <20071008172424.GA6692@kroah.com>
References: <20071005034058.20275.21559.stgit@ghaskins-t60p.haskins.net> <1191576686.22357.64.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191576686.22357.64.camel@twins>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 11:31:26AM +0200, Peter Zijlstra wrote:
> 
> Stable team,
> 
> please consider this patch for the next 22-stable.

I don't see this patch in Linus's upstream tree.  We need it there to be
able to accept it for -stable.  Or is this just a bugfix of other things
that are already in his tree?

thanks,

greg k-h


> 
> ---
> Subject: lockdep: fix mismatched lockdep_depth/curr_chain_hash
> From: Gregory Haskins <ghaskins@novell.com>
> 
> It is possible for the current->curr_chain_key to become inconsistent with the
> current index if the chain fails to validate.  The end result is that future
> lock_acquire() operations may inadvertently fail to find a hit in the cache
> resulting in a new node being added to the graph for every acquire.
> 
> [ peterz: this might explain some of the lockdep is so _slow_ complaints. ]
> [ mingo: this does not impact the correctness of validation, but may slow
>   down future operations significantly, if the chain gets very long. ]
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/lockdep.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/kernel/lockdep.c
> ===================================================================
> --- linux-2.6.orig/kernel/lockdep.c
> +++ linux-2.6/kernel/lockdep.c
> @@ -2166,7 +2166,6 @@ out_calc_hash:
>  	}
>  #endif
>  	chain_key = iterate_chain_key(chain_key, id);
> -	curr->curr_chain_key = chain_key;
>  
>  	/*
>  	 * Trylock needs to maintain the stack of held locks, but it
> @@ -2215,6 +2214,7 @@ out_calc_hash:
>  		if (unlikely(!debug_locks))
>  			return 0;
>  
> +	curr->curr_chain_key = chain_key;
>  	curr->lockdep_depth++;
>  	check_chain_key(curr);
>  #ifdef CONFIG_DEBUG_LOCKDEP
> 
> 
> _______________________________________________
> stable mailing list
> stable@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable
