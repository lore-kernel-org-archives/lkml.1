Return-Path: <linux-kernel-owner+w=401wt.eu-S1759795AbXKGSoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795AbXKGSoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbXKGSoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:44:00 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:57235 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbXKGSn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:43:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=LRv/ez5hhwRPdJ47W49AKfJ/k2hJo3UUYC2hWfKkAbvTqBlaHtBk73NOVgLSmRJo7MqwLXcMuARuzgjKwSoYj4D5UJx1tJp2CG3AgXdu79KvUgVRCDe/wRN78uwoqDv0N6jrQ+3S0pM+nlP23a+CrPbJNtznk3Fx8aJwRvdB9gg=
Message-ID: <2c0942db0711071043p7cd31f6di9031816c1fed81ca@mail.gmail.com>
Date: Wed, 7 Nov 2007 10:43:56 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Roel Kluin" <12o3l@tiscali.nl>
Subject: Re: [PATCH] fix incorrect test in trident_ac97_set(); sound/oss/trident.c
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <47320533.4020400@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47320533.4020400@tiscali.nl>
X-Google-Sender-Auth: 4cd3c4efa94b03a6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 7, 2007 10:34 AM, Roel Kluin <12o3l@tiscali.nl> wrote:
> If count reaches zero, the loop ends, but the postfix decrement subtracts it.
> so, testing for 'count == 0' will not work.
>
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/sound/oss/trident.c b/sound/oss/trident.c
> index 96adc47..94b5fb4 100644
> --- a/sound/oss/trident.c
> +++ b/sound/oss/trident.c
> @@ -2939,7 +2939,7 @@ trident_ac97_set(struct ac97_codec *codec, u8 reg, u16 val)
>
>         data |= (mask | (reg & AC97_REG_ADDR));
>
> -       if (count == 0) {
> +       if (count == -1) {
>                 printk(KERN_ERR "trident: AC97 CODEC write timed out.\n");
>                 spin_unlock_irqrestore(&card->lock, flags);
>                 return;
> @@ -2999,7 +2999,7 @@ trident_ac97_get(struct ac97_codec *codec, u8 reg)
>         } while (count--);
>         spin_unlock_irqrestore(&card->lock, flags);
>
> -       if (count == 0) {
> +       if (count == -1) {
>                 printk(KERN_ERR "trident: AC97 CODEC read timed out.\n");
>                 data = 0;
>         }

You didn't test this: count is unsigned. Change the loop condition to
be --count instead.

Ray
