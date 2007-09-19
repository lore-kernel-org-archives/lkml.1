Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbXISDB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbXISDB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 23:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbXISDBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 23:01:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:59801 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbXISDBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 23:01:18 -0400
Subject: Re: [PATCH] atyfb: force 29MHz xtal on G3 PowerBooks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070825091358.GA12235@aepfle.de>
References: <20070825091358.GA12235@aepfle.de>
Content-Type: text/plain
Date: Wed, 19 Sep 2007 13:01:06 +1000
Message-Id: <1190170866.6403.133.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-25 at 11:13 +0200, Olaf Hering wrote:
> The atyfb does not work on my 233MHz PowerBook with Mach64 LP, when the
> kernel is booted from firmware. aty_ld_pll_ct() returns 0x22 and xtal
> remains at 14.31818. When booted from MacOS, aty_ld_pll_ct() returns 0x3c
> and xtal is changed to 29.498928.
> Google indicates that all 4 PowerBook models need the higher value.

Seems to break it on my wallstreet first gen (M64 LG)

So NAK for now until we find out a better way.

Ben.

> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> 
> --- a/drivers/video/aty/atyfb_base.c
> +++ b/drivers/video/aty/atyfb_base.c
> @@ -2411,7 +2411,7 @@ static int __devinit aty_init(struct fb_
>  				diff1 = -diff1;
>  			if (diff2 < 0)
>  				diff2 = -diff2;
> -			if (diff2 < diff1) {
> +			if (diff2 < diff1 || (M64_HAS(G3_PB_1024x768))) {
>  				par->ref_clk_per = 1000000000000ULL / 29498928;
>  				xtal = "29.498928";
>  			}
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev

