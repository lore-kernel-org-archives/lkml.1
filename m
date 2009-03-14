Return-Path: <linux-kernel-owner+w=401wt.eu-S1762959AbZCNAwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762959AbZCNAwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbZCNAU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:20:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:54013 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754853AbZCNAU4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:20:56 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX19zAylakzZzX5vjM7NHMsG8jCSfsxLho9sLFONSjG
	RDtlsMF8GDlqNG
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: gregkh@suse.de
Subject: Re: patch sdhci-add-no_busy_irq-quirk-for-marvell-cafe-host-chip.patch added to 2.6.28-stable tree
Date: Sat, 14 Mar 2009 01:20:49 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, dilinger@debian.org, drzeus@drzeus.cx,
       stable@kernel.org
References: <20090313051410.668244906E@coco.kroah.org>
In-Reply-To: <20090313051410.668244906E@coco.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903140120.52111.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Freitag, 13. März 2009, gregkh@suse.de wrote:
> This is a note to let you know that we have just queued up the patch titled
> 
>     Subject: sdhci: Add NO_BUSY_IRQ quirk for Marvell CAFE host chip
> 
> to the 2.6.28-stable tree.  Its filename is
> 
>     sdhci-add-no_busy_irq-quirk-for-marvell-cafe-host-chip.patch
> 
> A git repo of this tree can be found at 
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> 
> From a0874897b1ba106298e4303a25456a473fc40f3d Mon Sep 17 00:00:00 2001
> From: Andres Salomon <dilinger@debian.org>
> Date: Mon, 2 Mar 2009 21:48:20 +0100
> Subject: sdhci: Add NO_BUSY_IRQ quirk for Marvell CAFE host chip
> 
> From: Andres Salomon <dilinger@debian.org>
> 
> commit a0874897b1ba106298e4303a25456a473fc40f3d upstream.
> 
> As described here: http://lkml.org/lkml/2009/2/20/265
> 
> The CAFE chip is broken due to commit e809517f6fa5803a5a1cd5602.
> Anton added a quirk here: http://lkml.org/lkml/2009/2/20/279 that fixes
> CAFE's problem.  This adds the quirk for CAFE.

Adding this patch alone breaks compiling the current -stable queue for 
2.6.28:

  CC [M]  drivers/mmc/host/sdhci-pci.o
drivers/mmc/host/sdhci-pci.c:110: error: 'SDHCI_QUIRK_NO_BUSY_IRQ' undeclared here (not in a function)
make[6]: *** [drivers/mmc/host/sdhci-pci.o] Error 1
make[5]: *** [drivers/mmc/host] Error 2
make[4]: *** [drivers/mmc] Error 2
make[3]: *** [drivers] Error 2

It seems to depend the following patch, wich introduces this particular 
quirk type:

commit f945405cdecd9e0ae3e58ff84cabd19b4522965e
Author: Ben Dooks <ben-linux@fluff.org>
Date:   Fri Feb 20 20:33:08 2009 +0300

    sdhci: Add quirk for controllers with no end-of-busy IRQ

    The Samsung SDHCI (and FSL eSDHC) controller block seems to fail
    to generate an INT_DATA_END after the transfer has completed and
    the bus busy state finished.

    Changes in e809517f6fa5803a5a1cd56026f0e2190fc13d5c to use the
    new busy method are the cause of the behaviour change.

    Signed-off-by: Ben Dooks <ben-linux@fluff.org>
    Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
    Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>


Regards
	Stefan Lippers-Hollmann

-- 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/mmc/host/sdhci-pci.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/drivers/mmc/host/sdhci-pci.c
> +++ b/drivers/mmc/host/sdhci-pci.c
> @@ -107,6 +107,7 @@ static const struct sdhci_pci_fixes sdhc
>  
>  static const struct sdhci_pci_fixes sdhci_cafe = {
>  	.quirks		= SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER |
> +			  SDHCI_QUIRK_NO_BUSY_IRQ |
>  			  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL,
>  };
>  
> 
> 
> Patches currently in stable-queue which might be from dilinger@debian.org are
> 
> queue-2.6.28/sdhci-add-no_busy_irq-quirk-for-marvell-cafe-host-chip.patch
> --
> To unsubscribe from this list: send the line "unsubscribe stable-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
