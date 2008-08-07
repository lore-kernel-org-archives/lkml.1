Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbYHGGMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbYHGGMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 02:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbYHGGMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 02:12:20 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47935 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113AbYHGGMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 02:12:19 -0400
Message-ID: <489A923D.4080302@garzik.org>
Date: Thu, 07 Aug 2008 02:12:13 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Eduardo Habkost <ehabkost@redhat.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH][resend] xen-netfront: use netif_start_queue() on xennet_open()
References: <1217536615-2090-1-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1217536615-2090-1-git-send-email-ehabkost@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduardo Habkost wrote:
> xen-netfront never called netif_start_queue() and was was waking the
> queue on xennet_open(), triggering the BUG_ON() on __netif_schedule().
> 
> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> ---
>  drivers/net/xen-netfront.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
> index 902bbe7..c749bdb 100644
> --- a/drivers/net/xen-netfront.c
> +++ b/drivers/net/xen-netfront.c
> @@ -329,7 +329,7 @@ static int xennet_open(struct net_device *dev)
>  	}
>  	spin_unlock_bh(&np->rx_lock);
>  
> -	xennet_maybe_wake_tx(dev);
> +	netif_start_queue(dev);
>  

applied


