Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbYLVVN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbYLVVN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 16:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbYLVVNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:13:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51197 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbYLVVNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:13:19 -0500
Date: Mon, 22 Dec 2008 21:13:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: draschi@ibs.sm, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: BUG smbd crash
Message-ID: <20081222211316.GM28946@ZenIV.linux.org.uk>
References: <000701c9643e$9d949480$1b02a8c0@client018> <20081222130545.f318ecb4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081222130545.f318ecb4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2008 at 01:05:45PM -0800, Andrew Morton wrote:
> On Mon, 22 Dec 2008 15:07:24 +0100
> "Diego Raschi" <draschi@ibs.sm> wrote:
> 
> > 1.smbd crash
> > 2.The daemon smbd crash and after restart the system is unstable.
> > 3.daemon
> > 4.Linux version 2.6.27.8.fc9.x86_64 (root@node1) (gcc version 4.3.0 20080428
> > (Red Hat 4.3.0-8) (GCC) ) #3 SMP Thu Dec 18 10:40:19 CET 2008
> > 5.Mon Dec 22 13:49:01 CET 2008
> > BUG: soft lockup - CPU#5 stuck for 61s! [smbd:16614]
> > Modules linked in: sha256_generic aes_x86_64 aes_generic cbc dm_crypt
> > crypto_blkcipher nfs lockd nfs_acl ipmi_si ipmi_devintf ipmi_msghandler
> > sunrpc bonding ipv6 xfs dm_mirror dm_log dm_multipath dm_mod kvm_amd kvm
> > sr_mod cdrom raid0 ata_generic pata_amd cfi_cmdset_0002 pcspkr cfi_util
> > ppdev sata_nv pata_acpi floppy libata button jedec_probe parport_pc
> > cfi_probe gen_probe ck804xrom parport mtd qla2xxx chipreg scsi_transport_fc
> > scsi_tgt map_funcs sg forcedeth i2c_nforce2 i2c_core shpchp 3w_9xxx sd_mod
> > scsi_mod raid456 async_xor async_memcpy async_tx xor raid1 ext3 jbd mbcache
> > uhci_hcd ohci_hcd ehci_hcd [last unloaded: e1000]
> > CPU 5:
> > Modules linked in: sha256_generic aes_x86_64 aes_generic cbc dm_crypt
> > crypto_blkcipher nfs lockd nfs_acl ipmi_si ipmi_devintf ipmi_msghandler
> > sunrpc bonding ipv6 xfs dm_mirror dm_log dm_multipath dm_mod kvm_amd kvm
> > sr_mod cdrom raid0 ata_generic pata_amd cfi_cmdset_0002 pcspkr cfi_util
> > ppdev sata_nv pata_acpi floppy libata button jedec_probe parport_pc
> > cfi_probe gen_probe ck804xrom parport mtd qla2xxx chipreg scsi_transport_fc
> > scsi_tgt map_funcs sg forcedeth i2c_nforce2 i2c_core shpchp 3w_9xxx sd_mod
> > scsi_mod raid456 async_xor async_memcpy async_tx xor raid1 ext3 jbd mbcache
> > uhci_hcd ohci_hcd ehci_hcd [last unloaded: e1000]
> > Pid: 16614, comm: smbd Not tainted 2.6.27.8.fc9.x86_64 #3
> > RIP: 0010:[<ffffffff812a1871>]  [<ffffffff812a1871>] mutex_lock+0x23/0x2e
> > RSP: 0000:ffff88032f0c1e38  EFLAGS: 00000246
> > RAX: 0000000000000246 RBX: ffff88032f0c1e48 RCX: 0000000000000002
> > RDX: ffff88032e91ebc0 RSI: 0000000000000058 RDI: ffff88010b65d3f0
> > RBP: 0000000000000000 R08: ffff88032f0c0000 R09: 0000000000000000
> > R10: 0000150d29bc50cf R11: ffff8802dca56048 R12: 0000150d29bc50cf
> > R13: ffff8802dca56048 R14: ffff88032f0c1e28 R15: 0000000000000000
> > FS:  00007f011676a7a0(0000) GS:ffff88022fa13200(0000) knlGS:00000000f7fd86c0
> > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > CR2: 0000000002642fc0 CR3: 000000032e91d000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > 
> > Call Trace:
> >  [<ffffffff812a186b>] ? mutex_lock+0x1d/0x2e
> >  [<ffffffff810dbd0e>] ? inotify_destroy+0x83/0xda
> >  [<ffffffff810dbefe>] ? inotify_release+0x28/0xd7
> >  [<ffffffff810b2202>] ? __fput+0xc5/0x184
> >  [<ffffffff810b22d6>] ? fput+0x15/0x17
> >  [<ffffffff810af745>] ? filp_close+0x67/0x72
> >  [<ffffffff810af7fd>] ? sys_close+0xad/0xf0
> >  [<ffffffff8100c0ea>] ? system_call_fastpath+0x16/0x1b
> 
> Is this a regression?  Were any earlier kernels OK?  2.6.27.7?
> 
> An inotify fix went into 2.6.27.8 and I seem to recall that there might
> have been some problems with it.

It's IDR breakage, actually; introduced in
6ff2d39b91aec3dcae951afa982059e3dd9b49dc, fixed in
711a49a07f84f914aac26a52143f6e7526571143.  IIRC, .10 has the fix in place.
