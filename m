Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbZBCPhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbZBCPhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 10:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZBCPhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 10:37:46 -0500
Received: from a2s12.a2hosting.com ([69.39.88.120]:46477 "EHLO
	a2s12.a2hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbZBCPhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 10:37:45 -0500
X-Greylist: delayed 1804 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Feb 2009 10:37:45 EST
Message-Id: <3A9AF76B-8B13-4E75-8349-4893CEE3A08E@loc.gov>
From: Scott Phelps <sphe@loc.gov>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: soft lockup - CPU#0 stuck for 61s! [kswapd0:267]
Date: Tue, 3 Feb 2009 10:07:36 -0500
X-Mailer: Apple Mail (2.930.3)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - a2s12.a2hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - loc.gov
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was seeing this error after four to five days running  kernel  
2.6.27-9-generic from a default Intrepid install. I subsequently  
installed the latest stable release, 2.6.28.3, and now just saw the  
error after twenty days up uptime.

The hardware is a Sun x4500

Here's a dump from syslog:

2009-02-03T02:32:59-05:00 foobar kernel 03 [kern.err] kernel:  
[1748960.075466] BUG: soft lockup - CPU#0 stuck for 61s! [kswapd0:234]
2009-02-03T02:32:59-05:00 foobar kernel 04 [kern.warning] kernel:  
[1748960.075471] Modules linked in: nfsd auth_rpcgss exportfs autofs4  
nfs lockd nfs_acl sunrpc ipv6 iptable_filter ip_tables x_tables ext3  
jbd mbcache parport_pc lp parport loop evdev pcspkr psmouse serio_raw  
amd_rng i2c_amd8111 k8temp i2c_amd756 i2c_core shpchp pci_hotplug xfs  
sd_mod crc_t10dif sg pata_amd pata_acpi lpfc scsi_transport_fc  
scsi_tgt ata_generic sata_mv e1000 libata scsi_mod raid10 raid456  
async_xor async_memcpy async_tx xor raid1 raid0 multipath linear  
md_mod dm_mirror dm_region_hash dm_log dm_snapshot dm_mod fuse
2009-02-03T02:32:59-05:00 foobar kernel 06 [kern.info] kernel:  
[1748960.075471] CPU 0:
2009-02-03T02:32:59-05:00 foobar kernel 04 [kern.warning] kernel:  
[1748960.075471] Modules linked in: nfsd auth_rpcgss exportfs autofs4  
nfs lockd nfs_acl sunrpc ipv6 iptable_filter ip_tables x_tables ext3  
jbd mbcache parport_pc lp parport loop evdev pcspkr psmouse serio_raw  
amd_rng i2c_amd8111 k8temp i2c_amd756 i2c_core shpchp pci_hotplug xfs  
sd_mod crc_t10dif sg pata_amd pata_acpi lpfc scsi_transport_fc  
scsi_tgt ata_generic sata_mv e1000 libata scsi_mod raid10 raid456  
async_xor async_memcpy async_tx xor raid1 raid0 multipath linear  
md_mod dm_mirror dm_region_hash dm_log dm_snapshot dm_mod fuse
2009-02-03T02:32:59-05:00 foobar kernel 06 [kern.info] kernel:  
[1748960.075471] Pid: 234, comm: kswapd0 Not tainted 2.6.28-sphe #1
2009-02-03T02:32:59-05:00 foobar kernel 06 [kern.info] kernel:  
[1748960.075471] RIP: 0010:[<ffffffff802a6116>] [<ffffffff802a6116>]  
find_get_pages+0x56/0x100
2009-02-03T02:32:59-05:00 foobar kernel 06 [kern.info] kernel:  
[1748960.075471] RSP: 0018:ffff8801f4dabbf0 EFLAGS: 00000246
2009-02-03T02:32:59-05:00 foobar kernel 06 [kern.info] kernel:  
[1748960.075471] RAX: ffff8802337a6830 RBX: ffff8801f4dabc30 RCX:  
ffff8802337a68b8
2009-02-03T02:32:59-05:00 foobar kernel 06 [kern.info] kernel:  
[1748960.075471] RDX: 0000000000000229 RSI: 0000000000000000 RDI:  
ffffe200076c2068
2009-02-03T02:32:59-05:00 foobar kernel 06 [kern.info] kernel:  
[1748960.075471] RBP: ffff8801f4dabc30 R08: 0000000000000006 R09:  
000000000000000e
2009-02-03T02:32:59-05:00 foobar kernel 06 [kern.info] kernel:  
[1748960.075471] R10: 0000000000000028 R11: 0000000000000229 R12:  
ffff88020b042e48
2009-02-03T02:32:59-05:00 foobar kernel 06 [kern.info] kernel:  
[1748960.075471] R13: ffffffff802b0c97 R14: ffff8801f4dabc30 R15:  
000000000000000e
2009-02-03T02:32:59-05:00 foobar kernel 06 [kern.info] kernel:  
[1748960.075471] FS: 00007fe7f7b966e0(0000) GS:ffffffff8073aa00(0000)  
knlGS:0000000009930830
2009-02-03T02:32:59-05:00 foobar kernel 06 [kern.info] kernel:  
[1748960.075471] CS: 0010 DS: 0018 ES: 0018 CR0: 000000008005003b
2009-02-03T02:32:59-05:00 foobar kernel 06 [kern.info] kernel:  
[1748960.075471] CR2: 00007fe7f7dafd1c CR3: 00000001f7455000 CR4:  
00000000000006e0
2009-02-03T02:32:59-05:00 foobar kernel 06 [kern.info] kernel:  
[1748960.075471] DR0: 0000000000000000 DR1: 0000000000000000 DR2:  
0000000000000000
2009-02-03T02:32:59-05:00 foobar kernel 06 [kern.info] kernel:  
[1748960.075471] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:  
0000000000000400
2009-02-03T02:32:59-05:00 foobar kernel 04 [kern.warning] kernel:  
[1748960.075471] Call Trace:
2009-02-03T02:32:59-05:00 foobar kernel 04 [kern.warning] kernel:  
[1748960.075471] [<ffffffff802b06bf>] pagevec_lookup+0x1f/0x30
2009-02-03T02:32:59-05:00 foobar kernel 04 [kern.warning] kernel:  
[1748960.075471] [<ffffffff802b20c3>] __invalidate_mapping_pages 
+0x83/0x1c0
2009-02-03T02:32:59-05:00 foobar kernel 04 [kern.warning] kernel:  
[1748960.075471] [<ffffffff802b220b>] invalidate_mapping_pages+0xb/0x10
2009-02-03T02:32:59-05:00 foobar kernel 04 [kern.warning] kernel:  
[1748960.075471] [<ffffffff802fa7c0>] shrink_icache_memory+0x2a0/0x2b0
2009-02-03T02:32:59-05:00 foobar kernel 04 [kern.warning] kernel:  
[1748960.075471] [<ffffffff802b2575>] shrink_slab+0x125/0x180
2009-02-03T02:32:59-05:00 foobar kernel 04 [kern.warning] kernel:  
[1748960.075471] [<ffffffff802b58ef>] kswapd+0x56f/0x6d0
2009-02-03T02:32:59-05:00 foobar kernel 04 [kern.warning] kernel:  
[1748960.075471] [<ffffffff802b2e30>] ? isolate_pages_global+0x0/0x270
2009-02-03T02:32:59-05:00 foobar kernel 04 [kern.warning] kernel:  
[1748960.075471] [<ffffffff8025fd90>] ? autoremove_wake_function 
+0x0/0x40
2009-02-03T02:32:59-05:00 foobar kernel 04 [kern.warning] kernel:  
[1748960.075471] [<ffffffff802b5380>] ? kswapd+0x0/0x6d0
2009-02-03T02:32:59-05:00 foobar kernel 04 [kern.warning] kernel:  
[1748960.075471] [<ffffffff8025f939>] kthread+0x49/0x90
2009-02-03T02:32:59-05:00 foobar kernel 04 [kern.warning] kernel:  
[1748960.075471] [<ffffffff8020d8b9>] child_rip+0xa/0x11
2009-02-03T02:32:59-05:00 foobar kernel 04 [kern.warning] kernel:  
[1748960.075471] [<ffffffff8025f8f0>] ? kthread+0x0/0x90
2009-02-03T02:32:59-05:00 foobar kernel 04 [kern.warning] kernel:  
[1748960.075471] [<ffffffff8020d8af>] ? child_rip+0x0/0x11

Thanks in advance,
Scott Phelps
