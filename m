Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbZEFIWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbZEFIWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 04:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbZEFIWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 04:22:10 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:11342 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZEFIWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 04:22:09 -0400
Date: Wed, 6 May 2009 10:22:02 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Michael Abbott <michael@araneidae.co.uk>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.29.2] PXA I2C: Define log level for i2c PXA error
 report
Message-ID: <20090506102202.73d6045d@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.64.0905060829580.24668@venus.araneidae.co.uk>
References: <Pine.LNX.4.64.0905060829580.24668@venus.araneidae.co.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009 08:32:09 +0100 (BST), Michael Abbott wrote:
> All the i2c pxa error messages should probably be KERN_DEBUG
> 
> At least, all the printk messages should have a log level specfied,
> and KERN_DEBUG seems appropriate.
> 
> Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
> ---
>  drivers/i2c/busses/i2c-pxa.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
> index bdb1f75..8cb9160 100644
> --- a/drivers/i2c/busses/i2c-pxa.c
> +++ b/drivers/i2c/busses/i2c-pxa.c
> @@ -210,11 +210,11 @@ static irqreturn_t i2c_pxa_handler(int this_irq, void *dev_id);
>  static void i2c_pxa_scream_blue_murder(struct pxa_i2c *i2c, const char *why)
>  {
>  	unsigned int i;
> -	printk("i2c: error: %s\n", why);
> -	printk("i2c: msg_num: %d msg_idx: %d msg_ptr: %d\n",
> +	printk(KERN_DEBUG "i2c: error: %s\n", why);
> +	printk(KERN_DEBUG "i2c: msg_num: %d msg_idx: %d msg_ptr: %d\n",
>  		i2c->msg_num, i2c->msg_idx, i2c->msg_ptr);
> -	printk("i2c: ICR: %08x ISR: %08x\n"
> -	       "i2c: log: ", readl(_ICR(i2c)), readl(_ISR(i2c)));
> +	printk(KERN_DEBUG "i2c: ICR: %08x ISR: %08x\n"
> +	       KERN_DEBUG "i2c: log: ", readl(_ICR(i2c)), readl(_ISR(i2c)));
>  	for (i = 0; i < i2c->irqlogidx; i++)
>  		printk("[%08x:%08x] ", i2c->isrlog[i], i2c->icrlog[i]);
>  	printk("\n");

Already fixed in Linus' tree:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=154d22b04ae1741c5fcfd5d747b813a9a279abff#patch4

-- 
Jean Delvare
