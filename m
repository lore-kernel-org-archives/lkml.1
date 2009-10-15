Return-Path: <linux-kernel-owner+w=401wt.eu-S935281AbZJOVfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935281AbZJOVfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 17:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935215AbZJOVfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 17:35:52 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:55789 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934760AbZJOVfv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 17:35:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=DToJRPu99KrpXTO8QaPyH6KGR4cOoJXEN3Zy2oeXx/aeVclwGMuUnMEFGfkKmbD/jU
         FXESSBwzzH/urgQHYJv/bflnZj559kvUJufHqD4fTNgcCCQ7HivyP4hWIW0rv9fxiINA
         QXiBmUgHC6OPzXaCfhHiZC2r51r0dLiGrfOvE=
MIME-Version: 1.0
In-Reply-To: <438397970910151312sc3ce9e9ge844dce0aa364f64@mail.gmail.com>
References: <438397970910151312sc3ce9e9ge844dce0aa364f64@mail.gmail.com>
Date: Thu, 15 Oct 2009 14:35:13 -0700
Message-ID: <438397970910151435m6af98ac1n3272101910a7815@mail.gmail.com>
Subject: Re: IO error and panic while doing iput(), kernel BUG at 
	fs/inode.c:1165!
From: Kallol Biswas <nucleodyne@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The umount is done with -l option (lazy).

On Thu, Oct 15, 2009 at 1:12 PM, Kallol Biswas <nucleodyne@gmail.com> wrote:
> Hi,
>   I have been getting a panic while unmounting the ext3 filesystem
> that is on a partition.
>
> The block device is a raid device. When the power to the disk shelf is
> lost we see a lot of IO errors in the dmesg. These are expected.
>
> Our application then tries to unmount the filesystem that has been
> created on a partition.
>
> At the end of __blkdev_put() on the partition the same routine is
> invoked in recursion on the whole disk.
>
> Since the whole disk's i_state is already I_CLEAR the system panics.
>
> Is this a known issue? Who release the reference to the whole device?
> udev/hotplug handler?
>
> I am running 2.6.23 kernel and did not see this problem on 2.6.12 kernel.
>
> Kallol
>
> g directory #2 offset 0
> (E3)[1255107782.100033] Buffer I/O error on device dd_dg10p1, logical block 0
> (E4)[1255107782.100120] lost page write due to I/O error on dd_dg10p1
> (E2)[1255107782.100221] EXT3-fs error (device dd_dg10p1):
> read_inode_bitmap: Cannot read inode bitmap - block_group = 3,
> inode_bitmap = 99377
> (E4)[1255107782.100462] WARNING: at fs/buffer.c:1154 mark_buffer_dirty()
> (E4)[1255107782.100544]
> (E4)[1255107782.100544] Call Trace:
> (E4)[1255107782.100720]  [<ffffffff802b2185>] mark_buffer_dirty+0xc5/0xd0
> (E4)[1255107782.100803]  [<ffffffff802e5bc7>] ext3_commit_super+0x57/0xa0
> (E4)[1255107782.100881]  [<ffffffff802e6064>] ext3_handle_error+0x54/0xe0
> (E4)[1255107782.100959]  [<ffffffff802e628d>] ext3_error+0xcd/0xe0
> (E4)[1255107782.101039]  [<ffffffff8034ff7e>] submit_bio+0x5e/0xe0
> (E4)[1255107782.101118]  [<ffffffff802b2f35>] submit_bh+0xf5/0x130
> (E4)[1255107782.101231]  [<ffffffff802dbae6>] read_inode_bitmap+0x86/0x90
> (E4)[1255107782.101340]  [<ffffffff802dc1fa>] ext3_new_inode+0x46a/0xac0
> (E4)[1255107782.101421]  [<ffffffff802e374e>] ext3_create+0x6e/0x100
> (E4)[1255107782.101499]  [<ffffffff802983dc>] vfs_create+0xac/0xf0
> (E4)[1255107782.101574]  [<ffffffff80298c47>] open_namei+0x617/0x680
> (E4)[1255107782.101653]  [<ffffffff8028d7bc>] do_filp_open+0x1c/0x50
> (E4)[1255107782.101733]  [<ffffffff8028d94f>] get_unused_fd_flags+0x3f/0x120
> (E4)[1255107782.101809]  [<ffffffff8028db9a>] do_sys_open+0x5a/0xf0
> (E4)[1255107782.101885]  [<ffffffff8020beb2>] system_call+0x82/0x87
> (E4)[1255107782.101962]
> (E3)[1255107782.102036] Buffer I/O error on device dd_dg10p1, logical block 0
> (E4)[1255107782.102143] lost page write due to I/O error on dd_dg10p1
> (E2)[1255107782.102251] EXT3-fs error (device dd_dg10p1) in
> ext3_new_inode: IO failure
> (E3)[1255107782.102342] Buffer I/O error on device dd_dg10p1, logical block 0
> (E4)[1255107782.102419] lost page write due to I/O error on dd_dg10p1
> (E2)[1255107782.106154] EXT3-fs error (device dd_dg10p3):
> ext3_find_entry: reading directory #2 offset 0
> (E3)[1255107782.106402] Buffer I/O error on device dd_dg10p3, logical block 0
> (E4)[1255107782.106487] lost page write due to I/O error on dd_dg10p3
> (E2)[1255107782.106589] EXT3-fs error (device dd_dg10p3):
> read_inode_bitmap: Cannot read inode bitmap - block_group = 3,
> inode_bitmap = 99377
> (E3)[1255107782.106867] Buffer I/O error on device dd_dg10p3, logical
>
> ....................
> .....................
> (E0)[1255107782.258305] ------------[ cut here ]------------
> (E2)[1255107782.322915] kernel BUG at fs/inode.c:1165!
> (U0)(MSG-KERN-00005):[1255107782.381327] invalid opcode: 0000 [1] SMP
> (E4)[1255107782.456956] CPU 10
> (E4)[1255107782.491713] Modules linked in: msr mptctl ipmi_watchdog
> ipmi_si ipmi_devintf ipmi_msghandler ipv6 dd_iosched(P) usbkbd usbhid
> uhci_hcd ehci_hcd i2c_i801 i2c_core 8021q t3_tom toecore cxgb3 usbcore
> dd_raid_driver(P) e1000e qla2xxx firmware_class scsi_transport_fc
> dm_round_robin dm_emc dm_mpath_rdac dm_multipath dm_mod scsi_dump
> diskdump elog mptsas mptscsih mptbase sg dd_qoskcm(P)
> (E4)[1255107782.912981] Pid: 24783, comm: umount Tainted: P
> 2.6.23-ddr133064 #1
> (E4)[1255107783.004615] RIP: 0010:[<ffffffff802a2f92>]
> [<ffffffff802a2f92>] iput+0x72/0x80
> (E4)[1255107783.101728] RSP: 0018:ffff8107e36f9df8  EFLAGS: 00010246
> (E4)[1255107783.174675] RAX: ffffffff804e7b40 RBX: ffff811029162188
> RCX: ffff81105e5ea300
> (E4)[1255107783.269410] RDX: ffff810820b68820 RSI: 0000000000000001
> RDI: ffff811029162188
> (E4)[1255107783.364185] RBP: ffff8110291620c0 R08: 0000000000000000
> R09: 0000000000000001
> (E4)[1255107783.458956] R10: 0000000000000000 R11: ffffffff802b6d10
> R12: 0000000000000000
> (E4)[1255107783.553760] R13: ffff8110291620d8 R14: 0000000000000000
> R15: ffff811029162188
> (E4)[1255107783.648604] FS:  00002b8099549f80(0000)
> GS:ffff811037fae0c0(0000) knlGS:0000000000000000
> (E4)[1255107783.754854] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> (E4)[1255107783.833014] CR2: 00002b809936716c CR3: 00000007fa6b1000
> CR4: 00000000000006e0
> (E4)[1255107783.927814] DR0: 0000000000000000 DR1: 0000000000000000
> DR2: 0000000000000000
> (E4)[1255107784.022652] DR3: 0000000000000000 DR6: 00000000ffff0ff0
> DR7: 0000000000000400
> (E4)[1255107784.117494] Process umount (pid: 24783, threadinfo
> ffff8107e36f8000, task ffff810820b68820)
> (E4)[1255107784.226857] Stack:  0000000000000001 ffffffff802b77f1
> 0000000017a8cf40 ffffffff88274780
> (E4)[1255107784.333431]  ffff810817a8cc80 ffff810810cadc00
> ffff810817a8cc98 ffff8110291620c0
> (E4)[1255107784.432516]  ffff810817a8cd48 ffffffff802b7803
> 0000000080610680 ffff810817114800
> (E4)[1255107784.529221] Call Trace:
> (E4)[1255107784.570325]  [<ffffffff802b77f1>] __blkdev_put+0x91/0x190
> (E4)[1255107784.644300]  [<ffffffff802b7803>] __blkdev_put+0xa3/0x190
> (E4)[1255107784.718282]  [<ffffffff8028fbe3>] deactivate_super+0x63/0x90
> (E4)[1255107784.795376]  [<ffffffff802a655e>] sys_umount+0x6e/0x280
> (E4)[1255107784.867282]  [<ffffffff80291f67>] sys_newstat+0x27/0x70
> (E4)[1255107784.939183]  [<ffffffff8027553e>] do_munmap+0x26e/0x310
> (E4)[1255107785.011087]  [<ffffffff8036d371>] __up_write+0x31/0x150
> (E4)[1255107785.082985]  [<ffffffff8020beb2>] system_call+0x82/0x87
> (E4)[1255107785.154883]
> (E4)[1255107785.182193]
> (E4)[1255107785.182193] Code: 0f 0b eb fe 66 66 66 90 66 66 90 66 66
> 90 48 83 ec 08 48 8b
> (U1)(MSG-KERN-00005):[1255107785.310184] RIP  [<ffffffff802a2f92>]
> iput+0x72/0x80
> (E4)[1255107785.397005]  RSP <ffff8107e36f9df8>
>
