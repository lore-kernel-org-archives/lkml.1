Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbYGWXUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbYGWXUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 19:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbYGWXT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 19:19:58 -0400
Received: from smtprelay09.ispgateway.de ([80.67.29.23]:53390 "EHLO
	smtprelay09.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbYGWXT6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 19:19:58 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Uwe =?utf-8?q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
Subject: Re: [PATCH] set_irq_wake: fix return code and wake status tracking
Date: Wed, 23 Jul 2008 20:44:14 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <1216816945-20223-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
In-Reply-To: <1216816945-20223-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807232044.15049.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

you can mark the new function static.

[trimmed CC list, since this is just a minor issue]

On Wednesday 23 July 2008, Uwe Kleine-König wrote:
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index e01ad8e..227cd49 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -194,6 +194,17 @@ void enable_irq(unsigned int irq)
>  }
>  EXPORT_SYMBOL(enable_irq);
>  
> +int set_irq_wake_real(unsigned int irq, unsigned int on)
static int set_irq_wake_real(unsigned int irq, unsigned int on)

> +{
> +	struct irq_desc *desc = irq_desc + irq;
> +	int ret = -ENXIO;
> +
> +	if (desc->chip->set_wake)
> +		ret = desc->chip->set_wake(irq, on);
> +
> +	return ret;
> +}
> +

Best Regards

Ingo Oeser
