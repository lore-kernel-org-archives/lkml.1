Return-Path: <linux-kernel-owner+w=401wt.eu-S1030864AbXAZQto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030864AbXAZQto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030861AbXAZQtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:49:43 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:41131 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030854AbXAZQtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:49:21 -0500
Message-ID: <45BA3112.503@drzeus.cx>
Date: Fri, 26 Jan 2007 17:49:22 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
MIME-Version: 1.0
To: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
CC: dbrownell@users.sourceforge.net, mikael.starvik@axis.com,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 4/5: Updates to SPI and mmc_spi: mmc_spi updated, kernel
 2.6.19
References: <200701250453.l0P4rjHN017189@ignucius.se.axis.com>
In-Reply-To: <200701250453.l0P4rjHN017189@ignucius.se.axis.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hans-Peter Nilsson wrote:
> 
> Future improvements:
> A rewrite.  Not only for the new MMC framework (I haven't looked
> at it so I don't know what's involved) but also because this
> code seems a little too, um, experimental to fit my taste.
> Functions go behind each other's back and look at and change
> data; they seem to "fix up" the result of each others work.
> It doesn't help maintenance.
> 

Right, this isn't getting merged anywhere near its current state. It
should be implemented as a host driver and we'll modify the mmc core
where needed to cover the differences when doing spi.

As for my "new framework", it's mostly reorganising the stuff already
there. But any patches will have to be reworked after that change. So
I'd suggest holding off on this for a while.

> Support SDIO and SDHC.  SDIO fails over already when mmc_spi
> sees CMD5 and reports that it's invalid.  This is mostly about
> mapping commands and reply-types, but also support for the SDIO
> interrupt line.  Ok, I guess this can't be properly defined
> before the SDIO and SDHC support at the MMC layer is clear. :)
> 

The response type problem is exactly the kind of problem that should be
solved by moving spi support into the mmc core.

> Better API.  The card-detect API should *at least optionally* be
> like the get_ro function.

I think this is so uncommon and involves so little code that it just
adds complexity to abstract it up to the core. Most hw get interrupts
for insertion/removal.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
