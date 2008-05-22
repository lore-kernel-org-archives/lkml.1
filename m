Return-Path: <linux-kernel-owner+w=401wt.eu-S937040AbYEVKX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937040AbYEVKX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 06:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936780AbYEVKWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 06:22:32 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59353 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934948AbYEVKW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 06:22:27 -0400
Message-ID: <4835495E.8020506@pobox.com>
Date: Thu, 22 May 2008 06:22:22 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Julia Lawall <julia@diku.dk>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] au1000_eth: remove useless check
References: <Pine.LNX.4.64.0805121537320.3694@ask.diku.dk> <20080512161734.GA22190@electric-eye.fr.zoreil.com> <Pine.LNX.4.64.0805121852510.16384@ask.diku.dk> <20080512164421.GB22190@electric-eye.fr.zoreil.com>
In-Reply-To: <20080512164421.GB22190@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu wrote:
> The lifespan of the device covers the request_irq .. free_irq interval.
> 
> The cast of a void * pointer is not needed either.
> 
> Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
> 
> diff --git a/drivers/net/au1000_eth.c b/drivers/net/au1000_eth.c
> index 3634b5f..7023d77 100644
> --- a/drivers/net/au1000_eth.c
> +++ b/drivers/net/au1000_eth.c
> @@ -1239,12 +1239,7 @@ static int au1000_rx(struct net_device *dev)
>   */
>  static irqreturn_t au1000_interrupt(int irq, void *dev_id)
>  {
> -	struct net_device *dev = (struct net_device *) dev_id;
> -
> -	if (dev == NULL) {
> -		printk(KERN_ERR "%s: isr: null dev ptr\n", dev->name);
> -		return IRQ_RETVAL(1);
> -	}
> +	struct net_device *dev = dev_id;
>  

applied


