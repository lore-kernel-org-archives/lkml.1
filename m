Return-Path: <linux-kernel-owner+w=401wt.eu-S1752534AbYCJRbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbYCJRbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 13:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbYCJRb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 13:31:26 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:38273 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbYCJRbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 13:31:25 -0400
Date: Mon, 10 Mar 2008 17:28:37 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Johannes Weiner <hannes@saeurebad.de>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Remove redundant display of free swap space in
 show_mem()
In-Reply-To: <87abl68rdd.fsf@saeurebad.de>
Message-ID: <Pine.LNX.4.64.0803101720580.3398@blonde.site>
References: <87abl68rdd.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008, Johannes Weiner wrote:
> From: Johannes Weiner <hannes@saeurebad.de>
> 
> show_free_areas() already displays free swap space, no need to do it a
> second time in show_mem() which calls the former anyway.
> 
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

I heartily approve of this; and yes, it's the per-arch one which should
go (since its "alignment" looks nasty).  But there's a lot more arches
than just x86 which should be fixed (and so rather more work, preparing
those patches for the various maintainers) - is that something you'd
have time to do?  (Don't worry, "No" is a perfectly fair answer, and
it's no way essential that all change at once.)

Thanks,
Hugh

> ---
>  arch/x86/mm/init_64.c    |    3 ---
>  arch/x86/mm/pgtable_32.c |    1 -
>  2 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 8230d1e..94baf63 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -89,9 +89,6 @@ void show_mem(void)
>  
>  	printk(KERN_INFO "Mem-info:\n");
>  	show_free_areas();
> -	printk(KERN_INFO "Free swap:       %6ldkB\n",
> -		nr_swap_pages << (PAGE_SHIFT-10));
> -
>  	for_each_online_pgdat(pgdat) {
>  		for (i = 0; i < pgdat->node_spanned_pages; ++i) {
>  			/*
> diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
> index 6530201..bacae27 100644
> --- a/arch/x86/mm/pgtable_32.c
> +++ b/arch/x86/mm/pgtable_32.c
> @@ -32,7 +32,6 @@ void show_mem(void)
>  
>  	printk(KERN_INFO "Mem-info:\n");
>  	show_free_areas();
> -	printk(KERN_INFO "Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
>  	for_each_online_pgdat(pgdat) {
>  		pgdat_resize_lock(pgdat, &flags);
>  		for (i = 0; i < pgdat->node_spanned_pages; ++i) {
