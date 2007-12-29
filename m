Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbXL2IHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbXL2IHT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 03:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbXL2IHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 03:07:08 -0500
Received: from ag-out-0708.google.com ([72.14.246.245]:54809 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbXL2IHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 03:07:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QEnHKhqmAkgcggU0dGVRsxdvOoWjJNU4sdHA7TjFjM+0SVOyixfOHLzUr+6z5PA9L5/XZL9XJCPOE5P6LQliaR2nIWp+g6fYD26vRyCmDdwb7lpD6PBhQsvdnQLDZQ3TNABVxxQqHfkN5NK2S3XEN4+ThNrBsyVoJKpQNlaQuu8=
Message-ID: <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com>
Date: Sat, 29 Dec 2007 16:07:04 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: gombasg@sztaki.hu
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Cc: linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net
In-Reply-To: <20071228173203.GA20690@boogie.lpds.sztaki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071228173203.GA20690@boogie.lpds.sztaki.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 29, 2007 1:32 AM, Gabor Gombas <gombasg@sztaki.hu> wrote:
> Hi,
>
> I'm using my phone as a GPRS modem over Bluetooth. Sometimes Bluetooth
> on the phone seems to stall and the phone has to be switched off & on to
> get it back to a sane state. During this I sometimes get the following
> Oops (this is kernel 2.6.24-rc6 on x86_64):
>
> Dec 28 17:52:11 host kernel: Unable to handle kernel NULL pointer dereference at 00000000000000b8 RIP:
> Dec 28 17:52:11 host kernel:  [<ffffffff8046e0d5>] mutex_lock+0x10/0x1d
> Dec 28 17:52:11 host kernel: PGD 920b0067 PUD a7aba067 PMD 0
> Dec 28 17:52:11 host kernel: Oops: 0002 [1]
> Dec 28 17:52:11 host kernel: CPU 0
> Dec 28 17:52:11 host kernel: Modules linked in: cpufreq_ondemand ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async crc_ccitt ppp_generic slhc binfmt_misc rfcomm l2cap nfsd auth_rpcgss exportfs ipt_REJECT xt_tcpudp ipt_LOG xt_limit iptable_filter ip_tables x_tables nfs lockd nfs_acl sunrpc fuse dm_crypt dm_snapshot dm_mirror saa7134_alsa radeon hwmon_vid eeprom hci_usb bluetooth usb_storage tuner tea5767 tda8290 tuner_simple mt20xx tea5761 sg snd_intel8x0 saa7134 firewire_ohci snd_ac97_codec firewire_core videobuf_dma_sg videobuf_core ir_kbd_i2c ac97_bus crc_itu_t ir_common snd_pcm ehci_hcd ohci_hcd parport_pc parport sky2 sr_mod forcedeth snd_timer snd_page_alloc cdrom floppy
> Dec 28 17:52:11 host kernel: Pid: 4381, comm: pppd Not tainted 2.6.24-rc6 #1
> Dec 28 17:52:11 host kernel: RIP: 0010:[<ffffffff8046e0d5>]  [<ffffffff8046e0d5>] mutex_lock+0x10/0x1d
> Dec 28 17:52:11 host kernel: RSP: 0018:ffff81009402fd08  EFLAGS: 00010246
> Dec 28 17:52:11 host kernel: RAX: 0000000000000000 RBX: 00000000000000b8 RCX: 0000000000000000
> Dec 28 17:52:11 host kernel: RDX: ffff81009402ffd8 RSI: ffffffff80639d70 RDI: 00000000000000b8
> Dec 28 17:52:11 host kernel: RBP: ffffffff8058adb0 R08: 6390dfaa7e3bd395 R09: ffffffff8050597e
> Dec 28 17:52:11 host kernel: R10: 0000000000004000 R11: 0000003000000018 R12: ffff8100b4d75e60
> Dec 28 17:52:11 host kernel: R13: 00000000fffffff4 R14: ffff8100abe9e180 R15: ffff8100a7a10900
> Dec 28 17:52:11 host kernel: FS:  00002ab1bddc3ac0(0000) GS:ffffffff805b0000(0000) knlGS:0000000000000000
> Dec 28 17:52:11 host kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Dec 28 17:52:11 host kernel: CR2: 00000000000000b8 CR3: 000000009400e000 CR4: 00000000000006e0
> Dec 28 17:52:11 host kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Dec 28 17:52:11 host kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Dec 28 17:52:11 host kernel: Process pppd (pid: 4381, threadinfo ffff81009402e000, task ffff81009403d060)
> Dec 28 17:52:11 host kernel: Stack:  ffff81009403d060 ffffffff80285555 ffff810093734d48 ffffffff802aefa5
> Dec 28 17:52:11 host kernel:  ffff8100bf9e1c80 ffff8100b4d75e60 ffff810060720600 ffffffff802af1ba
> Dec 28 17:52:11 host kernel:  ffff8100b6e5ced0 ffff8100b6e5ced0 ffff8100bfa11c00 ffff810060720600
> Dec 28 17:52:11 host kernel: Call Trace:
> Dec 28 17:52:11 host kernel:  [<ffffffff80285555>] dput+0x26/0x103
> Dec 28 17:52:11 host kernel:  [<ffffffff802aefa5>] sysfs_get_dentry+0x45/0x8f
> Dec 28 17:52:11 host kernel:  [<ffffffff802af1ba>] sysfs_move_dir+0x63/0x204
> Dec 28 17:52:11 host kernel:  [<ffffffff803006e5>] kobject_move+0xba/0x110
> Dec 28 17:52:11 host kernel:  [<ffffffff80368640>] device_move+0x59/0x111
> Dec 28 17:52:11 host kernel:  [<ffffffff8828841c>] :rfcomm:rfcomm_tty_close+0x2f/0x74
> Dec 28 17:52:11 host kernel:  [<ffffffff803442ff>] release_dev+0x212/0x5e2
> Dec 28 17:52:11 host kernel:  [<ffffffff80288801>] mntput_no_expire+0x1f/0x6f
> Dec 28 17:52:11 host kernel:  [<ffffffff803e845d>] sys_sendto+0x128/0x151
> Dec 28 17:52:11 host kernel:  [<ffffffff803446db>] tty_release+0xc/0x10
> Dec 28 17:52:11 host kernel:  [<ffffffff80276f67>] __fput+0xb1/0x16f
> Dec 28 17:52:11 host kernel:  [<ffffffff802748b5>] filp_close+0x5d/0x65
> Dec 28 17:52:11 host kernel:  [<ffffffff80275a07>] sys_close+0x73/0xa6
> Dec 28 17:52:11 host kernel:  [<ffffffff8020b5fc>] tracesys+0xdc/0xe1
> Dec 28 17:52:11 host kernel:
> Dec 28 17:52:11 host kernel:
> Dec 28 17:52:11 host kernel: Code: ff 0f 79 05 e8 c9 00 00 00 58 5a 5b c3 41 54 48 8d 47 08 48
> Dec 28 17:52:11 host kernel: RIP  [<ffffffff8046e0d5>] mutex_lock+0x10/0x1d
> Dec 28 17:52:11 host kernel:  RSP <ffff81009402fd08>
> Dec 28 17:52:11 host kernel: CR2: 00000000000000b8
> Dec 28 17:52:11 host kernel: ---[ end trace 12717319afdb56f5 ]---
>
> The bug is also present in 2.6.23.9:
>
> Dec 28 15:30:29 twister kernel: Unable to handle kernel paging request at fffffffffffffffe RIP:
> Dec 28 15:30:29 twister kernel:  [<ffffffff8027ac13>] dput+0xd/0x103
> Dec 28 15:30:29 twister kernel: PGD 203067 PUD 204067 PMD 0
> Dec 28 15:30:29 twister kernel: Oops: 0000 [1]
> Dec 28 15:30:29 twister kernel: CPU 0
> Dec 28 15:30:29 twister kernel: Modules linked in: ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async crc_ccitt ppp_generic slhc binfmt_misc rfcomm l2cap nfsd exportfs auth_rpcgss ipt_REJECT xt_tcpudp ipt_LOG xt_limit iptable_filter ip_tables x_tables nfs lockd nfs_acl sunrpc fuse dm_crypt dm_snapshot dm_mirror saa7134_alsa radeon it87 hwmon_vid eeprom hci_usb bluetooth tuner usb_storage saa7134 video_buf ir_kbd_i2c snd_intel8x0 sg firewire_ohci firewire_core ir_common crc_itu_t snd_ac97_codec ac97_bus forcedeth parport_pc parport sky2 ohci_hcd snd_pcm snd_timer snd_page_alloc ehci_hcd sr_mod cdrom floppy
> Dec 28 15:30:29 twister kernel: Pid: 14700, comm: pppd Not tainted 2.6.23.9 #1
> Dec 28 15:30:29 twister kernel: RIP: 0010:[<ffffffff8027ac13>]  [<ffffffff8027ac13>] dput+0xd/0x103
> Dec 28 15:30:29 twister kernel: RSP: 0018:ffff810054e5bd28  EFLAGS: 00010282
> Dec 28 15:30:29 twister kernel: RAX: fffffffffffffffe RBX: fffffffffffffffe RCX: 0000000000000052
> Dec 28 15:30:29 twister kernel: RDX: ffffffff802f6414 RSI: ffff81000411b4e0 RDI: fffffffffffffffe
> Dec 28 15:30:29 twister kernel: RBP: ffff8100bfef14d0 R08: ffffffffffffffff R09: 0000000000005401
> Dec 28 15:30:29 twister kernel: R10: 00007fff7018a2e0 R11: 0000000000000246 R12: ffff8100b3731948
> Dec 28 15:30:29 twister kernel: R13: 0000000000000000 R14: ffff81005a1cb100 R15: fffffffffffffffe
> Dec 28 15:30:29 twister kernel: FS:  00002acd3a94cac0(0000) GS:ffffffff80592000(0000) knlGS:00000000f7d786b0
> Dec 28 15:30:29 twister kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Dec 28 15:30:29 twister kernel: CR2: fffffffffffffffe CR3: 0000000047f21000 CR4: 00000000000006e0
> Dec 28 15:30:29 twister kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Dec 28 15:30:29 twister kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Dec 28 15:30:29 twister kernel: Process pppd (pid: 14700, threadinfo ffff810054e5a000, task ffff81007907ce40)
> Dec 28 15:30:29 twister kernel: Stack:  00000000fffffffe ffffffff802a5a81 0000000000000053 ffff81000411b4e0
> Dec 28 15:30:29 twister kernel:  0000000000000000 ffff8100b539f8d0 ffff81000411b4e0 ffff8100b04e7060
> Dec 28 15:30:29 twister kernel:  00000000fffffff4 ffff81005a1cb100 ffff8100b09db800 ffffffff802f6448
> Dec 28 15:30:29 twister kernel: Call Trace:
> Dec 28 15:30:29 twister kernel:  [<ffffffff802a5a81>] sysfs_move_dir+0x1d2/0x1ed
> Dec 28 15:30:29 twister kernel:  [<ffffffff802f6448>] kobject_move+0xba/0x110
> Dec 28 15:30:29 twister kernel:  [<ffffffff8035e0f0>] device_move+0x59/0x111
> Dec 28 15:30:29 twister kernel:  [<ffffffff8827c382>] :rfcomm:rfcomm_tty_close+0x2f/0x74
> Dec 28 15:30:29 twister kernel:  [<ffffffff803397ff>] release_dev+0x212/0x5e2
> Dec 28 15:30:29 twister kernel:  [<ffffffff802d4206>] inode_has_perm+0x65/0x72
> Dec 28 15:30:29 twister kernel:  [<ffffffff802d42a7>] file_has_perm+0x94/0xa3
> Dec 28 15:30:29 twister kernel:  [<ffffffff80339bdb>] tty_release+0xc/0x11
> Dec 28 15:30:29 twister kernel:  [<ffffffff8026c578>] __fput+0xb1/0x177
> Dec 28 15:30:29 twister kernel:  [<ffffffff80269ecc>] filp_close+0x5d/0x65
> Dec 28 15:30:29 twister kernel:  [<ffffffff8026b01a>] sys_close+0x72/0xa5
> Dec 28 15:30:29 twister kernel:  [<ffffffff8020b5cc>] tracesys+0xdc/0xe1
> Dec 28 15:30:29 twister kernel:
> Dec 28 15:30:29 twister kernel:
> Dec 28 15:30:29 twister kernel: Code: 83 3b 01 75 05 e8 e8 29 1e 00 48 c7 c6 08 de 61 80 48 89 df
> Dec 28 15:30:29 twister kernel: RIP  [<ffffffff8027ac13>] dput+0xd/0x103
> Dec 28 15:30:29 twister kernel:  RSP <ffff810054e5bd28>
> Dec 28 15:30:29 twister kernel: CR2: fffffffffffffffe
>

Please try the -mm tree kernel, might have been fixed by :
http://lkml.org/lkml/2007/11/18/141

Regards
dave
