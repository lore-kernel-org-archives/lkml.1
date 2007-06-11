Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbXFKWeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbXFKWeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 18:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbXFKWeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 18:34:04 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41640 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751726AbXFKWeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 18:34:03 -0400
Date: Mon, 11 Jun 2007 23:39:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: jeff@garzik.org
Subject: Re: libata passthru: support PIO multi commands
Message-ID: <20070611233917.4bd8c6d7@the-village.bc.nu>
In-Reply-To: <200706112200.l5BM0qFn005767@hera.kernel.org>
References: <200706112200.l5BM0qFn005767@hera.kernel.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +	if (is_multi_taskfile(tf)) {
> +		unsigned int multi_count = 1 << (cdb[1] >> 5);
> +
> +		/* compare the passed through multi_count
> +		 * with the cached multi_count of libata
> +		 */
> +		if (multi_count != dev->multi_count)
> +			ata_dev_printk(dev, KERN_WARNING,
> +				       "invalid multi_count %u ignored\n",
> +				       multi_count);
> +	}

What limits log spamming here ? Also shouldn't we error this
situation not proceed and hope that enough data was supplied not
to leave us stuck half way through a command having made a nasty
mess on disk ?
	
