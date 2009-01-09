Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbZAIPBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbZAIPBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 10:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbZAIPBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 10:01:31 -0500
Received: from nn7.de ([85.214.94.156]:49777 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbZAIPBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 10:01:31 -0500
Subject: Do ICH10+AHCI-driver support port-multiplying on a eSATA port?
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux-ide <linux-ide@vger.kernel.org>
Cc: Tejun Heo <htejun@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 09 Jan 2009 16:01:27 +0100
Message-Id: <1231513287.2631.68.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I am trying to connect an external 2-disk case (eCube II  see
http://www.one-tech.com/EN/htm_ecube.htm) to an ICH10 skyburg dp45sg
board via eSATA. As the case requires a port-multiplying sata card, I am
wondering if ich10+ahci support it?

At least with 2.6.27.10 I am seeing only one drive. Connecting the case
via usb gives two (dmesg parts below).

So is port multiplying not yet available for ahci or not at all or does
the the ich10 not support it and I should rather try a sil 3132 or so?

Thanks,
Soeren

ata4: exception Emask 0x10 SAct 0x0 SErr 0x4050000 action 0xe frozen
ata4: irq_stat 0x00000040, connection status changed
ata4: SError: { PHYRdyChg CommWake DevExch }
ata4: hard resetting link
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-7: ST3400832AS, 3.01, max UDMA/133
ata4.00: 781422768 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata4.00: configured for UDMA/133
ata4: EH complete
scsi 3:0:0:0: Direct-Access     ATA      ST3400832AS      3.01 PQ: 0 ANSI: 5
sd 3:0:0:0: [sde] 781422768 512-byte hardware sectors (400088 MB)
sd 3:0:0:0: [sde] Write Protect is off
sd 3:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sde] 781422768 512-byte hardware sectors (400088 MB)
sd 3:0:0:0: [sde] Write Protect is off
sd 3:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sde: unknown partition table
sd 3:0:0:0: [sde] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg5 type 0
ata4: exception Emask 0x50 SAct 0x0 SErr 0x4490801 action 0xe frozen
ata4: irq_stat 0x00400040, connection status changed
ata4: SError: { RecovData HostInt PHYRdyChg 10B8B Handshk DevExch }
ata4: hard resetting link
ata4: SATA link down (SStatus 0 SControl 300)
ata4: hard resetting link
ata4: SATA link down (SStatus 0 SControl 300)
ata4: hard resetting link
ata4: SATA link down (SStatus 0 SControl 300)
ata4.00: disabled
ata4: EH complete
ata4.00: detaching (SCSI 3:0:0:0)
sd 3:0:0:0: [sde] Synchronizing SCSI cache
sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
sd 3:0:0:0: [sde] Stopping disk
sd 3:0:0:0: [sde] START_STOP FAILED
sd 3:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
usb 1-4: new high speed USB device using ehci_hcd and address 6
usb 1-4: configuration #1 chosen from 1 choice
scsi7 : SCSI emulation for USB Mass Storage devices
usb 1-4: New USB device found, idVendor=1a4a, idProduct=1670
usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-4: Product: 5744 FW:1.1516
usb 1-4: Manufacturer: Silicon Image, Inc
usb 1-4: SerialNumber: 9999999999999999999
usb-storage: device found at 6
usb-storage: waiting for device to settle before scanning
scsi 7:0:0:0: Direct-Access     ST340083             3NF0      PQ: 0 ANSI: 2
sd 7:0:0:0: [sde] 781422769 512-byte hardware sectors (400088 MB)
sd 7:0:0:0: [sde] Write Protect is off
sd 7:0:0:0: [sde] Mode Sense: 1a 0c 00 00
sd 7:0:0:0: [sde] Assuming drive cache: write through
sd 7:0:0:0: [sde] 781422769 512-byte hardware sectors (400088 MB)
sd 7:0:0:0: [sde] Write Protect is off
sd 7:0:0:0: [sde] Mode Sense: 1a 0c 00 00
sd 7:0:0:0: [sde] Assuming drive cache: write through
 sde: unknown partition table
sd 7:0:0:0: [sde] Attached SCSI disk
sd 7:0:0:0: Attached scsi generic sg5 type 0
scsi 7:0:0:1: Direct-Access     ST340062             5QG0      PQ: 0 ANSI: 2
sd 7:0:0:1: [sdf] 781422769 512-byte hardware sectors (400088 MB)
sd 7:0:0:1: [sdf] Write Protect is off
sd 7:0:0:1: [sdf] Mode Sense: 1a 0c 00 00
sd 7:0:0:1: [sdf] Assuming drive cache: write through
sd 7:0:0:1: [sdf] 781422769 512-byte hardware sectors (400088 MB)
sd 7:0:0:1: [sdf] Write Protect is off
sd 7:0:0:1: [sdf] Mode Sense: 1a 0c 00 00
sd 7:0:0:1: [sdf] Assuming drive cache: write through
 sdf: unknown partition table
sd 7:0:0:1: [sdf] Attached SCSI disk
sd 7:0:0:1: Attached scsi generic sg6 type 0

