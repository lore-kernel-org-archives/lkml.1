Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbYK3TeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbYK3TeZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 14:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbYK3TeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 14:34:14 -0500
Received: from relay3.ptmail.sapo.pt ([212.55.154.23]:42881 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752565AbYK3TeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 14:34:12 -0500
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Sun, 30 Nov 2008 19:34:01 +0000
From: Luis Henriques <henrix@sapo.pt>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [BUG] kvm crashes in 2.6.28-rc6-00007-ged31348
Message-ID: <20081130193401.GA7690@hades>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Maybe this is duplicated bug report, but since I was not able to find any
reference to it, I am reporting it anyway.

I am running 2.6.28-rc6-00007-ged31348 on x86_64.

I just tried to start kvm and got the following:

[  883.483978] ------------[ cut here ]------------
[  883.483995] kernel BUG at /home/miguel/projects/linux/trees/linux-2.6/arch/x86/kvm/../../../virt/kvm/kvm_main.c:1824!
[  883.484006] invalid opcode: 0000 [#1] PREEMPT SMP 
[  883.484021] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
[  883.484031] Dumping ftrace buffer:
[  883.484038]    (ftrace buffer empty)
[  883.484044] CPU 1 
[  883.484052] Modules linked in: kqemu loop aes_x86_64 aes_generic af_packet binfmt_misc bridge stp llc rfcomm bnep sco l2cap bluetooth vboxdrv kvm_amd kvm 
parport_pc ppdev parport ipv6 powernow_k8 cpufreq_userspace cpufreq_powersave cpufreq_stats cpufreq_ondemand freq_table cpufreq_conservative container sbs wm
i sbshc iptable_filter ip_tables x_tables sbp2 arc4 snd_hda_intel ecb snd_pcm snd_page_alloc snd_hwdep ath5k snd_seq snd_timer snd_seq_device mac80211 led_cl
ass uvcvideo i2c_piix4 snd compat_ioctl32 videodev v4l1_compat cfg80211 i2c_core k8temp psmouse rfkill video output battery soundcore ac input_polldev button
 evdev ext3 jbd mbcache sr_mod cdrom ata_generic pata_acpi sg sd_mod pata_atiixp ahci ide_pci_generic ohci1394 ieee1394 ide_core ehci_hcd ohci_hcd libata usb
 core scsi_mod r8169 mii thermal processor fan fuse
 [  883.484270] Pid: 10886, comm: kvm Tainted: G        W  2.6.28-rc6-00007-ged31348 #1
 [  883.484270] RIP: 0010:[<ffffffffa04b8262>]  [<ffffffffa04b8262>] kvm_handle_fault_on_reboot+0x12/0x20 [kvm]
 [  883.484270] RSP: 0018:ffff88007940dcf8  EFLAGS: 00010046
 [  883.484270] RAX: ffff88007b582000 RBX: ffff8800794e8000 RCX: 0000000000000000
 [  883.484270] RDX: ffff8800794e8000 RSI: ffff88007940dd2c RDI: 000000007f803a80
 [  883.484270] RBP: ffff88007940dcf8 R08: 0000000000000001 R09: 0000000000000001
 [  883.484270] R10: 0000000000000000 R11: 0000000000000246 R12: ffff8800794e8000
 [  883.484270] R13: 0000000000000000 R14: ffff880078862000 R15: ffff8800794e8cc0
 [  883.484270] FS:  00000000417c2950(0063) GS:ffff88007f803a80(0000) knlGS:0000000000000000
 [  883.484270] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 [  883.484270] CR2: 00007fb0461a8000 CR3: 0000000079417000 CR4: 00000000000006e0
 [  883.484270] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [  883.484270] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 [  883.484270] Process kvm (pid: 10886, threadinfo ffff88007940c000, task ffff880079dd0000)
 [  883.484270] Stack:
 [  883.484270]  ffff88007940dd58 ffffffffa04e9350 ffffffff807b83f8 ffff8800794e8000
 [  883.484270]  0000000000638000 ffff8800775e40a8 00000000794e8000 ffff8800794e80b8
 [  883.484270]  ffff8800794e8000 0000000000000000 ffff880078862000 ffff8800794e8cc0
 [  883.484270] Call Trace:
 [  883.484270]  [<ffffffffa04e9350>] svm_vcpu_run+0x1f0/0x460 [kvm_amd]
 [  883.484270]  [<ffffffffa04c1b94>] kvm_arch_vcpu_ioctl_run+0x2a4/0x950 [kvm]
 [  883.484270]  [<ffffffff802e9cc2>] ? __slab_free+0xe2/0x3d0
 [  883.484270]  [<ffffffffa04b87b7>] kvm_vcpu_ioctl+0x2f7/0x5b0 [kvm]
 [  883.484270]  [<ffffffff80259e3d>] ? __sigqueue_free+0x3d/0x50
 [  883.484270]  [<ffffffff8025cd16>] ? sys_rt_sigtimedwait+0x156/0x2c0
 [  883.484270]  [<ffffffff803025c6>] vfs_ioctl+0x36/0xb0
 [  883.484270]  [<ffffffff803026bc>] do_vfs_ioctl+0x7c/0x480
 [  883.484270]  [<ffffffff80302b59>] sys_ioctl+0x99/0xa0
 [  883.484270]  [<ffffffff8020c67a>] system_call_fastpath+0x16/0x1b
 [  883.484270] Code: 00 00 31 c0 48 c7 86 80 00 00 00 00 31 4e a0 c9 c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 1f 44 00 00 80 3d 40 ca 02 00 00 75 06 <0f> 0b eb fe 66 90 eb fe 66 0f 1f 44 00 00 55 48 89 e5 41 54 53 
 [  883.484270] RIP  [<ffffffffa04b8262>] kvm_handle_fault_on_reboot+0x12/0x20 [kvm]
 [  883.484270]  RSP <ffff88007940dcf8>
 [  883.484270] ---[ end trace 4eaa2a86a8e2da22 ]---
 [  883.485030] note: kvm[10886] exited with preempt_count 1
 [  883.485043] BUG: sleeping function called from invalid context at /home/miguel/projects/linux/trees/linux-2.6/kernel/rwsem.c:21
 [  883.485052] in_atomic(): 1, irqs_disabled(): 0, pid: 10886, name: kvm
 [  883.485059] INFO: lockdep is turned off.
 [  883.485066] Pid: 10886, comm: kvm Tainted: G      D W  2.6.28-rc6-00007-ged31348 #1
 [  883.485073] Call Trace:
 [  883.485083]  [<ffffffff80275983>] ? __debug_show_held_locks+0x23/0x30
 [  883.485096]  [<ffffffff80242614>] __might_sleep+0x144/0x170
 [  883.485107]  [<ffffffff804e1b32>] down_read+0x22/0x60
 [  883.485119]  [<ffffffff8040e38c>] ? vt_console_print+0x6c/0x370
 [  883.485128]  [<ffffffff80277bf1>] futex_wake+0x41/0x130
 [  883.485139]  [<ffffffff803a4138>] ? sprintf+0x68/0x70
 [  883.485148]  [<ffffffff802790bc>] do_futex+0x9c/0xa80
 [  883.485158]  [<ffffffff804e331f>] ? _spin_unlock_irqrestore+0x4f/0x90
 [  883.485171]  [<ffffffff8024d68d>] ? release_console_sem+0x1fd/0x250
 [  883.485182]  [<ffffffff8024dbce>] ? vprintk+0x1ae/0x490
 [  883.485191]  [<ffffffff80279b5c>] sys_futex+0xbc/0x150
 [  883.485200]  [<ffffffff80278552>] ? exit_robust_list+0x82/0x150
 [  883.485211]  [<ffffffff8024a459>] mm_release+0xa9/0xe0
 [  883.485222]  [<ffffffff8024efd6>] exit_mm+0x26/0x160
 [  883.485232]  [<ffffffff802865d4>] ? acct_collect+0x194/0x1f0
 [  883.485243]  [<ffffffff80250c5b>] do_exit+0x17b/0x9c0
 [  883.485282]  [<ffffffff8021006f>] ? show_registers+0x9f/0x2b0
 [  883.485292]  [<ffffffff80411472>] ? do_unblank_screen+0x22/0x150
 [  883.485303]  [<ffffffff804e4c3e>] oops_end+0xbe/0xc0
 [  883.485313]  [<ffffffff802102e3>] die+0x63/0x90
 [  883.485323]  [<ffffffff804e46b6>] do_trap+0x146/0x170
 [  883.485333]  [<ffffffff804e7741>] ? atomic_notifier_call_chain+0x11/0x20
 [  883.485344]  [<ffffffff8020ec45>] do_invalid_op+0x95/0xb0
 [  883.485372]  [<ffffffffa04b8262>] ? kvm_handle_fault_on_reboot+0x12/0x20 [kvm]
 [  883.485383]  [<ffffffff804e2ca5>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [  883.485393]  [<ffffffff8020ebb0>] ? do_invalid_op+0x0/0xb0
 [  883.485403]  [<ffffffff804e3cbf>] error_exit+0x0/0xc8
 [  883.485430]  [<ffffffffa04b8262>] ? kvm_handle_fault_on_reboot+0x12/0x20 [kvm]
 [  883.485447]  [<ffffffffa04e9350>] svm_vcpu_run+0x1f0/0x460 [kvm_amd]
 [  883.485476]  [<ffffffffa04c1b94>] kvm_arch_vcpu_ioctl_run+0x2a4/0x950 [kvm]
 [  883.485489]  [<ffffffff802e9cc2>] ? __slab_free+0xe2/0x3d0
 [  883.485516]  [<ffffffffa04b87b7>] kvm_vcpu_ioctl+0x2f7/0x5b0 [kvm]
 [  883.485528]  [<ffffffff80259e3d>] ? __sigqueue_free+0x3d/0x50
 [  883.485539]  [<ffffffff8025cd16>] ? sys_rt_sigtimedwait+0x156/0x2c0
 [  883.485549]  [<ffffffff803025c6>] vfs_ioctl+0x36/0xb0
 [  883.485559]  [<ffffffff803026bc>] do_vfs_ioctl+0x7c/0x480
 [  883.485569]  [<ffffffff80302b59>] sys_ioctl+0x99/0xa0
 [  883.485579]  [<ffffffff8020c67a>] system_call_fastpath+0x16/0x1b

--
Luis Henriques

