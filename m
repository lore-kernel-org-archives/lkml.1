Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbZFVMbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbZFVMbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZFVMbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:31:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44703 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752193AbZFVMbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:31:11 -0400
Date: Mon, 22 Jun 2009 13:32:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: greg@kroah.com, torvalds@linux-foundation.org, Kevin.Huang@rdc.com.tw
Subject: Re: Staging: add pata_rdc driver
Message-ID: <20090622133222.3a689f22@lxorguk.ukuu.org.uk>
In-Reply-To: <200906200109.n5K19iaC012636@hera.kernel.org>
References: <200906200109.n5K19iaC012636@hera.kernel.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static struct pci_bits ATA_Decode_Enable_Bits[] = { // see ATA Host Adapters Standards.
> +    { 0x41U, 1U, 0x80UL, 0x80UL },    /* port (Channel) 0 */
> +    { 0x43U, 1U, 0x80UL, 0x80UL },    /* port (Channel) 1 */
> +};
> +

Decode bits 0x80 in 0x41/0x43 - same as ata_piix


> +    /* no hotplugging support (FIXME) */ // why???

copied from the piix driver


> +        Mask = ATAConfiguration_IDEIOConfiguration_PrimaryDeviceCable80Report;

Cable bits at 0x54: same format as ATA_PIIX

and this continues throughout the driver

So it seems the following occurred

- take ata_piix
- remove all the innards of it
- replace them with identically functional but convoluted vendor code for
the same actual hardware interface
- submit as new driver

Would someone please tell me wtf is going on here and why if the hardware
is so close to ata_piix it doesn't either use the piix driver or if its
very similar just use bits of it as was (as efar, mpiix and oldpiix do) ?

What if anything actually differs between Intel PIIX and the new RDC
controllers ? Why can't we just cp ata_piix.c ata_rdc.c and just remove
all the intel specific casing ?

Alan
