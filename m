Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbYKNVs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbYKNVs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 16:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYKNVsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 16:48:17 -0500
Received: from server.drzeus.cx ([85.8.24.28]:58666 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751466AbYKNVsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 16:48:16 -0500
Date: Fri, 14 Nov 2008 22:48:13 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, sdhci-devel@list.drzeus.cx,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [patch 5/7] SDHCI: Samsung SDHCI (HSMMC) driver
Message-ID: <20081114224813.063017d7@mjolnir.drzeus.cx>
In-Reply-To: <20081103201010.652101443@fluff.org.uk>
References: <20081103200944.099353331@fluff.org.uk>
	<20081103201010.652101443@fluff.org.uk>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Nov 2008 20:09:49 +0000
Ben Dooks <ben-linux@fluff.org> wrote:

> +static void sdhci_s3c_sel_sclk(struct sdhci_host *host)
> +{
> +	struct sdhci_s3c *ourhost = to_s3c(host);
> +
> +	/* select sclk */
> +	u32 tmp = readl(host->ioaddr + 0x80);
> +
> +	if ((tmp & (3 << 4)) == (2 << 4))
> +		return;
> +
> +	tmp &= ~(3<<4);
> +	tmp |= (2 << 4);
> +	writel(tmp, host->ioaddr + 0x80);
> +}

No defines for this? This is not terribly readable.

> +	if (pdata->cfg_card)
> +		pdata->cfg_card(ourhost->pdev, host->ioaddr,
> +				ios, host->mmc->card);

What's the deal here? Hosts shouldn't know more about the card than the
MMC core tells them.

Since I have no hardware for this, could you take it upon you to handle
support for these chips? I'd like a MAINTAINERS patch for that as well.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
