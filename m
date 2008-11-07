Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbYKGA1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbYKGA1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 19:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYKGA1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 19:27:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:32831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbYKGA1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 19:27:43 -0500
Date: Fri, 7 Nov 2008 01:27:42 +0100
From: Nick Piggin <npiggin@suse.de>
To: Glauber Costa <glommer@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH] restart search at beggining of vmalloc address
Message-ID: <20081107002742.GA12135@wotan.suse.de>
References: <1226005106-4974-1-git-send-email-glommer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226005106-4974-1-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excellent, thank you! Good catch

If you agree my previous patch was also good in combination with this one,
then I'll send them all to be merged.

Thanks,
Nick

On Thu, Nov 06, 2008 at 06:58:26PM -0200, Glauber Costa wrote:
> Current vmalloc restart search for a free area in case we
> can't find one. The reason is there are areas which are lazily
> freed, and could be possibly freed now. However, current implementation
> start searching the tree from the last failing address, which is
> pretty much by definition at the end of address space. So, we fail.
> 
> The proposal of this patch is to restart the search from the beginning
> of the requested vstart address. This fixes the regression in running
> KVM virtual machines for me, described in
> http://lkml.org/lkml/2008/10/28/349, caused by commit
> db64fe02258f1507e13fe5212a989922323685ce.
> 
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Nick Piggin <npiggin@suse.de>
> ---
>  mm/vmalloc.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 7db493d..6fe2003 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -378,6 +378,7 @@ found:
>  		if (!purged) {
>  			purge_vmap_area_lazy();
>  			purged = 1;
> +			addr = ALIGN(vstart, align);
>  			goto retry;
>  		}
>  		if (printk_ratelimit())
> -- 
> 1.5.6.5
