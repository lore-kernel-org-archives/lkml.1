Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbXFYF4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbXFYF4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 01:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbXFYF4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 01:56:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49202 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbXFYF4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 01:56:38 -0400
Date: Mon, 25 Jun 2007 06:56:36 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linuxppc-dev@ozlabs.org, Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] pcmcia: CompactFlash driver for PA Semi Electra boards
Message-ID: <20070625055636.GB1057@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
	linux-pcmcia@lists.infradead.org, linuxppc-dev@ozlabs.org,
	Russell King <rmk+lkml@arm.linux.org.uk>
References: <20070625010311.GA31355@lixom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625010311.GA31355@lixom.net>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int bus_notify(struct notifier_block *nb, unsigned long action,
> +		      void *data)
> +{
> +	struct device *dev = data;
> +
> +	printk("bus notify called\n");
> +
> +	/* We are only intereted in device addition */
> +	if (action != BUS_NOTIFY_ADD_DEVICE)
> +		return 0;
> +
> +	/* We use the direct ops for localbus */
> +	dev->archdata.dma_ops = &dma_direct_ops;
> +
> +	return 0;
> +}

Sorry for not coming back to you after the last posting of the patch,
but I still really this bit of the code.  We don't set dma ops from
a driver anywhere else in the tree, so I'd really prefer if you could
handle this in architecture code somewhere.  Especially as dma_direct_ops
and the pcmcia_bug_type shouldn't really be something exported to users.

Also this code is unlogic if not buggy.  Just because you have one
electra bridge it doesn't mean all pcmcia is driven by it.  In fact I'm
pretty sure there are cardbus/pcmcia bridges that can be plugged into
plain pci slots.
