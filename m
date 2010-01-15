Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab0AOLbz (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 06:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756884Ab0AOLby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 06:31:54 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:35807 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756802Ab0AOLbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 06:31:52 -0500
Date: Fri, 15 Jan 2010 12:35:24 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: linux kernel conference <linux-kernel@vger.kernel.org>
Cc: nikola.ciprich@linuxbox.cz, "Theodore Ts'o" <tytso@mit.edu>
Subject: 2.6.32.3: kernel BUG at fs/ext4/inode.c
Message-ID: <20100115113524.GA4715@nik-nb2.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Milter-Copy-Status: I
X-Antivirus: on proxybox by Kaspersky antivirus, engine 5.5.10, data 3096780 records(15-01-2010)
X-Envelope-From: nik@linuxbox.cz
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
we've hit the following BUG:

[506168.379535] ------------[ cut here ]------------
[506168.383995] kernel BUG at fs/ext4/inode.c:1852!
[506168.383995] invalid opcode: 0000 [#1] PREEMPT SMP
[506168.383995] last sysfs file: /sys/devices/pci0000:00/0000:00:03.0/0000:0a:00.0/0000:0b:0e.0/host4/target4:0:1/4:0:1:0/type
[506168.383995] CPU 1
[506168.383995] Modules linked in: ext4 jbd2 crc16 sha256_generic krng ansi_cprng eseqiv rng cryptd crypto_wq aes_x86_64 aes_generic cbc cryptomgr crypto_hash aead pcompress dm_crypt crypto_blkciphe
r crypto_algapi nfs ipmi_si ipmi_devintf ipmi_msghandler netconsole nfsd nfs_acl auth_rpcgss exportfs ipv6 autofs4 lockd sunrpc 8021q cpufreq_ondemand acpi_cpufreq freq_table reiserfs crc32 raid456
async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx video backlight output sbs sbshc fan battery ac container piix pata_acpi joydev ide_pci_generic ide_core processor thermal the
rmal_sys usbhid button i2c_i801 i2c_core rng_core shpchp i3000_edac pcspkr ata_piix pci_hotplug ata_generic e1000e edac_core iTCO_wdt sg arcmsr ahci libata sd_mod scsi_mod crc_t10dif raid1 dm_snapsh
ot dm_zero dm_mirror dm_region_hash dm_log dm_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
[506168.383995] Pid: 27713, comm: mc Not tainted 2.6.32lb.04 #1 PDSM4+
[506168.383995] RIP: 0010:[<ffffffffa067e7ec>]  [<ffffffffa067e7ec>] ext4_da_get_block_prep+0x29c/0x2b0 [ext4]
[506168.383995] RSP: 0018:ffff880076a199f8  EFLAGS: 00010202
[506168.383995] RAX: 000000000000005a RBX: ffff88003c922c80 RCX: 0000000000000001
[506168.383995] RDX: 0000000000000059 RSI: 0000000000000059 RDI: 0000000000000154
[506168.383995] RBP: ffff880076a19a58 R08: 0000000000000153 R09: 0000000000000000
[506168.383995] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000001000
[506168.383995] R13: ffff880048595690 R14: ffff88003c922b50 R15: 0000000000001000
[506168.383995] FS:  00007fc458e256e0(0000) GS:ffff880001f00000(0000) knlGS:0000000000000000
[506168.383995] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[506168.383995] CR2: 00007f56785cb000 CR3: 000000006bd69000 CR4: 00000000000006e0
[506168.383995] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[506168.383995] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[506168.383995] Process mc (pid: 27713, threadinfo ffff880076a18000, task ffff8800299e4e40)
[506168.383995] Stack:
[506168.383995]  ffff88003c922c80 ffff88003c923120 0000000076a19a28 ffffffffffff0000
[506168.383995] <0> ffff88006c37b800 ffffea00006f1c48 0000000076a19a58 0000000000001000
[506168.383995] <0> 0000000000001000 0000000000000000 ffff880076a19ad8 0000000000001000
[506168.383995] Call Trace:
[506168.383995]  [<ffffffff8113d0fc>] __block_prepare_write+0x27c/0x440
[506168.383995]  [<ffffffffa067e550>] ? ext4_da_get_block_prep+0x0/0x2b0 [ext4]
[506168.383995]  [<ffffffff810dbd82>] ? __lru_cache_add+0x72/0xb0
[506168.383995]  [<ffffffff8113d359>] block_write_begin+0x59/0xe0
[506168.383995]  [<ffffffffa067d612>] ext4_da_write_begin+0x182/0x280 [ext4]
[506168.383995]  [<ffffffffa067e550>] ? ext4_da_get_block_prep+0x0/0x2b0 [ext4]
[506168.383995]  [<ffffffff810d2b9a>] generic_file_buffered_write+0x10a/0x290
[506168.383995]  [<ffffffff810d30e6>] __generic_file_aio_write+0x266/0x420
[506168.383995]  [<ffffffff810d32e6>] ? generic_file_aio_write+0x46/0xb0
[506168.383995]  [<ffffffff810d32fc>] generic_file_aio_write+0x5c/0xb0
[506168.383995]  [<ffffffffa0673f06>] ext4_file_write+0x46/0xb0 [ext4]
[506168.383995]  [<ffffffff81114ed1>] do_sync_write+0xf1/0x130
[506168.383995]  [<ffffffff8106e8a0>] ? autoremove_wake_function+0x0/0x40
[506168.383995]  [<ffffffff810a4992>] ? audit_filter_syscall+0x92/0x190
[506168.383995]  [<ffffffff810a493a>] ? audit_filter_syscall+0x3a/0x190
[506168.383995]  [<ffffffff810a48cf>] ? audit_filter_inodes+0x19f/0x1d0
[506168.383995]  [<ffffffff81199431>] ? security_file_permission+0x11/0x20
[506168.383995]  [<ffffffff811156f7>] vfs_write+0xc7/0x1a0
[506168.383995]  [<ffffffff81115e00>] sys_write+0x50/0x90
[506168.383995]  [<ffffffff8100b2ab>] system_call_fastpath+0x16/0x1b
[506168.383995] Code: 55 b8 49 89 55 18 48 8b 40 18 49 89 45 20 f0 41 80 4d 00 40 f0 41 80 4d 01 02 e9 69 ff ff ff c7 45 b4 86 ff ff ff e9 5d ff ff ff <0f> 0b eb fe 0f 0b eb f
[506168.383995] RIP  [<ffffffffa067e7ec>] ext4_da_get_block_prep+0x29c/0x2b0 [ext4]
[506168.383995]  RSP <ffff880076a199f8>
[506168.805527] ---[ end trace d0b7fef2831ee787 ]---
[506168.810542] note: mc[27713] exited with preempt_count 1
[506168.816202] BUG: scheduling while atomic: mc/27713/0x10000002
[506168.822419] INFO: lockdep is turned off.
[506168.826645] Modules linked in:  .........
[506168.918234] Pid: 27713, comm: mc Tainted: G      D    2.6.32lb.04 #1
[506168.925034] Call Trace:
[506168.927780]  [<ffffffff8107e935>] ? __debug_show_held_locks+0x25/0x30
[506168.934664]  [<ffffffff81041385>] __schedule_bug+0x65/0x70
[506168.940590]  [<ffffffff81340435>] thread_return+0x6e8/0x823
[506168.946580]  [<ffffffff81043bf3>] __cond_resched+0x13/0x30
[506168.952526]  [<ffffffff813405e8>] _cond_resched+0x28/0x30
[506168.958334]  [<ffffffff810ee54b>] unmap_vmas+0x93b/0x9d0
[506168.964056]  [<ffffffff810f343e>] exit_mmap+0xde/0x190
[506168.969647]  [<ffffffff8104d6a4>] mmput+0x54/0x110
[506168.974858]  [<ffffffff81052762>] exit_mm+0x102/0x130
[506168.980300]  [<ffffffff8122aaad>] ? tty_audit_exit+0x2d/0x90
[506168.986395]  [<ffffffff81053ead>] do_exit+0x18d/0x7d0
[506168.991828]  [<ffffffff8100f8d7>] oops_end+0xa7/0xb0
[506168.997162]  [<ffffffff8100fad6>] die+0x56/0x90
[506169.002083]  [<ffffffff8100c820>] do_trap+0x130/0x150
[506169.007542]  [<ffffffff8100ce90>] do_invalid_op+0x90/0xb0
[506169.013365]  [<ffffffffa067e7ec>] ? ext4_da_get_block_prep+0x29c/0x2b0 [ext4]
[506169.021045]  [<ffffffff8100c0b5>] invalid_op+0x15/0x20
[506169.026606]  [<ffffffffa067e7ec>] ? ext4_da_get_block_prep+0x29c/0x2b0 [ext4]
[506169.034295]  [<ffffffffa067e6bb>] ? ext4_da_get_block_prep+0x16b/0x2b0 [ext4]
[506169.041980]  [<ffffffff8113d0fc>] __block_prepare_write+0x27c/0x440
[506169.048657]  [<ffffffffa067e550>] ? ext4_da_get_block_prep+0x0/0x2b0 [ext4]
[506169.056119]  [<ffffffff810dbd82>] ? __lru_cache_add+0x72/0xb0
[506169.062286]  [<ffffffff8113d359>] block_write_begin+0x59/0xe0
[506169.068441]  [<ffffffffa067d612>] ext4_da_write_begin+0x182/0x280 [ext4]
[506169.075636]  [<ffffffffa067e550>] ? ext4_da_get_block_prep+0x0/0x2b0 [ext4]
[506169.083120]  [<ffffffff810d2b9a>] generic_file_buffered_write+0x10a/0x290
[506169.090398]  [<ffffffff810d30e6>] __generic_file_aio_write+0x266/0x420
[506169.097392]  [<ffffffff810d32e6>] ? generic_file_aio_write+0x46/0xb0
[506169.104133]  [<ffffffff810d32fc>] generic_file_aio_write+0x5c/0xb0
[506169.110804]  [<ffffffffa0673f06>] ext4_file_write+0x46/0xb0 [ext4]
[506169.117439]  [<ffffffff81114ed1>] do_sync_write+0xf1/0x130
[506169.123356]  [<ffffffff8106e8a0>] ? autoremove_wake_function+0x0/0x40
[506169.130231]  [<ffffffff810a4992>] ? audit_filter_syscall+0x92/0x190
[506169.136911]  [<ffffffff810a493a>] ? audit_filter_syscall+0x3a/0x190
[506169.143606]  [<ffffffff810a48cf>] ? audit_filter_inodes+0x19f/0x1d0
[506169.150308]  [<ffffffff81199431>] ? security_file_permission+0x11/0x20
[506169.157223]  [<ffffffff811156f7>] vfs_write+0xc7/0x1a0
[506169.162787]  [<ffffffff81115e00>] sys_write+0x50/0x90
[506169.168190]  [<ffffffff8100b2ab>] system_call_fastpath+0x16/0x1b
[506169.175310] ------------[ cut here ]------------
[506169.178631] kernel BUG at fs/jbd/transaction.c:280!
[506169.178631] invalid opcode: 0000 [#2] PREEMPT SMP
[506169.178631] last sysfs file: /sys/devices/pci0000:00/0000:00:03.0/0000:0a:00.0/0000:0b:0e.0/host4/target4:0:1/4:0:1:0/type
[506169.178631] CPU 1

[506169.178631] Modules linked in: ...
[506169.178631] Pid: 27713, comm: mc Tainted: G      D    2.6.32lb.04 #1 PDSM4+
[506169.178631] RIP: 0010:[<ffffffffa002850c>]  [<ffffffffa002850c>] journal_start+0xec/0xf0 [jbd]
[506169.178631] RSP: 0018:ffff880076a192f8  EFLAGS: 00010287
[506169.178631] RAX: ffff88006bd0a600 RBX: ffff88007ba89b10 RCX: 0000000000000000
[506169.178631] RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff88007cbef000
[506169.178631] RBP: ffff880076a19328 R08: 0000000000000001 R09: 0000000000000040
[506169.178631] R10: 0000000000000001 R11: ffff880076a19480 R12: ffff88007ba89b10
[506169.178631] R13: ffff88007cbef000 R14: ffff8800299e4e40 R15: 0000000000000002
[506169.178631] FS:  00007fc458e256e0(0000) GS:ffff880001f00000(0000) knlGS:0000000000000000
[506169.178631] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[506169.178631] CR2: 00007f56785cb000 CR3: 0000000001001000 CR4: 00000000000006e0
[506169.178631] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[506169.178631] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[506169.178631] Process mc (pid: 27713, threadinfo ffff880076a18000, task ffff8800299e4e40)
[506169.178631] Stack:
[506169.178631]  0000000000000202 0000000000000001 ffff88007ba89b10 ffff88007407b1c8
[506169.178631] <0> 000000004b4dd3ab ffff880071031280 ffff880076a19338 ffffffffa004c47c
[506169.178631] <0> ffff880076a19368 ffffffffa00461b8 000000000001bc24 0000000000000001
[506169.178631] Call Trace:
[506169.178631]  [<ffffffffa004c47c>] ext3_journal_start_sb+0x2c/0x50 [ext3]
[506169.178631]  [<ffffffffa00461b8>] ext3_dirty_inode+0x38/0x90 [ext3]
[506169.178631]  [<ffffffff81136935>] __mark_inode_dirty+0x35/0x180
[506169.178631]  [<ffffffff8112c4e5>] file_update_time+0xe5/0x190
[506169.178631]  [<ffffffff810d30b2>] __generic_file_aio_write+0x232/0x420
[506169.178631]  [<ffffffff810d32e6>] ? generic_file_aio_write+0x46/0xb0
[506169.178631]  [<ffffffff810d32e6>] ? generic_file_aio_write+0x46/0xb0
[506169.178631]  [<ffffffff810d32fc>] generic_file_aio_write+0x5c/0xb0
[506169.178631]  [<ffffffff81114ed1>] do_sync_write+0xf1/0x130
[506169.178631]  [<ffffffff8106e8a0>] ? autoremove_wake_function+0x0/0x40
[506169.178631]  [<ffffffff81092bec>] ? do_acct_process+0x23c/0x4e0
[506169.178631]  [<ffffffff81092d22>] do_acct_process+0x372/0x4e0
[506169.178631]  [<ffffffff81092b00>] ? do_acct_process+0x150/0x4e0
[506169.178631]  [<ffffffff810f3341>] ? remove_vma+0x61/0x80
[506169.178631]  [<ffffffff81092efc>] acct_process+0x6c/0xa0
[506169.178631]  [<ffffffff81054435>] do_exit+0x715/0x7d0
[506169.178631]  [<ffffffff8100f8d7>] oops_end+0xa7/0xb0
[506169.178631]  [<ffffffff8100fad6>] die+0x56/0x90
[506169.178631]  [<ffffffff8100c820>] do_trap+0x130/0x150
[506169.178631]  [<ffffffff8100ce90>] do_invalid_op+0x90/0xb0
[506169.178631]  [<ffffffffa067e7ec>] ? ext4_da_get_block_prep+0x29c/0x2b0 [ext4]
[506169.178631]  [<ffffffff8100c0b5>] invalid_op+0x15/0x20
[506169.178631]  [<ffffffffa067e7ec>] ? ext4_da_get_block_prep+0x29c/0x2b0 [ext4]
[506169.178631]  [<ffffffffa067e6bb>] ? ext4_da_get_block_prep+0x16b/0x2b0 [ext4]
[506169.178631]  [<ffffffff8113d0fc>] __block_prepare_write+0x27c/0x440
[506169.178631]  [<ffffffffa067e550>] ? ext4_da_get_block_prep+0x0/0x2b0 [ext4]
[506169.178631]  [<ffffffff810dbd82>] ? __lru_cache_add+0x72/0xb0
[506169.178631]  [<ffffffff8113d359>] block_write_begin+0x59/0xe0
[506169.178631]  [<ffffffffa067d612>] ext4_da_write_begin+0x182/0x280 [ext4]
[506169.178631]  [<ffffffffa067e550>] ? ext4_da_get_block_prep+0x0/0x2b0 [ext4]
[506169.178631]  [<ffffffff810d2b9a>] generic_file_buffered_write+0x10a/0x290
[506169.178631]  [<ffffffff810d30e6>] __generic_file_aio_write+0x266/0x420
[506169.178631]  [<ffffffff810d32e6>] ? generic_file_aio_write+0x46/0xb0
[506169.178631]  [<ffffffff810d32fc>] generic_file_aio_write+0x5c/0xb0
[506169.178631]  [<ffffffffa0673f06>] ext4_file_write+0x46/0xb0 [ext4]
[506169.178631]  [<ffffffff81114ed1>] do_sync_write+0xf1/0x130
[506169.178631]  [<ffffffff8106e8a0>] ? autoremove_wake_function+0x0/0x40
[506169.178631]  [<ffffffff810a4992>] ? audit_filter_syscall+0x92/0x190
[506169.178631]  [<ffffffff810a493a>] ? audit_filter_syscall+0x3a/0x190
[506169.178631]  [<ffffffff810a48cf>] ? audit_filter_inodes+0x19f/0x1d0
[506169.178631]  [<ffffffff81199431>] ? security_file_permission+0x11/0x20
[506169.178631]  [<ffffffff811156f7>] vfs_write+0xc7/0x1a0
[506169.178631]  [<ffffffff81115e00>] sys_write+0x50/0x90
[506169.178631]  [<ffffffff8100b2ab>] system_call_fastpath+0x16/0x1b
[506169.178631] Code: ff ff 85 c0 41 89 c4 79 84 48 8b 3d 17 91 00 00 48 89 de 49 63 dc e8 d4 30 0e e1 49 c7 86 08 16 00 00 00 00 00 00 e9 62 ff ff ff <0f> 0b eb fe 55 be 01 00 00 00 48 89 e5 e8 02
ff ff ff 48 3d 00
[506169.178631] RIP  [<ffffffffa002850c>] journal_start+0xec/0xf0 [jbd]
[506169.178631]  RSP <ffff880076a192f8>
[506169.742830] ---[ end trace d0b7fef2831ee788 ]---
[506169.747821] Fixing recursive fault but reboot is needed!
[506169.753554] BUG: scheduling while atomic: mc/27713/0x00000002
[506169.759697] INFO: lockdep is turned off.
[506169.763993] Modules linked in: .....
[506169.853541] Pid: 27713, comm: mc Tainted: G      D    2.6.32lb.04 #1
[506169.860343] Call Trace:
[506169.863132]  [<ffffffff8107e935>] ? __debug_show_held_locks+0x25/0x30
[506169.870098]  [<ffffffff81041385>] __schedule_bug+0x65/0x70
[506169.876027]  [<ffffffff81340435>] thread_return+0x6e8/0x823
[506169.882148]  [<ffffffff810544d5>] do_exit+0x7b5/0x7d0
[506169.887634]  [<ffffffff8100f8d7>] oops_end+0xa7/0xb0
[506169.893009]  [<ffffffff8100fad6>] die+0x56/0x90
[506169.897991]  [<ffffffff8100c820>] do_trap+0x130/0x150
[506169.903461]  [<ffffffff8100ce90>] do_invalid_op+0x90/0xb0
[506169.909329]  [<ffffffffa002850c>] ? journal_start+0xec/0xf0 [jbd]
[506169.915937]  [<ffffffff810512b5>] ? vprintk+0x3c5/0x4c0
[506169.921608]  [<ffffffff8100c0b5>] invalid_op+0x15/0x20
[506169.928726]  [<ffffffffa002850c>] ? journal_start+0xec/0xf0 [jbd]
[506169.935266]  [<ffffffffa004c47c>] ext3_journal_start_sb+0x2c/0x50 [ext3]
[506169.942539]  [<ffffffffa00461b8>] ext3_dirty_inode+0x38/0x90 [ext3]
[506169.949364]  [<ffffffff81136935>] __mark_inode_dirty+0x35/0x180
[506169.955760]  [<ffffffff8112c4e5>] file_update_time+0xe5/0x190
[506169.961968]  [<ffffffff810d30b2>] __generic_file_aio_write+0x232/0x420
[506169.968985]  [<ffffffff810d32e6>] ? generic_file_aio_write+0x46/0xb0
[506169.975887]  [<ffffffff810d32e6>] ? generic_file_aio_write+0x46/0xb0
[506169.982761]  [<ffffffff810d32fc>] generic_file_aio_write+0x5c/0xb0
[506169.989454]  [<ffffffff81114ed1>] do_sync_write+0xf1/0x130
[506169.995382]  [<ffffffff8106e8a0>] ? autoremove_wake_function+0x0/0x40
[506170.002346]  [<ffffffff81092bec>] ? do_acct_process+0x23c/0x4e0
[506170.008740]  [<ffffffff81092d22>] do_acct_process+0x372/0x4e0
[506170.014989]  [<ffffffff81092b00>] ? do_acct_process+0x150/0x4e0
[506170.021458]  [<ffffffff810f3341>] ? remove_vma+0x61/0x80
[506170.027273]  [<ffffffff81092efc>] acct_process+0x6c/0xa0
[506170.033029]  [<ffffffff81054435>] do_exit+0x715/0x7d0
[506170.038568]  [<ffffffff8100f8d7>] oops_end+0xa7/0xb0
[506170.043954]  [<ffffffff8100fad6>] die+0x56/0x90
[506170.048937]  [<ffffffff8100c820>] do_trap+0x130/0x150
[506170.054447]  [<ffffffff8100ce90>] do_invalid_op+0x90/0xb0
[506170.060269]  [<ffffffffa067e7ec>] ? ext4_da_get_block_prep+0x29c/0x2b0 [ext4]
[506170.067991]  [<ffffffff8100c0b5>] invalid_op+0x15/0x20
[506170.073588]  [<ffffffffa067e7ec>] ? ext4_da_get_block_prep+0x29c/0x2b0 [ext4]
[506170.081361]  [<ffffffffa067e6bb>] ? ext4_da_get_block_prep+0x16b/0x2b0 [ext4]
[506170.089142]  [<ffffffff8113d0fc>] __block_prepare_write+0x27c/0x440
[506170.095891]  [<ffffffffa067e550>] ? ext4_da_get_block_prep+0x0/0x2b0 [ext4]
[506170.103271]  [<ffffffff810dbd82>] ? __lru_cache_add+0x72/0xb0
[506170.109477]  [<ffffffff8113d359>] block_write_begin+0x59/0xe0
[506170.115655]  [<ffffffffa067d612>] ext4_da_write_begin+0x182/0x280 [ext4]
[506170.122928]  [<ffffffffa067e550>] ? ext4_da_get_block_prep+0x0/0x2b0 [ext4]
[506170.130421]  [<ffffffff810d2b9a>] generic_file_buffered_write+0x10a/0x290
[506170.137718]  [<ffffffff810d30e6>] __generic_file_aio_write+0x266/0x420
[506170.144699]  [<ffffffff810d32e6>] ? generic_file_aio_write+0x46/0xb0
[506170.151517]  [<ffffffff810d32fc>] generic_file_aio_write+0x5c/0xb0
[506170.158141]  [<ffffffffa0673f06>] ext4_file_write+0x46/0xb0 [ext4]
[506170.164887]  [<ffffffff81114ed1>] do_sync_write+0xf1/0x130
[506170.170850]  [<ffffffff8106e8a0>] ? autoremove_wake_function+0x0/0x40
[506170.177698]  [<ffffffff810a4992>] ? audit_filter_syscall+0x92/0x190
[506170.184458]  [<ffffffff810a493a>] ? audit_filter_syscall+0x3a/0x190
[506170.191227]  [<ffffffff810a48cf>] ? audit_filter_inodes+0x19f/0x1d0
[506170.197965]  [<ffffffff81199431>] ? security_file_permission+0x11/0x20
[506170.205007]  [<ffffffff811156f7>] vfs_write+0xc7/0x1a0
[506170.210580]  [<ffffffff81115e00>] sys_write+0x50/0x90
[506170.216109]  [<ffffffff8100b2ab>] system_call_fastpath+0x16/0x1b

The filesystem is ~5.5TB EXT4, mounted on top of dm-crypt on top of sw raid5
I've run full fsck about 2 days before the crash, without any issue.
Could anybody more skilled have a look on the traces please?
Should it be needed, I'll gladly provide further information/testing.
cheers
nik


