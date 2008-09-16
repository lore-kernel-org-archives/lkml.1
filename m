Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbYIPCQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbYIPCQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 22:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbYIPCQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 22:16:40 -0400
Received: from hs-out-0708.google.com ([64.233.178.250]:42464 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbYIPCQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 22:16:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=bNZhNooL1fSVxQg59NgAS2wOCLRo8wyxusCgxtc546MgaZA9uIldv5wbiBWZ9TbB7R
         twKag3SjWKtSviE/QaODAMS0Ed+zQ+Djq1EAD/CZ8Mc7FooaraMYR0fMDXfBgabfdPlY
         gg/AeIBa4P+EFbDnXtxiaac+2xsrwTLN0ja8c=
Message-ID: <386072610809151916j7ed1ad54i330a7ee0be692828@mail.gmail.com>
Date: Tue, 16 Sep 2008 10:16:38 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "=?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=" 
	<ukleinek@informatik.uni-freiburg.de>
Subject: Re: [PATCH] gpio_free might sleep, blackfin architecture
Cc: linux-kernel@vger.kernel.org, "David Brownell" <david-b@pacbell.net>,
       uclinux-dist-devel@blackfin.uclinux.org,
       "Guennadi Liakhovetski" <g.liakhovetski@pengutronix.de>,
       "Greg KH" <greg@kroah.com>, "Kay Sievers" <kay.sievers@vrfy.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Russell King" <rmk+kernel@arm.linux.org.uk>
In-Reply-To: <1221508963-27259-4-git-send-email-ukleinek@informatik.uni-freiburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1216884515-12084-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
	 <1221508963-27259-1-git-send-email-ukleinek@informatik.uni-freiburg.de>
	 <1221508963-27259-2-git-send-email-ukleinek@informatik.uni-freiburg.de>
	 <1221508963-27259-3-git-send-email-ukleinek@informatik.uni-freiburg.de>
	 <1221508963-27259-4-git-send-email-ukleinek@informatik.uni-freiburg.de>
X-Google-Sender-Auth: d9c71c1ed2439e39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 4:02 AM, Uwe Kleine-König
<ukleinek@informatik.uni-freiburg.de> wrote:
> According to the documentation gpio_free should only be called from task
> context only.  To make this more explicit add a might sleep to all
> implementations.
>
> This patch changes the gpio_free implementations for the blackfin
> architecture.
>

It looks fine for me, thanks a lot.

Acked-by: Bryan Wu <cooloney@kernel.org>


> Signed-off-by: Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
> Cc: David Brownell <david-b@pacbell.net>
> Cc: Bryan Wu <cooloney@kernel.org
> Cc: uclinux-dist-devel@blackfin.uclinux.org
> Cc: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
> Cc: Greg KH <greg@kroah.com>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  arch/blackfin/kernel/bfin_gpio.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
> index ecbd141..394006d 100644
> --- a/arch/blackfin/kernel/bfin_gpio.c
> +++ b/arch/blackfin/kernel/bfin_gpio.c
> @@ -1151,6 +1151,8 @@ void gpio_free(unsigned gpio)
>        if (check_gpio(gpio) < 0)
>                return;
>
> +       might_sleep();
> +
>        local_irq_save(flags);
>
>        if (unlikely(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)))) {
> --
> 1.5.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
