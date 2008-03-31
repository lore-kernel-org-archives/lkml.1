Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbYCaIwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbYCaIwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 04:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbYCaIwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 04:52:25 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:3319 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbYCaIwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 04:52:24 -0400
Date: Mon, 31 Mar 2008 10:51:54 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] i2c/busses/scx200_acb.c: don't use 0 as NULL
 pointer
Message-ID: <20080331105154.0a38ebf7@hyperion.delvare>
In-Reply-To: <20080330232228.GR28445@cs181133002.pp.htv.fi>
References: <20080330232228.GR28445@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2008 02:22:28 +0300, Adrian Bunk wrote:
> Don't use 0 as NULL pointer.
> 
> Spotted by sparse.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 4a2495930cc9bc83f4302de3b73ebf3e8849dc1a diff --git a/drivers/i2c/busses/scx200_acb.c b/drivers/i2c/busses/scx200_acb.c
> index f5e7a70..61abe0f 100644
> --- a/drivers/i2c/busses/scx200_acb.c
> +++ b/drivers/i2c/busses/scx200_acb.c
> @@ -527,7 +527,7 @@ static int __init scx200_create_isa(const char *text, unsigned long base,
>  	if (iface == NULL)
>  		return -ENOMEM;
>  
> -	if (request_region(base, 8, iface->adapter.name) == 0) {
> +	if (!request_region(base, 8, iface->adapter.name)) {
>  		printk(KERN_ERR NAME ": can't allocate io 0x%lx-0x%lx\n",
>  		       base, base + 8 - 1);
>  		rc = -EBUSY;
> 

Applied, thanks.

-- 
Jean Delvare
