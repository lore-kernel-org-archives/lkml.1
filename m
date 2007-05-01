Return-Path: <linux-kernel-owner+w=401wt.eu-S1030915AbXEASXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030915AbXEASXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030901AbXEASXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:23:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030915AbXEASXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:23:05 -0400
Date: Tue, 1 May 2007 14:23:01 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.21rc7-mm1 usb/sysfs oops.
Message-ID: <20070501182301.GB2843@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I thought I'd try something really silly, and set up
a raid5 stripe across 3 USB memory sticks just for giggles.

it worked just fine. Then I thought I'd be *really* clever
and see how well raid5 reconstruction over same would behave,
and yanked one out whilst the array was still 'up'.

*boom*.

No more being a smart-ass for me today.

	Dave

------------[ cut here ]------------
kernel BUG at fs/sysfs/inode.c:272!
invalid opcode: 0000 [1] SMP 
CPU 1 
Modules linked in: raid456 raid0 usb_storage hidp l2cap bluetooth sunrpc ipv6 nf_conntrack_netbios_ns nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink xt_tcpudp ipt_REJECT iptable_filter ip_tables x_tables dm_multipath video sbs button dock battery asus_acpi ac lp snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device e1000 snd_pcm_oss snd_mixer_oss sg snd_pcm shpchp snd_timer parport_pc snd soundcore parport floppy i2c_i801 serio_raw snd_page_alloc sr_mod cdrom i2c_core rtc_cmos rtc_core rtc_lib dm_snapshot dm_zero dm_mirror dm_mod ahci pata_marvell pata_jmicron ata_generic ata_piix libata sd_mod scsi_mod ext3 jbd mbcache ehci_hcd ohci_hcd uhci_hcd
Pid: 176, comm: khubd Tainted: G      D 2.6.21-rc7-mm1 #2
RIP: 0010:[<ffffffff8030e9e3>]  [<ffffffff8030e9e3>] sysfs_drop_dentry+0x19e/0x1ce
RSP: 0018:ffff810003d03b70  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff81001d9f3820 RCX: ffff81001d9f3600
RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff81000923a130
RBP: ffff810003d03bd0 R08: 000000000001a029 R09: 0000000000000000
R10: ffffffff802ec8f4 R11: ffff81000456b5b0 R12: ffff81000923a048
R13: 0000000000000002 R14: ffff81000923a130 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff810002c010a0(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00002ab1d986a000 CR3: 0000000005580000 CR4: 00000000000006e0
Process khubd (pid: 176, threadinfo ffff810003d02000, task ffff810002e46080)
Stack:  ffff810003d03b90 ffffffff802a359a 000000004637843a 000000001007b214
 000000004637843a 000000001007b214 ffff81001d9f3600 ffff81001d9f3600
 ffff810008bc5568 ffff81001d9f3820 ffff81000456b5b0 ffff810005202ba0
Call Trace:
 [<ffffffff802a359a>] trace_hardirqs_on+0x114/0x138
 [<ffffffff8031015d>] remove_dir+0x58/0x93
 [<ffffffff803102b3>] __sysfs_remove_dir+0x11b/0x126
 [<ffffffff803102ff>] sysfs_remove_dir+0x36/0x3b
 [<ffffffff803469d1>] kobject_del+0x16/0x22
 [<ffffffff803b6268>] device_del+0x2d8/0x302
 [<ffffffff880619f5>] :scsi_mod:scsi_remove_host+0x109/0x120
 [<ffffffff883cfbfb>] :usb_storage:quiesce_and_remove_host+0xb3/0xb8
 [<ffffffff883cfcdf>] :usb_storage:storage_disconnect+0x18/0x24
 [<ffffffff803d1fd6>] usb_unbind_interface+0x47/0x87
 [<ffffffff803b8777>] __device_release_driver+0x93/0xb3
 [<ffffffff803b8bfb>] device_release_driver+0x42/0x5a
 [<ffffffff803b7fc7>] bus_remove_device+0x92/0xa4
 [<ffffffff803b6209>] device_del+0x279/0x302
 [<ffffffff803cf903>] usb_disable_device+0x7a/0xf2
 [<ffffffff803cbde8>] usb_disconnect+0xb7/0x14b
 [<ffffffff803cc5a8>] hub_thread+0x3ae/0xba6
 [<ffffffff8026000a>] relocate_kernel+0xa/0x11f
 [<ffffffff8029cf4d>] autoremove_wake_function+0x0/0x38
 [<ffffffff803cc1fa>] hub_thread+0x0/0xba6
 [<ffffffff8023263b>] kthread+0x49/0x76
 [<ffffffff8025cfa8>] child_rip+0xa/0x12
 [<ffffffff8025c6bc>] restore_args+0x0/0x30
 [<ffffffff8029ce11>] kthreadd+0x11f/0x144
 [<ffffffff802325f2>] kthread+0x0/0x76
 [<ffffffff8025cf9e>] child_rip+0x0/0x12

INFO: lockdep is turned off.

Code: 0f 0b eb fe 41 ff 4c 24 4c 48 89 df e8 2e eb ef ff 4c 89 f7 
RIP  [<ffffffff8030e9e3>] sysfs_drop_dentry+0x19e/0x1ce
 RSP <ffff810003d03b70>


-- 
http://www.codemonkey.org.uk
