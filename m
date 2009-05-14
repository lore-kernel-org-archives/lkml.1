Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbZENHYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbZENHYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 03:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZENHYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 03:24:03 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:4218 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbZENHYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 03:24:00 -0400
Message-ID: <4A0BC6EF.9080704@krogh.cc>
Date: Thu, 14 May 2009 09:23:27 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Oops on 2.6.27.20 (smp_call_function_mask)? 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

This morning the system blew up with a lot of these messages in dmesg

May 14 06:59:14 svin kernel: [513352.822556] Modules linked in: nfsd 
auth_rpcgss exportfs autofs4 nfs lockd sunrpc ipv6 bonding 
iptable_filter ip_tables x_tables parport_pc
lp parport loop cfi_cmdset_0001 cfi_util jedec_probe cfi_probe psmouse 
gen_probe serio_raw ck804xrom mtd chipreg i2c_nforce2 joydev shpchp 
pcspkr i2c_core pci_hotplug map_fu
ncs button evdev ext3 jbd mbcache ide_cd_mod cdrom sg sd_mod ata_generic 
libata usbhid hid dock mptsas mptscsih mptbase qla2xxx 
scsi_transport_sas scsi_transport_fc amd74xx
ohci_hcd ehci_hcd e1000 scsi_mod ide_core usbcore dm_mirror dm_log 
dm_snapshot dm_mod thermal processor fan thermal_sys fuse
May 14 06:59:14 svin kernel: [513352.822556] CPU 31:
May 14 06:59:14 svin kernel: [513352.822556] Modules linked in: nfsd 
auth_rpcgss exportfs autofs4 nfs lockd sunrpc ipv6 bonding 
iptable_filter ip_tables x_tables parport_pc
lp parport loop cfi_cmdset_0001 cfi_util jedec_probe cfi_probe psmouse 
gen_probe serio_raw ck804xrom mtd chipreg i2c_nforce2 joydev shpchp 
pcspkr i2c_core pci_hotplug
  map_funcs button evdev ext3 jbd mbcache ide_cd_mod cdrom sg sd_mod 
ata_generic libata usbhid hid dock mptsas mptscsih mptbase qla2xxx 
scsi_transport_sas scsi_transport_fc amd74xx ohci_hcd ehci_hcd e1000 
scsi_mod ide_core usbcore dm_mirror dm_log dm_snapshot dm_mod thermal 
processor fan thermal_sys fuse
May 14 06:59:14 svin kernel: [513352.822556] Pid: 130, comm: events/31 
Not tainted 2.6.27.20 #7
May 14 06:59:14 svin kernel: [513352.822556] RIP: 
0010:[<ffffffff80259537>]  [<ffffffff80259537>] csd_flag_wait+0x7/0x10
May 14 06:59:14 svin kernel: [513352.822556] RSP: 0018:ffff88021f38fd78 
  EFLAGS: 00000202
May 14 06:59:14 svin kernel: [513352.822556] RAX: 0000000000000020 RBX: 
000000000000001f RCX: 0000000000000020
May 14 06:59:14 svin kernel: [513352.822556] RDX: 0000000000000020 RSI: 
0000000000000020 RDI: ffff880f277118a0
May 14 06:59:14 svin kernel: [513352.822556] RBP: 0000000000000286 R08: 
0000000000000000 R09: ffff88021f38fcf0
May 14 06:59:14 svin kernel: [513352.822556] R10: 0000000000000000 R11: 
00000000ffffffff R12: 000000028022b9df
May 14 06:59:14 svin kernel: [513352.822556] R13: ffffffff80337a1a R14: 
ffff88021f38fe70 R15: ffff880e272365b8
May 14 06:59:14 svin kernel: [513352.822556] FS:  00007ff29f7c76e0(0000) 
GS:ffff88101f00fb00(0000) knlGS:0000000000000000
May 14 06:59:14 svin kernel: [513352.822556] CS:  0010 DS: 0018 ES: 0018 
CR0: 000000008005003b
May 14 06:59:14 svin kernel: [513352.822556] CR2: 00007fffa77d4fe8 CR3: 
0000000000201000 CR4: 00000000000006e0
May 14 06:59:14 svin kernel: [513352.822556] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
May 14 06:59:14 svin kernel: [513352.822556] DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
May 14 06:59:14 svin kernel: [513352.822556]
May 14 06:59:14 svin kernel: [513352.822556] Call Trace:
May 14 06:59:14 svin kernel: [513352.822556]  [<ffffffff802598da>] ? 
smp_call_function_mask+0x13a/0x230
May 14 06:59:14 svin kernel: [513352.822556]  [<ffffffff8045a0ef>] ? 
thread_return+0x3a/0x5eb
May 14 06:59:14 svin kernel: [513352.822556]  [<ffffffff80241ad4>] ? 
lock_timer_base+0x34/0x70
May 14 06:59:14 svin kernel: [513352.822556]  [<ffffffff802174a0>] ? 
mcheck_timer+0x0/0x80
May 14 06:59:14 svin kernel: [513352.822556]  [<ffffffff80217d40>] ? 
mcheck_check_cpu+0x0/0x40
May 14 06:59:14 svin kernel: [513352.822556]  [<ffffffff8023caed>] ? 
on_each_cpu+0x1d/0x40
May 14 06:59:14 svin kernel: [513352.822556]  [<ffffffff802174b4>] ? 
mcheck_timer+0x14/0x80
May 14 06:59:14 svin kernel: [513352.822556]  [<ffffffff80248d8e>] ? 
run_workqueue+0xbe/0x150
May 14 06:59:14 svin kernel: [513352.822556]  [<ffffffff802497c0>] ? 
worker_thread+0x0/0x100
May 14 06:59:14 svin kernel: [513352.822556]  [<ffffffff802497c0>] ? 
worker_thread+0x0/0x100
May 14 06:59:14 svin kernel: [513352.822556]  [<ffffffff8024985f>] ? 
worker_thread+0x9f/0x100
May 14 06:59:14 svin kernel: [513352.822556]  [<ffffffff8024ca10>] ? 
autoremove_wake_function+0x0/0x30
May 14 06:59:14 svin kernel: [513352.822556]  [<ffffffff802497c0>] ? 
worker_thread+0x0/0x100
May 14 06:59:14 svin kernel: [513352.822556]  [<ffffffff802497c0>] ? 
worker_thread+0x0/0x100
May 14 06:59:14 svin kernel: [513352.822556]  [<ffffffff8024c5db>] ? 
kthread+0x4b/0x80
May 14 06:59:14 svin kernel: [513352.822556]  [<ffffffff8020d1b9>] ? 
child_rip+0xa/0x11
May 14 06:59:14 svin kernel: [513352.822556]  [<ffffffff8024c590>] ? 
kthread+0x0/0x80
May 14 06:59:14 svin kernel: [513352.822556]  [<ffffffff8020d1af>] ? 
child_rip+0x0/0x11
May 14 06:59:14 svin kernel: [513352.822556]

More of them on http://krogh.cc/~jesper/kernel-messages.txt

The systems is a 32 core Opteron (8xquad-core) with 64GB of memory, but 
otherwise its just running PostgreSQL+apache+perl.

I hit the same one a week ago on 2.6.27.6 (see the 2.6.27.21 release 
thread here for that): http://lkml.org/lkml/2009/5/8/44

Any suggestions?

-- 
Jesper
