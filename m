Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbZKCBgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbZKCBgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 20:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757848AbZKCBgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 20:36:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58862 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757841AbZKCBgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 20:36:16 -0500
Message-ID: <4AF0DABA.3070103@cn.fujitsu.com>
Date: Wed, 04 Nov 2009 09:36:58 +0800
From: Yang Hongyang <yanghy@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Thiago Farina <tfransosi@gmail.com>
CC: trivial@kernel.com, baum@tehutinetworks.net, andy@greyhouse.net,
       davem@davemloft.net, shemminger@vyatta.com, apkm@linux-fundation.org,
       ben@decadent.org.uk, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: remove duplicated MIN macro from tehuti.
References: <y> <1257194714-5218-1-git-send-email-tfransosi@gmail.com>
In-Reply-To: <1257194714-5218-1-git-send-email-tfransosi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thiago Farina wrote:
> Since the kernel api already has the macro "min",
> just use it instead of declaring another one.
> 
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> ---
>  drivers/net/tehuti.c |    4 ++--
>  drivers/net/tehuti.h |    2 --
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/tehuti.c b/drivers/net/tehuti.c
> index ec9dfb2..8d116a9 100644
> --- a/drivers/net/tehuti.c
> +++ b/drivers/net/tehuti.c
> @@ -1878,7 +1878,7 @@ static void bdx_tx_push_desc_safe(struct bdx_priv *priv, void *data, int size)
>  			udelay(50);	/* give hw a chance to clean fifo */
>  			continue;
>  		}
> -		avail = MIN(avail, size);
> +		avail = min(avail, size);
>  		DBG("about to push  %d bytes starting %p size %d\n", avail,
>  		    data, size);
>  		bdx_tx_push_desc(priv, data, avail);
> @@ -1889,7 +1889,7 @@ static void bdx_tx_push_desc_safe(struct bdx_priv *priv, void *data, int size)
>  }
>  
>  static const struct net_device_ops bdx_netdev_ops = {
> -	.ndo_open	 	= bdx_open,
> +	.ndo_open	        = bdx_open,

  Why are you change TAB to SPACES here?

>  	.ndo_stop		= bdx_close,
>  	.ndo_start_xmit		= bdx_tx_transmit,
>  	.ndo_validate_addr	= eth_validate_addr,
> diff --git a/drivers/net/tehuti.h b/drivers/net/tehuti.h
> index 4fc875e..1241419 100644
> --- a/drivers/net/tehuti.h
> +++ b/drivers/net/tehuti.h
> @@ -76,8 +76,6 @@
>  #define FIFO_SIZE  4096
>  #define FIFO_EXTRA_SPACE            1024
>  
> -#define MIN(x, y)  ((x) < (y) ? (x) : (y))
> -
>  #if BITS_PER_LONG == 64
>  #    define H32_64(x)  (u32) ((u64)(x) >> 32)
>  #    define L32_64(x)  (u32) ((u64)(x) & 0xffffffff)


-- 
Regards
Yang Hongyang
