Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbZD1TuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbZD1TuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 15:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbZD1Ttu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 15:49:50 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:58769 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbZD1Ttt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 15:49:49 -0400
Date: Tue, 28 Apr 2009 21:49:47 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: JosephChan@via.com.tw
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, ben-linux@fluff.org
Subject: Re: [Patch 1/1 v5] via-sdmmc: VIA MSP card reader driver support
Message-ID: <20090428214947.7478e66b@mjolnir.ossman.eu>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB8090CA2D4@exchtp03.taipei.via.com.tw>
References: <20090410203520.6e43acb2@mjolnir.ossman.eu>
	<C80EF34A3D2E494DBAF9AC29C7AE4EB8090CA2D4@exchtp03.taipei.via.com.tw>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009 01:35:29 +0800
JosephChan@via.com.tw wrote:

> -----Original Message-----
> From: Pierre Ossman [mailto:drzeus-mmc@drzeus.cx] 
> >> +	else if (ios->clock >=  5000000)
> >> +		clock = PCI_CLK_8M;
> >>+	else
> >>+		clock = PCI_CLK_375K;
> >>+
> 
> > This looks a bit strange. Why are you not comparing with the clock frequency you'll be setting?
> 
> Do you mean that we should check the current clock frequency before setting?

No. My point was that you compare with, for example, 5 MHz, but then
you set the clock to 8 MHz. This is very dangerous as you'll most
likely overclock things.


> 
> > You also need to set the bits stating if the controller supports the high-speed SD and/or MMC mode, otherwise the core won't go over 25/20 MHz.
> 
> 
> OK, we will add the following line in the via_init_mmc_host function:
> 
>        mmc->caps |= MMC_CAP_MMC_HIGHSPEED |MMC_CAP_SD_HIGHSPEED;
> 

You sure the controller handles MMC high-speed timings though? They are
different from SD high-speed, which is why there are two separate caps
bits.

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
