Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbYJBISN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbYJBISN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbYJBISB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:18:01 -0400
Received: from server.drzeus.cx ([85.8.24.28]:41318 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752822AbYJBISA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:18:00 -0400
Date: Thu, 2 Oct 2008 10:17:54 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SDHCI: timeout during data transfer
Message-ID: <20081002101754.031d6710@mjolnir.drzeus.cx>
In-Reply-To: <20080923212459.GA13888@dreamland.darkstar.lan>
References: <20080923212459.GA13888@dreamland.darkstar.lan>
X-Mailer: Claws Mail 3.5.0cvs92 (GTK+ 2.14.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2008 23:24:59 +0200
Luca Tettamanti <kronos.it@gmail.com> wrote:

> Hi,
> I'm seeing timeout errors when transfering "big" (over 1MB or so) files to a SD
> card (small files are ok):
> 
> [  251.956666] mmcblk0: error -110 transferring data
> [  251.979810] end_request: I/O error, dev mmcblk0, sector 1572758

Looks like the card died on you there. Did you build the kernel
yourself? If so, it would be helpful if you could enable
CONFIG_MMC_DEBUG and give me a complete dmesg dump from when this
happens.

> kernel in use is 2.6.27-rc6, and this is the controller:
> 
> 09:01.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 22)
> 09:01.2 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev 12)
> 09:01.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 12)
> 09:01.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 12)
> 
> Googling around I found a patch[1] that introduced a quirk to address an
> off-by-one issue for the timeout value in certain controllers.
> 
> With this patch:
> 

The patch doubles the timeout, so something is clearly broken if that
solves the issue. I'd like to identify if it's the driver, controller
or card first though.

Are you experiencing this with just this card, or with all?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
