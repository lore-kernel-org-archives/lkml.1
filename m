Return-Path: <linux-kernel-owner+w=401wt.eu-S1765935AbZDHOGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765935AbZDHOGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764133AbZDHOFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:05:47 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:51681 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759371AbZDHOFq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QFGDgsMf8FxwnqDy74NXaBpYSK7t06dWUxcwoxE7oAW0owzR6MAn38VPtiI79lDTJG
         bl1qlNeXqhoZx2Ny2xmYRch8auUENGnCE/1eOFlSzIONgyCJLVAng8qfO7IUD57KA3Xe
         6Xym7kitcKtF6IqcQuprvJS78j8fXz+7jVFG8=
MIME-Version: 1.0
In-Reply-To: <49DCAC88.7010500@fastmail.fm>
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>
	 <36ca99e90904080439u7098d2feka5dd39f8ab6a470c@mail.gmail.com>
	 <49DCAC88.7010500@fastmail.fm>
Date: Wed, 8 Apr 2009 15:05:43 +0100
Message-ID: <87a5b0800904080705n74829b75l8becfd6e7d1a321f@mail.gmail.com>
Subject: Re: [PATCH 20/56] inflate: Remove void casts
From: Will Newton <will.newton@gmail.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Bert Wesarg <bert.wesarg@googlemail.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 2:54 PM, Jack Stone <jwjstone@fastmail.fm> wrote:
> Heres the fixed patch
>
> Thanks,
>
> Jack
>
> --
>
> inflate: Remove void casts
>
> From: Jack Stone <jwjstone@fastmail.fm>
>
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>
>  lib/inflate.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/lib/inflate.c b/lib/inflate.c
> index 1a8e8a9..1eb0cd8 100644
> --- a/lib/inflate.c
> +++ b/lib/inflate.c
> @@ -249,7 +249,7 @@ static void *malloc(int size)
>
>        malloc_ptr = (malloc_ptr + 3) & ~3;     /* Align */
>
> -       p = (void *)malloc_ptr;
> +       p = malloc_ptr;
>        malloc_ptr += size;

Won't this cause a "assignment makes pointer from integer without a
cast" warning?

>        if (free_mem_end_ptr && malloc_ptr >= free_mem_end_ptr)
> @@ -481,8 +481,7 @@ DEBG1("3 ");
>         z = 1 << j;             /* table entries for j-bit table */
>
>         /* allocate and link in new table */
> -        if ((q = (struct huft *)malloc((z + 1)*sizeof(struct huft))) ==
> -            (struct huft *)NULL)
> +        if ((q = malloc((z + 1)*sizeof(struct huft))) == NULL)
>         {
>           if (h)
>             huft_free(u[0]);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
