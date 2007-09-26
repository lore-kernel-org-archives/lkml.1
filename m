Return-Path: <linux-kernel-owner+w=401wt.eu-S1759128AbXIZLRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128AbXIZLRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 07:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758824AbXIZLRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 07:17:42 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40544 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758758AbXIZLRl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 07:17:41 -0400
Date: Wed, 26 Sep 2007 12:23:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Peer Chen <peerchen@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, linux-ide <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] ahci: enable GHC.AE bit before set GHC.HR
Message-ID: <20070926122332.39351382@the-village.bc.nu>
In-Reply-To: <46F9DA07.4080201@garzik.org>
References: <200709211327569648280@gmail.com>
	<46F9DA07.4080201@garzik.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 00:03:19 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Peer Chen wrote:
> > According to the description of section 5.2.2.1 and 10.1.2 of AHCI specification rev1_1/rev1_2, GHC.HR shall only be set to ¡®1¡¯
> > by software when GHC.AE is set to ¡®1¡¯.
> > 
> > Signed-off-by: Peer Chen <peerchen@gmail.com>
> > ---
> > --- linux-2.6.23-rc7/drivers/ata/ahci.c.orig	2007-09-20 11:01:55.000000000 -0400
> > +++ linux-2.6.23-rc7/drivers/ata/ahci.c	2007-09-20 11:07:31.000000000 -0400
> > @@ -834,6 +834,10 @@ static int ahci_reset_controller(struct 
> >  	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
> >  	u32 tmp;
> >  
> > +        /* turn on AHCI mode before controller reset*/
> > +        writel(HOST_AHCI_EN, mmio + HOST_CTL);
> > +        (void) readl(mmio + HOST_CTL);  /* flush */
> 
> applied the attached patch, inspired by yours.


NAK - mmio is an iomap so writel and readl are the wrong things to use

