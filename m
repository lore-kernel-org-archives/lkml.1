Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbYGaEbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbYGaEbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 00:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbYGaEbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 00:31:32 -0400
Received: from 215.47.DSNET ([211.144.215.47]:54754 "EHLO
	cnshjsmin03.cn.alcatel-lucent.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750841AbYGaEbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 00:31:31 -0400
X-AuditID: ac189297-ada00bb000003fd3-ef-48914ce5c114
Message-ID: <48913FFD.5070901@alcatel-lucent.com>
Date: Thu, 31 Jul 2008 12:30:53 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: PIIX4: DMA timeout issue
References: <488ED837.2060509@alcatel-lucent.com>	<488F1C6C.9000002@garzik.org>	<48902EB5.8070102@alcatel-lucent.com> <20080730114934.5a593cf4@lxorguk.ukuu.org.uk>
In-Reply-To: <20080730114934.5a593cf4@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 31 Jul 2008 04:30:44.0823 (UTC) FILETIME=[32B50670:01C8F2C6]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Another question is my PIIX4 chip has device ID + vendor ID of 
>> 0x71108086. But it finally
>> was mapped to following ID of piix_pci_tbl[] array. Device of 0x7110 and 
>> 0x7010 should
>> be quit different, right?
>>     
>
> Yes - I find tht one very odd - you might need to debug a bit to see what
> is occuring if you think this is the case.
>
> Alan
>   
Alan/Jeff, I tried to install ATA driver on PIIX4. After fixing IRQ number
to 143 for primary and secondary channel. I got following output and
it seems the driver has been loaded sucessfully. However, I couldn't
see any information from /proc/devices. Do you have any ideas?

piix_init: enter
piix_init_one: pci device: �[eh
piix_init_one: vendor=0x00008086, device=0x00007111
piix_init_one: piix_host_priv allocated
piix_init_one: ent->driver_data=0
ata_pci_init_one: n_ports=2
ata_pci_init_one: pci device enabled
ata_pci_init_one: pci device class=0x00010180
ata_pci_init_one: legacy_mode=8
ata_pci_init_one: DMA mode has been set
ata_pci_init_legacy_port: port_mask=0x0000000b
ata_pci_init_legacy_port: ATA_PRIMARY_CMD=0x000001f0, 
ATA_PRIMARY_CTL=0x000003f6
ata_pci_init_legacy_port: ATA_SECONDARY_CMD=0x00000170, 
ATA_SECONDARY_CTL=0x00000376
ata_pci_init_legacy_port: BMDMA=0xfbf00000
, phys=0x00001000, phys_end=0x0000100f
ata_pci_init_legacy_port: probe_ent initialized
ata_pci_init_legacy_port: IRQ line of primary channel is 143
ata_pci_init_legacy_port: IRQ line of secondary channel is 143
ata_pci_init_one: Master set
ata1: PATA max UDMA/33 cmd 0xfbeff1f0 ctl 0xfbeff3f6 bmdma 0xfbf00000 
irq 143
ata2: PATA max UDMA/33 cmd 0xfbeff170 ctl 0xfbeff376 bmdma 0xfbf00008 
irq 143
scsi0 : ata_piix
scsi1 : ata_piix
ata2.00: ATA-6: HTE721010G9AT00, MCZOA51A, max UDMA/100
ata2.00: 195371568 sectors, multi 0: LBA48
ata2.00: configured for UDMA/33
1:0:0:0: Direct-Access ATA HTE721010G9AT00 MCZO PQ: 0 ANSI: 5

/ $ cat /proc/devices
Character devices:
1 mem
2 pty
3 ttyp
4 /dev/vc/0
4 tty
5 /dev/tty
5 /dev/console
5 /dev/ptmx
7 vcs
10 misc
13 input
90 mtd
128 ptm
136 pts
204 ttyMM
205 ttyVC
206 ttySC
253 telica_sysinfo
254 mlba

Block devices:
1 ramdisk
7 loop
31 mtdblock

Gavin


