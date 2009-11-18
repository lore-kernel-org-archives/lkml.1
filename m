Return-Path: <linux-kernel-owner+w=401wt.eu-S1757785AbZKRQdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785AbZKRQdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757774AbZKRQdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:33:00 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:53747 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757770AbZKRQc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:32:58 -0500
X-Trace: 288731698/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.56.48/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.56.48
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjUBAMewA0tPRTgw/2dsb2JhbAAI1lGEOwQ
X-IronPort-AV: E=Sophos;i="4.44,766,1249254000"; 
   d="scan'208";a="288731698"
Date: Wed, 18 Nov 2009 16:32:43 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/6] mm: mlocking in try_to_unmap_one
In-Reply-To: <20091117103620.3DC4.A69D9226@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0911181629000.29205@sister.anvils>
References: <20091113143930.33BF.A69D9226@jp.fujitsu.com>
 <Pine.LNX.4.64.0911152217030.29917@sister.anvils> <20091117103620.3DC4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009, KOSAKI Motohiro wrote:
> 
> From 7332f765dbaa1fbfe48cf8d53b20048f7f8105e0 Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Tue, 17 Nov 2009 10:46:51 +0900
> Subject: comment adding to mlocking in try_to_unmap_one
> 
> Current code doesn't tell us why we don't bother to nonlinear kindly.
> This patch added small adding explanation.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

(if the "MLOCK_PAGES && " is removed from this one too)

> ---
>  mm/rmap.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 81a168c..c631407 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1061,7 +1061,11 @@ static int try_to_unmap_file(struct page *page, enum ttu_flags flags)
>  	if (list_empty(&mapping->i_mmap_nonlinear))
>  		goto out;
>  
> -	/* We don't bother to try to find the munlocked page in nonlinears */
> +	/*
> +	 * We don't bother to try to find the munlocked page in nonlinears.
> +	 * It's costly. Instead, later, page reclaim logic may call
> +	 * try_to_unmap(TTU_MUNLOCK) and recover PG_mlocked lazily.
> +	 */
>  	if (MLOCK_PAGES && TTU_ACTION(flags) == TTU_MUNLOCK)
>  		goto out;
>  
> -- 
> 1.6.2.5
