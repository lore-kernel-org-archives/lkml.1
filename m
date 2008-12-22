Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbYLVVGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbYLVVGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 16:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYLVVGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:06:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751183AbYLVVGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:06:01 -0500
Date: Mon, 22 Dec 2008 13:05:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: <draschi@ibs.sm>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       stable@kernel.org
Subject: Re: BUG smbd crash
Message-Id: <20081222130545.f318ecb4.akpm@linux-foundation.org>
In-Reply-To: <000701c9643e$9d949480$1b02a8c0@client018>
References: <000701c9643e$9d949480$1b02a8c0@client018>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2008 15:07:24 +0100
"Diego Raschi" <draschi@ibs.sm> wrote:

> 1.smbd crash
> 2.The daemon smbd crash and after restart the system is unstable.
> 3.daemon
> 4.Linux version 2.6.27.8.fc9.x86_64 (root@node1) (gcc version 4.3.0 20080428
> (Red Hat 4.3.0-8) (GCC) ) #3 SMP Thu Dec 18 10:40:19 CET 2008
> 5.Mon Dec 22 13:49:01 CET 2008
> BUG: soft lockup - CPU#5 stuck for 61s! [smbd:16614]
> Modules linked in: sha256_generic aes_x86_64 aes_generic cbc dm_crypt
> crypto_blkcipher nfs lockd nfs_acl ipmi_si ipmi_devintf ipmi_msghandler
> sunrpc bonding ipv6 xfs dm_mirror dm_log dm_multipath dm_mod kvm_amd kvm
> sr_mod cdrom raid0 ata_generic pata_amd cfi_cmdset_0002 pcspkr cfi_util
> ppdev sata_nv pata_acpi floppy libata button jedec_probe parport_pc
> cfi_probe gen_probe ck804xrom parport mtd qla2xxx chipreg scsi_transport_fc
> scsi_tgt map_funcs sg forcedeth i2c_nforce2 i2c_core shpchp 3w_9xxx sd_mod
> scsi_mod raid456 async_xor async_memcpy async_tx xor raid1 ext3 jbd mbcache
> uhci_hcd ohci_hcd ehci_hcd [last unloaded: e1000]
> CPU 5:
> Modules linked in: sha256_generic aes_x86_64 aes_generic cbc dm_crypt
> crypto_blkcipher nfs lockd nfs_acl ipmi_si ipmi_devintf ipmi_msghandler
> sunrpc bonding ipv6 xfs dm_mirror dm_log dm_multipath dm_mod kvm_amd kvm
> sr_mod cdrom raid0 ata_generic pata_amd cfi_cmdset_0002 pcspkr cfi_util
> ppdev sata_nv pata_acpi floppy libata button jedec_probe parport_pc
> cfi_probe gen_probe ck804xrom parport mtd qla2xxx chipreg scsi_transport_fc
> scsi_tgt map_funcs sg forcedeth i2c_nforce2 i2c_core shpchp 3w_9xxx sd_mod
> scsi_mod raid456 async_xor async_memcpy async_tx xor raid1 ext3 jbd mbcache
> uhci_hcd ohci_hcd ehci_hcd [last unloaded: e1000]
> Pid: 16614, comm: smbd Not tainted 2.6.27.8.fc9.x86_64 #3
> RIP: 0010:[<ffffffff812a1871>]  [<ffffffff812a1871>] mutex_lock+0x23/0x2e
> RSP: 0000:ffff88032f0c1e38  EFLAGS: 00000246
> RAX: 0000000000000246 RBX: ffff88032f0c1e48 RCX: 0000000000000002
> RDX: ffff88032e91ebc0 RSI: 0000000000000058 RDI: ffff88010b65d3f0
> RBP: 0000000000000000 R08: ffff88032f0c0000 R09: 0000000000000000
> R10: 0000150d29bc50cf R11: ffff8802dca56048 R12: 0000150d29bc50cf
> R13: ffff8802dca56048 R14: ffff88032f0c1e28 R15: 0000000000000000
> FS:  00007f011676a7a0(0000) GS:ffff88022fa13200(0000) knlGS:00000000f7fd86c0
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000002642fc0 CR3: 000000032e91d000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> 
> Call Trace:
>  [<ffffffff812a186b>] ? mutex_lock+0x1d/0x2e
>  [<ffffffff810dbd0e>] ? inotify_destroy+0x83/0xda
>  [<ffffffff810dbefe>] ? inotify_release+0x28/0xd7
>  [<ffffffff810b2202>] ? __fput+0xc5/0x184
>  [<ffffffff810b22d6>] ? fput+0x15/0x17
>  [<ffffffff810af745>] ? filp_close+0x67/0x72
>  [<ffffffff810af7fd>] ? sys_close+0xad/0xf0
>  [<ffffffff8100c0ea>] ? system_call_fastpath+0x16/0x1b

Is this a regression?  Were any earlier kernels OK?  2.6.27.7?

An inotify fix went into 2.6.27.8 and I seem to recall that there might
have been some problems with it.

