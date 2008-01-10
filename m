Return-Path: <linux-kernel-owner+w=401wt.eu-S1754269AbYAJKPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbYAJKPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 05:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbYAJKPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 05:15:35 -0500
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:45445 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbYAJKPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 05:15:33 -0500
Date: Thu, 10 Jan 2008 11:15:31 +0100
From: Gabor Gombas <gombasg@sztaki.hu>
To: Tejun Heo <htejun@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Dave Young <hidave.darkstar@gmail.com>,
       linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net,
       kay.sievers@vrfy.org, Greg KH <greg@kroah.com>
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Message-ID: <20080110101531.GB3591@boogie.lpds.sztaki.hu>
References: <20071228173203.GA20690@boogie.lpds.sztaki.hu> <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com> <20080102151642.GA7273@boogie.lpds.sztaki.hu> <20080105075039.GF27894@ZenIV.linux.org.uk> <20080107141300.GB12763@boogie.lpds.sztaki.hu> <47824415.80703@gmail.com> <20080107210024.GA13537@boogie.lpds.sztaki.hu> <47834593.1000506@gmail.com> <20080108133215.GA15814@boogie.lpds.sztaki.hu> <478490D2.5050902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478490D2.5050902@gmail.com>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jan 09, 2008 at 06:16:02PM +0900, Tejun Heo wrote:

> Please confirm the attached patch fixes the oops.  I'll separate it into
> two patches and forward them to Greg.  But bluetooth code also needs to
> be updated such that it moves the refcommX device before killing the
> connection node.

The kernel survives switching the phone off & on but then oopses when
pppd is started:

Jan 10 10:59:09 twister kernel: Unable to handle kernel NULL pointer dereference at 0000000000000008 RIP: 
Jan 10 10:59:09 twister kernel:  [<ffffffff802af03f>] sysfs_get_dentry+0x27/0x8f
Jan 10 10:59:09 twister kernel: PGD 260bb067 PUD 260bc067 PMD 0 
Jan 10 10:59:09 twister kernel: Oops: 0000 [1] 
Jan 10 10:59:09 twister kernel: CPU 0 
Jan 10 10:59:09 twister kernel: Modules linked in: ppp_generic slhc binfmt_misc rfcomm l2cap nfsd auth_rpcgss exportfs ipt_REJECT xt_tcpudp ipt_LOG xt_limit iptable_filter ip_tables x_tables nfs lockd nfs_acl sunrpc fuse dm_crypt saa7134_alsa radeon hwmon_vid eeprom hci_usb bluetooth usb_storage tuner tea5767 tda8290 tuner_simple mt20xx tea5761 snd_intel8x0 snd_ac97_codec saa7134 firewire_ohci firewire_core sg ac97_bus videobuf_dma_sg videobuf_core ir_kbd_i2c crc_itu_t ir_common snd_pcm parport_pc parport sky2 forcedeth sr_mod snd_timer snd_page_alloc ehci_hcd ohci_hcd floppy cdrom
Jan 10 10:59:09 twister kernel: Pid: 4490, comm: pppd Not tainted 2.6.24-rc6debug-dirty #8
Jan 10 10:59:09 twister kernel: RIP: 0010:[<ffffffff802af03f>]  [<ffffffff802af03f>] sysfs_get_dentry+0x27/0x8f
Jan 10 10:59:09 twister kernel: RSP: 0018:ffff8100260dbc88  EFLAGS: 00010207
Jan 10 10:59:09 twister kernel: RAX: 0000000000000000 RBX: ffff8100251577d0 RCX: 0000000000000000
Jan 10 10:59:09 twister kernel: RDX: ffff8100260e3410 RSI: ffffffff80643d70 RDI: ffff8100bb32d898
Jan 10 10:59:09 twister kernel: RBP: 0000000000000000 R08: 6390dfaa7e3bd395 R09: ffffffff8050cee6
Jan 10 10:59:09 twister kernel: R10: ffff8100260dbcb8 R11: 0000003000000018 R12: ffff8100b6ef4b90
Jan 10 10:59:09 twister kernel: R13: 00000000fffffff4 R14: ffff81004d9d2600 R15: ffff8100b6eb227e
Jan 10 10:59:09 twister kernel: FS:  00002b5731903ac0(0000) GS:ffffffff805ba000(0000) knlGS:0000000000000000
Jan 10 10:59:09 twister kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 10 10:59:09 twister kernel: CR2: 0000000000000008 CR3: 00000000260b1000 CR4: 00000000000006e0
Jan 10 10:59:09 twister kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 10 10:59:09 twister kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 10 10:59:09 twister kernel: Process pppd (pid: 4490, threadinfo ffff8100260da000, task ffff81009550d060)
Jan 10 10:59:09 twister kernel: Stack:  ffff8100260e3690 ffff8100b6ef4b90 ffff81003a5942a0 ffffffff802af272
Jan 10 10:59:09 twister kernel:  ffff8100becca2d0 ffff8100becca2d0 ffff8100260df300 ffff81003a5942a0
Jan 10 10:59:09 twister kernel:  00000000fffffff4 ffff81004d9d2600 ffff8100b6eb227e ffffffff803007a5
Jan 10 10:59:09 twister kernel: Call Trace:
Jan 10 10:59:09 twister kernel:  [<ffffffff802af272>] sysfs_move_dir+0x63/0x1fd
Jan 10 10:59:09 twister kernel:  [<ffffffff803007a5>] kobject_move+0xba/0x110
Jan 10 10:59:09 twister kernel:  [<ffffffff803698cc>] device_move+0x59/0x111
Jan 10 10:59:09 twister kernel:  [<ffffffff8827d31e>] :rfcomm:rfcomm_tty_open+0x1c1/0x1db
Jan 10 10:59:09 twister kernel:  [<ffffffff80224204>] default_wake_function+0x0/0xe
Jan 10 10:59:09 twister kernel:  [<ffffffff80345a2d>] tty_open+0x1c5/0x2af
Jan 10 10:59:09 twister kernel:  [<ffffffff80278590>] chrdev_open+0x113/0x132
Jan 10 10:59:09 twister kernel:  [<ffffffff8027847d>] chrdev_open+0x0/0x132
Jan 10 10:59:09 twister kernel:  [<ffffffff80274b4a>] __dentry_open+0xda/0x1aa
Jan 10 10:59:09 twister kernel:  [<ffffffff80274cd1>] do_filp_open+0x2d/0x3d
Jan 10 10:59:09 twister kernel:  [<ffffffff80473812>] mutex_lock+0xd/0x1d
Jan 10 10:59:09 twister kernel:  [<ffffffff802749d6>] get_unused_fd_flags+0x6d/0x100
Jan 10 10:59:09 twister kernel:  [<ffffffff80274d27>] do_sys_open+0x46/0xc3
Jan 10 10:59:09 twister kernel:  [<ffffffff8020b5fc>] tracesys+0xdc/0xe1
Jan 10 10:59:09 twister kernel: 
Jan 10 10:59:09 twister kernel: 
Jan 10 10:59:09 twister kernel: Code: 48 8b 45 08 48 39 d0 74 05 48 89 c5 eb f2 48 8b 7b 08 48 81 
Jan 10 10:59:09 twister kernel: RIP  [<ffffffff802af03f>] sysfs_get_dentry+0x27/0x8f
Jan 10 10:59:09 twister kernel:  RSP <ffff8100260dbc88>
Jan 10 10:59:09 twister kernel: CR2: 0000000000000008
Jan 10 10:59:09 twister kernel: ---[ end trace b33fe66800773e0c ]---

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
