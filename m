Return-Path: <linux-kernel-owner+w=401wt.eu-S933788AbXLQJA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788AbXLQJA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 04:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757301AbXLQJAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 04:00:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49375 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756480AbXLQJAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 04:00:45 -0500
Date: Mon, 17 Dec 2007 01:00:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: trash can <thetrashcan@earthlink.net>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Iomega ZIP-100 drive unsupported with jmicron JMB361 chip?
Message-Id: <20071217010041.103b4eab.akpm@linux-foundation.org>
In-Reply-To: <475D9D07.6070705@earthlink.net>
References: <475D9D07.6070705@earthlink.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Dec 2007 15:09:43 -0500 trash can <thetrashcan@earthlink.net> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> I have tolerated this problem for a year and do not post to this list in
> haste. I have posted on forums and searched the community over the past
> year.

Your report is welcome - thanks.  Let's cc the IDE/sata development list.

> I have looked at the list archive on gossamer-threads.com for
> solutions. With Fedora Core 6 unsupported (the last kernel for which my
> zip drive worked), it is time for my last attempt at a solution. Please
> CC: any response as I have not joined the list. I have compiled a
> kernel-debug RPM and can run this if its output would help. Thank you
> for any time you might devote to this problem.
> 
> motherboard: MSI P965 Platinum/Intel P965 Express Chipset Based (MS-7238
> series)
> Fedora 8 : kernel 2.6.23.1-42.fc8
> Iomega Zip drive internal Model Z100ATAPI
> 
> lspci
> 03:00.0 SATA controller: JMicron Technologies, Inc. JMB361 AHCI/IDE (rev 02)
> 03:00.1 IDE interface: JMicron Technologies, Inc. JMB361 AHCI/IDE (rev 02)
> 
> # lsmod | grep ata
> pata_jmicron            8257  0
> ata_generic             8901  0
> ata_piix               16709  0
> libata                 99633  4 ahci,pata_jmicron,ata_generic,ata_piix
> scsi_mod              119757  4 sr_mod,sg,libata,sd_mod
> 
> I have recently changed the BIOS setting for the SATA#1 Controller from
> [IDE] to [AHCI] with no effect. I assume AHCI is correct?
> 
> Text below attached as text.txt for readability.
> from dmesg:
> libata version 2.21 loaded.
> device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
> PCI: Enabling device 0000:03:00.1 (0000 -> 0001)
> ACPI: PCI Interrupt 0000:03:00.1[B] -> GSI 17 (level, low) -> IRQ 17
> PCI: Setting latency timer of device 0000:03:00.1 to 64
> scsi0 : pata_jmicron
> scsi1 : pata_jmicron
> ata1: PATA max UDMA/100 cmd 0x0001cc00 ctl 0x0001c882 bmdma 0x0001c400 irq 17
> ata2: PATA max UDMA/100 cmd 0x0001c800 ctl 0x0001c482 bmdma 0x0001c408 irq 17
> ata1.00: ATAPI: LITE-ON DVDRW SOHW-1693S, KS0B, max UDMA/66
> ata1.01: ATAPI: IOMEGA  ZIP 100       ATAPI, 05.H, max MWDMA1, CDB intr
> ata1.00: configured for UDMA/66
> ata1.01: configured for MWDMA1
> scsi 0:0:0:0: CD-ROM            LITE-ON  DVDRW SOHW-1693S KS0B PQ: 0 ANSI: 5
> scsi 0:0:1:0: Direct-Access     IOMEGA   ZIP 100          05.H PQ: 0 ANSI: 5
> sd 0:0:1:0: [sda] 196608 512-byte hardware sectors (101 MB)
> sd 0:0:1:0: [sda] Write Protect is off
> sd 0:0:1:0: [sda] Mode Sense: 00 40 00 00
> sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> sd 0:0:1:0: [sda] 196608 512-byte hardware sectors (101 MB)
> sd 0:0:1:0: [sda] Write Protect is off
> sd 0:0:1:0: [sda] Mode Sense: 00 40 00 00
> sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>  sda:<6>sd 0:0:1:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
> sd 0:0:1:0: [sda] Sense Key : Hardware Error [current]
> sd 0:0:1:0: [sda] Add. Sense: Scsi parity error
> end_request: I/O error, dev sda, sector 0
> Buffer I/O error on device sda, logical block 0
> 
> If a disk is inserted into the drive (/var/log/messages)
> Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] Spinning up disk.....<5>sd 0:0:1:0: [sda] Spinning up disk....ready
> Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] 196608 512-byte hardware sectors (101 MB)
> Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] Write Protect is off
> Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] 196608 512-byte hardware sectors (101 MB)
> Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] Write Protect is off
> Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Dec 10 14:22:53 localhost kernel:  sda:<6>sd 0:0:1:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
> Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] Sense Key : Hardware Error [current]
> Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] Add. Sense: Scsi parity error
> Dec 10 14:22:53 localhost kernel: end_request: I/O error, dev sda, sector 0
> Dec 10 14:22:53 localhost kernel: printk: 42 messages suppressed.
> Dec 10 14:22:53 localhost kernel: Buffer I/O error on device sda, logical block 0
> 

So which is the most recent kernel version which worked OK?
