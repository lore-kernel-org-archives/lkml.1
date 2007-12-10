Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbXLJULd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbXLJULd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 15:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbXLJUL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 15:11:26 -0500
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:34359 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753399AbXLJULZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 15:11:25 -0500
Message-ID: <475D9D07.6070705@earthlink.net>
Date: Mon, 10 Dec 2007 15:09:43 -0500
From: trash can <thetrashcan@earthlink.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Iomega ZIP-100 drive unsupported with jmicron JMB361 chip?
X-Enigmail-Version: 0.95.5
Content-Type: multipart/mixed;
 boundary="------------080509090104000906000601"
X-ELNK-Trace: 0eb48aa9e2d02e93d780f4a490ca69563f9fea00a6dd62bcc2998c5da909b5a0ff2633891b83d0f8350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 66.32.114.165
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080509090104000906000601
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I have tolerated this problem for a year and do not post to this list in
haste. I have posted on forums and searched the community over the past
year. I have looked at the list archive on gossamer-threads.com for
solutions. With Fedora Core 6 unsupported (the last kernel for which my
zip drive worked), it is time for my last attempt at a solution. Please
CC: any response as I have not joined the list. I have compiled a
kernel-debug RPM and can run this if its output would help. Thank you
for any time you might devote to this problem.

motherboard: MSI P965 Platinum/Intel P965 Express Chipset Based (MS-7238
series)
Fedora 8 : kernel 2.6.23.1-42.fc8
Iomega Zip drive internal Model Z100ATAPI

lspci
03:00.0 SATA controller: JMicron Technologies, Inc. JMB361 AHCI/IDE (rev 02)
03:00.1 IDE interface: JMicron Technologies, Inc. JMB361 AHCI/IDE (rev 02)

# lsmod | grep ata
pata_jmicron            8257  0
ata_generic             8901  0
ata_piix               16709  0
libata                 99633  4 ahci,pata_jmicron,ata_generic,ata_piix
scsi_mod              119757  4 sr_mod,sg,libata,sd_mod

I have recently changed the BIOS setting for the SATA#1 Controller from
[IDE] to [AHCI] with no effect. I assume AHCI is correct?

Text below attached as text.txt for readability.
from dmesg:
libata version 2.21 loaded.
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
PCI: Enabling device 0000:03:00.1 (0000 -> 0001)
ACPI: PCI Interrupt 0000:03:00.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:03:00.1 to 64
scsi0 : pata_jmicron
scsi1 : pata_jmicron
ata1: PATA max UDMA/100 cmd 0x0001cc00 ctl 0x0001c882 bmdma 0x0001c400 irq 17
ata2: PATA max UDMA/100 cmd 0x0001c800 ctl 0x0001c482 bmdma 0x0001c408 irq 17
ata1.00: ATAPI: LITE-ON DVDRW SOHW-1693S, KS0B, max UDMA/66
ata1.01: ATAPI: IOMEGA  ZIP 100       ATAPI, 05.H, max MWDMA1, CDB intr
ata1.00: configured for UDMA/66
ata1.01: configured for MWDMA1
scsi 0:0:0:0: CD-ROM            LITE-ON  DVDRW SOHW-1693S KS0B PQ: 0 ANSI: 5
scsi 0:0:1:0: Direct-Access     IOMEGA   ZIP 100          05.H PQ: 0 ANSI: 5
sd 0:0:1:0: [sda] 196608 512-byte hardware sectors (101 MB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Mode Sense: 00 40 00 00
sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:1:0: [sda] 196608 512-byte hardware sectors (101 MB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Mode Sense: 00 40 00 00
sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:<6>sd 0:0:1:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 0:0:1:0: [sda] Sense Key : Hardware Error [current]
sd 0:0:1:0: [sda] Add. Sense: Scsi parity error
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0

If a disk is inserted into the drive (/var/log/messages)
Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] Spinning up disk.....<5>sd 0:0:1:0: [sda] Spinning up disk....ready
Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] 196608 512-byte hardware sectors (101 MB)
Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] Write Protect is off
Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] 196608 512-byte hardware sectors (101 MB)
Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] Write Protect is off
Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec 10 14:22:53 localhost kernel:  sda:<6>sd 0:0:1:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] Sense Key : Hardware Error [current]
Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] Add. Sense: Scsi parity error
Dec 10 14:22:53 localhost kernel: end_request: I/O error, dev sda, sector 0
Dec 10 14:22:53 localhost kernel: printk: 42 messages suppressed.
Dec 10 14:22:53 localhost kernel: Buffer I/O error on device sda, logical block 0

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFHXZ0Hz1/aqdDsM3URAs0UAJ0TUthyDtWaoSIHrbaIc43v/6yj+ACgkMyx
fC3xUrTkYyojPOV7YBSqLSY=
=0eW3
-----END PGP SIGNATURE-----

--------------080509090104000906000601
Content-Type: text/plain;
 name="text.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="text.txt"

from dmesg:
libata version 2.21 loaded.
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
PCI: Enabling device 0000:03:00.1 (0000 -> 0001)
ACPI: PCI Interrupt 0000:03:00.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:03:00.1 to 64
scsi0 : pata_jmicron
scsi1 : pata_jmicron
ata1: PATA max UDMA/100 cmd 0x0001cc00 ctl 0x0001c882 bmdma 0x0001c400 irq 17
ata2: PATA max UDMA/100 cmd 0x0001c800 ctl 0x0001c482 bmdma 0x0001c408 irq 17
ata1.00: ATAPI: LITE-ON DVDRW SOHW-1693S, KS0B, max UDMA/66
ata1.01: ATAPI: IOMEGA  ZIP 100       ATAPI, 05.H, max MWDMA1, CDB intr
ata1.00: configured for UDMA/66
ata1.01: configured for MWDMA1
scsi 0:0:0:0: CD-ROM            LITE-ON  DVDRW SOHW-1693S KS0B PQ: 0 ANSI: 5
scsi 0:0:1:0: Direct-Access     IOMEGA   ZIP 100          05.H PQ: 0 ANSI: 5
sd 0:0:1:0: [sda] 196608 512-byte hardware sectors (101 MB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Mode Sense: 00 40 00 00
sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:1:0: [sda] 196608 512-byte hardware sectors (101 MB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Mode Sense: 00 40 00 00
sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:<6>sd 0:0:1:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 0:0:1:0: [sda] Sense Key : Hardware Error [current]
sd 0:0:1:0: [sda] Add. Sense: Scsi parity error
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0

If a disk is inserted into the drive (/var/log/messages)
Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] Spinning up disk.....<5>sd 0:0:1:0: [sda] Spinning up disk....ready
Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] 196608 512-byte hardware sectors (101 MB)
Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] Write Protect is off
Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] 196608 512-byte hardware sectors (101 MB)
Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] Write Protect is off
Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec 10 14:22:53 localhost kernel:  sda:<6>sd 0:0:1:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] Sense Key : Hardware Error [current]
Dec 10 14:22:53 localhost kernel: sd 0:0:1:0: [sda] Add. Sense: Scsi parity error
Dec 10 14:22:53 localhost kernel: end_request: I/O error, dev sda, sector 0
Dec 10 14:22:53 localhost kernel: printk: 42 messages suppressed.
Dec 10 14:22:53 localhost kernel: Buffer I/O error on device sda, logical block 0

--------------080509090104000906000601--
