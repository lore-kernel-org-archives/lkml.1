Return-Path: <linux-kernel-owner+w=401wt.eu-S1758987AbXKGTEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbXKGTEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 14:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbXKGTEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 14:04:45 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:24959 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbXKGTEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 14:04:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Ql+xWJvYBfiMotmEDFydoD4lEmYWGLQrQnCWwY3XEy82xCDTJTXXwBaR9Hp4xQbkIG6+lrNeTBX4KC2Y//y93RZGG4wdRYH/Qqo3+XtefrKpukcQumLpo4Rgp6ZUBRxVPWNL2cxE/Yb6GtZ2YiaNdeJPvyy7Uhpg4hhbfRCSYyc=
Message-ID: <2c0942db0711071104x4360c38s930f6f9d494d4bb6@mail.gmail.com>
Date: Wed, 7 Nov 2007 11:04:41 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Roel Kluin" <12o3l@tiscali.nl>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix incorrect test in trident_ac97_set(); sound/oss/trident.c
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <473208ED.9000707@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47320533.4020400@tiscali.nl>
	 <2c0942db0711071043p7cd31f6di9031816c1fed81ca@mail.gmail.com>
	 <473208ED.9000707@tiscali.nl>
X-Google-Sender-Auth: 0aac1e41cca6b60b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 7, 2007 10:50 AM, Roel Kluin <12o3l@tiscali.nl> wrote:
> If count reaches zero, the loop ends, but the postfix decrement still subtracts:
> testing for 'count == 0' will not work.
>
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/sound/oss/trident.c b/sound/oss/trident.c
> index 96adc47..6959ee1 100644
> --- a/sound/oss/trident.c
> +++ b/sound/oss/trident.c
> @@ -2935,7 +2935,7 @@ trident_ac97_set(struct ac97_codec *codec, u8 reg, u16 val)
>         do {
>                 if ((inw(TRID_REG(card, address)) & busy) == 0)
>                         break;
> -       } while (count--);
> +       } while (--count);
>
>         data |= (mask | (reg & AC97_REG_ADDR));
>
> @@ -2996,7 +2996,7 @@ trident_ac97_get(struct ac97_codec *codec, u8 reg)
>                 data = inl(TRID_REG(card, address));
>                 if ((data & busy) == 0)
>                         break;
> -       } while (count--);
> +       } while (--count);
>
>         spin_unlock_irqrestore(&card->lock, flags);
>
>         if (count == 0) {
>

Thanks, much better. In the future, please also CC: the appropriate
maintainers, or Andrew Morton if you're at a loss...

Reviewed-by: Ray Lee <ray-lk@madrabbit.org>
