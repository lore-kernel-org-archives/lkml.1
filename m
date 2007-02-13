Return-Path: <linux-kernel-owner+w=401wt.eu-S1750709AbXBMMzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750709AbXBMMzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 07:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbXBMMzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 07:55:52 -0500
Received: from stinky.trash.net ([213.144.137.162]:35353 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbXBMMzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 07:55:51 -0500
Message-ID: <45D1B555.6040302@trash.net>
Date: Tue, 13 Feb 2007 13:55:49 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
CC: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.20 12/14] nfnetlink_log: possible NULL pointer	dereference
 in nfulnl_recv_config()
References: <20070212003738.GA8262@rere.qmqm.pl>	<20070212202052.GA28704@rere.qmqm.pl> <20070212202224.GC28704@rere.qmqm.pl>
In-Reply-To: <20070212202224.GC28704@rere.qmqm.pl>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Micha³ Miros³aw wrote:
> Eliminate possible NULL pointer dereference in nfulnl_recv_config().
> 
> Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
> 
> --- linux-2.6.20/net/netfilter/nfnetlink_log.c.10	2007-02-12 17:05:14.000000000 +0100
> +++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-12 17:35:50.000000000 +0100
> @@ -853,6 +853,9 @@ nfulnl_recv_config(struct sock *ctnl, st
>  			ret = -EINVAL;
>  			break;
>  		}
> +
> +		if (!inst)
> +			goto out_null;

I think we should check that an instance is present before doing
any changes any return an error if the user tries to change the
configuration for a non-existant instance.
