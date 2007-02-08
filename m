Return-Path: <linux-kernel-owner+w=401wt.eu-S1423310AbXBHUTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423310AbXBHUTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 15:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423306AbXBHUTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 15:19:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:18778 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423310AbXBHUTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 15:19:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=clAPiz583tAn+coJAIBIAd5FGIZKW6xhbVg7FyCqwCyMnSjoOE8bC3x16gHHRiTxHzv2lING1Yriu6OvR8NbKtEbYhz0p6h4CLJmOxMOC83U0KVGNAb49emErTpU44xnl/AtEC7e/hA+tfOAfuGmxYYfySn8/1rMA+eIZbzk1nI=
Date: Thu, 8 Feb 2007 23:19:09 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: ahendry <ahendry@tusc.com.au>
Cc: linux-x25@vger.kernel.org, eis@baty.hanse.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] X.25: Adds /proc/sys/net/x25/x25_forward to control forwarding.
Message-ID: <20070208201909.GA5532@martell.zuzino.mipt.ru>
References: <1170890071.5189.40.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170890071.5189.40.camel@localhost>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 10:14:31AM +1100, ahendry wrote:
> echo "1" > /proc/sys/net/x25/x25_forward
> To turn on x25_forwarding, defaults to off

> --- linux-2.6.20-vanilla/include/linux/sysctl.h
> +++ linux-2.6.20/include/linux/sysctl.h
> @@ -699,7 +699,8 @@ enum {
>  	NET_X25_CALL_REQUEST_TIMEOUT=2,
>  	NET_X25_RESET_REQUEST_TIMEOUT=3,
>  	NET_X25_CLEAR_REQUEST_TIMEOUT=4,
> -	NET_X25_ACK_HOLD_BACK_TIMEOUT=5
> +	NET_X25_ACK_HOLD_BACK_TIMEOUT=5,
> +	NET_X25_FORWARD=6
>  };

> --- linux-2.6.20-vanilla/net/x25/sysctl_net_x25.c
> +++ linux-2.6.20/net/x25/sysctl_net_x25.c
> @@ -73,6 +73,14 @@ static struct ctl_table x25_table[] = {
>  		.extra1 =	&min_timer,
>  		.extra2 =	&max_timer,
>  	},
> +	{
> +		.ctl_name =	NET_X25_FORWARD,
> +		.procname =	"x25_forward",
> +		.data = 	&sysctl_x25_forward,
> +		.maxlen = 	sizeof(int),
> +		.mode = 	0644,
> +		.proc_handler = &proc_dointvec,
> +	},

Reserving binary sysctl number and not defining ->strategy is strange.
;-)

