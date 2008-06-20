Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbYFTLB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbYFTLB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 07:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYFTLBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 07:01:21 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:57804 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752003AbYFTLBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 07:01:21 -0400
Date: Fri, 20 Jun 2008 12:01:15 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, Ben Dooks <ben-linux@fluff.org>
Subject: Re: MMC: card test driver should not be builtin with other card
	support
Message-ID: <20080620110115.GB21835@fluff.org.uk>
References: <20080620105802.173598466@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620105802.173598466@fluff.org.uk>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2008 at 11:58:02AM +0100, ben@fluff.org.uk wrote:
> The mmc test driver and mmc block driver will attempt to bind
> to any card present in the system, which means only one of these
> drivers will end up with the card. If either one of these is selected
> as builtin, ensure the other does not get built.
> 
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> 
> Index: linux-2.6.26-rc6-sdmmc3/drivers/mmc/card/Kconfig
> ===================================================================
> --- linux-2.6.26-rc6-sdmmc3.orig/drivers/mmc/card/Kconfig	2008-06-20 11:53:08.000000000 +0100
> +++ linux-2.6.26-rc6-sdmmc3/drivers/mmc/card/Kconfig	2008-06-20 11:53:29.000000000 +0100
> @@ -6,7 +6,7 @@ comment "MMC/SD Card Drivers"
>  
>  config MMC_BLOCK
>  	tristate "MMC block device driver"
> -	depends on BLOCK
> +	depends on BLOCK && MMC_TEST != y
>  	default y
>  	help
>  	  Say Y here to enable the MMC block device driver support.
> @@ -42,6 +42,7 @@ config SDIO_UART
>  config MMC_TEST
>  	tristate "MMC host test driver"
>  	default n
> +	depends on MMC_BLOCK != y
>  	help
>  	  Development driver that performs a series of reads and writes
>  	  to a memory card in order to expose certain well known bugs

This is what I would have liked to have done in Kconfig, but of course
the system fails with a circular dependency error. Is there any way
to get this done without some horrible hacks?

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
