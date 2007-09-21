Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbXIUK3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbXIUK3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 06:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbXIUK3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 06:29:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38546 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346AbXIUK3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 06:29:15 -0400
Date: Fri, 21 Sep 2007 03:29:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Peer Chen" <peerchen@gmail.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "jeff" <jeff@garzik.org>,
       "linux-ide" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] ahci: enable GHC.AE bit before set GHC.HR
Message-Id: <20070921032903.45deb785.akpm@linux-foundation.org>
In-Reply-To: <200709211327569648280@gmail.com>
References: <200709211327569648280@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007 13:28:01 +0800 "Peer Chen" <peerchen@gmail.com> wrote:

> According to the description of section 5.2.2.1 and 10.1.2 of AHCI specification rev1_1/rev1_2, GHC.HR shall only be set to __1__
> by software when GHC.AE is set to __1__.

This text contained non-ascii garbage which came through as __1__.

I'll assume that you actually meant "1".


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
> 

We don't normally do that (void) cast.
