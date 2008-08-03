Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbYHCIOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbYHCIOz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 04:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbYHCIOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 04:14:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40436
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752639AbYHCIOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 04:14:40 -0400
Date: Sun, 03 Aug 2008 01:14:40 -0700 (PDT)
Message-Id: <20080803.011440.137037332.davem@davemloft.net>
To: hugh@veritas.com
Cc: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: combinatorial explosion in lockdep
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0808011246210.18137@blonde.site>
References: <20080801092219.GA15691@elte.hu>
	<20080801.023214.117218567.davem@davemloft.net>
	<Pine.LNX.4.64.0808011246210.18137@blonde.site>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hugh@veritas.com>
Date: Fri, 1 Aug 2008 12:57:27 +0100 (BST)

> @@ -113,6 +113,7 @@ static void __spin_lock_debug(spinlock_t
>  		/* lockup suspected: */
>  		if (print_once) {
>  			print_once = 0;
> +			oops_in_progress = 1;
>  			printk(KERN_EMERG "BUG: spinlock lockup on CPU#%d, "
>  					"%s/%d, %p\n",
>  				raw_smp_processor_id(), current->comm,
> @@ -121,6 +122,7 @@ static void __spin_lock_debug(spinlock_t
>  #ifdef CONFIG_SMP
>  			trigger_all_cpu_backtrace();
>  #endif
> +			oops_in_progress = 0;
>  		}
>  	}
>  }

It's probably best to not later clear oops_in_progress when we trigger
an event like this, to ensure that we do actually get any followon
messages on the console.
