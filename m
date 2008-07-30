Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbYG3H7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbYG3H7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 03:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYG3H7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 03:59:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751808AbYG3H7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 03:59:37 -0400
Date: Wed, 30 Jul 2008 00:58:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sven Wegener <sven.wegener@stealer.net>
Cc: Richard Purdie <rpurdie@rpsys.net>, Rod Whitby <rod@whitby.id.au>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds-fsg: Change order of initialization and
 deinitialization
Message-Id: <20080730005853.3f343d93.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.1.10.0807272016570.16340@titan.stealer.net>
References: <alpine.LNX.1.10.0807272016570.16340@titan.stealer.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jul 2008 20:30:59 +0200 (CEST) Sven Wegener <sven.wegener@stealer.net> wrote:

> --- a/drivers/leds/leds-fsg.c
> +++ b/drivers/leds/leds-fsg.c
> @@ -161,6 +161,16 @@ static int fsg_led_probe(struct platform_device *pdev)
>  {
>  	int ret;
>  
> +	/* Map the LED chip select address space */
> +	latch_address = (unsigned short *) ioremap(IXP4XX_EXP_BUS_BASE(2), 512);
> +	if (!latch_address) {
> +		ret = -ENOMEM;
> +		goto failremap;
> +	}
> +
> +	latch_value = 0xffff;
> +	*latch_address = latch_value;

Mutter.  Shouldn't this driver be using readw/writew?  It's not even
using a volatile pointer, so there's a decent risk that the compiler
will optimise away important things..

