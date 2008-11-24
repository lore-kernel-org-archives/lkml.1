Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbYKXJzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbYKXJzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 04:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbYKXJzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 04:55:03 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37363 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751776AbYKXJzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 04:55:01 -0500
Date: Mon, 24 Nov 2008 09:55:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Shane McDonald <mcdonald.shane@gmail.com>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Resurrect IT8172 IDE controller driver
Message-ID: <20081124095510.31cc990f@lxorguk.ukuu.org.uk>
In-Reply-To: <E1L4UpB-0007ro-1g@localhost>
References: <E1L4UpB-0007ro-1g@localhost>
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

> This patch resurrects the IT8172 IDE controller code.  I began with
> the 2.6.18 version of the it8172.c file, and have moved it forward so

This appears to be a PIIX clone, is it different enough to need its own
driver ?

> +static unsigned int __devinit init_chipset_it8172(struct pci_dev *dev)
> +{
> +	unsigned char progif;
> +
> +	/*
> +	 * Place both IDE interfaces into PCI "native" mode
> +	 */
> +	pci_read_config_byte(dev, PCI_CLASS_PROG, &progif);
> +	pci_write_config_byte(dev, PCI_CLASS_PROG, progif | 0x05);
> +
> +	return dev->irq;
> +}

NAK. You can't do this here any more. The PCI code now understands
'legacy' PCI IDE header types and resources so you must fix up the
resources as a PCI quirk early on in boot or you will leave bogus
resource assignments around.

Alan
