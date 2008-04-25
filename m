Return-Path: <linux-kernel-owner+w=401wt.eu-S1761965AbYDYLZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761965AbYDYLZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 07:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbYDYLZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 07:25:11 -0400
Received: from mail.transmode.se ([83.241.175.147]:4937 "EHLO
	tmnt04.transmode.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753962AbYDYLZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 07:25:09 -0400
Subject: RE: [PATCH 1/2] spi_mpc83xx: test below 0 on unsigned irq
	in	mpc83xx_spi_probe()
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Reply-To: joakim.tjernlund@transmode.se
To: "'Roel Kluin'" <12o3l@tiscali.nl>
Cc: galak@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net,
       "'lkml'" <linux-kernel@vger.kernel.org>
In-Reply-To: <00ed01c8a58c$b4a5fa40$1df1eec0$@Tjernlund@transmode.se>
References: <480FA234.1000601@tiscali.nl>
	 <00ed01c8a58c$b4a5fa40$1df1eec0$@Tjernlund@transmode.se>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Transmode AB
Date: Fri, 25 Apr 2008 13:25:06 +0200
Message-Id: <1209122706.31117.8.camel@gentoo-jocke.transmode.se>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-23 at 23:55 +0200, Joakim Tjernlund wrote:
> > -----Original Message-----
> > From: linuxppc-dev-bounces+joakim.tjernlund=transmode.se@ozlabs.org [mailto:linuxppc-dev-
> > bounces+joakim.tjernlund=transmode.se@ozlabs.org] On Behalf Of Roel Kluin
> > Sent: den 23 april 2008 22:55
> > To: galak@kernel.crashing.org; linuxppc-dev@ozlabs.org
> > Cc: spi-devel-general@lists.sourceforge.net; dbrownell@users.sourceforge.net; lkml
> > Subject: [PATCH 1/2] spi_mpc83xx: test below 0 on unsigned irq in mpc83xx_spi_probe()
> > 
> > mpc83xx_spi->irq is unsigned, so the test fails
> > 
> > Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> 
> hmm, I got a pretty large 83xx spi patch queued at dbrownell. I hope
> that one can be applied first. Then you probably need to rediff this patch.
> 
> David, any progress on my patch?

David, heard nothing from you in a while. Don't you get my mails?

   Jocke 

> 
>  Jocke
> > ---
> > diff --git a/drivers/spi/spi_mpc83xx.c b/drivers/spi/spi_mpc83xx.c
> > index be15a62..033fd51 100644
> > --- a/drivers/spi/spi_mpc83xx.c
> > +++ b/drivers/spi/spi_mpc83xx.c
> > @@ -454,12 +454,12 @@ static int __init mpc83xx_spi_probe(struct platform_device *dev)
> >  		goto put_master;
> >  	}
> > 
> > -	mpc83xx_spi->irq = platform_get_irq(dev, 0);
> > -
> > -	if (mpc83xx_spi->irq < 0) {
> > -		ret = -ENXIO;
> > +	ret = platform_get_irq(dev, 0);
> > +	if (ret < 0)
> >  		goto unmap_io;
> > -	}
> > +
> > +	mpc83xx_spi->irq = ret;
> > +	ret = 0;
> > 
> >  	/* Register for SPI Interrupt */
> >  	ret = request_irq(mpc83xx_spi->irq, mpc83xx_spi_irq,
> > 
> > _______________________________________________
> > Linuxppc-dev mailing list
> > Linuxppc-dev@ozlabs.org
> > https://ozlabs.org/mailman/listinfo/linuxppc-dev
> > 
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
> 
> 
