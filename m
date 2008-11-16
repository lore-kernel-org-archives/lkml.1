Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbYKPADS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbYKPADS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 19:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbYKPADI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 19:03:08 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:53751 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751620AbYKPADF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 19:03:05 -0500
Date: Sun, 16 Nov 2008 00:03:02 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       sdhci-devel@list.drzeus.cx
Subject: Re: [patch 5/7] SDHCI: Samsung SDHCI (HSMMC) driver
Message-ID: <20081116000302.GD9161@fluff.org.uk>
References: <20081103200944.099353331@fluff.org.uk> <20081103201010.652101443@fluff.org.uk> <20081114224813.063017d7@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081114224813.063017d7@mjolnir.drzeus.cx>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 10:48:13PM +0100, Pierre Ossman wrote:
> On Mon, 03 Nov 2008 20:09:49 +0000
> Ben Dooks <ben-linux@fluff.org> wrote:
> 
> > +static void sdhci_s3c_sel_sclk(struct sdhci_host *host)
> > +{
> > +	struct sdhci_s3c *ourhost = to_s3c(host);
> > +
> > +	/* select sclk */
> > +	u32 tmp = readl(host->ioaddr + 0x80);
> > +
> > +	if ((tmp & (3 << 4)) == (2 << 4))
> > +		return;
> > +
> > +	tmp &= ~(3<<4);
> > +	tmp |= (2 << 4);
> > +	writel(tmp, host->ioaddr + 0x80);
> > +}
> 
> No defines for this? This is not terribly readable.

it was only temporary to ensure that if people bisected before
the clock callback was added the host would at least work even
if it was locked to one clock input.
 
> > +	if (pdata->cfg_card)
> > +		pdata->cfg_card(ourhost->pdev, host->ioaddr,
> > +				ios, host->mmc->card);
> 
> What's the deal here? Hosts shouldn't know more about the card than the
> MMC core tells them.

Depending on exactly which version, there's a number of configurations
in the extra configuration registers that get changed, such as delays
used for clock feedback which are meant to be chnaged when the speed
of the card is changed. Unfortunately this changes depending on the
chip model and possibly also on the board it is on.

The other is that it is possible that depending on the chip and board
combination things like the GPIO driver-strength controls will need to
be changed.
 
> Since I have no hardware for this, could you take it upon you to handle
> support for these chips? I'd like a MAINTAINERS patch for that as well.

ok, i'll add it to the list.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
