Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbXEGFYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbXEGFYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 01:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbXEGFYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 01:24:50 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:47811 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbXEGFYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 01:24:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pmXdG6f3OHsoAQg8UNjcbZQPBQFEWBqpZGc8NAfjEmHCHMsf7BFfSasd8cuNG9iHCnpXf4ZL9HxX89XFh5IRmNWJLchLPcvDGmUdP3m0VEMsYSg5xnqvWjYVovx4ER+LHFUclBG5cd1k02BBx78qs/kzN/luL4e0D6WPwEOw/+0=
Message-ID: <f19298770705062224v5f60535bn7dfce17f4a5e04f@mail.gmail.com>
Date: Mon, 7 May 2007 09:24:48 +0400
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Krzysztof Halasa" <khc@pm.waw.pl>
Subject: Re: [PATCH 2/3] ARM: include IXP4xx "fuses" support
Cc: "Jeff Garzik" <jeff@garzik.org>, "Russell King" <rmk@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <m3wszlbiom.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <m3abwhcy74.fsf@maximus.localdomain>
	 <m3wszlbiom.fsf@maximus.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Krzysztof.

On 5/7/07, Krzysztof Halasa <khc@pm.waw.pl> wrote:
...
> +                                IXP4XX_FUSE_RSA |                      \
> +                                IXP4XX_FUSE_XSCALE_MAX_FREQ)
> +

#ifndef __ASSEMBLY__

> +static inline u32 ixp4xx_read_fuses(void)
> +{
> +       unsigned int fuses = ~*IXP4XX_EXP_CFG2;
...
> +       fuses &= ~IXP4XX_FUSE_RESERVED;
> +}

#endif /* __ASSEMBLY__ */

> +
>  #endif


Are you sure this is the version you wanted to send? I don't see how this could
compile without this #ifndef. And also there is some problem with undefined
processor_id, but this is not your fault, but a flaw in the pre-rc1
kernel, which
I hope is now noticed. So maybe you should just send the patches made for
the 2.6.21 kernel?

Otherwise, when applied on top of my 2.6.20 kernel, the driver just
works (at least
I see the pings, haven't considered any other tests yet), thank you a lot!
