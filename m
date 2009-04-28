Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbZD1ElS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbZD1ElS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 00:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbZD1ElG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 00:41:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56842 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbZD1ElF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 00:41:05 -0400
Date: Tue, 28 Apr 2009 06:41:02 +0200
From: Nick Piggin <npiggin@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slqb: enforce MAX_ORDER
Message-ID: <20090428044102.GC6304@wotan.suse.de>
References: <alpine.DEB.2.00.0904261255520.18988@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904261255520.18988@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 26, 2009 at 12:56:31PM -0700, David Rientjes wrote:
> Slabs may not be allocated at MAX_ORDER or higher.
> 
> Cc: Nick Piggin <npiggin@suse.de>
> Signed-off-by: David Rientjes <rientjes@google.com>

Thanks

> ---
>  mm/slqb.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slqb.c b/mm/slqb.c
> --- a/mm/slqb.c
> +++ b/mm/slqb.c
> @@ -872,6 +872,7 @@ __setup("slqb_debug", setup_slqb_debug);
>  static int __init setup_slqb_min_order(char *str)
>  {
>  	get_option(&str, &slqb_min_order);
> +	slqb_min_order = min(slqb_min_order, MAX_ORDER - 1);
>  
>  	return 1;
>  }
> @@ -1840,8 +1841,8 @@ static int calculate_order(int size)
>  	 * This size cannot fit in order-1. Allow bigger orders, but
>  	 * forget about trying to save space.
>  	 */
> -	order = slab_order(size, MAX_ORDER, 0);
> -	if (order <= MAX_ORDER)
> +	order = slab_order(size, MAX_ORDER - 1, 0);
> +	if (order < MAX_ORDER)
>  		return order;
>  
>  	return -ENOSYS;
