Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbZLIJ2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbZLIJ2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:28:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbZLIJ2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:28:06 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:42584 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbZLIJ2D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:28:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LiVog6mxaLdY+fjQRRbgvnXGJc+sRMQitD9YyXmjDzTHI7Wn5k2oViyLge3Cv3BAnb
         M9ffocQ8M3nAgE0SaTUUnsnwLfHuIR5qXdq3HJFQPxdF3eGrY6SEu/KG34pXatb8UzD9
         407+yxHs/skxvsDUUYAlXm8JjXR4qrZBgFPNU=
MIME-Version: 1.0
In-Reply-To: <1260350401-9858-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1260350401-9858-1-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Wed, 9 Dec 2009 17:28:09 +0800
Message-ID: <2375c9f90912090128k70f54ee1n99421caa81c53a8f@mail.gmail.com>
Subject: Re: [PATCH] irq: handle irq0 special only on x86
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/9 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> I just noticed this when digging in the irq handling.  At least for arm
> this doesn't make sense.  Not sure if x86 is the only arch this test
> is valid for, but probably it is.

No, it is not.

Try grep -Inr 'irq0' arch/*/kernel.


>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> ---
>  kernel/irq/spurious.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
> index 22b0a6e..4996b66 100644
> --- a/kernel/irq/spurious.c
> +++ b/kernel/irq/spurious.c
> @@ -199,8 +199,10 @@ try_misrouted_irq(unsigned int irq, struct irq_desc *desc,
>        if (irqfixup < 2)
>                return 0;
>
> +#if defined(CONFIG_ARCH_X86)
>        if (!irq)
>                return 1;
> +#endif
>
>        /*
>         * Since we don't get the descriptor lock, "action" can
