Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab0BHVHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 16:07:54 -0500
Received: from mail-pz0-f172.google.com ([209.85.222.172]:62292 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab0BHVHx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 16:07:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Mp4R2AZi6CunbETgN4wcKTz+coWbVGketS33JD8q4WVPT91NVM4qTDl0zY8eNp1UeL
         Hv9zLMl9clyla1oQYLrtfDG51OxzakiQ/7s5T4ydl450Lv/SkDXWwgV7+fO+uS6J6911
         GCg0a5wcM1zI/1PiyQlv5fjOOvPR6MqAMjotc=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1002060943220.8092@ask.diku.dk>
References: <Pine.LNX.4.64.1002060943220.8092@ask.diku.dk>
Date: Mon, 8 Feb 2010 14:07:52 -0700
X-Google-Sender-Auth: 962cd7eedb6830be
Message-ID: <e9c3a7c21002081307j567413adg6ed8aa04bf153e41@mail.gmail.com>
Subject: Re: [PATCH 6/11] drivers/dma: Correct NULL test
From: Dan Williams <dan.j.williams@intel.com>
To: Julia Lawall <julia@diku.dk>, Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ adding Linus in case this BUG_ON had a different intent, or can be deleted ]

On Sat, Feb 6, 2010 at 1:43 AM, Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
>
> cohd_fin has already been verified not to be NULL, so the argument to
> BUG_ON cannot be true.
>
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @r@
> expression *x;
> expression e;
> identifier l;
> @@
>
> if (x == NULL || ...) {
>    ... when forall
>    return ...; }
> ... when != goto l;
>    when != x = e
>    when != &x
> *x == NULL
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
>
> ---
>  drivers/dma/coh901318.c             |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
> index b5f2ee0..64a9372 100644
> --- a/drivers/dma/coh901318.c
> +++ b/drivers/dma/coh901318.c
> @@ -613,8 +613,6 @@ static void dma_tasklet(unsigned long data)
>        cohd_fin->pending_irqs--;
>        cohc->completed = cohd_fin->desc.cookie;
>
> -       BUG_ON(cohc->nbr_active_done && cohd_fin == NULL);
> -
>        if (cohc->nbr_active_done == 0)
>                return;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
