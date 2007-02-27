Return-Path: <linux-kernel-owner+w=401wt.eu-S1750898AbXB0OGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750898AbXB0OGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 09:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbXB0OGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 09:06:45 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:47874 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbXB0OGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 09:06:45 -0500
Date: Tue, 27 Feb 2007 09:06:21 -0500
From: Eric Buddington <ebuddington@verizon.net>
Subject: USB misbehavior causes system hang
To: linux-kernel@vger.kernel.org
Reply-to: ebuddington@wesleyan.edu
Message-id: <20070227140610.GC6850@pool-71-123-99-133.spfdma.east.verizon.net>
Organization: ECS Labs
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-Eric-conspiracy: there is no conspiracy
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.20-mm2 #1 Mon Feb 26 13:16:04 EST 2007 i686 unknown

I have an external USB drive (WD MyBook 5000YS), which I use for backups.

When I try to back up to it, it works for a while, but inevitably
starts resetting like mad, gives I/O errors, and then (here's the
problem), the softdog module reboots the system.

---------------------------
scsi1 : SCSI emulation for USB Mass Storage devices
input: Western Digital External HDD as /class/input/input8
input: USB HID v1.11 Device [Western Digital External HDD] on usb-0000:00:03.2-6
.2
scsi 1:0:0:0: Direct-Access     WD       5000YS External  106a PQ: 0 ANSI: 4
SCSI device sda: 976773168 512-byte hdwr sectors (500108 MB)
sda: Write Protect is off
sda: assuming drive cache: write through
SCSI device sda: 976773168 512-byte hdwr sectors (500108 MB)
sda: Write Protect is off
sda: assuming drive cache: write through
 sda: sda1 sda2
sd 1:0:0:0: Attached scsi disk sda
sd 1:0:0:0: Attached scsi generic sg0 type 0
reiser4[pdflush(194)]: disable_write_barrier (fs/reiser4/wander.c:234)[zam-1055]
:
NOTICE: md1 does not support write barriers, using synchronous write instead.
reiser4: sda2: found disk format 4.0.0.

---- (works fine here for a while, then:) ----------

usb 1-6.2: reset high speed USB device using ehci_hcd and address 36
usb 1-6.2: device descriptor read/64, error -110
usb 1-6.2: device descriptor read/64, error -110
usb 1-6.2: reset high speed USB device using ehci_hcd and address 36
usb 1-6.2: device descriptor read/64, error -110
usb 1-6.2: device descriptor read/64, error -110
usb 1-6.2: reset high speed USB device using ehci_hcd and address 36
usb 1-6.2: device descriptor read/8, error -110
usb 1-6.2: device descriptor read/8, error -110
usb 1-6.2: reset high speed USB device using ehci_hcd and address 36
usb 1-6.2: device descriptor read/8, error -110
usb 1-6.2: device descriptor read/8, error -110
sd 1:0:0:0: scsi: Device offlined - not ready after error recovery
sd 1:0:0:0: SCSI error: return code = 0x00050000
end_request: I/O error, dev sda, sector 919931588
sd 1:0:0:0: rejecting I/O to offline device
sd 1:0:0:0: SCSI error: return code = 0x00010000
end_request: I/O error, dev sda, sector 919931828
sd 1:0:0:0: rejecting I/O to offline device
sd 1:0:0:0: rejecting I/O to offline device
sd 1:0:0:0: rejecting I/O to offline device
...
SoftDog: Initiating system reboot.

-----------------------------------------------------

Now, the USB problem may well be a device or cabling issue, but I
don't think that this drive failure should trigger a reboot - I assume
the drive failure is somehow constipating the entire disk I/O system,
and preventing my softdog-patting script from running.

My softdog script loops 'date >/tmp/$logfile;echo 1 > /dev/watchdog; sleep
30'. Nothing in it accesses the USB disk. /tmp is tmpfs.

Should the USB failure cause this problem?

-Eric


