Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575Ab0AQTiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab0AQTiA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 14:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527Ab0AQTh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 14:37:59 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:41982 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab0AQTh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 14:37:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Gd31z6H98iyOoKKMzT04RG6QmIecV5pEfOJXfQF1YF4P2c3L/pH9fMToyHn6VYwGMc
         TKodyKYZMtokAQBnEgRzTlUik1JNo8GMLWL9vNT7HS4j6jRvbfqUn6zIrE3hUGFe32AH
         JWLA/Ubp2f/rhDfNAXt+glm/PHafErUwij9jo=
Message-ID: <4B536710.4010304@gmail.com>
Date: Sun, 17 Jan 2010 21:37:52 +0200
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Gemini: wrong registers used to set reg_level in gpio_set_irq_type()?
References: <4B4F8877.6080105@gmail.com>
In-Reply-To: <4B4F8877.6080105@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2010 11:11 PM, Roel Kluin wrote:
> It appears the wrong GPIO registers were used
>
> Signed-off-by: Roel Kluin<roel.kluin@gmail.com>
> ---
> I am not sure whether this is right so please review.

Yes, you are right. Thanks for spotting.
I put this patch in my queue.

> diff --git a/arch/arm/mach-gemini/gpio.c b/arch/arm/mach-gemini/gpio.c
> index e726385..fe3bd5a 100644
> --- a/arch/arm/mach-gemini/gpio.c
> +++ b/arch/arm/mach-gemini/gpio.c
> @@ -86,7 +86,7 @@ static int gpio_set_irq_type(unsigned int irq, unsigned int type)
>   	unsigned int reg_both, reg_level, reg_type;
>
>   	reg_type = __raw_readl(base + GPIO_INT_TYPE);
> -	reg_level = __raw_readl(base + GPIO_INT_BOTH_EDGE);
> +	reg_level = __raw_readl(base + GPIO_INT_LEVEL);
>   	reg_both = __raw_readl(base + GPIO_INT_BOTH_EDGE);
>
>   	switch (type) {
> @@ -117,7 +117,7 @@ static int gpio_set_irq_type(unsigned int irq, unsigned int type)
>   	}
>
>   	__raw_writel(reg_type, base + GPIO_INT_TYPE);
> -	__raw_writel(reg_level, base + GPIO_INT_BOTH_EDGE);
> +	__raw_writel(reg_level, base + GPIO_INT_LEVEL);
>   	__raw_writel(reg_both, base + GPIO_INT_BOTH_EDGE);
>
>   	gpio_ack_irq(irq);

