Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbYBQF0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbYBQF0L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 00:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbYBQFZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 00:25:59 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48884 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750794AbYBQFZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 00:25:58 -0500
Date: Sat, 16 Feb 2008 21:24:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andy Whitcroft <apw@shadowen.org>,
       Dave Hansen <haveblue@us.ibm.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: 2.6.25-rc2-mm1
Message-Id: <20080216212446.0713aeae.akpm@linux-foundation.org>
In-Reply-To: <47B7C13C.1080004@linux.vnet.ibm.com>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<47B7C13C.1080004@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 10:38:12 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> The 2.6.25-rc2-mm1 kernel oopses, followed by softlockup several times (have pasted
> only some of them) on the x86_64 machine. The machine has 4 cpu(s).
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000219
> IP: [<ffffffff802ee99a>] security_inode_getattr+0x4/0x21
> PGD 1da947067 PUD 1e1803067 PMD 0 
> Oops: 0000 [1] SMP 
> last sysfs file: /sys/devices/system/cpu/cpu1/cpufreq/scaling_setspeed
> CPU 2 
> Modules linked in: auth_rpcgss exportfs autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 acpi_cpufreq dm_mirror dm_mod video output sbs sbshc battery acpi_memhotplug ac parport_pc lp parport sg floppy tg3 button ide_cd_mod cdrom serio_raw i2c_i801 pcspkr e752x_edac edac_core shpchp i2c_core aic79xx scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded: microcode]
> Pid: 3069, comm: modprobe Not tainted 2.6.25-rc2-mm1-autotest #1
> RIP: 0010:[<ffffffff802ee99a>]  [<ffffffff802ee99a>] security_inode_getattr+0x4/0x21
> RSP: 0018:ffff8101da9e9ea0  EFLAGS: 00010286
> RAX: 0000000000000000 RBX: ffff8101e1cd7a40 RCX: 0000000000000001
> RDX: ffff8101da9e9ef8 RSI: ffff8101e1cd7a40 RDI: ffff8101e5946dc0
> RBP: 00000000fffffff7 R08: 0000000000000002 R09: 0000000000000002
> R10: 0000000000000002 R11: 0000000000000246 R12: 0000000000000000
> R13: ffff8101da9e9ef8 R14: ffff8101e5946dc0 R15: 000000000061a660
> FS:  00007fc33bc746f0(0000) GS:ffff8101e714de40(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000219 CR3: 00000001da894000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process modprobe (pid: 3069, threadinfo ffff8101da9e8000, task ffff8101e51975e0)
> Stack:  ffffffff8028e55d ffff8101e7111300 00000000fffffff7 ffff8101da9e9ef8
>  0000000000000003 0000000000000001 ffffffff8028e5ca 00007fff43c90120
>  0000000000618e40 0000000000000000 ffffffff8028e5ec ffffffff8025b7e3
> Call Trace:
>  [<ffffffff8028e55d>] vfs_getattr+0x1a/0x5e
>  [<ffffffff8028e5ca>] vfs_fstat+0x29/0x3a
>  [<ffffffff8028e5ec>] sys_newfstat+0x11/0x29
>  [<ffffffff8025b7e3>] audit_syscall_exit+0x2e4/0x303
>  [<ffffffff8020bf6e>] tracesys+0x71/0xe1
>  [<ffffffff8020bfd9>] tracesys+0xdc/0xe1
> 
> 
> Code: 8b 98 a8 01 00 00 41 ff e3 31 c0 c3 f6 87 19 02 00 00 02 75 11 48 8b 05 7d 0d 64 00 4c 8b 98 a0 01 00 00 41 ff e3 c3 48 8b 46 10 <f6> 80 19 02 00 00 02 75 11 48 8b 05 5e 0d 64 00 4c 8b 98 98 01 

Beats me.  Looks like we somehow passed a garbage dentry* into
security_inode_getattr().  But 0x219?  That could be an offset from an
accidentally IS_ERR pointer, but sizeof(struct dentry) is only 0xa0 here,
so the pointer would have to have a value of -0x139 or less, and that's
outside the range of any sane errnos.

If it's reproducible then a bisection search would be great, please.
