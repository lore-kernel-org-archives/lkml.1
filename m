Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147Ab0BDUDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:03:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51677
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932929Ab0BDUDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:03:31 -0500
Date: Thu, 04 Feb 2010 12:03:45 -0800 (PST)
Message-Id: <20100204.120345.51673241.davem@davemloft.net>
To: hadi@cyberus.ca
Cc: s.L-H@gmx.de, gregkh@suse.de, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: patch net-restore-ip-source-validation.patch added to
 2.6.32-stable tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <1265313056.4651.18.camel@bigi>
References: <201002041931.40493.s.L-H@gmx.de>
	<1265308725.4651.14.camel@bigi>
	<1265313056.4651.18.camel@bigi>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: jamal <hadi@cyberus.ca>
Date: Thu, 04 Feb 2010 14:50:56 -0500

> Ok, I was able to reproduce it finally. This fixes it:
> 
> ---
> diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
> index b6e7aae..469193c 100644
> --- a/kernel/sysctl_check.c
> +++ b/kernel/sysctl_check.c
> @@ -220,6 +220,7 @@ static const struct trans_ctl_table
> trans_net_ipv4_conf_vars_table[] = {
>         { NET_IPV4_CONF_PROMOTE_SECONDARIES,    "promote_secondaries" },
>         { NET_IPV4_CONF_ARP_ACCEPT,             "arp_accept" },
>         { NET_IPV4_CONF_ARP_NOTIFY,             "arp_notify" },
> +       { NET_IPV4_CONF_SRC_VMARK,              "src_valid_mark" },
>         {}
>  };
> ---
> 
> Note we dont have that code anymore in current tree - thats why it
> was missed...
> If this works, Greg/Dave - please include it in the -stable patch.

I see, thanks for figuring this out Jamal.

Acked-by: David S. Miller <davem@davemloft.net>
