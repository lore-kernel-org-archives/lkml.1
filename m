Return-Path: <linux-kernel-owner+w=401wt.eu-S1764587AbZDHMea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764587AbZDHMea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756954AbZDHMeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:34:16 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:61390 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758965AbZDHMeP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:34:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lA53tGu5qDcA8q+pqFrcUZPnl9/vsnBdpL53yVzxWL02HJK26fhpJww6VBFLKClv/o
         v931WOsieOaWcbgzigGzdr7RoL1hDfLQhjOnAX0JrC59jWIdKm12Spxn/AKWl2bZZSHD
         +6bRToQNRrIDvdEGDSpxAYHjbTnYPu0hfWxxE=
MIME-Version: 1.0
In-Reply-To: <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
Date: Wed, 8 Apr 2009 14:34:12 +0200
Message-ID: <36ca99e90904080534g54a1d4f3ue782b8598d238090@mail.gmail.com>
Subject: Re: [PATCH 08/56] cris: Remove void casts
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 13:21, Jack Stone <jwjstone@fastmail.fm> wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  arch/cris/arch-v32/drivers/cryptocop.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/cris/arch-v32/drivers/cryptocop.c b/arch/cris/arch-v32/drivers/cryptocop.c
> index 67c61ea..5d20327 100644
> --- a/arch/cris/arch-v32/drivers/cryptocop.c
> +++ b/arch/cris/arch-v32/drivers/cryptocop.c
> @@ -2455,7 +2455,7 @@ static int map_pages_to_iovec(struct iovec *iov, int iovlen, int *iovix, struct
>                        DEBUG_API(printk("map_page_to_iovec: *pageix=%d >= nopages=%d\n", *pageix, nopages));
>                        return 0;
>                }
> -               iov[*iovix].iov_base = (unsigned char*)page_address(pages[*pageix]) + *pageoffset;
> +               iov[*iovix].iov_base = page_address(pages[*pageix]) + *pageoffset;
Pointer arithmetic or intended cast (to avoid warnings for void
pointer arithmetic).

>                tmplen = PAGE_SIZE - *pageoffset;
>                if (tmplen < map_length){
>                        (*pageoffset) = 0;
> @@ -2780,16 +2780,16 @@ static int cryptocop_ioctl_process(struct inode *inode, struct file *filp, unsig
>                size_t tmplen = cop->tfrm_op.inlen;
>
>                cop->tfrm_op.indata[0].iov_len = PAGE_SIZE - ((unsigned long int)(oper.indata + prev_ix) & ~PAGE_MASK);
> -               cop->tfrm_op.indata[0].iov_base = (unsigned char*)page_address(inpages[0]) + ((unsigned long int)(oper.indata + prev_ix) & ~PAGE_MASK);
> +               cop->tfrm_op.indata[0].iov_base = page_address(inpages[0]) + ((unsigned long int)(oper.indata + prev_ix) & ~PAGE_MASK);
Dito.

>                tmplen -= cop->tfrm_op.indata[0].iov_len;
>                for (i = 1; i<noinpages; i++){
>                        cop->tfrm_op.indata[i].iov_len = tmplen < PAGE_SIZE ? tmplen : PAGE_SIZE;
> -                       cop->tfrm_op.indata[i].iov_base = (unsigned char*)page_address(inpages[i]);
> +                       cop->tfrm_op.indata[i].iov_base = page_address(inpages[i]);
>                        tmplen -= PAGE_SIZE;
>                }
>        } else {
>                cop->tfrm_op.indata[0].iov_len = oper.inlen - prev_ix;
> -               cop->tfrm_op.indata[0].iov_base = (unsigned char*)page_address(inpages[0]) + ((unsigned long int)(oper.indata + prev_ix) & ~PAGE_MASK);
> +               cop->tfrm_op.indata[0].iov_base = page_address(inpages[0]) + ((unsigned long int)(oper.indata + prev_ix) & ~PAGE_MASK);
Dito.

>        }
>
>        iovlen = nooutpages + 6;
> --
Bert
