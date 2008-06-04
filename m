Return-Path: <linux-kernel-owner+w=401wt.eu-S1760250AbYFDPcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbYFDPcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 11:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755674AbYFDPcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 11:32:07 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36680 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983AbYFDPcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 11:32:06 -0400
Date: Wed, 4 Jun 2008 18:31:32 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
Subject: Re: [PATCH] spi: two bug-fixes
Message-ID: <20080604153132.GB4189@cs181133002.pp.htv.fi>
References: <Pine.LNX.4.64.0806041705430.32657@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806041705430.32657@axis700.grange>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 05:11:14PM +0200, Guennadi Liakhovetski wrote:
> Two SPI-related fixes: unsigned int cannot be less than zero, and the list
> search success check is wrong: for example, it didn't recognise failure for me
> when I requested port 0.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
> 
> ---
> 
> It might be a good idea to get it in for 2.6.26. As a side note I was 
> surprised, that the compiler didn't generate a warning for "if (t<0)" for 
> unsigned t, whereas it does generate one for unsigned char with the same 
> flags (-Wall). I asked on gcc, there was one reply from Segher 
> Boessenkool, it is unclear if this is going to be recognised as a bug or 
> not: http://gcc.gnu.org/ml/gcc/2008-06/threads.html#00044
> 
>  arch/arm/mach-pxa/ssp.c |    2 +-
>  drivers/gpio/mcp23s08.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/gpio/mcp23s08.c
> ===================================================================
> --- linux-2.6.orig/drivers/gpio/mcp23s08.c	2008-06-04 12:11:26.000000000 +0200
> +++ linux-2.6/drivers/gpio/mcp23s08.c	2008-06-04 12:11:50.000000000 +0200
> @@ -178,7 +178,7 @@
>  
>  	mutex_lock(&mcp->lock);
>  	t = mcp23s08_read_regs(mcp, 0, mcp->cache, sizeof mcp->cache);
> -	if (t < 0) {
> +	if ((int)t < 0) {
>  		seq_printf(s, " I/O ERROR %d\n", t);
>  		goto done;
>  	}
>...

The better fix of making "t" signed by Roel Kluin is already as
commit 1d1c1d9b557a12320174058d2d313ffb0f8611f4 in Linus' tree.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

