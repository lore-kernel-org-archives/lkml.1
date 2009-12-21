Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbZLUQ4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbZLUQ4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755606AbZLUQ4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:56:44 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:32026 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbZLUQ4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:56:43 -0500
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXJ75k/CpbGRgUpU
X-RZG-CLASS-ID: mo00
Message-ID: <4B2FA8C7.3010509@hartkopp.net>
Date: Mon, 21 Dec 2009 17:56:39 +0100
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Alexander Strakh <strakh@ispras.ru>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Donald Becker <becker@scyld.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 3c507.c: remove unused NULL pointer check
References: <200912211923.58735.strakh@ispras.ru>
In-Reply-To: <200912211923.58735.strakh@ispras.ru>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Strakh wrote:
> 	In driver drivers/net/3c507.c in function Iirqreturn_t el16_interrupt:
> 1. If in line 555 dev = NULL then we goto line 556
> 2. In line 556 we have null dereference because pr_err called with dev->name 
> in third parameter.
>  555        if (dev == NULL) {
>  556                pr_err("%s: net_interrupt(): irq %d for unknown device.
> \n",
>  557                        dev->name, irq);
>  558                return IRQ_NONE;
>  559        }
> 
> Found by Linux Device Drivers Verification (Svace detector)
> 
> Remove unused NULL pointer check.

You are obviously doing more than that ...

> 
> Signed-off-by: Alexander Strakh <strakh@ispras.ru>
> 
> ---
> diff --git a/./0000/drivers/net/3c507.c b/./moder/drivers/net/3c507.c
> index fbc2311..3bfb3dd 100644
> --- a/./0000/drivers/net/3c507.c
> +++ b/./moder/drivers/net/3c507.c
> @@ -552,12 +552,6 @@ static irqreturn_t el16_interrupt(int irq, void *dev_id)
>  	ushort ack_cmd = 0;
>  	void __iomem *shmem;
>  
> -	if (dev == NULL) {
> -		pr_err("%s: net_interrupt(): irq %d for unknown device.\n",
> -			dev->name, irq);

You are changing real funcionality here!

If you want to fix it, fix the pr_err() but do not remove the "return
IRQ_NONE" entirely.

This looks like an introduction of a bug.

Regards,
Oliver


> -		return IRQ_NONE;
> -	}
> -

