Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbXHVBnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbXHVBnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 21:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbXHVBnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 21:43:05 -0400
Received: from postin.uv.es ([147.156.1.90]:44521 "EHLO postin.uv.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195AbXHVBnE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 21:43:04 -0400
From: =?iso-8859-15?q?Jos=E9_Luis_Pati=F1o_Andr=E9s?= 
	<jopan@alumni.uv.es>
Organization: Universitat de =?iso-8859-1?q?Val=E8ncia?=
To: Rene Herman <rene.herman@gmail.com>
Subject: Re: Problems with IDE on linux 2.6.22.X
Date: Wed, 22 Aug 2007 03:39:44 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200708212149.12912.jopan@alumni.uv.es> <46CB626F.8020801@gmail.com>
In-Reply-To: <46CB626F.8020801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708220339.45138.jopan@alumni.uv.es>
X-RelayDelay-Mem: Whitelisted relay cuervo.ci.uv.es [147.156.1.157]. Not delayed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Miércoles, 22 de Agosto de 2007 00:08, Rene Herman escribió:

> You have a SATA harddrive (Hitachi Travelstar 5K100 100GB SATA/2.5") and an
> IDE (also known as PATA) DVD drive (LG GMA-4082N). That is, your disk
> should be driven by the:
>
> "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
>
> under the "Serial ATA (prod) and Parallel ATA (experimental) drivers" menu,
> and it seems this driver should also take care of your DVD. Not sure from
> your report what you are using -- first try with only that driver, and
> nothing from the old "ATA/ATAPI/MFM/RLL support" menu selected.
>
> In that situation, your harddrive works, but your DVD does not?

Okay, now it's tested as you said. In fact, in this way with only the SATA 
drivers activated and ATA/ATAPI support completely unselected, my HDD works 
but my DVD not.

And so...

> If so, this should be fixed in the driver, but to get things working I
> believe you may try with both the above driver for your harddisk and the
> old IDE driver for the DVD:
>
> <*>   Enhanced IDE/MFM/RLL disk/cdrom/tape/floppy support
> <*>     Include IDE/ATAPI CDROM support (NEW)
> [*]     PCI IDE chipset support
> [*]     Generic PCI bus-master DMA support
> <*>       Intel PIIXn chipsets support

Checked.

> (do not select IDE/ATA-2 disk support)

Unselected.

Now, I have this kernel panic:
###################
#VFS: cannot open root device "sda3" or unknown-block (0,0)
#Please, append a correct "root=" boot option; here are the available 
#partitions:
#1600 4194302 hdc driver: ide-cdrom
#Kernel panic - not syncing: VFS: Unable to mount root fs on 
#unknown-block(0,0)
###################

> where you may need to boot with a "libata.atapi_enabled=0" kernel
> parameter.

This parameter has no effect. I have the same kernel panic with or without it.

José Luis Patiño.
