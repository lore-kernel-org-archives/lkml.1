Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab0BIWWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 17:22:13 -0500
Received: from lnx141.hrz.tu-darmstadt.de ([130.83.156.236]:40536 "EHLO
	lnx141.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754373Ab0BIWWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 17:22:07 -0500
X-Greylist: delayed 916 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Feb 2010 17:22:05 EST
From: ST <st@iss.tu-darmstadt.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.33-rc7 problems
Date: Tue, 9 Feb 2010 23:06:07 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-00025-g08c4f1b; KDE/4.3.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_PxdcLLcKvNKr0Kp"
Message-Id: <201002092306.07449.st@iss.tu-darmstadt.de>
X-PMX-TU: seen v0.99a by 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.2.9.215423
X-PMX-SPAMCHECK: outgoing mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_PxdcLLcKvNKr0Kp
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi

I am currently running the linus main git tree with the last commit beeing:
deb0c98c7f6035d47a247e548384517a955314a5 (2.6.33-rc7)

USB Cardreader:
Since i am now in my third attempt to get my usb flashreader going under this
kernel (damn this must be simple right?). I have my doubts if this is probably 
not a .config but a kernel problem. If i plug in the usb card reader i get the 
output as attached in the file "usb_problems". The .config will be also 
attached. So i thought "ok, no problem i messed up", what about the defconfig.
(arch/x86/configs/x86_64_defconfig).
The defconfig works slightly better by omitting the repeating thread 
awake/thread sleeping output but no device is found usable. The distribution 
is Debian/Sid. The hardware is working with the standard Debian kernel 2.6.30.
I had a similar error when i had an typo in the default codepage "utf-8" vs. 
"utf8". But this error is fixed now and USB Sticks are working fine.

Firmware loading:
Firmware loading seems to hang this machine. It can be worked arround by 
embedding the firmware for the device (radeon onboard gfx) into the kernel
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE="radeon/R600_rlc.bin"
CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"
The microcode firmware loading also hangs for quite some time.

Disk access:
This is the most annoying: When dooing a md raid 1 level resync the machine
is barely usable. I haven't testet it with the current configuration but even 
when "update-grub" from grub2 is called the slowdown is really still there.
There is a file attached "timeouts" which give a output of such a scenario.
And boy 120s starvation is quite bad, right? Besides it doesn't seem fair to 
me either.

I am happy to test any patches you throw at me. Any hints tips are also very 
welcome.

Thanks
ST

PS: This is whitebox hw with a ASUS M4A78T-E Mainboard and 8 Gigs of ECC 
Memory and two SAMSUNG HD103SI in MD Raid 1 configuration.

PPS: Please CC as im am not subscribed on the list.

--Boundary-00=_PxdcLLcKvNKr0Kp
Content-Type: text/plain;
  charset="UTF-8";
  name="usb_problems.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="usb_problems.txt"

Feb  9 22:38:38 localhost kernel: hub 1-4:1.0: state 7 ports 4 chg 0000 evt 0008
Feb  9 22:38:38 localhost kernel: hub 1-4:1.0: port 3, status 0101, change 0001, 12 Mb/s
Feb  9 22:38:38 localhost kernel: hub 1-4:1.0: debounce: port 3: total 100ms stable 100ms status 0x101
Feb  9 22:38:38 localhost kernel: hub 1-4:1.0: port 3 not reset yet, waiting 10ms
Feb  9 22:38:38 localhost kernel: usb 1-4.3: new high speed USB device using ehci_hcd and address 6
Feb  9 22:38:38 localhost kernel: hub 1-4:1.0: port 3 not reset yet, waiting 10ms
Feb  9 22:38:38 localhost kernel: usb 1-4.3: skipped 1 descriptor after interface
Feb  9 22:38:38 localhost kernel: usb 1-4.3: default language 0x0409
Feb  9 22:38:38 localhost kernel: usb 1-4.3: udev 6, busnum 1, minor = 5
Feb  9 22:38:38 localhost kernel: usb 1-4.3: New USB device found, idVendor=058f, idProduct=6364
Feb  9 22:38:38 localhost kernel: usb 1-4.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Feb  9 22:38:38 localhost kernel: usb 1-4.3: Product: Mass Storage Device
Feb  9 22:38:38 localhost kernel: usb 1-4.3: Manufacturer: Generic
Feb  9 22:38:38 localhost kernel: usb 1-4.3: SerialNumber: 058F63646476
Feb  9 22:38:38 localhost kernel: usb 1-4.3: uevent
Feb  9 22:38:38 localhost kernel: usb 1-4.3: usb_probe_device
Feb  9 22:38:38 localhost kernel: usb 1-4.3: configuration #1 chosen from 1 choice
Feb  9 22:38:38 localhost kernel: usb 1-4.3: adding 1-4.3:1.0 (config #1, interface 0)
Feb  9 22:38:38 localhost kernel: usb 1-4.3:1.0: uevent
Feb  9 22:38:38 localhost kernel: usb 1-4.3: adding 1-4.3:1.1 (config #1, interface 1)
Feb  9 22:38:38 localhost kernel: usb 1-4.3:1.1: uevent
Feb  9 22:38:38 localhost kernel: usbhid 1-4.3:1.1: usb_probe_interface
Feb  9 22:38:38 localhost kernel: usbhid 1-4.3:1.1: usb_probe_interface - got id
Feb  9 22:38:38 localhost kernel: generic-usb: probe of 0003:058F:6364.0003 failed with error -22
Feb  9 22:38:38 localhost kernel: drivers/usb/core/inode.c: creating file '006'
Feb  9 22:38:38 localhost kernel: hub 1-4:1.0: state 7 ports 4 chg 0000 evt 0008
Feb  9 22:38:38 localhost kernel: usb 1-4.3: uevent
Feb  9 22:38:38 localhost kernel: Initializing USB Mass Storage driver...
Feb  9 22:38:38 localhost kernel: usb-storage 1-4.3:1.0: usb_probe_interface
Feb  9 22:38:38 localhost kernel: usb-storage 1-4.3:1.0: usb_probe_interface - got id
Feb  9 22:38:38 localhost kernel: usb-storage: USB Mass Storage device detected
Feb  9 22:38:38 localhost kernel: usb-storage: -- associate_dev
Feb  9 22:38:38 localhost kernel: usb-storage: Vendor: 0x058f, Product: 0x6364, Revision: 0x0100
Feb  9 22:38:38 localhost kernel: usb-storage: Interface Subclass: 0x06, Protocol: 0x50
Feb  9 22:38:38 localhost kernel: usb-storage: Transport: Bulk
Feb  9 22:38:38 localhost kernel: usb-storage: Protocol: Transparent SCSI
Feb  9 22:38:38 localhost kernel: scsi8 : usb-storage 1-4.3:1.0
Feb  9 22:38:38 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:38 localhost kernel: usb-storage 1-4.3:1.0: device found
Feb  9 22:38:38 localhost kernel: usb-storage 1-4.3:1.0: waiting for device to settle before scanning
Feb  9 22:38:38 localhost kernel: usbcore: registered new interface driver usb-storage
Feb  9 22:38:38 localhost kernel: USB Mass Storage support registered.
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_control_msg: rq=fe rqtype=a1 value=0000 index=00 len=1
Feb  9 22:38:43 localhost kernel: usb-storage: GetMaxLUN command result is 1, data is 3
Feb  9 22:38:43 localhost kernel: usb-storage 1-4.3:1.0: scan complete
Feb  9 22:38:43 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:43 localhost kernel: usb-storage: Command INQUIRY (6 bytes)
Feb  9 22:38:43 localhost kernel: usb-storage:  12 00 00 00 24 00
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x1 L 36 F 128 Trg 0 LUN 0 CL 6
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 36 bytes, 1 entries
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 36/36
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk data transfer result 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x1 R 0 Stat 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: scsi cmd done, result=0x0
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:43 localhost kernel: scsi 8:0:0:0: Direct-Access     Generic- SD/MMC           1.00 PQ: 0 ANSI: 0
Feb  9 22:38:43 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:43 localhost kernel: usb-storage: Bad target number (1:0)
Feb  9 22:38:43 localhost kernel: usb-storage: scsi cmd done, result=0x40000
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:43 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:43 localhost kernel: usb-storage: Bad target number (2:0)
Feb  9 22:38:43 localhost kernel: usb-storage: scsi cmd done, result=0x40000
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:43 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:43 localhost kernel: usb-storage: Bad target number (3:0)
Feb  9 22:38:43 localhost kernel: usb-storage: scsi cmd done, result=0x40000
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:43 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:43 localhost kernel: usb-storage: Bad target number (4:0)
Feb  9 22:38:43 localhost kernel: usb-storage: scsi cmd done, result=0x40000
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:43 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:43 localhost kernel: usb-storage: Bad target number (5:0)
Feb  9 22:38:43 localhost kernel: usb-storage: scsi cmd done, result=0x40000
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:43 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:43 localhost kernel: usb-storage: Bad target number (6:0)
Feb  9 22:38:43 localhost kernel: usb-storage: scsi cmd done, result=0x40000
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:43 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:43 localhost kernel: usb-storage: Bad target number (7:0)
Feb  9 22:38:43 localhost kernel: usb-storage: scsi cmd done, result=0x40000
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:43 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:43 localhost kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Feb  9 22:38:43 localhost kernel: usb-storage:  00 00 00 00 00 00
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x2 L 0 F 0 Trg 0 LUN 0 CL 6
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:43 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:43 localhost kernel: sd 8:0:0:0: Attached scsi generic sg3 type 0
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x2 R 0 Stat 0x1
Feb  9 22:38:43 localhost kernel: usb-storage: -- transport indicates command failure
Feb  9 22:38:43 localhost kernel: usb-storage: Issuing auto-REQUEST_SENSE
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x3 L 18 F 128 Trg 0 LUN 0 CL 6
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 18/18
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk data transfer result 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x3 R 0 Stat 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: -- Result from auto-sense is 0
Feb  9 22:38:43 localhost kernel: usb-storage: -- code: 0xf0, key: 0x2, ASC: 0x3a, ASCQ: 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: Not Ready: Medium not present
Feb  9 22:38:43 localhost kernel: usb-storage: scsi cmd done, result=0x2
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:43 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:43 localhost kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Feb  9 22:38:43 localhost kernel: usb-storage:  00 00 00 00 00 00
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x4 L 0 F 0 Trg 0 LUN 0 CL 6
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:43 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x4 R 0 Stat 0x1
Feb  9 22:38:43 localhost kernel: usb-storage: -- transport indicates command failure
Feb  9 22:38:43 localhost kernel: usb-storage: Issuing auto-REQUEST_SENSE
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x5 L 18 F 128 Trg 0 LUN 0 CL 6
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 18/18
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk data transfer result 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x5 R 0 Stat 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: -- Result from auto-sense is 0
Feb  9 22:38:43 localhost kernel: usb-storage: -- code: 0xf0, key: 0x2, ASC: 0x3a, ASCQ: 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: Not Ready: Medium not present
Feb  9 22:38:43 localhost kernel: usb-storage: scsi cmd done, result=0x2
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:43 localhost kernel: sd 8:0:0:0: [sdc] Attached SCSI removable disk
Feb  9 22:38:43 localhost kernel: usb 1-4.3:1.0: uevent
Feb  9 22:38:43 localhost kernel: usb 1-4.3: uevent
Feb  9 22:38:43 localhost kernel: usb 1-4.3:1.0: uevent
Feb  9 22:38:43 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:43 localhost kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Feb  9 22:38:43 localhost kernel: usb-storage:  00 00 00 00 00 00
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x6 L 0 F 0 Trg 0 LUN 0 CL 6
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:43 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x6 R 0 Stat 0x1
Feb  9 22:38:43 localhost kernel: usb-storage: -- transport indicates command failure
Feb  9 22:38:43 localhost kernel: usb-storage: Issuing auto-REQUEST_SENSE
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x7 L 18 F 128 Trg 0 LUN 0 CL 6
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 18/18
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk data transfer result 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x7 R 0 Stat 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: -- Result from auto-sense is 0
Feb  9 22:38:43 localhost kernel: usb-storage: -- code: 0xf0, key: 0x2, ASC: 0x3a, ASCQ: 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: Not Ready: Medium not present
Feb  9 22:38:43 localhost kernel: usb-storage: scsi cmd done, result=0x2
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:43 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:43 localhost kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Feb  9 22:38:43 localhost kernel: usb-storage:  00 00 00 00 00 00
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x8 L 0 F 0 Trg 0 LUN 0 CL 6
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:43 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x8 R 0 Stat 0x1
Feb  9 22:38:43 localhost kernel: usb-storage: -- transport indicates command failure
Feb  9 22:38:43 localhost kernel: usb-storage: Issuing auto-REQUEST_SENSE
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x9 L 18 F 128 Trg 0 LUN 0 CL 6
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 18/18
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk data transfer result 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x9 R 0 Stat 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: -- Result from auto-sense is 0
Feb  9 22:38:43 localhost kernel: usb-storage: -- code: 0xf0, key: 0x2, ASC: 0x3a, ASCQ: 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: Not Ready: Medium not present
Feb  9 22:38:43 localhost kernel: usb-storage: scsi cmd done, result=0x2
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:43 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:43 localhost kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Feb  9 22:38:43 localhost kernel: usb-storage:  00 00 00 00 00 00
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0xa L 0 F 0 Trg 0 LUN 0 CL 6
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:43 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0xa R 0 Stat 0x1
Feb  9 22:38:43 localhost kernel: usb-storage: -- transport indicates command failure
Feb  9 22:38:43 localhost kernel: usb-storage: Issuing auto-REQUEST_SENSE
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0xb L 18 F 128 Trg 0 LUN 0 CL 6
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 18/18
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk data transfer result 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0xb R 0 Stat 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: -- Result from auto-sense is 0
Feb  9 22:38:43 localhost kernel: usb-storage: -- code: 0xf0, key: 0x2, ASC: 0x3a, ASCQ: 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: Not Ready: Medium not present
Feb  9 22:38:43 localhost kernel: usb-storage: scsi cmd done, result=0x2
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:43 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:43 localhost kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Feb  9 22:38:43 localhost kernel: usb-storage:  00 00 00 00 00 00
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0xc L 0 F 0 Trg 0 LUN 0 CL 6
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:43 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0xc R 0 Stat 0x1
Feb  9 22:38:43 localhost kernel: usb-storage: -- transport indicates command failure
Feb  9 22:38:43 localhost kernel: usb-storage: Issuing auto-REQUEST_SENSE
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0xd L 18 F 128 Trg 0 LUN 0 CL 6
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 18/18
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk data transfer result 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0xd R 0 Stat 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: -- Result from auto-sense is 0
Feb  9 22:38:43 localhost kernel: usb-storage: -- code: 0xf0, key: 0x2, ASC: 0x3a, ASCQ: 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: Not Ready: Medium not present
Feb  9 22:38:43 localhost kernel: usb-storage: scsi cmd done, result=0x2
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:43 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:43 localhost kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Feb  9 22:38:43 localhost kernel: usb-storage:  00 00 00 00 00 00
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0xe L 0 F 0 Trg 0 LUN 0 CL 6
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:43 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0xe R 0 Stat 0x1
Feb  9 22:38:43 localhost kernel: usb-storage: -- transport indicates command failure
Feb  9 22:38:43 localhost kernel: usb-storage: Issuing auto-REQUEST_SENSE
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0xf L 18 F 128 Trg 0 LUN 0 CL 6
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 18/18
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk data transfer result 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0xf R 0 Stat 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: -- Result from auto-sense is 0
Feb  9 22:38:43 localhost kernel: usb-storage: -- code: 0xf0, key: 0x2, ASC: 0x3a, ASCQ: 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: Not Ready: Medium not present
Feb  9 22:38:43 localhost kernel: usb-storage: scsi cmd done, result=0x2
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:43 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:43 localhost kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Feb  9 22:38:43 localhost kernel: usb-storage:  00 00 00 00 00 00
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x10 L 0 F 0 Trg 0 LUN 0 CL 6
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:43 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x10 R 0 Stat 0x1
Feb  9 22:38:43 localhost kernel: usb-storage: -- transport indicates command failure
Feb  9 22:38:43 localhost kernel: usb-storage: Issuing auto-REQUEST_SENSE
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x11 L 18 F 128 Trg 0 LUN 0 CL 6
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 18/18
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk data transfer result 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:43 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:43 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:43 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:43 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x11 R 0 Stat 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: -- Result from auto-sense is 0
Feb  9 22:38:43 localhost kernel: usb-storage: -- code: 0xf0, key: 0x2, ASC: 0x3a, ASCQ: 0x0
Feb  9 22:38:43 localhost kernel: usb-storage: Not Ready: Medium not present
Feb  9 22:38:43 localhost kernel: usb-storage: scsi cmd done, result=0x2
Feb  9 22:38:43 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:46 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:46 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:46 localhost kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Feb  9 22:38:46 localhost kernel: usb-storage:  00 00 00 00 00 00
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x12 L 0 F 0 Trg 0 LUN 0 CL 6
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:46 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x12 R 0 Stat 0x1
Feb  9 22:38:46 localhost kernel: usb-storage: -- transport indicates command failure
Feb  9 22:38:46 localhost kernel: usb-storage: Issuing auto-REQUEST_SENSE
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x13 L 18 F 128 Trg 0 LUN 0 CL 6
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 18/18
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk data transfer result 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x13 R 0 Stat 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: -- Result from auto-sense is 0
Feb  9 22:38:46 localhost kernel: usb-storage: -- code: 0xf0, key: 0x2, ASC: 0x3a, ASCQ: 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: Not Ready: Medium not present
Feb  9 22:38:46 localhost kernel: usb-storage: scsi cmd done, result=0x2
Feb  9 22:38:46 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:46 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:46 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:46 localhost kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Feb  9 22:38:46 localhost kernel: usb-storage:  00 00 00 00 00 00
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x14 L 0 F 0 Trg 0 LUN 0 CL 6
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:46 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x14 R 0 Stat 0x1
Feb  9 22:38:46 localhost kernel: usb-storage: -- transport indicates command failure
Feb  9 22:38:46 localhost kernel: usb-storage: Issuing auto-REQUEST_SENSE
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x15 L 18 F 128 Trg 0 LUN 0 CL 6
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 18/18
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk data transfer result 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x15 R 0 Stat 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: -- Result from auto-sense is 0
Feb  9 22:38:46 localhost kernel: usb-storage: -- code: 0xf0, key: 0x2, ASC: 0x3a, ASCQ: 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: Not Ready: Medium not present
Feb  9 22:38:46 localhost kernel: usb-storage: scsi cmd done, result=0x2
Feb  9 22:38:46 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:46 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:46 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:46 localhost kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Feb  9 22:38:46 localhost kernel: usb-storage:  00 00 00 00 00 00
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x16 L 0 F 0 Trg 0 LUN 0 CL 6
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:46 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x16 R 0 Stat 0x1
Feb  9 22:38:46 localhost kernel: usb-storage: -- transport indicates command failure
Feb  9 22:38:46 localhost kernel: usb-storage: Issuing auto-REQUEST_SENSE
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x17 L 18 F 128 Trg 0 LUN 0 CL 6
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 18/18
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk data transfer result 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x17 R 0 Stat 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: -- Result from auto-sense is 0
Feb  9 22:38:46 localhost kernel: usb-storage: -- code: 0xf0, key: 0x2, ASC: 0x3a, ASCQ: 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: Not Ready: Medium not present
Feb  9 22:38:46 localhost kernel: usb-storage: scsi cmd done, result=0x2
Feb  9 22:38:46 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:46 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:46 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:46 localhost kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Feb  9 22:38:46 localhost kernel: usb-storage:  00 00 00 00 00 00
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x18 L 0 F 0 Trg 0 LUN 0 CL 6
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:46 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x18 R 0 Stat 0x1
Feb  9 22:38:46 localhost kernel: usb-storage: -- transport indicates command failure
Feb  9 22:38:46 localhost kernel: usb-storage: Issuing auto-REQUEST_SENSE
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x19 L 18 F 128 Trg 0 LUN 0 CL 6
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 18/18
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk data transfer result 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x19 R 0 Stat 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: -- Result from auto-sense is 0
Feb  9 22:38:46 localhost kernel: usb-storage: -- code: 0xf0, key: 0x2, ASC: 0x3a, ASCQ: 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: Not Ready: Medium not present
Feb  9 22:38:46 localhost kernel: usb-storage: scsi cmd done, result=0x2
Feb  9 22:38:46 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:46 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:46 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:46 localhost kernel: usb-storage: Command ALLOW_MEDIUM_REMOVAL (6 bytes)
Feb  9 22:38:46 localhost kernel: usb-storage:  1e 00 00 00 01 00
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x1a L 0 F 0 Trg 0 LUN 0 CL 6
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:46 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x1a R 0 Stat 0x1
Feb  9 22:38:46 localhost kernel: usb-storage: -- transport indicates command failure
Feb  9 22:38:46 localhost kernel: usb-storage: Issuing auto-REQUEST_SENSE
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x1b L 18 F 128 Trg 0 LUN 0 CL 6
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 18/18
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk data transfer result 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x1b R 0 Stat 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: -- Result from auto-sense is 0
Feb  9 22:38:46 localhost kernel: usb-storage: -- code: 0xf0, key: 0x5, ASC: 0x26, ASCQ: 0x2
Feb  9 22:38:46 localhost kernel: usb-storage: Illegal Request: Parameter value invalid
Feb  9 22:38:46 localhost kernel: usb-storage: scsi cmd done, result=0x2
Feb  9 22:38:46 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:46 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:46 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:46 localhost kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Feb  9 22:38:46 localhost kernel: usb-storage:  00 00 00 00 00 00
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x1c L 0 F 0 Trg 0 LUN 0 CL 6
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:46 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x1c R 0 Stat 0x1
Feb  9 22:38:46 localhost kernel: usb-storage: -- transport indicates command failure
Feb  9 22:38:46 localhost kernel: usb-storage: Issuing auto-REQUEST_SENSE
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x1d L 18 F 128 Trg 0 LUN 0 CL 6
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 18/18
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk data transfer result 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x1d R 0 Stat 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: -- Result from auto-sense is 0
Feb  9 22:38:46 localhost kernel: usb-storage: -- code: 0xf0, key: 0x2, ASC: 0x3a, ASCQ: 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: Not Ready: Medium not present
Feb  9 22:38:46 localhost kernel: usb-storage: scsi cmd done, result=0x2
Feb  9 22:38:46 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:46 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:46 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:46 localhost kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Feb  9 22:38:46 localhost kernel: usb-storage:  00 00 00 00 00 00
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x1e L 0 F 0 Trg 0 LUN 0 CL 6
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:46 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x1e R 0 Stat 0x1
Feb  9 22:38:46 localhost kernel: usb-storage: -- transport indicates command failure
Feb  9 22:38:46 localhost kernel: usb-storage: Issuing auto-REQUEST_SENSE
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x1f L 18 F 128 Trg 0 LUN 0 CL 6
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 18/18
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk data transfer result 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x1f R 0 Stat 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: -- Result from auto-sense is 0
Feb  9 22:38:46 localhost kernel: usb-storage: -- code: 0xf0, key: 0x2, ASC: 0x3a, ASCQ: 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: Not Ready: Medium not present
Feb  9 22:38:46 localhost kernel: usb-storage: scsi cmd done, result=0x2
Feb  9 22:38:46 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:46 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:46 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:46 localhost kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Feb  9 22:38:46 localhost kernel: usb-storage:  00 00 00 00 00 00
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x20 L 0 F 0 Trg 0 LUN 0 CL 6
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:46 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x20 R 0 Stat 0x1
Feb  9 22:38:46 localhost kernel: usb-storage: -- transport indicates command failure
Feb  9 22:38:46 localhost kernel: usb-storage: Issuing auto-REQUEST_SENSE
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x21 L 18 F 128 Trg 0 LUN 0 CL 6
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 18/18
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk data transfer result 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x21 R 0 Stat 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: -- Result from auto-sense is 0
Feb  9 22:38:46 localhost kernel: usb-storage: -- code: 0xf0, key: 0x2, ASC: 0x3a, ASCQ: 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: Not Ready: Medium not present
Feb  9 22:38:46 localhost kernel: usb-storage: scsi cmd done, result=0x2
Feb  9 22:38:46 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:46 localhost kernel: usb-storage: queuecommand called
Feb  9 22:38:46 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:46 localhost kernel: usb-storage: Command TEST_UNIT_READY (6 bytes)
Feb  9 22:38:46 localhost kernel: usb-storage:  00 00 00 00 00 00
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x22 L 0 F 0 Trg 0 LUN 0 CL 6
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:46 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x22 R 0 Stat 0x1
Feb  9 22:38:46 localhost kernel: usb-storage: -- transport indicates command failure
Feb  9 22:38:46 localhost kernel: usb-storage: Issuing auto-REQUEST_SENSE
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Command S 0x43425355 T 0x23 L 18 F 128 Trg 0 LUN 0 CL 6
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 31/31
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk command transfer result=0
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 18/18
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk data transfer result 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: Attempting to get CSW...
Feb  9 22:38:46 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Feb  9 22:38:46 localhost kernel: usb-storage: Status code 0; transferred 13/13
Feb  9 22:38:46 localhost kernel: usb-storage: -- transfer complete
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk status result = 0
Feb  9 22:38:46 localhost kernel: usb-storage: Bulk Status S 0x53425355 T 0x23 R 0 Stat 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: -- Result from auto-sense is 0
Feb  9 22:38:46 localhost kernel: usb-storage: -- code: 0xf0, key: 0x2, ASC: 0x3a, ASCQ: 0x0
Feb  9 22:38:46 localhost kernel: usb-storage: Not Ready: Medium not present
Feb  9 22:38:46 localhost kernel: usb-storage: scsi cmd done, result=0x2
Feb  9 22:38:46 localhost kernel: usb-storage: *** thread sleeping.
Feb  9 22:38:46 localhost kernel: hub 1-4:1.0: state 7 ports 4 chg 0000 evt 0008
Feb  9 22:38:46 localhost kernel: hub 1-4:1.0: port 3, status 0100, change 0001, 12 Mb/s
Feb  9 22:38:46 localhost kernel: usb 1-4.3: USB disconnect, address 6
Feb  9 22:38:46 localhost kernel: usb 1-4.3: unregistering device
Feb  9 22:38:46 localhost kernel: usb 1-4.3: usb_disable_device nuking all URBs
Feb  9 22:38:46 localhost kernel: usb 1-4.3: unregistering interface 1-4.3:1.0
Feb  9 22:38:46 localhost kernel: usb-storage: storage_disconnect() called
Feb  9 22:38:46 localhost kernel: usb-storage: -- usb_stor_release_resources
Feb  9 22:38:46 localhost kernel: usb-storage: -- sending exit command to thread
Feb  9 22:38:46 localhost kernel: usb-storage: *** thread awakened.
Feb  9 22:38:46 localhost kernel: usb-storage: -- exiting
Feb  9 22:38:46 localhost kernel: usb-storage: -- dissociate_dev
Feb  9 22:38:46 localhost kernel: usb 1-4.3:1.0: uevent
Feb  9 22:38:46 localhost kernel: usb 1-4.3: unregistering interface 1-4.3:1.1
Feb  9 22:38:46 localhost kernel: usb 1-4.3:1.1: uevent
Feb  9 22:38:46 localhost kernel: usb 1-4.3: uevent
Feb  9 22:38:46 localhost kernel: hub 1-4:1.0: debounce: port 3: total 100ms stable 100ms status 0x100
Feb  9 22:39:01 localhost /USR/SBIN/CRON[3684]: (root) CMD (  [ -x /usr/lib/php5/maxlifetime ] && [ -d /var/lib/php5 ] && find /var/lib/php5/ -type f -cmin +$(/usr/lib/php5/maxlifetime) -print0 | xargs -n 200 -r -0 rm)

--Boundary-00=_PxdcLLcKvNKr0Kp
Content-Type: text/plain;
  charset="UTF-8";
  name="timeouts"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="timeouts"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.30-1-amd64 (Debian 2.6.30-6) (waldi@debian.org) (gcc version 4.3.4 (Debian 4.3.4-1) ) #1 SMP Sat Aug 15 18:09:19 UTC 2009
[    0.000000] Command line: root=/dev/sda4 ro quiet
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfe90000 (usable)
[    0.000000]  BIOS-e820: 00000000bfe90000 - 00000000bfea8000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfea8000 - 00000000bfed0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfed0000 - 00000000bff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x230000 max_arch_pfn = 0x100000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000230000000 aka 8960M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000c0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbfe90 max_arch_pfn = 0x100000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bfe90000
[    0.000000] Using GB pages for direct mapping
[    0.000000]  0000000000 - 0080000000 page 1G
[    0.000000]  0080000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bfe90000 page 4k
[    0.000000] kernel direct mapping tables up to bfe90000 @ 10000-13000
[    0.000000] init_memory_mapping: 0000000100000000-0000000230000000
[    0.000000] Using GB pages for direct mapping
[    0.000000]  0100000000 - 0200000000 page 1G
[    0.000000]  0200000000 - 0230000000 page 2M
[    0.000000] kernel direct mapping tables up to 230000000 @ 12000-14000
[    0.000000] RAMDISK: 37886000 - 37fef11b
[    0.000000] ACPI: RSDP 00000000000fb8b0 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bfe90100 00054 (v01 060509 XSDT1006 20090605 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bfe90290 000F4 (v03 060509 FACP1006 20090605 MSFT 00000097)
[    0.000000] ACPI Warning (tbfadt-0562): Optional field Pm2ControlBlock has zero address or length: 0000000000000000/1 [20090320]
[    0.000000] ACPI: DSDT 00000000bfe90440 0E6E4 (v01  A1152 A1152000 00000000 INTL 20060113)
[    0.000000] ACPI: FACS 00000000bfea8000 00040
[    0.000000] ACPI: APIC 00000000bfe90390 0006C (v01 060509 APIC1006 20090605 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bfe90400 0003C (v01 060509 OEMMCFG  20090605 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bfea8040 00072 (v01 060509 OEMB1006 20090605 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bfe9f440 00038 (v01 060509 OEMHPET  20090605 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bfe9f480 0088C (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000230000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000230000000
[    0.000000]   NODE_DATA [0000000000013000 - 000000000001afff]
[    0.000000]   bootmap [000000000001b000 -  0000000000060fff] pages 46
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0230000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00007dd8cc]    TEXT DATA BSS ==> [0000200000 - 00007dd8cc]
[    0.000000]   #3 [0037886000 - 0037fef11b]          RAMDISK ==> [0037886000 - 0037fef11b]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #5 [00007de000 - 00007de290]              BRK ==> [00007de000 - 00007de290]
[    0.000000]   #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000]   #7 [0000012000 - 0000013000]          PGTABLE ==> [0000012000 - 0000013000]
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000]  [ffffe20000000000-ffffe20007bfffff] PMD -> [ffff880028200000-ffff88002effffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00230000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bfe90
[    0.000000]     0: 0x00100000 -> 0x00230000
[    0.000000] On node 0 totalpages: 2031135
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1603 pages reserved
[    0.000000]   DMA zone: 2324 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 767688 pages, LIFO batch:31
[    0.000000]   Normal zone: 17024 pages used for memmap
[    0.000000]   Normal zone: 1228160 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e6000
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bfe90000 - 00000000bfea8000
[    0.000000] PM: Registered nosave memory: 00000000bfea8000 - 00000000bfed0000
[    0.000000] PM: Registered nosave memory: 00000000bfed0000 - 00000000bff00000
[    0.000000] PM: Registered nosave memory: 00000000bff00000 - 00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: bff00000:40000000)
[    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages at ffff880028034000, static data 76256 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1998172
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/sda4 ro quiet
[    0.000000] Initializing CPU#0
[    0.000000] Experimental hierarchical RCU implementation.
[    0.000000] Experimental hierarchical RCU init done.
[    0.000000] NR_IRQS:4352 nr_irqs:440
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3211.077 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Node 0: aperture @ 4000000 size 32 MB
[    0.004000] Aperture pointing to e820 RAM. Ignoring.
[    0.004000] Your BIOS doesn't leave a aperture memory hole
[    0.004000] Please enable the IOMMU option in the BIOS setup
[    0.004000] This costs you 64 MB of RAM
[    0.004000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.004000] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.004000] Memory: 7932016k/9175040k available (2784k kernel code, 1050500k absent, 192524k reserved, 1415k data, 560k init)
[    0.004000] hpet clockevent registered
[    0.004000]   alloc irq_desc for 24 on cpu 0 node 0
[    0.004000]   alloc kstat_irqs on cpu 0 node 0
[    0.004000] HPET: 4 timers in total, 1 timers will be used for per-cpu timer
[    0.004006] Calibrating delay loop (skipped), value calculated using timer frequency.. 6422.14 BogoMIPS (lpj=12844292)
[    0.004054] Security Framework initialized
[    0.004057] SELinux:  Disabled at boot.
[    0.004509] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.006513] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.007391] Mount-cache hash table entries: 256
[    0.007474] Initializing cgroup subsys ns
[    0.007477] Initializing cgroup subsys cpuacct
[    0.007479] Initializing cgroup subsys devices
[    0.007481] Initializing cgroup subsys freezer
[    0.007482] Initializing cgroup subsys net_cls
[    0.007498] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.007499] CPU: L2 Cache: 512K (64 bytes/line)
[    0.007500] CPU 0/0x0 -> Node 0
[    0.007502] tseg: 0000000000
[    0.007512] CPU: Physical Processor ID: 0
[    0.007512] CPU: Processor Core ID: 0
[    0.007518] using C1E aware idle routine
[    0.008057] ACPI: Core revision 20090320
[    0.024039] Setting APIC routing to flat
[    0.024327] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.064881] CPU0: AMD Phenom(tm) II X4 955 Processor stepping 02
[    0.068001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 6421.93 BogoMIPS (lpj=12843864)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU 1/0x1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.152863] CPU1: AMD Phenom(tm) II X4 955 Processor stepping 02
[    0.152869] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.156014] System has AMD C1E enabled
[    0.156024] Switch to broadcast mode on CPU1
[    0.156060] Booting processor 2 APIC 0x2 ip 0x6000
[    0.004000] Initializing CPU#2
[    0.004000] Calibrating delay using timer specific routine.. 6421.92 BogoMIPS (lpj=12843840)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU 2/0x2 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 2
[    0.004000] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.244799] CPU2: AMD Phenom(tm) II X4 955 Processor stepping 02
[    0.244804] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.248017] Switch to broadcast mode on CPU2
[    0.248064] Booting processor 3 APIC 0x3 ip 0x6000
[    0.004000] Initializing CPU#3
[    0.004000] Calibrating delay using timer specific routine.. 6421.88 BogoMIPS (lpj=12843762)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU 3/0x3 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 3
[    0.004000] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.336816] CPU3: AMD Phenom(tm) II X4 955 Processor stepping 02
[    0.336820] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.340020] Brought up 4 CPUs
[    0.340022] Total of 4 processors activated (25687.87 BogoMIPS).
[    0.340019] Switch to broadcast mode on CPU3
[    0.340073] CPU0 attaching sched-domain:
[    0.340075]  domain 0: span 0-3 level MC
[    0.340077]   groups: 0 1 2 3
[    0.340081] CPU1 attaching sched-domain:
[    0.340082]  domain 0: span 0-3 level MC
[    0.340083]   groups: 1 2 3 0
[    0.340087] CPU2 attaching sched-domain:
[    0.340088]  domain 0: span 0-3 level MC
[    0.340089]   groups: 2 3 0 1
[    0.340092] CPU3 attaching sched-domain:
[    0.340093]  domain 0: span 0-3 level MC
[    0.340094]   groups: 3 0 1 2
[    0.340147] Switch to broadcast mode on CPU0
[    0.340147] net_namespace: 1936 bytes
[    0.340147] Booting paravirtualized kernel on bare hardware
[    0.340147] regulator: core version 0.5
[    0.340147] NET: Registered protocol family 16
[    0.340147] node 0 link 0: io port [1000, ffffff]
[    0.340147] TOM: 00000000d0000000 aka 3328M
[    0.340147] Fam 10h mmconf [e0000000, efffffff]
[    0.340147] node 0 link 0: mmio [a0000, bffff]
[    0.340147] node 0 link 0: mmio [d0000000, efffffff] ==> [d0000000, dfffffff]
[    0.340147] node 0 link 0: mmio [f0000000, fbcfffff]
[    0.340147] node 0 link 0: mmio [fbd00000, fbefffff]
[    0.340147] node 0 link 0: mmio [fbf00000, ffefffff]
[    0.340147] TOM2: 0000000230000000 aka 8960M
[    0.340147] bus: [00,07] on node 0 link 0
[    0.340147] bus: 00 index 0 io port: [0, ffff]
[    0.340147] bus: 00 index 1 mmio: [a0000, bffff]
[    0.340147] bus: 00 index 2 mmio: [d0000000, dfffffff]
[    0.340147] bus: 00 index 3 mmio: [f0000000, ffffffff]
[    0.340147] bus: 00 index 4 mmio: [230000000, fcffffffff]
[    0.340147] ACPI: bus type pci registered
[    0.340147] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.340147] PCI: Not using MMCONFIG.
[    0.340147] PCI: Using configuration type 1 for base access
[    0.340147] PCI: Using configuration type 1 for extended access
[    0.340147] mtrr: your CPUs had inconsistent fixed MTRR settings
[    0.340147] mtrr: probably your BIOS does not setup all CPUs.
[    0.340147] mtrr: corrected configuration.
[    0.340147] bio: create slab <bio-0> at 0
[    0.340451] ACPI: EC: Look up EC in DSDT
[    0.431345] ACPI: Interpreter enabled
[    0.431348] ACPI: (supports S0 S1 S3 S4 S5)
[    0.431368] ACPI: Using IOAPIC for interrupt routing
[    0.431421] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.436846] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.442943] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.449672] ACPI Warning (tbutils-0246): Incorrect checksum in table [OEMB] - 05, should be FC [20090320]
[    0.449672] ACPI: No dock devices found.
[    0.449672] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.449672] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.449672] pci 0000:00:06.0: PME# disabled
[    0.449672] pci 0000:00:11.0: reg 10 io port: [0xc000-0xc007]
[    0.449672] pci 0000:00:11.0: reg 14 io port: [0xb000-0xb003]
[    0.449672] pci 0000:00:11.0: reg 18 io port: [0xa000-0xa007]
[    0.449672] pci 0000:00:11.0: reg 1c io port: [0x9000-0x9003]
[    0.449672] pci 0000:00:11.0: reg 20 io port: [0x8000-0x800f]
[    0.449672] pci 0000:00:11.0: reg 24 32bit mmio: [0xfbcffc00-0xfbcfffff]
[    0.449672] pci 0000:00:12.0: reg 10 32bit mmio: [0xfbcfd000-0xfbcfdfff]
[    0.449672] pci 0000:00:12.1: reg 10 32bit mmio: [0xfbcfe000-0xfbcfefff]
[    0.449672] pci 0000:00:12.2: reg 10 32bit mmio: [0xfbcff800-0xfbcff8ff]
[    0.449672] pci 0000:00:12.2: supports D1 D2
[    0.449672] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.449672] pci 0000:00:12.2: PME# disabled
[    0.452023] pci 0000:00:13.0: reg 10 32bit mmio: [0xfbcfb000-0xfbcfbfff]
[    0.452070] pci 0000:00:13.1: reg 10 32bit mmio: [0xfbcfc000-0xfbcfcfff]
[    0.452133] pci 0000:00:13.2: reg 10 32bit mmio: [0xfbcff400-0xfbcff4ff]
[    0.452179] pci 0000:00:13.2: supports D1 D2
[    0.452180] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.452183] pci 0000:00:13.2: PME# disabled
[    0.452284] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
[    0.452290] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
[    0.452295] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
[    0.452301] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
[    0.452306] pci 0000:00:14.1: reg 20 io port: [0xff00-0xff0f]
[    0.452363] pci 0000:00:14.2: reg 10 64bit mmio: [0xfbcf4000-0xfbcf7fff]
[    0.452400] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.452403] pci 0000:00:14.2: PME# disabled
[    0.452495] pci 0000:00:14.5: reg 10 32bit mmio: [0xfbcfa000-0xfbcfafff]
[    0.452599] pci 0000:01:05.0: reg 10 32bit mmio: [0xd0000000-0xdfffffff]
[    0.452602] pci 0000:01:05.0: reg 14 io port: [0xd000-0xd0ff]
[    0.452604] pci 0000:01:05.0: reg 18 32bit mmio: [0xfbee0000-0xfbeeffff]
[    0.452609] pci 0000:01:05.0: reg 24 32bit mmio: [0xfbd00000-0xfbdfffff]
[    0.452618] pci 0000:01:05.0: supports D1 D2
[    0.452631] pci 0000:01:05.1: reg 10 32bit mmio: [0xfbefc000-0xfbefffff]
[    0.452645] pci 0000:01:05.1: supports D1 D2
[    0.452679] pci 0000:00:01.0: bridge io port: [0xd000-0xdfff]
[    0.452681] pci 0000:00:01.0: bridge 32bit mmio: [0xfbd00000-0xfbefffff]
[    0.452684] pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.452725] pci 0000:02:00.0: reg 10 64bit mmio: [0xfbfc0000-0xfbffffff]
[    0.452731] pci 0000:02:00.0: reg 18 io port: [0xec00-0xec7f]
[    0.452775] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    0.452778] pci 0000:02:00.0: PME# disabled
[    0.452828] pci 0000:00:06.0: bridge io port: [0xe000-0xefff]
[    0.452829] pci 0000:00:06.0: bridge 32bit mmio: [0xfbf00000-0xfbffffff]
[    0.452882] pci 0000:00:14.4: transparent bridge
[    0.452901] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.453083] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.453143] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE6._PRT]
[    0.453209] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.456134] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 *11 12 14 15)
[    0.456206] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 *10 11 12 14 15)
[    0.456319] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 12 14 15)
[    0.456432] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 *7 10 11 12 14 15)
[    0.456545] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.456658] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.456771] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 10 *11 12 14 15)
[    0.456884] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.456930] usbcore: registered new interface driver usbfs
[    0.456930] usbcore: registered new interface driver hub
[    0.456930] usbcore: registered new device driver usb
[    0.456930] PCI: Using ACPI for IRQ routing
[    0.472074] PCI-DMA: Disabling AGP.
[    0.472122] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.472122] PCI-DMA: using GART IOMMU.
[    0.472122] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.473764] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
[    0.473769] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.480021] hpet: hpet2 irq 24 for MSI
[    0.503988] Switched to high resolution mode on CPU 3
[    0.503992] Switched to high resolution mode on CPU 1
[    0.503996] Switched to high resolution mode on CPU 2
[    0.504012] Switched to high resolution mode on CPU 0
[    0.508252] pnp: PnP ACPI init
[    0.508267] ACPI: bus type pnp registered
[    0.513014] pnp: PnP ACPI: found 15 devices
[    0.513015] ACPI: ACPI bus type pnp unregistered
[    0.513022] system 00:01: iomem range 0xc0000000-0xcfffffff has been reserved
[    0.513027] system 00:07: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.513029] system 00:07: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.513033] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.513035] system 00:08: ioport range 0x40b-0x40b has been reserved
[    0.513036] system 00:08: ioport range 0x4d6-0x4d6 has been reserved
[    0.513038] system 00:08: ioport range 0xc00-0xc01 has been reserved
[    0.513040] system 00:08: ioport range 0xc14-0xc14 has been reserved
[    0.513041] system 00:08: ioport range 0xc50-0xc51 has been reserved
[    0.513043] system 00:08: ioport range 0xc52-0xc52 has been reserved
[    0.513045] system 00:08: ioport range 0xc6c-0xc6c has been reserved
[    0.513046] system 00:08: ioport range 0xc6f-0xc6f has been reserved
[    0.513048] system 00:08: ioport range 0xcd0-0xcd1 has been reserved
[    0.513050] system 00:08: ioport range 0xcd2-0xcd3 has been reserved
[    0.513052] system 00:08: ioport range 0xcd4-0xcd5 has been reserved
[    0.513053] system 00:08: ioport range 0xcd6-0xcd7 has been reserved
[    0.513055] system 00:08: ioport range 0xcd8-0xcdf has been reserved
[    0.513057] system 00:08: ioport range 0xb00-0xb3f has been reserved
[    0.513058] system 00:08: ioport range 0x800-0x89f has been reserved
[    0.513060] system 00:08: ioport range 0xb00-0xb0f has been reserved
[    0.513062] system 00:08: ioport range 0xb20-0xb3f has been reserved
[    0.513064] system 00:08: ioport range 0x900-0x90f has been reserved
[    0.513065] system 00:08: ioport range 0x910-0x91f has been reserved
[    0.513067] system 00:08: ioport range 0xfe00-0xfefe has been reserved
[    0.513069] system 00:08: iomem range 0xffb80000-0xffbfffff has been reserved
[    0.513071] system 00:08: iomem range 0xfec10000-0xfec1001f has been reserved
[    0.513075] system 00:0c: ioport range 0x230-0x23f has been reserved
[    0.513077] system 00:0c: ioport range 0x290-0x29f has been reserved
[    0.513078] system 00:0c: ioport range 0xf40-0xf4f has been reserved
[    0.513080] system 00:0c: ioport range 0xa30-0xa3f has been reserved
[    0.513083] system 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
[    0.513086] system 00:0e: iomem range 0x0-0x9ffff could not be reserved
[    0.513088] system 00:0e: iomem range 0xc0000-0xcffff has been reserved
[    0.513090] system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
[    0.513092] system 00:0e: iomem range 0x100000-0xbfefffff could not be reserved
[    0.513094] system 00:0e: iomem range 0xfec00000-0xffffffff could not be reserved
[    0.517976] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.517978] pci 0000:00:01.0:   IO window: 0xd000-0xdfff
[    0.517980] pci 0000:00:01.0:   MEM window: 0xfbd00000-0xfbefffff
[    0.517982] pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.517985] pci 0000:00:06.0: PCI bridge, secondary bus 0000:02
[    0.517986] pci 0000:00:06.0:   IO window: 0xe000-0xefff
[    0.517988] pci 0000:00:06.0:   MEM window: 0xfbf00000-0xfbffffff
[    0.517990] pci 0000:00:06.0:   PREFETCH window: disabled
[    0.517993] pci 0000:00:14.4: PCI bridge, secondary bus 0000:03
[    0.517994] pci 0000:00:14.4:   IO window: disabled
[    0.517998] pci 0000:00:14.4:   MEM window: disabled
[    0.518001] pci 0000:00:14.4:   PREFETCH window: disabled
[    0.518011]   alloc irq_desc for 18 on cpu 0 node 0
[    0.518013]   alloc kstat_irqs on cpu 0 node 0
[    0.518016] pci 0000:00:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.518018] pci 0000:00:06.0: setting latency timer to 64
[    0.518024] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.518026] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.518027] pci_bus 0000:01: resource 0 io:  [0xd000-0xdfff]
[    0.518029] pci_bus 0000:01: resource 1 mem: [0xfbd00000-0xfbefffff]
[    0.518030] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.518032] pci_bus 0000:02: resource 0 io:  [0xe000-0xefff]
[    0.518033] pci_bus 0000:02: resource 1 mem: [0xfbf00000-0xfbffffff]
[    0.518035] pci_bus 0000:03: resource 3 io:  [0x00-0xffff]
[    0.518037] pci_bus 0000:03: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.518108] NET: Registered protocol family 2
[    0.576402] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.577314] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.579100] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.579328] TCP: Hash tables configured (established 524288 bind 65536)
[    0.579329] TCP reno registered
[    0.608323] NET: Registered protocol family 1
[    0.608359] Trying to unpack rootfs image as initramfs...
[    0.717788] Freeing initrd memory: 7588k freed
[    0.720648] audit: initializing netlink socket (disabled)
[    0.720659] type=2000 audit(1252659046.720:1): initialized
[    0.721097] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.721215] VFS: Disk quotas dquot_6.5.2
[    0.721238] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.721273] msgmni has been set to 15507
[    0.721408] alg: No test for stdrng (krng)
[    0.721462] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.721464] io scheduler noop registered
[    0.721465] io scheduler anticipatory registered
[    0.721466] io scheduler deadline registered
[    0.721483] io scheduler cfq registered (default)
[    0.868259] pci 0000:01:05.0: Boot video device
[    0.868395]   alloc irq_desc for 25 on cpu 0 node 0
[    0.868397]   alloc kstat_irqs on cpu 0 node 0
[    0.868403] pcieport-driver 0000:00:06.0: irq 25 for MSI/MSI-X
[    0.868409] pcieport-driver 0000:00:06.0: setting latency timer to 64
[    0.870879] Linux agpgart interface v0.103
[    0.870881] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.870995] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.871325] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.872473] brd: module loaded
[    0.872532] input: Macintosh mouse button emulation as /devices/virtual/input/input0
[    0.872662] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.872664] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.872755] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.872842] mice: PS/2 mouse device common for all mice
[    0.872881] rtc_cmos 00:03: RTC can wake from S4
[    0.872911] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.872933] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.872953] cpuidle: using governor ladder
[    0.872954] cpuidle: using governor menu
[    0.872957] No iBFT detected.
[    0.873174] TCP cubic registered
[    0.873221] NET: Registered protocol family 10
[    0.873512] lo: Disabled Privacy Extensions
[    0.873695] Mobile IPv6
[    0.873697] NET: Registered protocol family 17
[    0.873798] registered taskstats version 1
[    0.873912] rtc_cmos 00:03: setting system clock to 2009-09-11 08:50:47 UTC (1252659047)
[    0.873944] Freeing unused kernel memory: 560k freed
[    0.874068] Write protecting the kernel read-only data: 3812k
[    0.889125] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    0.943988] Floppy drive(s): fd0 is 1.44M
[    0.947547] ATL1E 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.947556] ATL1E 0000:02:00.0: setting latency timer to 64
[    0.955809] SCSI subsystem initialized
[    0.960337] Uniform Multi-Platform E-IDE driver
[    0.961255] FDC 0 is a post-1991 82077
[    0.961259] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.961310]   alloc irq_desc for 17 on cpu 0 node 0
[    0.961311]   alloc kstat_irqs on cpu 0 node 0
[    0.961317] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.961341] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    0.961402] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    0.961442] ehci_hcd 0000:00:12.2: debug port 1
[    0.961457] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfbcff800
[    0.970101] libata version 3.00 loaded.
[    0.970488] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.976040] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    0.976056] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.976058] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.976059] usb usb1: Product: EHCI Host Controller
[    0.976061] usb usb1: Manufacturer: Linux 2.6.30-1-amd64 ehci_hcd
[    0.976062] usb usb1: SerialNumber: 0000:00:12.2
[    0.976115] usb usb1: configuration #1 chosen from 1 choice
[    0.976133] hub 1-0:1.0: USB hub found
[    0.976138] hub 1-0:1.0: 6 ports detected
[    0.976265] atiixp 0000:00:14.1: IDE controller (0x1002:0x439c rev 0x00)
[    0.976274]   alloc irq_desc for 16 on cpu 0 node 0
[    0.976275]   alloc kstat_irqs on cpu 0 node 0
[    0.976280] ATIIXP_IDE 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.976293] atiixp 0000:00:14.1: not 100% native mode: will probe irqs later
[    0.976297]     ide0: BM-DMA at 0xff00-0xff07
[    0.976302] atiixp 0000:00:14.1: simplex device: DMA disabled
[    0.976304] ide1: DMA disabled
[    0.976305] Probing IDE interface ide0...
[    2.048254] hdb: TOSHIBA DVD-ROM SD-M1612, ATAPI CD/DVD-ROM drive
[    2.048285] hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    2.048777] hdb: UDMA/33 mode selected
[    2.049359] Probing IDE interface ide1...
[    2.616283] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    2.624641] ide1 at 0x170-0x177,0x376 on irq 15
[    2.624825] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.624856] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    2.624903] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 2
[    2.624926] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfbcfd000
[    2.684250] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.684252] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.684254] usb usb2: Product: OHCI Host Controller
[    2.684255] usb usb2: Manufacturer: Linux 2.6.30-1-amd64 ohci_hcd
[    2.684256] usb usb2: SerialNumber: 0000:00:12.0
[    2.684293] usb usb2: configuration #1 chosen from 1 choice
[    2.684310] hub 2-0:1.0: USB hub found
[    2.684318] hub 2-0:1.0: 3 ports detected
[    2.684497] ahci 0000:00:11.0: version 3.0
[    2.684507]   alloc irq_desc for 22 on cpu 0 node 0
[    2.684509]   alloc kstat_irqs on cpu 0 node 0
[    2.684513] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    2.684549]   alloc irq_desc for 26 on cpu 0 node 0
[    2.684550]   alloc kstat_irqs on cpu 0 node 0
[    2.684559] ahci 0000:00:11.0: irq 26 for MSI/MSI-X
[    2.684651] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    2.684654] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
[    2.684924] scsi0 : ahci
[    2.685045] scsi1 : ahci
[    2.685104] scsi2 : ahci
[    2.685160] scsi3 : ahci
[    2.685215] scsi4 : ahci
[    2.685272] scsi5 : ahci
[    2.685350] ata1: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffd00 irq 26
[    2.685353] ata2: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffd80 irq 26
[    2.685355] ata3: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffe00 irq 26
[    2.685358] ata4: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffe80 irq 26
[    2.685360] ata5: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcfff00 irq 26
[    2.685363] ata6: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcfff80 irq 26
[    2.685488]   alloc irq_desc for 19 on cpu 0 node 0
[    2.685490]   alloc kstat_irqs on cpu 0 node 0
[    2.685493] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.685504] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    2.685542] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 3
[    2.685571] ehci_hcd 0000:00:13.2: debug port 1
[    2.685583] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfbcff400
[    2.696251] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    2.696261] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    2.696263] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.696264] usb usb3: Product: EHCI Host Controller
[    2.696266] usb usb3: Manufacturer: Linux 2.6.30-1-amd64 ehci_hcd
[    2.696267] usb usb3: SerialNumber: 0000:00:13.2
[    2.696295] usb usb3: configuration #1 chosen from 1 choice
[    2.696310] hub 3-0:1.0: USB hub found
[    2.696315] hub 3-0:1.0: 6 ports detected
[    2.696624] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.696634] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    2.696675] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    2.696690] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfbcfe000
[    2.756242] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.756244] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.756245] usb usb4: Product: OHCI Host Controller
[    2.756246] usb usb4: Manufacturer: Linux 2.6.30-1-amd64 ohci_hcd
[    2.756247] usb usb4: SerialNumber: 0000:00:12.1
[    2.756275] usb usb4: configuration #1 chosen from 1 choice
[    2.756291] hub 4-0:1.0: USB hub found
[    2.756298] hub 4-0:1.0: 3 ports detected
[    2.756472] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.756482] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    2.756517] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    2.756536] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfbcfb000
[    2.816247] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.816249] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.816251] usb usb5: Product: OHCI Host Controller
[    2.816252] usb usb5: Manufacturer: Linux 2.6.30-1-amd64 ohci_hcd
[    2.816253] usb usb5: SerialNumber: 0000:00:13.0
[    2.816287] usb usb5: configuration #1 chosen from 1 choice
[    2.816303] hub 5-0:1.0: USB hub found
[    2.816309] hub 5-0:1.0: 3 ports detected
[    2.816487] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.816498] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    2.816533] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    2.816547] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfbcfc000
[    2.876248] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    2.876250] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.876251] usb usb6: Product: OHCI Host Controller
[    2.876252] usb usb6: Manufacturer: Linux 2.6.30-1-amd64 ohci_hcd
[    2.876253] usb usb6: SerialNumber: 0000:00:13.1
[    2.876284] usb usb6: configuration #1 chosen from 1 choice
[    2.876301] hub 6-0:1.0: USB hub found
[    2.876307] hub 6-0:1.0: 3 ports detected
[    2.876594] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.876606] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    2.876641] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[    2.876656] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfbcfa000
[    2.936245] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    2.936247] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.936248] usb usb7: Product: OHCI Host Controller
[    2.936249] usb usb7: Manufacturer: Linux 2.6.30-1-amd64 ohci_hcd
[    2.936251] usb usb7: SerialNumber: 0000:00:14.5
[    2.936285] usb usb7: configuration #1 chosen from 1 choice
[    2.936301] hub 7-0:1.0: USB hub found
[    2.936307] hub 7-0:1.0: 2 ports detected
[    3.005776] ata2: SATA link down (SStatus 0 SControl 300)
[    3.005800] ata6: SATA link down (SStatus 0 SControl 300)
[    3.005822] ata5: SATA link down (SStatus 0 SControl 300)
[    3.005843] ata4: SATA link down (SStatus 0 SControl 300)
[    3.088257] usb 4-2: new low speed USB device using ohci_hcd and address 2
[    3.168262] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.168281] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.175137] ata3.00: ATA-7: SAMSUNG HD103SI, 1AG01118, max UDMA7
[    3.175139] ata3.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    3.175154] ata1.00: ATA-7: SAMSUNG HD103SI, 1AG01118, max UDMA7
[    3.175156] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    3.182364] ata1.00: configured for UDMA/133
[    3.182379] ata3.00: configured for UDMA/133
[    3.196312] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD103SI  1AG0 PQ: 0 ANSI: 5
[    3.196416] scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD103SI  1AG0 PQ: 0 ANSI: 5
[    3.200547] ide-cd driver 5.00
[    3.202162] ide-cd: hdb: ATAPI 48X DVD-ROM drive, 512kB Cache
[    3.202165] Uniform CD-ROM driver Revision: 3.20
[    3.205340] Driver 'sd' needs updating - please use bus_type methods
[    3.205439] sd 0:0:0:0: [sda] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
[    3.205444] sd 2:0:0:0: [sdb] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
[    3.205448] sd 0:0:0:0: [sda] Write Protect is off
[    3.205450] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.205454] sd 2:0:0:0: [sdb] Write Protect is off
[    3.205456] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.205461] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.205466] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.205539]  sda:<6> sdb: sdb1 sdb2 < sda1 sda2 < sda5 > sda3 sda4
[    3.239815]  sdb5 > sdb3
[    3.250606] sd 2:0:0:0: [sdb] Attached SCSI disk
[    3.254632] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.258260] usb 4-2: New USB device found, idVendor=046d, idProduct=c404
[    3.258262] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.258264] usb 4-2: Product: Trackball
[    3.258265] usb 4-2: Manufacturer: Logitech
[    3.258311] usb 4-2: configuration #1 chosen from 1 choice
[    3.264216] usbcore: registered new interface driver hiddev
[    3.270662] input: Logitech Trackball as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.0/input/input2
[    3.270694] generic-usb 0003:046D:C404.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech Trackball] on usb-0000:00:12.1-2/input0
[    3.270704] usbcore: registered new interface driver usbhid
[    3.270706] usbhid: v2.6:USB HID core driver
[    3.580175] kjournald starting.  Commit interval 5 seconds
[    3.580184] EXT3-fs: mounted filesystem with ordered data mode.
[    4.458039] udev: starting version 141
[    4.909210] ACPI: WMI: Mapper loaded
[    4.914686] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[    4.917684] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    4.917709] ACPI: Power Button [PWRF]
[    4.917760] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4
[    4.917775] ACPI: Power Button [PWRB]
[    4.942731] processor ACPI_CPU:00: registered as cooling_device0
[    4.942735] ACPI: Processor [P001] (supports 8 throttling states)
[    4.943126] processor ACPI_CPU:01: registered as cooling_device1
[    4.943507] processor ACPI_CPU:02: registered as cooling_device2
[    4.943881] processor ACPI_CPU:03: registered as cooling_device3
[    4.945020] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.945260] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    5.004048] shpchp 0000:00:01.0: HPC vendor_id 1022 device_id 9602 ss_vid 0 ss_did 0
[    5.004051] shpchp 0000:00:01.0: Cannot reserve MMIO region
[    5.004098] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    5.229737] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.288712] HDA Intel 0000:01:05.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    5.288733] HDA Intel 0000:01:05.1: setting latency timer to 64
[    5.885748] EXT3 FS on sda4, internal journal
[    5.952118] it87: Found IT8720F chip at 0x290, revision 2
[    5.952125] it87: in3 is VCC (+5V)
[    5.952126] it87: in7 is VCCH (+5V Stand-By)
[    7.054111]   alloc irq_desc for 27 on cpu 0 node 0
[    7.054113]   alloc kstat_irqs on cpu 0 node 0
[    7.054125] ATL1E 0000:02:00.0: irq 27 for MSI/MSI-X
[    7.054243] ATL1E 0000:02:00.0: ATL1E: eth0 NIC Link is Up<100 Mbps Full Duplex>
[    7.054974] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    7.055707] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    7.107242] powernow-k8: Found 1 AMD Phenom(tm) II X4 955 Processor processors (4 cpu cores) (version 2.20.00)
[    7.107284] powernow-k8:    0 : pstate 0 (3200 MHz)
[    7.107286] powernow-k8:    1 : pstate 1 (2500 MHz)
[    7.107287] powernow-k8:    2 : pstate 2 (2100 MHz)
[    7.107289] powernow-k8:    3 : pstate 3 (800 MHz)
[    7.676807] lp: driver loaded but no devices found
[    7.685134] ppdev: user-space parallel port driver
[   10.337210] pci 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   10.453362] [drm] Initialized drm 1.1.0 20060810
[   10.466261] pci 0000:01:05.0: setting latency timer to 64
[   10.466503] [drm] Initialized radeon 1.30.0 20080528 for 0000:01:05.0 on minor 0
[   10.816372] [drm] Setting GART location based on new memory map
[   10.816689] [drm] Loading RS780 CP Microcode
[   10.816691] platform r600_cp.0: firmware: requesting radeon/RS780_cp.bin
[   10.914434] r600_cp: Failed to load firmware "radeon/RS780_cp.bin"
[   10.914442] [drm:r600_do_init_cp] *ERROR* Failed to load firmware!
[   17.653510] eth0: no IPv6 routers present
[  282.049596] device-mapper: uevent: version 1.0.3
[  282.050101] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[  547.682886] md: md0 stopped.
[  547.685061] md: bind<sdb5>
[  547.685354] md: bind<sda5>
[  547.685365] md: md0: raid array is not clean -- starting background reconstruction
[  547.708856] md: raid1 personality registered for level 1
[  547.709757] raid1: raid set md0 active with 2 out of 2 mirrors
[  547.709901] md: resync of RAID array md0
[  547.709909] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  547.709915] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
[  547.709925] md: using 128k window, over a total of 488279488 blocks.
[  547.709930] md: resuming resync of md0 from checkpoint.
[  547.710637]  md0: unknown partition table
[ 1229.604867] kjournald starting.  Commit interval 5 seconds
[ 1229.877564] EXT3 FS on sda1, internal journal
[ 1229.877576] EXT3-fs: mounted filesystem with ordered data mode.
[ 1895.360272] kjournald starting.  Commit interval 5 seconds
[ 1895.366343] EXT3 FS on dm-0, internal journal
[ 1895.366354] EXT3-fs: mounted filesystem with ordered data mode.
[ 2280.720380] INFO: task kjournald:1168 blocked for more than 120 seconds.
[ 2280.720388] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2280.720395] kjournald     D ffff88002807a0c0     0  1168      2
[ 2280.720405]  ffff88022f19e140 0000000000000046 ffff880217bd2c28 ffff880217bc06e0
[ 2280.720415]  0000000000000086 00000000000120c0 000000000000e250 ffff88022f244280
[ 2280.720424]  ffff88022f244570 0000000200000000 0000000000000000 ffffffff8020e5a9
[ 2280.720432] Call Trace:
[ 2280.720448]  [<ffffffff8020e5a9>] ? __switch_to+0xae/0x263
[ 2280.720458]  [<ffffffff80235f09>] ? set_next_entity+0x34/0x56
[ 2280.720469]  [<ffffffff804b4500>] ? schedule+0x9/0x1d
[ 2280.720500]  [<ffffffffa012fd4e>] ? journal_commit_transaction+0x108/0xdf6 [jbd]
[ 2280.720510]  [<ffffffff8025473e>] ? autoremove_wake_function+0x0/0x2e
[ 2280.720520]  [<ffffffff8024ad47>] ? try_to_del_timer_sync+0x52/0x5b
[ 2280.720541]  [<ffffffffa01332e3>] ? kjournald+0xe4/0x229 [jbd]
[ 2280.720549]  [<ffffffff8025473e>] ? autoremove_wake_function+0x0/0x2e
[ 2280.720568]  [<ffffffffa01331ff>] ? kjournald+0x0/0x229 [jbd]
[ 2280.720585]  [<ffffffffa01331ff>] ? kjournald+0x0/0x229 [jbd]
[ 2280.720594]  [<ffffffff80254382>] ? kthread+0x54/0x80
[ 2280.720602]  [<ffffffff80210aca>] ? child_rip+0xa/0x20
[ 2280.720611]  [<ffffffff8025432e>] ? kthread+0x0/0x80
[ 2280.720617]  [<ffffffff80210ac0>] ? child_rip+0x0/0x20
[ 2280.720644] INFO: task konqueror:2948 blocked for more than 120 seconds.
[ 2280.720648] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2280.720654] konqueror     D ffff8800280940c0     0  2948   2868
[ 2280.720662]  ffff88022c50b690 0000000000000082 ffff88020dd4cc90 ffffffff802dd7f7
[ 2280.720671]  00000000ffffffff 00000000000120c0 000000000000e250 ffff88022c63a400
[ 2280.720679]  ffff88022c63a6f0 0000000310dc8748 ffff880217bd2bc0 ffff880217bd2c28
[ 2280.720687] Call Trace:
[ 2280.720695]  [<ffffffff802dd7f7>] ? __find_get_block+0x176/0x186
[ 2280.720705]  [<ffffffff80215db6>] ? read_tsc+0xa/0x20
[ 2280.720712]  [<ffffffff802de217>] ? sync_buffer+0x0/0x40
[ 2280.720719]  [<ffffffff804b4500>] ? schedule+0x9/0x1d
[ 2280.720727]  [<ffffffff804b4577>] ? io_schedule+0x63/0xa5
[ 2280.720734]  [<ffffffff802de252>] ? sync_buffer+0x3b/0x40
[ 2280.720742]  [<ffffffff804b488c>] ? __wait_on_bit+0x41/0x70
[ 2280.720748]  [<ffffffff802de217>] ? sync_buffer+0x0/0x40
[ 2280.720757]  [<ffffffff804b4926>] ? out_of_line_wait_on_bit+0x6b/0x77
[ 2280.720764]  [<ffffffff8025476c>] ? wake_bit_function+0x0/0x23
[ 2280.720793]  [<ffffffffa0148034>] ? ext3_find_entry+0x3aa/0x558 [ext3]
[ 2280.720802]  [<ffffffff802bb130>] ? kmem_getpages+0xdc/0x12b
[ 2280.720809]  [<ffffffff802bbb8f>] ? cache_alloc_refill+0x6d/0x1f9
[ 2280.720837]  [<ffffffffa0148a2c>] ? ext3_lookup+0x30/0xe4 [ext3]
[ 2280.720845]  [<ffffffff802c816d>] ? __lookup_hash+0xc6/0xe7
[ 2280.720853]  [<ffffffff802ca2e6>] ? do_filp_open+0x1e2/0x85a
[ 2280.720862]  [<ffffffff802d2e24>] ? alloc_fd+0x67/0x10c
[ 2280.720869]  [<ffffffff802bf2ad>] ? do_sys_open+0x4b/0xc8
[ 2280.720878]  [<ffffffff8020fa42>] ? system_call_fastpath+0x16/0x1b
[ 2280.720891] INFO: task groupadd:10911 blocked for more than 120 seconds.
[ 2280.720895] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2280.720900] groupadd      D ffff88002807a0c0     0 10911  10910
[ 2280.720908]  ffff88022f171510 0000000000000086 ffff88022ac8f978 00000000000e0201
[ 2280.720916]  ffff88022ac0e610 00000000000120c0 000000000000e250 ffff88022b50e300
[ 2280.720924]  ffff88022b50e5f0 000000022b42ac48 ffff88022e8ef200 0000000000000000
[ 2280.720932] Call Trace:
[ 2280.720940]  [<ffffffff80215db6>] ? read_tsc+0xa/0x20
[ 2280.720947]  [<ffffffff802de217>] ? sync_buffer+0x0/0x40
[ 2280.720955]  [<ffffffff804b4500>] ? schedule+0x9/0x1d
[ 2280.720962]  [<ffffffff804b4577>] ? io_schedule+0x63/0xa5
[ 2280.720969]  [<ffffffff802de252>] ? sync_buffer+0x3b/0x40
[ 2280.720977]  [<ffffffff804b478f>] ? __wait_on_bit_lock+0x3f/0x84
[ 2280.720984]  [<ffffffff802de217>] ? sync_buffer+0x0/0x40
[ 2280.720992]  [<ffffffff804b483f>] ? out_of_line_wait_on_bit_lock+0x6b/0x77
[ 2280.720999]  [<ffffffff8025476c>] ? wake_bit_function+0x0/0x23
[ 2280.721021]  [<ffffffff802dd7f7>] ? __find_get_block+0x176/0x186
[ 2280.721042]  [<ffffffffa012f042>] ? do_get_write_access+0x6a/0x409 [jbd]
[ 2280.721055]  [<ffffffff802dd825>] ? __getblk+0x1e/0x295
[ 2280.721079]  [<ffffffffa012f403>] ? journal_get_write_access+0x22/0x33 [jbd]
[ 2280.721115]  [<ffffffffa014f281>] ? __ext3_journal_get_write_access+0x1e/0x47 [ext3]
[ 2280.721146]  [<ffffffffa01431a8>] ? ext3_reserve_inode_write+0x3e/0x75 [ext3]
[ 2280.721177]  [<ffffffffa01431f5>] ? ext3_mark_inode_dirty+0x16/0x31 [ext3]
[ 2280.721208]  [<ffffffffa014923b>] ? ext3_rename+0x486/0x555 [ext3]
[ 2280.721221]  [<ffffffff802c9b64>] ? vfs_rename+0x215/0x36e
[ 2280.721233]  [<ffffffff802cad57>] ? sys_renameat+0x16d/0x1e9
[ 2280.721246]  [<ffffffff802c407d>] ? sys_newlstat+0x23/0x30
[ 2280.721260]  [<ffffffff8020fa42>] ? system_call_fastpath+0x16/0x1b
[ 2640.720039] INFO: task pdflush:262 blocked for more than 120 seconds.
[ 2640.720047] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2640.720054] pdflush       D ffff8800280600c0     0   262      2
[ 2640.720063]  ffff88022f1614d0 0000000000000046 ffffe2000523e358 ffffe2000523e3c8
[ 2640.720073]  ffffe20006021fd8 00000000000120c0 000000000000e250 ffff88022f26c340
[ 2640.720082]  ffff88022f26c630 00000001296df738 0000000000000008 ffff8802296df738
[ 2640.720091] Call Trace:
[ 2640.720108]  [<ffffffff8020e5a9>] ? __switch_to+0xae/0x263
[ 2640.720120]  [<ffffffff804b4ad5>] ? __mutex_lock_common+0x10f/0x17f
[ 2640.720130]  [<ffffffff804b4944>] ? mutex_lock+0x12/0x28
[ 2640.720139]  [<ffffffff802c23c1>] ? sync_supers+0x42/0xa6
[ 2640.720147]  [<ffffffff802987f3>] ? wb_kupdate+0x2f/0x121
[ 2640.720156]  [<ffffffff802994d7>] ? pdflush+0x159/0x23b
[ 2640.720164]  [<ffffffff802987c4>] ? wb_kupdate+0x0/0x121
[ 2640.720171]  [<ffffffff8029937e>] ? pdflush+0x0/0x23b
[ 2640.720181]  [<ffffffff80254382>] ? kthread+0x54/0x80
[ 2640.720188]  [<ffffffff80210aca>] ? child_rip+0xa/0x20
[ 2640.720197]  [<ffffffff8025432e>] ? kthread+0x0/0x80
[ 2640.720203]  [<ffffffff80210ac0>] ? child_rip+0x0/0x20
[ 2640.720213] INFO: task kjournald:1168 blocked for more than 120 seconds.
[ 2640.720217] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2640.720222] kjournald     D ffff8800280940c0     0  1168      2
[ 2640.720230]  ffff88022c50b690 0000000000000046 000000002b037ca0 0000000000000001
[ 2640.720239]  ffff8802111b9200 00000000000120c0 000000000000e250 ffff88022f244280
[ 2640.720248]  ffff88022f244570 0000000300000001 ffff88022e91f370 ffffffff8025b4d5
[ 2640.720256] Call Trace:
[ 2640.720265]  [<ffffffff8025b4d5>] ? getnstimeofday+0x55/0xaf
[ 2640.720273]  [<ffffffff802573be>] ? ktime_get_ts+0x21/0x49
[ 2640.720281]  [<ffffffff80215db6>] ? read_tsc+0xa/0x20
[ 2640.720289]  [<ffffffff802de217>] ? sync_buffer+0x0/0x40
[ 2640.720297]  [<ffffffff804b4500>] ? schedule+0x9/0x1d
[ 2640.720304]  [<ffffffff804b4577>] ? io_schedule+0x63/0xa5
[ 2640.720311]  [<ffffffff802de252>] ? sync_buffer+0x3b/0x40
[ 2640.720319]  [<ffffffff804b488c>] ? __wait_on_bit+0x41/0x70
[ 2640.720326]  [<ffffffff802de217>] ? sync_buffer+0x0/0x40
[ 2640.720334]  [<ffffffff804b4926>] ? out_of_line_wait_on_bit+0x6b/0x77
[ 2640.720341]  [<ffffffff8025476c>] ? wake_bit_function+0x0/0x23
[ 2640.720372]  [<ffffffffa013053b>] ? journal_commit_transaction+0x8f5/0xdf6 [jbd]
[ 2640.720383]  [<ffffffff8024accf>] ? lock_timer_base+0x26/0x4c
[ 2640.720405]  [<ffffffffa01332e3>] ? kjournald+0xe4/0x229 [jbd]
[ 2640.720412]  [<ffffffff8025473e>] ? autoremove_wake_function+0x0/0x2e
[ 2640.720431]  [<ffffffffa01331ff>] ? kjournald+0x0/0x229 [jbd]
[ 2640.720449]  [<ffffffffa01331ff>] ? kjournald+0x0/0x229 [jbd]
[ 2640.720457]  [<ffffffff80254382>] ? kthread+0x54/0x80
[ 2640.720464]  [<ffffffff80210aca>] ? child_rip+0xa/0x20
[ 2640.720473]  [<ffffffff8025432e>] ? kthread+0x0/0x80
[ 2640.720480]  [<ffffffff80210ac0>] ? child_rip+0x0/0x20
[ 2640.720494] INFO: task Xorg:2614 blocked for more than 120 seconds.
[ 2640.720499] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2640.720503] Xorg          D ffff8800280940c0     0  2614   2598
[ 2640.720511]  ffff88022c50b690 0000000000000086 ffff88022d1b3978 000000000003d08f
[ 2640.720519]  0000000000000282 00000000000120c0 000000000000e250 ffff88022e90a2c0
[ 2640.720528]  ffff88022e90a5b0 000000032d1b3978 ffff88022d1b3d48 ffffffff80256fa5
[ 2640.720535] Call Trace:
[ 2640.720543]  [<ffffffff80256fa5>] ? hrtimer_cancel+0xc/0x16
[ 2640.720551]  [<ffffffff804b4c9b>] ? schedule_hrtimeout_range+0xc8/0xf3
[ 2640.720560]  [<ffffffff80215db6>] ? read_tsc+0xa/0x20
[ 2640.720567]  [<ffffffff802de217>] ? sync_buffer+0x0/0x40
[ 2640.720574]  [<ffffffff804b4500>] ? schedule+0x9/0x1d
[ 2640.720582]  [<ffffffff804b4577>] ? io_schedule+0x63/0xa5
[ 2640.720588]  [<ffffffff802de252>] ? sync_buffer+0x3b/0x40
[ 2640.720596]  [<ffffffff804b478f>] ? __wait_on_bit_lock+0x3f/0x84
[ 2640.720603]  [<ffffffff802de217>] ? sync_buffer+0x0/0x40
[ 2640.720611]  [<ffffffff804b483f>] ? out_of_line_wait_on_bit_lock+0x6b/0x77
[ 2640.720618]  [<ffffffff8025476c>] ? wake_bit_function+0x0/0x23
[ 2640.720625]  [<ffffffff802dd7f7>] ? __find_get_block+0x176/0x186
[ 2640.720645]  [<ffffffffa012f042>] ? do_get_write_access+0x6a/0x409 [jbd]
[ 2640.720652]  [<ffffffff802dd825>] ? __getblk+0x1e/0x295
[ 2640.720661]  [<ffffffff8040b0d6>] ? __alloc_skb+0x66/0x138
[ 2640.720681]  [<ffffffffa012f403>] ? journal_get_write_access+0x22/0x33 [jbd]
[ 2640.720713]  [<ffffffffa014f281>] ? __ext3_journal_get_write_access+0x1e/0x47 [ext3]
[ 2640.720740]  [<ffffffffa01431a8>] ? ext3_reserve_inode_write+0x3e/0x75 [ext3]
[ 2640.720765]  [<ffffffffa01431f5>] ? ext3_mark_inode_dirty+0x16/0x31 [ext3]
[ 2640.720784]  [<ffffffffa012fb58>] ? journal_start+0x9a/0xce [jbd]
[ 2640.720809]  [<ffffffffa0143347>] ? ext3_dirty_inode+0x63/0x7b [ext3]
[ 2640.720819]  [<ffffffff802d9893>] ? __mark_inode_dirty+0x29/0x18a
[ 2640.720828]  [<ffffffff802d0bf1>] ? file_update_time+0xb0/0xf5
[ 2640.720836]  [<ffffffff802930ce>] ? __generic_file_aio_write_nolock+0x16e/0x293
[ 2640.720844]  [<ffffffff8029399d>] ? generic_file_aio_write+0x64/0xc4
[ 2640.720869]  [<ffffffffa0141384>] ? ext3_file_write+0x16/0x96 [ext3]
[ 2640.720877]  [<ffffffff802c0a08>] ? do_sync_write+0xce/0x113
[ 2640.720884]  [<ffffffff8025473e>] ? autoremove_wake_function+0x0/0x2e
[ 2640.720893]  [<ffffffff8025277e>] ? synchronize_rcu+0x45/0x4b
[ 2640.720901]  [<ffffffff80281785>] ? rcu_start_gp+0xdc/0x112
[ 2640.720908]  [<ffffffff802c13a1>] ? vfs_write+0xa9/0x102
[ 2640.720916]  [<ffffffff802c14b6>] ? sys_write+0x45/0x6e
[ 2640.720924]  [<ffffffff8020fa42>] ? system_call_fastpath+0x16/0x1b
[ 2640.720933] INFO: task plasma-desktop:2912 blocked for more than 120 seconds.
[ 2640.720937] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2640.720942] plasma-deskto D ffff8800280940c0     0  2912      1
[ 2640.720950]  ffff88022e90a2c0 0000000000000082 ffff88022c835e68 ffff8802294ef118
[ 2640.720958]  ffff88022947ee00 00000000000120c0 000000000000e250 ffff88022e900fe0
[ 2640.720966]  ffff88022e9012d0 00000003294ce118 ffffffff802c8532 ffff8802111fa000
[ 2640.720974] Call Trace:
[ 2640.720981]  [<ffffffff802c8532>] ? inode_permission+0x82/0xa1
[ 2640.720989]  [<ffffffff802c867c>] ? __link_path_walk+0x12b/0x70b
[ 2640.720998]  [<ffffffff804b4ad5>] ? __mutex_lock_common+0x10f/0x17f
[ 2640.721022]  [<ffffffff804b4944>] ? mutex_lock+0x12/0x28
[ 2640.721029]  [<ffffffff802ca2de>] ? do_filp_open+0x1da/0x85a
[ 2640.721043]  [<ffffffff802d2e24>] ? alloc_fd+0x67/0x10c
[ 2640.721054]  [<ffffffff802bf2ad>] ? do_sys_open+0x4b/0xc8
[ 2640.721067]  [<ffffffff8020fa42>] ? system_call_fastpath+0x16/0x1b
[ 2640.721078] INFO: task konqueror:2948 blocked for more than 120 seconds.
[ 2640.721085] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2640.721094] konqueror     D ffff8800280940c0     0  2948   2868
[ 2640.721108]  ffff88022f333590 0000000000000082 ffff88022a959e68 ffff8802294ef118
[ 2640.721128]  ffff88022947ee00 00000000000120c0 000000000000e250 ffff88022c63a400
[ 2640.721147]  ffff88022c63a6f0 00000003294ce118 ffffffff802c8532 ffff88022ccdc000
[ 2640.721166] Call Trace:
[ 2640.721177]  [<ffffffff802c8532>] ? inode_permission+0x82/0xa1
[ 2640.721188]  [<ffffffff802c867c>] ? __link_path_walk+0x12b/0x70b
[ 2640.721202]  [<ffffffff804b4ad5>] ? __mutex_lock_common+0x10f/0x17f
[ 2640.721214]  [<ffffffff804b4944>] ? mutex_lock+0x12/0x28
[ 2640.721226]  [<ffffffff802ca2de>] ? do_filp_open+0x1da/0x85a
[ 2640.721238]  [<ffffffff802d2e24>] ? alloc_fd+0x67/0x10c
[ 2640.721249]  [<ffffffff802bf2ad>] ? do_sys_open+0x4b/0xc8
[ 2640.721261]  [<ffffffff8020fa42>] ? system_call_fastpath+0x16/0x1b
[ 2640.721271] INFO: task konsole:2997 blocked for more than 120 seconds.
[ 2640.721278] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2640.721287] konsole       D ffff8800280460c0     0  2997      1
[ 2640.721300]  ffff88022e90a2c0 0000000000000082 ffff880210ddd198 ffff880210dc3678
[ 2640.721319]  0000000000000000 00000000000120c0 000000000000e250 ffff88022f2bc500
[ 2640.721338]  ffff88022f2bc7f0 00000000802dd825 ffff8802214bd118 000000010000000b
[ 2640.721357] Call Trace:
[ 2640.721369]  [<ffffffff804b4500>] ? schedule+0x9/0x1d
[ 2640.721393]  [<ffffffffa012f1e0>] ? do_get_write_access+0x208/0x409 [jbd]
[ 2640.721404]  [<ffffffff8025476c>] ? wake_bit_function+0x0/0x23
[ 2640.721417]  [<ffffffff802dd825>] ? __getblk+0x1e/0x295
[ 2640.721440]  [<ffffffffa012f403>] ? journal_get_write_access+0x22/0x33 [jbd]
[ 2640.721473]  [<ffffffffa014f281>] ? __ext3_journal_get_write_access+0x1e/0x47 [ext3]
[ 2640.721503]  [<ffffffffa0141ca9>] ? ext3_new_inode+0x4e9/0x9d9 [ext3]
[ 2640.721532]  [<ffffffffa012f98f>] ? start_this_handle+0x2cd/0x33e [jbd]
[ 2640.721565]  [<ffffffffa01487d1>] ? ext3_create+0x8f/0x10c [ext3]
[ 2640.721577]  [<ffffffff802c96b2>] ? vfs_create+0x6d/0x89
[ 2640.721589]  [<ffffffff802ca3ac>] ? do_filp_open+0x2a8/0x85a
[ 2640.721603]  [<ffffffff802bf2ad>] ? do_sys_open+0x4b/0xc8
[ 2640.721616]  [<ffffffff8020fa42>] ? system_call_fastpath+0x16/0x1b
[ 2640.721626] INFO: task xulrunner-stub:9276 blocked for more than 120 seconds.
[ 2640.721634] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2640.721642] xulrunner-stu D ffff8800280460c0     0  9276   2928
[ 2640.721656]  ffffffff805c2390 0000000000000086 ffffffff00000001 ffff88020dcbde70
[ 2640.721676]  ffff88022d0eded8 00000000000120c0 000000000000e250 ffff88022c4aade0
[ 2640.721695]  ffff88022c4ab0d0 000000000025e00a 0000000000001000 ffffffff8025465f
[ 2640.721714] Call Trace:
[ 2640.721725]  [<ffffffff8025465f>] ? bit_waitqueue+0x10/0xa0
[ 2640.721735]  [<ffffffff8025472d>] ? wake_up_bit+0x11/0x22
[ 2640.721746]  [<ffffffff8025465f>] ? bit_waitqueue+0x10/0xa0
[ 2640.721758]  [<ffffffff804b4500>] ? schedule+0x9/0x1d
[ 2640.721781]  [<ffffffffa012f1e0>] ? do_get_write_access+0x208/0x409 [jbd]
[ 2640.721793]  [<ffffffff8025476c>] ? wake_bit_function+0x0/0x23
[ 2640.721816]  [<ffffffffa012f403>] ? journal_get_write_access+0x22/0x33 [jbd]
[ 2640.721850]  [<ffffffffa014f281>] ? __ext3_journal_get_write_access+0x1e/0x47 [ext3]
[ 2640.721882]  [<ffffffffa0148cd3>] ? ext3_orphan_add+0x7c/0x15e [ext3]
[ 2640.721912]  [<ffffffffa0143207>] ? ext3_mark_inode_dirty+0x28/0x31 [ext3]
[ 2640.721944]  [<ffffffffa0149633>] ? ext3_unlink+0x166/0x1b4 [ext3]
[ 2640.721956]  [<ffffffff802c9852>] ? vfs_unlink+0x72/0xb2
[ 2640.721968]  [<ffffffff802cae92>] ? do_unlinkat+0xad/0x134
[ 2640.721980]  [<ffffffff802bf18e>] ? filp_close+0x5b/0x62
[ 2640.721993]  [<ffffffff8020fa42>] ? system_call_fastpath+0x16/0x1b
[ 7671.134661] md: md0: resync done.
[ 7671.262254] RAID1 conf printout:
[ 7671.262261]  --- wd:2 rd:2
[ 7671.262267]  disk 0, wo:0, o:1, dev:sda5
[ 7671.262273]  disk 1, wo:0, o:1, dev:sdb5

--Boundary-00=_PxdcLLcKvNKr0Kp
Content-Type: text/x-mpsub;
  charset="UTF-8";
  name="config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.33-rc7
# Mon Feb  8 23:54:37 2010
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
# CONFIG_TREE_RCU is not set
CONFIG_TREE_PREEMPT_RCU=y
# CONFIG_TINY_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_CGROUP_MEM_RES_CTLR is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_SLOW_WORK=y
# CONFIG_SLOW_WORK_DEBUG is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEBUG_CFQ_IOSCHED is not set
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_SPARSE_IRQ is not set
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
# CONFIG_XEN is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
CONFIG_MK8=y
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=7
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_STATS=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_IOMMU_API=y
CONFIG_NR_CPUS=4
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
# CONFIG_I8K is not set
CONFIG_MICROCODE=m
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
# CONFIG_K8_NUMA is not set
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=4
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION_NVS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION="/dev/sda3"
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_POWER_METER=m
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=m
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=m
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_DMAR=y
CONFIG_DMAR_DEFAULT_ON=y
CONFIG_DMAR_FLOPPY_WA=y
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
# CONFIG_PCIEAER_INJECT is not set
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_LEGACY is not set
CONFIG_PCI_STUB=m
CONFIG_HT_IRQ=y
CONFIG_PCI_IOV=y
CONFIG_PCI_IOAPIC=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
CONFIG_IP_MROUTE=y
# CONFIG_IP_PIMSM_V1 is not set
# CONFIG_IP_PIMSM_V2 is not set
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
# CONFIG_NF_CONNTRACK is not set
# CONFIG_NETFILTER_TPROXY is not set
CONFIG_NETFILTER_XTABLES=m
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
CONFIG_NETFILTER_XT_TARGET_HL=m
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_TRACE is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_NETFILTER_XT_MATCH_PHYSDEV is not set
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
CONFIG_IP_VS=m
# CONFIG_IP_VS_IPV6 is not set
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
# CONFIG_IP_VS_PROTO_TCP is not set
# CONFIG_IP_VS_PROTO_UDP is not set
# CONFIG_IP_VS_PROTO_ESP is not set
# CONFIG_IP_VS_PROTO_AH is not set

#
# IPVS scheduler
#
# CONFIG_IP_VS_RR is not set
# CONFIG_IP_VS_WRR is not set
# CONFIG_IP_VS_LC is not set
# CONFIG_IP_VS_WLC is not set
# CONFIG_IP_VS_LBLC is not set
# CONFIG_IP_VS_LBLCR is not set
# CONFIG_IP_VS_DH is not set
# CONFIG_IP_VS_SH is not set
# CONFIG_IP_VS_SED is not set
# CONFIG_IP_VS_NQ is not set

#
# IPVS application helper
#

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
# CONFIG_BT_HCIBTSDIO is not set
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIVHCI=m
# CONFIG_BT_MRVL is not set
# CONFIG_AF_RXRPC is not set
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_PRIV=y
# CONFIG_CFG80211 is not set
CONFIG_WIRELESS_EXT_SYSFS=y
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE="radeon/R600_rlc.bin"
CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_TIFM_CORE=m
CONFIG_CB710_CORE=m
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=m
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
# CONFIG_BLK_DEV_IDECD is not set
# CONFIG_BLK_DEV_IDETAPE is not set
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
CONFIG_BLK_DEV_PLATFORM=m
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set

#
# PCI IDE chipsets support
#
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
# CONFIG_BLK_DEV_IDEDMA is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=m
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATP867X is not set
CONFIG_PATA_ATIIXP=m
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
# CONFIG_MD_LINEAR is not set
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=y
# CONFIG_MD_RAID10 is not set
CONFIG_MD_RAID456=m
# CONFIG_MULTICORE_RAID456 is not set
CONFIG_MD_RAID6_PQ=m
# CONFIG_ASYNC_RAID6_TEST is not set
CONFIG_MD_MULTIPATH=m
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# The newer stack is recommended.
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
CONFIG_VETH=m
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=m
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=m
# CONFIG_TYPHOON is not set
# CONFIG_ETHOC is not set
# CONFIG_DNET is not set
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
# CONFIG_NET_PCI is not set
# CONFIG_B44 is not set
# CONFIG_KS8842 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
CONFIG_ATL1E=m
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set
CONFIG_WLAN=y
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
CONFIG_USB_ZD1201=m
# CONFIG_HOSTAP is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=m
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
# CONFIG_PPP_MPPE is not set
# CONFIG_PPPOE is not set
# CONFIG_PPPOL2TP is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=m
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_VIRTIO_NET is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1920
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=1200
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_USB_WACOM=m
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_WINBOND_CIR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=m
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=m
CONFIG_SERIAL_8250_PNP=m
CONFIG_SERIAL_8250_NR_UARTS=2
CONFIG_SERIAL_8250_RUNTIME_UARTS=2
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=m
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=m
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_LIS3_I2C is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ATK0110=m
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_THERMAL=m
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_88PM8607 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_BQ24022 is not set
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
# CONFIG_DVB_CORE is not set
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_IR_CORE=m
CONFIG_VIDEO_IR=m
# CONFIG_MEDIA_ATTACH is not set
CONFIG_MEDIA_TUNER=m
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
# CONFIG_VIDEO_VIVI is not set
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_CPIA is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_SAA5246A is not set
# CONFIG_VIDEO_SAA5249 is not set
# CONFIG_VIDEO_STRADIS is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_IVTV is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_USB_DRIVERS=y
# CONFIG_USB_VIDEO_CLASS is not set
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
# CONFIG_USB_M5602 is not set
# CONFIG_USB_STV06XX is not set
# CONFIG_USB_GL860 is not set
# CONFIG_USB_GSPCA_CONEX is not set
# CONFIG_USB_GSPCA_ETOMS is not set
# CONFIG_USB_GSPCA_FINEPIX is not set
# CONFIG_USB_GSPCA_JEILINJ is not set
# CONFIG_USB_GSPCA_MARS is not set
# CONFIG_USB_GSPCA_MR97310A is not set
# CONFIG_USB_GSPCA_OV519 is not set
# CONFIG_USB_GSPCA_OV534 is not set
# CONFIG_USB_GSPCA_PAC207 is not set
# CONFIG_USB_GSPCA_PAC7302 is not set
# CONFIG_USB_GSPCA_PAC7311 is not set
# CONFIG_USB_GSPCA_SN9C20X is not set
# CONFIG_USB_GSPCA_SONIXB is not set
# CONFIG_USB_GSPCA_SONIXJ is not set
# CONFIG_USB_GSPCA_SPCA500 is not set
# CONFIG_USB_GSPCA_SPCA501 is not set
# CONFIG_USB_GSPCA_SPCA505 is not set
# CONFIG_USB_GSPCA_SPCA506 is not set
# CONFIG_USB_GSPCA_SPCA508 is not set
# CONFIG_USB_GSPCA_SPCA561 is not set
# CONFIG_USB_GSPCA_SQ905 is not set
# CONFIG_USB_GSPCA_SQ905C is not set
# CONFIG_USB_GSPCA_STK014 is not set
# CONFIG_USB_GSPCA_STV0680 is not set
# CONFIG_USB_GSPCA_SUNPLUS is not set
# CONFIG_USB_GSPCA_T613 is not set
# CONFIG_USB_GSPCA_TV8532 is not set
# CONFIG_USB_GSPCA_VC032X is not set
# CONFIG_USB_GSPCA_ZC3XX is not set
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_HDPVR is not set
# CONFIG_VIDEO_EM28XX is not set
# CONFIG_VIDEO_CX231XX is not set
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_USB_VICAM is not set
# CONFIG_USB_IBMCAM is not set
# CONFIG_USB_KONICAWC is not set
# CONFIG_USB_QUICKCAM_MESSENGER is not set
# CONFIG_USB_ET61X251 is not set
# CONFIG_VIDEO_OVCAMCHIP is not set
# CONFIG_USB_OV511 is not set
# CONFIG_USB_SE401 is not set
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_STV680 is not set
# CONFIG_USB_ZC0301 is not set
# CONFIG_USB_PWC is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_USB_S2255 is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_GEMTEK_PCI is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_MAESTRO is not set
# CONFIG_I2C_SI4713 is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_USB_DSBR is not set
# CONFIG_RADIO_SI470X is not set
# CONFIG_USB_MR800 is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_RADIO_TEF6862 is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_TTM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=128
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
# CONFIG_SOUND_OSS_CORE is not set
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
CONFIG_SND_VIRMIDI=m
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_INPUT_JACK=y
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_NVHDMI=y
CONFIG_SND_HDA_CODEC_INTELHDMI=y
CONFIG_SND_HDA_ELD=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=30
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_USB=y
# CONFIG_SND_USB_AUDIO is not set
CONFIG_SND_USB_USX2Y=m
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=m
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=m
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_APPLE=m
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EZKEY=m
CONFIG_HID_KYE=m
CONFIG_HID_GYRATION=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LOGITECH=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_NTRIG=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TOPSEED=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=m
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
CONFIG_USB_DEBUG=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=m
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# Enable Host or Gadget support to see Inventra options
#

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
# CONFIG_USB_EZUSB is not set
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MOTOROLA is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
# CONFIG_MMC_BLOCK_BOUNCE is not set
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_PLTFM is not set
CONFIG_MMC_WBSD=m
# CONFIG_MMC_AT91 is not set
# CONFIG_MMC_ATMELMCI is not set
CONFIG_MMC_TIFM_SD=m
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
# CONFIG_LEDS_CLASS is not set

#
# LED drivers
#

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_AMD64=y
CONFIG_EDAC_AMD64_ERROR_INJECTION=y
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# TI VLYNQ
#
CONFIG_STAGING=y
# CONFIG_STAGING_EXCLUDE_BUILD is not set
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
# CONFIG_VIDEO_GO7007 is not set
# CONFIG_USB_IP_COMMON is not set
# CONFIG_PRISM2_USB is not set
# CONFIG_ECHO is not set
# CONFIG_RT2860 is not set
CONFIG_RT2870=m
# CONFIG_COMEDI is not set
# CONFIG_ASUS_OLED is not set
# CONFIG_ALTERA_PCIE_CHDMA is not set
# CONFIG_R8187SE is not set
# CONFIG_RTL8192SU is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTL8192E is not set
# CONFIG_INPUT_MIMIO is not set
# CONFIG_TRANZPORT is not set

#
# Qualcomm MSM Camera And Video
#

#
# Camera Sensor Selection
#
# CONFIG_INPUT_GPIO is not set
# CONFIG_POHMELFS is not set
# CONFIG_B3DFG is not set
# CONFIG_IDE_PHISON is not set
# CONFIG_PLAN9AUTH is not set
# CONFIG_LINE6_USB is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_NOUVEAU is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_USB_SERIAL_QUATECH_USB2 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_FB_UDL is not set
# CONFIG_HYPERV is not set
# CONFIG_VME_BUS is not set

#
# RAR Register Driver
#
# CONFIG_RAR_REGISTER is not set
# CONFIG_IIO is not set
# CONFIG_RAMZSWAP is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_STRIP is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
CONFIG_EXT4_FS=m
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=1250
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-15"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=m
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
CONFIG_NFSD=m
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
CONFIG_NFSD_V4=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=m
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
CONFIG_LATENCYTOP=y
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_INTEL_TXT is not set
# CONFIG_DEFAULT_SECURITY_SELINUX is not set
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=m
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y

--Boundary-00=_PxdcLLcKvNKr0Kp
Content-Type: text/plain;
  charset="UTF-8";
  name="lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci"

00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host Bridge
00:01.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (int gfx)
00:07.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 3)
00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller [AHCI mode]
00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller
00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller
00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3c)
00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller
00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 Controller
00:18.0 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] HyperTransport Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Miscellaneous Control
00:18.4 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Link Control
01:05.0 VGA compatible controller: ATI Technologies Inc Radeon HD 3300 Graphics
01:05.1 Audio device: ATI Technologies Inc RS780 Azalia controller
02:00.0 FireWire (IEEE 1394): VIA Technologies, Inc. Device 3403
03:06.0 Ethernet controller: 3Com Corporation 3c905C-TX/TX-M [Tornado] (rev 74)

--Boundary-00=_PxdcLLcKvNKr0Kp
Content-Type: text/plain;
  charset="UTF-8";
  name="lsusb"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lsusb"

Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 002: ID 046d:c404 Logitech, Inc. TrackMan Wheel
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 005: ID 046d:c401 Logitech, Inc. TrackMan Marble Wheel
Bus 001 Device 004: ID 046a:002d Cherry GmbH SmartTerminal XX44
Bus 001 Device 002: ID 0424:2504 Standard Microsystems Corp. USB 2.0 Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

--Boundary-00=_PxdcLLcKvNKr0Kp
Content-Type: text/plain;
  charset="UTF-8";
  name="cpuinfo"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cpuinfo"

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 16
model		: 4
model name	: AMD Phenom(tm) II X4 955 Processor
stepping	: 2
cpu MHz		: 800.000
cache size	: 512 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 4
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
bogomips	: 6423.08
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 16
model		: 4
model name	: AMD Phenom(tm) II X4 955 Processor
stepping	: 2
cpu MHz		: 800.000
cache size	: 512 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 4
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
bogomips	: 6424.47
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor	: 2
vendor_id	: AuthenticAMD
cpu family	: 16
model		: 4
model name	: AMD Phenom(tm) II X4 955 Processor
stepping	: 2
cpu MHz		: 800.000
cache size	: 512 KB
physical id	: 0
siblings	: 4
core id		: 2
cpu cores	: 4
apicid		: 2
initial apicid	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
bogomips	: 6424.41
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor	: 3
vendor_id	: AuthenticAMD
cpu family	: 16
model		: 4
model name	: AMD Phenom(tm) II X4 955 Processor
stepping	: 2
cpu MHz		: 800.000
cache size	: 512 KB
physical id	: 0
siblings	: 4
core id		: 3
cpu cores	: 4
apicid		: 3
initial apicid	: 3
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
bogomips	: 6424.47
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate


--Boundary-00=_PxdcLLcKvNKr0Kp--
