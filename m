Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbZDOETU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbZDOETU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 00:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbZDOETL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 00:19:11 -0400
Received: from mail.vyatta.com ([76.74.103.46]:56012 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbZDOETK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 00:19:10 -0400
Date: Tue, 14 Apr 2009 21:18:51 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Subject: Can't boot with "nosmp"
Message-ID: <20090414211851.219d8b45@nehalam>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I boot a KVM instance configured with 4 CPU's but pass the "nosmp" flag
Host kernel is 2.6.30-rc1, guest kernel is 2.6.29.1
It dies really early in boot, on a module I never use..

This system is open-source software. The exact distribution terms for 
Press ESC to enter the Grub menu...      0    modprobe: FATAL: Could not load /lib/modules/2.6.29-1-amd64-vyatta/modules.dep: No such file or directory

Loading, please wait...
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff803d6b6b>] dma_channel_rebalance+0x46/0x1d1
PGD 1d8db067 PUD 179bc067 PMD 0 
Oops: 0002 [#1] SMP 
last sysfs file: /sys/kernel/uevent_seqnum
CPU 0 
Modules linked in: async_tx(+) xor raid1 raid0 multipath linear md_mod virtio_blk sg sr_mod cdrom pata_acpi virtio_pci virtio_ring virtio floppy uhci_hcd usbcore ata_piix ata_generic thermal processor fan thermal_sys
Pid: 1789, comm: modprobe Not tainted 2.6.29-1-amd64-vyatta #1 
RIP: 0010:[<ffffffff803d6b6b>]  [<ffffffff803d6b6b>] dma_channel_rebalance+0x46/0x1d1
RSP: 0018:ffff880017a6de78  EFLAGS: 00010283
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000020 R09: ffffffff8063ab00
R10: ffffffffa0106d80 R11: ffff880001010300 R12: 000000000000000c
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fe9c51536e0(0000) GS:ffffffff806ac080(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000001d903000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 1789, threadinfo ffff880017a6c000, task ffff88001fb14380)
Stack:
 0000000000000000 ffffffff805fc4e8 0000000000001ee9 ffffffff805fc4e8
 0000000000000000 0000000000000000 0000000000000000 ffffffff803d730a
 00000000fffffffe ffffffffa0106d80 0000000000001ee9 ffffffffa0109000
Call Trace:
 [<ffffffff803d730a>] dmaengine_get+0xca/0xdd
 [<ffffffffa0109000>] async_tx_init+0x0/0x1b [async_tx]
 [<ffffffffa0109009>] async_tx_init+0x9/0x1b [async_tx]
 [<ffffffff80209051>] _stext+0x51/0x120
 [<ffffffff8032bfde>] __up_read+0x13/0x8d
 [<ffffffff8024aa4d>] __blocking_notifier_call_chain+0x51/0x5f
 [<ffffffff80257c75>] sys_init_module+0xa0/0x1ba
 [<ffffffff8020be5b>] system_call_fastpath+0x16/0x1b
Code: 53 48 83 ec 08 e8 ae 15 f5 ff 89 c3 83 f8 0c b8 0c 00 00 00 0f 4f d8 eb 5a 48 8b 04 ed e0 12 73 80 48 63 d1 48 f7 d0 48 8b 04 d0 <48> c7 00 00 00 00 00 8d 51 01 48 8b 3d b4 d3 09 00 be 20 00 00 
RIP  [<ffffffff803d6b6b>] dma_channel_rebalance+0x46/0x1d1
 RSP <ffff880017a6de78>
CR2: 0000000000000000
---[ end trace af2ed99f087c36ac ]---
Killed
