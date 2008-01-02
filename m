Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbYABPQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbYABPQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 10:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbYABPQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 10:16:44 -0500
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:41627 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbYABPQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 10:16:43 -0500
Date: Wed, 2 Jan 2008 16:16:42 +0100
From: Gabor Gombas <gombasg@sztaki.hu>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Message-ID: <20080102151642.GA7273@boogie.lpds.sztaki.hu>
References: <20071228173203.GA20690@boogie.lpds.sztaki.hu> <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2007 at 04:07:04PM +0800, Dave Young wrote:

> Please try the -mm tree kernel, might have been fixed by :
> http://lkml.org/lkml/2007/11/18/141

Heh, it seems talking about a bug makes it trigger:

Jan  2 16:05:45 twister kernel: Unable to handle kernel NULL pointer dereference at 00000000000000b8 RIP: 
Jan  2 16:05:45 twister kernel:  [<ffffffff804720a5>] mutex_lock+0x10/0x1d
Jan  2 16:05:45 twister kernel: PGD bcf6e067 PUD bcee3067 PMD 0 
Jan  2 16:05:45 twister kernel: Oops: 0002 [1] 
Jan  2 16:05:45 twister kernel: CPU 0 
Jan  2 16:05:45 twister kernel: Modules linked in: binfmt_misc rfcomm l2cap nfsd auth_rpcgss exportfs ipt_REJECT xt_tcpudp ipt_LOG xt_limit iptable_filter ip_tables x_tables nfs lockd nfs_acl sunrpc fuse dm_crypt dm_snapshot dm_mirror cpufreq_ondemand saa7134_alsa radeon hwmon_vid eeprom hci_usb bluetooth usb_storage tuner tea5767 tda8290 tuner_simple mt20xx tea5761 sg snd_intel8x0 saa7134 snd_ac97_codec ac97_bus videobuf_dma_sg videobuf_core ir_kbd_i2c sr_mod firewire_ohci firewire_core snd_pcm crc_itu_t ir_common ehci_hcd ohci_hcd cdrom snd_timer snd_page_alloc parport_pc parport sky2 forcedeth floppy
Jan  2 16:05:45 twister kernel: Pid: 5056, comm: cat Not tainted 2.6.24-rc6-dirty #3
Jan  2 16:05:45 twister kernel: RIP: 0010:[<ffffffff804720a5>]  [<ffffffff804720a5>] mutex_lock+0x10/0x1d
Jan  2 16:05:45 twister kernel: RSP: 0018:ffff8100bce3fd08  EFLAGS: 00010246
Jan  2 16:05:45 twister kernel: RAX: 0000000000000000 RBX: 00000000000000b8 RCX: 0000000000000000
Jan  2 16:05:45 twister kernel: RDX: ffff8100bce3ffd8 RSI: ffffffff80641d70 RDI: 00000000000000b8
Jan  2 16:05:45 twister kernel: RBP: ffffffff80591db0 R08: 0000000000000000 R09: 00000000000899a2
Jan  2 16:05:45 twister kernel: R10: 0000000000000000 R11: 0000003000000018 R12: ffff8100bcb8ef50
Jan  2 16:05:45 twister kernel: R13: 00000000fffffff4 R14: ffff8100bcfc8e00 R15: ffff8100a370b300
Jan  2 16:05:45 twister kernel: FS:  00002b225d0e56e0(0000) GS:ffffffff805b8000(0000) knlGS:0000000000000000
Jan  2 16:05:45 twister kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan  2 16:05:45 twister kernel: CR2: 00000000000000b8 CR3: 0000000095ad1000 CR4: 00000000000006e0
Jan  2 16:05:45 twister kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan  2 16:05:45 twister kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan  2 16:05:45 twister kernel: Process cat (pid: 5056, threadinfo ffff8100bce3e000, task ffff8100ba931060)
Jan  2 16:05:45 twister kernel: Stack:  ffffe2000007e2d8 ffffffff80285555 ffff8100a3387000 ffffffff802aefa5
Jan  2 16:05:45 twister kernel:  ffff8100bfa8af50 ffff8100bcb8ef50 ffff8100baab9300 ffffffff802af1ba
Jan  2 16:05:45 twister kernel:  ffff8100a342a8d0 ffff8100a342a8d0 ffff8100bfa92dc0 ffff8100baab9300
Jan  2 16:05:45 twister kernel: Call Trace:
Jan  2 16:05:45 twister kernel:  [<ffffffff80285555>] dput+0x26/0x103
Jan  2 16:05:45 twister kernel:  [<ffffffff802aefa5>] sysfs_get_dentry+0x45/0x8f
Jan  2 16:05:45 twister kernel:  [<ffffffff802af1ba>] sysfs_move_dir+0x63/0x204
Jan  2 16:05:45 twister kernel:  [<ffffffff803006e5>] kobject_move+0xba/0x110
Jan  2 16:05:45 twister kernel:  [<ffffffff80368a00>] device_move+0x59/0x111
Jan  2 16:05:45 twister kernel:  [<ffffffff88292425>] :rfcomm:rfcomm_tty_close+0x2f/0x74
Jan  2 16:05:45 twister kernel:  [<ffffffff803446bf>] release_dev+0x212/0x5e2
Jan  2 16:05:45 twister kernel:  [<ffffffff8021b609>] do_page_fault+0x2ff/0x65a
Jan  2 16:05:45 twister kernel:  [<ffffffff80344a9b>] tty_release+0xc/0x10
Jan  2 16:05:45 twister kernel:  [<ffffffff80276f67>] __fput+0xb1/0x16f
Jan  2 16:05:45 twister kernel:  [<ffffffff802748b5>] filp_close+0x5d/0x65
Jan  2 16:05:45 twister kernel:  [<ffffffff80275a07>] sys_close+0x73/0xa6
Jan  2 16:05:45 twister kernel:  [<ffffffff8020b5fc>] tracesys+0xdc/0xe1
Jan  2 16:05:45 twister kernel: 
Jan  2 16:05:45 twister kernel: 
Jan  2 16:05:45 twister kernel: Code: ff 0f 79 05 e8 c9 00 00 00 58 5a 5b c3 41 54 48 8d 47 08 48 
Jan  2 16:05:45 twister kernel: RIP  [<ffffffff804720a5>] mutex_lock+0x10/0x1d
Jan  2 16:05:45 twister kernel:  RSP <ffff8100bce3fd08>
Jan  2 16:05:45 twister kernel: CR2: 00000000000000b8
Jan  2 16:05:45 twister kernel: ---[ end trace da76522f0284e9b6 ]---

So the patch referenced above does not help. But I've found a very easy
way to trigger the bug:

- do a "cat /dev/zero > /dev/rfcomm0"
- switch the phone off
- switch the phone on, and the kernel oopses

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
