Return-Path: <linux-kernel-owner+w=401wt.eu-S1759729AbXGNIuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759729AbXGNIuX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 04:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbXGNIuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 04:50:11 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48333 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751708AbXGNIuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 04:50:09 -0400
Date: Sat, 14 Jul 2007 09:56:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] libata: use ->proto_mask in drivers
Message-ID: <20070714095638.6e34794e@the-village.bc.nu>
In-Reply-To: <20070714081728.GB27006@havoc.gtf.org>
References: <20070714081526.GA26878@havoc.gtf.org>
	<20070714081728.GB27006@havoc.gtf.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jul 2007 04:17:28 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> 
> Review definitely helps here...

Without knowing what the precise semantics are that is hard. Every
SFF_DMA case may not be supporting DMA depending upon the configuration
so it should probably be set by ata_pci_init_one for all the normal SFF
devices.

Thus I would say
- Drop every user of ata_pci_init_one from the patch

in ata_pci_init_one set it to SFF
in ata_pci_init_bmdma set it to SFF + DMA on success

and while we are at it this would nicely fix your TODO in
ata_pci_init_bmdma by testing the class when copying the modes over.

Alan
