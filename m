Return-Path: <linux-kernel-owner+w=401wt.eu-S1757732AbXJKVqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbXJKVqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbXJKVq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:46:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58130
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754789AbXJKVqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:46:25 -0400
Date: Thu, 11 Oct 2007 14:46:13 -0700 (PDT)
Message-Id: <20071011.144613.48517852.davem@davemloft.net>
To: shemminger@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, heiko.carstens@de.ibm.com,
       schwidefsky@de.ibm.com
Subject: Re: [PATCH net-2.6.24] remove bogus qeth type check
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071011132458.3b536662@freepuppy.rosehill>
References: <200710110909.l9B99fEM021646@imap1.linux-foundation.org>
	<20071011.024529.112295019.davem@davemloft.net>
	<20071011132458.3b536662@freepuppy.rosehill>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Thu, 11 Oct 2007 13:24:58 -0700

[ SOrry, I just noticed this was different... ]

> Not sure why this crept in with hard-header-ops change.
> Just kill it. Need to start doing cross-compiles for s390...
> 
> Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
> 
> --- a/drivers/s390/net/qeth_main.c	2007-10-10 08:26:48.000000000 -0700
> +++ b/drivers/s390/net/qeth_main.c	2007-10-11 13:21:17.000000000 -0700
> @@ -6581,9 +6581,6 @@ qeth_hard_header_parse(const struct sk_b
>  	const struct qeth_card *card;
>  	const struct ethhdr *eth;
>  
> -	if (dev->type != ARPHRD_IEEE802_TR)
> -		return 0;
> -
>  	card = qeth_get_card_from_dev(skb->dev);
>  	if (card->options.layer2)
>  		goto haveheader;

I think you copied the check from another part of the driver.
Perhaps you should double check before we kill this outright.
