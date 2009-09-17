Return-Path: <linux-kernel-owner+w=401wt.eu-S1752501AbZIQUFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbZIQUFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbZIQUFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:05:14 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:49018 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZIQUFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:05:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=LBHzg96ea0NC8WqZR9CqMjbsdmIjBh/M0Y1vSjKdbhjU150GWwnMiYfjQohdhAln5/
         ZR6cM0CpTsX7b79Ldok+rcNXt7WRtIbOl0kJ21kKaBTxEBCBZ2bnPItjXkIXp5qvR9OB
         na9prVicfo8WG39VNyyKxHS0pS1zwQe0sHHOc=
MIME-Version: 1.0
Date: Thu, 17 Sep 2009 22:05:14 +0200
Message-ID: <520f0cf10909171305j4b65b146sbc135afb335f2576@mail.gmail.com>
Subject: 2.6.31-rt10 crash
From: John Kacur <jkacur@gmail.com>
To: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was recompiling 2.6.31-rt10 on a system that was already running 2.6.31-rt10
(I wanted a kernel with trace options, and not so many debug options
to measure latency with)
I got the following during the sudo make modules_install install
step

BUG: unable to handle kernel paging request at 000000066d387ba0
IP: [<ffffffff81410e8f>] __schedule+0x650/0x8ef
PGD 12bc16067 PUD 0
Thread overran stack, or stack corrupted
Oops: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/class/power_supply/BAT0/energy_full
CPU 1
Modules linked in: tun fuse i915 drm i2c_algo_bit ipt_MASQUERADE iptable_nat nf_
nat rfcomm bridge stp bnep sco l2cap sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defr
ag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_stat
e ip6table_filter ip6_tables x_tables ipv6 cpufreq_ondemand acpi_cpufreq ext3 jb
d mbcache dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod kvm_intel
kvm uinput arc4 ecb snd_hda_codec_conexant iwlagn iwlcore snd_hda_intel snd_hda_
codec mac80211 snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq sn
d_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer e1000e sdhci_pci btusb
sdhci thinkpad_acpi cfg80211 snd ppdev video parport_pc i2c_i801 ata_generic sr_
mod mmc_core firewire_ohci pata_acpi parport hwmon bluetooth firewire_core outpu
t ricoh_mmc soundcore intel_agp i2c_core sg ac battery cdrom pcspkr iTCO_wdt iTC
O_vendor_support button rfkill wmi snd_page_alloc crc_itu_t joydev ahci libata s
d_mod scsi_mod crc_t10dif xfs exportfs uhci_hcd ohci_hcd ehci_hcd [last unloaded
: microcode]
Pid: 2602, comm: Xorg Not tainted 2.6.31-rt10 #1 2241B48
RIP: 0010:[<ffffffff81410e8f>]  [<ffffffff81410e8f>] __schedule+0x650/0x8ef
RSP: 0018:ffff88012b1221b8  EFLAGS: 00010083
RAX: 00000000dd79fbea RBX: ffff8801300fc700 RCX: ffff8801300fc700
RDX: 0000000000221a00 RSI: 00000000dd79fbea RDI: ffff88002c24c1a0
RBP: ffff88012b122268 R08: ffff88011d421a10 R09: 00000754f3bd1b47
R10: 00000000dd79fbea R11: 0000000000000000 R12: ffff8801300fc700
R13: ffff88002c248a80 R14: 0000000000000004 R15: ffff88002c24ba00
FS:  00007fc79b087790(0000) GS:ffff88002c02a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000066d387ba0 CR3: 0000000138d67000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process Xorg (pid: 2602, threadinfo ffff88012b122000, task ffff8801300fc700)
Stack:
 ffff88002c248a80 0000000000000246 ffff88012b1222c8 ffffffff81412bb6
<0> ffff8801300fc700 ffff88013bb804c0 ffff8801300fcaa0 00000001814125f4
<0> ffffffff8141140f ffff88002c248a80 ffff88012b122238 ffffffff810e1574
Call Trace:
 [<ffffffff81412bb6>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8141140f>] ? preempt_schedule+0x55/0x98
 [<ffffffff810e1574>] ? trace_preempt_off+0x2f/0x70
 [<ffffffff81411422>] preempt_schedule+0x68/0x98
 [<ffffffff81413b59>] ? _atomic_spin_unlock_irqrestore+0x55/0x91
 [<ffffffff81413b7a>] _atomic_spin_unlock_irqrestore+0x76/0x91
 [<ffffffff814125f4>] rt_spin_lock_slowlock+0x255/0x29e
 [<ffffffff8141239f>] ? rt_spin_lock_slowlock+0x0/0x29e
 [<ffffffff8109e3cc>] rt_spin_lock_fastlock+0x67/0x82
 [<ffffffff814130dd>] rt_spin_lock+0x2e/0x68
 [<ffffffff8112a6c4>] _slab_irq_disable+0x4f/0x89
 [<ffffffff8112d408>] kmem_cache_alloc+0x7a/0x238
 [<ffffffffa00a8221>] scsi_pool_alloc_command+0x36/0x8a [scsi_mod]
 [<ffffffff810e18d4>] ? trace_preempt_on+0x2c/0x6d
 [<ffffffffa00a82a0>] scsi_host_alloc_command+0x2b/0x8c [scsi_mod]
 [<ffffffffa00a87c3>] __scsi_get_command+0x24/0xb2 [scsi_mod]
 [<ffffffffa00a8897>] scsi_get_command+0x46/0xbf [scsi_mod]
 [<ffffffffa00af2eb>] scsi_setup_fs_cmnd+0x7e/0xe3 [scsi_mod]
 [<ffffffffa00d9d73>] sd_prep_fn+0x73/0x8b4 [sd_mod]
 [<ffffffff81219bd1>] ? cfq_dispatch_insert+0x4c/0x76
 [<ffffffff8121a2ba>] ? cfq_dispatch_requests+0x291/0x387
 [<ffffffff81413b63>] ? _atomic_spin_unlock_irqrestore+0x5f/0x91
 [<ffffffff812096d9>] blk_peek_request+0x136/0x216
 [<ffffffffa00ae5dc>] scsi_request_fn+0x92/0x55f [scsi_mod]
 [<ffffffff8120a105>] __blk_run_queue+0x4f/0x99
 [<ffffffff81219ff3>] cfq_insert_request+0x30b/0x341
 [<ffffffff811ff936>] elv_insert+0x1ef/0x2b3
 [<ffffffff811ffaa3>] __elv_add_request+0xa9/0xc8
 [<ffffffff8120b04c>] __make_request+0x3d6/0x46b
 [<ffffffff81208fa3>] generic_make_request+0x2e4/0x342
 [<ffffffff812090c9>] submit_bio+0xc8/0xe5
 [<ffffffffa0079229>] _xfs_buf_ioapply+0x231/0x273 [xfs]
 [<ffffffffa007a3ef>] xfs_buf_iorequest+0x5a/0xa4 [xfs]
 [<ffffffffa007adbc>] ? xfs_buf_get_flags+0xda/0x170 [xfs]
 [<ffffffffa007aa67>] _xfs_buf_read+0x40/0x6d [xfs]
 [<ffffffffa007aeb7>] xfs_buf_read_flags+0x65/0xb1 [xfs]
 [<ffffffffa0070938>] xfs_trans_read_buf+0x1c8/0x2d8 [xfs]
 [<ffffffffa00437fd>] xfs_btree_read_buf_block+0x5c/0xb4 [xfs]
 [<ffffffff8141235b>] ? rt_spin_lock_slowunlock+0x58/0x9c
 [<ffffffffa00448e8>] xfs_btree_lookup_get_block+0x97/0xd1 [xfs]
 [<ffffffffa0044f5c>] xfs_btree_lookup+0x145/0x3fb [xfs]
 [<ffffffffa002ef12>] xfs_alloc_lookup_eq+0x27/0x3d [xfs]
 [<ffffffffa002f09a>] xfs_alloc_fixup_trees+0x80/0x2a0 [xfs]
 [<ffffffffa002ef99>] ? xfs_alloc_get_rec+0x31/0x72 [xfs]
 [<ffffffffa003066b>] xfs_alloc_ag_vextent_size+0x342/0x43f [xfs]
 [<ffffffffa00310cd>] xfs_alloc_ag_vextent+0x38/0x11e [xfs]
 [<ffffffffa00319bc>] xfs_alloc_vextent+0x2f9/0x44d [xfs]
 [<ffffffffa003d00d>] ? xfs_inode_is_filestream+0x3a/0x85 [xfs]
 [<ffffffffa003d01c>] ? xfs_inode_is_filestream+0x49/0x85 [xfs]
 [<ffffffffa003d594>] xfs_bmap_btalloc+0x53c/0x719 [xfs]
 [<ffffffffa003d78d>] xfs_bmap_alloc+0x1c/0x32 [xfs]
 [<ffffffffa003f5ce>] xfs_bmapi+0x6f0/0xdf1 [xfs]
 [<ffffffffa005ecdb>] xfs_iomap_write_allocate+0x21f/0x363 [xfs]
 [<ffffffff8141316e>] ? rt_spin_unlock+0x57/0x72
 [<ffffffffa005f69f>] xfs_iomap+0x21f/0x2a0 [xfs]
 [<ffffffffa0076c01>] xfs_map_blocks+0x37/0x54 [xfs]
 [<ffffffffa0077b73>] xfs_page_state_convert+0x2f0/0x5d7 [xfs]
 [<ffffffff8110a6aa>] ? __dec_zone_state+0x9a/0xd9
 [<ffffffff81095670>] ? trace_hardirqs_on+0x20/0x36
 [<ffffffff810e193e>] ? time_hardirqs_on+0x29/0x7d
 [<ffffffffa007820d>] xfs_vm_writepage+0xbb/0x108 [xfs]
 [<ffffffff81100a61>] shrink_page_list+0x3d1/0x6f0
 [<ffffffff81095670>] ? trace_hardirqs_on+0x20/0x36
 [<ffffffff811012d6>] shrink_list+0x2e5/0x5b0
 [<ffffffff8109ea0c>] ? debug_rt_mutex_free_waiter+0x27/0xf0
 [<ffffffff81095670>] ? trace_hardirqs_on+0x20/0x36
 [<ffffffff81413b63>] ? _atomic_spin_unlock_irqrestore+0x5f/0x91
 [<ffffffff810e18d4>] ? trace_preempt_on+0x2c/0x6d
 [<ffffffff81101850>] shrink_zone+0x2af/0x38a
 [<ffffffff8110297e>] ? try_to_free_pages+0xde/0x3cd
 [<ffffffff810ff671>] ? count_vm_event+0x4e/0x8c
 [<ffffffff81416d54>] ? sub_preempt_count+0xad/0xd7
 [<ffffffff81102af0>] try_to_free_pages+0x250/0x3cd
 [<ffffffff810ff744>] ? isolate_pages_global+0x0/0x1fc
 [<ffffffff810faf52>] __alloc_pages_nodemask+0x44a/0x640
 [<ffffffff811286b1>] alloc_pages_current+0xa9/0xca
 [<ffffffff810fa006>] __get_free_pages+0x1c/0x6d
 [<ffffffff8114f92f>] __pollwait+0x71/0xfe
 [<ffffffff813e6039>] sock_poll_wait+0x29/0x42
 [<ffffffff813e607d>] unix_poll+0x2b/0xc3
 [<ffffffff81349eca>] sock_poll+0x2e/0x44
 [<ffffffff8114f18f>] do_select+0x3c0/0x5da
 [<ffffffff8114f8be>] ? __pollwait+0x0/0xfe
 [<ffffffff8114f9bc>] ? pollwake+0x0/0x7c
 [<ffffffff8114f9bc>] ? pollwake+0x0/0x7c
 [<ffffffff8114f9bc>] ? pollwake+0x0/0x7c
 [<ffffffff8114f9bc>] ? pollwake+0x0/0x7c
 [<ffffffff8114f9bc>] ? pollwake+0x0/0x7c
 [<ffffffff8114f9bc>] ? pollwake+0x0/0x7c
 [<ffffffff8114f9bc>] ? pollwake+0x0/0x7c
 [<ffffffff8114f9bc>] ? pollwake+0x0/0x7c
 [<ffffffff8114f9bc>] ? pollwake+0x0/0x7c
 [<ffffffff8114f561>] core_sys_select+0x1b8/0x271
 [<ffffffff8141402b>] ? unlock_kernel+0x54/0x6a
 [<ffffffff8114e580>] ? poll_select_set_timeout+0x68/0x9f
 [<ffffffff8114f882>] sys_select+0xa3/0xdf
 [<ffffffff8100bfeb>] system_call_fastpath+0x16/0x1b
Code: ff ff 48 89 85 78 ff ff ff 0f 84 25 03 00 00 48 8b 8d 70 ff ff ff 48 c7 c2
 00 1a 22 00 48 8b 9d 70 ff ff ff 48 8b 41 08 8b 40 18 <48> 8b 04 c5 50 9c 68 81
 48 8d 0c 02 48 3b 99 40 08 00 00 74 63
RIP  [<ffffffff81410e8f>] __schedule+0x650/0x8ef
 RSP <ffff88012b1221b8>
CR2: 000000066d387ba0
---[ end trace 00b40f39bfa88a0d ]---
BUG: unable to handle kernel paging request at 00000000d9f9a490
IP: [<ffffffff81045fcf>] task_rq_lock+0x41/0x9c
PGD 11311f067 PUD 0
Oops: 0000 [#2] PREEMPT SMP
last sysfs file: /sys/class/power_supply/BAT0/energy_full
CPU 0
Modules linked in: tun fuse i915 drm i2c_algo_bit ipt_MASQUERADE iptable_nat nf_
nat rfcomm bridge stp bnep sco l2cap sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defr
ag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_stat
e ip6table_filter ip6_tables x_tables ipv6 cpufreq_ondemand acpi_cpufreq ext3 jb
d mbcache dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod kvm_intel
kvm uinput arc4 ecb snd_hda_codec_conexant iwlagn iwlcore snd_hda_intel snd_hda_
codec mac80211 snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq sn
d_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer e1000e sdhci_pci btusb
sdhci thinkpad_acpi cfg80211 snd ppdev video parport_pc i2c_i801 ata_generic sr_
mod mmc_core firewire_ohci pata_acpi parport hwmon bluetooth firewire_core outpu
t ricoh_mmc soundcore intel_agp i2c_core sg ac battery cdrom pcspkr iTCO_wdt iTC
O_vendor_support button rfkill wmi snd_page_alloc crc_itu_t joydev ahci libata s
d_mod scsi_mod crc_t10dif xfs exportfs uhci_hcd ohci_hcd ehci_hcd [last unloaded
: microcode]
Pid: 8, comm: sirq-block/0 Tainted: G      D    2.6.31-rt10 #1 2241B48
RIP: 0010:[<ffffffff81045fcf>]  [<ffffffff81045fcf>] task_rq_lock+0x41/0x9c
RSP: 0018:ffff88013bb15a30  EFLAGS: 00010046
RAX: 000000002b122108 RBX: 0000000000221a00 RCX: ffff88013bb15bd0
RDX: 00000000bd4f4834 RSI: 0000000000000001 RDI: 0000000000000003
RBP: ffff88013bb15a60 R08: 0000000000000002 R09: 0000000000000001
R10: 0000000035ffad5e R11: 0000000000000046 R12: 0000000000221a00
R13: ffff88013bb15a88 R14: ffff8801300fc700 R15: ffff8801300fc700
FS:  0000000000000000(0000) GS:ffff88002be00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000d9f9a490 CR3: 0000000118cf2000 CR4: 00000000000026f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
Process sirq-block/0 (pid: 8, threadinfo ffff88013bb14000, task ffff88013bb10200
)
Stack:
 ffff8801300fce60 00000000bd4f4834 0000000000000032 ffff8801300fc700
<0> ffff88013bb15b80 ffff880137c133b8 ffff88013bb15ac0 ffffffff810520ea
<0> ffff88013bb15bb8 ffff8801300fcea0 ffffffff8142a700 0000000000000046
Call Trace:
 [<ffffffff810520ea>] task_setprio+0x42/0x1d2
 [<ffffffff8109d4eb>] __rt_mutex_adjust_prio+0x2f/0x4a
 [<ffffffff8109dc3c>] task_blocks_on_rt_mutex+0x13a/0x1b0
 [<ffffffff814124a4>] rt_spin_lock_slowlock+0x105/0x29e
 [<ffffffff8141239f>] ? rt_spin_lock_slowlock+0x0/0x29e
 [<ffffffff8109e3cc>] rt_spin_lock_fastlock+0x67/0x82
 [<ffffffff814130dd>] rt_spin_lock+0x2e/0x68
 [<ffffffffa00af5b3>] ? scsi_device_unbusy+0x3a/0xd1 [scsi_mod]
 [<ffffffffa00af617>] scsi_device_unbusy+0x9e/0xd1 [scsi_mod]
 [<ffffffffa00a7aa7>] scsi_finish_command+0x36/0x11f [scsi_mod]
 [<ffffffffa00afcb7>] scsi_softirq_done+0x133/0x153 [scsi_mod]
 [<ffffffff8120f58b>] blk_done_softirq+0x87/0xad
 [<ffffffff81061b8e>] ksoftirqd+0x160/0x28f
 [<ffffffff81061a2e>] ? ksoftirqd+0x0/0x28f
 [<ffffffff81061a2e>] ? ksoftirqd+0x0/0x28f
 [<ffffffff8107fe9e>] kthread+0xad/0xb5
 [<ffffffff81412bb6>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff810e193e>] ? time_hardirqs_on+0x29/0x7d
 [<ffffffff8100d15a>] child_rip+0xa/0x20
 [<ffffffff8100cac0>] ? restore_args+0x0/0x30
 [<ffffffff8107fdf1>] ? kthread+0x0/0xb5
 [<ffffffff8100d150>] ? child_rip+0x0/0x20
Code: 00 53 48 83 ec 10 65 48 8b 04 25 28 00 00 00 48 89 45 d8 31 c0 9c 58 fa 49
 89 45 00 4c 89 e3 e8 c0 e6 04 00 49 8b 46 08 8b 40 18 <48> 03 1c c5 50 9c 68 81
 48 89 df e8 92 dd 3c 00 49 8b 46 08 8b
RIP  [<ffffffff81045fcf>] task_rq_lock+0x41/0x9c
 RSP <ffff88013bb15a30>
CR2: 00000000d9f9a490
---[ end trace 00b40f39bfa88a0e ]---
note: sirq-block/0[8] exited with preempt_count 2
Kernel panic - not syncing: Fatal exception in interrupt
BUG: spinlock lockup on CPU#1, Xorg/2602, ffff88002c24ba00
Pid: 2602, comm: Xorg Tainted: G      D    2.6.31-rt10 #1
Call Trace:
 <IRQ>  [<ffffffff8122a929>] _raw_spin_lock+0x11c/0x15d
 [<ffffffff81413ddc>] _atomic_spin_lock+0x6b/0x94
 [<ffffffff81054344>] ? scheduler_tick+0x55/0x280
 [<ffffffff810872c6>] ? sched_clock_tick+0x82/0x105
 [<ffffffff81054344>] scheduler_tick+0x55/0x280
 [<ffffffff810698a7>] update_process_times+0x3f/0x80
 [<ffffffff81090020>] tick_sched_timer+0x82/0xc2
 [<ffffffff81413a4c>] ? _atomic_spin_unlock+0x56/0x71
 [<ffffffff8108ff9e>] ? tick_sched_timer+0x0/0xc2
 [<ffffffff81083a5e>] __run_hrtimer+0x89/0xd5
 [<ffffffff81084046>] ? hrtimer_interrupt+0xd0/0x1a9
 [<ffffffff8108409d>] hrtimer_interrupt+0x127/0x1a9
 [<ffffffff810e1606>] ? time_hardirqs_off+0x51/0x70
 [<ffffffff810e1606>] ? time_hardirqs_off+0x51/0x70
 [<ffffffff8102784e>] smp_apic_timer_interrupt+0x94/0xbe
 [<ffffffff8100cc33>] apic_timer_interrupt+0x13/0x20
 <EOI>
BUG: spinlock lockup on CPU#0, depmod/1942, ffff88002c24ba00
Pid: 1942, comm: depmod Tainted: G      D    2.6.31-rt10 #1
Call Trace:
 <IRQ>  [<ffffffff8122a929>] _raw_spin_lock+0x11c/0x15d
 [<ffffffff81413ddc>] _atomic_spin_lock+0x6b/0x94
 [<ffffffff81049f6b>] ? sched_rt_period_timer+0xb3/0x1e4
 [<ffffffff81413a4c>] ? _atomic_spin_unlock+0x56/0x71
 [<ffffffff81049f6b>] sched_rt_period_timer+0xb3/0x1e4
 [<ffffffff81049eb8>] ? sched_rt_period_timer+0x0/0x1e4
 [<ffffffff81083a5e>] __run_hrtimer+0x89/0xd5
 [<ffffffff81084046>] ? hrtimer_interrupt+0xd0/0x1a9
 [<ffffffff8108409d>] hrtimer_interrupt+0x127/0x1a9
 [<ffffffff8102784e>] smp_apic_timer_interrupt+0x94/0xbe
 [<ffffffff8100cc33>] apic_timer_interrupt+0x13/0x20
 <EOI>  [<ffffffff8141140f>] ? preempt_schedule+0x55/0x98
 [<ffffffff8103ffd3>] ? need_resched+0x0/0x4f
 [<ffffffff81411432>] ? preempt_schedule+0x78/0x98
 [<ffffffff81413b7a>] ? _atomic_spin_unlock_irqrestore+0x76/0x91
 [<ffffffff8141235b>] ? rt_spin_lock_slowunlock+0x58/0x9c
 [<ffffffff8141316e>] ? rt_spin_unlock+0x57/0x72
 [<ffffffff81100125>] ? __remove_mapping+0x62/0x10e
 [<ffffffff811001a1>] ? __remove_mapping+0xde/0x10e
 [<ffffffff81100c18>] ? shrink_page_list+0x588/0x6f0
 [<ffffffff81095670>] ? trace_hardirqs_on+0x20/0x36
 [<ffffffff810e18d4>] ? trace_preempt_on+0x2c/0x6d
 [<ffffffff81416d54>] ? sub_preempt_count+0xad/0xd7
 [<ffffffff811012d6>] ? shrink_list+0x2e5/0x5b0
 [<ffffffff81095670>] ? trace_hardirqs_on+0x20/0x36
 [<ffffffff810fc6b9>] ? throttle_vm_writeout+0x43/0xb4
 [<ffffffff81101850>] ? shrink_zone+0x2af/0x38a
 [<ffffffff8110297e>] ? try_to_free_pages+0xde/0x3cd
 [<ffffffff810ff671>] ? count_vm_event+0x4e/0x8c
 [<ffffffff81416d54>] ? sub_preempt_count+0xad/0xd7
 [<ffffffff81102af0>] ? try_to_free_pages+0x250/0x3cd
 [<ffffffff810ff744>] ? isolate_pages_global+0x0/0x1fc
 [<ffffffff810faf52>] ? __alloc_pages_nodemask+0x44a/0x640
 [<ffffffff811287ac>] ? alloc_page_vma+0xda/0xf0
 [<ffffffff8110f702>] ? handle_mm_fault+0x190/0x68e
 [<ffffffff8109fccf>] ? rt_down_read_trylock+0x81/0xa1
 [<ffffffff81416c75>] ? do_page_fault+0x29f/0x2d1
 [<ffffffff81412bf5>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814142cf>] ? page_fault+0x1f/0x30
 [<ffffffff810f2a5f>] ? file_read_actor+0x60/0x15f
 [<ffffffff810f3335>] ? find_get_page+0x84/0xaa
 [<ffffffff8104003e>] ? should_resched+0x1c/0x51
 [<ffffffff810f4fde>] ? generic_file_aio_read+0x374/0x5cb
 [<ffffffffa007fd5e>] ? xfs_read+0x183/0x205 [xfs]
 [<ffffffffa007b7ed>] ? xfs_file_aio_read+0x7b/0x92 [xfs]
 [<ffffffff81138685>] ? do_sync_read+0xf9/0x152
 [<ffffffff8112b1f7>] ? kmem_cache_free+0x54/0xdf
 [<ffffffff81080352>] ? autoremove_wake_function+0x0/0x5e
 [<ffffffff81416d54>] ? sub_preempt_count+0xad/0xd7
 [<ffffffff811ce9f4>] ? security_file_permission+0x24/0x3a
 [<ffffffff81412bb6>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff811393a3>] ? vfs_read+0xbe/0x12f
 [<ffffffff81139510>] ? sys_read+0x59/0x99
 [<ffffffff8100bfeb>] ? system_call_fastpath+0x16/0x1b
