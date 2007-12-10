Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbXLJS5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbXLJS5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 13:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbXLJS5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 13:57:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:36644 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbXLJS5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 13:57:23 -0500
Date: Mon, 10 Dec 2007 19:57:21 +0100
From: Andi Kleen <ak@suse.de>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org, akpm@osdl.org,
       torvalds@osdl.org
Subject: Re: BUG fs/dcache.c:595 in 2.4.24rc3-git3 during NFS umount
Message-ID: <20071210185720.GA32466@bingen.suse.de>
References: <200712031623.58223.ak@suse.de> <200712081422.30815.ak@suse.de> <1197243901.11792.1.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197243901.11792.1.camel@heimdal.trondhjem.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Andi,
> 
> Does the attached patch fix the Oops?

Nope, got that a few hours after boot again:

-Andi


EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
------------[ cut here ]------------
kernel BUG at fs/dcache.c:595!
invalid opcode: 0000 [1] SMP 
CPU 0 
Modules linked in: nfs lockd nfs_acl sunrpc autofs4 iptable_filter ip_tables ip6table_filter ip6_tables x_tables af_packet ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq dm_crypt ext2 ext3 jbd mbcache loop dm_mod e1000 shpchp container pci_hotplug button iTCO_wdt rtc_cmos i2c_i801 rtc_core rtc_lib i2c_core sr_mod cdrom iTCO_vendor_support sg floppy ehci_hcd uhci_hcd sd_mod usbcore edd reiserfs fan aic79xx scsi_transport_spi ata_piix ahci libata scsi_mod thermal processor
Pid: 30784, comm: umount.nfs Not tainted 2.6.24-rc4-git3-2-vanilla #1
RIP: 0010:[<ffffffff802a602e>]  [<ffffffff802a602e>] shrink_dcache_for_umount_subtree+0x16/0x241
RSP: 0018:ffff8101530c5e18  EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff8101b2873080 RCX: 0000000000000000
RDX: 00000000ffffffff RSI: 0000000000000296 RDI: ffff8101b2873080
RBP: ffff810153dddcb0 R08: ffff8101db008d10 R09: 0000000000000296
R10: ffff8101db008d10 R11: 0000000000000400 R12: ffff810225c27000
R13: 0000000000000000 R14: 0000555555769040 R15: 0000000000000000
FS:  00002b8c13dd16f0(0000) GS:ffffffff8050d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002ab9197bc315 CR3: 00000001db56c000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process umount.nfs (pid: 30784, threadinfo ffff8101530c4000, task ffff810224c7d040)
Stack:  0000000000000296 ffff810225c27000 ffffffff883e7be0 ffff810225c27000
 0000000000000000 ffffffff802a6288 ffff810225c27000 ffffffff80297afc
 ffff8101db008c80 0000000000000018 ffffffff883ffe60 ffffffff80297bfb
Call Trace:
 [<ffffffff802a6288>] shrink_dcache_for_umount+0x2f/0x3d
 [<ffffffff80297afc>] generic_shutdown_super+0x19/0xf1
 [<ffffffff80297bfb>] kill_anon_super+0x9/0x35
 [<ffffffff883cb1c2>] :nfs:nfs_kill_super+0xd/0x16
 [<ffffffff80297cac>] deactivate_super+0x6a/0x83
 [<ffffffff802ab2b4>] sys_umount+0x23c/0x24d
 [<ffffffff802a585a>] d_kill+0x40/0x55
 [<ffffffff802a6d77>] dput+0x26/0x115
 [<ffffffff80296d9a>] __fput+0x14a/0x179
 [<ffffffff802aa70d>] mntput_no_expire+0x1f/0x86
 [<ffffffff8029442a>] filp_close+0x5a/0x61
 [<ffffffff8020bfbe>] system_call+0x7e/0x83


Code: 0f 0b eb fe 48 c7 c7 80 16 62 80 e8 d7 bc 16 00 48 8b 53 40 
RIP  [<ffffffff802a602e>] shrink_dcache_for_umount_subtree+0x16/0x241
 RSP <ffff8101530c5e18>
