Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbZBAUMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbZBAUMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 15:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbZBAUMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 15:12:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47794 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbZBAUMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 15:12:22 -0500
Date: Sun, 1 Feb 2009 15:12:20 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Luis Henriques <henrix@sapo.pt>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -rt] Trivial changes to mm/page_alloc.c in -rt git tree
In-Reply-To: <20090201194719.GA5383@hades.domain.com>
Message-ID: <alpine.DEB.1.10.0902011511470.30993@gandalf.stny.rr.com>
References: <20090201194719.GA5383@hades.domain.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks, I'll add this Monday. Peter's having some issues with his 
semi-colon key ;-)

-- Steve


On Sun, 1 Feb 2009, Luis Henriques wrote:

> Some trivial changes in function drain_zone_pages, in -rt tree.
> 
> Invocations to functions get_cpu_lock_cpu_irqsave/restore in function
> drain_zone_pages missing the ';' character.
> 
> ---
>  mm/page_alloc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 238e192..3b18a12 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -889,14 +889,14 @@ void drain_zone_pages(int cpu, struct zone *zone, struct per_cpu_pages *pcp)
>  	unsigned long flags;
>  	int to_drain;
>  
> -	get_cpu_lock_cpu_irqsave(zone, cpu, flags)
> +	get_cpu_lock_cpu_irqsave(zone, cpu, flags);
>  	if (pcp->count >= pcp->batch)
>  		to_drain = pcp->batch;
>  	else
>  		to_drain = pcp->count;
>  	free_pages_bulk(zone, to_drain, &pcp->list, 0);
>  	pcp->count -= to_drain;
> -	put_cpu_lock_irqrestore(zone, cpu, flags)
> +	put_cpu_lock_irqrestore(zone, cpu, flags);
>  }
>  #endif
>  
> -- 
> 1.5.6.5
> 
> 
> 
