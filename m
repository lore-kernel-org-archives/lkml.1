Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbZBRCsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbZBRCsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 21:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbZBRCs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 21:48:28 -0500
Received: from lixom.net ([66.141.50.11]:44818 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbZBRCs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 21:48:28 -0500
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Feb 2009 21:48:27 EST
Date: Tue, 17 Feb 2009 20:43:12 -0600
From: Olof Johansson <olof@lixom.net>
To: dayu@datangmobile.cn
Cc: leoli@freescale.com, galak@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix the interrupt loss problem on powerpc IPIC
	(2.6.25-2.6.28)
Message-ID: <20090218024312.GA14848@lixom.net>
References: <D728AD1FA2543948B89DE29C5BF4CD0716AC37FD@bjmail1.bj.datangmobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D728AD1FA2543948B89DE29C5BF4CD0716AC37FD@bjmail1.bj.datangmobile.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 10:16:07AM +0800, dayu@datangmobile.cn wrote:
> From: Da Yu <dayu@datangmobile.cn>
> Date: Wed, 18 Feb 2009 19:58:20 +0800
> Subject: [PATCH] fix the interrupt loss problem on powerpc IPIC (2.6.25-2.6.28)
> 
> Signed-off-by: Da Yu <dayu@datangmobile.cn>

Still no proper explanation in the patch.

Also, with this change, is 'temp' really needed, or can you just pass in the
mask by hand?


-Olof

> ---
> 
> --- a/arch/powerpc/sysdev/ipic.c	2009-02-18 09:47:04.000000000 +0800
> +++ b/arch/powerpc/sysdev/ipic.c	2009-02-18 09:46:34.000000000 +0800
> @@ -568,8 +568,7 @@ static void ipic_ack_irq(unsigned int vi
> 
>  	spin_lock_irqsave(&ipic_lock, flags);
> 
> -	temp = ipic_read(ipic->regs, ipic_info[src].ack);
> -	temp |= (1 << (31 - ipic_info[src].bit));
> +	temp = 1 << (31 - ipic_info[src].bit);
>  	ipic_write(ipic->regs, ipic_info[src].ack, temp);
> 
>  	/* mb() can't guarantee that ack is finished.  But it does finish

