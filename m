Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbXIUKak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbXIUKak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 06:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbXIUKad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 06:30:33 -0400
Received: from brick.kernel.dk ([87.55.233.238]:24478 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbXIUKac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 06:30:32 -0400
Date: Fri, 21 Sep 2007 12:31:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Peer Chen <peerchen@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, jeff <jeff@garzik.org>,
       akpm <akpm@linux-foundation.org>, linux-ide <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] ahci: enable GHC.AE bit before set GHC.HR
Message-ID: <20070921103120.GK2367@kernel.dk>
References: <200709211327569648280@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200709211327569648280@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21 2007, Peer Chen wrote:
> According to the description of section 5.2.2.1 and 10.1.2 of AHCI specification rev1_1/rev1_2, GHC.HR shall only be set to ¡®1¡¯
> by software when GHC.AE is set to ¡®1¡¯.
> 
> Signed-off-by: Peer Chen <peerchen@gmail.com>
> ---
> --- linux-2.6.23-rc7/drivers/ata/ahci.c.orig	2007-09-20 11:01:55.000000000 -0400
> +++ linux-2.6.23-rc7/drivers/ata/ahci.c	2007-09-20 11:07:31.000000000 -0400
> @@ -834,6 +834,10 @@ static int ahci_reset_controller(struct 
>  	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
>  	u32 tmp;
>  
> +        /* turn on AHCI mode before controller reset*/
> +        writel(HOST_AHCI_EN, mmio + HOST_CTL);
> +        (void) readl(mmio + HOST_CTL);  /* flush */
> +
>  	/* global controller reset */
>  	tmp = readl(mmio + HOST_CTL);
>  	if ((tmp & HOST_RESET) == 0) {

I appreciate the readl() flushes, but in this particular case we end up
reading the exact offset again below.

-- 
Jens Axboe

