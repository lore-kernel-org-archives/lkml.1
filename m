Return-Path: <linux-kernel-owner+w=401wt.eu-S932567AbZKBXhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbZKBXhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 18:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757317AbZKBXhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 18:37:11 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:45336 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313AbZKBXhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 18:37:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Wln3vF0fT6M0TQcCu5sBGyNbNYO87zNtiOSoAIdPpxFC9DS1lwh82u2CiFUY4Suhad
         CqcCpw/qDHqD37gVqhhtnpMfKgFkjNbjwsV0vc9p1U4evvJInvuJIGyI3qwrROExT7tm
         cHcjvaG9ef/AVyRIYDulEukwu3HDiH9uU77hY=
Date: Tue, 3 Nov 2009 08:34:16 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv2 1/5] vmscan: separate sc.swap_cluster_max and
 sc.nr_max_reclaim
Message-Id: <20091103083416.a09dac3b.minchan.kim@barrios-desktop>
In-Reply-To: <20091103001211.8866.A69D9226@jp.fujitsu.com>
References: <20091101234614.F401.A69D9226@jp.fujitsu.com>
	<20091102093517.32021780.minchan.kim@barrios-desktop>
	<20091103001211.8866.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009 00:35:30 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi
> 
> > > @@ -1932,6 +1938,7 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order)
> > >  		.may_unmap = 1,
> > >  		.may_swap = 1,
> > >  
> > 		.swap_cluster_max = SWAP_CLUSTER_MAX,
> > Or add comment in here. 
> > 
> > 'kswapd doesn't want to be bailed out while reclaim.'
> 
> OK, reasonable.
> How about this?
> 
>
> 
> ---
>  mm/vmscan.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7fb3435..84e4da0 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1930,6 +1930,10 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order)
>  		.gfp_mask = GFP_KERNEL,
>  		.may_unmap = 1,
>  		.may_swap = 1,
> +		/*
> +		 * kswapd doesn't want to be bailed out while reclaim. because
> +		 * we want to put equal scanning pressure on each zone.
> +		 */
>  		.nr_to_reclaim = ULONG_MAX,
>  		.swappiness = vm_swappiness,
>  		.order = order,
> -- 
> 1.6.2.5
> 


Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
It looks good than mine.
Thanks, Kosaki. :)



-- 
Kind regards,
Minchan Kim
