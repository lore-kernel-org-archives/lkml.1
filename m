Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbXGIMKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbXGIMKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 08:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXGIMK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 08:10:27 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60868 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751917AbXGIMK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 08:10:26 -0400
Date: Mon, 9 Jul 2007 13:16:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rodney Gordon II <meff@spherevision.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [BUG] IT8212 libata driver *still* hard-freezes system on boot
 on 2.6.22 final.
Message-ID: <20070709131649.5fa63744@the-village.bc.nu>
In-Reply-To: <1183979782.4301.4.camel@ghreen.sphere>
References: <1183944204.8932.8.camel@ghreen.sphere>
	<20070709104930.4e26f38f@the-village.bc.nu>
	<1183979782.4301.4.camel@ghreen.sphere>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > It would be useful to know if a kernel built with no DMA support for the
> > IT8212 behaved as that might give us a clue about what is choking. If you
> > look in drivers/ata/pata_it821x.c:it821x_init_one you'll see a pair of
> > lines that say
> > 
> > 	mwdma = 0x1f,
> > 	udma_mask = 0x7f
> > 
> > 
> > remove, rebuild and report..
> 
> Alright.
> 
> Attachment [0] is a successful boot with those lines removed. (This a
> good thing or a bad thing? :)

Thats an interesting question in itself. It does seem to indicate the
problem is DMA tuning or DMA related and not IRQ routing - which is good
as of itself.

> Attachment [1] is a successful boot with the old ata subsystem using the
> IT8212.

For the next trick set mwdma_mask = 0x07 but leave UDMA off and see what
happens. Then try with udma_mask = 0x02 which should force the 50MHz
clock on not the 66MHz clock just in case its clock related.

How much RAM do you have ?

Alan
