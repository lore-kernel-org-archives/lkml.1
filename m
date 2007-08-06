Return-Path: <linux-kernel-owner+w=401wt.eu-S932119AbXHFMGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbXHFMGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 08:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbXHFMGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 08:06:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:38019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764596AbXHFMGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 08:06:19 -0400
Date: Mon, 6 Aug 2007 14:06:17 +0200
From: Karsten Keil <kkeil@suse.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       isdn4linux@listserv.isdn4linux.de, Carsten Paeth <calle@calle.de>,
       Kai Germaschewski <kai@germaschewski.name>,
       Karsten Keil <kkeil@suse.de>,
       Kai Germaschewski <kai.germaschewski@gmx.de>
Subject: Re: [PATCH][RESEND][ISDN] Guard against a potential NULL pointer dereference in old_capi_manufacturer()
Message-ID: <20070806120617.GB12243@pingi.kke.suse.de>
Mail-Followup-To: Jesper Juhl <jesper.juhl@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	isdn4linux@listserv.isdn4linux.de, Carsten Paeth <calle@calle.de>,
	Kai Germaschewski <kai@germaschewski.name>,
	Karsten Keil <kkeil@suse.de>,
	Kai Germaschewski <kai.germaschewski@gmx.de>
References: <200708042031.54363.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708042031.54363.jesper.juhl@gmail.com>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.27-0.6-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2007 at 08:31:54PM +0200, Jesper Juhl wrote:
> (first send: Monday 25 June 2007, resending due to no response)
> (resending again on August 8'th, 2007)
> 
> 
> In drivers/isdn/capi/kcapi.c::old_capi_manufacturer(), if the call 
> to get_capi_ctr_by_nr(ldef.contr); in line 823 returns NULL, then 
> we'll be dereferencing a NULL pointer in the very next line.
> 
> (Found by Coverity checker as bug #402)
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Acked-by: Karsten Keil <kkeil@suse.de>

> ---
> 
>  drivers/isdn/capi/kcapi.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/isdn/capi/kcapi.c b/drivers/isdn/capi/kcapi.c
> index 3ed34f7..3f9e962 100644
> --- a/drivers/isdn/capi/kcapi.c
> +++ b/drivers/isdn/capi/kcapi.c
> @@ -821,6 +821,8 @@ static int old_capi_manufacturer(unsigned int cmd, void 
> __user *data)
>  				return -EFAULT;
>  		}
>  		card = get_capi_ctr_by_nr(ldef.contr);
> +		if (!card)
> +			return -EINVAL;
>  		card = capi_ctr_get(card);
>  		if (!card)
>  			return -ESRCH;
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
