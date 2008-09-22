Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbYIVBMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbYIVBMz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 21:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbYIVBMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 21:12:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:42410 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbYIVBMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 21:12:45 -0400
Subject: Re: [PATCH] arch/powerpc/platforms/powermac/pic.c: move of_node_put
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Julia Lawall <julia@diku.dk>
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0809211301030.7450@ask.diku.dk>
References: <Pine.LNX.4.64.0809211301030.7450@ask.diku.dk>
Content-Type: text/plain
Date: Sun, 21 Sep 2008 18:12:28 -0700
Message-Id: <1222045948.12085.9.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-09-21 at 13:01 +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> It seems better to dereference master before decrementing the reference
> count rather than afterwards.
> 
> The problem was found using the following semantic match:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @r exists@
> expression n,E;
> identifier fld;
> iterator I;
> statement S;
> @@
> 
> * of_node_put(n)
> ... when != n = E
>     when != I(n,...) S
> * n->fld
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Ack.

No big deal, tho, those nodes are never going to go away :-)

Cheers,
Ben.

> ---
> 
>  arch/powerpc/platforms/powermac/pic.c          |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
> index 6d149ae..d17aa2b 100644
> --- a/arch/powerpc/platforms/powermac/pic.c
> +++ b/arch/powerpc/platforms/powermac/pic.c
> @@ -395,10 +395,10 @@ static void __init pmac_pic_probe_oldstyle(void)
>  	if (max_real_irqs > 32)
>  		pmac_irq_hw[i++] = (volatile struct pmac_irq_hw __iomem *)
>  			(addr + 0x10);
> -	of_node_put(master);
>  
>  	printk(KERN_INFO "irq: Found primary Apple PIC %s for %d irqs\n",
>  	       master->full_name, max_real_irqs);
> +	of_node_put(master);
>  
>  	/* Map interrupts of cascaded controller */
>  	if (slave && !of_address_to_resource(slave, 0, &r)) {

