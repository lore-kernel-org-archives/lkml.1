Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbXH3LLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbXH3LLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 07:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbXH3LKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 07:10:55 -0400
Received: from mi0.bluebottle.com ([206.188.25.15]:57796 "EHLO
	mi0.bluebottle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbXH3LKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 07:10:54 -0400
DomainKey-Signature: a=rsa-sha1; s=mail; d=bluebottle.com; c=nofws; q=dns;
	h=received:message-id:from:to:subject:date:mime-version:
	content-type:content-transfer-encoding:x-priority:
	x-msmail-priority:x-mailer:x-mimeole:x-trusted-delivery;
	b=BaoxiTKzmYMJ7jwH+AXk9KkQlp1+LHYgoyfZsrelHlp9KLX3jE66TrVkAUZMMUzMz
	5G5aye5544NgrW+F/a2f2/8hXBA3+neMqykMUGVqyhpCZovKuzv8f0JWJ2YA2gi
Message-ID: <007d01c7eaf6$74b9b350$0100a8c0@hak>
From: "n" <xellos@bluebottle.com>
To: <linux-kernel@vger.kernel.org>
Subject: limiting to UDMA/33 instead of UDMA/100 - pata_pdc202xx_old (also XFS error)?
Date: Thu, 30 Aug 2007 04:11:03 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="Windows-1252";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Trusted-Delivery: <7efbb97aca25f9048da528e7838faa77>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hello, with kernel 2.6.22.5 using the new pata_pdc202xx_old  driver it doesn 
detect the cable right on this seagate drive (i tried switching ports / 
cables ...etc)

it detects the maxtor drive fine no matter what port its on, the seagate 
doesnt detect correctly on either port

ata1.00: ATA-6: ST3120026A, 3.06, max UDMA/100
ata1.00: 234441648 sectors, multi 16: LBA48
ata1.00: limited to UDMA/33 due to 40-wire cable
ata1.00: configured for UDMA/33
ata2.00: ATA-7: Maxtor 6B200R0, max UDMA/133
ata2.00: 398297088 sectors, multi 16: LBA48
ata2.00: configured for UDMA/100


i was searching goolge and i found other uses with the same problem and had 
seagate drives (maybe the cable detect code is differnt in seagate?)


btw only devices sda and sdb are on the pata_pdc202xx_old card.
sdc-g are on the new via driver.

i also get this error about 50 of them
(dmsg cut top output where it had info about the cable error) anyways if you 
scroll down you will see errors like this
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x4)
ata1.00: cmd ca/00:01:3f:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 512 out
         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
ata1: soft resetting port
ata1.00: configured for UDMA/33
ata1: EH complete ..etc

.... Ends up here

ata1: EH complete
ata1.00: limiting speed to PIO4
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x4)
ata1.00: cmd ca/00:00:21:9d:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072 
out
         res 51/84:00:21:9d:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
ata1: soft resetting port
ata1.00: configured for PIO4           <- pio4 so is it even going lower?
ata1: EH complete

here is most of output from dmsg


sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
 sdb: sdb1
sd 1:0:0:0: [sdb] Attached SCSI disk
pata_via 0000:00:04.1: version 0.3.1
scsi2 : pata_via
scsi3 : pata_via
ata3: PATA max UDMA/66 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001d800 irq 14
ata4: PATA max UDMA/66 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001d808 irq 15
ata3.00: ATA-6: Maxtor 5T040H4, TAH71DP0, max UDMA/100
ata3.00: 80043264 sectors, multi 16: LBA
ata3.01: ATA-6: WDC WD800BB-55JKC0, 05.01C05, max UDMA/100
ata3.01: 156301488 sectors, multi 16: LBA
ata3.00: configured for UDMA/66
ata3.01: configured for UDMA/66
ata4.00: ATA-5: MAXTOR 4K080H4, A08.1500, max UDMA/100
ata4.00: 156301488 sectors, multi 16: LBA
ata4.01: ATA-7: Maxtor 6Y120L0, YAR41VW0, max UDMA/133
ata4.01: 240121728 sectors, multi 16: LBA
ata4.00: configured for UDMA/66
ata4.01: configured for UDMA/66
scsi 2:0:0:0: Direct-Access     ATA      Maxtor 5T040H4   TAH7 PQ: 0 ANSI: 5
sd 2:0:0:0: [sdc] 80043264 512-byte hardware sectors (40982 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sd 2:0:0:0: [sdc] 80043264 512-byte hardware sectors (40982 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
 sdc: sdc1 sdc2 sdc3 sdc4
sd 2:0:0:0: [sdc] Attached SCSI disk
scsi 2:0:1:0: Direct-Access     ATA      WDC WD800BB-55JK 05.0 PQ: 0 ANSI: 5
sd 2:0:1:0: [sdd] 156301488 512-byte hardware sectors (80026 MB)
sd 2:0:1:0: [sdd] Write Protect is off
sd 2:0:1:0: [sdd] Mode Sense: 00 3a 00 00
sd 2:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sd 2:0:1:0: [sdd] 156301488 512-byte hardware sectors (80026 MB)
sd 2:0:1:0: [sdd] Write Protect is off
sd 2:0:1:0: [sdd] Mode Sense: 00 3a 00 00
sd 2:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
 sdd: sdd1
sd 2:0:1:0: [sdd] Attached SCSI disk
scsi 3:0:0:0: Direct-Access     ATA      MAXTOR 4K080H4   A08. PQ: 0 ANSI: 5
sd 3:0:0:0: [sde] 156301488 512-byte hardware sectors (80026 MB)
sd 3:0:0:0: [sde] Write Protect is off
sd 3:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sd 3:0:0:0: [sde] 156301488 512-byte hardware sectors (80026 MB)
sd 3:0:0:0: [sde] Write Protect is off
sd 3:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
 sde: sde1
sd 3:0:0:0: [sde] Attached SCSI disk
scsi 3:0:1:0: Direct-Access     ATA      Maxtor 6Y120L0   YAR4 PQ: 0 ANSI: 5
sd 3:0:1:0: [sdf] 240121728 512-byte hardware sectors (122942 MB)
sd 3:0:1:0: [sdf] Write Protect is off
sd 3:0:1:0: [sdf] Mode Sense: 00 3a 00 00
sd 3:0:1:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sd 3:0:1:0: [sdf] 240121728 512-byte hardware sectors (122942 MB)
sd 3:0:1:0: [sdf] Write Protect is off
sd 3:0:1:0: [sdf] Mode Sense: 00 3a 00 00
sd 3:0:1:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
 sdf: sdf1
sd 3:0:1:0: [sdf] Attached SCSI disk
usbmon: debugfs is not available
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:04.2[D] -> Link [LNKC] -> GSI 11 (level, low) -> 
IRQ 11
uhci_hcd 0000:00:04.2: UHCI Host Controller
uhci_hcd 0000:00:04.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:04.2: irq 11, io base 0x0000d400
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:04.3[D] -> Link [LNKC] -> GSI 11 (level, low) -> 
IRQ 11
uhci_hcd 0000:00:04.3: UHCI Host Controller
uhci_hcd 0000:00:04.3: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:04.3: irq 11, io base 0x0000d000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: 
dm-devel@redhat.com
input: AT Translated Set 2 keyboard as /class/input/input2
usb 1-1: new low speed USB device using uhci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
usb 1-2: new low speed USB device using uhci_hcd and address 3
usb 1-2: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
hiddev96: USB HID v1.10 Device [CPS UPS AE550] on usb-0000:00:04.2-1
input: Logitech USB Receiver as /class/input/input3
input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:04.2-2
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.14 (Thu May 31 09:03:25 
2007 UTC).
ACPI: PCI Interrupt 0000:00:04.5[C] -> Link [LNKB] -> GSI 10 (level, low) -> 
IRQ 10
PCI: Setting latency timer of device 0000:00:04.5 to 64
ALSA device list:
  #0: VIA 82C686A/B rev20 with AD1881A at 0xb800, irq 10
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
XFS mounting filesystem sdc2
Ending clean XFS mount for filesystem: sdc2
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 224k freed
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKD] -> GSI 5 (level, low) -> 
IRQ 5
eth0: RealTek RTL8139 at 0x8800, 00:40:05:3a:15:c4, IRQ 5
eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
ACPI: PCI Interrupt 0000:00:0f.0[A] -> Link [LNKC] -> GSI 11 (level, low) -> 
IRQ 11
eth1: RTL8169sb/8110sb at 0xe882c000, 00:14:d1:38:5e:25, IRQ 11
parport_pc: VIA 686A/8231 detected
parport_pc: probing current configuration
parport_pc: Current parallel port base: 0x378
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
parport_pc: VIA parallel port: io=0x378, irq=7
via686a 0000:00:04.4: base address not set - upgrade BIOS or use 
force_addr=0xaddr
Adding 390560k swap on /dev/sdc1.  Priority:-1 extents:1 across:390560k
XFS mounting filesystem sdc3
Ending clean XFS mount for filesystem: sdc3
XFS mounting filesystem sdc4
Ending clean XFS mount for filesystem: sdc4
XFS mounting filesystem sdd1
Ending clean XFS mount for filesystem: sdd1
XFS mounting filesystem sde1
Ending clean XFS mount for filesystem: sde1
XFS mounting filesystem sdf1
Ending clean XFS mount for filesystem: sdf1
XFS mounting filesystem sdb1
Ending clean XFS mount for filesystem: sdb1
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x4)
ata1.00: cmd ca/00:01:3f:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 512 out
         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
ata1: soft resetting port
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x4)
ata1.00: cmd ca/00:01:3f:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 512 out
         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
ata1: soft resetting port
ata1.00: configured for UDMA/33
ata1: EH complete
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x4)
ata1.00: cmd ca/00:01:3f:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 512 out
         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
ata1: soft resetting port
ata1.00: configured for UDMA/33
ata1: EH complete
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
ata1.00: limiting speed to UDMA/25:PIO4
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x4)
ata1.00: cmd ca/00:01:3f:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 512 out
         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
ata1: soft resetting port
ata1.00: configured for UDMA/25
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x4)
ata1.00: cmd ca/00:01:3f:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 512 out
         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
ata1: soft resetting port
ata1.00: configured for UDMA/25
ata1: EH complete
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x4)
ata1.00: cmd ca/00:01:3f:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 512 out
         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
ata1: soft resetting port
ata1.00: configured for UDMA/25
sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
sd 0:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 47 00 00 00 00 0c 00 0a 80 00 00 00 00 00
        00 00 00 3f
sd 0:0:0:0: [sda] ASC=0x47 ASCQ=0x0
end_request: I/O error, dev sda, sector 63
ata1: EH complete
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
Filesystem "sda1": Disabling barriers, trial barrier write failed
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
XFS mounting filesystem sda1
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x4)
ata1.00: cmd ca/00:00:21:9c:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072 
out
         res 51/84:00:21:9c:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
ata1: soft resetting port
ata1.00: configured for UDMA/25
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x4)
ata1.00: cmd ca/00:00:21:9c:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072 
out
         res 51/84:00:21:9c:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
ata1: soft resetting port
ata1.00: configured for UDMA/25
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x4)
ata1.00: cmd ca/00:00:21:9c:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072 
out
         res 51/84:00:21:9c:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
ata1: soft resetting port
ata1.00: configured for UDMA/25
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x4)
ata1.00: cmd ca/00:00:21:9c:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072 
out
         res 51/84:00:21:9c:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
ata1: soft resetting port
ata1.00: configured for UDMA/25
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x4)
ata1.00: cmd ca/00:00:21:9c:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072 
out
         res 51/84:00:21:9c:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
ata1: soft resetting port
ata1.00: configured for UDMA/25
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x4)
ata1.00: cmd ca/00:00:21:9c:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072 
out
         res 51/84:00:21:9c:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
ata1: soft resetting port
ata1.00: configured for UDMA/25
sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
sd 0:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 47 00 00 00 00 0c 00 0a 80 00 00 00 00 00
        06 fc 9c 21
sd 0:0:0:0: [sda] ASC=0x47 ASCQ=0x0
end_request: I/O error, dev sda, sector 117218337
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x4)
ata1.00: cmd ca/00:00:21:9d:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072 
out
         res 51/84:00:21:9d:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
ata1: soft resetting port
ata1.00: configured for UDMA/25
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x4)
ata1.00: cmd ca/00:00:21:9d:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072 
out
         res 51/84:00:21:9d:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
ata1: soft resetting port
ata1.00: configured for UDMA/25
ata1: EH complete
ata1.00: limiting speed to PIO4
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata1.00: (BMDMA stat 0x4)
ata1.00: cmd ca/00:00:21:9d:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072 
out
         res 51/84:00:21:9d:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
ata1: soft resetting port
ata1.00: configured for PIO4
ata1: EH complete
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
xfs_force_shutdown(sda1,0x1) called from line 423 of file fs/xfs/xfs_rw.c. 
Return address = 0xc020cea8
Filesystem "sda1": I/O Error Detected.  Shutting down filesystem: sda1
Please umount the filesystem, and rectify the problem(s)
I/O error in filesystem ("sda1") meta-data dev sda1 block 0x6fc9be2 
("xlog_bwrite") error 5 buf count 262144
XFS: failed to locate log tail
XFS: log mount/recovery failed: error 5
XFS: log mount failed
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA

after the kernel finnishes booting i can mount that drive fine (also all the 
xfs_check xfs_repair ..etc say there is no errors)

anyidea whats going on? the ide old driver seemed to work ok with this 
drive.
i tried changing the drive jumpers around and that also didnt help

----------------------------------------------------------------------
Finally - A spam blocker that actually works.
http://www.bluebottle.com/tag/4

