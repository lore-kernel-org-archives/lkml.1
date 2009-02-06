Return-Path: <linux-kernel-owner+w=401wt.eu-S1757653AbZBFOCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbZBFOCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 09:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbZBFOCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:02:44 -0500
Received: from mga07.intel.com ([143.182.124.22]:12823 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751986AbZBFOCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:02:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,391,1231142400"; 
   d="scan'208";a="107943422"
Date: Fri, 6 Feb 2009 15:05:06 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/mfd: Adjust NULL test
Message-ID: <20090206140505.GH3341@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <Pine.LNX.4.64.0812211907400.9555@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812211907400.9555@pc-004.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2008 at 07:08:09PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Since ei is already known to be non-NULL, I assume that what was intended
> was to test the result of kzalloc.
Makes sense, thanks. Applied to my for-linus branch.

Cheers,
Samuel.

 
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> expression E,E1;
> identifier f,fld,fld1;
> statement S1,S2;
> @@
> 
> E->fld = f(...);
> ... when != E = E1
>     when != E->fld1 = E1
> if (
> -   E
> +   E->fld
>            == NULL) S1 else S2
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/mfd/htc-egpio.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -u -p a/drivers/mfd/htc-egpio.c b/drivers/mfd/htc-egpio.c
> --- a/drivers/mfd/htc-egpio.c
> +++ b/drivers/mfd/htc-egpio.c
> @@ -307,7 +307,7 @@ static int __init egpio_probe(struct pla
>  
>  	ei->nchips = pdata->num_chips;
>  	ei->chip = kzalloc(sizeof(struct egpio_chip) * ei->nchips, GFP_KERNEL);
> -	if (!ei) {
> +	if (!ei->chip) {
>  		ret = -ENOMEM;
>  		goto fail;
>  	}

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
