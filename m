Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbYK2GNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbYK2GNd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 01:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbYK2GNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 01:13:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34677
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750701AbYK2GNW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 01:13:22 -0500
Date: Fri, 28 Nov 2008 22:13:22 -0800 (PST)
Message-Id: <20081128.221322.67645422.davem@davemloft.net>
To: frederic.moulins@alsatis.com
Cc: jchapman@katalix.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] [PPPOL2TP] Add missing sock_put() in pppol2tp_release()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081127171851.3fe7db5a@iter>
References: <20081127171851.3fe7db5a@iter>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frédéric Moulins <frederic.moulins@alsatis.com>
Date: Thu, 27 Nov 2008 17:18:51 +0100

> pppol2tp_sock_to_session() do sock_hold() if the session to release is
> not NULL.
> 
> Signed-off-by: Frédéric Moulins <frederic.moulins@alsatis.com>

Applied, but please post networking patches at least CC:'d to
netdev@vger.kernel.org so that your work gets properly tracked
at:

	http://patchwork.ozlabs.org/project/netdev/list

Thanks.

> ---
> Patch is applicable to kernels 2.6.26 and following.
> 
> Tested with a 2.6.26 stable kernel:
> without this patch, a session in a persistent tunnel cannot be
> established again (connect failed: -17), and the pppol2tp kernel module
> cannot be removed because still considered in use after stopping all
> userspace daemons.
> 
> diff --git a/drivers/net/pppol2tp.c b/drivers/net/pppol2tp.c
> index ff175e8..de80ba4 100644
> --- a/drivers/net/pppol2tp.c
> +++ b/drivers/net/pppol2tp.c
> @@ -1353,6 +1353,7 @@ static int pppol2tp_release(struct socket *sock)
>  			kfree_skb(skb);
>  			sock_put(sk);
>  		}
> +		sock_put(sk);
>  	}
>  
>  	release_sock(sk);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
