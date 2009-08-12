Return-Path: <linux-kernel-owner+w=401wt.eu-S932387AbZHLJlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387AbZHLJlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbZHLJlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:41:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34960 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201AbZHLJle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:41:34 -0400
Date: Wed, 12 Aug 2009 11:41:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
Message-ID: <20090812094119.GC14734@elte.hu>
References: <Pine.LNX.4.44L0.0908111659510.5845-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0908111659510.5845-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Stern <stern@rowland.harvard.edu> wrote:

> This patch (as1279) adds kerneldoc for flush_scheduled_work()
> containing a stern warning that the function should be avoided.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---
> 
> Index: usb-2.6/kernel/workqueue.c
> ===================================================================
> --- usb-2.6.orig/kernel/workqueue.c
> +++ usb-2.6/kernel/workqueue.c
> @@ -739,6 +739,24 @@ int schedule_on_each_cpu(work_func_t fun
>  	return 0;
>  }
>  
> +/**
> + * flush_scheduled_work - ensure that all work scheduled on keventd_wq has run to completion.
> + *
> + * Blocks until all works on the keventd_wq global workqueue have completed.
> + * We sleep until all works present upon entry have been handled, but we
> + * are not livelocked by new incoming ones.
> + *
> + * Use of this function is discouraged, as it is highly prone to deadlock.
> + * It should never be called from within a work routine on the global
> + * queue, and it should never be called while holding a mutex required
> + * by one of the works on the global queue.  But the fact that keventd_wq
> + * _is_ global means that it can contain works requiring practically any
> + * mutex.  Hence this routine shouldn't be called while holding any mutex.
> + *
> + * Consider using cancel_work_sync() or cancel_delayed_work_sync() instead.
> + * They don't do the same thing (they cancel the work instead of waiting
> + * for it to complete), but in most cases they will suffice.
> + */

Looks good - a small nit: please use proper/consistent line length, 
something like:

/**
 * flush_scheduled_work - ensure that all work scheduled on 
 *			  keventd_wq has run to completion
 *
 * Blocks until all works on the keventd_wq global workqueue have 
 * completed.  We sleep until all works present upon entry have been 
 * handled, but we are not livelocked by new incoming ones.
 *
 * Use of this function is discouraged, as it is highly prone to 
 * deadlock.  It should never be called from within a work routine 
 * on the global queue, and it should never be called while holding 
 * a mutex required by one of the works on the global queue.  But 
 * the fact that keventd_wq _is_ global means that it can contain 
 * works requiring practically any mutex.  Hence this routine 
 * shouldn't be called while holding any mutex.
 *
 * Consider using cancel_work_sync() or cancel_delayed_work_sync() 
 * instead.  They don't do the same thing (they cancel the work 
 * instead of waiting for it to complete), but in most cases they 
 * will suffice.
 */

Thanks,

	Ingo
