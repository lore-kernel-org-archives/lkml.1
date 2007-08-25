Return-Path: <linux-kernel-owner+w=401wt.eu-S933541AbXHYIpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541AbXHYIpF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 04:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761482AbXHYIox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 04:44:53 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:27243 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759941AbXHYIov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 04:44:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=uX1/U2LS16aniP1Rzafm4Yb2Mj2ojxiB5Z+4xbwCwvIEnXVZVYP9z080Df47IVa9p8ETuJinW52RdZYw4GilxNGD6jn6HgMscTq8KESNuLkRS8Fb34v9YYqu/cNOYkED35f2pLLJscuHBm2V4S2AA7npBRzez3EehLaQXqx77Ww=
Message-ID: <46CFEC40.7060006@gmail.com>
Date: Sat, 25 Aug 2007 10:45:52 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       linux-ide@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Jeff Garzik <jgarzik@pobox.com>
Subject: readXs on pci*iomap-ped regions [Was: [PATCH] /drivers/char sx.c
 ioremap -> pci_ioremap api]
References: <46CF2849.2090008@gmail.com>	<4af2d03a0708241159v56b46299h46df9777a98590e5@mail.gmail.com>	<20070824201530.5d741b37@the-village.bc.nu>	<46CF399E.3010808@gmail.com> <20070824213439.0007e653@the-village.bc.nu>
In-Reply-To: <20070824213439.0007e653@the-village.bc.nu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox napsal(a):
>>>>> +	rebase = pci_iomap(pdev, 0, 0x80);
>>>>>   	t = readl(rebase + CNTRL_REG_OFFSET);
>>> Switch to ioread* if you are using the iomap interface. Its not a trivial
>> Why, if you know it's surely a mem region (and thus you rely on it and do
>> ioremap)? There are many places in the kernel, where this approach is used, e.g.
>> libata piix.
> 
> Every single one of them is wrong. The encoding of iomap values is
> platform dependant. Fixed in my tree.

OK, fast search found these suspicious (not considering e.g. arch/):
$ find drivers/ -name '*.c' -exec grep -q pci.*iomap {} \; -a -exec grep -l
'\<readl\>' {} \+
drivers/firewire/fw-ohci.c
drivers/scsi/sym53c8xx_2/sym_glue.c
drivers/media/dvb/pluto2/pluto2.c
drivers/media/dvb/b2c2/flexcop-pci.c
drivers/ssb/scan.c
drivers/char/cyclades.c
drivers/char/sx.c
drivers/ata/ata_piix.c
drivers/ata/sata_inic162x.c
drivers/ata/pata_pdc2027x.c
drivers/ata/sata_sx4.c
drivers/ata/sata_qstor.c
drivers/ata/sata_mv.c
drivers/ata/sata_svw.c
drivers/ata/sata_nv.c
drivers/ata/sata_sil.c
drivers/ata/sata_vsc.c
drivers/ata/sata_promise.c
drivers/ata/ahci.c
drivers/ata/sata_sil24.c
drivers/net/cassini.c
drivers/mtd/nand/cafe_nand.c

How do you imagine a proper fix?
- move to ioreadX/iowriteX
or
- move back to ioremap (unlikely for the most)
or?

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
