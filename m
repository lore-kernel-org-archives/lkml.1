Return-Path: <linux-kernel-owner+w=401wt.eu-S933189AbZHVCob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189AbZHVCob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 22:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933177AbZHVCob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 22:44:31 -0400
Received: from relais.videotron.ca ([24.201.245.36]:57086 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933176AbZHVCoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 22:44:30 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 21 Aug 2009 22:44:00 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
       mirq-linux@rere.qmqm.pl, lkml <linux-kernel@vger.kernel.org>,
       manuel.lauss@gmail.com, ppisa@pikron.com, maen@marvell.com,
       s.hauer@pengutronix.de, tony@atomide.com, madhu.cr@ti.com,
       drzeus@drzeus.cx, ben-linux@fluff.org, avorontsov@ru.mvista.com,
       pierre@ossman.eu, sdhci-devel@lists.ossman.eu, saschasommer@freenet.de,
       oakad@yahoo.com, ian@mnementh.co.uk, HaraldWelte@viatech.com,
       JosephChan@via.com.tw
Subject: Re: [PATCH] Convert MMC subsys drivers to dev_pm_ops
In-reply-to: <200908220223.50588.marek.vasut@gmail.com>
Message-id: <alpine.LFD.2.00.0908212234150.6044@xanadu.home>
References: <200908220223.50588.marek.vasut@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Aug 2009, Marek Vasut wrote:

> Hi,
> 
> This converts most of the drivers found in drivers/mmc/host to dev_pm_ops.
> Also, it contains some fixes for the probe/remove functions in some cases.

Are you sure you're actually fixing things?

You replaced platform_driver_probe() calls with 
platform_driver_register() calls, and made the probe functions __devinit 
instead of __init.  Especially when the platform device is unlikely to 
go away or new ones to ever appear, there is no point keeping the 
probe code around after it is done.


Nicolas
