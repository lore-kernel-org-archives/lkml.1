Return-Path: <linux-kernel-owner+w=401wt.eu-S1764030AbXGTODx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764030AbXGTODx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 10:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757264AbXGTODr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 10:03:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:50836 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250AbXGTODq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 10:03:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=n8zCVs2Srukar58PRFPGd3S2LUf22SZCe6OmKE/IvBbvfPBj1yHxNRSCkafOrLsU7DRZd/avJhsdHiyWpL0cDHHU60TlZV/qenqQSSb3mfUAvnnc7fbyV0vCuLzuuGRzS2iomXTxrIb3ecOncvkgp+TF/Nwyy+z+y2EZQnP4dX8=
Message-ID: <46A0C059.8090506@googlemail.com>
Date: Fri, 20 Jul 2007 16:02:01 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Felipe Contreras <felipe.contreras@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: ata_piix broken in 2.6.22
References: <94a0d4530707200626r2b50146bs55e268033ceab4b0@mail.gmail.com> <20070720143510.6ce81c09@the-village.bc.nu>
In-Reply-To: <20070720143510.6ce81c09@the-village.bc.nu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> O> ata_piix 0000:00:1f.2: version 2.11
>> ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
>> ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 16 (level, low) -> IRQ 16
>> ata_piix 0000:00:1f.2: 0x1F0 IDE port busy
>> ata_piix 0000:00:1f.2: 0x170 IDE port busy
>> ata_piix 0000:00:1f.2: no available legacy port
> 
> You appear to have old IDE compiled in as well and finding the device
> first

Alan ,

But this is allowed now and for me, after removing CONFIG_SATA_INTEL_COMBINED option
some other options combos may be illegal and removing it broke a lot working setups.

On <2.6.22 you got on your SATA/PATA controller with CONFIG_IDE=y , ATA=y ( ATA_X=y and even BLK_DEV_X=y) the

SATA disk as SATA and PATA one as IDE now you get the SATA disk as 'IDE' too which gives you almost 3-4MB/s speed.

Is such a config legall for you for an SATA/IDE combo controller in >=2.6.22 ?

CONFIG_BLK_DEV_IDE_SATA=n
CONFIG_IDE=y
ATA=y
BLK_DEV_PIIX=y(or m doesn't matter )
ATA_PIIX=y

IMO after removing CONFIG_SATA_INTEL_COMBINED you guys introduced an real conflict with the IDE subsystem.

The only way to get libata working with such a config is to boot ideX=noprobe.


Regards,

Gabriel
