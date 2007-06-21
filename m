Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbXFUK1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbXFUK1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 06:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbXFUK12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 06:27:28 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:60579 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbXFUK1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 06:27:24 -0400
From: Oliver Neukum <oliver@neukum.org>
To: reiserfs-dev@namesys.com, reiserfs-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: reproducible hang with reiserfs and bash_shared_mapping
Date: Thu, 21 Jun 2007 12:26:03 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706211226.03994.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get reproducible hangs when running bash_shared_mapping from the
autotest suite. I've tested with a USB mass storage device and a PATA
hard drive. No difference. Vanilla 2.6.22-rc5 and -git5 are affected. Ext3
works flawlessly on both devices. Below is the result of sysrq-t while
tasks are hanging.

	Regards
		Oliver

Jun 21 11:56:24 valisk kernel: ReiserFS: sdb1: found reiserfs format "3.6" with standard journal
Jun 21 11:56:24 valisk kernel: ReiserFS: sdb1: warning: CONFIG_REISERFS_CHECK is set ON
Jun 21 11:56:24 valisk kernel: ReiserFS: sdb1: warning: - it is slow mode for debugging.
Jun 21 11:56:24 valisk kernel: ReiserFS: sdb1: using ordered data mode
Jun 21 11:56:24 valisk kernel: ReiserFS: sdb1: journal params: device sdb1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Jun 21 11:56:24 valisk kernel: ReiserFS: sdb1: checking transaction log (sdb1)
Jun 21 11:56:27 valisk kernel: ReiserFS: sdb1: journal-1225: No valid transactions found
Jun 21 11:56:27 valisk kernel: ReiserFS: sdb1: journal-1299: Setting newest_mount_id to 10
Jun 21 11:56:27 valisk kernel: ReiserFS: sdb1: Using r5 hash to sort names
Jun 21 11:56:27 valisk kernel: ReiserFS: sdb1: warning: Created .reiserfs_priv on sdb1 - reserved for xattr storage.
Jun 21 11:57:33 valisk kernel: SoftMAC: Scanning finished: scanned 13 channels starting with channel 1
Jun 21 11:58:01 valisk kernel: SysRq : Show State
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel:                                  free                        sibling
Jun 21 11:58:01 valisk kernel:   task                 PC        stack   pid father child younger older
Jun 21 11:58:01 valisk kernel: init          S 000000844ec941ea     0     1      0 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810001081a18 0000000000000082 0000000000000000 ffff810037971750
Jun 21 11:58:01 valisk kernel:  ffffffff80242e42 000000000000000a ffff810037971750 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  0000000000002b6b ffff810037971930 0000000000000000 ffff810001081a28
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7467>] schedule_timeout+0x8a/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023924e>] process_timeout+0x0/0x5
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029413e>] do_select+0x403/0x466
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff88089c47>] :reiserfs:reiserfs_file_write+0x17ae/0x186c
Jun 21 11:58:01 valisk kernel:  [<ffffffff880841e9>] :reiserfs:inode2sd+0xf2/0x103
Jun 21 11:58:01 valisk kernel:  [<ffffffff880a4b78>] :reiserfs:xattr_lookup_poison+0x5f/0x6c
Jun 21 11:58:01 valisk kernel:  [<ffffffff80297a94>] __d_lookup+0xb0/0x100
Jun 21 11:58:01 valisk kernel:  [<ffffffff8028e7c8>] do_lookup+0x63/0x1ae
Jun 21 11:58:01 valisk kernel:  [<ffffffff80297f7b>] dput+0x26/0x115
Jun 21 11:58:01 valisk kernel:  [<ffffffff80290e8b>] __link_path_walk+0xc4d/0xd9d
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029bf3f>] mntput_no_expire+0x1c/0x94
Jun 21 11:58:01 valisk kernel:  [<ffffffff802910a9>] link_path_walk+0xce/0xe0
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029435d>] core_sys_select+0x1bc/0x265
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029bf3f>] mntput_no_expire+0x1c/0x94
Jun 21 11:58:01 valisk kernel:  [<ffffffff8028ab45>] cp_new_stat+0xe7/0xff
Jun 21 11:58:01 valisk kernel:  [<ffffffff802948c8>] sys_select+0x15a/0x183
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209b6e>] system_call+0x7e/0x83
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: kthreadd      S ffffffff804a53f0     0     2      0 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff810001083f10 0000000000000046 0000000000000000 ffffffff805d55c0
Jun 21 11:58:01 valisk kernel:  ffffffffffffffff 0000000000000008 ffff810037971040 ffff8100010a9180
Jun 21 11:58:01 valisk kernel:  000000000000028a ffff810037971220 0000000000000000 ffff81002d6f5940
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242b1c>] kthreadd+0x8a/0x145
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242a92>] kthreadd+0x0/0x145
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: migration/0   S ffff81000100eaf0     0     3      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff810001087ed0 0000000000000046 0000000000000000 0000000000000000
Jun 21 11:58:01 valisk kernel:  ffff810037974790 0000000000000001 ffff810037974790 ffff810037971040
Jun 21 11:58:01 valisk kernel:  0000000000000475 ffff810037974970 0000000001087f20 0000000000000046
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022da8c>] migration_thread+0x188/0x220
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022d904>] migration_thread+0x0/0x220
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: ksoftirqd/0   S 0000008463d45369     0     4      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff810001089f10 0000000000000046 0000000000000000 ffff810039fe1750
Jun 21 11:58:01 valisk kernel:  0000000000000d62 0000000000000009 ffff810037974080 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  000000000000020f ffff810037974260 0000000000000010 ffff81002d4a7750
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80235e3f>] ksoftirqd+0x0/0xbe
Jun 21 11:58:01 valisk kernel:  [<ffffffff80235e79>] ksoftirqd+0x3a/0xbe
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: events/0      S ffff810037ff52c0     0     5      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff81000108bee0 0000000000000046 0000000000000282 ffff810039f5048b
Jun 21 11:58:01 valisk kernel:  ffff810039f50400 000000000000000a ffff8100379757d0 ffff810037fa1040
Jun 21 11:58:01 valisk kernel:  0000000000000adf ffff8100379759b0 0000000037ff52c0 ffff810033f6a9c0
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff8033a92b>] tty_ldisc_deref+0x1e/0x75
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023feec>] worker_thread+0x0/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023ff8d>] worker_thread+0xa1/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: khelper       S ffff810037ff5240     0     6      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff81000108fee0 0000000000000046 0000000000000000 ffff81000108e000
Jun 21 11:58:01 valisk kernel:  0000000000000e00 000000000000000a ffff8100379750c0 ffff8100378c2890
Jun 21 11:58:01 valisk kernel:  0000000000002728 ffff8100379752a0 000000008020a97e 0000000000000010
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023f068>] __call_usermodehelper+0x24/0x5b
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023feec>] worker_thread+0x0/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023ff8d>] worker_thread+0xa1/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: kblockd/0     S ffff8100010d0bc0     0    26      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff8100010f5ee0 0000000000000046 ffff81003da4e000 ffffffff880204dd
Jun 21 11:58:01 valisk kernel:  ffff810037dc37a8 000000000000000a ffff8100010ca040 ffff8100378ef140
Jun 21 11:58:01 valisk kernel:  00000000000092c5 ffff8100010ca220 0000000037dc38a8 ffffffff802e8fd7
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff880204dd>] :scsi_mod:scsi_request_fn+0x34b/0x3a0
Jun 21 11:58:01 valisk kernel:  [<ffffffff802e8fd7>] blk_unplug_work+0x5b/0x62
Jun 21 11:58:01 valisk kernel:  [<ffffffff802edf0c>] cfq_kick_queue+0x22/0x35
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023feec>] worker_thread+0x0/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023ff8d>] worker_thread+0xa1/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: kacpid        S 00000083d4a0fe2c     0    27      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff8100010f7ee0 0000000000000046 0000000000000000 ffffffff880115f5
Jun 21 11:58:01 valisk kernel:  ffff8100010d00c0 000000000000000a ffff8100010dc790 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  000000000000a6e9 ffff8100010dc970 0000000000000000 ffff810030bf9740
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff880115f5>] :thermal:acpi_thermal_check+0x376/0x385
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023feec>] worker_thread+0x0/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023ff8d>] worker_thread+0xa1/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: kacpi_notify  S ffff8100010d0840     0    28      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff8100010fbee0 0000000000000046 ffff8100010dc080 ffff8100010dc0b0
Jun 21 11:58:01 valisk kernel:  ffffffff8049a580 0000000000000001 ffff8100010dc080 ffff8100379750c0
Jun 21 11:58:01 valisk kernel:  00000000000002e6 ffff8100010dc260 0000000008001144 ffff810001081d10
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023feec>] worker_thread+0x0/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023ff8d>] worker_thread+0xa1/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: cqueue/0      S ffff81003780eec0     0   135      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff81000110fee0 0000000000000046 ffff8100378f6100 ffff8100378f6130
Jun 21 11:58:01 valisk kernel:  ffffffff8049a580 0000000000000001 ffff8100378f6100 ffff810037971040
Jun 21 11:58:01 valisk kernel:  0000000000000274 ffff8100378f62e0 0000000000000000 ffff810001081d20
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023feec>] worker_thread+0x0/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023ff8d>] worker_thread+0xa1/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: kseriod       S ffffffff804bfcf0     0   136      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff810037893ed0 0000000000000046 ffff810037edc810 ffffffff804bfb88
Jun 21 11:58:01 valisk kernel:  ffff810037893e90 000000000000000a ffff8100010be790 ffff810037971750
Jun 21 11:58:01 valisk kernel:  00000000000006b6 ffff8100010be970 00000000805d55c0 ffffffff8035b013
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff8035b013>] next_device+0x9/0x1d
Jun 21 11:58:01 valisk kernel:  [<ffffffff8035b138>] bus_for_each_dev+0x61/0x6e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80362b6d>] serio_thread+0x2ae/0x301
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff803628bf>] serio_thread+0x0/0x301
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: pdflush       D 0000007d75b2931c     0   163      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff81003799dca0 0000000000000046 0000000000000000 0000000000000002
Jun 21 11:58:01 valisk kernel:  0000000000000000 000000000000000a ffff8100378b0040 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  000000000000457f ffff8100378b0220 000000003faf0798 ffff810037f33b98
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff8809da72>] :reiserfs:queue_log_writer+0x66/0x8a
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff880a08bf>] :reiserfs:do_journal_end+0x201/0xc2c
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f0e35>] __next_cpu+0x19/0x28
Jun 21 11:58:01 valisk kernel:  [<ffffffff8808f22c>] :reiserfs:reiserfs_sync_fs+0x38/0x5c
Jun 21 11:58:01 valisk kernel:  [<ffffffff802899d6>] sync_supers+0x64/0xb1
Jun 21 11:58:01 valisk kernel:  [<ffffffff80268a5a>] pdflush+0x0/0x208
Jun 21 11:58:01 valisk kernel:  [<ffffffff802686d0>] wb_kupdate+0x29/0x10b
Jun 21 11:58:01 valisk kernel:  [<ffffffff80268a5a>] pdflush+0x0/0x208
Jun 21 11:58:01 valisk kernel:  [<ffffffff80268bb8>] pdflush+0x15e/0x208
Jun 21 11:58:01 valisk kernel:  [<ffffffff802686a7>] wb_kupdate+0x0/0x10b
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: pdflush       S ffff81003799fef8     0   164      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff81003799fec0 0000000000000046 ffff81003799fe18 ffffffff802a305a
Jun 21 11:58:01 valisk kernel:  0000000000259aa4 000000000000000a ffff8100378b0750 ffff8100378b0040
Jun 21 11:58:01 valisk kernel:  0000000000000762 ffff8100378b0930 0000000000000000 00000000000002b0
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff802a305a>] writeback_inodes+0xa8/0xda
Jun 21 11:58:01 valisk kernel:  [<ffffffff80268a5a>] pdflush+0x0/0x208
Jun 21 11:58:01 valisk kernel:  [<ffffffff80268b4c>] pdflush+0xf2/0x208
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: kswapd0       S ffff81003788f180     0   165      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff81003da51e20 0000000000000046 ffff81003da51da0 ffffffff805d55c0
Jun 21 11:58:01 valisk kernel:  0000000000000286 0000000000000003 ffff81003788f180 ffff81003788f890
Jun 21 11:58:01 valisk kernel:  00000000000004b6 ffff81003788f360 00000000ffffffff ffffffdfdff3ffff
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff8026bba4>] kswapd+0x0/0x4bd
Jun 21 11:58:01 valisk kernel:  [<ffffffff8026bcc3>] kswapd+0x11f/0x4bd
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e6acc>] thread_return+0x0/0xf6
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8026bba4>] kswapd+0x0/0x4bd
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: aio/0         S 0000000b5a14fdce     0   166      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff81003da55ee0 0000000000000046 0000000000000000 ffff81003788f8c0
Jun 21 11:58:01 valisk kernel:  ffffffff8049a580 0000000000000003 ffff81003788f890 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  0000000000001289 ffff81003788fa70 00000000afffffff ffff810001081d50
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023feec>] worker_thread+0x0/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023ff8d>] worker_thread+0xa1/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: kpsmoused     S ffff810037fb55c0     0   400      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff810037989ee0 0000000000000046 ffff8100010a9890 ffff8100010a98c0
Jun 21 11:58:01 valisk kernel:  ffffffff8049a580 0000000000000009 ffff8100010a9890 ffff8100379750c0
Jun 21 11:58:01 valisk kernel:  000000000000025c ffff8100010a9a70 0000000000000000 ffff810001081d50
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023feec>] worker_thread+0x0/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023ff8d>] worker_thread+0xa1/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: ata/0         S ffff810037eb2cc0     0   464      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff81003db23ee0 0000000000000046 00000000fffedd4c 58ffffff00000001
Jun 21 11:58:01 valisk kernel:  0000000000000000 000000000000000a ffff810037889850 ffff810037efc100
Jun 21 11:58:01 valisk kernel:  0000000000007354 ffff810037889a30 0000000000000004 ffff81003ed88ad0
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff8804d39e>] :libata:ata_pio_task+0xcc/0xd9
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023feec>] worker_thread+0x0/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023ff8d>] worker_thread+0xa1/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: ata_aux       S ffff810037eb2b40     0   465      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff810037dc1ee0 0000000000000046 ffff8100010be080 ffff8100010be0b0
Jun 21 11:58:01 valisk kernel:  ffff810037eded80 0000000000000005 ffff8100010be080 ffff810037efc100
Jun 21 11:58:01 valisk kernel:  0000000000000193 ffff8100010be260 0000000000007529 ffff810037991cd8
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023feec>] worker_thread+0x0/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023ff8d>] worker_thread+0xa1/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: scsi_eh_0     S 0000000000000293     0   467      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff810037dcde80 0000000000000046 0000000000000000 0000000000000000
Jun 21 11:58:01 valisk kernel:  0000000000000082 0000000000000005 ffff8100010c17d0 ffff810037efc100
Jun 21 11:58:01 valisk kernel:  00000000005a0096 ffff8100010c19b0 0000000000000000 0000000000000001
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff8801a269>] :scsi_mod:__scsi_iterate_devices+0x56/0x6f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8801e1e5>] :scsi_mod:scsi_error_handler+0x69/0x4c7
Jun 21 11:58:01 valisk kernel:  [<ffffffff8801e17c>] :scsi_mod:scsi_error_handler+0x0/0x4c7
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: scsi_eh_1     S 0000000000000293     0   468      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff810037dc5e80 0000000000000046 0000000000000000 0000000000000000
Jun 21 11:58:01 valisk kernel:  0000000000000082 000000000000000a ffff8100378c9040 ffff810037efc100
Jun 21 11:58:01 valisk kernel:  00000000002c1e0c ffff8100378c9220 0000000000000000 0000000000000001
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff8801a269>] :scsi_mod:__scsi_iterate_devices+0x56/0x6f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8801e1e5>] :scsi_mod:scsi_error_handler+0x69/0x4c7
Jun 21 11:58:01 valisk kernel:  [<ffffffff8801e17c>] :scsi_mod:scsi_error_handler+0x0/0x4c7
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: ksuspend_usbd S ffff810037c36740     0   629      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff81003d4afee0 0000000000000046 ffff810037fa1750 ffff810037fa1780
Jun 21 11:58:01 valisk kernel:  ffff81003dbf1780 0000000000000008 ffff810037fa1750 ffff810037f9b7d0
Jun 21 11:58:01 valisk kernel:  0000000000000411 ffff810037fa1930 000000006e695f79 ffff81003db3fcd8
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023feec>] worker_thread+0x0/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023ff8d>] worker_thread+0xa1/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: khubd         S ffffffff880f40d0     0   630      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff810037c05e40 0000000000000046 ffff81003670f888 ffff81003679fc80
Jun 21 11:58:01 valisk kernel:  0000000000000000 000000000000000a ffff810037f9f790 ffff8100010ad040
Jun 21 11:58:01 valisk kernel:  000000000000ff16 ffff810037f9f970 0000000037e35888 0000000000000000
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff880d6be3>] :usbcore:hub_thread+0xa8e/0xb0a
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff880d6155>] :usbcore:hub_thread+0x0/0xb0a
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: reiserfs/0    S 0000007d780cfdf6     0  1049      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff810037d41ee0 0000000000000046 0000000000000000 00000001378ef880
Jun 21 11:58:01 valisk kernel:  0000000000023c54 000000000000000a ffff8100378ef850 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  0000000000000376 ffff8100378efa30 0000000000d23210 ffff81003db99c00
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023feec>] worker_thread+0x0/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023ff8d>] worker_thread+0xa1/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: udevd         S 7fffffffffffffff     0  1130      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff81003c6ada18 0000000000000082 0000000000000000 ffff81003d66eef8
Jun 21 11:58:01 valisk kernel:  0000000000000206 0000000000000004 ffff8100010ad040 ffff810037974080
Jun 21 11:58:01 valisk kernel:  000000000001949c ffff8100010ad220 0000000000000286 ffff8100373670c0
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e73fb>] schedule_timeout+0x1e/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff80243048>] add_wait_queue+0x15/0x45
Jun 21 11:58:01 valisk kernel:  [<ffffffff8028cf0d>] pipe_poll+0x2d/0x87
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029413e>] do_select+0x403/0x466
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff80267563>] __alloc_pages+0x61/0x2c3
Jun 21 11:58:01 valisk kernel:  [<ffffffff8026cb17>] zone_statistics+0x3f/0x60
Jun 21 11:58:01 valisk kernel:  [<ffffffff880a4b78>] :reiserfs:xattr_lookup_poison+0x5f/0x6c
Jun 21 11:58:01 valisk kernel:  [<ffffffff80297f7b>] dput+0x26/0x115
Jun 21 11:58:01 valisk kernel:  [<ffffffff8028e710>] __follow_mount+0x26/0x7b
Jun 21 11:58:01 valisk kernel:  [<ffffffff8028e7c8>] do_lookup+0x63/0x1ae
Jun 21 11:58:01 valisk kernel:  [<ffffffff8028ea9a>] permission+0xaf/0xf7
Jun 21 11:58:01 valisk kernel:  [<ffffffff802903ac>] __link_path_walk+0x16e/0xd9d
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029435d>] core_sys_select+0x1bc/0x265
Jun 21 11:58:01 valisk kernel:  [<ffffffff80297a94>] __d_lookup+0xb0/0x100
Jun 21 11:58:01 valisk kernel:  [<ffffffff8028ea9a>] permission+0xaf/0xf7
Jun 21 11:58:01 valisk kernel:  [<ffffffff802a179f>] simple_empty+0x10/0x58
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242fbf>] remove_wait_queue+0x12/0x45
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029482f>] sys_select+0xc1/0x183
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209b6e>] system_call+0x7e/0x83
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: tifm          S ffff810037c362c0     0  1542      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff81003df9bee0 0000000000000046 ffff81003c98d810 ffff81003c98d840
Jun 21 11:58:01 valisk kernel:  ffff81003cc0c500 0000000000000007 ffff81003c98d810 ffff81003bef4100
Jun 21 11:58:01 valisk kernel:  000000000000038b ffff81003c98d9f0 000000008702bb60 ffff81003c999cd8
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023feec>] worker_thread+0x0/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023ff8d>] worker_thread+0xa1/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: khpsbpkt      S ffff81003df3bee8     0  1612      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff81003df3bf00 0000000000000046 0000001f6e08fe16 ffff81003dd61d90
Jun 21 11:58:01 valisk kernel:  0000000000000001 000000000000000a ffff81003d7c4890 ffff8100378c9750
Jun 21 11:58:01 valisk kernel:  0000000000000226 ffff81003d7c4a70 0000000000000000 ffff81003dd61d20
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff881ec417>] :ieee1394:hpsbpkt_thread+0x0/0x11d
Jun 21 11:58:01 valisk kernel:  [<ffffffff881ec50d>] :ieee1394:hpsbpkt_thread+0xf6/0x11d
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: knodemgrd_0   S ffff81003d9201d8     0  1629      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff81003dd61e80 0000000000000046 ffff81003dbe5448 ffff81003d8433c0
Jun 21 11:58:01 valisk kernel:  0000000000000000 0000000000000009 ffff8100378c9750 ffff81003da7f080
Jun 21 11:58:01 valisk kernel:  000000000000ce76 ffff8100378c9930 00000000881f4f59 ffffffff802c9b19
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff802c9b19>] sysfs_make_dirent+0x29/0x38
Jun 21 11:58:01 valisk kernel:  [<ffffffff802caab4>] sysfs_create_link+0x128/0x140
Jun 21 11:58:01 valisk kernel:  [<ffffffff881f0c08>] :ieee1394:nodemgr_host_thread+0x80/0xa14
Jun 21 11:58:01 valisk kernel:  [<ffffffff881f0b88>] :ieee1394:nodemgr_host_thread+0x0/0xa14
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022d518>] schedule_tail+0x56/0x93
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: pccardd       S ffff81003e27dab0     0  2128      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff81003c789ed0 0000000000000046 0000000000000282 ffffffff802393b2
Jun 21 11:58:01 valisk kernel:  ffffffff882a2f40 0000000000000005 ffff81003def1180 ffff81003be90080
Jun 21 11:58:01 valisk kernel:  00000000000015f5 ffff81003def1360 00000000ffff319c ffffffff803e746f
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff802393b2>] try_to_del_timer_sync+0x51/0x5a
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e746f>] schedule_timeout+0x92/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023924e>] process_timeout+0x0/0x5
Jun 21 11:58:01 valisk kernel:  [<ffffffff88299bca>] :pcmcia_core:pccardd+0x1c3/0x21c
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff88299a07>] :pcmcia_core:pccardd+0x0/0x21c
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: syslog-ng     S 00000081fc83de95     0  2535      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff81003932fb28 0000000000000086 0000000000000000 ffffffff8808f2c6
Jun 21 11:58:01 valisk kernel:  ffff81003db99c00 000000000000000a ffff8100378ef140 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  00000000000056ba ffff8100378ef320 0000000000000000 ffff81003932fb38
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff8808f2c6>] :reiserfs:reiserfs_dirty_inode+0x6f/0x76
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7467>] schedule_timeout+0x8a/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023924e>] process_timeout+0x0/0x5
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293c18>] do_sys_poll+0x276/0x35e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e70>] wake_bit_function+0x0/0x23
Jun 21 11:58:01 valisk kernel:  [<ffffffff80267f07>] __set_page_dirty_nobuffers+0xbc/0xc7
Jun 21 11:58:01 valisk kernel:  [<ffffffff8809e6a7>] :reiserfs:flush_commit_list+0x51d/0x5c1
Jun 21 11:58:01 valisk kernel:  [<ffffffff880a2d04>] :reiserfs:reiserfs_commit_for_inode+0x14c/0x1ac
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293d32>] sys_poll+0x32/0x3b
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209b6e>] system_call+0x7e/0x83
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: klogd         R  running task       0  2538      1 (NOTLB)
Jun 21 11:58:01 valisk kernel: dbus-daemon   S 7fffffffffffffff     0  2555      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff8100393e3b28 0000000000000082 ffff8100393e3ae8 ffffffff80228a22
Jun 21 11:58:01 valisk kernel:  ffff8100393e3ab8 000000000000000a ffff8100378f6810 ffff8100372587d0
Jun 21 11:58:01 valisk kernel:  000000000000061b ffff8100378f69f0 0000000000000001 ffff810036979140
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228a22>] task_rq_lock+0x3d/0x6f
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e73fb>] schedule_timeout+0x1e/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff80243048>] add_wait_queue+0x15/0x45
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293c18>] do_sys_poll+0x276/0x35e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8028807d>] do_readv_writev+0x199/0x1ae
Jun 21 11:58:01 valisk kernel:  [<ffffffff80286c9b>] sys_faccessat+0x103/0x148
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293d32>] sys_poll+0x32/0x3b
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209b6e>] system_call+0x7e/0x83
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: resmgrd       S 7fffffffffffffff     0  2628      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810039f47b28 0000000000000082 ffff810039f47d48 0000000000000002
Jun 21 11:58:01 valisk kernel:  ffff8100379809c0 0000000000000009 ffff81003d7fb040 ffff81003b4b5750
Jun 21 11:58:01 valisk kernel:  0000000000001878 ffff81003d7fb220 00000000000004d0 ffff81003b4b5750
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e73fb>] schedule_timeout+0x1e/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e1ed0>] unix_stream_recvmsg+0x439/0x56c
Jun 21 11:58:01 valisk kernel:  [<ffffffff80243048>] add_wait_queue+0x15/0x45
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293c18>] do_sys_poll+0x276/0x35e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8037e974>] sock_recvmsg+0xf8/0x117
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029bf3f>] mntput_no_expire+0x1c/0x94
Jun 21 11:58:01 valisk kernel:  [<ffffffff802910a9>] link_path_walk+0xce/0xe0
Jun 21 11:58:01 valisk kernel:  [<ffffffff80264e84>] filemap_nopage+0x180/0x2b0
Jun 21 11:58:01 valisk kernel:  [<ffffffff8037f857>] sys_recvmsg+0x15c/0x254
Jun 21 11:58:01 valisk kernel:  [<ffffffff80380e46>] sk_free+0xc8/0xde
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d7f>] bit_waitqueue+0x1c/0x90
Jun 21 11:58:01 valisk kernel:  [<ffffffff80297323>] d_kill+0x44/0x59
Jun 21 11:58:01 valisk kernel:  [<ffffffff80297f7b>] dput+0x26/0x115
Jun 21 11:58:01 valisk kernel:  [<ffffffff80288a9d>] __fput+0x151/0x180
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293d32>] sys_poll+0x32/0x3b
Jun 21 11:58:01 valisk kernel:  [<ffffffff802874bd>] sys_close+0x8c/0xc9
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209b6e>] system_call+0x7e/0x83
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: acpid         S 0000002e785fcbc9     0  2705      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810039135b28 0000000000000086 0000000000000000 ffff81003d7c4180
Jun 21 11:58:01 valisk kernel:  0000000000009dec 0000000000000007 ffff81003d7c4180 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  0000000000000ae5 ffff81003d7c4360 0000000000000001 0000002e785f1ec0
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e73fb>] schedule_timeout+0x1e/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff80243048>] add_wait_queue+0x15/0x45
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293c18>] do_sys_poll+0x276/0x35e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8037ea7d>] sock_sendmsg+0xea/0x107
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f0ec9>] _atomic_dec_and_lock+0x39/0x58
Jun 21 11:58:01 valisk kernel:  [<ffffffff8037f4fb>] sys_sendto+0x128/0x151
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e6acc>] thread_return+0x0/0xf6
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293d32>] sys_poll+0x32/0x3b
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209b6e>] system_call+0x7e/0x83
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: polkitd       S 7fffffffffffffff     0  2893      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff8100388e3b28 0000000000000086 ffff810035fa62e8 ffffffff80228a22
Jun 21 11:58:01 valisk kernel:  0000000000000001 000000000000000a ffff81003913a0c0 ffff8100378f6810
Jun 21 11:58:01 valisk kernel:  0000000000012345 ffff81003913a2a0 00000000378f6810 ffff8100391e7870
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228a22>] task_rq_lock+0x3d/0x6f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b241>] try_to_wake_up+0x3f8/0x409
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e73fb>] schedule_timeout+0x1e/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff80243048>] add_wait_queue+0x15/0x45
Jun 21 11:58:01 valisk kernel:  [<ffffffff80243048>] add_wait_queue+0x15/0x45
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293c18>] do_sys_poll+0x276/0x35e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8037dee8>] sock_aio_write+0x110/0x128
Jun 21 11:58:01 valisk kernel:  [<ffffffff8037e00c>] sock_aio_read+0x10c/0x124
Jun 21 11:58:01 valisk kernel:  [<ffffffff80287b1c>] do_sync_read+0xc9/0x10c
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8028807d>] do_readv_writev+0x199/0x1ae
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293d32>] sys_poll+0x32/0x3b
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209b6e>] system_call+0x7e/0x83
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: hald          S 00000083e7a897ee     0  2904      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff8100384d9b28 0000000000000082 0000000000000000 0000000000000001
Jun 21 11:58:01 valisk kernel:  ffff81003796c8a0 0000000000000009 ffff81003b941140 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  000000000003381e ffff81003b941320 00000000384d9bb8 ffff8100384d9b38
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7467>] schedule_timeout+0x8a/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023924e>] process_timeout+0x0/0x5
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293c18>] do_sys_poll+0x276/0x35e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff802728b7>] remove_vma+0x5d/0x64
Jun 21 11:58:01 valisk kernel:  [<ffffffff802734c8>] do_munmap+0x254/0x276
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293d32>] sys_poll+0x32/0x3b
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209b6e>] system_call+0x7e/0x83
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: hald-runner   S 7fffffffffffffff     0  2905   2904 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff8100384fbb28 0000000000000086 0000000000000001 ffffffff80228a22
Jun 21 11:58:01 valisk kernel:  ffff8100384fbab8 0000000000000008 ffff8100378c2180 ffff81003b941140
Jun 21 11:58:01 valisk kernel:  0000000000004f61 ffff8100378c2360 0000000000000001 00000000384fbb38
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228a22>] task_rq_lock+0x3d/0x6f
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e73fb>] schedule_timeout+0x1e/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff80243048>] add_wait_queue+0x15/0x45
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293c18>] do_sys_poll+0x276/0x35e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8037dee8>] sock_aio_write+0x110/0x128
Jun 21 11:58:01 valisk kernel:  [<ffffffff8037ddd8>] sock_aio_write+0x0/0x128
Jun 21 11:58:01 valisk kernel:  [<ffffffff802180c6>] flush_tlb_page+0x90/0xaf
Jun 21 11:58:01 valisk kernel:  [<ffffffff8026e142>] do_wp_page+0x1b7/0x490
Jun 21 11:58:01 valisk kernel:  [<ffffffff8026fc6d>] __handle_mm_fault+0x9c0/0xa47
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f3cab>] __up_read+0x13/0x8a
Jun 21 11:58:01 valisk kernel:  [<ffffffff803ea59f>] do_page_fault+0x41f/0x76f
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e6acc>] thread_return+0x0/0xf6
Jun 21 11:58:01 valisk kernel:  [<ffffffff80233d2f>] do_wait+0x9e7/0xa97
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293d32>] sys_poll+0x32/0x3b
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209b6e>] system_call+0x7e/0x83
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: hald-addon-ke S ffff810037effc80     0  2958   2905 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810038399ea8 0000000000000082 0000000000000000 00002b259bf61000
Jun 21 11:58:01 valisk kernel:  0000000000001000 000000000000000a ffff810037fa1040 ffff81002d304850
Jun 21 11:58:01 valisk kernel:  0000000000000aa7 ffff810037fa1220 0000000000000082 ffff8100379757d0
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803689ed>] evdev_read+0xff/0x211
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80288335>] vfs_read+0xcb/0x153
Jun 21 11:58:01 valisk kernel:  [<ffffffff802886d1>] sys_read+0x45/0x6e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209b6e>] system_call+0x7e/0x83
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: kondemand/0   S 000000846d0e5b2e     0  2966      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff8100374f1ee0 0000000000000046 0000000000000000 ffff8100010144d8
Jun 21 11:58:01 valisk kernel:  0000000000000282 000000000000000a ffff810039fbb790 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  00000000000005d2 ffff810039fbb970 0000000000000286 ffffffff802f3d43
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f3d43>] __up_write+0x21/0x10e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023feec>] worker_thread+0x0/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023ff8d>] worker_thread+0xa1/0xe4
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: hald-addon-ke S ffff810038e1e4c0     0  2969   2905 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff8100375e9ea8 0000000000000086 0000000000000000 ffff8100374efe48
Jun 21 11:58:01 valisk kernel:  ffff8100374efce8 0000000000000007 ffff810037f9f080 ffff81003b941140
Jun 21 11:58:01 valisk kernel:  00000000000720eb ffff810037f9f260 0000000000000206 0000000000000000
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803689ed>] evdev_read+0xff/0x211
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80288335>] vfs_read+0xcb/0x153
Jun 21 11:58:01 valisk kernel:  [<ffffffff802886d1>] sys_read+0x45/0x6e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209b6e>] system_call+0x7e/0x83
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: hald-addon-ke S ffff81003914cd80     0  2974   2905 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff8100375a9ea8 0000000000000082 0000000000000000 ffff8100387fd1e8
Jun 21 11:58:01 valisk kernel:  ffff8100387fd608 0000000000000006 ffff81003d7fb750 ffff81003912f100
Jun 21 11:58:01 valisk kernel:  000000000007e60e ffff81003d7fb930 0000000000000202 0000000000000000
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803689ed>] evdev_read+0xff/0x211
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80288335>] vfs_read+0xcb/0x153
Jun 21 11:58:01 valisk kernel:  [<ffffffff802886d1>] sys_read+0x45/0x6e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209b6e>] system_call+0x7e/0x83
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: hald-addon-ke S ffff81003914c980     0  2976   2905 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810037535ea8 0000000000000082 0000000000000000 ffff810037620ce8
Jun 21 11:58:01 valisk kernel:  ffff8100374ef088 0000000000000005 ffff81003d1d7080 ffff8100378c2180
Jun 21 11:58:01 valisk kernel:  0000000000081fda ffff81003d1d7260 0000000000000202 0000000000000000
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803689ed>] evdev_read+0xff/0x211
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80288335>] vfs_read+0xcb/0x153
Jun 21 11:58:01 valisk kernel:  [<ffffffff802886d1>] sys_read+0x45/0x6e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209b6e>] system_call+0x7e/0x83
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: hald-addon-ke S ffff81003914c480     0  2977   2905 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810038395ea8 0000000000000082 0000000000000000 ffff81003a3d5a28
Jun 21 11:58:01 valisk kernel:  ffff810039fc23f8 0000000000000006 ffff81003912f100 ffff8100010ca750
Jun 21 11:58:01 valisk kernel:  000000000007a421 ffff81003912f2e0 0000000000000202 0000000000000000
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803689ed>] evdev_read+0xff/0x211
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80288335>] vfs_read+0xcb/0x153
Jun 21 11:58:01 valisk kernel:  [<ffffffff802886d1>] sys_read+0x45/0x6e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209b6e>] system_call+0x7e/0x83
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: dhcdbd        S 0000008481cecf76     0  3006      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff81003700ba18 0000000000000082 0000000000000000 ffff81000100d880
Jun 21 11:58:01 valisk kernel:  0000003230ecafcf 000000000000000a ffff81003880b890 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  0000000000001de5 ffff81003880ba70 000000003ccaeb40 ffff81003700ba28
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7467>] schedule_timeout+0x8a/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023924e>] process_timeout+0x0/0x5
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029413e>] do_select+0x403/0x466
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228991>] __wake_up+0x38/0x4f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8038227f>] sock_def_readable+0x34/0x5f
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e2a27>] unix_stream_sendmsg+0x27e/0x34a
Jun 21 11:58:01 valisk kernel:  [<ffffffff8037e974>] sock_recvmsg+0xf8/0x117
Jun 21 11:58:01 valisk kernel:  [<ffffffff880a4b78>] :reiserfs:xattr_lookup_poison+0x5f/0x6c
Jun 21 11:58:01 valisk kernel:  [<ffffffff80297a94>] __d_lookup+0xb0/0x100
Jun 21 11:58:01 valisk kernel:  [<ffffffff802402e8>] get_pid_task+0x5/0xf
Jun 21 11:58:01 valisk kernel:  [<ffffffff802be7f7>] pid_revalidate+0x73/0xf7
Jun 21 11:58:01 valisk kernel:  [<ffffffff8028e7c8>] do_lookup+0x63/0x1ae
Jun 21 11:58:01 valisk kernel:  [<ffffffff80297f7b>] dput+0x26/0x115
Jun 21 11:58:01 valisk kernel:  [<ffffffff80290e8b>] __link_path_walk+0xc4d/0xd9d
Jun 21 11:58:01 valisk kernel:  [<ffffffff8037ddd8>] sock_aio_write+0x0/0x128
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029435d>] core_sys_select+0x1bc/0x265
Jun 21 11:58:01 valisk kernel:  [<ffffffff80239afb>] recalc_sigpending+0xe/0x25
Jun 21 11:58:01 valisk kernel:  [<ffffffff80239bb0>] sigprocmask+0x9e/0xc0
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029bf3f>] mntput_no_expire+0x1c/0x94
Jun 21 11:58:01 valisk kernel:  [<ffffffff80286c9b>] sys_faccessat+0x103/0x148
Jun 21 11:58:01 valisk kernel:  [<ffffffff802948c8>] sys_select+0x15a/0x183
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209b6e>] system_call+0x7e/0x83
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: hald-addon-cp S 7fffffffffffffff     0  3008   2905 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810037783b28 0000000000000082 ffff81003b97d060 ffffffff80228a22
Jun 21 11:58:01 valisk kernel:  ffff810037783ab8 0000000000000009 ffff810039b65140 ffff81003913a0c0
Jun 21 11:58:01 valisk kernel:  0000000000002491 ffff810039b65320 0000000000000001 00000000d4521f57
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228a22>] task_rq_lock+0x3d/0x6f
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e73fb>] schedule_timeout+0x1e/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff80243048>] add_wait_queue+0x15/0x45
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293c18>] do_sys_poll+0x276/0x35e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8037dee8>] sock_aio_write+0x110/0x128
Jun 21 11:58:01 valisk kernel:  [<ffffffff8037ddd8>] sock_aio_write+0x0/0x128
Jun 21 11:58:01 valisk kernel:  [<ffffffff80287900>] do_sync_readv_writev+0xc0/0x107
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f4d1b>] sscanf+0x49/0x51
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f0ec9>] _atomic_dec_and_lock+0x39/0x58
Jun 21 11:58:01 valisk kernel:  [<ffffffff8028807d>] do_readv_writev+0x199/0x1ae
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e6acc>] thread_return+0x0/0xf6
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293d32>] sys_poll+0x32/0x3b
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209b6e>] system_call+0x7e/0x83
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: hald-addon-ac S 7fffffffffffffff     0  3009   2905 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810037069bd8 0000000000000086 0000000000000296 ffff810037705d78
Jun 21 11:58:01 valisk kernel:  0000000000000001 0000000000000003 ffff8100010c10c0 ffff81003b941850
Jun 21 11:58:01 valisk kernel:  0000000000003e97 ffff8100010c12a0 0000000000000286 ffffffff80297a94
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80297a94>] __d_lookup+0xb0/0x100
Jun 21 11:58:01 valisk kernel:  [<ffffffff8809e9e4>] :reiserfs:get_cnode+0x6b/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e73fb>] schedule_timeout+0x1e/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242f63>] prepare_to_wait+0x15/0x5f
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e1cdc>] unix_stream_recvmsg+0x245/0x56c
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8037e00c>] sock_aio_read+0x10c/0x124
Jun 21 11:58:01 valisk kernel:  [<ffffffff80272efe>] vma_adjust+0x217/0x451
Jun 21 11:58:01 valisk kernel:  [<ffffffff80287b1c>] do_sync_read+0xc9/0x10c
Jun 21 11:58:01 valisk kernel:  [<ffffffff80273685>] vma_merge+0x141/0x1ee
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff802745f3>] do_mmap_pgoff+0x639/0x7a5
Jun 21 11:58:01 valisk kernel:  [<ffffffff80288348>] vfs_read+0xde/0x153
Jun 21 11:58:01 valisk kernel:  [<ffffffff802886d1>] sys_read+0x45/0x6e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209b6e>] system_call+0x7e/0x83
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: NetworkManage S 0000002ef906c17a     0  3020      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff8100371fbb28 0000000000000086 0000000000000000 ffffffff80242e31
Jun 21 11:58:01 valisk kernel:  ffff810033ce2610 0000000000000005 ffff81003913a7d0 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  0000000000010e23 ffff81003913a9b0 00000000371fbe78 ffff8100371fbd68
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e31>] wake_up_bit+0x11/0x22
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e73fb>] schedule_timeout+0x1e/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff80243048>] add_wait_queue+0x15/0x45
Jun 21 11:58:01 valisk kernel:  [<ffffffff80243048>] add_wait_queue+0x15/0x45
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293c18>] do_sys_poll+0x276/0x35e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff80267270>] get_page_from_freelist+0x369/0x4e4
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293480>] filldir64+0x0/0xb8
Jun 21 11:58:01 valisk kernel:  [<ffffffff8808106f>] :reiserfs:search_by_entry_key+0x157/0x2e0
Jun 21 11:58:01 valisk kernel:  [<ffffffff88098ccd>] :reiserfs:pathrelse+0x6e/0x86
Jun 21 11:58:01 valisk kernel:  [<ffffffff8809e9e4>] :reiserfs:get_cnode+0x6b/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8809eb2a>] :reiserfs:journal_mark_dirty+0x13e/0x232
Jun 21 11:58:01 valisk kernel:  [<ffffffff880841e9>] :reiserfs:inode2sd+0xf2/0x103
Jun 21 11:58:01 valisk kernel:  [<ffffffff802180c6>] flush_tlb_page+0x90/0xaf
Jun 21 11:58:01 valisk kernel:  [<ffffffff8026e142>] do_wp_page+0x1b7/0x490
Jun 21 11:58:01 valisk kernel:  [<ffffffff8026fc6d>] __handle_mm_fault+0x9c0/0xa47
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f3cab>] __up_read+0x13/0x8a
Jun 21 11:58:01 valisk kernel:  [<ffffffff803ea59f>] do_page_fault+0x41f/0x76f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8808f2c6>] :reiserfs:reiserfs_dirty_inode+0x6f/0x76
Jun 21 11:58:01 valisk kernel:  [<ffffffff80297f7b>] dput+0x26/0x115
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293d32>] sys_poll+0x32/0x3b
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209b6e>] system_call+0x7e/0x83
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: NetworkManage S 7fffffffffffffff     0  3058      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810038765b28 0000000000000086 ffff810037fca000 ffffffff803e76c2
Jun 21 11:58:01 valisk kernel:  0000000000000000 000000000000000a ffff810037269100 ffff810037974080
Jun 21 11:58:01 valisk kernel:  0000000000003eed ffff8100372692e0 00000000ffffffff ffff81003733b890
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e76c2>] mutex_lock+0xd/0x1e
Jun 21 11:58:01 valisk kernel:  [<ffffffff803839be>] skb_dequeue+0x48/0x50
Jun 21 11:58:01 valisk kernel:  [<ffffffff80385be0>] memcpy_toiovec+0x36/0x66
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e73fb>] schedule_timeout+0x1e/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff80243048>] add_wait_queue+0x15/0x45
Jun 21 11:58:01 valisk kernel:  [<ffffffff80243048>] add_wait_queue+0x15/0x45
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293c18>] do_sys_poll+0x276/0x35e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff802357e5>] current_fs_time+0x3b/0x40
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228991>] __wake_up+0x38/0x4f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029a8e6>] touch_atime+0xbe/0x104
Jun 21 11:58:01 valisk kernel:  [<ffffffff8028dfca>] pipe_read+0x386/0x39a
Jun 21 11:58:01 valisk kernel:  [<ffffffff80287b1c>] do_sync_read+0xc9/0x10c
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d7f>] bit_waitqueue+0x1c/0x90
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293d32>] sys_poll+0x32/0x3b
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209b6e>] system_call+0x7e/0x83
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: NetworkManage S 0000008474dcb49d     0  3125      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff8100364cdb28 0000000000000086 0000000000000000 0000000000000286
Jun 21 11:58:01 valisk kernel:  0000000000000292 000000000000000a ffff81003733b890 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  00000000000024e1 ffff81003733ba70 0000000000000020 ffff8100364cdb38
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7467>] schedule_timeout+0x8a/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023924e>] process_timeout+0x0/0x5
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293c18>] do_sys_poll+0x276/0x35e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228991>] __wake_up+0x38/0x4f
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228a22>] task_rq_lock+0x3d/0x6f
Jun 21 11:58:01 valisk kernel:  [<ffffffff802287a4>] __activate_task+0x26/0x38
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b241>] try_to_wake_up+0x3f8/0x409
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228368>] __wake_up_common+0x3e/0x68
Jun 21 11:58:01 valisk kernel:  [<ffffffff802357e5>] current_fs_time+0x3b/0x40
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228991>] __wake_up+0x38/0x4f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029a7a6>] file_update_time+0x30/0xb2
Jun 21 11:58:01 valisk kernel:  [<ffffffff8028db3f>] pipe_write+0x3d3/0x44a
Jun 21 11:58:01 valisk kernel:  [<ffffffff80287a10>] do_sync_write+0xc9/0x10c
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d7f>] bit_waitqueue+0x1c/0x90
Jun 21 11:58:01 valisk kernel:  [<ffffffff8025cf9b>] audit_syscall_entry+0x141/0x174
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293d32>] sys_poll+0x32/0x3b
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: NetworkManage S 000000845fd38f80     0  3136      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff81003675bb28 0000000000000086 0000000000000000 ffff81003c919d70
Jun 21 11:58:01 valisk kernel:  ffff81003baa9560 000000000000000a ffff8100373677d0 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  00000000000078b2 ffff8100373679b0 0000000037ebbec0 ffff81003675bb38
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7467>] schedule_timeout+0x8a/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023924e>] process_timeout+0x0/0x5
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293c18>] do_sys_poll+0x276/0x35e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff80297f7b>] dput+0x26/0x115
Jun 21 11:58:01 valisk kernel:  [<ffffffff80290e8b>] __link_path_walk+0xc4d/0xd9d
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029bf3f>] mntput_no_expire+0x1c/0x94
Jun 21 11:58:01 valisk kernel:  [<ffffffff802910a9>] link_path_walk+0xce/0xe0
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f5ff3>] __strncpy_from_user+0x17/0x41
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f527a>] vsnprintf+0x557/0x59b
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f53cb>] sprintf+0x51/0x59
Jun 21 11:58:01 valisk kernel:  [<ffffffff80267563>] __alloc_pages+0x61/0x2c3
Jun 21 11:58:01 valisk kernel:  [<ffffffff8025cf9b>] audit_syscall_entry+0x141/0x174
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293d32>] sys_poll+0x32/0x3b
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: auditd        S 000000843fefa898     0  3059      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff81003746da18 0000000000000086 0000000000000000 0000000000000086
Jun 21 11:58:01 valisk kernel:  ffff81003746d9c8 000000000000000a ffff810039b65850 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  0000000000001332 ffff810039b65a30 0000000000001017 ffff81003746da28
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7467>] schedule_timeout+0x8a/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023924e>] process_timeout+0x0/0x5
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029413e>] do_select+0x403/0x466
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228991>] __wake_up+0x38/0x4f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8038227f>] sock_def_readable+0x34/0x5f
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e2a27>] unix_stream_sendmsg+0x27e/0x34a
Jun 21 11:58:01 valisk kernel:  [<ffffffff8037dee8>] sock_aio_write+0x110/0x128
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228a22>] task_rq_lock+0x3d/0x6f
Jun 21 11:58:01 valisk kernel:  [<ffffffff802287a4>] __activate_task+0x26/0x38
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b241>] try_to_wake_up+0x3f8/0x409
Jun 21 11:58:01 valisk kernel:  [<ffffffff80287900>] do_sync_readv_writev+0xc0/0x107
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029435d>] core_sys_select+0x1bc/0x265
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f3cab>] __up_read+0x13/0x8a
Jun 21 11:58:01 valisk kernel:  [<ffffffff80249364>] do_futex+0x9f8/0xab1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8028807d>] do_readv_writev+0x199/0x1ae
Jun 21 11:58:01 valisk kernel:  [<ffffffff802948c8>] sys_select+0x15a/0x183
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209b6e>] system_call+0x7e/0x83
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: auditd        S 000000817d0b74bb     0  3060      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff8100371a5cd8 0000000000000086 0000000000000000 ffff8100371a5cb8
Jun 21 11:58:01 valisk kernel:  ffff8100371a5ca8 0000000000000009 ffff810037889140 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  000000000001513a ffff810037889320 0000000000000000 ffffffff80272baa
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80272baa>] find_extend_vma+0x16/0x59
Jun 21 11:58:01 valisk kernel:  [<ffffffff802484cb>] futex_wait+0x214/0x327
Jun 21 11:58:01 valisk kernel:  [<ffffffff80247724>] get_futex_key+0x82/0x14e
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f3cab>] __up_read+0x13/0x8a
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff802489e0>] do_futex+0x74/0xab1
Jun 21 11:58:01 valisk kernel:  [<ffffffff802694ca>] pagevec_lookup_tag+0x1a/0x21
Jun 21 11:58:01 valisk kernel:  [<ffffffff80263b22>] wait_on_page_writeback_range+0xc3/0x10e
Jun 21 11:58:01 valisk kernel:  [<ffffffff880a2d04>] :reiserfs:reiserfs_commit_for_inode+0x14c/0x1ac
Jun 21 11:58:01 valisk kernel:  [<ffffffff802494ff>] sys_futex+0xe2/0x100
Jun 21 11:58:01 valisk kernel:  [<ffffffff802a51b9>] do_fsync+0x70/0xa4
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209b6e>] system_call+0x7e/0x83
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: audispd       S 7fffffffffffffff     0  3061   3059 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810036c51b28 0000000000000086 0000000000000000 000000000000000f
Jun 21 11:58:01 valisk kernel:  0000000000000002 000000000000000a ffff8100372580c0 ffff810037889140
Jun 21 11:58:01 valisk kernel:  000000000000190b ffff8100372582a0 0000000000000000 ffff810039b65850
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e73fb>] schedule_timeout+0x1e/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029392f>] free_poll_entry+0x11/0x1a
Jun 21 11:58:01 valisk kernel:  [<ffffffff80243048>] add_wait_queue+0x15/0x45
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293c18>] do_sys_poll+0x276/0x35e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff880a422b>] :reiserfs:open_xa_file+0x17/0x11b
Jun 21 11:58:01 valisk kernel:  [<ffffffff80267270>] get_page_from_freelist+0x369/0x4e4
Jun 21 11:58:01 valisk kernel:  [<ffffffff8037e00c>] sock_aio_read+0x10c/0x124
Jun 21 11:58:01 valisk kernel:  [<ffffffff80287b1c>] do_sync_read+0xc9/0x10c
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293d32>] sys_poll+0x32/0x3b
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209b6e>] system_call+0x7e/0x83
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: kauditd       S 0000000000000000     0  3062      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff810036c61ed0 0000000000000046 0000000100000000 ffff81003810e870
Jun 21 11:58:01 valisk kernel:  0000000000000000 000000000000000a ffff81003b4b5040 ffff810039b65850
Jun 21 11:58:01 valisk kernel:  0000000000000828 ffff81003b4b5220 0000000000000000 0000000000000001
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228991>] __wake_up+0x38/0x4f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8025975d>] kauditd_thread+0x111/0x148
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8025964c>] kauditd_thread+0x0/0x148
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: nscd          S 000000844038c176     0  3073      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810036dffe98 0000000000000082 0000000000000000 ffffffff802f3cab
Jun 21 11:58:01 valisk kernel:  ffff810036ebdcf8 000000000000000a ffff81003d1d7790 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  000000000000137e ffff81003d1d7970 0000000000000000 ffff810036dffea8
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f3cab>] __up_read+0x13/0x8a
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7467>] schedule_timeout+0x8a/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023924e>] process_timeout+0x0/0x5
Jun 21 11:58:01 valisk kernel:  [<ffffffff802ae87d>] sys_epoll_wait+0x182/0x420
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: nscd          S ffff810036ebbd78     0  3074      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810036ebbcd8 0000000000000082 0000000000000000 ffff810036ebbcc8
Jun 21 11:58:01 valisk kernel:  ffff810037ebb0c0 000000000000000a ffff81003733b180 ffff810036eb0750
Jun 21 11:58:01 valisk kernel:  00000000000047bf ffff81003733b360 00000000ffffffff ffffffff80244e12
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80244e12>] enqueue_hrtimer+0x64/0x6b
Jun 21 11:58:01 valisk kernel:  [<ffffffff8024535f>] hrtimer_start+0xf2/0x104
Jun 21 11:58:01 valisk kernel:  [<ffffffff80247724>] get_futex_key+0x82/0x14e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8024851a>] futex_wait+0x263/0x327
Jun 21 11:58:01 valisk kernel:  [<ffffffff80244fb6>] hrtimer_wakeup+0x0/0x22
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff802489e0>] do_futex+0x74/0xab1
Jun 21 11:58:01 valisk kernel:  [<ffffffff802463a6>] getnstimeofday+0x32/0x8c
Jun 21 11:58:01 valisk kernel:  [<ffffffff8024554c>] ktime_get_ts+0x1a/0x4e
Jun 21 11:58:01 valisk kernel:  [<ffffffff802494ff>] sys_futex+0xe2/0x100
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: nscd          S ffff810036ebdd78     0  3075      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810036ebdcd8 0000000000000082 0000000000000000 ffff810036ebdcc8
Jun 21 11:58:01 valisk kernel:  ffff810037ebb0c0 000000000000000a ffff810036eb0750 ffff810036eb0040
Jun 21 11:58:01 valisk kernel:  0000000000002bbf ffff810036eb0930 00000000ffffffff ffffffff80244e12
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80244e12>] enqueue_hrtimer+0x64/0x6b
Jun 21 11:58:01 valisk kernel:  [<ffffffff8024535f>] hrtimer_start+0xf2/0x104
Jun 21 11:58:01 valisk kernel:  [<ffffffff80247724>] get_futex_key+0x82/0x14e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8024851a>] futex_wait+0x263/0x327
Jun 21 11:58:01 valisk kernel:  [<ffffffff80244fb6>] hrtimer_wakeup+0x0/0x22
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff802489e0>] do_futex+0x74/0xab1
Jun 21 11:58:01 valisk kernel:  [<ffffffff802463a6>] getnstimeofday+0x32/0x8c
Jun 21 11:58:01 valisk kernel:  [<ffffffff8024554c>] ktime_get_ts+0x1a/0x4e
Jun 21 11:58:01 valisk kernel:  [<ffffffff802494ff>] sys_futex+0xe2/0x100
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: nscd          S ffff810036ebfd78     0  3076      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810036ebfcd8 0000000000000082 00000000467a4b1e ffffffff802f0ec9
Jun 21 11:58:01 valisk kernel:  ffff810037ebb0c0 000000000000000a ffff810036eb0040 ffff810036eb5790
Jun 21 11:58:01 valisk kernel:  0000000000002fea ffff810036eb0220 00000000ffffffff ffffffff80244e12
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f0ec9>] _atomic_dec_and_lock+0x39/0x58
Jun 21 11:58:01 valisk kernel:  [<ffffffff80244e12>] enqueue_hrtimer+0x64/0x6b
Jun 21 11:58:01 valisk kernel:  [<ffffffff8024535f>] hrtimer_start+0xf2/0x104
Jun 21 11:58:01 valisk kernel:  [<ffffffff80247724>] get_futex_key+0x82/0x14e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8024851a>] futex_wait+0x263/0x327
Jun 21 11:58:01 valisk kernel:  [<ffffffff80244fb6>] hrtimer_wakeup+0x0/0x22
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff802489e0>] do_futex+0x74/0xab1
Jun 21 11:58:01 valisk kernel:  [<ffffffff802463a6>] getnstimeofday+0x32/0x8c
Jun 21 11:58:01 valisk kernel:  [<ffffffff8024554c>] ktime_get_ts+0x1a/0x4e
Jun 21 11:58:01 valisk kernel:  [<ffffffff802494ff>] sys_futex+0xe2/0x100
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: nscd          S 000000842d78ddea     0  3077      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810036ec1cd8 0000000000000082 0000000000000000 ffff810036ec1cc8
Jun 21 11:58:01 valisk kernel:  ffff810037ebb0c0 000000000000000a ffff810036eb5790 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  0000000000002819 ffff810036eb5970 00000000ffffffff ffffffff80244e12
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80244e12>] enqueue_hrtimer+0x64/0x6b
Jun 21 11:58:01 valisk kernel:  [<ffffffff8024851a>] futex_wait+0x263/0x327
Jun 21 11:58:01 valisk kernel:  [<ffffffff80244fb6>] hrtimer_wakeup+0x0/0x22
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff802489e0>] do_futex+0x74/0xab1
Jun 21 11:58:01 valisk kernel:  [<ffffffff802463a6>] getnstimeofday+0x32/0x8c
Jun 21 11:58:01 valisk kernel:  [<ffffffff8024554c>] ktime_get_ts+0x1a/0x4e
Jun 21 11:58:01 valisk kernel:  [<ffffffff802494ff>] sys_futex+0xe2/0x100
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: nscd          S ffff810036ec3d10     0  3078      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810036ec3cd8 0000000000000082 0000000000000000 0000000000000000
Jun 21 11:58:01 valisk kernel:  0000000000000000 000000000000000a ffff810036eb5080 ffff81002c45f890
Jun 21 11:58:01 valisk kernel:  0000000000002627 ffff810036eb5260 0000000036eb5080 ffffffff80272baa
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80272baa>] find_extend_vma+0x16/0x59
Jun 21 11:58:01 valisk kernel:  [<ffffffff80247724>] get_futex_key+0x82/0x14e
Jun 21 11:58:01 valisk kernel:  [<ffffffff802484cb>] futex_wait+0x214/0x327
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff802489e0>] do_futex+0x74/0xab1
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228991>] __wake_up+0x38/0x4f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029bf3f>] mntput_no_expire+0x1c/0x94
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d7f>] bit_waitqueue+0x1c/0x90
Jun 21 11:58:01 valisk kernel:  [<ffffffff802494ff>] sys_futex+0xe2/0x100
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: nscd          S ffff81003728fd10     0  3087      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff81003728fcd8 0000000000000082 0000000000000000 0000000000000000
Jun 21 11:58:01 valisk kernel:  0000000000000000 000000000000000a ffff8100010ca750 ffff81003b4b5750
Jun 21 11:58:01 valisk kernel:  00000000000031e9 ffff8100010ca930 00000000010ca750 ffffffff80272baa
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80272baa>] find_extend_vma+0x16/0x59
Jun 21 11:58:01 valisk kernel:  [<ffffffff80247724>] get_futex_key+0x82/0x14e
Jun 21 11:58:01 valisk kernel:  [<ffffffff802484cb>] futex_wait+0x214/0x327
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff802489e0>] do_futex+0x74/0xab1
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228991>] __wake_up+0x38/0x4f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029bf3f>] mntput_no_expire+0x1c/0x94
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d7f>] bit_waitqueue+0x1c/0x90
Jun 21 11:58:01 valisk kernel:  [<ffffffff802494ff>] sys_futex+0xe2/0x100
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: nscd          S ffff810036dbbd10     0  3088      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810036dbbcd8 0000000000000082 0000000000000000 0000000000000000
Jun 21 11:58:01 valisk kernel:  0000000000000000 000000000000000a ffff810039fbb080 ffff81002d304850
Jun 21 11:58:01 valisk kernel:  000000000000405d ffff810039fbb260 0000000039fbb080 ffffffff80272baa
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80272baa>] find_extend_vma+0x16/0x59
Jun 21 11:58:01 valisk kernel:  [<ffffffff80247724>] get_futex_key+0x82/0x14e
Jun 21 11:58:01 valisk kernel:  [<ffffffff802484cb>] futex_wait+0x214/0x327
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff802489e0>] do_futex+0x74/0xab1
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228991>] __wake_up+0x38/0x4f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029bf3f>] mntput_no_expire+0x1c/0x94
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d7f>] bit_waitqueue+0x1c/0x90
Jun 21 11:58:01 valisk kernel:  [<ffffffff802494ff>] sys_futex+0xe2/0x100
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: nscd          S ffff810036dbdd10     0  3089      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810036dbdcd8 0000000000000082 0000000000000000 0000000000000000
Jun 21 11:58:01 valisk kernel:  0000000000000000 000000000000000a ffff810037327140 ffff81002c45f890
Jun 21 11:58:01 valisk kernel:  000000000000479a ffff810037327320 0000000037327140 ffffffff80272baa
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80272baa>] find_extend_vma+0x16/0x59
Jun 21 11:58:01 valisk kernel:  [<ffffffff80247724>] get_futex_key+0x82/0x14e
Jun 21 11:58:01 valisk kernel:  [<ffffffff802484cb>] futex_wait+0x214/0x327
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff802489e0>] do_futex+0x74/0xab1
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228991>] __wake_up+0x38/0x4f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029bf3f>] mntput_no_expire+0x1c/0x94
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d7f>] bit_waitqueue+0x1c/0x90
Jun 21 11:58:01 valisk kernel:  [<ffffffff802494ff>] sys_futex+0xe2/0x100
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: portmap       S 7fffffffffffffff     0  3086      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810036f07b28 0000000000000086 0000000000000212 ffffffff80339278
Jun 21 11:58:01 valisk kernel:  ffff810036f07c78 0000000000000001 ffff810036ef8810 ffff8100010ca750
Jun 21 11:58:01 valisk kernel:  000000000000e946 ffff810036ef89f0 0000000036f07b20 ffff810036f07c78
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80339278>] __add_entropy_words+0x60/0x196
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e73fb>] schedule_timeout+0x1e/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff80243048>] add_wait_queue+0x15/0x45
Jun 21 11:58:01 valisk kernel:  [<ffffffff803b1430>] tcp_poll+0x1c/0x12f
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293c18>] do_sys_poll+0x276/0x35e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f3d43>] __up_write+0x21/0x10e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80262d6c>] find_get_page+0x21/0x50
Jun 21 11:58:01 valisk kernel:  [<ffffffff80264e84>] filemap_nopage+0x180/0x2b0
Jun 21 11:58:01 valisk kernel:  [<ffffffff8026f6af>] __handle_mm_fault+0x402/0xa47
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f3cab>] __up_read+0x13/0x8a
Jun 21 11:58:01 valisk kernel:  [<ffffffff803ea59f>] do_page_fault+0x41f/0x76f
Jun 21 11:58:01 valisk kernel:  [<ffffffff802dd502>] keyring_alloc+0x46/0x5e
Jun 21 11:58:01 valisk kernel:  [<ffffffff802ded03>] alloc_uid_keyring+0x78/0xa6
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023b271>] recalc_sigpending_and_wake+0x9/0x1a
Jun 21 11:58:01 valisk kernel:  [<ffffffff8025cf9b>] audit_syscall_entry+0x141/0x174
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293d32>] sys_poll+0x32/0x3b
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: sshd          S 7fffffffffffffff     0  3140      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff8100366eba18 0000000000000086 0000000000000296 ffffffff80242e1b
Jun 21 11:58:01 valisk kernel:  ffff81003a00c0c8 0000000000000006 ffff810036b6d040 ffff810036b6d750
Jun 21 11:58:01 valisk kernel:  00000000000478ea ffff810036b6d220 00000000366ebc58 ffff8100366ebbd8
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e1b>] __wake_up_bit+0x28/0x2d
Jun 21 11:58:01 valisk kernel:  [<ffffffff88098fa8>] :reiserfs:search_by_key+0x224/0x1613
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e73fb>] schedule_timeout+0x1e/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff80243048>] add_wait_queue+0x15/0x45
Jun 21 11:58:01 valisk kernel:  [<ffffffff803b1430>] tcp_poll+0x1c/0x12f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029413e>] do_select+0x403/0x466
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8028a865>] inode_get_bytes+0x10/0x31
Jun 21 11:58:01 valisk kernel:  [<ffffffff880841e9>] :reiserfs:inode2sd+0xf2/0x103
Jun 21 11:58:01 valisk kernel:  [<ffffffff88098ccd>] :reiserfs:pathrelse+0x6e/0x86
Jun 21 11:58:01 valisk kernel:  [<ffffffff88084a13>] :reiserfs:reiserfs_update_sd_size+0x27e/0x290
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80267270>] get_page_from_freelist+0x369/0x4e4
Jun 21 11:58:01 valisk kernel:  [<ffffffff880a12ba>] :reiserfs:do_journal_end+0xbfc/0xc2c
Jun 21 11:58:01 valisk kernel:  [<ffffffff8026996e>] activate_page+0xad/0xd4
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029435d>] core_sys_select+0x1bc/0x265
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f3cab>] __up_read+0x13/0x8a
Jun 21 11:58:01 valisk kernel:  [<ffffffff803ea59f>] do_page_fault+0x41f/0x76f
Jun 21 11:58:01 valisk kernel:  [<ffffffff802181df>] flush_tlb_mm+0x8f/0xb0
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029482f>] sys_select+0xc1/0x183
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: powersaved    S 7fffffffffffffff     0  3172      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810035cc7b28 0000000000000082 0000000000000000 ffffffff80228a22
Jun 21 11:58:01 valisk kernel:  0000000000000001 000000000000000a ffff810036979140 ffff8100378f6810
Jun 21 11:58:01 valisk kernel:  0000000000007690 ffff810036979320 0000000000000001 0000007bd5e8f170
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228a22>] task_rq_lock+0x3d/0x6f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b241>] try_to_wake_up+0x3f8/0x409
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e73fb>] schedule_timeout+0x1e/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff80243048>] add_wait_queue+0x15/0x45
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293c18>] do_sys_poll+0x276/0x35e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8037dee8>] sock_aio_write+0x110/0x128
Jun 21 11:58:01 valisk kernel:  [<ffffffff8037e00c>] sock_aio_read+0x10c/0x124
Jun 21 11:58:01 valisk kernel:  [<ffffffff80287b1c>] do_sync_read+0xc9/0x10c
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8028807d>] do_readv_writev+0x199/0x1ae
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e6acc>] thread_return+0x0/0xf6
Jun 21 11:58:01 valisk kernel:  [<ffffffff8025cf9b>] audit_syscall_entry+0x141/0x174
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293d32>] sys_poll+0x32/0x3b
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: dhclient      S 0000002ee1164524     0  3180   3006 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810035459a18 0000000000000086 0000000000000000 ffffffff80242e31
Jun 21 11:58:01 valisk kernel:  ffff8100372bfc28 000000000000000a ffff81003880b180 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  0000000000002819 ffff81003880b360 0000000035459c58 ffff810035459a28
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e31>] wake_up_bit+0x11/0x22
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7467>] schedule_timeout+0x8a/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023924e>] process_timeout+0x0/0x5
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029413e>] do_select+0x403/0x466
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff880841e9>] :reiserfs:inode2sd+0xf2/0x103
Jun 21 11:58:01 valisk kernel:  [<ffffffff88098ccd>] :reiserfs:pathrelse+0x6e/0x86
Jun 21 11:58:01 valisk kernel:  [<ffffffff88084a13>] :reiserfs:reiserfs_update_sd_size+0x27e/0x290
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80267270>] get_page_from_freelist+0x369/0x4e4
Jun 21 11:58:01 valisk kernel:  [<ffffffff880a12ba>] :reiserfs:do_journal_end+0xbfc/0xc2c
Jun 21 11:58:01 valisk kernel:  [<ffffffff802180c6>] flush_tlb_page+0x90/0xaf
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029435d>] core_sys_select+0x1bc/0x265
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f3cab>] __up_read+0x13/0x8a
Jun 21 11:58:01 valisk kernel:  [<ffffffff803ea59f>] do_page_fault+0x41f/0x76f
Jun 21 11:58:01 valisk kernel:  [<ffffffff802181df>] flush_tlb_mm+0x8f/0xb0
Jun 21 11:58:01 valisk kernel:  [<ffffffff802948c8>] sys_select+0x15a/0x183
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: smpppd        S 0000008477573db6     0  3187      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810034a8da18 0000000000000082 0000000000000000 ffffffff80267563
Jun 21 11:58:01 valisk kernel:  00000010000280d2 000000000000000a ffff810036b6d750 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  0000000000011b9c ffff810036b6d930 0000000000000000 ffff810034a8da28
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80267563>] __alloc_pages+0x61/0x2c3
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7467>] schedule_timeout+0x8a/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023924e>] process_timeout+0x0/0x5
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029413e>] do_select+0x403/0x466
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff80267563>] __alloc_pages+0x61/0x2c3
Jun 21 11:58:01 valisk kernel:  [<ffffffff8026f81f>] __handle_mm_fault+0x572/0xa47
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f3cab>] __up_read+0x13/0x8a
Jun 21 11:58:01 valisk kernel:  [<ffffffff803ea59f>] do_page_fault+0x41f/0x76f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029435d>] core_sys_select+0x1bc/0x265
Jun 21 11:58:01 valisk kernel:  [<ffffffff802716ce>] free_pgtables+0xae/0xc3
Jun 21 11:58:01 valisk kernel:  [<ffffffff802181df>] flush_tlb_mm+0x8f/0xb0
Jun 21 11:58:01 valisk kernel:  [<ffffffff802948c8>] sys_select+0x15a/0x183
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: kdm           S 7fffffffffffffff     0  3229      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810035581a18 0000000000000082 0000000000000000 ffffffff80242d7f
Jun 21 11:58:01 valisk kernel:  ffff810035581c48 000000000000000a ffff8100376407d0 ffff8100010ad750
Jun 21 11:58:01 valisk kernel:  0000000000005405 ffff8100376409b0 0000000000000000 ffff8100345d1790
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d7f>] bit_waitqueue+0x1c/0x90
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e73fb>] schedule_timeout+0x1e/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff80243048>] add_wait_queue+0x15/0x45
Jun 21 11:58:01 valisk kernel:  [<ffffffff8028cf0d>] pipe_poll+0x2d/0x87
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029413e>] do_select+0x403/0x466
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff80267563>] __alloc_pages+0x61/0x2c3
Jun 21 11:58:01 valisk kernel:  [<ffffffff802357e5>] current_fs_time+0x3b/0x40
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228991>] __wake_up+0x38/0x4f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029a8e6>] touch_atime+0xbe/0x104
Jun 21 11:58:01 valisk kernel:  [<ffffffff8028dfca>] pipe_read+0x386/0x39a
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029435d>] core_sys_select+0x1bc/0x265
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029482f>] sys_select+0xc1/0x183
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: master        S 000000010002685b     0  3332      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810034161e98 0000000000000082 0000000000000000 ffffffff00000001
Jun 21 11:58:01 valisk kernel:  ffff810037500080 000000000000000a ffff81003697c180 ffff8100341d9140
Jun 21 11:58:01 valisk kernel:  0000000000004baa ffff81003697c360 0000000034161e68 ffff810034161ea8
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80239487>] __mod_timer+0xb6/0xc5
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7467>] schedule_timeout+0x8a/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023924e>] process_timeout+0x0/0x5
Jun 21 11:58:01 valisk kernel:  [<ffffffff802ae87d>] sys_epoll_wait+0x182/0x420
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: pickup        S 00000081dd342684     0  3360   3332 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff81003419de98 0000000000000086 0000000000000000 ffffffff00000001
Jun 21 11:58:01 valisk kernel:  ffff8100345cd880 000000000000000a ffff8100341d9140 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  00000000000003cf ffff8100341d9320 000000003419de68 ffff81003419dea8
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7467>] schedule_timeout+0x8a/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023924e>] process_timeout+0x0/0x5
Jun 21 11:58:01 valisk kernel:  [<ffffffff802ae87d>] sys_epoll_wait+0x182/0x420
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: qmgr          S 000000010002dd8b     0  3361   3332 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff8100341f5e98 0000000000000082 ffff81003a4de120 0000000300000002
Jun 21 11:58:01 valisk kernel:  ffff81003a4dec88 000000000000000a ffff81003912f810 ffff8100341d9140
Jun 21 11:58:01 valisk kernel:  0000000000000411 ffff81003912f9f0 0000000000000001 ffff8100341f5ea8
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80239487>] __mod_timer+0xb6/0xc5
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7467>] schedule_timeout+0x8a/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023924e>] process_timeout+0x0/0x5
Jun 21 11:58:01 valisk kernel:  [<ffffffff802ae87d>] sys_epoll_wait+0x182/0x420
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: cron          S 0000008482614451     0  3362      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810034243eb8 0000000000000086 0000000000000000 000000000006dcf4
Jun 21 11:58:01 valisk kernel:  ffff810034243e58 0000000000000007 ffff81003b941850 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  0000000000005ac2 ffff81003b941a30 0000000000000000 ffffffff80244e12
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80244e12>] enqueue_hrtimer+0x64/0x6b
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e78a8>] do_nanosleep+0x46/0x77
Jun 21 11:58:01 valisk kernel:  [<ffffffff802453c9>] hrtimer_nanosleep+0x58/0x11e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80244fb6>] hrtimer_wakeup+0x0/0x22
Jun 21 11:58:01 valisk kernel:  [<ffffffff802454db>] sys_nanosleep+0x4c/0x62
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: Xorg          S 000000848248b136     0  3382   3229 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff8100342a7a18 0000000000000082 0000000000000000 ffff8100010ad750
Jun 21 11:58:01 valisk kernel:  ffffffff80242e42 000000000000000a ffff8100010ad750 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  0000000000002636 ffff8100010ad930 0000000000000000 ffff8100342a7a28
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7467>] schedule_timeout+0x8a/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023924e>] process_timeout+0x0/0x5
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029413e>] do_select+0x403/0x466
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff803839be>] skb_dequeue+0x48/0x50
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e1ed0>] unix_stream_recvmsg+0x439/0x56c
Jun 21 11:58:01 valisk kernel:  [<ffffffff8037dee8>] sock_aio_write+0x110/0x128
Jun 21 11:58:01 valisk kernel:  [<ffffffff80244e12>] enqueue_hrtimer+0x64/0x6b
Jun 21 11:58:01 valisk kernel:  [<ffffffff8024535f>] hrtimer_start+0xf2/0x104
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029435d>] core_sys_select+0x1bc/0x265
Jun 21 11:58:01 valisk kernel:  [<ffffffff80239afb>] recalc_sigpending+0xe/0x25
Jun 21 11:58:01 valisk kernel:  [<ffffffff802096aa>] do_notify_resume+0x647/0x719
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020f5b9>] init_fpu+0x6b/0x87
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020b53e>] math_state_restore+0x1a/0x49
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e8b1d>] error_exit+0x0/0x84
Jun 21 11:58:01 valisk kernel:  [<ffffffff802948c8>] sys_select+0x15a/0x183
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: kdm           S 00000035e3aa63a8     0  3383   3229 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810033c7dce8 0000000000000086 0000000000000000 ffffffff8022b241
Jun 21 11:58:01 valisk kernel:  ffff81000000d468 0000000000000006 ffff8100345d1790 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  0000000000000c64 ffff8100345d1970 0000000033353334 ffff81002dbc3778
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b241>] try_to_wake_up+0x3f8/0x409
Jun 21 11:58:01 valisk kernel:  [<ffffffff8028d745>] pipe_wait+0x66/0x8d
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e76c2>] mutex_lock+0xd/0x1e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8028df5c>] pipe_read+0x318/0x39a
Jun 21 11:58:01 valisk kernel:  [<ffffffff80287b1c>] do_sync_read+0xc9/0x10c
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e6acc>] thread_return+0x0/0xf6
Jun 21 11:58:01 valisk kernel:  [<ffffffff80288335>] vfs_read+0xcb/0x153
Jun 21 11:58:01 valisk kernel:  [<ffffffff802886d1>] sys_read+0x45/0x6e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: login         S 0000000000000000     0  3385      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810033cfdec8 0000000000000082 0000000000611110 ffffffff802f3cab
Jun 21 11:58:01 valisk kernel:  ffff81000109c480 0000000000000007 ffff810037327850 ffff81003d7fb040
Jun 21 11:58:01 valisk kernel:  0000000000007fe5 ffff810037327a30 0000000037dfc000 ffff810037dfc000
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f3cab>] __up_read+0x13/0x8a
Jun 21 11:58:01 valisk kernel:  [<ffffffff80297f7b>] dput+0x26/0x115
Jun 21 11:58:01 valisk kernel:  [<ffffffff80233cda>] do_wait+0x992/0xa97
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: login         S 0000000000000000     0  3386      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810033cffec8 0000000000000086 0000000000611110 ffffffff802f3cab
Jun 21 11:58:01 valisk kernel:  ffff81000109cd00 0000000000000006 ffff810037269810 ffff8100376400c0
Jun 21 11:58:01 valisk kernel:  0000000000007786 ffff8100372699f0 000000003db64000 ffff81003db64000
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f3cab>] __up_read+0x13/0x8a
Jun 21 11:58:01 valisk kernel:  [<ffffffff80297f7b>] dput+0x26/0x115
Jun 21 11:58:01 valisk kernel:  [<ffffffff80233cda>] do_wait+0x992/0xa97
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: login         S 0000000000000000     0  3388      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff81003a53dec8 0000000000000082 0000000000611110 ffffffff802f3cab
Jun 21 11:58:01 valisk kernel:  ffff81000109cc00 0000000000000006 ffff81003b4b5750 ffff81002a5c0750
Jun 21 11:58:01 valisk kernel:  0000000000007ae4 ffff81003b4b5930 000000003d0e2000 ffff81003d0e2000
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f3cab>] __up_read+0x13/0x8a
Jun 21 11:58:01 valisk kernel:  [<ffffffff80297f7b>] dput+0x26/0x115
Jun 21 11:58:01 valisk kernel:  [<ffffffff80233cda>] do_wait+0x992/0xa97
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: mingetty      S 7fffffffffffffff     0  3390      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810033d3fdc8 0000000000000082 ffff81003d2f5800 0000000000000020
Jun 21 11:58:01 valisk kernel:  0000000000000020 0000000000000004 ffff810039fe1040 ffff8100376400c0
Jun 21 11:58:01 valisk kernel:  000000000005a6f3 ffff810039fe1220 0000000033e51400 ffff810033f83800
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e73fb>] schedule_timeout+0x1e/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff8026ea9e>] unmap_vmas+0x438/0x746
Jun 21 11:58:01 valisk kernel:  [<ffffffff80243048>] add_wait_queue+0x15/0x45
Jun 21 11:58:01 valisk kernel:  [<ffffffff80340230>] read_chan+0x396/0x61e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8033d24f>] tty_read+0x72/0xc7
Jun 21 11:58:01 valisk kernel:  [<ffffffff80288335>] vfs_read+0xcb/0x153
Jun 21 11:58:01 valisk kernel:  [<ffffffff802886d1>] sys_read+0x45/0x6e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: mingetty      S 7fffffffffffffff     0  3391      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810033e17dc8 0000000000000082 ffff81003dfe1a00 0000000000000020
Jun 21 11:58:01 valisk kernel:  0000000000000020 0000000000000004 ffff810036ef8100 ffff8100010ad040
Jun 21 11:58:01 valisk kernel:  000000000005d981 ffff810036ef82e0 0000000038e08c00 ffff81003747d000
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e73fb>] schedule_timeout+0x1e/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff8026ea9e>] unmap_vmas+0x438/0x746
Jun 21 11:58:01 valisk kernel:  [<ffffffff80243048>] add_wait_queue+0x15/0x45
Jun 21 11:58:01 valisk kernel:  [<ffffffff80340230>] read_chan+0x396/0x61e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8033d24f>] tty_read+0x72/0xc7
Jun 21 11:58:01 valisk kernel:  [<ffffffff80288335>] vfs_read+0xcb/0x153
Jun 21 11:58:01 valisk kernel:  [<ffffffff802886d1>] sys_read+0x45/0x6e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: mingetty      S 7fffffffffffffff     0  3394      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff810033d99dc8 0000000000000082 ffff810037e74600 0000000000000020
Jun 21 11:58:01 valisk kernel:  0000000000000020 0000000000000003 ffff8100341d9850 ffff81003afd1890
Jun 21 11:58:01 valisk kernel:  000000000006c77c ffff8100341d9a30 0000000038e08000 ffff810035fe5000
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e73fb>] schedule_timeout+0x1e/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff8026ea9e>] unmap_vmas+0x438/0x746
Jun 21 11:58:01 valisk kernel:  [<ffffffff80243048>] add_wait_queue+0x15/0x45
Jun 21 11:58:01 valisk kernel:  [<ffffffff80340230>] read_chan+0x396/0x61e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8033d24f>] tty_read+0x72/0xc7
Jun 21 11:58:01 valisk kernel:  [<ffffffff80288335>] vfs_read+0xcb/0x153
Jun 21 11:58:01 valisk kernel:  [<ffffffff802886d1>] sys_read+0x45/0x6e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: cupsd         S 0000002ee5d88dae     0  3438      1 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff8100338bfa18 0000000000000086 0000000000000000 ffffffff80242e31
Jun 21 11:58:01 valisk kernel:  ffff81003a00c130 000000000000000a ffff810036979850 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  00000000000040c2 ffff810036979a30 00000000338bfc58 ffff8100338bfa28
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e31>] wake_up_bit+0x11/0x22
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e73fb>] schedule_timeout+0x1e/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff80243048>] add_wait_queue+0x15/0x45
Jun 21 11:58:01 valisk kernel:  [<ffffffff8028cf0d>] pipe_poll+0x2d/0x87
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029413e>] do_select+0x403/0x466
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff880a12ba>] :reiserfs:do_journal_end+0xbfc/0xc2c
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029435d>] core_sys_select+0x1bc/0x265
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f3cab>] __up_read+0x13/0x8a
Jun 21 11:58:01 valisk kernel:  [<ffffffff803ea59f>] do_page_fault+0x41f/0x76f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023ae63>] group_send_sig_info+0x62/0x6f
Jun 21 11:58:01 valisk kernel:  [<ffffffff803eb4c3>] kprobe_flush_task+0x5d/0x9f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029482f>] sys_select+0xc1/0x183
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: kdm_greet     S 00000084819fddc9     0  3475   3383 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff8100331eda18 0000000000000082 0000000000000000 0000000000000286
Jun 21 11:58:01 valisk kernel:  0000000000000044 000000000000000a ffff81003697c890 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  0000000000000691 ffff81003697ca70 0000000000000000 ffff8100331eda28
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e065c>] unix_poll+0x0/0x96
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7467>] schedule_timeout+0x8a/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023924e>] process_timeout+0x0/0x5
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029413e>] do_select+0x403/0x466
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8038227f>] sock_def_readable+0x34/0x5f
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e2a27>] unix_stream_sendmsg+0x27e/0x34a
Jun 21 11:58:01 valisk kernel:  [<ffffffff803839be>] skb_dequeue+0x48/0x50
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e1ed0>] unix_stream_recvmsg+0x439/0x56c
Jun 21 11:58:01 valisk kernel:  [<ffffffff8037dee8>] sock_aio_write+0x110/0x128
Jun 21 11:58:01 valisk kernel:  [<ffffffff802357e5>] current_fs_time+0x3b/0x40
Jun 21 11:58:01 valisk kernel:  [<ffffffff8037e00c>] sock_aio_read+0x10c/0x124
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029435d>] core_sys_select+0x1bc/0x265
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e42>] autoremove_wake_function+0x0/0x2e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8028807d>] do_readv_writev+0x199/0x1ae
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e76c2>] mutex_lock+0xd/0x1e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8028d1ed>] pipe_ioctl+0x62/0x67
Jun 21 11:58:01 valisk kernel:  [<ffffffff802948c8>] sys_select+0x15a/0x183
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: bash          S 000000000000000a     0  3507   3385 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff81002da39ec8 0000000000000086 0000000000000202 ffffffff802f3cab
Jun 21 11:58:01 valisk kernel:  ffff81002da35298 0000000000000008 ffff81003def1890 ffff8100372587d0
Jun 21 11:58:01 valisk kernel:  000000000001ff33 ffff81003def1a70 0000000000000000 0000000000000007
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f3cab>] __up_read+0x13/0x8a
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228991>] __wake_up+0x38/0x4f
Jun 21 11:58:01 valisk kernel:  [<ffffffff80233cda>] do_wait+0x992/0xa97
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: scsi_eh_2     S ffff81003726d800     0  3557      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff81002d3c9e80 0000000000000046 0000000000000046 ffffffff804a4460
Jun 21 11:58:01 valisk kernel:  ffffffff804a446c 0000000000000008 ffff8100345d1080 ffff8100372587d0
Jun 21 11:58:01 valisk kernel:  0000000000000281 ffff8100345d1260 0000000000000086 ffffffff8022b241
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b241>] try_to_wake_up+0x3f8/0x409
Jun 21 11:58:01 valisk kernel:  [<ffffffff8801e1e5>] :scsi_mod:scsi_error_handler+0x69/0x4c7
Jun 21 11:58:01 valisk kernel:  [<ffffffff8801e17c>] :scsi_mod:scsi_error_handler+0x0/0x4c7
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: usb-storage   S ffff81003726de68     0  3558      2 (L-TLB)
Jun 21 11:58:01 valisk kernel:  ffff81002d3bfe20 0000000000000046 ffff81003726dd30 ffff81003726dd30
Jun 21 11:58:01 valisk kernel:  0000000000000000 000000000000000a ffff81002d4a7750 ffff810037974080
Jun 21 11:58:01 valisk kernel:  00000000000005c4 ffff81002d4a7930 000000002d3bfdc0 ffff81002d3bfdc0
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff884c5e83>] :usb_storage:usb_stor_bulk_transfer_buf+0x51/0x86
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e845f>] __down_interruptible+0xcb/0x137
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e8261>] __down_failed_interruptible+0x35/0x3a
Jun 21 11:58:01 valisk kernel:  [<ffffffff884c7272>] :usb_storage:usb_stor_control_thread+0x41/0x1dc
Jun 21 11:58:01 valisk kernel:  [<ffffffff884c7231>] :usb_storage:usb_stor_control_thread+0x0/0x1dc
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242d24>] kthread+0x47/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a988>] child_rip+0xa/0x12
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242cdd>] kthread+0x0/0x73
Jun 21 11:58:01 valisk kernel:  [<ffffffff8020a97e>] child_rip+0x0/0x12
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: hald-addon-st S 0000000100024a33     0  3577   2905 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff81002d4b7b28 0000000000000086 0000000000000000 00000000ffffffff
Jun 21 11:58:01 valisk kernel:  ffff810039fe1750 0000000000000009 ffff810039fe1750 ffff810037974080
Jun 21 11:58:01 valisk kernel:  00000000000024ec ffff810039fe1930 000000002d4b7b78 ffff81002d4b7b38
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80239487>] __mod_timer+0xb6/0xc5
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7467>] schedule_timeout+0x8a/0xad
Jun 21 11:58:01 valisk kernel:  [<ffffffff8023924e>] process_timeout+0x0/0x5
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293c18>] do_sys_poll+0x276/0x35e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8029468d>] __pollwait+0x0/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff802e635a>] __freed_request+0x2f/0x85
Jun 21 11:58:01 valisk kernel:  [<ffffffff802e63d4>] freed_request+0x24/0x44
Jun 21 11:58:01 valisk kernel:  [<ffffffff802e670a>] blk_put_request+0x2a/0x42
Jun 21 11:58:01 valisk kernel:  [<ffffffff880200c1>] :scsi_mod:scsi_execute_req+0x82/0xde
Jun 21 11:58:01 valisk kernel:  [<ffffffff88020156>] :scsi_mod:scsi_test_unit_ready+0x39/0x75
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f180f>] kobject_get+0x12/0x17
Jun 21 11:58:01 valisk kernel:  [<ffffffff8811be52>] :sd_mod:sd_media_changed+0xa9/0x100
Jun 21 11:58:01 valisk kernel:  [<ffffffff802a9d83>] check_disk_change+0x1f/0x76
Jun 21 11:58:01 valisk kernel:  [<ffffffff8811bb05>] :sd_mod:sd_open+0xf0/0x183
Jun 21 11:58:01 valisk kernel:  [<ffffffff802aa5ff>] do_open+0x222/0x2b9
Jun 21 11:58:01 valisk kernel:  [<ffffffff802aa858>] blkdev_open+0x0/0x5d
Jun 21 11:58:01 valisk kernel:  [<ffffffff802aa886>] blkdev_open+0x2e/0x5d
Jun 21 11:58:01 valisk kernel:  [<ffffffff8801a0c3>] :scsi_mod:scsi_device_put+0x2f/0x3e
Jun 21 11:58:01 valisk kernel:  [<ffffffff8811acb5>] :sd_mod:scsi_disk_put+0x2e/0x3f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8811bc5a>] :sd_mod:sd_release+0xc2/0xcc
Jun 21 11:58:01 valisk kernel:  [<ffffffff80299510>] iput+0x42/0x7b
Jun 21 11:58:01 valisk kernel:  [<ffffffff8025cf9b>] audit_syscall_entry+0x141/0x174
Jun 21 11:58:01 valisk kernel:  [<ffffffff80293d32>] sys_poll+0x32/0x3b
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: bash          S 000000000000000a     0  3627   3386 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff81002b57bec8 0000000000000086 0000000000000206 ffffffff802f3cab
Jun 21 11:58:01 valisk kernel:  ffff8100297f1ef8 0000000000000009 ffff8100376400c0 ffff81002ac00100
Jun 21 11:58:01 valisk kernel:  000000000001778d ffff8100376402a0 0000000000000000 0000000000000007
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f3cab>] __up_read+0x13/0x8a
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228991>] __wake_up+0x38/0x4f
Jun 21 11:58:01 valisk kernel:  [<ffffffff80233cda>] do_wait+0x992/0xa97
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: bash-shared-m D ffff810037d9da54     0  3737   3507 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff81002b319b18 0000000000000086 ffff81003edb9800 ffffffff803120d5
Jun 21 11:58:01 valisk kernel:  000000000000ad55 0000000000000001 ffff8100372587d0 ffff8100298cc0c0
Jun 21 11:58:01 valisk kernel:  00000000000721cc ffff8100372589b0 0000000037993ba8 000000013ed7dd40
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803120d5>] bit_putcs+0x450/0x4a9
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7827>] __mutex_lock_slowpath+0x5d/0x98
Jun 21 11:58:01 valisk kernel:  [<ffffffff803125dd>] bit_cursor+0x4af/0x4ce
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e76cf>] mutex_lock+0x1a/0x1e
Jun 21 11:58:01 valisk kernel:  [<ffffffff880885ab>] :reiserfs:reiserfs_file_write+0x112/0x186c
Jun 21 11:58:01 valisk kernel:  [<ffffffff8030d287>] fbcon_putcs+0x213/0x263
Jun 21 11:58:01 valisk kernel:  [<ffffffff8030ebe7>] fbcon_redraw+0x130/0x169
Jun 21 11:58:01 valisk kernel:  [<ffffffff8031061c>] fbcon_scroll+0x5bd/0xae8
Jun 21 11:58:01 valisk kernel:  [<ffffffff8031283a>] soft_cursor+0x192/0x1a4
Jun 21 11:58:01 valisk kernel:  [<ffffffff803125dd>] bit_cursor+0x4af/0x4ce
Jun 21 11:58:01 valisk kernel:  [<ffffffff8030d978>] fbcon_cursor+0x23c/0x264
Jun 21 11:58:01 valisk kernel:  [<ffffffff8031212e>] bit_cursor+0x0/0x4ce
Jun 21 11:58:01 valisk kernel:  [<ffffffff802313be>] release_console_sem+0x1b8/0x1d1
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228991>] __wake_up+0x38/0x4f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8033a96f>] tty_ldisc_deref+0x62/0x75
Jun 21 11:58:01 valisk kernel:  [<ffffffff802881e1>] vfs_write+0xce/0x157
Jun 21 11:58:01 valisk kernel:  [<ffffffff80288828>] sys_pwrite64+0x50/0x70
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209c81>] tracesys+0x71/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: bash-shared-m D ffff810037d9da54     0  3738   3737 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff81002abd9b18 0000000000000082 ffff81003edb9800 ffffffff803120d5
Jun 21 11:58:01 valisk kernel:  000000000000ad55 0000000000000006 ffff8100373670c0 ffff8100010a9180
Jun 21 11:58:01 valisk kernel:  00000000000ec8fb ffff8100373672a0 0000000037993c70 000000013ed7cdc0
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803120d5>] bit_putcs+0x450/0x4a9
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7827>] __mutex_lock_slowpath+0x5d/0x98
Jun 21 11:58:01 valisk kernel:  [<ffffffff803125dd>] bit_cursor+0x4af/0x4ce
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e76cf>] mutex_lock+0x1a/0x1e
Jun 21 11:58:01 valisk kernel:  [<ffffffff880885ab>] :reiserfs:reiserfs_file_write+0x112/0x186c
Jun 21 11:58:01 valisk kernel:  [<ffffffff8030d287>] fbcon_putcs+0x213/0x263
Jun 21 11:58:01 valisk kernel:  [<ffffffff8030ebe7>] fbcon_redraw+0x130/0x169
Jun 21 11:58:01 valisk kernel:  [<ffffffff8031061c>] fbcon_scroll+0x5bd/0xae8
Jun 21 11:58:01 valisk kernel:  [<ffffffff8031283a>] soft_cursor+0x192/0x1a4
Jun 21 11:58:01 valisk kernel:  [<ffffffff803125dd>] bit_cursor+0x4af/0x4ce
Jun 21 11:58:01 valisk kernel:  [<ffffffff8030d978>] fbcon_cursor+0x23c/0x264
Jun 21 11:58:01 valisk kernel:  [<ffffffff8031212e>] bit_cursor+0x0/0x4ce
Jun 21 11:58:01 valisk kernel:  [<ffffffff802313be>] release_console_sem+0x1b8/0x1d1
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228991>] __wake_up+0x38/0x4f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8033a96f>] tty_ldisc_deref+0x62/0x75
Jun 21 11:58:01 valisk kernel:  [<ffffffff802881e1>] vfs_write+0xce/0x157
Jun 21 11:58:01 valisk kernel:  [<ffffffff80288828>] sys_pwrite64+0x50/0x70
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209c81>] tracesys+0x71/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: bash-shared-m D ffff810037d9da54     0  3739   3737 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff81002abdbb18 0000000000000082 ffff81003edb9800 ffffffff803120d5
Jun 21 11:58:01 valisk kernel:  000000000000ad55 0000000000000005 ffff81002d4a7040 ffff8100010a9180
Jun 21 11:58:01 valisk kernel:  0000000000076180 ffff81002d4a7220 0000000037993c70 000000013ed7cfe0
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803120d5>] bit_putcs+0x450/0x4a9
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7827>] __mutex_lock_slowpath+0x5d/0x98
Jun 21 11:58:01 valisk kernel:  [<ffffffff803125dd>] bit_cursor+0x4af/0x4ce
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e76cf>] mutex_lock+0x1a/0x1e
Jun 21 11:58:01 valisk kernel:  [<ffffffff880885ab>] :reiserfs:reiserfs_file_write+0x112/0x186c
Jun 21 11:58:01 valisk kernel:  [<ffffffff8030d287>] fbcon_putcs+0x213/0x263
Jun 21 11:58:01 valisk kernel:  [<ffffffff8030ebe7>] fbcon_redraw+0x130/0x169
Jun 21 11:58:01 valisk kernel:  [<ffffffff8031061c>] fbcon_scroll+0x5bd/0xae8
Jun 21 11:58:01 valisk kernel:  [<ffffffff8031283a>] soft_cursor+0x192/0x1a4
Jun 21 11:58:01 valisk kernel:  [<ffffffff803125dd>] bit_cursor+0x4af/0x4ce
Jun 21 11:58:01 valisk kernel:  [<ffffffff8030d978>] fbcon_cursor+0x23c/0x264
Jun 21 11:58:01 valisk kernel:  [<ffffffff8031212e>] bit_cursor+0x0/0x4ce
Jun 21 11:58:01 valisk kernel:  [<ffffffff802313be>] release_console_sem+0x1b8/0x1d1
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228991>] __wake_up+0x38/0x4f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8033a96f>] tty_ldisc_deref+0x62/0x75
Jun 21 11:58:01 valisk kernel:  [<ffffffff802881e1>] vfs_write+0xce/0x157
Jun 21 11:58:01 valisk kernel:  [<ffffffff80288828>] sys_pwrite64+0x50/0x70
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209c81>] tracesys+0x71/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: bash-shared-m D ffff81000100d880     0  3740   3737 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff81002abfb7d8 0000000000000082 ffff81002ad97eb8 0000000000002013
Jun 21 11:58:01 valisk kernel:  ffff81002a316c28 0000000000000004 ffff8100010a9180 ffff81002a0d4790
Jun 21 11:58:01 valisk kernel:  0000000000b99630 ffff8100010a9360 000000002abfb780 ffff81002abfb800
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff802463a6>] getnstimeofday+0x32/0x8c
Jun 21 11:58:01 valisk kernel:  [<ffffffff80262e0c>] sync_page+0x0/0x42
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e73a6>] io_schedule+0x3e/0x66
Jun 21 11:58:01 valisk kernel:  [<ffffffff80262e4a>] sync_page+0x3e/0x42
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e74ea>] __wait_on_bit_lock+0x36/0x66
Jun 21 11:58:01 valisk kernel:  [<ffffffff80262df9>] __lock_page+0x5e/0x64
Jun 21 11:58:01 valisk kernel:  [<ffffffff80242e70>] wake_bit_function+0x0/0x23
Jun 21 11:58:01 valisk kernel:  [<ffffffff80264f18>] filemap_nopage+0x214/0x2b0
Jun 21 11:58:01 valisk kernel:  [<ffffffff8026f4a8>] __handle_mm_fault+0x1fb/0xa47
Jun 21 11:58:01 valisk kernel:  [<ffffffff803ea56c>] do_page_fault+0x3ec/0x76f
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e8b1d>] error_exit+0x0/0x84
Jun 21 11:58:01 valisk kernel:  [<ffffffff880877d5>] :reiserfs:reiserfs_copy_from_user_to_file_region+0x7e/0xf8
Jun 21 11:58:01 valisk kernel:  [<ffffffff88087819>] :reiserfs:reiserfs_copy_from_user_to_file_region+0xc2/0xf8
Jun 21 11:58:01 valisk kernel:  [<ffffffff88089b11>] :reiserfs:reiserfs_file_write+0x1678/0x186c
Jun 21 11:58:01 valisk kernel:  [<ffffffff8030d287>] fbcon_putcs+0x213/0x263
Jun 21 11:58:01 valisk kernel:  [<ffffffff8031283a>] soft_cursor+0x192/0x1a4
Jun 21 11:58:01 valisk kernel:  [<ffffffff803125dd>] bit_cursor+0x4af/0x4ce
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b20f>] try_to_wake_up+0x3c6/0x409
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b201>] try_to_wake_up+0x3b8/0x409
Jun 21 11:58:01 valisk kernel:  [<ffffffff802357e5>] current_fs_time+0x3b/0x40
Jun 21 11:58:01 valisk kernel:  [<ffffffff802881e1>] vfs_write+0xce/0x157
Jun 21 11:58:01 valisk kernel:  [<ffffffff80288828>] sys_pwrite64+0x50/0x70
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209c81>] tracesys+0x71/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: bash-shared-m D ffff810037d9da54     0  3741   3737 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff81002abfdb18 0000000000000082 ffff81003edb9800 ffffffff803120d5
Jun 21 11:58:01 valisk kernel:  000000000000ad55 0000000000000003 ffff8100378c2890 ffff81002a0d4790
Jun 21 11:58:01 valisk kernel:  0000000000027036 ffff8100378c2a70 0000000037993c70 000000013ed7d9d0
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803120d5>] bit_putcs+0x450/0x4a9
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7827>] __mutex_lock_slowpath+0x5d/0x98
Jun 21 11:58:01 valisk kernel:  [<ffffffff803125dd>] bit_cursor+0x4af/0x4ce
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e76cf>] mutex_lock+0x1a/0x1e
Jun 21 11:58:01 valisk kernel:  [<ffffffff880885ab>] :reiserfs:reiserfs_file_write+0x112/0x186c
Jun 21 11:58:01 valisk kernel:  [<ffffffff8030d287>] fbcon_putcs+0x213/0x263
Jun 21 11:58:01 valisk kernel:  [<ffffffff8030ebe7>] fbcon_redraw+0x130/0x169
Jun 21 11:58:01 valisk kernel:  [<ffffffff8031061c>] fbcon_scroll+0x5bd/0xae8
Jun 21 11:58:01 valisk kernel:  [<ffffffff8031283a>] soft_cursor+0x192/0x1a4
Jun 21 11:58:01 valisk kernel:  [<ffffffff803125dd>] bit_cursor+0x4af/0x4ce
Jun 21 11:58:01 valisk kernel:  [<ffffffff8030d978>] fbcon_cursor+0x23c/0x264
Jun 21 11:58:01 valisk kernel:  [<ffffffff8031212e>] bit_cursor+0x0/0x4ce
Jun 21 11:58:01 valisk kernel:  [<ffffffff802313be>] release_console_sem+0x1b8/0x1d1
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228991>] __wake_up+0x38/0x4f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8033a96f>] tty_ldisc_deref+0x62/0x75
Jun 21 11:58:01 valisk kernel:  [<ffffffff802881e1>] vfs_write+0xce/0x157
Jun 21 11:58:01 valisk kernel:  [<ffffffff80288828>] sys_pwrite64+0x50/0x70
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209c81>] tracesys+0x71/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: bash-shared-m D ffff810037d9da54     0  3742   3737 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff81002a0dfb18 0000000000000086 ffff81003edb9800 ffffffff803120d5
Jun 21 11:58:01 valisk kernel:  000000000000ad55 0000000000000002 ffff81002a0d4790 ffff81002a0d4080
Jun 21 11:58:01 valisk kernel:  000000000006c2a6 ffff81002a0d4970 0000000037993c72 000000013ed7c810
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803120d5>] bit_putcs+0x450/0x4a9
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7827>] __mutex_lock_slowpath+0x5d/0x98
Jun 21 11:58:01 valisk kernel:  [<ffffffff803125dd>] bit_cursor+0x4af/0x4ce
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e76cf>] mutex_lock+0x1a/0x1e
Jun 21 11:58:01 valisk kernel:  [<ffffffff880885ab>] :reiserfs:reiserfs_file_write+0x112/0x186c
Jun 21 11:58:01 valisk kernel:  [<ffffffff8030d287>] fbcon_putcs+0x213/0x263
Jun 21 11:58:01 valisk kernel:  [<ffffffff8030ebe7>] fbcon_redraw+0x130/0x169
Jun 21 11:58:01 valisk kernel:  [<ffffffff8031061c>] fbcon_scroll+0x5bd/0xae8
Jun 21 11:58:01 valisk kernel:  [<ffffffff8031283a>] soft_cursor+0x192/0x1a4
Jun 21 11:58:01 valisk kernel:  [<ffffffff803125dd>] bit_cursor+0x4af/0x4ce
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228a22>] task_rq_lock+0x3d/0x6f
Jun 21 11:58:01 valisk kernel:  [<ffffffff802287a4>] __activate_task+0x26/0x38
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b241>] try_to_wake_up+0x3f8/0x409
Jun 21 11:58:01 valisk kernel:  [<ffffffff802313be>] release_console_sem+0x1b8/0x1d1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8033ef7b>] write_chan+0x2e6/0x305
Jun 21 11:58:01 valisk kernel:  [<ffffffff8033a92b>] tty_ldisc_deref+0x1e/0x75
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e77c1>] __mutex_unlock_slowpath+0x2a/0x33
Jun 21 11:58:01 valisk kernel:  [<ffffffff802881e1>] vfs_write+0xce/0x157
Jun 21 11:58:01 valisk kernel:  [<ffffffff80288828>] sys_pwrite64+0x50/0x70
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209c81>] tracesys+0x71/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: bash-shared-m D ffff810037d9da54     0  3743   3737 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff8100298c1e78 0000000000000086 00002b35d07e5a50 ffff8100341ed7c0
Jun 21 11:58:01 valisk kernel:  0000000000000f28 0000000000000001 ffff81002a0d4080 ffff8100298cc7d0
Jun 21 11:58:01 valisk kernel:  00000000000ddf8d ffff81002a0d4260 0000000000000246 ffff810029b7f348
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff802f3cab>] __up_read+0x13/0x8a
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7827>] __mutex_lock_slowpath+0x5d/0x98
Jun 21 11:58:01 valisk kernel:  [<ffffffff8033a96f>] tty_ldisc_deref+0x62/0x75
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e76cf>] mutex_lock+0x1a/0x1e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80286d42>] do_truncate+0x53/0x79
Jun 21 11:58:01 valisk kernel:  [<ffffffff8025cf9b>] audit_syscall_entry+0x141/0x174
Jun 21 11:58:01 valisk kernel:  [<ffffffff80286e52>] sys_ftruncate+0xea/0x107
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: bash-shared-m D ffff810037d9da54     0  3744   3737 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff8100298e3b18 0000000000000086 ffff81003edb9800 ffffffff803120d5
Jun 21 11:58:01 valisk kernel:  000000000000ad55 0000000000000001 ffff8100298cc7d0 ffff81002ac00810
Jun 21 11:58:01 valisk kernel:  000000000000084b ffff8100298cc9b0 0000000037993a18 000000013ed7de50
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803120d5>] bit_putcs+0x450/0x4a9
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7827>] __mutex_lock_slowpath+0x5d/0x98
Jun 21 11:58:01 valisk kernel:  [<ffffffff803125dd>] bit_cursor+0x4af/0x4ce
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e76cf>] mutex_lock+0x1a/0x1e
Jun 21 11:58:01 valisk kernel:  [<ffffffff880885ab>] :reiserfs:reiserfs_file_write+0x112/0x186c
Jun 21 11:58:01 valisk kernel:  [<ffffffff8030d287>] fbcon_putcs+0x213/0x263
Jun 21 11:58:01 valisk kernel:  [<ffffffff8030ebe7>] fbcon_redraw+0x130/0x169
Jun 21 11:58:01 valisk kernel:  [<ffffffff8031061c>] fbcon_scroll+0x5bd/0xae8
Jun 21 11:58:01 valisk kernel:  [<ffffffff8031283a>] soft_cursor+0x192/0x1a4
Jun 21 11:58:01 valisk kernel:  [<ffffffff803125dd>] bit_cursor+0x4af/0x4ce
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228a22>] task_rq_lock+0x3d/0x6f
Jun 21 11:58:01 valisk kernel:  [<ffffffff802287a4>] __activate_task+0x26/0x38
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b241>] try_to_wake_up+0x3f8/0x409
Jun 21 11:58:01 valisk kernel:  [<ffffffff802313be>] release_console_sem+0x1b8/0x1d1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8033ef7b>] write_chan+0x2e6/0x305
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e6acc>] thread_return+0x0/0xf6
Jun 21 11:58:01 valisk kernel:  [<ffffffff802881e1>] vfs_write+0xce/0x157
Jun 21 11:58:01 valisk kernel:  [<ffffffff80288828>] sys_pwrite64+0x50/0x70
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209c81>] tracesys+0x71/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: bash-shared-m D ffff810037d9da54     0  3745   3737 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff81002ac03b18 0000000000000082 ffff81003edb9800 ffffffff803120d5
Jun 21 11:58:01 valisk kernel:  000000000000ad55 0000000000000001 ffff8100298cc0c0 ffff8100298cc7d0
Jun 21 11:58:01 valisk kernel:  0000000000072002 ffff8100298cc2a0 0000000037993ae0 000000013ed7de50
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803120d5>] bit_putcs+0x450/0x4a9
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7827>] __mutex_lock_slowpath+0x5d/0x98
Jun 21 11:58:01 valisk kernel:  [<ffffffff803125dd>] bit_cursor+0x4af/0x4ce
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e76cf>] mutex_lock+0x1a/0x1e
Jun 21 11:58:01 valisk kernel:  [<ffffffff880885ab>] :reiserfs:reiserfs_file_write+0x112/0x186c
Jun 21 11:58:01 valisk kernel:  [<ffffffff8030d287>] fbcon_putcs+0x213/0x263
Jun 21 11:58:01 valisk kernel:  [<ffffffff8030ebe7>] fbcon_redraw+0x130/0x169
Jun 21 11:58:01 valisk kernel:  [<ffffffff8031061c>] fbcon_scroll+0x5bd/0xae8
Jun 21 11:58:01 valisk kernel:  [<ffffffff8031283a>] soft_cursor+0x192/0x1a4
Jun 21 11:58:01 valisk kernel:  [<ffffffff803125dd>] bit_cursor+0x4af/0x4ce
Jun 21 11:58:01 valisk kernel:  [<ffffffff8030d978>] fbcon_cursor+0x23c/0x264
Jun 21 11:58:01 valisk kernel:  [<ffffffff8031212e>] bit_cursor+0x0/0x4ce
Jun 21 11:58:01 valisk kernel:  [<ffffffff802313be>] release_console_sem+0x1b8/0x1d1
Jun 21 11:58:01 valisk kernel:  [<ffffffff80228991>] __wake_up+0x38/0x4f
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff8033a96f>] tty_ldisc_deref+0x62/0x75
Jun 21 11:58:01 valisk kernel:  [<ffffffff802881e1>] vfs_write+0xce/0x157
Jun 21 11:58:01 valisk kernel:  [<ffffffff80288828>] sys_pwrite64+0x50/0x70
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209c81>] tracesys+0x71/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: bash-shared-m D ffff810037d9da54     0  3746   3737 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff81002ac07b18 0000000000000086 ffff81003edb9800 ffffffff803120d5
Jun 21 11:58:01 valisk kernel:  000000000000ad55 0000000000000001 ffff81002ac00810 ffff810037974080
Jun 21 11:58:01 valisk kernel:  00000000000002ea ffff81002ac009f0 0000000037993c70 ffff8100298cc7d0
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff803120d5>] bit_putcs+0x450/0x4a9
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e7827>] __mutex_lock_slowpath+0x5d/0x98
Jun 21 11:58:01 valisk kernel:  [<ffffffff803125dd>] bit_cursor+0x4af/0x4ce
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e76cf>] mutex_lock+0x1a/0x1e
Jun 21 11:58:01 valisk kernel:  [<ffffffff880885ab>] :reiserfs:reiserfs_file_write+0x112/0x186c
Jun 21 11:58:01 valisk kernel:  [<ffffffff8030d287>] fbcon_putcs+0x213/0x263
Jun 21 11:58:01 valisk kernel:  [<ffffffff8030ebe7>] fbcon_redraw+0x130/0x169
Jun 21 11:58:01 valisk kernel:  [<ffffffff8031061c>] fbcon_scroll+0x5bd/0xae8
Jun 21 11:58:01 valisk kernel:  [<ffffffff8031283a>] soft_cursor+0x192/0x1a4
Jun 21 11:58:01 valisk kernel:  [<ffffffff803125dd>] bit_cursor+0x4af/0x4ce
Jun 21 11:58:01 valisk kernel:  [<ffffffff8030d978>] fbcon_cursor+0x23c/0x264
Jun 21 11:58:01 valisk kernel:  [<ffffffff8031212e>] bit_cursor+0x0/0x4ce
Jun 21 11:58:01 valisk kernel:  [<ffffffff802313be>] release_console_sem+0x1b8/0x1d1
Jun 21 11:58:01 valisk kernel:  [<ffffffff8033ef7b>] write_chan+0x2e6/0x305
Jun 21 11:58:01 valisk kernel:  [<ffffffff8022b252>] default_wake_function+0x0/0xe
Jun 21 11:58:01 valisk kernel:  [<ffffffff802357e5>] current_fs_time+0x3b/0x40
Jun 21 11:58:01 valisk kernel:  [<ffffffff8033a92b>] tty_ldisc_deref+0x1e/0x75
Jun 21 11:58:01 valisk kernel:  [<ffffffff802881e1>] vfs_write+0xce/0x157
Jun 21 11:58:01 valisk kernel:  [<ffffffff80288828>] sys_pwrite64+0x50/0x70
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209c81>] tracesys+0x71/0xe1
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: tail          S 000000847f6d94bc     0  3747   3627 (NOTLB)
Jun 21 11:58:01 valisk kernel:  ffff81002abd7eb8 0000000000000082 0000000000000000 000000000006dcb6
Jun 21 11:58:01 valisk kernel:  ffff81002abd7e58 000000000000000a ffff81002ac00100 ffffffff8049a8c0
Jun 21 11:58:01 valisk kernel:  0000000000001a0c ffff81002ac002e0 0000000000000000 ffffffff80244e12
Jun 21 11:58:01 valisk kernel: Call Trace:
Jun 21 11:58:01 valisk kernel:  [<ffffffff80244e12>] enqueue_hrtimer+0x64/0x6b
Jun 21 11:58:01 valisk kernel:  [<ffffffff803e78a8>] do_nanosleep+0x46/0x77
Jun 21 11:58:01 valisk kernel:  [<ffffffff802453c9>] hrtimer_nanosleep+0x58/0x11e
Jun 21 11:58:01 valisk kernel:  [<ffffffff80244fb6>] hrtimer_wakeup+0x0/0x22
Jun 21 11:58:01 valisk kernel:  [<ffffffff802454db>] sys_nanosleep+0x4c/0x62
Jun 21 11:58:01 valisk kernel:  [<ffffffff80209cec>] tracesys+0xdc/0xe1
Jun 21 11:58:01 valisk kernel: 
Jun 21 11:58:01 valisk kernel: bash          R  running task       0  3748   3388 (NOTLB)
Jun 21 11:59:34 valisk kernel: SoftMAC: Scanning finished: scanned 13 channels starting with channel 1
