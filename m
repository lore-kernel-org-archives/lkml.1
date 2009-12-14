Return-Path: <linux-kernel-owner+w=401wt.eu-S1758835AbZLNXwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbZLNXwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758812AbZLNXwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:52:13 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:49425 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758818AbZLNXwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:52:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=KvE6RguMsp9XPw3t7TkVsZA9x7r1Wk96my6P0gNmADfwUtM8u2FQnJuLlwEc2u9auY
         LdmkHv0Mg6/l402fi0SaMU+warJaiByvNILFLfgL0xnX9W6a0nt6eHyNfI/Siy8FRJ5u
         ag6lcfHMKpKOllqOuqPtFo0jY+elNJiDjERCw=
Date: Tue, 15 Dec 2009 08:46:36 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, lwoodman@redhat.com,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Subject: Re: [PATCH 5/8] Use io_schedule() instead schedule()
Message-Id: <20091215084636.c7790658.minchan.kim@barrios-desktop>
In-Reply-To: <20091214213026.BBBD.A69D9226@jp.fujitsu.com>
References: <20091211164651.036f5340@annuminas.surriel.com>
	<20091214210823.BBAE.A69D9226@jp.fujitsu.com>
	<20091214213026.BBBD.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 21:30:54 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> All task sleeping point in vmscan (e.g. congestion_wait) use
> io_schedule. then shrink_zone_begin use it too.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/vmscan.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3562a2d..0880668 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1624,7 +1624,7 @@ static int shrink_zone_begin(struct zone *zone, struct scan_control *sc)
>  		    max_zone_concurrent_reclaimers)
>  			break;
>  
> -		schedule();
> +		io_schedule();

Hmm. We have many cond_resched which is not io_schedule in vmscan.c.
In addition, if system doesn't have swap device space and out of page cache 
due to heavy memory pressue, VM might scan & drop pages until priority is zero
or zone is unreclaimable. 

I think it would be not a IO wait.





>  
>                 /*
>                  * If other processes freed enough memory while we waited,
> -- 
> 1.6.5.2
> 
> 
> 


-- 
Kind regards,
Minchan Kim
