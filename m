Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab0BLXTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 18:19:15 -0500
Received: from lnx500.hrz.tu-darmstadt.de ([130.83.156.225]:45486 "EHLO
	lnx500.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754561Ab0BLXTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 18:19:13 -0500
From: ST <st@iss.tu-darmstadt.de>
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: 2.6.33-rc7 problems
Date: Sat, 13 Feb 2010 00:18:42 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-00025-g08c4f1b; KDE/4.3.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201002092306.07449.st@iss.tu-darmstadt.de> <201002112354.51990.st@iss.tu-darmstadt.de> <51f3faa71002111749k403df397j8b3c924ad9cf633e@mail.gmail.com>
In-Reply-To: <51f3faa71002111749k403df397j8b3c924ad9cf633e@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201002130018.42576.st@iss.tu-darmstadt.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-PMX-TU: seen v0.99a by 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.2.12.230046
X-PMX-SPAMCHECK: outgoing mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert
> Can you post
> the full dmesg from 2.6.32 when connecting the drive? 
The dmesg when connecting the drive is attached. This is
from a Fedora 12 installation. Hopefully this is enough?

Mh, it seems as if the following lines are missing in the failing case?:
Initializing USB Mass Storage driver...
scsi8 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 6
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device scan complete

Is there probably a wrong driver bound to the wrong driver?
(Didn't find anything suspicious under /sysfs)
Why is "usb_stor_init" not called?

I just tried to get a working kernel by using "make localyesconfig"
under fedora. But it still only detects the the SD card... 

Thank you very much for your help.
ST

The Fedora 12 installation with 2.6.31.5-127.fc12.x86_64:
udev: starting version 145
usb 1-4.3: new high speed USB device using ehci_hcd and address 6
usb 1-4.3: New USB device found, idVendor=058f, idProduct=6364
usb 1-4.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-4.3: Product: Mass Storage Device
usb 1-4.3: Manufacturer: Generic
usb 1-4.3: SerialNumber: 058F63646476
usb 1-4.3: configuration #1 chosen from 1 choice
generic-usb: probe of 0003:058F:6364.0003 failed with error -22
Initializing USB Mass Storage driver...
scsi8 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 6
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device scan complete
scsi 8:0:0:0: Direct-Access     Generic- SD/MMC           1.00 PQ: 0 ANSI: 0
scsi 8:0:0:1: Direct-Access     Generic- Compact Flash    1.01 PQ: 0 ANSI: 0
scsi 8:0:0:2: Direct-Access     Generic- SM/xD-Picture    1.02 PQ: 0 ANSI: 0
scsi 8:0:0:3: Direct-Access     Generic- MS/MS-Pro        1.03 PQ: 0 ANSI: 0 
CCS
sd 8:0:0:0: Attached scsi generic sg3 type 0
sd 8:0:0:1: Attached scsi generic sg4 type 0
sd 8:0:0:2: Attached scsi generic sg5 type 0
sd 8:0:0:3: Attached scsi generic sg6 type 0
sd 8:0:0:2: [sde] Attached SCSI removable disk
sd 8:0:0:0: [sdc] Attached SCSI removable disk
sd 8:0:0:3: [sdf] Attached SCSI removable disk
sd 8:0:0:1: [sdd] 15858864 512-byte logical blocks: (8.11 GB/7.56 GiB)
sd 8:0:0:1: [sdd] Write Protect is off
sd 8:0:0:1: [sdd] Mode Sense: 03 00 00 00
sd 8:0:0:1: [sdd] Assuming drive cache: write through
sd 8:0:0:1: [sdd] Assuming drive cache: write through
 sdd: sdd1 sdd2
sd 8:0:0:1: [sdd] Assuming drive cache: write through
sd 8:0:0:1: [sdd] Attached SCSI removable disk


The failure without usb block debug output:
hub 1-4:1.0: state 7 ports 4 chg 0000 evt 0008
hub 1-4:1.0: port 3, status 0101, change 0001, 12 Mb/s
hub 1-4:1.0: debounce: port 3: total 100ms stable 100ms status 0x101
hub 1-4:1.0: port 3 not reset yet, waiting 10ms
usb 1-4.3: new high speed USB device using ehci_hcd and address 6
hub 1-4:1.0: port 3 not reset yet, waiting 10ms
usb 1-4.3: skipped 1 descriptor after interface
usb 1-4.3: default language 0x0409
usb 1-4.3: udev 6, busnum 1, minor = 5
usb 1-4.3: New USB device found, idVendor=058f, idProduct=6364
usb 1-4.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-4.3: Product: Mass Storage Device
usb 1-4.3: Manufacturer: Generic
usb 1-4.3: SerialNumber: 058F63646476
usb 1-4.3: uevent
usb 1-4.3: usb_probe_device
usb 1-4.3: configuration #1 chosen from 1 choice
usb 1-4.3: adding 1-4.3:1.0 (config #1, interface 0)
usb 1-4.3:1.0: uevent
usb-storage 1-4.3:1.0: usb_probe_interface
usb-storage 1-4.3:1.0: usb_probe_interface - got id
scsi8 : usb-storage 1-4.3:1.0
usb 1-4.3: adding 1-4.3:1.1 (config #1, interface 1)
usb 1-4.3:1.1: uevent
usbhid 1-4.3:1.1: usb_probe_interface
usbhid 1-4.3:1.1: usb_probe_interface - got id
generic-usb: probe of 0003:058F:6364.0003 failed with error -22
drivers/usb/core/inode.c: creating file '006'
hub 1-4:1.0: state 7 ports 4 chg 0000 evt 0008
usb 1-4.3: uevent
scsi 8:0:0:0: Direct-Access     Generic- SD/MMC           1.00 PQ: 0 ANSI: 0
sd 8:0:0:0: [sdc] Attached SCSI removable disk
usb 1-4.3:1.0: uevent
usb 1-4.3: uevent
usb 1-4.3:1.0: uevent
