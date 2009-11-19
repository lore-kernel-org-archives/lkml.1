Return-Path: <linux-kernel-owner+w=401wt.eu-S932469AbZKSDsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbZKSDsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 22:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932443AbZKSDsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 22:48:37 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:56222 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932435AbZKSDsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 22:48:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=X5KpzP65krVy5rzaYCtKmM6v9rvi1XuszNb0WU19TCfUWSYjPAcSSpT6AurM4Sw9zB
         6/tUrtlERIZWeGdUGq8Nn3qYIF6wcyFqwCAEHfpUciupuTMWvMYrdcKkalB+c3inE69V
         uZeAfhRkS/qznpWJFbRFVZRtzM03XoI3wmP2I=
MIME-Version: 1.0
Date: Thu, 19 Nov 2009 01:48:42 -0200
X-Google-Sender-Auth: 9b8b9ab63c2dcbeb
Message-ID: <2c03f9590911181948w3a9f68a3m6d55e09f537ba63c@mail.gmail.com>
Subject: Oops with 2.6.32-rc6
From: "Lucas C. Villa Real" <lucasvr@gobolinux.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I recently decided to test 2.6.32-rc6 and I noticed that, whenever too
many disk activity happens, the system crashes. The error shown in the
traces below happened about 3 times in a week.

Do you have any suggestions?

Thanks,
Lucas


Nov 16 10:37:27 (none) kernel: BUG: unable to handle kernel paging
request at 0000b2cb
Nov 16 10:37:33 (none) kernel: IP: [<c0198266>] __rmqueue+0x98/0x36c
Nov 16 10:37:33 (none) kernel: *pdpt = 0000000031dd2001 *pde = 0000000000000000
Nov 16 10:37:33 (none) kernel: Oops: 0002 [#1] PREEMPT SMP
Nov 16 10:37:33 (none) kernel: last sysfs file:
/System/Kernel/Objects/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0003:00/power_supply/ADP1/online
Nov 16 10:37:33 (none) kernel: Modules linked in: ipv6 acpi_cpufreq
snd_pcm_oss snd_mixer_oss hfsplus ndiswrapper fuse
snd_hda_codec_realtek joydev isight_firmware snd_hda_intel sky2
uvcvideo snd_hda_codec videodev firewire_ohci video output snd_hwdep
firewire_core v4l1_compat ac battery appletouch snd_pcm i2c_i801
applesmc led_class rtc_cmos thermal snd_timer processor shpchp
i2c_core button ohci1394 intel_agp iTCO_wdt rtc_core rtc_lib
input_polldev pcspkr snd snd_page_alloc iTCO_vendor_support
pci_hotplug
Nov 16 10:37:33 (none) kernel:
Nov 16 10:37:33 (none) kernel: Pid: 1724, comm: tar Tainted: P
  (2.6.32-rc6-Gobo #3) MacBook3,1
Nov 16 10:37:33 (none) kernel: EIP: 0060:[<c0198266>] EFLAGS: 00010086 CPU: 0
Nov 16 10:37:33 (none) kernel: EIP is at __rmqueue+0x98/0x36c
Nov 16 10:37:33 (none) kernel: EAX: 000001b8 EBX: c1ad1000 ECX:
0000000a EDX: 0000b2c7
Nov 16 10:37:33 (none) kernel: ESI: c0b2cf40 EDI: c0b2d22c EBP:
f0c8fc50 ESP: f0c8fc18
Nov 16 10:37:33 (none) kernel:  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Nov 16 10:37:33 (none) kernel: Process tar (pid: 1724, ti=f0c8f000
task=f307a610 task.ti=f0c8f000)
Nov 16 10:37:33 (none) kernel: Stack:
Nov 16 10:37:33 (none) kernel:  c01c909e f24c7250 00000000 00000000
00000010 00000000 c0b2d218 c0b2d21c
Nov 16 10:37:33 (none) kernel: <0> 00000002 c1ad1018 00000010 c0b2cf40
c1ae0ff8 00000000 f0c8fca4 c0199335
Nov 16 10:37:33 (none) kernel: <0> 00000000 ffffffff 0000001f 0000003c
00000000 c0b2d744 c0b2cf7c c0bd4134
Nov 16 10:37:33 (none) kernel: Call Trace:
Nov 16 10:37:33 (none) kernel:  [<c01c909e>] ? inode_get_bytes+0x48/0x54
Nov 16 10:37:33 (none) kernel:  [<c0199335>] ?
get_page_from_freelist+0x147/0x3ec
Nov 16 10:37:33 (none) kernel:  [<c01996a0>] ? __alloc_pages_nodemask+0xc6/0x480
Nov 16 10:37:33 (none) kernel:  [<c014e22f>] ? autoremove_wake_function+0x0/0x34
Nov 16 10:37:33 (none) kernel:  [<c01946fe>] ? find_get_page+0x2d/0x9f
Nov 16 10:37:33 (none) kernel:  [<c0194cdc>] ?
grab_cache_page_write_begin+0x54/0x8e
Nov 16 10:37:33 (none) kernel:  [<c0217b8b>] ? reiserfs_write_begin+0x81/0x1b2
Nov 16 10:37:33 (none) kernel:  [<c0195588>] ?
generic_file_buffered_write+0xd9/0x22f
Nov 16 10:37:33 (none) kernel:  [<c0195c2e>] ?
__generic_file_aio_write+0x3a2/0x3e3
Nov 16 10:37:33 (none) kernel:  [<c019635a>] ? generic_file_aio_read+0x4cf/0x509
Nov 16 10:37:33 (none) kernel:  [<c0195cd3>] ? generic_file_aio_write+0x64/0xab
Nov 16 10:37:33 (none) kernel:  [<c01c5eea>] ? do_sync_write+0xb0/0xeb
Nov 16 10:37:33 (none) kernel:  [<c014e22f>] ? autoremove_wake_function+0x0/0x34
Nov 16 10:37:33 (none) kernel:  [<c014e22f>] ? autoremove_wake_function+0x0/0x34
Nov 16 10:37:33 (none) kernel:  [<c01d81e9>] ? expand_files+0xe/0x201
Nov 16 10:37:33 (none) kernel:  [<c01ebbce>] ? fsnotify+0xe/0xdb
Nov 16 10:37:33 (none) kernel:  [<c021be86>] ? reiserfs_file_write+0x6e/0x77
Nov 16 10:37:33 (none) kernel:  [<c01c68f3>] ? vfs_write+0x99/0x14c
Nov 16 10:37:33 (none) kernel:  [<c021be18>] ? reiserfs_file_write+0x0/0x77
Nov 16 10:37:33 (none) kernel:  [<c01c6a62>] ? sys_write+0x48/0x75
Nov 16 10:37:33 (none) kernel:  [<c0103553>] ? sysenter_do_call+0x12/0x28
Nov 16 10:37:33 (none) kernel: Code: 39 5d f0 75 06 41 e9 a0 00 00 00
8b 55 e8 c1 e2 03 89 55 f0 01 c2 8b 94 16 24 01 00 00 89 d3 83 eb 18
89 55 ec 8b 7b 1c 8b 53 18 <89> 7a 04 89 17 c7 43 1c 00 02 20 00 c7 43
18 00 01 10 00 8b 7d
Nov 16 10:37:33 (none) kernel: EIP: [<c0198266>] __rmqueue+0x98/0x36c
SS:ESP 0068:f0c8fc18
Nov 16 10:37:33 (none) kernel: CR2: 000000000000b2cb
Nov 16 10:37:33 (none) kernel: ---[ end trace 611dcee22abb0dec ]---


Nov 16 10:37:33 (none) kernel: note: tar[1724] exited with preempt_count 2
Nov 16 10:37:33 (none) kernel: BUG: scheduling while atomic: tar/1724/0x10000003
Nov 16 10:37:33 (none) kernel: Modules linked in: ipv6 acpi_cpufreq
snd_pcm_oss snd_mixer_oss hfsplus ndiswrapper fuse
snd_hda_codec_realtek joydev isight_firmware snd_hda_intel sky2
uvcvideo snd_hda_codec videodev firewire_ohci video output snd_hwdep
firewire_core v4l1_compat ac battery appletouch snd_pcm i2c_i801
applesmc led_class rtc_cmos thermal snd_timer processor shpchp
i2c_core button ohci1394 intel_agp iTCO_wdt rtc_core rtc_lib
input_polldev pcspkr snd snd_page_alloc iTCO_vendor_support
pci_hotplug
Nov 16 10:37:33 (none) kernel: Pid: 1724, comm: tar Tainted: P      D
  2.6.32-rc6-Gobo #3
Nov 16 10:37:33 (none) kernel: Call Trace:
Nov 16 10:37:33 (none) kernel:  [<c012da92>] __schedule_bug+0x51/0x56
Nov 16 10:37:33 (none) kernel:  [<c07f0fc9>] schedule+0x9f/0x993
Nov 16 10:37:33 (none) kernel:  [<c019b750>] ? release_pages+0xe/0x165
Nov 16 10:37:33 (none) kernel:  [<c01c4463>] ? lookup_page_cgroup+0x9/0x32
Nov 16 10:37:33 (none) kernel:  [<c01c4463>] ? lookup_page_cgroup+0x9/0x32
Nov 16 10:37:33 (none) kernel:  [<c07f1a47>] ? preempt_schedule+0x8/0x49
Nov 16 10:37:33 (none) kernel:  [<c019bd73>] ? lru_add_drain+0x95/0x9b
Nov 16 10:37:33 (none) kernel:  [<c01a569f>] ? __dec_zone_state+0xe/0x87
Nov 16 10:37:33 (none) kernel:  [<c012e61e>] __cond_resched+0x1b/0x2b
Nov 16 10:37:33 (none) kernel:  [<c07f19c1>] _cond_resched+0x20/0x2b
Nov 16 10:37:33 (none) kernel:  [<c01a972c>] unmap_vmas+0x55f/0x6af
Nov 16 10:37:33 (none) kernel:  [<c019b750>] ? release_pages+0xe/0x165
Nov 16 10:37:33 (none) kernel:  [<c01ad4e4>] exit_mmap+0xaf/0x13e
Nov 16 10:37:33 (none) kernel:  [<c0135b76>] mmput+0x3a/0xb0
Nov 16 10:37:33 (none) kernel:  [<c01395bb>] exit_mm+0xea/0xf2
Nov 16 10:37:33 (none) kernel:  [<c013ae64>] do_exit+0x1b3/0x5f6
Nov 16 10:37:33 (none) kernel:  [<c07f0b7a>] ? printk+0x14/0x16
Nov 16 10:37:33 (none) kernel:  [<c07f4039>] oops_end+0xa2/0xaa
Nov 16 10:37:33 (none) kernel:  [<c011e1c0>] no_context+0x13b/0x145
Nov 16 10:37:33 (none) kernel:  [<c011e2b6>] __bad_area_nosemaphore+0xec/0xf4
Nov 16 10:37:33 (none) kernel:  [<c011e2d0>] bad_area_nosemaphore+0x12/0x15
Nov 16 10:37:33 (none) kernel:  [<c07f52a7>] do_page_fault+0x200/0x34e
Nov 16 10:37:33 (none) kernel:  [<c07f50a7>] ? do_page_fault+0x0/0x34e
Nov 16 10:37:33 (none) kernel:  [<c07f36c3>] error_code+0x73/0x78
Nov 16 10:37:33 (none) kernel:  [<c02200d8>] ? find_hash_out+0xc1/0x1dd
Nov 16 10:37:33 (none) kernel:  [<c0198266>] ? __rmqueue+0x98/0x36c
Nov 16 10:37:33 (none) kernel:  [<c01c909e>] ? inode_get_bytes+0x48/0x54
Nov 16 10:37:33 (none) kernel:  [<c0199335>] get_page_from_freelist+0x147/0x3ec
Nov 16 10:37:33 (none) kernel:  [<c01996a0>] __alloc_pages_nodemask+0xc6/0x480
Nov 16 10:37:33 (none) kernel:  [<c014e22f>] ? autoremove_wake_function+0x0/0x34
Nov 16 10:37:33 (none) kernel:  [<c01946fe>] ? find_get_page+0x2d/0x9f
Nov 16 10:37:33 (none) kernel:  [<c0194cdc>]
grab_cache_page_write_begin+0x54/0x8e
Nov 16 10:37:33 (none) kernel:  [<c0217b8b>] reiserfs_write_begin+0x81/0x1b2
Nov 16 10:37:33 (none) kernel:  [<c0195588>]
generic_file_buffered_write+0xd9/0x22f
Nov 16 10:37:33 (none) kernel:  [<c0195c2e>]
__generic_file_aio_write+0x3a2/0x3e3
Nov 16 10:37:33 (none) kernel:  [<c019635a>] ? generic_file_aio_read+0x4cf/0x509
Nov 16 10:37:33 (none) kernel:  [<c0195cd3>] generic_file_aio_write+0x64/0xab
Nov 16 10:37:33 (none) kernel:  [<c01c5eea>] do_sync_write+0xb0/0xeb
Nov 16 10:37:33 (none) kernel:  [<c014e22f>] ? autoremove_wake_function+0x0/0x34
Nov 16 10:37:33 (none) kernel:  [<c014e22f>] ? autoremove_wake_function+0x0/0x34
Nov 16 10:37:33 (none) kernel:  [<c01d81e9>] ? expand_files+0xe/0x201
Nov 16 10:37:33 (none) kernel:  [<c01ebbce>] ? fsnotify+0xe/0xdb
Nov 16 10:37:33 (none) kernel:  [<c021be86>] reiserfs_file_write+0x6e/0x77
Nov 16 10:37:33 (none) kernel:  [<c01c68f3>] vfs_write+0x99/0x14c
Nov 16 10:37:33 (none) kernel:  [<c021be18>] ? reiserfs_file_write+0x0/0x77
Nov 16 10:37:33 (none) kernel:  [<c01c6a62>] sys_write+0x48/0x75
Nov 16 10:37:33 (none) kernel:  [<c0103553>] sysenter_do_call+0x12/0x28
Nov 16 10:37:33 (none) kernel: BUG: scheduling while atomic: tar/1724/0x00000003
Nov 16 10:37:33 (none) kernel: Modules linked in: ipv6 acpi_cpufreq
snd_pcm_oss snd_mixer_oss hfsplus ndiswrapper fuse
snd_hda_codec_realtek joydev isight_firmware snd_hda_intel sky2
uvcvideo snd_hda_codec videodev firewire_ohci video output snd_hwdep
firewire_core v4l1_compat ac battery appletouch snd_pcm i2c_i801
applesmc led_class rtc_cmos thermal snd_timer processor shpchp
i2c_core button ohci1394 intel_agp iTCO_wdt rtc_core rtc_lib
input_polldev pcspkr snd snd_page_alloc iTCO_vendor_support
pci_hotplug
Nov 16 10:37:33 (none) kernel: Pid: 1724, comm: tar Tainted: P      D
  2.6.32-rc6-Gobo #3
Nov 16 10:37:33 (none) kernel: Call Trace:
Nov 16 10:37:33 (none) kernel:  [<c012da92>] __schedule_bug+0x51/0x56
Nov 16 10:37:34 (none) kernel:  [<c07f0fc9>] schedule+0x9f/0x993
Nov 16 10:37:34 (none) kernel:  [<c012422b>] ? idle_cpu+0x8/0x2a
Nov 16 10:37:34 (none) kernel:  [<c013d77d>] ? irq_exit+0x3e/0x6b
Nov 16 10:37:34 (none) kernel:  [<c0124c0e>] ? mutex_spin_on_owner+0x56/0x65
Nov 16 10:37:34 (none) kernel:  [<c07f2066>] __mutex_lock_slowpath+0xc8/0x122
Nov 16 10:37:34 (none) kernel:  [<c07f1f14>] mutex_lock+0x18/0x26
Nov 16 10:37:34 (none) kernel:  [<c021bbe7>] reiserfs_file_release+0x116/0x303
Nov 16 10:37:34 (none) kernel:  [<c01f39aa>] ? locks_remove_posix+0xc/0x8c
Nov 16 10:37:34 (none) kernel:  [<c01ebbce>] ? fsnotify+0xe/0xdb
Nov 16 10:37:34 (none) kernel:  [<c01c724d>] ? __fput+0x85/0x177
Nov 16 10:37:34 (none) kernel:  [<c01c7297>] __fput+0xcf/0x177
Nov 16 10:37:34 (none) kernel:  [<c01c7359>] fput+0x1a/0x1c
Nov 16 10:37:34 (none) kernel:  [<c01c4811>] filp_close+0x56/0x60
Nov 16 10:37:34 (none) kernel:  [<c0139747>] put_files_struct+0x5d/0xa1
Nov 16 10:37:34 (none) kernel:  [<c01397c7>] exit_files+0x3c/0x41
Nov 16 10:37:34 (none) kernel:  [<c013aebb>] do_exit+0x20a/0x5f6
Nov 16 10:37:34 (none) kernel:  [<c07f0b7a>] ? printk+0x14/0x16
Nov 16 10:37:34 (none) kernel:  [<c07f4039>] oops_end+0xa2/0xaa
Nov 16 10:37:34 (none) kernel:  [<c011e1c0>] no_context+0x13b/0x145
Nov 16 10:37:34 (none) kernel:  [<c011e2b6>] __bad_area_nosemaphore+0xec/0xf4
Nov 16 10:37:34 (none) kernel:  [<c011e2d0>] bad_area_nosemaphore+0x12/0x15
Nov 16 10:37:34 (none) kernel:  [<c07f52a7>] do_page_fault+0x200/0x34e
Nov 16 10:37:34 (none) kernel:  [<c07f50a7>] ? do_page_fault+0x0/0x34e
Nov 16 10:37:34 (none) kernel:  [<c07f36c3>] error_code+0x73/0x78
Nov 16 10:37:34 (none) kernel:  [<c02200d8>] ? find_hash_out+0xc1/0x1dd
Nov 16 10:37:34 (none) kernel:  [<c0198266>] ? __rmqueue+0x98/0x36c
Nov 16 10:37:34 (none) kernel:  [<c01c909e>] ? inode_get_bytes+0x48/0x54
Nov 16 10:37:34 (none) kernel:  [<c0199335>] get_page_from_freelist+0x147/0x3ec
Nov 16 10:37:34 (none) kernel:  [<c01996a0>] __alloc_pages_nodemask+0xc6/0x480
Nov 16 10:37:34 (none) kernel:  [<c014e22f>] ? autoremove_wake_function+0x0/0x34
Nov 16 10:37:34 (none) kernel:  [<c01946fe>] ? find_get_page+0x2d/0x9f
Nov 16 10:37:34 (none) kernel:  [<c0194cdc>]
grab_cache_page_write_begin+0x54/0x8e
Nov 16 10:37:34 (none) kernel:  [<c0217b8b>] reiserfs_write_begin+0x81/0x1b2
Nov 16 10:37:34 (none) kernel:  [<c0195588>]
generic_file_buffered_write+0xd9/0x22f
Nov 16 10:37:34 (none) kernel:  [<c0195c2e>]
__generic_file_aio_write+0x3a2/0x3e3
Nov 16 10:37:34 (none) kernel:  [<c019635a>] ? generic_file_aio_read+0x4cf/0x509
Nov 16 10:37:34 (none) kernel:  [<c0195cd3>] generic_file_aio_write+0x64/0xab
Nov 16 10:37:34 (none) kernel:  [<c01c5eea>] do_sync_write+0xb0/0xeb
Nov 16 10:37:34 (none) kernel:  [<c014e22f>] ? autoremove_wake_function+0x0/0x34
Nov 16 10:37:34 (none) kernel:  [<c014e22f>] ? autoremove_wake_function+0x0/0x34
Nov 16 10:37:34 (none) kernel:  [<c01d81e9>] ? expand_files+0xe/0x201
Nov 16 10:37:34 (none) kernel:  [<c01ebbce>] ? fsnotify+0xe/0xdb
Nov 16 10:37:34 (none) kernel:  [<c021be86>] reiserfs_file_write+0x6e/0x77
Nov 16 10:37:34 (none) kernel:  [<c01c68f3>] vfs_write+0x99/0x14c
Nov 16 10:37:34 (none) kernel:  [<c021be18>] ? reiserfs_file_write+0x0/0x77
Nov 16 10:37:34 (none) kernel:  [<c01c6a62>] sys_write+0x48/0x75
Nov 16 10:37:34 (none) kernel:  [<c0103553>] sysenter_do_call+0x12/0x28
