Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab0BQXrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 18:47:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49521
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344Ab0BQXrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 18:47:18 -0500
Date: Wed, 17 Feb 2010 15:47:34 -0800 (PST)
Message-Id: <20100217.154734.177239957.davem@davemloft.net>
To: william.allen.simpson@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, andi@firstfloor.org
Subject: Re: [PATCH v5 3/7] tcp: harmonize tcp_vx_rcv header length
 assumptions
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B77953C.7070908@gmail.com>
References: <4B7791CF.9030201@gmail.com>
	<4B77953C.7070908@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: William Allen Simpson <william.allen.simpson@gmail.com>
Date: Sun, 14 Feb 2010 01:16:28 -0500

> @@ -1559,7 +1559,8 @@ int tcp_v4_do_rcv(struct sock *sk, struct sk_buff *skb)
>  		return 0;
>  	}
>  
> -	if (skb->len < tcp_hdrlen(skb) || tcp_checksum_complete(skb))
> +	/* Assumes header and options unchanged since checksum_init() */
> +	if (tcp_checksum_complete(skb))
>  		goto csum_err;
>  

Not true.

The skb->len can be modified by the call to sk_filter() done
by tcp_v4_rcv().
