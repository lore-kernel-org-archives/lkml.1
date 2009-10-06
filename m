Return-Path: <linux-kernel-owner+w=401wt.eu-S932830AbZJFOio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830AbZJFOio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932784AbZJFOio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:38:44 -0400
Received: from mail-qy0-f173.google.com ([209.85.221.173]:42119 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698AbZJFOin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:38:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=LRNY2rk1tpoQFlWApucJIwhp4tE45NGrbLe3EuvFDJtdz9aJtFQqdRjP/yl2dFshkE
         jGAueZ+S2NMzUzz4K//qMmcfHK0c8nlO+wqu3WgKgJyTwPW24CHuC5mnwC+7QdRhwylh
         w+vBBy94V+D76Rq1WF3oS3joOlfHoJ4uvvkvg=
MIME-Version: 1.0
Date: Tue, 6 Oct 2009 09:38:05 -0500
Message-ID: <632b79000910060738l5ed0dd6ch60b4569d87d2ef0e@mail.gmail.com>
Subject: kernel NULL pointer dereference/ kvm subsystem
From: Don Dupuis <dondster@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel 2.6.31.2
x86 64bit

Running numerous kvm linux guests and noticed this oops in messages
file. This didn't occur in 2.6.30.6

BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
IP: [<ffffffffa01de29f>] kpit_elapsed+0x30/0x60 [kvm]
PGD 219c20067 PUD 219c1f067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
CPU 6
Modules linked in: nfs fscache tun ipt_REJECT xt_tcpudp iptable_filter
ip_tables x_tables nfsd nfs_acl auth_rpcgss exportfs autofs4 hidp
rfcomm l2cap bluetooth rfkill lockd sunrpc bridge stp ib_iser rdma_cm
ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp cxgb3i cxgb3
mdio libiscsi_tcp libiscsi scsi_transport_iscsi dm_mirror dm_multipath
scsi_dh video output sbs sbshc battery acpi_memhotplug ac parport_pc
lp parport kvm_intel kvm joydev sg sr_mod e1000e button cdrom
serio_raw dcdbas rtc_cmos rtc_core rtc_lib pcspkr dm_region_hash
dm_log dm_mod ata_piix libata shpchp mptsas mptscsih mptbase
scsi_transport_sas sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd
[last unloaded: microcode]
Pid: 5677, comm: qemu-kvm Not tainted 2.6.31.2 #1 PowerEdge R710
RIP: 0010:[<ffffffffa01de29f>]  [<ffffffffa01de29f>]
kpit_elapsed+0x30/0x60 [kvm]
RSP: 0018:ffff88021808dc48  EFLAGS: 00010202
RAX: 0000000000000000 RBX: 00003977f71173c6 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff880219d11e60 RDI: ffff880218084000
RBP: ffff880219d11e60 R08: 0000000000000043 R09: 0000000000000008
R10: 0000000000000001 R11: ffffffffa01f6843 R12: ffff880218084000
R13: ffff880218084000 R14: 0000000000000007 R15: ffff880219d11f28
FS:  0000000041216940(0000) GS:ffffc90000c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 0000000000000028 CR3: 0000000219cb0000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process qemu-kvm (pid: 5677, threadinfo ffff88021808c000, task ffff88022e14c0c0)
Stack:
 0000000000000007 ffff880219d11e60 0000000000000000 ffffffffa01de3e7
<0> ffff8802180916f8 ffff8802180916d8 ffff880219d11e60 0000000000000000
<0> ffff880218084000 ffffffffa01de49a 0000000000000000 ffff880219d11e60
Call Trace:
 [<ffffffffa01de3e7>] ? pit_get_count+0x48/0xb4 [kvm]
 [<ffffffffa01de49a>] ? pit_latch_count+0x47/0x56 [kvm]
 [<ffffffffa01deb6c>] ? pit_ioport_write+0xf8/0x18c [kvm]
 [<ffffffffa01d0461>] ? kvm_emulate_pio+0x1c8/0x1e8 [kvm]
 [<ffffffffa01ccbb5>] ? emulate_instruction+0x278/0x2a8 [kvm]
 [<ffffffffa01dd335>] ? kvm_get_apic_interrupt+0x4c/0x6b [kvm]
 [<ffffffff812faf9f>] ? __down_read+0x12/0x97
 [<ffffffffa01f3d1c>] ? skip_emulated_instruction+0x1f/0x55 [kvm_intel]
 [<ffffffffa01cfdaa>] ? kvm_arch_vcpu_ioctl_run+0x86c/0xacd [kvm]
 [<ffffffff810c31ba>] ? cache_alloc_refill+0x120/0x1a0
 [<ffffffff810115ae>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffffa01f6843>] ? handle_io+0x0/0x63 [kvm_intel]
 [<ffffffffa01c9ad4>] ? kvm_vcpu_ioctl+0xf2/0x5a9 [kvm]
 [<ffffffff810115ae>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffff81136774>] ? cap_file_ioctl+0x0/0x3
 [<ffffffff810d5226>] ? vfs_ioctl+0x21/0x6b
 [<ffffffff810d5759>] ? do_vfs_ioctl+0x476/0x4cb
 [<ffffffff81067ba8>] ? sys_futex+0x116/0x134
 [<ffffffff810d57ff>] ? sys_ioctl+0x51/0x70
 [<ffffffff810115ae>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffff81010a02>] ? system_call_fastpath+0x16/0x1b
Code: 48 83 ec 08 85 d2 75 40 48 8b af 30 2b 00 00 31 d2 48 83 c5 60
48 83 bd 98 00 00 00 00 74 35 48 8d 45 48 48 8b 58 18 48 8b 40 30 <ff>
50 28 48 8b 95 98 00 00 00 48 29 c3 48 89 d1 48 89 d0 48 29
RIP  [<ffffffffa01de29f>] kpit_elapsed+0x30/0x60 [kvm]
 RSP <ffff88021808dc48>
CR2: 0000000000000028
---[ end trace 3e93dea7b5989be2 ]---

Thanks

Don Dupuis
