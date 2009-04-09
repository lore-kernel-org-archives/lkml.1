Return-Path: <linux-kernel-owner+w=401wt.eu-S933760AbZDIOEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760AbZDIOEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbZDIOEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:04:35 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:11430 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbZDIOEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:04:34 -0400
Subject: Re: [PATCH] mm: move the scan_unevictable_pages sysctl to the vm
	table
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       linux-mm <linux-mm@kvack.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1239270133.7647.213.camel@twins>
References: <1239270133.7647.213.camel@twins>
Content-Type: text/plain
Organization: HP/OSLO
Date: Thu, 09 Apr 2009 10:04:32 -0400
Message-Id: <1239285872.24817.20.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-09 at 11:42 +0200, Peter Zijlstra wrote:
> Subject: mm: move the scan_unevictable_pages sysctl to the vm table
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Thu Apr 09 11:38:45 CEST 2009
> 
> vm knobs should go in the vm table. Probably too late for randomize_va_space
> though.

I was surprised to see "scan_unevictable_pages" in the kernel table.
This must be the result of a merge glitch.  I originally put this at the
end of the vm table.  Just went back and looked at some older patches to
be sure.  E.g.,

	http://marc.info/?l=linux-mm&m=121321022603288&w=4

It had been moved to the kernel table by the time the unevictable lru
was merged upstream:

	http://marc.info/?l=linux-mm-commits&m=122453486931267&w=4

Anyway...

> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

> ---
>  kernel/sysctl.c |   20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6/kernel/sysctl.c
> ===================================================================
> --- linux-2.6.orig/kernel/sysctl.c
> +++ linux-2.6/kernel/sysctl.c
> @@ -914,16 +914,6 @@ static struct ctl_table kern_table[] = {
>  		.proc_handler	= &proc_dointvec,
>  	},
>  #endif
> -#ifdef CONFIG_UNEVICTABLE_LRU
> -	{
> -		.ctl_name	= CTL_UNNUMBERED,
> -		.procname	= "scan_unevictable_pages",
> -		.data		= &scan_unevictable_pages,
> -		.maxlen		= sizeof(scan_unevictable_pages),
> -		.mode		= 0644,
> -		.proc_handler	= &scan_unevictable_handler,
> -	},
> -#endif
>  #ifdef CONFIG_SLOW_WORK
>  	{
>  		.ctl_name	= CTL_UNNUMBERED,
> @@ -1324,6 +1314,16 @@ static struct ctl_table vm_table[] = {
>  		.extra2		= &one,
>  	},
>  #endif
> +#ifdef CONFIG_UNEVICTABLE_LRU
> +	{
> +		.ctl_name	= CTL_UNNUMBERED,
> +		.procname	= "scan_unevictable_pages",
> +		.data		= &scan_unevictable_pages,
> +		.maxlen		= sizeof(scan_unevictable_pages),
> +		.mode		= 0644,
> +		.proc_handler	= &scan_unevictable_handler,
> +	},
> +#endif
>  /*
>   * NOTE: do not add new entries to this table unless you have read
>   * Documentation/sysctl/ctl_unnumbered.txt
> 

