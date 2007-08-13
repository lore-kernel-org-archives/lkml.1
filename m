Return-Path: <linux-kernel-owner+w=401wt.eu-S938215AbXHMP2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938215AbXHMP2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030240AbXHMNX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 09:23:26 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60589 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S972837AbXHMNXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 09:23:19 -0400
Date: Mon, 13 Aug 2007 14:30:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: mikpe@it.uu.se, bzolnier@gmail.com, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_artop: fix UDMA5 for AEC6280[R] and UDMA6 for
 AEC6880[R]
Message-ID: <20070813143032.4caffc28@the-village.bc.nu>
In-Reply-To: <200708121153.l7CBrsm5011470@harpo.it.uu.se>
References: <200708121153.l7CBrsm5011470@harpo.it.uu.se>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > It would be nice to know why - is the cable detet coming out right on
> > this ?
> 
> The box has a short 40-wire cable, so pata_artop drops to udma/33
> while aec62xx does udma/100 without intervention. I added an override

Curious as both use the same cable detect logic. 

> to artop6260_cable_detect() to make it return PATA40_SHORT on this
> platform, and with that it does udma/100 as expected.

Patch would be good. Looks like there are a couple of cases anyway where
artop needs platform specific uglies


> 
> Read performance fluctuates quite a bit, but seems to be 1-3 MB/s
> slower than aec62xx on average. I compared lspci -vvxxx and the
> only differences are a latency setting and some ROM thingy:

Latency shouldn't matter but you can tweak the driver to verify easily
enough
