Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbYAGONQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbYAGONQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 09:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbYAGONE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 09:13:04 -0500
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:43167 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbYAGOND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 09:13:03 -0500
Date: Mon, 7 Jan 2008 15:13:00 +0100
From: Gabor Gombas <gombasg@sztaki.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, htejun@gmail.com
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Message-ID: <20080107141300.GB12763@boogie.lpds.sztaki.hu>
References: <20071228173203.GA20690@boogie.lpds.sztaki.hu> <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com> <20080102151642.GA7273@boogie.lpds.sztaki.hu> <20080105075039.GF27894@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080105075039.GF27894@ZenIV.linux.org.uk>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jan 05, 2008 at 07:50:39AM +0000, Al Viro wrote:

> Could you stick
> 	if (!parent->d_inode)
> 		printk(KERN_WARNING "sysfs locking blows: %s",
> 			parent->d_name.name);
> right before
>                 mutex_lock(&parent->d_inode->i_mutex);
>                 dentry = lookup_one_noperm(cur->s_name, parent);
>                 mutex_unlock(&parent->d_inode->i_mutex);
> in sysfs_get_dentry() (fs/sysfs/dir.c) and verify that it does, indeed,
> trigger?

Here it is:

Jan  7 14:35:43 twister kernel: sysfs locking blows: acl001BAFE1624D<1>Unable to handle kernel NULL pointer dereference at 00000000000000b8 RIP: 
Jan  7 14:35:43 twister kernel:  [<ffffffff80473835>] mutex_lock+0x10/0x1d
Jan  7 14:35:43 twister kernel: PGD b6031067 PUD b609c067 PMD 0 
Jan  7 14:35:43 twister kernel: Oops: 0002 [1] 
Jan  7 14:35:43 twister kernel: CPU 0 
Jan  7 14:35:43 twister kernel: Modules linked in: binfmt_misc rfcomm l2cap nfsd auth_rpcgss exportfs ipt_REJECT xt_tcpudp ipt_LOG xt_limit iptable_filter ip_tables x_tables nfs lockd nfs_acl sunrpc fuse dm_crypt saa7134_alsa radeon hwmon_vid eeprom hci_usb bluetooth usb_storage tuner tea5767 tda8290 tuner_simple mt20xx tea5761 parport_pc parport floppy snd_intel8x0 snd_ac97_codec saa7134 ac97_bus firewire_ohci firewire_core videobuf_dma_sg videobuf_core ir_kbd_i2c sky2 ir_common crc_itu_t snd_pcm forcedeth snd_timer snd_page_alloc ehci_hcd ohci_hcd sg sr_mod cdrom
Jan  7 14:35:43 twister kernel: Pid: 3218, comm: cat Not tainted 2.6.24-rc6debug-dirty #5
Jan  7 14:35:43 twister kernel: RIP: 0010:[<ffffffff80473835>]  [<ffffffff80473835>] mutex_lock+0x10/0x1d
Jan  7 14:35:43 twister kernel: RSP: 0018:ffff8100b5733d08  EFLAGS: 00010246
Jan  7 14:35:43 twister kernel: RAX: 0000000000000000 RBX: 00000000000000b8 RCX: 0000000000000001
Jan  7 14:35:43 twister kernel: RDX: ffff8100b5733fd8 RSI: ffff8100bfab6000 RDI: 00000000000000b8
Jan  7 14:35:43 twister kernel: RBP: ffffffff80593db0 R08: ffffffff8057b118 R09: ffffffff806093d0
Jan  7 14:35:43 twister kernel: R10: ffff8100b6074aa0 R11: ffff81000101b100 R12: ffff8100b6074aa0
Jan  7 14:35:43 twister kernel: R13: 00000000fffffff4 R14: ffff8100b571fb80 R15: ffff8100b573e000
Jan  7 14:35:43 twister kernel: FS:  00002aead9fc56e0(0000) GS:ffffffff805ba000(0000) knlGS:0000000000000000
Jan  7 14:35:43 twister kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan  7 14:35:43 twister kernel: CR2: 00000000000000b8 CR3: 00000000b60b2000 CR4: 00000000000006e0
Jan  7 14:35:43 twister kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan  7 14:35:43 twister kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan  7 14:35:43 twister kernel: Process cat (pid: 3218, threadinfo ffff8100b5732000, task ffff8100bfa70830)
Jan  7 14:35:43 twister kernel: Stack:  ffffe2000007e310 ffffffff8028560d ffff8100b202a7d0 ffffffff802af076
Jan  7 14:35:43 twister kernel:  ffff8100bfa52f00 ffff8100b6074aa0 ffff8100b618c720 ffffffff802af28b
Jan  7 14:35:43 twister kernel:  ffff8100b61308d0 ffff8100b61308d0 ffff8100bfa1a800 ffff8100b618c720
Jan  7 14:35:43 twister kernel: Call Trace:
Jan  7 14:35:43 twister kernel:  [<ffffffff8028560d>] dput+0x26/0x103
Jan  7 14:35:43 twister kernel:  [<ffffffff802af076>] sysfs_get_dentry+0x5e/0xa8
Jan  7 14:35:43 twister kernel:  [<ffffffff802af28b>] sysfs_move_dir+0x63/0x204
Jan  7 14:35:43 twister kernel:  [<ffffffff803007c5>] kobject_move+0xba/0x110
Jan  7 14:35:43 twister kernel:  [<ffffffff803698ec>] device_move+0x59/0x111
Jan  7 14:35:43 twister kernel:  [<ffffffff8827c433>] :rfcomm:rfcomm_tty_close+0x2f/0x74
Jan  7 14:35:43 twister kernel:  [<ffffffff803447af>] release_dev+0x212/0x5e2
Jan  7 14:35:43 twister kernel:  [<ffffffff8021b609>] do_page_fault+0x2ff/0x65a
Jan  7 14:35:43 twister kernel:  [<ffffffff80344b8b>] tty_release+0xc/0x10
Jan  7 14:35:43 twister kernel:  [<ffffffff80277013>] __fput+0xb1/0x16f
Jan  7 14:35:43 twister kernel:  [<ffffffff80274961>] filp_close+0x5d/0x65
Jan  7 14:35:43 twister kernel:  [<ffffffff80275ab3>] sys_close+0x73/0xa6
Jan  7 14:35:43 twister kernel:  [<ffffffff8020b5fc>] tracesys+0xdc/0xe1
Jan  7 14:35:43 twister kernel: 
Jan  7 14:35:43 twister kernel: 
Jan  7 14:35:43 twister kernel: Code: ff 0f 79 05 e8 c9 00 00 00 58 5a 5b c3 41 54 48 8d 47 08 48 
Jan  7 14:35:43 twister kernel: RIP  [<ffffffff80473835>] mutex_lock+0x10/0x1d
Jan  7 14:35:43 twister kernel:  RSP <ffff8100b5733d08>
Jan  7 14:35:43 twister kernel: CR2: 00000000000000b8
Jan  7 14:35:43 twister kernel: ---[ end trace 0e3a1176e9294792 ]---

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
