Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbXDHUGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbXDHUGo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 16:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbXDHUGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 16:06:44 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50025 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751978AbXDHUGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 16:06:44 -0400
Date: Sun, 8 Apr 2007 21:09:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC] pata_icside driver
Message-ID: <20070408210917.6e306851@the-village.bc.nu>
In-Reply-To: <20070408101826.GA5431@flint.arm.linux.org.uk>
References: <20070330110022.GA21653@flint.arm.linux.org.uk>
	<20070330110800.GB21653@flint.arm.linux.org.uk>
	<20070408101826.GA5431@flint.arm.linux.org.uk>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +	/*
> +	 * DMA is based on a 16MHz clock
> +	 */
> +	if (ata_timing_compute(adev, adev->dma_mode, &t, 1000, 1))
> +		return;

This seems strange for a 16MHz clock.

> +
> +	/*
> +	 * Now, properly adjust the timings.  If we have a 62.5ns clock
> +	 * period and we ask for MWDMA2, it calculates the following
> +	 * timings: active 125ns, recovery 62.5ns, cycle 125ns.
> +	 * Quite obviously bogus. 

NAK. 

At this point you need to work out why you are getting bogus results and
fix it or demonstrate a bug in the core code and fix that.

