Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbYJWUps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbYJWUps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 16:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYJWUpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 16:45:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39622
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752375AbYJWUpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 16:45:36 -0400
Date: Thu, 23 Oct 2008 13:45:13 -0700 (PDT)
Message-Id: <20081023.134513.267548182.davem@davemloft.net>
To: michellammertink@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netlink: fix append of whole original message on
 negative ack.
From: David Miller <davem@davemloft.net>
In-Reply-To: <4900BFCF.2030707@gmail.com>
References: <4900BFCF.2030707@gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: M Lammertink <michellammertink@gmail.com>
Date: Thu, 23 Oct 2008 20:17:51 +0200

You'll get a much better review of this if you send it to
the netdev mailing list, which is where all the networking
developers are subscribed.  They don't read linux-kernel

Added to CC:

> From: Michel Lammertink <mlammertink <at> ti-wmc.nl>
> Signed-off-by: Michel Lammertink <mlammertink <at> ti-wmc.nl>
> 
> Netlink can return an negative acknowledgement, which AFAICT should include an error code and the whole original message. This patch fixes the size argument given to the __nlmsg_put call. Without this patch only the original header was attached.
> ---
> 
> Can anyone explain to me why struct nlmsgerr contains an int error and the nlmsghdr struct. The comment in netlink_ack states that the whole message should be appended. Why not only include an int error in struct nlmsgerr and just append the original message?
> 
> Comments appreciated.
> 
> diff -uprN linux-2.6.27.3.orig/net/netlink/af_netlink.c linux-2.6.27.3/net/netlink/af_netlink.c
> --- linux-2.6.27.3.orig/net/netlink/af_netlink.c	2008-10-23 18:01:54.000000000 +0200
> +++ linux-2.6.27.3/net/netlink/af_netlink.c	2008-10-23 18:04:22.000000000 +0200
> @@ -1656,7 +1656,7 @@ void netlink_ack(struct sk_buff *in_skb,
>  	}
>  
>  	rep = __nlmsg_put(skb, NETLINK_CB(in_skb).pid, nlh->nlmsg_seq,
> -			  NLMSG_ERROR, sizeof(struct nlmsgerr), 0);
> +			  NLMSG_ERROR, payload, 0);
>  	errmsg = nlmsg_data(rep);
>  	errmsg->error = err;
>  	memcpy(&errmsg->msg, nlh, err ? nlh->nlmsg_len : sizeof(*nlh));
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
