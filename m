Return-Path: <linux-kernel-owner+w=401wt.eu-S965753AbXBTAjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965753AbXBTAjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:39:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965758AbXBTAjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:39:10 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:23091 "EHLO
	pd5mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965753AbXBTAjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:39:08 -0500
Date: Mon, 19 Feb 2007 18:39:03 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: forcedeth problems on 2.6.20-rc6-mm3
In-reply-to: <fa.6Uftu56OuKdbN+aI/fzLv4opZ/I@ifi.uio.no>
To: Ayaz Abdulla <aabdulla@nvidia.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Cc: David Ford <firefighterblu3@gmail.com>
Message-id: <45DA4327.3010106@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.EU4/Dq38S7AbpiJstT7NwokqTWE@ifi.uio.no>
 <fa.aMmqbeBS9CpIUWfPrgAtORtlXAQ@ifi.uio.no>
 <fa.d8YTRl6o0OIk8Vvk1QLpyc+bxQU@ifi.uio.no>
 <fa.XnyZ7qxKkAZ7Yhrg0DdiDmiy6wg@ifi.uio.no>
 <fa.s8qbnOGnlEinPfyyhT0PZsqiwwE@ifi.uio.no>
 <fa.6Uftu56OuKdbN+aI/fzLv4opZ/I@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ayaz Abdulla wrote:
> 
> For all those who are having issues, please try out the attached patch.
> 
> Ayaz
> 
> 
> ----------------------------------------------------------------------------------- 
> 
> This email message is for the sole use of the intended recipient(s) and 
> may contain
> confidential information.  Any unauthorized review, use, disclosure or 
> distribution
> is prohibited.  If you are not the intended recipient, please contact 
> the sender by
> reply email and destroy all copies of the original message.
> ----------------------------------------------------------------------------------- 
> 
> 
> 
> ------------------------------------------------------------------------
> 
> --- orig/drivers/net/forcedeth.c	2007-02-08 21:41:59.000000000 -0500
> +++ new/drivers/net/forcedeth.c	2007-02-08 21:44:53.000000000 -0500
> @@ -3104,13 +3104,17 @@
>  	struct fe_priv *np = netdev_priv(dev);
>  	u8 __iomem *base = get_hwbase(dev);
>  	unsigned long flags;
> +	u32 retcode;
>  
> -	if (np->desc_ver == DESC_VER_1 || np->desc_ver == DESC_VER_2)
> +	if (np->desc_ver == DESC_VER_1 || np->desc_ver == DESC_VER_2) {
>  		pkts = nv_rx_process(dev, limit);
> -	else
> +		retcode = nv_alloc_rx(dev);
> +	} else {
>  		pkts = nv_rx_process_optimized(dev, limit);
> +		retcode = nv_alloc_rx_optimized(dev);
> +	}
>  
> -	if (nv_alloc_rx(dev)) {
> +	if (retcode) {
>  		spin_lock_irqsave(&np->lock, flags);
>  		if (!np->in_shutdown)
>  			mod_timer(&np->oom_kick, jiffies + OOM_REFILL);

Did anyone push this patch into mainline? forcedeth on 2.6.20-git14 is 
still completely broken without this patch.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


