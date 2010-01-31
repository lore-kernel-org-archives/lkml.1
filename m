Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894Ab0AaUcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab0AaUcX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 15:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437Ab0AaUcW
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 15:32:22 -0500
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:61739 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752644Ab0AaUcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 15:32:22 -0500
From: Frans Pop <elendil@planet.nl>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 09/10] mm/slab.c: Fix continuation line formats
Date: Sun, 31 Jan 2010 21:32:18 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       penberg@cs.helsinki.fi, mpm@selenic.com, linux-mm@kvack.org
References: <cover.1264967493.git.joe@perches.com> <cover.1264967493.git.joe@perches.com> <9d64ab1e1d69c750d53a398e09fe5da2437668c5.1264967500.git.joe@perches.com>
In-reply-To: <9d64ab1e1d69c750d53a398e09fe5da2437668c5.1264967500.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001312132.19798.elendil@planet.nl>
X-OriginalArrivalTime: 31 Jan 2010 20:32:19.0699 (UTC) FILETIME=[7C513430:01CAA2B4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> String constants that are continued on subsequent lines with \
> are not good.

Fun. I'd done the same grep earlier today. AFAICT you've got all the
ones I had.

> The characters between seq_printf elements are tabs.
> That was probably not intentional, but isn't being changed.
> It's behind an #ifdef, so it could probably become a single space.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  mm/slab.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index 7451bda..9964619 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -4228,8 +4228,8 @@ static int s_show(struct seq_file *m, void *p)
>  unsigned long node_frees = cachep->node_frees;
>  unsigned long overflows = cachep->node_overflow;
>  
> -		seq_printf(m, " : globalstat %7lu %6lu %5lu %4lu \
> -				%4lu %4lu %4lu %4lu %4lu", allocs, high, grown,
> +		seq_printf(m, " : globalstat %7lu %6lu %5lu %4lu 				%4lu %4lu %4lu %4lu %4lu",
> +				allocs, high, grown,
>  				reaped, errors, max_freeable, node_allocs,
>  				node_frees, overflows);
>  }

If that spacing part is really needed (is it?), wouldn't it be more
readable as:
> +		seq_printf(m, " : globalstat %7lu %6lu %5lu %4lu"
> +				" 				"
> +				"%4lu %4lu %4lu %4lu %4lu",  
> +				allocs, high, grown,

Also, are there supposed to be tabs in that spacing part?

Cheers,
FJP
