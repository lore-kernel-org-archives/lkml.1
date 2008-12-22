Return-Path: <linux-kernel-owner+w=401wt.eu-S1756382AbYLVWO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbYLVWO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbYLVWOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 17:14:10 -0500
Received: from khc.piap.pl ([195.187.100.11]:40817 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbYLVWOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 17:14:07 -0500
To: Hannes Eder <hannes@hanneseder.net>
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/27] drivers/net: fix sparse warnings: make do-while a compound statement
References: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
	<20081222191507.11807.50794.stgit@vmbox.hanneseder.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 22 Dec 2008 23:14:05 +0100
In-Reply-To: <20081222191507.11807.50794.stgit@vmbox.hanneseder.net> (Hannes Eder's message of "Mon\, 22 Dec 2008 20\:15\:07 +0100")
Message-ID: <m3hc4voo2a.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Eder <hannes@hanneseder.net> writes:

> Fix this sparse warnings:

Or: break the formating to silence sparse.

>   drivers/net/atp.c:811:8: warning: do-while statement is not a compound statement
>   drivers/net/atp.c:813:8: warning: do-while statement is not a compound statement
>   drivers/net/atp.c:815:11: warning: do-while statement is not a compound statement
>   drivers/net/atp.c:817:11: warning: do-while statement is not a compound statement

> --- a/drivers/net/starfire.c
> +++ b/drivers/net/starfire.c
> @@ -882,9 +882,9 @@ static int mdio_read(struct net_device *dev, int phy_id, int location)
>  	void __iomem *mdio_addr = np->base + MIICtrl + (phy_id<<7) + (location<<2);
>  	int result, boguscnt=1000;
>  	/* ??? Should we add a busy-wait here? */
> -	do
> +	do {
>  		result = readl(mdio_addr);
> -	while ((result & 0xC0000000) != 0x80000000 && --boguscnt > 0);
> +	} while ((result & 0xC0000000) != 0x80000000 && --boguscnt > 0);
>  	if (boguscnt == 0)
>  		return 0;
>  	if ((result & 0xffff) == 0xffff)


I don't know how one could think the above is an improvement.

This "do-while statement is not a compound statement" warning is
pure nonsense.
-- 
Krzysztof Halasa
