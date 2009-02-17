Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbZBQONE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbZBQONE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 09:13:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbZBQOMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 09:12:53 -0500
Received: from gate.crashing.org ([63.228.1.57]:44086 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbZBQOMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 09:12:52 -0500
Cc: <LeoLi@freescale.com>, <linux-kernel@vger.kernel.org>,
       <linuxppc-dev@ozlabs.org>
Message-Id: <76C7F485-EF75-4B83-B673-564E6243C7C6@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: "<dayu@datangmobile.cn>" <dayu@datangmobile.cn>
In-Reply-To: <D728AD1FA2543948B89DE29C5BF4CD0716AC2DDE@bjmail1.bj.datangmobile.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] fix the interrupt loss problem on powerpc IPIC (2.6.23)
Date: Tue, 17 Feb 2009 08:12:33 -0600
References: <D728AD1FA2543948B89DE29C5BF4CD0716AC2DDE@bjmail1.bj.datangmobile.com>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 17, 2009, at 6:44 AM, <dayu@datangmobile.cn> <dayu@datangmobile.cn 
 > wrote:

> From: Da Yu <dayu@datangmobile.cn>
> Date: Tue, 17 Feb 2009 19:58:20 +0800
> Subject: [PATCH] fix the interrupt loss problem on powerpc IPIC  
> (2.6.23)
>
> Signed-off-by: Da Yu <dayu@datangmobile.cn>
> ---

Please provide a bit more description as to why this fixes the issue.

- k

>
>
> --- a/arch/powerpc/sysdev/ipic.c	2009-02-17 15:10:18.000000000 +0800
> +++ b/arch/powerpc/sysdev/ipic.c	2009-02-17 20:05:28.000000000 +0800
> @@ -561,8 +561,7 @@ static void ipic_ack_irq(unsigned int vi
>
> 	spin_lock_irqsave(&ipic_lock, flags);
>
> -	temp = ipic_read(ipic->regs, ipic_info[src].pend);
> -	temp |= (1 << (31 - ipic_info[src].bit));
> +	temp = 1 << (31 - ipic_info[src].bit);
> 	ipic_write(ipic->regs, ipic_info[src].pend, temp);
>
> 	spin_unlock_irqrestore(&ipic_lock, flags);
> @@ -581,8 +580,7 @@ static void ipic_mask_irq_and_ack(unsign
> 	temp &= ~(1 << (31 - ipic_info[src].bit));
> 	ipic_write(ipic->regs, ipic_info[src].mask, temp);
>
> -	temp = ipic_read(ipic->regs, ipic_info[src].pend);
> -	temp |= (1 << (31 - ipic_info[src].bit));
> +	temp = 1 << (31 - ipic_info[src].bit);
> 	ipic_write(ipic->regs, ipic_info[src].pend, temp);
>
> 	spin_unlock_irqrestore(&ipic_lock, flags);

