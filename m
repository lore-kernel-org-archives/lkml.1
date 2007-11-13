Return-Path: <linux-kernel-owner+w=401wt.eu-S1760360AbXKMC37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360AbXKMC37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 21:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbXKMC3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 21:29:51 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52087 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751029AbXKMC3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 21:29:51 -0500
Date: Tue, 13 Nov 2007 02:29:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonas Stare <jonas.stare@purplescout.se>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] drivers/ide/ide-probe.c, kernel 2.6.23.1
Message-ID: <20071113022910.0cef4290@the-village.bc.nu>
In-Reply-To: <20071112132448.0facce12.akpm@linux-foundation.org>
References: <473434F1.50509@purplescout.se>
	<20071112132448.0facce12.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > that they were not in a BSY state. The problem was most likely in the 
> > hardware but this patch enables you to ignore waiting for disks by 
> > setting hdX=noprobe (and not setting the geometry by hand) as a kernel 
> > option.

Probably someone saving a billionth of a cent on a resistor.

> > -       SELECT_DRIVE(&hwif->drives[1]);
> > -       hwif->OUTB(8, hwif->io_ports[IDE_CONTROL_OFFSET]);
> > -       mdelay(2);
> > -       rc = ide_wait_not_busy(hwif, 35000);

Please first verify if you see the same problem with the newer ATA
drivers. I suspect you will and if so we should be fixing those not the
legacy drivers (or as well as ..)

Alan
