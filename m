Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbXKXAgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbXKXAgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 19:36:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbXKXAgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 19:36:23 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:34177 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537AbXKXAgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 19:36:23 -0500
Message-ID: <47477202.3080602@garzik.org>
Date: Fri, 23 Nov 2007 19:36:18 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_isapnp: Polled devices
References: <20071119144105.6ce66cd0@the-village.bc.nu>
In-Reply-To: <20071119144105.6ce66cd0@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> If a card has no IRQ then pass no interrupt handler but allow polled
> usage.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/ata/pata_isapnp.c linux-2.6.24-rc2-mm1/drivers/ata/pata_isapnp.c
> --- linux.vanilla-2.6.24-rc2-mm1/drivers/ata/pata_isapnp.c	2007-11-16 17:54:39.000000000 +0000
> +++ linux-2.6.24-rc2-mm1/drivers/ata/pata_isapnp.c	2007-11-16 18:14:29.000000000 +0000
> @@ -75,13 +75,16 @@
>  	struct ata_host *host;
>  	struct ata_port *ap;
>  	void __iomem *cmd_addr, *ctl_addr;
> +	int irq = 0;
> +	irq_handler_t handler = NULL;
>  
>  	if (pnp_port_valid(idev, 0) == 0)

applied #upstream-fixes


