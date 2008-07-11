Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbYGKIIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbYGKIIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 04:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbYGKIIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 04:08:18 -0400
Received: from swm.pp.se ([212.247.200.143]:43118 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbYGKIIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 04:08:16 -0400
X-Greylist: delayed 1286 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jul 2008 04:08:16 EDT
Date: Fri, 11 Jul 2008 09:46:47 +0200 (CEST)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: linux-kernel@vger.kernel.org
Subject: xfs bug in 2.6.26-rc9
Message-ID: <alpine.DEB.1.10.0807110939520.30192@uplift.swm.pp.se>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I received this when running xfs_fsr to defragment my xfs volume (which 
resides on a crypted lvm).

Could it be that something is wrong with my xfs volume and this is not 
being properly handled (since it seems to refer to getbmap below?).

Kernel is configured with oldconfig from ubuntu hardy stock kernel plus 
Alsa. Hardware can be seen at 
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/235074>.

Kernel oopsed (caps lock+other flashing when I woke up this morning), 
don't know if it's related to the below bug or if it's something else. 
Screensaver was on so I couldn't see any text to see more info.

Jul  8 04:44:56 via kernel: [554197.888008] ------------[ cut here ]------------
Jul  8 04:44:56 via kernel: [554197.888008] kernel BUG at fs/xfs/support/debug.c:81!
Jul  8 04:44:56 via kernel: [554197.888008] invalid opcode: 0000 [#1] SMP
Jul  8 04:44:56 via kernel: [554197.888008] Modules linked in: soundcore 
ac97_bus isofs udf crc_itu_t nvidia(P) af_packet rfcomm l2c
ap bluetooth ppdev cpufreq_conservative cpufreq_stats cpufreq_ondemand 
cpufreq_userspace cpufreq_powersave freq_table container sbs
sbshc wmi video output battery iptable_filter ip_tables x_tables xfs 
sha256_generic aes_i586 dm_crypt ac max6650 padlock_sha padlock
_aes crypto_blkcipher aes_generic parport_pc lp parport pcspkr i2c_viapro 
i2c_core netxen_nic button via_agp shpchp pci_hotplug agpg
art ipv6 evdev ext3 jbd mbcache usbhid hid sr_mod cdrom pata_acpi pata_via 
sg sd_mod uhci_hcd ehci_hcd via_velocity crc_ccitt ata_ge
neric ahci libata via_rhine mii scsi_mod usbcore dock raid10 raid456 
async_xor async_memcpy async_tx xor raid1 raid0 multipath linea
r md_mod dm_mirror dm_log dm_snapshot dm_mod thermal processor fan fuse 
[last unloaded: nvidia]
Jul  8 04:44:56 via kernel: [554197.888008]
Jul  8 04:44:56 via kernel: [554197.888008] Pid: 16200, comm: xfs_fsr Tainted: P          (2.6.26-rc8 #1)
Jul  8 04:44:56 via kernel: [554197.888008] EIP: 0060:[<f956201b>] EFLAGS: 00010282 CPU: 0
Jul  8 04:44:56 via kernel: [554197.888008] EIP is at assfail+0x1b/0x20 [xfs]
Jul  8 04:44:56 via kernel: [554197.888008] EAX: 00000080 EBX: 00000000 ECX: 00000001 EDX: 00000092
Jul  8 04:44:56 via kernel: [554197.888008] ESI: 00000000 EDI: c279fed0 EBP: e890ea80 ESP: c279fde0
Jul  8 04:44:56 via kernel: [554197.888008]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Jul  8 04:44:56 via kernel: [554197.888008] Process xfs_fsr (pid: 16200, ti=c279e000 task=c6f7ec00 task.ti=c279e000)
Jul  8 04:44:56 via kernel: [554197.888008] Stack: f9570520 f9566db4 f95719fd 000016f7 f9505590 ffffffff ffffffff 00000000
Jul  8 04:44:56 via kernel: [554197.888008]        00000000 00000001 019cc780 f4463880 c279fe98 00000000 c01a1c25 f7879c80
Jul  8 04:44:56 via kernel: [554197.888008]        c0196cbb bf8e9ffc f4463880 c279ff04 002e9b68 00000000 00000000 c01a6318
Jul  8 04:44:56 via kernel: [554197.888008] Call Trace:
Jul  8 04:44:56 via kernel: [554197.888008]  [<f9505590>] xfs_getbmap+0x320/0x7e0 [xfs]
Jul  8 04:44:56 via kernel: [554197.888008]  [xfs:dput+0x65/0x2b0] dput+0x65/0xe0
Jul  8 04:44:56 via kernel: [554197.888008]  [__follow_mount+0x1b/0x70] __follow_mount+0x1b/0x70
Jul  8 04:44:56 via kernel: [554197.888008]  [fuse:mntput_no_expire+0x18/0x3fc0] mntput_no_expire+0x18/0x100
Jul  8 04:44:56 via kernel: [554197.888008]  [sg:seq_open+0x3c/0x100] seq_open+0x3c/0x90
Jul  8 04:44:56 via kernel: [554197.888008]  [fuse:mntput_no_expire+0x18/0x3fc0] mntput_no_expire+0x18/0x100
Jul  8 04:44:56 via kernel: [554197.888008]  [blk_init_queue_node+0x86/0x160] blk_init_queue_node+0x86/0x160
Jul  8 04:44:56 via kernel: [554197.888008]  [<f955b8e0>] xfs_ioc_getbmap+0x60/0xd0 [xfs]
Jul  8 04:44:56 via kernel: [554197.888008]  [blk_init_queue_node+0x86/0x160] blk_init_queue_node+0x86/0x160
Jul  8 04:44:56 via kernel: [554197.888008]  [<f955d036>] xfs_ioctl+0x306/0x780 [xfs]
Jul  8 04:44:56 via kernel: [554197.888008]  [free_pgtables+0x85/0xc0] free_pgtables+0x85/0xc0
Jul  8 04:44:56 via kernel: [554197.888008]  [flush_tlb_mm+0x5f/0x70] flush_tlb_mm+0x5f/0x70
Jul  8 04:44:56 via kernel: [554197.888008]  [blk_init_queue_node+0x86/0x160] blk_init_queue_node+0x86/0x160
Jul  8 04:44:56 via kernel: [554197.888008]  [<f955ada0>] xfs_file_ioctl_invis+0x30/0x70 [xfs]
Jul  8 04:44:56 via kernel: [554197.888008]  [blk_init_queue_node+0x86/0x160] blk_init_queue_node+0x86/0x160
Jul  8 04:44:56 via kernel: [554197.888008]  [<f955ad70>] xfs_file_ioctl_invis+0x0/0x70 [xfs]
Jul  8 04:44:56 via kernel: [554197.888008]  [vfs_ioctl+0x2b/0x90] vfs_ioctl+0x2b/0x90
Jul  8 04:44:56 via kernel: [554197.888008]  [do_vfs_ioctl+0x25b/0x2a0] do_vfs_ioctl+0x25b/0x2a0
Jul  8 04:44:56 via kernel: [554197.888008]  [sys_ioctl+0x56/0x70] sys_ioctl+0x56/0x70
Jul  8 04:44:56 via kernel: [554197.888008]  [sysenter_past_esp+0x78/0xb9] sysenter_past_esp+0x78/0xb9
Jul  8 04:44:56 via kernel: [554197.888008]  [blk_init_queue_node+0x86/0x160] blk_init_queue_node+0x86/0x160
Jul  8 04:44:56 via kernel: [554197.888008]  =======================
Jul  8 04:44:56 via kernel: [554197.888008] Code: 00 e8 ea 6e cb c6 83 c4 14 c3 8d b6 00 00 00 00 83 ec 10 89 4c 24 0c 89 54 24 08 89 44 24 04 c7 04 24 20 05 57 f9 e8 35 76 bc c6 <0f> 0b eb fe 90 55 57 89 c7 56 b8 20 71 58 f9 53 89 d6 83 ec 0c
Jul  8 04:44:56 via kernel: [554197.888008] EIP: [<f956201b>] assfail+0x1b/0x20 [xfs] SS:ESP 0068:c279fde0
Jul  8 04:44:56 via kernel: [554201.441862] ---[ end trace 598853b934570aec ]---

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
