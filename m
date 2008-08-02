Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbYHBB7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbYHBB7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 21:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYHBB6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 21:58:55 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:55922 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbYHBB6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 21:58:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=OzKI1PjqpLhIh5gdoU9G2SbB9SucURvM4rcsOd7a4DWow7Ha/1QfsAZ7iyxzipKBzZ
         zVMPyWrPKGXxVAw54OdjBCPcsNTK+3byQ0E+c5WUDnB3y1WvA82MS99nfQv/3g6lXq05
         lIRL9ihK6XFLgpgPfcv3IRbKmXvB0WzMv1wQw=
Message-ID: <82e4877d0808011858v336447dcn9e333407a89c73b@mail.gmail.com>
Date: Fri, 1 Aug 2008 21:58:51 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: tip - oops while running powertop
Cc: "Ingo Molnar" <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got the below oops just after running powertop. Does not seem to occur
in Linus's tree.

Parag

[  780.772501] BUG: unable to handle kernel paging request at c012aa60
[  780.772501] IP: [<c0215cf8>] number+0x1f8/0x330
[  780.772501] *pdpt = 0000000000476001 *pde = 00000000004ed067 *pte =
000000000012a161
[  780.772501] Oops: 0003 [#1] SMP
[  780.772501] Modules linked in: af_packet radeon drm binfmt_misc
rfcomm l2cap kvm_intel kvm ppdev ipv6 acpi_cpufreq cpufreq_powersave
cpufreq_stats cpufreq_conservative cpufreq_ondemand freq_table
cpufreq_userspace container video output pci_slot battery
iptable_filter ip_tables x_tables ac sbp2 lp snd_hda_intel snd_pcm_oss
snd_mixer_oss snd_pcm snd_timer snd_hwdep appledisplay hci_usb snd
bluetooth psmouse iTCO_wdt parport_serial parport_pc intel_agp parport
button soundcore agpgart serio_raw snd_page_alloc iTCO_vendor_support
pcspkr e1000e shpchp pci_hotplug evdev ext3 jbd mbcache sg sr_mod
cdrom sd_mod usbhid hid usb_storage libusual ohci1394 ieee1394 ahci
libata scsi_mod dock uhci_hcd ehci_hcd usbcore thermal processor fan
thermal_sys fuse
[  780.776002]
[  780.776002] Pid: 7472, comm: powertop Not tainted (2.6.27-rc1-tip-tip #2)
[  780.776002] EIP: 0060:[<c0215cf8>] EFLAGS: 00010206 CPU: 2
[  780.776002] EIP is at number+0x1f8/0x330
[  780.776002] EAX: 00000030 EBX: 00000000 ECX: f282bdab EDX: c012aa60
[  780.776002] ESI: c012aa60 EDI: ffffffff EBP: 00000001 ESP: f282bd88
[  780.776002]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  780.776002] Process powertop (pid: 7472, ti=f282a000 task=f446a760
task.ti=f282a000)
[  780.776002] Stack: fffffffc f282bdaa 00000000 00000000 c03fe3c0
fffffffd fffffffc 00000001
[  780.776002]        c030e3c4 c0125e78 80000001 00000000 fff99000
00000286 fb53e769 c0346025
[  780.776002]        c01b126e f35b1558 4c0c797e f71ef000 f282be48
f70a6cc0 00000000 00000016
[  780.776002] Call Trace:
[  780.776002]  [<c030e3c4>] fib_dump_info+0x134/0x3d0
[  780.776002]  [<c0125e78>] kmap_atomic_prot+0xf8/0x130
[  780.776002]  [<c0346025>] _spin_lock+0x5/0x10
[  780.776002]  [<c01b126e>] __d_lookup+0x10e/0x120
[  780.776002]  [<c012aa60>] sched_mc_power_savings_show+0x0/0x20
[  780.776002]  [<c0216751>] vsnprintf+0x2d1/0x5a0
[  780.776002]  [<c012aa60>] sched_mc_power_savings_show+0x0/0x20
[  780.776002]  [<c0119fe1>] flush_tlb_page+0x71/0x80
[  780.776002]  [<c01b1787>] dput+0x97/0x130
[  780.776002]  [<c01e7f3c>] sysfs_put_active_two+0xc/0x20
[  780.776002]  [<c01e6c98>] sysfs_open_file+0x188/0x1f0
[  780.776002]  [<c0125ecc>] kmap_atomic+0x1c/0x30
[  780.776002]  [<c0125fad>] kunmap_atomic+0x2d/0x80
[  780.776002]  [<c0178a8d>] get_page_from_freelist+0x2cd/0x480
[  780.776002]  [<c0178e73>] __alloc_pages_internal+0xb3/0x450
[  780.776002]  [<c018941c>] mmap_region+0x24c/0x490
[  780.776002]  [<c0216a40>] sprintf+0x20/0x30
[  780.776002]  [<c012aa7c>] sched_mc_power_savings_show+0x1c/0x20
[  780.776002]  [<c012aa60>] sched_mc_power_savings_show+0x0/0x20
[  780.776002]  [<c0297dd1>] sysdev_class_show+0x21/0x30
[  780.776002]  [<c01e6e93>] sysfs_read_file+0x83/0x120
[  780.776002]  [<c01f8bcc>] security_file_permission+0xc/0x10
[  780.776002]  [<c01e6e10>] sysfs_read_file+0x0/0x120
[  780.776002]  [<c019fbfd>] vfs_read+0x9d/0x160
[  780.776002]  [<c01a0011>] sys_read+0x41/0x70
[  780.776002]  [<c0109e77>] sysenter_do_call+0x12/0x2f
[  780.776002]  [<c0340000>] init_amd+0x640/0x6f0
[  780.776002]  =======================
[  780.776002] Code: 06 30 83 e8 01 83 c6 01 39 c5 7e ef 89 eb 83 eb
01 78 2a 8d 54 24 22 89 d1 89 54 24 04 01 e9 89 f2 66 90 39 d7 76 06
0f b6 41 ff <88> 02 83 c2 01 83 e9 01 3b 4c 24 04 75 ea 8d 74 1e 01 8b
4c 24
[  780.776002] EIP: [<c0215cf8>] number+0x1f8/0x330 SS:ESP 0068:f282bd88
[  780.776002] ---[ end trace f2f1f5eec0db2fb6 ]---
