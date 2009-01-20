Return-Path: <linux-kernel-owner+w=401wt.eu-S1761412AbZATV44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761412AbZATV44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 16:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbZATV4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 16:56:45 -0500
Received: from katalix.com ([82.103.140.233]:59338 "EHLO mail.katalix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460AbZATV4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 16:56:44 -0500
Message-ID: <49764890.5010403@katalix.com>
Date: Tue, 20 Jan 2009 21:56:32 +0000
From: James Chapman <jchapman@katalix.com>
Organization: Katalix Systems Ltd
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       devel@openvz.org, xemul@openvz.org,
       Michal Ostrowski <mostrows@earthlink.net>,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 5/5] net: pppoe,pppol2tp - register channels with explicit
 net
References: <20090120140510.228815074@gmail.com>> <4975dc14.0637560a.7f8e.729c@mx.google.com>
In-Reply-To: <4975dc14.0637560a.7f8e.729c@mx.google.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> In PPPo[E|L2TP] we could explicitly point which net namespace
> we're going to use for channels - make it so.
> 
> CC: James Chapman <jchapman@katalix.com>
> CC: Michal Ostrowski <mostrows@earthlink.net>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

This one's ok by me too for pppol2tp.

Signed-off-by: James Chapman <jchapman@katalix.com>

> ---
>  drivers/net/pppoe.c    |    2 +-
>  drivers/net/pppol2tp.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.git/drivers/net/pppoe.c
> ===================================================================
> --- linux-2.6.git.orig/drivers/net/pppoe.c
> +++ linux-2.6.git/drivers/net/pppoe.c
> @@ -695,7 +695,7 @@ static int pppoe_connect(struct socket *
>  		po->chan.private = sk;
>  		po->chan.ops = &pppoe_chan_ops;
>  
> -		error = ppp_register_channel(&po->chan);
> +		error = ppp_register_net_channel(dev_net(dev), &po->chan);
>  		if (error)
>  			goto err_put;
>  
> Index: linux-2.6.git/drivers/net/pppol2tp.c
> ===================================================================
> --- linux-2.6.git.orig/drivers/net/pppol2tp.c
> +++ linux-2.6.git/drivers/net/pppol2tp.c
> @@ -1749,7 +1749,7 @@ static int pppol2tp_connect(struct socke
>  	po->chan.ops	 = &pppol2tp_chan_ops;
>  	po->chan.mtu	 = session->mtu;
>  
> -	error = ppp_register_channel(&po->chan);
> +	error = ppp_register_net_channel(sock_net(sk), &po->chan);
>  	if (error)
>  		goto end_put_tun;
>  
> 


-- 
James Chapman
Katalix Systems Ltd
http://www.katalix.com
Catalysts for your Embedded Linux software development

