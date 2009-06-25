Return-Path: <linux-kernel-owner+w=401wt.eu-S1756493AbZFYITB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbZFYITB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 04:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbZFYISo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 04:18:44 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:61373 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbZFYISm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 04:18:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=R31gpfysA/zOfLzk5ktx480Jmq0SLw8DaXX9uPl61xU+KM9OOgwRAQHNEe65ftx4aL
         QsRKIbPqMVlWJSRrPpdo/Oo7Xg4He8XGEY0lojhfQV08qWx7zvBGuvVlWpdM+opR51UX
         SeJ1XrzBAb8PEIxo0hM7Eg++s/GpcB6CAfkmI=
From: Florian Fainelli <florian@openwrt.org>
To: Michael Opdenacker <michael@free-electrons.com>
Subject: Re: [PATCH 1/1] Minor code cleanup in drivers/net/r6040.c
Date: Thu, 25 Jun 2009 10:18:40 +0200
User-Agent: KMail/1.9.9
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1245913509-23245-1-git-send-email-michael@free-electrons.com>
In-Reply-To: <1245913509-23245-1-git-send-email-michael@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906251018.40995.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Thursday 25 June 2009 09:05:09 Michael Opdenacker, vous avez écrit :
>  Replaced '0' by 'bar' in the probe function.
>  The 'bar' variable was already set to '0' and is already
>  used in pci_iomap(). This is cleaner and improves code
>  consistency.
>
> Signed-off-by: Michael Opdenacker <michael@free-electrons.com>

Acked-by: Florian Fainelli <florian@openwrt.org>

> ---
>  drivers/net/r6040.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/r6040.c b/drivers/net/r6040.c
> index ed63d23..b3197e9 100644
> --- a/drivers/net/r6040.c
> +++ b/drivers/net/r6040.c
> @@ -1112,13 +1112,13 @@ static int __devinit r6040_init_one(struct pci_dev
> *pdev, }
>
>  	/* IO Size check */
> -	if (pci_resource_len(pdev, 0) < io_size) {
> +	if (pci_resource_len(pdev, bar) < io_size) {
>  		printk(KERN_ERR DRV_NAME ": Insufficient PCI resources, aborting\n");
>  		err = -EIO;
>  		goto err_out;
>  	}
>
> -	pioaddr = pci_resource_start(pdev, 0);	/* IO map base address */
> +	pioaddr = pci_resource_start(pdev, bar);	/* IO map base address */
>  	pci_set_master(pdev);
>
>  	dev = alloc_etherdev(sizeof(struct r6040_private));



-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
