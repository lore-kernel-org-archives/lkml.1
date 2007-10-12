Return-Path: <linux-kernel-owner+w=401wt.eu-S1762546AbXJLRSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762546AbXJLRSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760805AbXJLRRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:17:51 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:21582 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760631AbXJLRRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:17:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=n+cdDTsbcCFzGRKmd0p7LWc8iJ92iQTPe8GCaY92Ylio8F13rQRY/3zRlu7RzwTlee5yrGyfrPRQK/e6tq+BIMCNN7VPeA+1/HyKJsBzTvX0hJ50D8pzcKSybyQLTmPCRTaSo5p3vERDOZUgoMCU23803tvzU1d/RmNk7AtyIto=  ;
X-YMail-OSG: JwkcWpYVM1mqeSqX_wQsyXO4Kes624g5vx6ehz6zkEU4FAIraLiuXmzxY_cYqwf1bNbFfEWUtj0q7CZq0SJ.hmJlfa7ZPdFaDwMhTkqBDV26UW24h0q4.QPOH7gK
From: David Brownell <david-b@pacbell.net>
To: bryan.wu@analog.com
Subject: Re: [PATCH 02/10] Blackfin SPI driver: use new GPIO API and add error handling
Date: Fri, 12 Oct 2007 10:17:47 -0700
User-Agent: KMail/1.9.6
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       Michael Hennerich <michael.hennerich@analog.com>
References: <1192158304-8277-1-git-send-email-bryan.wu@analog.com> <200710112326.34500.david-b@pacbell.net> <1192172077.6247.15.camel@roc-laptop>
In-Reply-To: <1192172077.6247.15.camel@roc-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710121017.47645.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 October 2007, Bryan Wu wrote:
> On Thu, 2007-10-11 at 23:26 -0700, David Brownell wrote:
> > On Thursday 11 October 2007, Bryan Wu wrote:
> > > @@ -1182,12 +1198,9 @@ static int __init bfin5xx_spi_probe(struct platform_device *pdev)
> > >                 return -ENOMEM;
> > >         }
> > >  
> > > -       if (peripheral_request(P_SPI0_SCK, DRV_NAME) ||
> > > -                peripheral_request(P_SPI0_MISO, DRV_NAME) ||
> > > -                peripheral_request(P_SPI0_MOSI, DRV_NAME) ) {
> > > -
> > > +       if (setup_pin_mux(1)) {
> > >                 dev_err(&pdev->dev, ": Requesting Peripherals failed\n");
> > > -               goto out_error_queue_alloc;
> > > +               goto out_error;
> > >         }
> > >  
> > >         drv_data = spi_master_get_devdata(master);
> > > 
> > 
> > Still doesn't apply ... what tree are you generating this series against??
> 
> I apply this patch on Linus git tree at 2.6.23 tag

Then why don't my copies of that tree have the lines flagged
above with "-" ??

In fact, if I look at the kernel.org GIT tree, it doesn't have
them either.  Your tree must have somehow gotten a bunch of
private changes.


> git-request-pull output:
> ---
> The following changes since commit bbf25010f1a6b761914430f5fca081ec8c7accd1:
>   Linus Torvalds (1):
>         Linux 2.6.23
> 
> Bryan Wu (4):
>       Blackfin SPI driver: Initial supporting BF54x in SPI driver
>       Blackfin SPI driver: add error handing
>       Blackfin SPI driver: Blackfin SPI driver does not respect the per-transfer cs_change field
>       Blackfin SPI driver: update spi driver to support multi-ports
> 
> Michael Hennerich (1):
>       Blackfin SPI driver: use new GPIO API and add error handling
> 
> Mike Frysinger (1):
>       Blackfin SPI driver: prevent people from setting bits in ctl_reg
> 
> Sonic Zhang (4):
>       Blackfin SPI driver: Add SPI master controller platform device 1
>       Blackfin SPI driver: Move GPIO config to setup and cleanup
>       Blackfin SPI driver: Fix SPI driver to work with SPI flash ST25P16 on bf548
>       Blackfin SPI driver: Clean up useless wait in bfin SPI driver
> 
>  drivers/spi/spi_bfin5xx.c                       |  586 ++++++++++++++---------
>  include/asm-blackfin/mach-bf533/portmux.h       |    2 +-
>  include/asm-blackfin/mach-bf548/defBF54x_base.h |   17 +
>  3 files changed, 373 insertions(+), 232 deletions(-)
> 
> ---
> Need I send out just one SPI patch.
> 
> Thanks
> -Bryan Wu
> 


