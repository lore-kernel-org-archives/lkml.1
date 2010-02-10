Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab0BJTHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 14:07:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33206
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756471Ab0BJTHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 14:07:44 -0500
Date: Wed, 10 Feb 2010 11:07:56 -0800 (PST)
Message-Id: <20100210.110756.201335073.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-02-10
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100210185816.GB3286@tuxdriver.com>
References: <20100210185816.GB3286@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 10 Feb 2010 13:58:16 -0500

> Please let me know if there are problems!

I see one:

> diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
> index 5681ebe..03dfd27 100644
> --- a/drivers/ssb/main.c
> +++ b/drivers/ssb/main.c
> @@ -494,8 +494,7 @@ static int ssb_devices_register(struct ssb_bus *bus)
>  #endif
>  			break;
>  		case SSB_BUSTYPE_SDIO:
> -#ifdef CONFIG_SSB_SDIO
> -			sdev->irq = bus->host_sdio->dev.irq;
> +#ifdef CONFIG_SSB_SDIOHOST
>  			dev->parent = &bus->host_sdio->dev;
>  #endif
>  			break;

The commit message says "fix a typo" but it's also removing
the assignment of sdev->irq

All the bus types assign the sdev->irq, so it looks like
this was removed unintentionally.

If it was intentional, it needs to be explained in the
commit message or a code comment.
