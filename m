Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbXFLKLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbXFLKLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 06:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbXFLKLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 06:11:08 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47641 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751572AbXFLKLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 06:11:07 -0400
Date: Tue, 12 Jun 2007 11:16:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: libata passthru: support PIO multi commands
Message-ID: <20070612111621.10074408@the-village.bc.nu>
In-Reply-To: <466DE438.70108@garzik.org>
References: <200706112200.l5BM0qFn005767@hera.kernel.org>
	<20070611233917.4bd8c6d7@the-village.bc.nu>
	<466DE438.70108@garzik.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +		if (multi_count != dev->multi_count)
> >> +			ata_dev_printk(dev, KERN_WARNING,
> >> +				       "invalid multi_count %u ignored\n",
> >> +				       multi_count);
> >> +	}
> > 
> > What limits log spamming here ?
> 
> Intelligence of the user with privs?

Not ever SG_IO call requires priviledges. Not all priviledged users are
so perfect they never make a mistake.

> > Also shouldn't we error this
> > situation not proceed and hope that enough data was supplied not
> > to leave us stuck half way through a command having made a nasty
> > mess on disk ?
> 
> Is that English?  Can you be more specific and more clear?

Issue a multi count sized write. Acidentally collide with another program
which mucks up the multiwrite count (for once it probably won't be HAL
making a mess ;)) and send data. The state of the disk at the point a
short multiwrite terminates is undefined, it may have written some of the
sectors, it may have blanked them all (Optical media) etc. Far better
just to error the invalid command - especially as in some cases without
Mark's fixes for DRQ cleanup on error it may even hang in one direction.

Alan
