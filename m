Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbXJCBHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbXJCBHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 21:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbXJCBHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 21:07:31 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52520 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbXJCBHa (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 21:07:30 -0400
Message-ID: <4702EB4A.4000208@pobox.com>
Date: Tue, 02 Oct 2007 21:07:22 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: pomac@vapor.com, Linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] sky2: jumbo frame regression fix
References: <1191372129.26233.12.camel@localhost> <20071002180209.47c350a3@freepuppy.rosehill>
In-Reply-To: <20071002180209.47c350a3@freepuppy.rosehill>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> Remove unneeded check that caused problems with jumbo frame sizes.
> The check was recently added and is wrong.
> When using jumbo frames the sky2 driver does fragmentation, so
> rx_data_size is less than mtu.
> 
> Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
> 
> --- a/drivers/net/sky2.c	2007-10-02 17:56:31.000000000 -0700
> +++ b/drivers/net/sky2.c	2007-10-02 17:58:56.000000000 -0700
> @@ -2163,9 +2163,6 @@ static struct sk_buff *sky2_receive(stru
>  	sky2->rx_next = (sky2->rx_next + 1) % sky2->rx_pending;
>  	prefetch(sky2->rx_ring + sky2->rx_next);
>  
> -	if (length < ETH_ZLEN || length > sky2->rx_data_size)
> -		goto len_error;
> -

2.6.23?  2.6.24?  enquiring minds want to know...


