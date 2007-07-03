Return-Path: <linux-kernel-owner+w=401wt.eu-S1756992AbXGCEln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbXGCEln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 00:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbXGCElg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 00:41:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59889 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177AbXGCElf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 00:41:35 -0400
Date: Mon, 2 Jul 2007 21:41:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ed L. Cashin" <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org, Greg K-H <greg@kroah.com>
Subject: Re: [PATCH 10/12] add module parameter for users who need more
 outstanding I/O
Message-Id: <20070702214100.ed81e921.akpm@linux-foundation.org>
In-Reply-To: <772666addf79d3a3675f5f460228532fcd8f7364.1182883861.git.ecashin@coraid.com>
References: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
	<772666addf79d3a3675f5f460228532fcd8f7364.1182883861.git.ecashin@coraid.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 14:50:12 -0400 "Ed L. Cashin" <ecashin@coraid.com> wrote:

> Add module parameter for users who need more outstanding I/O.
> 

why?

I assume that there is some performance benefit to permitting some more
outstanding IO, but that's just a wild guess.

Assuming that the guess is right, some explanation of the effects of
altering this tunable would be appropriate.


> ---
>  drivers/block/aoe/aoecmd.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
> index 8d6540b..9de0024 100644
> --- a/drivers/block/aoe/aoecmd.c
> +++ b/drivers/block/aoe/aoecmd.c
> @@ -17,6 +17,11 @@ static int aoe_deadsecs = 60 * 3;
>  module_param(aoe_deadsecs, int, 0644);
>  MODULE_PARM_DESC(aoe_deadsecs, "After aoe_deadsecs seconds, give up and fail dev.");
>  
> +static int aoe_maxout = 16;
> +module_param(aoe_maxout, int, 0644);
> +MODULE_PARM_DESC(aoe_maxout,
> +	"Only aoe_maxout outstanding packets for every MAC on eX.Y.");
> +
>  static struct sk_buff *
>  new_skb(ulong len)
>  {
> @@ -967,7 +972,6 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
>  	struct aoeif *ifp;
>  	ulong flags, sysminor, aoemajor;
>  	struct sk_buff *sl;
> -	enum { MAXFRAMES = 16 };
>  	u16 n;
>  
>  	h = aoe_hdr(skb);
> @@ -992,8 +996,8 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
>  	}
>  
>  	n = be16_to_cpu(ch->bufcnt);
> -	if (n > MAXFRAMES)	/* keep it reasonable */
> -		n = MAXFRAMES;
> +	if (n > aoe_maxout)	/* keep it reasonable */
> +		n = aoe_maxout;
>  
>  	d = aoedev_by_sysminor_m(sysminor);
>  	if (d == NULL) {
> -- 
> 1.5.2.1
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
