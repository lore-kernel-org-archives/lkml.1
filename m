Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbYKNWUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbYKNWUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 17:20:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYKNWUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 17:20:25 -0500
Received: from server.drzeus.cx ([85.8.24.28]:54822 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751505AbYKNWUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 17:20:24 -0500
Date: Fri, 14 Nov 2008 23:20:21 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, sdhci-devel@list.drzeus.cx,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [patch 7/7] SDHCI: Add change_clock callback for glue drivers
Message-ID: <20081114232021.183de8d9@mjolnir.drzeus.cx>
In-Reply-To: <20081103201011.011975583@fluff.org.uk>
References: <20081103200944.099353331@fluff.org.uk>
	<20081103201011.011975583@fluff.org.uk>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Nov 2008 20:09:51 +0000
Ben Dooks <ben-linux@fluff.org> wrote:

> Add a change_clock callback to allow drivers to update
> device specific clock selections and control registers
> when there is a change in clock.
> 
> Move the main part of sdhci_set_clock() to a new routine
> which can be called by the glue drivers to do the sdhci
> standard clock management.
> 
> Update the sdhci-s3c driver to use this to select the
> appropriate clock source when clocks change.
> 
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> 

I'm afraid I don't quite follow on the requirements here. Care to
elaborate as to why this is needed?

> Index: linux.git/drivers/mmc/host/sdhci-pci.c
> ===================================================================
> --- linux.git.orig/drivers/mmc/host/sdhci-pci.c	2008-11-03 12:17:50.000000000 +0000
> +++ linux.git/drivers/mmc/host/sdhci-pci.c	2008-11-03 12:18:41.000000000 +0000
> @@ -391,6 +391,7 @@ static int sdhci_pci_enable_dma(struct s
>  
>  static struct sdhci_ops sdhci_pci_ops = {
>  	.enable_dma	= sdhci_pci_enable_dma,
> +	.change_clock	= sdhci_change_clock,
>  };
>  
>  /*****************************************************************************\

This seems pointless :)

> @@ -950,6 +955,8 @@ out:
>  	host->clock = clock;
>  }
>  
> +EXPORT_SYMBOL_GPL(sdhci_set_clock);
> +

Wrong symbol. :)

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
