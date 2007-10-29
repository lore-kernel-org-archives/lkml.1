Return-Path: <linux-kernel-owner+w=401wt.eu-S1757475AbXJ2Ibe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbXJ2Ibe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 04:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbXJ2Ib1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 04:31:27 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45062 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752210AbXJ2Ib0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 04:31:26 -0400
Date: Mon, 29 Oct 2007 08:33:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ciaran McCreesh <ciaran.mccreesh@blueyonder.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Abit F-190HD Onboard rlt8169 Ethernet Controller
Message-ID: <20071029083333.18a4dab7@the-village.bc.nu>
In-Reply-To: <20071029061532.5d10dfc6@snowcone>
References: <20071029061532.5d10dfc6@snowcone>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It is not recognised by 2.6.24-rc1. I'm guessing it's because the
> vendor ID is 0001 rather than something sensible. I patched the kernel
> as follows:

A vendor ID of 1 is very very very broken. Do all boards have this or do
you have a faulty box (perhaps a misprogrammed EEPROM somewhere)

> 
> --- drivers/net/r8169.c.orig	2007-10-29 05:37:02.000000000 +0000
> +++ drivers/net/r8169.c	2007-10-29 05:54:30.000000000 +0000
> @@ -165,6 +165,7 @@
>  	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8136), 0, 0, RTL_CFG_2 },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8167), 0, 0, RTL_CFG_0 },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8168), 0, 0, RTL_CFG_1 },
> +	{ PCI_DEVICE(PCI_ANY_ID,		0x8168), 0, 0, RTL_CFG_2 },

That will match any device 0x8168 not just a realtek one. I'd use 0x0001,
0x8168 for the match. However I'd seriously consider checking another
board as I suspect you simply have a return candidate.

