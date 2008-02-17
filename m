Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbYBQHhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbYBQHhx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 02:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbYBQHhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 02:37:40 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:45610 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbYBQHgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 02:36:53 -0500
Message-ID: <47B7E3F9.7080208@linux.vnet.ibm.com>
Date: Sun, 17 Feb 2008 13:06:25 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andy Whitcroft <apw@shadowen.org>,
       Dave Hansen <haveblue@us.ibm.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: 2.6.25-rc2-mm1
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7C13C.1080004@linux.vnet.ibm.com> <20080216212446.0713aeae.akpm@linux-foundation.org>
In-Reply-To: <20080216212446.0713aeae.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sun, 17 Feb 2008 10:38:12 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
>> The 2.6.25-rc2-mm1 kernel oopses, followed by softlockup several times (have pasted
>> only some of them) on the x86_64 machine. The machine has 4 cpu(s).
>>
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000219
>> IP: [<ffffffff802ee99a>] security_inode_getattr+0x4/0x21
>> PGD 1da947067 PUD 1e1803067 PMD 0 
>> Oops: 0000 [1] SMP 
>> last sysfs file: /sys/devices/system/cpu/cpu1/cpufreq/scaling_setspeed
>> CPU 2 
>> Modules linked in: auth_rpcgss exportfs autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 acpi_cpufreq dm_mirror dm_mod video output sbs sbshc battery acpi_memhotplug ac parport_pc lp parport sg floppy tg3 button ide_cd_mod cdrom serio_raw i2c_i801 pcspkr e752x_edac edac_core shpchp i2c_core aic79xx scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded: microcode]
>> Pid: 3069, comm: modprobe Not tainted 2.6.25-rc2-mm1-autotest #1
>> RIP: 0010:[<ffffffff802ee99a>]  [<ffffffff802ee99a>] security_inode_getattr+0x4/0x21
>> RSP: 0018:ffff8101da9e9ea0  EFLAGS: 00010286
>> RAX: 0000000000000000 RBX: ffff8101e1cd7a40 RCX: 0000000000000001
>> RDX: ffff8101da9e9ef8 RSI: ffff8101e1cd7a40 RDI: ffff8101e5946dc0
>> RBP: 00000000fffffff7 R08: 0000000000000002 R09: 0000000000000002
>> R10: 0000000000000002 R11: 0000000000000246 R12: 0000000000000000
>> R13: ffff8101da9e9ef8 R14: ffff8101e5946dc0 R15: 000000000061a660
>> FS:  00007fc33bc746f0(0000) GS:ffff8101e714de40(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> CR2: 0000000000000219 CR3: 00000001da894000 CR4: 00000000000006e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process modprobe (pid: 3069, threadinfo ffff8101da9e8000, task ffff8101e51975e0)
>> Stack:  ffffffff8028e55d ffff8101e7111300 00000000fffffff7 ffff8101da9e9ef8
>>  0000000000000003 0000000000000001 ffffffff8028e5ca 00007fff43c90120
>>  0000000000618e40 0000000000000000 ffffffff8028e5ec ffffffff8025b7e3
>> Call Trace:
>>  [<ffffffff8028e55d>] vfs_getattr+0x1a/0x5e
>>  [<ffffffff8028e5ca>] vfs_fstat+0x29/0x3a
>>  [<ffffffff8028e5ec>] sys_newfstat+0x11/0x29
>>  [<ffffffff8025b7e3>] audit_syscall_exit+0x2e4/0x303
>>  [<ffffffff8020bf6e>] tracesys+0x71/0xe1
>>  [<ffffffff8020bfd9>] tracesys+0xdc/0xe1
>>
>>
>> Code: 8b 98 a8 01 00 00 41 ff e3 31 c0 c3 f6 87 19 02 00 00 02 75 11 48 8b 05 7d 0d 64 00 4c 8b 98 a0 01 00 00 41 ff e3 c3 48 8b 46 10 <f6> 80 19 02 00 00 02 75 11 48 8b 05 5e 0d 64 00 4c 8b 98 98 01 
> 
> Beats me.  Looks like we somehow passed a garbage dentry* into
> security_inode_getattr().  But 0x219?  That could be an offset from an
> accidentally IS_ERR pointer, but sizeof(struct dentry) is only 0xa0 here,
> so the pointer would have to have a value of -0x139 or less, and that's
> outside the range of any sane errnos.
> 
> If it's reproducible then a bisection search would be great, please.
Hi Andrew,

I tried reproducing this panic, but was unsuccessful is reproducing it even after four rounds of
try, One of those round i had the following kernel panic 

BUG: unable to handle kernel paging request at 000000000508fffe
IP: [<ffff8101e5d15e44>]
PGD 1e382b067 PUD 1e38a9067 PMD 0 
Oops: 0002 [1] SMP 
last sysfs file: /sys/block/hda/removable
CPU 3 
Modules linked in: dm_mirror dm_mod video output sbs sbshc battery acpi_memhotplug ac parport_pc lp parport sg floppy tg3 ide_cd_mod button cdrom serio_raw i2c_i801 e752x_edac shpchp edac_core i2c_core pcspkr aic79xx scsi_transport_spi sd_mod scsi_mod ehci_hcd ohci_hcd uhci_hcd
Pid: 0, comm: swapper Not tainted 2.6.25-rc2-mm1-autotest #1
RIP: 0010:[<ffff8101e5d15e44>]  [<ffff8101e5d15e44>]
RSP: 0018:ffff8101e71dbf08  EFLAGS: 00010282
RAX: ffff8101e408cb00 RBX: ffff81000104175f RCX: ffffffffffffffff
RDX: 0000000000000060 RSI: 7fffffffffffffff RDI: ffff8101e408cb00
RBP: ffff8101e5839680 R08: 0000000000000004 R09: 000000000000003c
R10: ffff8101e711a4c8 R11: ffff8101e71dbf10 R12: 0000000000000002
R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8101e714d640(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 000000000508fffe CR3: 00000001e5cbf000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff8101e71d2000, task ffff8101e71cea70)
Stack:  ffffffff80260a4c 0000000000000001 ffffffff806800f0 000000000000000a
 ffffffff80260ada ffffffff806800e0 ffffffff80236f33 ffff8101e71d3e88
 0000000000000046 ffff8101e71dbf78 0000000000000000 0000000000000000
Call Trace:
 <IRQ>  [<ffffffff80260a4c>] __rcu_process_callbacks+0x10f/0x17a
 [<ffffffff80260ada>] rcu_process_callbacks+0x23/0x43
 [<ffffffff80236f33>] __do_softirq+0x55/0xc4
 [<ffffffff8020cfec>] call_softirq+0x1c/0x28
 [<ffffffff8020e677>] do_softirq+0x2c/0x68
 [<ffffffff8021bb1b>] smp_apic_timer_interrupt+0x8a/0xa3
 [<ffffffff8020ca96>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff8020adc7>] default_idle+0x31/0x55
 [<ffffffff8020adc2>] default_idle+0x2c/0x55
 [<ffffffff8020ad96>] default_idle+0x0/0x55
 [<ffffffff8020ae75>] cpu_idle+0x8a/0xac


Code: 00 00 00 00 00 00 00 20 5e d1 e5 01 81 ff ff 20 5e d1 e5 01 81 ff ff 00 00 00 00 00 00 00 00 20 62 cf e6 01 81 ff ff e0 0e ca e5 <01> 81 ff ff d8 c2 28 80 ff ff ff ff 00 00 00 00 00 00 00 00 00 
RIP  [<ffff8101e5d15e44>]
 RSP <ffff8101e71dbf08>
CR2: 000000000508fffe
BUG: unable to handle kernel <4>---[ end trace b5676e22cd1a5a92 ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!
paging request at 0000000005090005
IP: [<ffff8101e5d15e44>]
PGD 0 
Oops: 0002 [2] SMP 
last sysfs file: /sys/block/hda/removable
CPU 1 
Modules linked in: dm_mirror dm_mod video output sbs sbshc battery acpi_memhotplug ac parport_pc lp parport sg floppy tg3 ide_cd_mod button cdrom serio_raw i2c_i801 e752x_edac shpchp edac_core i2c_core pcspkr aic79xx scsi_transport_spi sd_mod scsi_mod ehci_hcd ohci_hcd uhci_hcd
Pid: 0, comm: swapper Tainted: G      D   2.6.25-rc2-mm1-autotest #1
RIP: 0010:[<ffff8101e5d15e44>]  [<ffff8101e5d15e44>]
RSP: 0018:ffff8101e716bf08  EFLAGS: 00010282
RAX: ffff8101e408cb00 RBX: ffff81000101f766 RCX: 0000000000000006
RDX: 000000000000004c RSI: 0000000000000030 RDI: ffff8101e408cb00
RBP: ffff8101e5839680 R08: 0000000000000010 R09: 0000000000000004
R10: 0000000000000000 R11: ffff8101e716bf10 R12: 0000000000000004
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8101e710b6c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000005090005 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff8101e7164000, task ffff8101e715c0c0)
Stack:  ffffffff80260a4c 0000000000000001 ffffffff806800f0 000000000000000a
 ffffffff80260ada 000000000000000a ffffffff80236f33 ffff8101e7165e88
 0000000000000046 ffff8101e716bf78 0000000000000000 0000000000000000
Call Trace:
 <IRQ>  [<ffffffff80260a4c>] __rcu_process_callbacks+0x10f/0x17a
 [<ffffffff80260ada>] rcu_process_callbacks+0x23/0x43
 [<ffffffff80236f33>] __do_softirq+0x55/0xc4
 [<ffffffff8020cfec>] call_softirq+0x1c/0x28
 [<ffffffff8020e677>] do_softirq+0x2c/0x68
 [<ffffffff8021bb1b>] smp_apic_timer_interrupt+0x8a/0xa3
 [<ffffffff8020ca96>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff8020adc7>] default_idle+0x31/0x55
 [<ffffffff8020adc2>] default_idle+0x2c/0x55
 [<ffffffff8020ad96>] default_idle+0x0/0x55
 [<ffffffff8020ae75>] cpu_idle+0x8a/0xac


Code: 00 00 00 00 00 00 00 20 5e d1 e5 01 81 ff ff 20 5e d1 e5 01 81 ff ff 00 00 00 00 00 00 00 00 20 62 cf e6 01 81 ff ff e0 0e ca e5 <01> 81 ff ff d8 c2 28 80 ff ff ff ff 00 00 00 00 00 00 00 00 00 
RIP  [<ffff8101e5d15e44>]
 RSP <ffff8101e716bf08>
CR2: 0000000005090005
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
