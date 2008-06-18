Return-Path: <linux-kernel-owner+w=401wt.eu-S1752874AbYFRQ3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbYFRQ3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 12:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYFRQ2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 12:28:47 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:38602 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbYFRQ2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 12:28:46 -0400
Date: Wed, 18 Jun 2008 17:28:16 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andreas Herrmann <andreas.herrmann3@amd.com>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 5/5 v2] x86: PAT: make pat_x_mtrr_type() more readable
In-Reply-To: <20080618133857.GB5213@alberich.amd.com>
Message-ID: <Pine.LNX.4.64.0806181717380.20372@blonde.site>
References: <20080610140755.GI5024@alberich.amd.com> <20080616125821.GA5213@alberich.amd.com>
 <Pine.LNX.4.64.0806161753060.13075@blonde.site> <20080618133857.GB5213@alberich.amd.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2008, Andreas Herrmann wrote:
> And the attached patch makes it even shorter.
> (patch against tip/x86/pat -- where your patch is already residing)

Yes, that's delightful, even better, thanks.  After accusing you
of an uninteresting BUG on a fifth value from 2 bits, I had an
inkling that maybe my patch was therefore still stupidly verbose.

> ---
> [PATCH] x86: shrink pat_x_mtrr_type to its essentials
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

Acked-by: Hugh Dickins <hugh@veritas.com>

> ---
>  arch/x86/mm/pat.c |   30 +++++++++++-------------------
>  1 files changed, 11 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index ac3a2b1..227df3c 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -161,29 +161,21 @@ static DEFINE_SPINLOCK(memtype_lock); 	/* protects memtype list */
>   */
>  static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
>  {
> -	u8 mtrr_type;
> -
> -	/*
> -	 * We return the PAT request directly for types where PAT takes
> -	 * precedence with respect to MTRR and for UC_MINUS.
> -	 * Consistency checks with other PAT requests is done later
> -	 * while going through memtype list.
> -	 */
> -	if (req_type == _PAGE_CACHE_WC ||
> -	    req_type == _PAGE_CACHE_UC_MINUS ||
> -	    req_type == _PAGE_CACHE_UC)
> -		return req_type;
> -
>  	/*
>  	 * Look for MTRR hint to get the effective type in case where PAT
>  	 * request is for WB.
>  	 */
> -	mtrr_type = mtrr_type_lookup(start, end);
> -	if (mtrr_type == MTRR_TYPE_UNCACHABLE)
> -		return _PAGE_CACHE_UC;
> -	if (mtrr_type == MTRR_TYPE_WRCOMB)
> -		return _PAGE_CACHE_WC;
> -	return _PAGE_CACHE_WB;
> +	if (req_type == _PAGE_CACHE_WB) {
> +		u8 mtrr_type;
> +
> +		mtrr_type = mtrr_type_lookup(start, end);
> +		if (mtrr_type == MTRR_TYPE_UNCACHABLE)
> +			return _PAGE_CACHE_UC;
> +		if (mtrr_type == MTRR_TYPE_WRCOMB)
> +			return _PAGE_CACHE_WC;
> +	}
> +
> +	return req_type;
>  }
>  
>  /*
