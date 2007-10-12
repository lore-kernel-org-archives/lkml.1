Return-Path: <linux-kernel-owner+w=401wt.eu-S1760052AbXJLGyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052AbXJLGyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 02:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbXJLGyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 02:54:41 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:12974 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546AbXJLGyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 02:54:40 -0400
X-IronPort-AV: i="4.21,264,1188792000"; 
   d="scan'208"; a="53841135:sNHT30135483"
Subject: Re: [PATCH 02/10] Blackfin SPI driver: use new GPIO API and add
	error handling
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: David Brownell <david-b@pacbell.net>
Cc: Bryan Wu <bryan.wu@analog.com>, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Michael Hennerich <michael.hennerich@analog.com>
In-Reply-To: <200710112326.34500.david-b@pacbell.net>
References: <1192158304-8277-1-git-send-email-bryan.wu@analog.com>
	 <1192158304-8277-3-git-send-email-bryan.wu@analog.com>
	 <200710112326.34500.david-b@pacbell.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Fri, 12 Oct 2007 14:54:37 +0800
Message-Id: <1192172077.6247.15.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 12 Oct 2007 06:54:39.0058 (UTC) FILETIME=[C213FB20:01C80C9C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-11 at 23:26 -0700, David Brownell wrote:
> On Thursday 11 October 2007, Bryan Wu wrote:
> > @@ -1182,12 +1198,9 @@ static int __init bfin5xx_spi_probe(struct platform_device *pdev)
> >                 return -ENOMEM;
> >         }
> >  
> > -       if (peripheral_request(P_SPI0_SCK, DRV_NAME) ||
> > -                peripheral_request(P_SPI0_MISO, DRV_NAME) ||
> > -                peripheral_request(P_SPI0_MOSI, DRV_NAME) ) {
> > -
> > +       if (setup_pin_mux(1)) {
> >                 dev_err(&pdev->dev, ": Requesting Peripherals failed\n");
> > -               goto out_error_queue_alloc;
> > +               goto out_error;
> >         }
> >  
> >         drv_data = spi_master_get_devdata(master);
> > 
> 
> Still doesn't apply ... what tree are you generating this series against??

I apply this patch on Linus git tree at 2.6.23 tag
git-request-pull output:
---
The following changes since commit bbf25010f1a6b761914430f5fca081ec8c7accd1:
  Linus Torvalds (1):
        Linux 2.6.23

Bryan Wu (4):
      Blackfin SPI driver: Initial supporting BF54x in SPI driver
      Blackfin SPI driver: add error handing
      Blackfin SPI driver: Blackfin SPI driver does not respect the per-transfer cs_change field
      Blackfin SPI driver: update spi driver to support multi-ports

Michael Hennerich (1):
      Blackfin SPI driver: use new GPIO API and add error handling

Mike Frysinger (1):
      Blackfin SPI driver: prevent people from setting bits in ctl_reg

Sonic Zhang (4):
      Blackfin SPI driver: Add SPI master controller platform device 1
      Blackfin SPI driver: Move GPIO config to setup and cleanup
      Blackfin SPI driver: Fix SPI driver to work with SPI flash ST25P16 on bf548
      Blackfin SPI driver: Clean up useless wait in bfin SPI driver

 drivers/spi/spi_bfin5xx.c                       |  586 ++++++++++++++---------
 include/asm-blackfin/mach-bf533/portmux.h       |    2 +-
 include/asm-blackfin/mach-bf548/defBF54x_base.h |   17 +
 3 files changed, 373 insertions(+), 232 deletions(-)

---
Need I send out just one SPI patch.

Thanks
-Bryan Wu
