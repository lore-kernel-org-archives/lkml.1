Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbZAJKlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbZAJKlX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 05:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbZAJKlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 05:41:13 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39608 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753442AbZAJKlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 05:41:12 -0500
Date: Sat, 10 Jan 2009 10:41:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: todays git: WARNING: at drivers/ata/libata-sff.c:1017
 ata_sff_hsm_move+0x45e/0x750()
Message-ID: <20090110104114.633cacd8@lxorguk.ukuu.org.uk>
In-Reply-To: <200901101009.13699.borntraeger@de.ibm.com>
References: <200901091334.55823.borntraeger@de.ibm.com>
	<20090109124412.619330ea@lxorguk.ukuu.org.uk>
	<200901101009.13699.borntraeger@de.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I did some printk debugging. 
> __atapi_pio_bytes is called with bytes=18. That means with 32bit transfers
> there is a 2 byte trailing transfer, which triggers this WARN_ON.

Ouch.. that means all that someone issued a multiple segment data
transfer with a 2 byte aligned chunk in the middle.

That is a bit of a suprise because we set blk_queue_dma_alignment to 3 so
the block layer should never hand us an sg list in that form. That means
we've either got a block layer bug or someone somewhere is generating
invalid sg lists internally to libata.

Can you dump qc->cdb[] and see what command is getting issued in the
broken form ?

Alan
