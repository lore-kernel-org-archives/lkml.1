Return-Path: <linux-kernel-owner+w=401wt.eu-S933778AbXHJR0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778AbXHJR0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 13:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755988AbXHJR0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 13:26:36 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47827 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750866AbXHJR0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 13:26:34 -0400
Date: Fri, 10 Aug 2007 18:33:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: bzolnier@gmail.com, jgarzik@pobox.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_artop: fix UDMA5 for AEC6280[R] and UDMA6 for
 AEC6880[R]
Message-ID: <20070810183343.6f1ebed0@the-village.bc.nu>
In-Reply-To: <200708101438.l7AEcNna029762@harpo.it.uu.se>
References: <200708101438.l7AEcNna029762@harpo.it.uu.se>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Tested on ATP865 (1191:0008 rev 07) in a DS101 box (an ARM-based NAS).
> Seems to work fine.

Its tested fairly hard on several NAS boxes (and still needs a fix for
one)

> However, I'm gettting consistently lower read throughput with pata_artop
> (13-19 MB/s) than with aec62xx (22 MB/s) on an oldish WD drive, and using
> pata_artop triggers a WARN_ON(irqs_disabled()) in arch/arm/mm/consistent.c:

It would be nice to know why - is the cable detet coming out right on
this ?

> WARNING: at arch/arm/mm/consistent.c:364 dma_free_coherent()

ARM has a problem with dma_free_coherent with IRQ disabled. Unfortunately
under high load ARM decides to use dma_free_coherent inside
dma_unmap_sg(). This as far as I can see is an ARM problem not a libata
problem and one you can duplicate with other drivers under high load.

If any ARM people can tell me what is going on and help fix it either in
ARM or libata that would be great.

Alan
