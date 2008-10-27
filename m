Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbYJ0T1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbYJ0T1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbYJ0T0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:26:54 -0400
Received: from mailout11.t-online.de ([194.25.134.85]:49249 "EHLO
	mailout11.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbYJ0T0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:26:53 -0400
Message-ID: <490615E9.7070607@t-online.de>
Date: Mon, 27 Oct 2008 20:26:33 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080926)
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>
Subject: 2.6.27.3, ata_piix: cannot play audio CD, "disk change detected"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ID: bHLE-YZSQhK59BnTqa1irbhZxJpdpFHF5KoaVgD3J2OMHxuAZEt5sK+zjXWe5MOQNn
X-TOI-MSGID: 20892c95-35a9-4a30-a172-d4c492932a83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

If I insert an audio CD in my sata drive to play it via grip, then
it fails. Grip does not even show the list of audio tracks, nor does
it play the CD. Instead there is a kernel message saying

[ 6730.836999] sr0: CDROM not ready yet.
[ 6732.838572] sr0: disc change detected.
[ 6783.659021] ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 6783.659034] ata4.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[ 6783.659035]          cdb 1b 00 00 00 02 00 00 00  00 00 00 00 00 00 00 00
[ 6783.659036]          res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
[ 6783.659038] ata4.00: status: { DRDY }
[ 6783.659046] ata4: hard resetting link
[ 6784.115039] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 6785.622185] ata4.00: configured for UDMA/100
[ 6785.622193] ata4: EH complete


The same CDs work fine with an USB CD drive attached to the same
PC, so this might be a sata driver issue. (BTW, stopping hal doesn't
make a difference. Data CDs work fine.)

Any idea what goes wrong here? Does grip violate the SCSI protocol
here?  Is there something I could try to help to track this down?


Regards

Harri
=======================================================================
Here is the usual lspci stuff:

00:00.0 Host bridge [0600]: Intel Corporation 82G33/G31/P35/P31 Express DRAM Controller [8086:29c0] (rev 02)
00:01.0 PCI bridge [0604]: Intel Corporation 82G33/G31/P35/P31 Express PCI Express Root Port [8086:29c1] (rev 02)
00:1a.0 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 [8086:2937] (rev 02)
00:1a.1 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 [8086:2938] (rev 02)
00:1a.2 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 [8086:2939] (rev 02)
00:1a.7 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 [8086:293c] (rev 02)
00:1b.0 Audio device [0403]: Intel Corporation 82801I (ICH9 Family) HD Audio Controller [8086:293e] (rev 02)
00:1c.0 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 [8086:2940] (rev 02)
00:1c.5 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Express Port 6 [8086:294a] (rev 02)
00:1d.0 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 [8086:2934] (rev 02)
00:1d.1 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 [8086:2935] (rev 02)
00:1d.2 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 [8086:2936] (rev 02)
00:1d.7 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 [8086:293a] (rev 02)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (rev 92)
00:1f.0 ISA bridge [0601]: Intel Corporation 82801IB (ICH9) LPC Interface Controller [8086:2918] (rev 02)
00:1f.2 IDE interface [0101]: Intel Corporation 82801IB (ICH9) 2 port SATA IDE Controller [8086:2921] (rev 02)
00:1f.3 SMBus [0c05]: Intel Corporation 82801I (ICH9 Family) SMBus Controller [8086:2930] (rev 02)
00:1f.5 IDE interface [0101]: Intel Corporation 82801I (ICH9 Family) 2 port SATA IDE Controller [8086:2926] (rev 02)
01:00.0 VGA compatible controller [0300]: nVidia Corporation G94 [GeForce 9600 GT] [10de:0622] (rev a1)
02:00.0 Ethernet controller [0200]: Attansic Technology Corp. L1 Gigabit Ethernet Adapter [1969:1048] (rev b0)


The CD/DVD drive is:

3: udi = '/org/freedesktop/Hal/devices/storage_model_CDDVDW_SH_S223F'
  storage.cdrom.hddvd = false  (bool)
  info.vendor = 'TSSTcorp'  (string)
  storage.cdrom.hddvdr = false  (bool)
  storage.cdrom.hddvdrw = false  (bool)
  storage.cdrom.mo = false  (bool)
  block.device = '/dev/scd0'  (string)
  linux.hotplug_type = 3  (0x3)  (int)
  storage.cdrom.mrw = true  (bool)
  block.major = 11  (0xb)  (int)
  storage.cdrom.mrw_w = true  (bool)
  block.minor = 0  (0x0)  (int)
  info.product = 'CDDVDW SH-S223F'  (string)
  storage.cdrom.support_media_changed = true  (bool)
  block.is_volume = false  (bool)
  storage.cdrom.support_multisession = true  (bool)
  info.udi = '/org/freedesktop/Hal/devices/storage_model_CDDVDW_SH_S223F'  (string)
  storage.bus = 'scsi'  (string)
  storage.cdrom.read_speed = 8468  (0x2114)  (int)
  storage.no_partitions_hint = true  (bool)
  storage.cdrom.write_speed = 8468  (0x2114)  (int)
  storage.media_check_enabled = true  (bool)
  org.freedesktop.Hal.Device.Storage.method_names = { 'Eject', 'CloseTray' } (string list)
  storage.automount_enabled_hint = true  (bool)
  org.freedesktop.Hal.Device.Storage.method_signatures = { 'as', 'as' } (string list)
  storage.drive_type = 'cdrom'  (string)
  org.freedesktop.Hal.Device.Storage.method_argnames = { 'extra_options', 'extra_options' } (string list)
  storage.model = 'CDDVDW SH-S223F'  (string)
  info.interfaces = { 'org.freedesktop.Hal.Device.Storage', 'org.freedesktop.Hal.Device.Storage', 'org.freedesktop.Hal.Device.Storage.Removable' } (string list)
  org.freedesktop.Hal.Device.Storage.method_execpaths = { 'hal-storage-eject', 'hal-storage-closetray' } (string list)
  storage.vendor = 'TSSTcorp'  (string)
  storage.lun = 0  (0x0)  (int)
  storage.originating_device = '/org/freedesktop/Hal/devices/computer'  (string)
  storage.removable.media_available = false  (bool)
  info.category = 'storage'  (string)
  storage.removable = true  (bool)
  info.capabilities = { 'storage', 'block', 'storage.cdrom' } (string list)
  storage.size = 0  (0x0)  (uint64)
  storage.hotpluggable = false  (bool)
  storage.removable.support_async_notification = false  (bool)
  storage.requires_eject = true  (bool)
  storage.cdrom.cdr = true  (bool)
  storage.cdrom.cdrw = true  (bool)
  storage.partitioning_scheme = ''  (string)
  storage.cdrom.dvd = true  (bool)
  block.storage_device = '/org/freedesktop/Hal/devices/storage_model_CDDVDW_SH_S223F'  (string)
  linux.sysfs_path = '/sys/block/sr0'  (string)
  storage.cdrom.dvdr = true  (bool)
  info.parent = '/org/freedesktop/Hal/devices/pci_8086_2926_scsi_host_0_scsi_device_lun0'  (string)
  storage.cdrom.dvdrw = true  (bool)
  storage.cdrom.dvdram = true  (bool)
  storage.cdrom.dvdplusr = true  (bool)
  storage.cdrom.dvdplusrw = true  (bool)
  storage.cdrom.dvdplusrwdl = false  (bool)
  storage.cdrom.dvdplusrdl = true  (bool)
  info.addons = { 'hald-addon-storage' } (string list)
  storage.cdrom.bd = false  (bool)
  storage.cdrom.bdr = false  (bool)
  storage.cdrom.bdre = false  (bool)


