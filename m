Return-Path: <linux-kernel-owner+w=401wt.eu-S1756994AbZASWot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994AbZASWot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 17:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZASWok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 17:44:40 -0500
Received: from gate.crashing.org ([63.228.1.57]:55320 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbZASWoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 17:44:39 -0500
Subject: Re: [PATCH 3/6] ide: small ide_register_port() cleanup
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Andreas Schwab <schwab@suse.de>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200901191243.13939.bzolnier@gmail.com>
References: <200811122216.06257.bzolnier@gmail.com>
	 <jeocy58l15.fsf@sykes.suse.de>  <200901191243.13939.bzolnier@gmail.com>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 09:44:24 +1100
Message-Id: <1232405064.23611.69.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Since it is the second time this ->parent special case bited us in the *ss:
> 
> pmac_ide_macio_attach():
> ...
> 	hw.dev = &mdev->bus->pdev->dev;
> 	hw.parent = &mdev->ofdev.dev;
> ...
> 
> I again wonder what is the reason for having different struct device-s used
> for DBDMA and for device tree on MACIO PMAC controllers.  Maybe there is no
> real reason after all and we can use &mdev->ofdev.dev also for hwif->dev?

Historically, dma_map_* wasn't supported on the macio devs, had to use
the underlying pci dev.

In fact, it might even still be the case. I need to have a look at it
after LCA, though with our current DMA ops, it should be easy to fix.

Cheers,
Ben.


