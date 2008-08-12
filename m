Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbYHLVzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbYHLVzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 17:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbYHLVzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 17:55:20 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:58832 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbYHLVzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 17:55:17 -0400
X-BigFish: VPS4(z21eW16d9mz4cd6kzz10d3izzz32i6bh43j68o)
X-Spam-TCS-SCL: 7:0
X-FB-SS: 5,
X-WSS-ID: 0K5ICVK-02-673-01
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: linux-kernel@vger.kernel.org
Subject: Warning in during hotplug on 2.6.27-rc2-git5
Date: Tue, 12 Aug 2008 17:00:20 -0500
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200808121700.20369.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 12 Aug 2008 21:55:08.0960 (UTC) FILETIME=[16668200:01C8FCC6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing the following error message when I hotunplug and replug
a cpu in 2.6.27-rc2-git5.  The system becomes unstable almost
immediately afterwards.

------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x33/0x39()
sysfs: duplicate filename 'machinecheck4' can not be created
Modules linked in: cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 freq_table sr_mod af_packet button battery ac loop dm_mod usb_storage usbhid ff_memless tg3 libphy ide_pci_generic shpchp ehci_hcd i2c_piix4 i2c_core pci_hotplug ohci_hcd usbcore ide_cd_mod cdrom floppy mptctl ext3 jbd edd fan thermal processor mptsas mptscsih mptbase scsi_transport_sas sg sata_svw libata dock serverworks sd_mod scsi_mod ide_disk ide_core
Pid: 4838, comm: bash Not tainted 2.6.27-rc2-git5-pn_test #2

Call Trace:
 [<ffffffff8023194f>] warn_slowpath+0xb4/0xde
 [<ffffffff80304cf7>] rb_insert_color+0x61/0xda
 [<ffffffff80304cf7>] rb_insert_color+0x61/0xda
 [<ffffffff80306c27>] vsnprintf+0x568/0x5b1
 [<ffffffff80226c3f>] hrtick_start_fair+0x10d/0x171
 [<ffffffff80301b45>] idr_get_empty_slot+0x164/0x243
 [<ffffffff80301d1a>] ida_get_new_above+0xf6/0x182
 [<ffffffff802a038a>] find_inode+0x28/0x6d
 [<ffffffff802d272c>] sysfs_ilookup_test+0x0/0xf
 [<ffffffff802d2928>] sysfs_find_dirent+0x1b/0x2f
 [<ffffffff802d29de>] sysfs_add_one+0x33/0x39
 [<ffffffff802d2ee3>] create_dir+0x4f/0x87
 [<ffffffff802d2f50>] sysfs_create_dir+0x35/0x4a
 [<ffffffff80302757>] kobject_get+0x12/0x17
 [<ffffffff80302890>] kobject_add_internal+0xcf/0x18a
 [<ffffffff80302a66>] kobject_init_and_add+0x5b/0x68
 [<ffffffff8022d5ab>] set_cpus_allowed_ptr+0x119/0x126
 [<ffffffff8038397a>] sysdev_register+0x5a/0xb5
 [<ffffffff804172df>] mce_create_device+0xb4/0x156
 [<ffffffff804173ac>] mce_cpu_callback+0x2b/0x9b
 [<ffffffff8041fb7d>] notifier_call_chain+0x29/0x4c
 [<ffffffff8041a2e7>] _cpu_up+0xc8/0x102
 [<ffffffff8041a375>] cpu_up+0x54/0x77
 [<ffffffff8040ffee>] store_online+0x43/0x67
 [<ffffffff802d20a1>] sysfs_write_file+0xd2/0x110
 [<ffffffff8028f1a5>] vfs_write+0xad/0x156
 [<ffffffff8028f692>] sys_write+0x45/0x6e
 [<ffffffff8020bdeb>] system_call_fastpath+0x16/0x1b

---[ end trace 48036b92036180e0 ]---
kobject_add_internal failed for machinecheck4 with -EEXIST, don't try to register things with the same name in the same directory.
Pid: 4838, comm: bash Tainted: G        W 2.6.27-rc2-git5-pn_test #2

Call Trace:
 [<ffffffff8030290c>] kobject_add_internal+0x14b/0x18a
 [<ffffffff80302a66>] kobject_init_and_add+0x5b/0x68
 [<ffffffff8022d5ab>] set_cpus_allowed_ptr+0x119/0x126
 [<ffffffff8038397a>] sysdev_register+0x5a/0xb5
 [<ffffffff804172df>] mce_create_device+0xb4/0x156
 [<ffffffff804173ac>] mce_cpu_callback+0x2b/0x9b
 [<ffffffff8041fb7d>] notifier_call_chain+0x29/0x4c
 [<ffffffff8041a2e7>] _cpu_up+0xc8/0x102
 [<ffffffff8041a375>] cpu_up+0x54/0x77
 [<ffffffff8040ffee>] store_online+0x43/0x67
 [<ffffffff802d20a1>] sysfs_write_file+0xd2/0x110
 [<ffffffff8028f1a5>] vfs_write+0xad/0x156
 [<ffffffff8028f692>] sys_write+0x45/0x6e
 [<ffffffff8020bdeb>] system_call_fastpath+0x16/0x1b

BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
IP: [<ffffffff802d2a11>] sysfs_addrm_start+0x2d/0x99
PGD 22a87c067 PUD 22c9ef067 PMD 0 
Oops: 0000 [1] SMP 
CPU 1 
Modules linked in: cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 freq_table sr_mod af_packet button battery ac loop dm_mod usb_storage usbhid ff_memless tg3 libphy ide_pci_generic shpchp ehci_hcd i2c_piix4 i2c_core pci_hotplug ohci_hcd usbcore ide_cd_mod cdrom floppy mptctl ext3 jbd edd fan thermal processor mptsas mptscsih mptbase scsi_transport_sas sg sata_svw libata dock serverworks sd_mod scsi_mod ide_disk ide_core
Pid: 4838, comm: bash Tainted: G        W 2.6.27-rc2-git5-pn_test #2
RIP: 0010:[<ffffffff802d2a11>]  [<ffffffff802d2a11>] sysfs_addrm_start+0x2d/0x99
RSP: 0018:ffff88022d0dbb38  EFLAGS: 00010246
RAX: ffff880028047710 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 00000acb2c4dfcc0 RSI: 0000000000000000 RDI: ffff88022fc3b000
RBP: ffff88022d0dbb58 R08: 0000000000000080 R09: ffff88022d0dba58
R10: ffff880028047710 R11: 00000acb2c4dfcc0 R12: 00000000fffffff4
R13: 0000000000000000 R14: ffff88022d0dbbb0 R15: 0000000000000004
FS:  00007f106d7496d0(0000) GS:ffff88022f0938c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000038 CR3: 000000022c8d0000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process bash (pid: 4838, threadinfo ffff88022d0da000, task ffff88022d6b4d90)
Stack:  00000000fffffff4 ffff88022e3dfc80 ffff88022dc0c870 ffffffff802d2ed8
 0000000000000000 0000000000000000 0000000000000000 0000000000000000
 ffff88022e3dfc80 ffff88022d0dbd18 00000000fffffffe 0000000000000004
Call Trace:
 [<ffffffff802d2ed8>] ? create_dir+0x44/0x87
 [<ffffffff802d2f50>] ? sysfs_create_dir+0x35/0x4a
 [<ffffffff80302757>] ? kobject_get+0x12/0x17
 [<ffffffff80302890>] ? kobject_add_internal+0xcf/0x18a
 [<ffffffff80302d57>] ? kobject_add+0x74/0x7c
 [<ffffffff8041bfc5>] ? thread_return+0x3e/0xa3
 [<ffffffff8030254e>] ? kobject_init_internal+0x12/0x2c
 [<ffffffff803025c6>] ? kobject_init+0x41/0x69
 [<ffffffff80302619>] ? kobject_create+0x2b/0x30
 [<ffffffff80302d8d>] ? kobject_create_and_add+0x2e/0x5b
 [<ffffffff804178c3>] ? threshold_create_device+0x1aa/0x32a
 [<ffffffff80417aa2>] ? threshold_cpu_callback+0x5f/0x2ca
 [<ffffffff804172df>] ? mce_create_device+0xb4/0x156
 [<ffffffff8041fb7d>] ? notifier_call_chain+0x29/0x4c
 [<ffffffff8041a2e7>] ? _cpu_up+0xc8/0x102
 [<ffffffff8041a375>] ? cpu_up+0x54/0x77
 [<ffffffff8040ffee>] ? store_online+0x43/0x67
 [<ffffffff802d20a1>] ? sysfs_write_file+0xd2/0x110
 [<ffffffff8028f1a5>] ? vfs_write+0xad/0x156
 [<ffffffff8028f692>] ? sys_write+0x45/0x6e
 [<ffffffff8020bdeb>] ? system_call_fastpath+0x16/0x1b


Code: c0 b9 08 00 00 00 fc 53 48 89 fd 48 89 f3 48 83 ec 08 f3 ab 48 89 75 00 48 c7 c7 e0 e7 51 80 e8 c2 9c 14 00 48 8b 3d 57 45 37 00 <48> 8b 73 38 48 89 d9 48 c7 c2 2c 27 2d 80 e8 1e db fc ff 48 85 
RIP  [<ffffffff802d2a11>] sysfs_addrm_start+0x2d/0x99
 RSP <ffff88022d0dbb38>
CR2: 0000000000000038
---[ end trace 48036b92036180e0 ]---



