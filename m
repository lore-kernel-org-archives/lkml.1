Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbZD1TqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbZD1TqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 15:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbZD1TqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 15:46:11 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:52197 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbZD1TqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 15:46:10 -0400
Date: Tue, 28 Apr 2009 21:45:31 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Kumar, Purushotam" <purushotam@ti.com>
Cc: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] DaVinci: MMC: V4: MMC/SD controller driver for
 DaVinci family.
Message-ID: <20090428214531.23950257@mjolnir.ossman.eu>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB59301CCA0190F@dbde02.ent.ti.com>
References: <1238666196-29979-1-git-send-email-purushotam@ti.com>
	<20090410214143.4aa4045e@mjolnir.ossman.eu>
	<B85A65D85D7EB246BE421B3FB0FBB59301CCA0190F@dbde02.ent.ti.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009 16:34:22 +0530
"Kumar, Purushotam" <purushotam@ti.com> wrote:

> > > +
> > > +	if (mmc_freq > mmc_req_freq)
> > > +		mmc_push_pull = mmc_push_pull + 1;
> > 
> > The naming of the divider is a bit confusing here. :)
> 
> I am thinking to change " mmc_push_pull" to " mmc_push_pull_divider". Please suggest other appropriate name.
> 

Or just "divider". The rest should be clear from the context.

> > > +	if (ios->bus_mode == MMC_BUSMODE_OPENDRAIN) {
> > > +		u32 temp;
> > > +
> > > +		/* Ignoring the init clock value passed for fixing the inter
> > > +		 * operability with different cards.
> > > +		 */
> > > +		open_drain_freq = ((unsigned int)cpu_arm_clk
> > > +				/ (2 * MMCSD_INIT_CLOCK)) - 1;
> > > +
> > > +		if (open_drain_freq > 0xFF)
> > > +			open_drain_freq = 0xFF;
> > > +
> > > +		temp = readl(host->base + DAVINCI_MMCCLK) & ~MMCCLK_CLKRT_MASK;
> > > +		temp |= open_drain_freq;
> > > +		writel(temp, host->base + DAVINCI_MMCCLK);
> > > +
> > > +		/* Convert ns to clock cycles */
> > > +		ns_in_one_cycle = (1000000) / (MMCSD_INIT_CLOCK/1000);
> > 
> > I'm still not sure why you need this. Open drain mode is always used at
> > a low frequency anyway.
> 
> 
> If my understanding is correct you are suggesting that at lower freq. there is no need to update the timeout parameter and can use the default value of ns_in_one_cycle.
> 
> The mmc_davinci_prepare_data() may  be called even during open drain frequency mode and here we are calculating the timeout value and updating the timeout reg. So ns_in_one_cycle should hold a proper value once we call mmc_davinci_prepare_data(). I think there is no harm in having this calculation here.
> 

I see. I thought this was some fiddling to override the core's decision
on clock frequency.

Why do you need to calculate the timeout differently based on
push-pull/open drain mode though?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
  TigerVNC, core developer          http://www.tigervnc.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
