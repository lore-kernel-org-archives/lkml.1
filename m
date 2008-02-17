Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbYBQFIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbYBQFIg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 00:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbYBQFI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 00:08:29 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:58637 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbYBQFI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 00:08:27 -0500
Message-ID: <47B7C13C.1080004@linux.vnet.ibm.com>
Date: Sun, 17 Feb 2008 10:38:12 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.25-rc2-mm1
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
In-Reply-To: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The 2.6.25-rc2-mm1 kernel oopses, followed by softlockup several times (have pasted
only some of them) on the x86_64 machine. The machine has 4 cpu(s).

BUG: unable to handle kernel NULL pointer dereference at 0000000000000219
IP: [<ffffffff802ee99a>] security_inode_getattr+0x4/0x21
PGD 1da947067 PUD 1e1803067 PMD 0 
Oops: 0000 [1] SMP 
last sysfs file: /sys/devices/system/cpu/cpu1/cpufreq/scaling_setspeed
CPU 2 
Modules linked in: auth_rpcgss exportfs autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 acpi_cpufreq dm_mirror dm_mod video output sbs sbshc battery acpi_memhotplug ac parport_pc lp parport sg floppy tg3 button ide_cd_mod cdrom serio_raw i2c_i801 pcspkr e752x_edac edac_core shpchp i2c_core aic79xx scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded: microcode]
Pid: 3069, comm: modprobe Not tainted 2.6.25-rc2-mm1-autotest #1
RIP: 0010:[<ffffffff802ee99a>]  [<ffffffff802ee99a>] security_inode_getattr+0x4/0x21
RSP: 0018:ffff8101da9e9ea0  EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff8101e1cd7a40 RCX: 0000000000000001
RDX: ffff8101da9e9ef8 RSI: ffff8101e1cd7a40 RDI: ffff8101e5946dc0
RBP: 00000000fffffff7 R08: 0000000000000002 R09: 0000000000000002
R10: 0000000000000002 R11: 0000000000000246 R12: 0000000000000000
R13: ffff8101da9e9ef8 R14: ffff8101e5946dc0 R15: 000000000061a660
FS:  00007fc33bc746f0(0000) GS:ffff8101e714de40(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000219 CR3: 00000001da894000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 3069, threadinfo ffff8101da9e8000, task ffff8101e51975e0)
Stack:  ffffffff8028e55d ffff8101e7111300 00000000fffffff7 ffff8101da9e9ef8
 0000000000000003 0000000000000001 ffffffff8028e5ca 00007fff43c90120
 0000000000618e40 0000000000000000 ffffffff8028e5ec ffffffff8025b7e3
Call Trace:
 [<ffffffff8028e55d>] vfs_getattr+0x1a/0x5e
 [<ffffffff8028e5ca>] vfs_fstat+0x29/0x3a
 [<ffffffff8028e5ec>] sys_newfstat+0x11/0x29
 [<ffffffff8025b7e3>] audit_syscall_exit+0x2e4/0x303
 [<ffffffff8020bf6e>] tracesys+0x71/0xe1
 [<ffffffff8020bfd9>] tracesys+0xdc/0xe1


Code: 8b 98 a8 01 00 00 41 ff e3 31 c0 c3 f6 87 19 02 00 00 02 75 11 48 8b 05 7d 0d 64 00 4c 8b 98 a0 01 00 00 41 ff e3 c3 48 8b 46 10 <f6> 80 19 02 00 00 02 75 11 48 8b 05 5e 0d 64 00 4c 8b 98 98 01 
RIP  [<ffffffff802ee99a>] security_inode_getattr+0x4/0x21
 RSP <ffff8101da9e9ea0>
CR2: 0000000000000219
---[ end trace ea9acd9e67a1740e ]---
BUG: unable to handle kernel NULL pointer dereference at 00000000000000b2
IP: [<ffffffff802c5734>] dnotify_flush+0x18/0x84
PGD 0 
Oops: 0000 [2] SMP 
last sysfs file: /sys/devices/system/cpu/cpu1/cpufreq/scaling_setspeed
CPU 0 
Modules linked in: auth_rpcgss exportfs autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 acpi_cpufreq dm_mirror dm_mod video output sbs sbshc battery acpi_memhotplug ac parport_pc lp parport sg floppy tg3 button ide_cd_mod cdrom serio_raw i2c_i801 pcspkr e752x_edac edac_core shpchp i2c_core aic79xx scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded: microcode]
Pid: 3069, comm: modprobe Tainted: G      D   2.6.25-rc2-mm1-autotest #1
RIP: 0010:[<ffffffff802c5734>]  [<ffffffff802c5734>] dnotify_flush+0x18/0x84
RSP: 0018:ffff8101da9e9ca8  EFLAGS: 00010292
RAX: ffff8101e1cd7a40 RBX: ffff8101e7111300 RCX: 0000000000000058
RDX: 0000000000000000 RSI: ffff8101e4488cc0 RDI: ffff8101e7111300
RBP: 0000000000000000 R08: ffff8101e343d7c0 R09: ffff81000d800000
R10: 0000000000000001 R11: ffffffff802eed8e R12: ffff8101e7111300
R13: ffff8101e4488cc0 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff805b7000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000000000b2 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 3069, threadinfo ffff8101da9e8000, task ffff8101e51975e0)
Stack:  ffff8101e343d7c0 ffff8101e7111300 ffff8101e4488cc0 0000000000000000
 ffff8101e4488cd0 ffffffff80289c58 ffff8101e4488cc0 0000000000000001
 0000000000000000 ffffffff802343a8 ffff8101e343d7c0 0000000000000001
Call Trace:
 [<ffffffff80289c58>] filp_close+0x4a/0x65
 [<ffffffff802343a8>] put_files_struct+0x66/0xc4
 [<ffffffff8023556e>] do_exit+0x261/0x6cf
 [<ffffffff80470c71>] oops_begin+0x0/0x8c
 [<ffffffff804729c5>] do_page_fault+0x73d/0x7f6
 [<ffffffff804708b9>] error_exit+0x0/0x51
 [<ffffffff802ee99a>] security_inode_getattr+0x4/0x21
 [<ffffffff8028e55d>] vfs_getattr+0x1a/0x5e
 [<ffffffff8028e5ca>] vfs_fstat+0x29/0x3a
 [<ffffffff8028e5ec>] sys_newfstat+0x11/0x29
 [<ffffffff8025b7e3>] audit_syscall_exit+0x2e4/0x303
 [<ffffffff8020bf6e>] tracesys+0x71/0xe1
 [<ffffffff8020bfd9>] tracesys+0xdc/0xe1


Code: 5b ff ff ff fe 85 b4 00 00 00 5b 5d 41 5c 41 5d 41 5e c3 41 55 49 89 f5 41 54 49 89 fc 55 53 48 83 ec 08 48 8b 47 18 48 8b 68 10 <0f> b7 85 b2 00 00 00 25 00 f0 00 00 3d 00 40 00 00 75 51 48 8d 
RIP  [<ffffffff802c5734>] dnotify_flush+0x18/0x84
 RSP <ffff8101da9e9ca8>
CR2: 00000000000000b2
---[ end trace ea9acd9e67a1740e ]---
BUG: unable to handle kernel NULL pointer dereference at 0000000000000219
IP: [<ffffffff802ee99a>] security_inode_getattr+0x4/0x21
PGD 0 
Oops: 0000 [3] SMP 
last sysfs file: /sys/devices/system/cpu/cpu1/cpufreq/scaling_setspeed
CPU 1 
Modules linked in: auth_rpcgss exportfs autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 acpi_cpufreq dm_mirror dm_mod video output sbs sbshc battery acpi_memhotplug ac parport_pc lp parport sg floppy tg3 button ide_cd_mod cdrom serio_raw i2c_i801 pcspkr e752x_edac edac_core shpchp i2c_core aic79xx scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded: microcode]
Pid: 3040, comm: xinetd Tainted: G      D   2.6.25-rc2-mm1-autotest #1
RIP: 0010:[<ffffffff802ee99a>]  [<ffffffff802ee99a>] security_inode_getattr+0x4/0x21
RSP: 0018:ffff8101da9cdea0  EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff8101e1ceba40 RCX: 0000000000000001
RDX: ffff8101da9cdef8 RSI: ffff8101e1ceba40 RDI: ffff8101e5946dc0
RBP: 00000000fffffff7 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000000
R13: ffff8101da9cdef8 R14: ffff8101e5946dc0 R15: 00007fff27284020
FS:  00007f431f23e710(0000) GS:ffff8101e710b6c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000219 CR3: 00000001da8a8000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process xinetd (pid: 3040, threadinfo ffff8101da9cc000, task ffff8101e72f6240)
Stack:  ffffffff8028e55d ffff8101e5c27500 00000000fffffff7 ffff8101da9cdef8
 00007f431f487bd8 0000000000000006 ffffffff8028e5ca 00007fff27283910
 0000000000000006 0000000000000000 ffffffff8028e5ec ffffffff8025b7e3
Call Trace:
 [<ffffffff8028e55d>] vfs_getattr+0x1a/0x5e
 [<ffffffff8028e5ca>] vfs_fstat+0x29/0x3a
 [<ffffffff8028e5ec>] sys_newfstat+0x11/0x29
 [<ffffffff8025b7e3>] audit_syscall_exit+0x2e4/0x303
 [<ffffffff8020bf6e>] tracesys+0x71/0xe1
 [<ffffffff8020bfd9>] tracesys+0xdc/0xe1


Code: 8b 98 a8 01 00 00 41 ff e3 31 c0 c3 f6 87 19 02 00 00 02 75 11 48 8b 05 7d 0d 64 00 4c 8b 98 a0 01 00 00 41 ff e3 c3 48 8b 46 10 <f6> 80 19 02 00 00 02 75 11 48 8b 05 5e 0d 64 00 4c 8b 98 98 01 
RIP  [<ffffffff802ee99a>] security_inode_getattr+0x4/0x21
 RSP <ffff8101da9cdea0>
CR2: 0000000000000219
---[ end trace ea9acd9e67a1740e ]---
BUG: unable to handle kernel NULL pointer dereference at 00000000000000b2
IP: [<ffffffff802c5734>] dnotify_flush+0x18/0x84
PGD 0 
Oops: 0000 [4] SMP 
last sysfs file: /sys/devices/system/cpu/cpu1/cpufreq/scaling_setspeed
CPU 1 
Modules linked in: auth_rpcgss exportfs autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 acpi_cpufreq dm_mirror dm_mod video output sbs sbshc battery acpi_memhotplug ac parport_pc lp parport sg floppy tg3 button ide_cd_mod cdrom serio_raw i2c_i801 pcspkr e752x_edac edac_core shpchp i2c_core aic79xx scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded: microcode]
Pid: 3040, comm: xinetd Tainted: G      D   2.6.25-rc2-mm1-autotest #1
RIP: 0010:[<ffffffff802c5734>]  [<ffffffff802c5734>] dnotify_flush+0x18/0x84
RSP: 0018:ffff8101da9cdca8  EFLAGS: 00010292
RAX: ffff8101e1ceba40 RBX: ffff8101e5c27500 RCX: 000000000000013d
RDX: 0000000000000010 RSI: ffff8101e596a980 RDI: ffff8101e5c27500
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000008
R10: 0000000000000001 R11: ffffffff802eed8e R12: ffff8101e5c27500
R13: ffff8101e596a980 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8101e710b6c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000000000b2 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process xinetd (pid: 3040, threadinfo ffff8101da9cc000, task ffff8101e72f6240)
Stack:  ffff8101e596a980 ffff8101e5c27500 ffff8101e596a980 0000000000000000
 ffff8101e596a990 ffffffff80289c58 ffff8101e596a980 0000000000000003
 0000000000000030 ffffffff802343a8 ffff8101e45401c0 0000000000000001
Call Trace:
 [<ffffffff80289c58>] filp_close+0x4a/0x65
 [<ffffffff802343a8>] put_files_struct+0x66/0xc4
 [<ffffffff8023556e>] do_exit+0x261/0x6cf
 [<ffffffff80374e77>] do_unblank_screen+0x1b/0x11c
 [<ffffffff80470c71>] oops_begin+0x0/0x8c
 [<ffffffff804729c5>] do_page_fault+0x73d/0x7f6
 [<ffffffff804708b9>] error_exit+0x0/0x51
 [<ffffffff802ee99a>] security_inode_getattr+0x4/0x21
 [<ffffffff8028e55d>] vfs_getattr+0x1a/0x5e
 [<ffffffff8028e5ca>] vfs_fstat+0x29/0x3a
 [<ffffffff8028e5ec>] sys_newfstat+0x11/0x29
 [<ffffffff8025b7e3>] audit_syscall_exit+0x2e4/0x303
 [<ffffffff8020bf6e>] tracesys+0x71/0xe1
 [<ffffffff8020bfd9>] tracesys+0xdc/0xe1


Code: 5b ff ff ff fe 85 b4 00 00 00 5b 5d 41 5c 41 5d 41 5e c3 41 55 49 89 f5 41 54 49 89 fc 55 53 48 83 ec 08 48 8b 47 18 48 8b 68 10 <0f> b7 85 b2 00 00 00 25 00 f0 00 00 3d 00 40 00 00 75 51 48 8d 
RIP  [<ffffffff802c5734>] dnotify_flush+0x18/0x84
 RSP <ffff8101da9cdca8>
CR2: 00000000000000b2
---[ end trace ea9acd9e67a1740e ]---
Fixing recursive fault but reboot is needed!
Fixing recursive fault but reboot is needed!
eth0: no IPv6 routers present
Feb 16 23:54:16 x346 kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000219
Feb 16 23:54:16 x346 kernel: IP: [<ffffffff802ee99a>] security_inode_getattr+0x4/0x21
Feb 16 23:54:16 x346 kernel: Oops: 0000 [1] SMP 
Feb 16 23:54:16 x346 kernel: last sysfs file: /sys/devices/system/cpu/cpu1/cpufreq/scaling_setspeed
list_add corruption. next->prev should be prev (ffffffff805755b0), but was ffff8101e1ceba80. (next=ffff8101e1ceba80).
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:27!
invalid opcode: 0000 [5] SMP 
last sysfs file: /sys/devices/system/cpu/cpu1/cpufreq/scaling_setspeed
CPU 1 
Modules linked in: auth_rpcgss exportfs autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 acpi_cpufreq dm_mirror dm_mod video output sbs sbshc battery acpi_memhotplug ac parport_pc lp parport sg floppy tg3 button ide_cd_mod cdrom serio_raw i2c_i801 pcspkr e752x_edac edac_core shpchp i2c_core aic79xx scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded: microcode]
Pid: 3082, comm: sshd Tainted: G      D   2.6.25-rc2-mm1-autotest #1
RIP: 0010:[<ffffffff8031cd32>]  [<ffffffff8031cd32>] __list_add+0x27/0x5b
RSP: 0018:ffff8101e1811ee8  EFLAGS: 00010292
RAX: 0000000000000079 RBX: ffff8101e1cebd80 RCX: 000000000000afd7
RDX: 000000000000abab RSI: 0000000000000046 RDI: ffff8101e1d41bf8
RBP: ffff8101e5c635c0 R08: 0000000000000000 R09: ffff81000105bf00
R10: ffff81000105bf00 R11: 0000010500000010 R12: ffff8101e1d41bf8
R13: ffff8101e1d41bf8 R14: ffff8101e594b780 R15: ffff8101e1cebd80
FS:  00007f67a5991710(0000) GS:ffff8101e710b6c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f67a59b1000 CR3: 00000001da819000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process sshd (pid: 3082, threadinfo ffff8101e1810000, task ffff8101e596c1c0)
Stack:  ffff8101e5c635c0 ffffffff8029b997 0000000000000010 ffffffff8028c47d
 00000000fbad2418 ffff8101e5c635c0 ffff8101e5c78380 0000000000000000
 0000000000001000 00007f67a5182490 00007f67a4f7d191 ffffffff80289c6b
Call Trace:
 [<ffffffff8029b997>] dput+0xa6/0x102
 [<ffffffff8028c47d>] __fput+0x14f/0x17e
 [<ffffffff80289c6b>] filp_close+0x5d/0x65
 [<ffffffff8028ae72>] sys_close+0x7e/0xb7
 [<ffffffff8020bfd9>] tracesys+0xdc/0xe1


Code: 10 00 58 c3 48 83 ec 08 48 89 f0 48 89 d6 48 8b 52 08 48 39 c2 74 18 48 89 f1 48 c7 c7 f5 86 51 80 48 89 c6 31 c0 e8 e3 62 f1 ff <0f> 0b eb fe 4c 8b 00 49 39 f0 74 18 48 89 c1 4c 89 c2 48 c7 c7 
RIP  [<ffffffff8031cd32>] __list_add+0x27/0x5b
 RSP <ffff8101e1811ee8>
---[ end trace ea9acd9e67a1740e ]---
Feb 16 23:54:17 x346 kernel: Code: 8b 98 a8 01 00 00 41 ff e3 31 c0 c3 f6 87 19 02 00 00 02 75 11 48 8b 05 7d 0d 64 00 4c 8b 98 a0 01 00 00 41 ff e3 c3 48 8b 46 10 <f6> 80 19 02 00 00 02 75 11 48 8b 05 5e 0d 64 00 4c 8b 98 98 01 
BUG: soft lockup - CPU#2 stuck for 61s! [pcscd:2983]
CPU 2:
Modules linked in: auth_rpcgss exportfs autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 acpi_cpufreq dm_mirror dm_mod video output sbs sbshc battery acpi_memhotplug ac parport_pc lp parport sg floppy tg3 button ide_cd_mod cdrom serio_raw i2c_i801 pcspkr e752x_edac edac_core shpchp i2c_core aic79xx scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded: microcode]
Pid: 2983, comm: pcscd Tainted: G      D   2.6.25-rc2-mm1-autotest #1
RIP: 0010:[<ffffffff804705e4>]  [<ffffffff804705e4>] _spin_lock+0x12/0x15
RSP: 0018:ffff8101d9c0ddc0  EFLAGS: 00000297
RAX: 0000000000002d2c RBX: ffffffff80575680 RCX: 0000000000000000
RDX: ffff8101e1cd76dc RSI: ffffffff80523a21 RDI: ffffffff807cd600
RBP: 0000000100000103 R08: ffff8101e5c632c0 R09: 00000000fffffff2
R10: 0000000000000002 R11: ffffffff802eeda4 R12: ffff8101d9c0ded8
R13: 0000000000000282 R14: ffff8101e6c70d80 R15: ffff8101e5946dc0
FS:  00000000415ea940(0063) GS:ffff8101e714de40(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f235a6fee40 CR3: 00000001e352c000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff8029b73f>] d_alloc+0x154/0x193
 [<ffffffff802a582b>] dcache_dir_open+0x0/0x26
 [<ffffffff802a583f>] dcache_dir_open+0x14/0x26
 [<ffffffff80289fa9>] __dentry_open+0x12c/0x238
 [<ffffffff80295bf1>] do_filp_open+0x3d7/0x752
 [<ffffffff80245ec7>] hrtimer_cancel+0xc/0x16
 [<ffffffff8046f982>] do_nanosleep+0x5d/0x95
 [<ffffffff80289ce4>] get_unused_fd_flags+0x71/0x115
 [<ffffffff80289dce>] do_sys_open+0x46/0xc3
 [<ffffffff8020bfd9>] tracesys+0xdc/0xe1

BUG: soft lockup - CPU#0 stuck for 61s! [cpuspeed:2401]
CPU 0:
Modules linked in: auth_rpcgss exportfs autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 acpi_cpufreq dm_mirror dm_mod video output sbs sbshc battery acpi_memhotplug ac parport_pc lp parport sg floppy tg3 button ide_cd_mod cdrom serio_raw i2c_i801 pcspkr e752x_edac edac_core shpchp i2c_core aic79xx scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded: microcode]
Pid: 2401, comm: cpuspeed Tainted: G      D   2.6.25-rc2-mm1-autotest #1
RIP: 0010:[<ffffffff804705e2>]  [<ffffffff804705e2>] _spin_lock+0x10/0x15
RSP: 0018:ffff8101e5dc9c00  EFLAGS: 00000287
RAX: 000000000000302c RBX: ffff8101e5dc9cb8 RCX: 0000000000000000
RDX: ffff8101e1de4d5c RSI: ffff8101e52ff00a RDI: ffffffff807cd600
RBP: ffffffff802eed00 R08: ffff8101e6cb3b28 R09: 00000000fffffff2
R10: 0000000000008001 R11: ffffffff802eed62 R12: ffff8101da840b00
R13: 0000000000000000 R14: ffffffff8031886d R15: ffff8101e5dc9b98
FS:  00007f46fd5656f0(0000) GS:ffffffff805b7000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fd65423bc60 CR3: 00000001e511c000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff8029b73f>] d_alloc+0x154/0x193
 [<ffffffff802923bd>] do_lookup+0xa0/0x1af
 [<ffffffff802943db>] __link_path_walk+0x81b/0xc49
 [<ffffffff80294858>] link_path_walk+0x4f/0xb2
 [<ffffffff80294bcf>] do_path_lookup+0x158/0x1cf
 [<ffffffff80295713>] __path_lookup_intent_open+0x56/0x97
 [<ffffffff802958b6>] do_filp_open+0x9c/0x752
 [<ffffffff80289ce4>] get_unused_fd_flags+0x71/0x115
 [<ffffffff80289dce>] do_sys_open+0x46/0xc3
 [<ffffffff8020be5b>] system_call_after_swapgs+0x7b/0x80

BUG: soft lockup - CPU#3 stuck for 61s! [syslogd:2720]
CPU 3:
Modules linked in: auth_rpcgss exportfs autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 acpi_cpufreq dm_mirror dm_mod video output sbs sbshc battery acpi_memhotplug ac parport_pc lp parport sg floppy tg3 button ide_cd_mod cdrom serio_raw i2c_i801 pcspkr e752x_edac edac_core shpchp i2c_core aic79xx scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded: microcode]
Pid: 2720, comm: syslogd Tainted: G      D   2.6.25-rc2-mm1-autotest #1
RIP: 0010:[<ffffffff804705e4>]  [<ffffffff804705e4>] _spin_lock+0x12/0x15
RSP: 0018:ffff8101e18ebcb0  EFLAGS: 00000293
RAX: 0000000000002f2c RBX: ffffffff807cd600 RCX: 0000000000000001
RDX: ffff8101e18ebeb8 RSI: ffffffff807cd600 RDI: ffffffff807cd600
RBP: ffff8101e5d09598 R08: ffff8101e18ebeb8 R09: 00007f235ae0dfe0
R10: 0000000000000002 R11: ffffffff802eed62 R12: ffff810001035b00
R13: ffff8101e5d09598 R14: ffffffff802257da R15: ffff8101e18ebc38
FS:  00007f235abe06f0(0000) GS:ffff8101e714d640(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fd65286c879 CR3: 00000001e18d3000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff80314335>] _atomic_dec_and_lock+0x39/0x54
 [<ffffffff8029b940>] dput+0x4f/0x102
 [<ffffffff8029210e>] path_put+0xd/0x27
 [<ffffffff802947e8>] __link_path_walk+0xc28/0xc49
 [<ffffffff80294858>] link_path_walk+0x4f/0xb2
 [<ffffffff8025b4cc>] audit_syscall_entry+0x12d/0x160
 [<ffffffff8025b7e3>] audit_syscall_exit+0x2e4/0x303
 [<ffffffff8031a303>] __strncpy_from_user+0x17/0x41
 [<ffffffff80294bcf>] do_path_lookup+0x158/0x1cf
 [<ffffffff80293992>] getname+0x140/0x1a7
 [<ffffffff8029553e>] __user_walk_fd+0x37/0x4c
 [<ffffffff8028a4fb>] sys_faccessat+0xbb/0x175
 [<ffffffff8025b4cc>] audit_syscall_entry+0x12d/0x160
 [<ffffffff8025b7e3>] audit_syscall_exit+0x2e4/0x303
 [<ffffffff8020bfd9>] tracesys+0xdc/0xe1

BUG: soft lockup - CPU#1 stuck for 61s! [sshd:3082]
CPU 1:
Modules linked in: auth_rpcgss exportfs autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 acpi_cpufreq dm_mirror dm_mod video output sbs sbshc battery acpi_memhotplug ac parport_pc lp parport sg floppy tg3 button ide_cd_mod cdrom serio_raw i2c_i801 pcspkr e752x_edac edac_core shpchp i2c_core aic79xx scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded: microcode]
Pid: 3082, comm: sshd Tainted: G      D   2.6.25-rc2-mm1-autotest #1
RIP: 0010:[<ffffffff804705e4>]  [<ffffffff804705e4>] _spin_lock+0x12/0x15
RSP: 0018:ffff8101e1811c60  EFLAGS: 00000293
RAX: 0000000000002e2c RBX: ffffffff807cd600 RCX: 0000000000000001
RDX: 0000000000000019 RSI: ffffffff807cd600 RDI: ffffffff807cd600
RBP: 00000000000002d0 R08: 0000000000000004 R09: 0000000000000004
R10: ffffe200067cc738 R11: ffffffff802eed8e R12: 00000001da9ae148
R13: ffff8101da9ae080 R14: ffffffff80428f7e R15: ffff8101da821c80
FS:  0000000000000000(0000) GS:ffff8101e710b6c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f67a59b1000 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff80314335>] _atomic_dec_and_lock+0x39/0x54
 [<ffffffff8029b940>] dput+0x4f/0x102
 [<ffffffff8028c47d>] __fput+0x14f/0x17e
 [<ffffffff80289c6b>] filp_close+0x5d/0x65
 [<ffffffff802343a8>] put_files_struct+0x66/0xc4
 [<ffffffff8023556e>] do_exit+0x261/0x6cf
 [<ffffffff80470c71>] oops_begin+0x0/0x8c
 [<ffffffff8020dcbe>] do_invalid_op+0x87/0x91
 [<ffffffff8031cd32>] __list_add+0x27/0x5b
 [<ffffffff80317c5b>] __up_read+0x19/0x7f
 [<ffffffff80233063>] printk+0x4e/0x56
 [<ffffffff804708b9>] error_exit+0x0/0x51
 [<ffffffff8031cd32>] __list_add+0x27/0x5b
 [<ffffffff8031cd32>] __list_add+0x27/0x5b
 [<ffffffff8029b997>] dput+0xa6/0x102
 [<ffffffff8028c47d>] __fput+0x14f/0x17e
 [<ffffffff80289c6b>] filp_close+0x5d/0x65
 [<ffffffff8028ae72>] sys_close+0x7e/0xb7
 [<ffffffff8020bfd9>] tracesys+0xdc/0xe1


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
