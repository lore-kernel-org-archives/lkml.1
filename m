Return-Path: <linux-kernel-owner+w=401wt.eu-S1752646AbXIGXVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbXIGXVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 19:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbXIGXU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 19:20:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35061 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbXIGXU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 19:20:58 -0400
Message-ID: <46E1DCD8.9030004@pobox.com>
Date: Fri, 07 Sep 2007 19:20:56 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Micah Gruber <micah.gruber@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [CORRECTION][PATCH] Fix a potential NULL pointer dereference
 in uli526x_interrupt() in drivers/net/tulip/uli526x.c
References: <46DD13CE.6010905@gmail.com>
In-Reply-To: <46DD13CE.6010905@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Micah Gruber wrote:
> This patch fixes a potential null dereference bug where we dereference dev before a null check. This patch simply moves the dereferencing after the null check.
> 
> Signed-off-by: Micah Gruber <micah.gruber@gmail.com>
> ---
> 
> --- a/drivers/net/tulip/uli526x.c
> +++ b/drivers/net/tulip/uli526x.c
> @@ -663,7 +663,7 @@
>  {
>  	struct net_device *dev = dev_id;
>  	struct uli526x_board_info *db = netdev_priv(dev);
> -	unsigned long ioaddr = dev->base_addr;
> +	unsigned long ioaddr;
>  	unsigned long flags;
>  
>  	if (!dev) {
> @@ -671,6 +671,8 @@
>  		return IRQ_NONE;
>  	}
>  
> +	ioaddr = dev->base_addr;
> +

as satyam noted, just remove the !dev test


