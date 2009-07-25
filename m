Return-Path: <linux-kernel-owner+w=401wt.eu-S1752148AbZGYSKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbZGYSKk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 14:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbZGYSKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 14:10:39 -0400
Received: from www17.your-server.de ([213.133.104.17]:46129 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbZGYSKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 14:10:38 -0400
Subject: 2.6.31-rc4: btrfs kernel bug
From: Thomas Meyer <thomas@m3y3r.de>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 25 Jul 2009 20:10:22 +0200
Message-Id: <1248545422.3199.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure what I did... Maybe powering off the hard drive while still
mounted? I'm not sure if the device was mounted (gnome/hal).

Kernel BUG at fa3819b3 [verbose debug info unavailable]
invalid opcode: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:1d.7/usb1/speed
Modules linked in: btrfs ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables nf_conntrack_ftp ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ath5k mac80211 video rndis_wlan ath cfg80211 [last unloaded: scsi_wait_scan]

Pid: 3348, comm: umount Not tainted (2.6.31-rc4 #3) MacBookPro1,1
EIP: 0060:[<fa3819b3>] EFLAGS: 00010246 CPU: 0
EIP is at btrfs_add_free_space+0x1b6/0x1da [btrfs]
EAX: 0000003a EBX: ffffffef ECX: fa38c7e8 EDX: 90d6eff2
ESI: ffffffef EDI: f25fc000 EBP: f2659b0c ESP: f2659adc
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process umount (pid: 3348, ti=f2659000 task=f26394a0 task.ti=f2659000)
Stack:
 90d6eff2 fa36ef72 00000000 f2405c6c f2405c74 f2405c00 00000000 00000000
<0> 90d6eff2 01c00000 00000000 f2659b2c f2659b4c fa34591b 00005000 00000000
<0> f5a06050 f2405c00 01c05000 00000000 fa36d74a f34ac800 00000000 00000001
Call Trace:
 [<fa36ef72>] ? find_first_extent_bit+0xe5/0x100 [btrfs]
 [<fa34591b>] ? add_new_free_space+0xc5/0xea [btrfs]
 [<fa36d74a>] ? read_extent_buffer+0x110/0x146 [btrfs]
 [<fa345ace>] ? cache_block_group+0x18e/0x2d0 [btrfs]
 [<fa3443ac>] ? btrfs_lookup_block_group+0x1b/0x34 [btrfs]
 [<fa345f59>] ? find_free_extent+0x349/0x7cd [btrfs]
 [<c0504b94>] ? __find_get_block+0x144/0x15f
 [<fa34654a>] ? __btrfs_reserve_extent+0x16d/0x33c [btrfs]
 [<c055a25a>] ? ext4_getblk+0xbd/0x18f
 [<fa34c0e7>] ? btrfs_alloc_free_block+0x7e/0x203 [btrfs]
 [<fa3405ba>] ? __btrfs_cow_block+0x157/0x55f [btrfs]
 [<c09c48a1>] ? schedule+0x82b/0x8a6
 [<fa341124>] ? btrfs_cow_block+0x180/0x1ae [btrfs]
 [<fa354d2c>] ? commit_cowonly_roots+0x52/0x17e [btrfs]
 [<fa355966>] ? btrfs_commit_transaction+0x38c/0x638 [btrfs]
 [<c04699e6>] ? autoremove_wake_function+0x0/0x4b
 [<c0521954>] ? sync_quota_sb+0x48/0xf7
 [<c0502fa4>] ? __sync_filesystem+0x35/0x6f
 [<c04e65da>] ? generic_shutdown_super+0x29/0xde
 [<c051f520>] ? vfs_quota_off+0x0/0x30
 [<c04e66f4>] ? kill_anon_super+0x18/0x5f
 [<c04e6e01>] ? deactivate_super+0x5c/0x93
 [<c04fac2b>] ? sys_umount+0x285/0x2c0
 [<c049543b>] ? audit_syscall_entry+0x1c4/0x1f7
 [<c0420277>] ? sysenter_do_call+0x12/0x22
Code: 85 c0 89 c3 74 07 89 f8 e8 fc d6 15 c6 8b 45 dc e8 ff 4f 64 c6 85 db 74 1b 53 68 e8 c7 38 fa e8 bd 21 64 c6 83 fb ef 59 5e 75 09 <0f> 0b eb fe bb f4 ff ff ff 8b 55 f0 65 33 15 14 00 00 00 89 d8 
EIP: [<fa3819b3>] btrfs_add_free_space+0x1b6/0x1da [btrfs] SS:ESP 0068:f2659adc
---[ end trace 19171a0c93ae6831 ]---


