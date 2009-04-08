Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbZDHFFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbZDHFFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbZDHFFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:05:30 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:3583 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbZDHFF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:05:29 -0400
Message-ID: <49DC3094.5010607@gawab.com>
Date: Tue, 07 Apr 2009 22:05:24 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: 2.6.30-rc1: OOPS on usb disk insert
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Testing out .30-rc1 and usb devises don't work. I insert my flash disk 
and get this oops.
More information (dmesg, config, etc.) at 
http://jdserver.homelinux.org/bugreports/003/

usb 5-3: new high speed USB device using ehci_hcd and address 2
usb 5-3: configuration #1 chosen from 1 choice
Initializing USB Mass Storage driver...
scsi2 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device scan complete
scsi 2:0:0:0: Direct-Access     SanDisk  Cruzer Micro     8.01 PQ: 0 
ANSI: 0 CCS
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<(null)>] (null)
*pde = 00000000
Oops: 0000 [#2] PREEMPT SMP
last sysfs file: 
/sys/devices/pci0000:00/0000:00:1e.0/0000:03:00.0/ssb0:0/net/eth0/statistics/collisions
Modules linked in: usb_storage i915 cfbcopyarea cfbimgblt cfbfillrect 
binfmt_misc acpi_cpufreq container sbs cpufreq_powersave pci_slot 
cpufreq_stats cpufreq_userspace sbshc cpufreq_conservative ext3 jbd 
mbcache firewire_sbp2 ecb cryptomgr aead pcompress crypto_blkcipher 
crypto_hash crypto_algapi dell_laptop snd_hda_codec_idt evdev iwl3945 
iwlcore rfkill sdhci_pci dcdbas video backlight rtc_cmos snd_hda_intel 
fb output sdhci rtc_core rtc_lib mac80211 snd_hda_codec snd_hwdep 
snd_pcm_oss snd_mixer_oss mmc_core psmouse snd_pcm battery ac button 
processor intel_agp snd_page_alloc reiserfs crc32 sr_mod cdrom sg 
firewire_ohci firewire_core crc_itu_t ata_piix ehci_hcd uhci_hcd usbcore 
thermal fan

Pid: 5579, comm: scsi_scan_2 Tainted: G      D    (2.6.30-rc1-git #1) 
MM061                          
EIP: 0060:[<00000000>] EFLAGS: 00010046 CPU: 0
EIP is at 0x0
EAX: f7117fb0 EBX: f7117fb0 ECX: 00000000 EDX: 00000003
ESI: b8023874 EDI: 00000000 EBP: e4432dd4 ESP: e4432dac
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process scsi_scan_2 (pid: 5579, ti=e4432000 task=ee7b3bb0 task.ti=e4432000)
Stack:
 c012a8af 00000000 00000001 00000003 c04f22d8 00000282 c04f22dc 00000005
 00000000 ee42ea20 e4432e00 c015e8b9 00000000 c0240d8d c04f22f8 f6527b00
 c02ff2d0 00000080 ffffffff f6527b00 e445c60e e4432e08 c015e93d e4432e44
Call Trace:
 [<c012a8af>] ? __wake_up+0x4f/0x80
 [<c015e8b9>] ? __async_schedule+0x139/0x1a0
 [<c0240d8d>] ? ida_pre_get+0x11d/0x150
 [<c02ff2d0>] ? sd_probe_async+0x0/0x270
 [<c015e93d>] ? async_schedule+0xd/0x10
 [<c02ff748>] ? sd_probe+0x208/0x2a0
 [<c02e6df6>] ? really_probe+0x156/0x220
 [<c02e6fbc>] ? __device_attach+0x4c/0x60
 [<c02e5b0b>] ? bus_for_each_drv+0x5b/0x80
 [<c02e6c7b>] ? device_attach+0xeb/0x110
 [<c02e6f70>] ? __device_attach+0x0/0x60
 [<c02e5a7f>] ? bus_attach_device+0x3f/0x70
 [<c02e442e>] ? device_add+0x65e/0x830
 [<c02ea8e0>] ? transport_configure+0x0/0x30
 [<c02fb3b2>] ? scsi_sysfs_add_sdev+0x62/0x2a0
 [<c0241592>] ? kobject_get+0x12/0x20
 [<c02f779d>] ? scsi_finish_async_scan+0x11d/0x160
 [<c02f9920>] ? do_scan_async+0x0/0x90
 [<c02f9978>] ? do_scan_async+0x58/0x90
 [<c02f9920>] ? do_scan_async+0x0/0x90
 [<c015558c>] ? kthread+0x3c/0x70
 [<c0155550>] ? kthread+0x0/0x70
 [<c0103f5f>] ? kernel_thread_helper+0x7/0x18
Code:  Bad EIP value.
EIP: [<00000000>] 0x0 SS:ESP 0068:e4432dac
CR2: 0000000000000000
---[ end trace fefef3dd1f6b4bd0 ]---
note: scsi_scan_2[5579] exited with preempt_count 1

Justin Madru
