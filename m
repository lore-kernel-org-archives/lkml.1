Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbZFRVDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbZFRVDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 17:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZFRVDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 17:03:31 -0400
Received: from mx03.syneticon.net ([78.111.66.105]:58041 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbZFRVDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 17:03:30 -0400
Message-ID: <4A3AABB7.9040705@wpkg.org>
Date: Thu, 18 Jun 2009 23:03:51 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: pl2303 - usblp Oops - BUG: unable to handle kernel NULL pointer dereference
 at (null)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This oops was made with:

1. started minicom connected to /dev/ttyUSB0
2. unplugged pl2303 converter without stopping minicom
3. connected USB printer to the same port where pl2303 was connected
4. Oops



usb 5-2: USB disconnect, address 2
pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
pl2303 5-2:1.0: device disconnected
usb 1-8: new high speed USB device using ehci_hcd and address 4
usb 1-8: New USB device found, idVendor=04e8, idProduct=342e
usb 1-8: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-8: Product: SCX-4300 Series
usb 1-8: Manufacturer: Samsung
usb 1-8: SerialNumber: 1457BFFQA00445L.
usb 1-8: configuration #1 chosen from 1 choice
usblp1: USB Bidirectional printer dev 4 if 1 alt 0 proto 2 vid 0x04E8 pid 0x342E
minicom[4260]: segfault at ea00 ip 0805d38f sp bfdff650 error 6 in minicom[8048000+27000]
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<c0425d16>] _spin_lock_irqsave+0x26/0x50
*pde = 00000000
Oops: 0002 [#1] SMP
last sysfs file: /sys/module/usblp/initstate
Modules linked in: tun radeon drm usblp af_packet ipv6 binfmt_misc loop dm_mirror dm_region_hash dm_log dm_mod cpufreq_ondemand cpufreq_conservative cpufreq_powersave p4_clockmod freq_table speedstep_lib pl2303 usbserial snd_intel8x0 joydev snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device usbhid snd_pcm_oss hid snd_pcm rng_core i2c_i801 snd_timer iTCO_wdt snd_mixer_oss intel_agp i2c_core r8169 mii agpgart snd soundcore iTCO_vendor_support snd_page_alloc uhci_hcd shpchp pci_hotplug ehci_hcd button evdev pcspkr rtc_cmos sr_mod thermal processor sg usbcore ata_generic ide_pci_generic pata_acpi piix ide_gd_mod ide_core ahci ata_piix libata sd_mod scsi_mod crc_t10dif ext4 jbd2 crc16

Pid: 4260, comm: minicom Not tainted (2.6.30-1mdv #1) MS-6728
EIP: 0060:[<c0425d16>] EFLAGS: 00010046 CPU: 1
EIP is at _spin_lock_irqsave+0x26/0x50
EAX: 00000100 EBX: 00000000 ECX: 00000246 EDX: 00000000
ESI: f8b24160 EDI: f6965800 EBP: ec04dc6c ESP: ec04dc68
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process minicom (pid: 4260, ti=ec04c000 task=c3ce6200 task.ti=ec04c000)
Stack:
 88fe17d2 ec04dcb4 f8b20e04 c0598f20 c18164c0 f95ecd75 0000000a 00000001
 e2ac6400 88fe17d2 00000046 c0598f20 00000b00 88fe17d2 ec04dcb4 88fe17d2
 f6965800 f8b24160 f691e900 ec04dcec f8ad4024 e288cf80 e2ac6400 88fe17d2
Call Trace:
 [<f8b20e04>] ? pl2303_close+0x34/0x240 [pl2303]
 [<f8ad4024>] ? serial_close+0x164/0x1a0 [usbserial]
 [<c0306848>] ? tty_release_dev+0x128/0x520
 [<c01ce9e7>] ? add_partial+0x27/0x80
 [<c01d0727>] ? __slab_free+0xa7/0x2f0
 [<c0306c60>] ? tty_release+0x20/0x40
 [<c01d979e>] ? __fput+0xbe/0x1d0
 [<c01d98d4>] ? fput+0x24/0x50
 [<c01d5582>] ? filp_close+0x52/0x90
 [<c0140683>] ? put_files_struct+0x73/0xd0
 [<c014072b>] ? exit_files+0x4b/0x70
 [<c0141215>] ? do_exit+0x135/0x6f0
 [<c014be8f>] ? __dequeue_signal+0xcf/0x180
 [<c014ca1b>] ? dequeue_signal+0x3b/0x1b0
 [<c014d5e9>] ? force_sig_info+0x89/0xf0
 [<c0141815>] ? do_group_exit+0x45/0xc0
 [<c014e11c>] ? get_signal_to_deliver+0x18c/0x3d0
 [<c0428570>] ? do_page_fault+0x0/0x300
 [<c0103534>] ? do_notify_resume+0xb4/0xa20
 [<c01babee>] ? do_wp_page+0xbe/0x6d0
 [<c0424a1e>] ? do_nanosleep+0x9e/0xe0
 [<c01babee>] ? do_wp_page+0xbe/0x6d0
 [<c01bb5ef>] ? handle_mm_fault+0x3ef/0x6b0
 [<c012675b>] ? __bad_area+0x4b/0x70
 [<c012679f>] ? bad_area+0x1f/0x40
 [<c0428852>] ? do_page_fault+0x2e2/0x300
 [<c0428570>] ? do_page_fault+0x0/0x300
 [<c0104118>] ? work_notifysig+0x13/0x1b
Code: e8 10 88 d1 ff 55 89 c2 89 e5 83 ec 04 65 a1 14 00 00 00 89 45 fc 31 c0 9c 58 8d 74 26 00 89 c1 fa 90 8d 74 26 00 b8 00 01 00 00 <f0> 66 0f c1 02 38 e0 74 06 f3 90 8a 02 eb f6 8b 55 fc 65 33 15
EIP: [<c0425d16>] _spin_lock_irqsave+0x26/0x50 SS:ESP 0068:ec04dc68
CR2: 0000000000000000
---[ end trace e61074245e51cb7e ]---
Fixing recursive fault but reboot is needed!
