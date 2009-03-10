Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbZCJCPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbZCJCPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 22:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZCJCP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 22:15:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbZCJCP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 22:15:27 -0400
Date: Mon, 9 Mar 2009 19:14:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Ville Syrjala <syrjala@sci.fi>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] drivers/w1/masters/w1-gpio.c: fix read_bit()
Message-Id: <20090309191419.98699220.akpm@linux-foundation.org>
In-Reply-To: <1236614530-11153-1-git-send-email-daniel@caiaq.de>
References: <1236614530-11153-1-git-send-email-daniel@caiaq.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 Mar 2009 17:02:10 +0100 Daniel Mack <daniel@caiaq.de> wrote:

> W1 master implementations are expected to return 0 or 1 from their
> read_bit() function. However, not all platforms do return these values
> from gpio_get_value() - namely PXAs won't. Hence the w1 gpio-master
> needs to break the result down to 0 or 1 itself.
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Ville Syrjala <syrjala@sci.fi>
> Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> ---
>  drivers/w1/masters/w1-gpio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
> index 9e1138a..a411702 100644
> --- a/drivers/w1/masters/w1-gpio.c
> +++ b/drivers/w1/masters/w1-gpio.c
> @@ -39,7 +39,7 @@ static u8 w1_gpio_read_bit(void *data)
>  {
>  	struct w1_gpio_platform_data *pdata = data;
>  
> -	return gpio_get_value(pdata->pin);
> +	return gpio_get_value(pdata->pin) ? 1 : 0;
>  }
>  
>  static int __init w1_gpio_probe(struct platform_device *pdev)

We recently merged a patch (I forget where) which fixed one
gpio_get_value() implementation so that it always returns 0 or 1.

>From which I deduce that the correct fix for <whatever problem you're
seeing> is to fix <whichever driver that is>?
