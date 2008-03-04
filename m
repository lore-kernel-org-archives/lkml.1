Return-Path: <linux-kernel-owner+w=401wt.eu-S1759106AbYCDI4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759106AbYCDI4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYCDI4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:56:13 -0500
Received: from jenny.ondioline.org ([66.220.1.122]:57667 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbYCDI4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:56:12 -0500
From: Paul Collins <paul@burly.ondioline.org>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: 11s softlockup and hang with kvm on 2.6.24.3
Date: Tue, 04 Mar 2008 21:55:32 +1300
Message-ID: <873ar6rhq3.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110007 (No Gnus v0.7) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running kvm 62 on 2.6.24.3 (the extraversion is reported due to a local
patch to vfat) I just got a couple of soft lockups and a hang.  I was
installing FreeBSD 7 at the time.

I am trying again with v2.6.25-rc3-369-g976dde0.

Here are the wossnames.


Mar  4 21:20:12 burly kernel: BUG: soft lockup - CPU#0 stuck for 11s! [kvm:11263]
Mar  4 21:20:12 burly kernel: CPU 0:
Mar  4 21:20:12 burly kernel: Modules linked in: tun nfs lockd nfs_acl sunrpc i915 drm hci_usb rfcomm hidp l2cap bluetooth fan ac battery cpufreq_stats fuse tcp_cubic aes_x86_64 aes_generic cbc blkcipher dm_crypt dm_mod kvm_intel kvm acpi_cpufreq firewire_sbp2 loop snd_hda_intel snd_pcm snd_timer firewire_ohci firewire_core i2c_i801 thermal snd crc_itu_t i2c_core intel_agp button processor soundcore snd_page_alloc evdev
Mar  4 21:20:12 burly kernel: Pid: 11263, comm: kvm Not tainted 2.6.24.3-gbc08d7e4 #30
Mar  4 21:20:12 burly kernel: RIP: 0010:[<ffffffff8043f963>]  [<ffffffff8043f963>] _spin_unlock_irqrestore+0x8/0x9
Mar  4 21:20:12 burly kernel: RSP: 0018:ffff810050cad8e0  EFLAGS: 00000286
Mar  4 21:20:12 burly kernel: RAX: ffff81000101a0d8 RBX: 00000000ffffffff RCX: 0000000000000001
Mar  4 21:20:12 burly kernel: RDX: ffff81001dbd6000 RSI: 0000000000000286 RDI: ffff81000101a080
Mar  4 21:20:12 burly kernel: RBP: ffff81007c359ec0 R08: 0000000000000001 R09: ffff81007c359ec0
Mar  4 21:20:13 burly kernel: R10: 0000000000000000 R11: ffffffff881099d6 R12: 0000000000000000
Mar  4 21:20:13 burly kernel: R13: ffffffff881099d6 R14: ffff810078c17f50 R15: 0000000000000000
Mar  4 21:20:13 burly kernel: FS:  00002b1aa02d7160(0000) GS:ffffffff8055f000(0000) knlGS:0000000000000000
Mar  4 21:20:13 burly kernel: CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
Mar  4 21:20:13 burly kernel: CR2: 00000008007c1000 CR3: 0000000050ca8000 CR4: 00000000000026e0
Mar  4 21:20:13 burly kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar  4 21:20:13 burly kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar  4 21:20:13 burly kernel: 
Mar  4 21:20:13 burly kernel: Call Trace:
Mar  4 21:20:13 burly kernel:  [<ffffffff8024b60e>] hrtimer_try_to_cancel+0x67/0x70
Mar  4 21:20:13 burly kernel:  [<ffffffff8024b629>] hrtimer_cancel+0x12/0x16
Mar  4 21:20:13 burly kernel:  [<ffffffff8024b623>] hrtimer_cancel+0xc/0x16
Mar  4 21:20:13 burly kernel:  [<ffffffff880fc9cd>] :kvm:kvm_migrate_apic_timer+0x19/0x2e
Mar  4 21:20:13 burly kernel:  [<ffffffff88109a07>] :kvm_intel:vmx_vcpu_load+0x31/0x105
Mar  4 21:20:13 burly kernel:  [<ffffffff880fca86>] :kvm:apic_update_ppr+0x1f/0x51
Mar  4 21:20:13 burly kernel:  [<ffffffff880f2249>] :kvm:kvm_vcpu_block+0x5a/0xae
Mar  4 21:20:13 burly kernel:  [<ffffffff8022fb01>] default_wake_function+0x0/0xe
Mar  4 21:20:13 burly kernel:  [<ffffffff88109d18>] :kvm_intel:skip_emulated_instruction+0x41/0x4a
Mar  4 21:20:14 burly kernel:  [<ffffffff880f444c>] :kvm:kvm_emulate_halt+0x26/0x46
Mar  4 21:20:14 burly kernel:  [<ffffffff880f30b7>] :kvm:kvm_vcpu_ioctl_run+0x29c/0x3b5
Mar  4 21:20:14 burly kernel:  [<ffffffff880f32dd>] :kvm:kvm_vcpu_ioctl+0x10d/0xd5c
Mar  4 21:20:14 burly kernel:  [<ffffffff80290a99>] fget_light+0x6c/0x8a
Mar  4 21:20:14 burly kernel:  [<ffffffff8029b89b>] do_select+0x436/0x453
Mar  4 21:20:14 burly kernel:  [<ffffffff8029bd3d>] __pollwait+0x0/0xe1
Mar  4 21:20:14 burly kernel:  [<ffffffff8022faf0>] try_to_wake_up+0x2f2/0x303
Mar  4 21:20:14 burly kernel:  [<ffffffff803e7693>] __alloc_skb+0x3d/0x133
Mar  4 21:20:14 burly kernel:  [<ffffffff8022bd26>] __wake_up_common+0x46/0x75
Mar  4 21:20:14 burly kernel:  [<ffffffff8022e0ff>] __wake_up+0x38/0x4f
Mar  4 21:20:14 burly kernel:  [<ffffffff802f4983>] dummy_file_permission+0x0/0x3
Mar  4 21:20:14 burly kernel:  [<ffffffff80288e9c>] add_partial_tail+0x12/0x3f
Mar  4 21:20:14 burly kernel:  [<ffffffff803e8e01>] skb_copy_datagram_iovec+0x25/0x1eb
Mar  4 21:20:14 burly kernel:  [<ffffffff80289d46>] __slab_free+0x7d/0x2af
Mar  4 21:20:14 burly kernel:  [<ffffffff8024d798>] getnstimeofday+0x2f/0x87
Mar  4 21:20:14 burly kernel:  [<ffffffff8024b9c7>] ktime_get_real+0xc/0x41
Mar  4 21:20:14 burly kernel:  [<ffffffff803ec077>] netif_rx_ni+0x19/0x1d
Mar  4 21:20:14 burly kernel:  [<ffffffff8823fdd7>] :tun:tun_chr_aio_write+0x1d2/0x213
Mar  4 21:20:14 burly kernel:  [<ffffffff8029bab0>] core_sys_select+0x1f8/0x264
Mar  4 21:20:14 burly kernel:  [<ffffffff8028f705>] do_sync_write+0xd1/0x118
Mar  4 21:20:14 burly kernel:  [<ffffffff80248cfb>] autoremove_wake_function+0x0/0x2e
Mar  4 21:20:15 burly kernel:  [<ffffffff802414e1>] dequeue_signal+0x8f/0x110
Mar  4 21:20:15 burly kernel:  [<ffffffff8024d798>] getnstimeofday+0x2f/0x87
Mar  4 21:20:15 burly kernel:  [<ffffffff8029a8dd>] do_ioctl+0x21/0x6b
Mar  4 21:20:15 burly kernel:  [<ffffffff8029ab6a>] vfs_ioctl+0x243/0x25c
Mar  4 21:20:15 burly kernel:  [<ffffffff8028ff2f>] vfs_write+0x13a/0x14f
Mar  4 21:20:15 burly kernel:  [<ffffffff8029abd4>] sys_ioctl+0x51/0x71
Mar  4 21:20:15 burly kernel:  [<ffffffff8020befe>] system_call+0x7e/0x83
Mar  4 21:20:15 burly kernel: 
Mar  4 21:20:15 burly kernel: BUG: soft lockup - CPU#1 stuck for 11s! [mpd:3178]
Mar  4 21:20:15 burly kernel: CPU 1:
Mar  4 21:20:15 burly kernel: Modules linked in: tun nfs lockd nfs_acl sunrpc i915 drm hci_usb rfcomm hidp l2cap bluetooth fan ac battery cpufreq_stats fuse tcp_cubic aes_x86_64 aes_generic cbc blkcipher dm_crypt dm_mod kvm_intel kvm acpi_cpufreq firewire_sbp2 loop snd_hda_intel snd_pcm snd_timer firewire_ohci firewire_core i2c_i801 thermal snd crc_itu_t i2c_core intel_agp button processor soundcore snd_page_alloc evdev
Mar  4 21:20:15 burly kernel: Pid: 3178, comm: mpd Not tainted 2.6.24.3-gbc08d7e4 #30
Mar  4 21:20:15 burly kernel: RIP: 0010:[<ffffffff8024ba70>]  [<ffffffff8024ba70>] run_hrtimer_softirq+0x74/0xe3
Mar  4 21:20:15 burly kernel: RSP: 0000:ffff81007c373ef0  EFLAGS: 00000202
Mar  4 21:20:15 burly kernel: RAX: ffff810078c17f90 RBX: ffff810078c17f90 RCX: 0000000000000000
Mar  4 21:20:15 burly kernel: RDX: ffff81000101a138 RSI: ffff81000101a0d8 RDI: ffff810078c17f50
Mar  4 21:20:15 burly kernel: RBP: ffff81007c373e70 R08: ffff810078c17fa8 R09: 0000000000000000
Mar  4 21:20:15 burly kernel: R10: ffff81000101d680 R11: ffffffff805e82e0 R12: ffffffff8020cb36
Mar  4 21:20:16 burly kernel: R13: ffff810078c17f50 R14: ffffffff880fcd8d R15: ffffffff8024b986
Mar  4 21:20:16 burly kernel: FS:  00002b98dfcb0500(0000) GS:ffff81007c001700(0000) knlGS:0000000000000000
Mar  4 21:20:16 burly kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Mar  4 21:20:16 burly kernel: CR2: 00000008007c1000 CR3: 0000000065a37000 CR4: 00000000000026e0
Mar  4 21:20:16 burly kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar  4 21:20:16 burly kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar  4 21:20:16 burly kernel: 
Mar  4 21:20:16 burly kernel: Call Trace:
Mar  4 21:20:17 burly kernel:  <IRQ>  [<ffffffff8023b825>] __do_softirq+0x65/0xce
Mar  4 21:20:17 burly kernel:  [<ffffffff8025027c>] tick_program_event+0x31/0x4d
Mar  4 21:20:17 burly kernel:  [<ffffffff8020d08c>] call_softirq+0x1c/0x28
Mar  4 21:20:17 burly kernel:  [<ffffffff8020e4e0>] do_softirq+0x2c/0x7d
Mar  4 21:20:17 burly kernel:  [<ffffffff8023b77b>] irq_exit+0x3f/0x84
Mar  4 21:20:17 burly kernel:  [<ffffffff8021e33c>] smp_apic_timer_interrupt+0x3f/0x53
Mar  4 21:20:17 burly kernel:  [<ffffffff8020cb36>] apic_timer_interrupt+0x66/0x70
Mar  4 21:20:17 burly kernel:  <EOI> 


-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
