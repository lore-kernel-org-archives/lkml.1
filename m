Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbXKUT2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbXKUT2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 14:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbXKUT2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 14:28:04 -0500
Received: from cfif3.ist.utl.pt ([193.136.161.44]:32843 "EHLO cfif3.ist.utl.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbXKUT2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 14:28:00 -0500
X-Greylist: delayed 3720 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Nov 2007 14:28:00 EST
From: paulo@cfif3.ist.utl.pt
Message-Id: <200711211825.lALIPp5U002919@cfif3.ist.utl.pt>
Subject: kernel BUG at fs/inode.c
To: linux-kernel@vger.kernel.org
Date: Wed, 21 Nov 2007 18:25:51 +0000 (WET)
Reply-to: paulo.nogueira@ist.utl.pt
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



  hi,

 This is to report a kernel bug that appeared while using the
 non-standard kernel 2.6.24-rc1-git10, which I was using for
 the purpose of helping to debug a different problem.
 I am not sure if the problem is easily reproducible... if
 needed I'll try with the latest fc7 kernel.

 The dump listed below was extracted from /var/log/messages
 and was generated after copying > 1GB of data to a DVD-RAM,
 udf format. When it seemed to have stopped (after 2 hours!)
 I issued the eject command. It then seemed to write more
 data to the disk (possibly part of the data had not been
 really copied, and it was syncing) and a few minutes after
 this notice came up.

  best regards
   Paulo Nogueira

  PS please cc replies to me



Nov 20 23:30:23 *** kernel: kernel BUG at fs/inode.c:191!
Nov 20 23:30:23 *** kernel: invalid opcode: 0000 [1] SMP 
Nov 20 23:30:23 *** kernel: CPU 1 
Nov 20 23:30:23 *** kernel: Modules linked in: udf usb_storage autofs4 sunrpc cpufreq_ondemand reiserfs dm_mirror dm_mod video output sbs sbshc battery ac power_supply ipv6 snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd sr_mod button forcedeth soundcore cdrom k8temp pcspkr snd_page_alloc pata_amd hwmon i2c_nforce2 i2c_core sg sata_nv ata_generic libata sd_mod scsi_mod ext3 jbd mbcache ehci_hcd ohci_hcd uhci_hcd
Nov 20 23:30:23 *** kernel: Pid: 11762, comm: umount Not tainted 2.6.24-rc1-git10 #0
Nov 20 23:30:23 *** kernel: RIP: 0010:[<ffffffff810a9886>]  [<ffffffff810a9886>] destroy_inode+0xd/0x47
Nov 20 23:30:23 *** kernel: RSP: 0018:ffff81001ac47dd8  EFLAGS: 00010202
Nov 20 23:30:23 *** kernel: RAX: 0000000000000001 RBX: ffff81010ac0b548 RCX: ffff81010ac0b548
Nov 20 23:30:23 *** kernel: RDX: 0000000000000007 RSI: ffff81010ac0b750 RDI: ffff81010ac0b548
Nov 20 23:30:23 *** kernel: RBP: ffff81010ac0b548 R08: 8000000000000000 R09: ffffffff81405a18
Nov 20 23:30:23 *** kernel: R10: 0000000000000000 R11: ffff81001ac47d58 R12: 00000000000001ba
Nov 20 23:30:23 *** kernel: R13: ffff81001ac47e18 R14: ffff81001aba6068 R15: 0000000000000000
Nov 20 23:30:23 *** kernel: FS:  00002b38ac69f6c0(0000) GS:ffff810100001800(0000) knlGS:0000000000000000
Nov 20 23:30:23 *** kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Nov 20 23:30:23 *** kernel: CR2: 00000000008cb370 CR3: 000000001ac6a000 CR4: 00000000000006e0
Nov 20 23:30:23 *** kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 20 23:30:23 *** kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 20 23:30:23 *** kernel: Process umount (pid: 11762, threadinfo ffff81001ac46000, task ffff81010492c000)
Nov 20 23:30:23 *** kernel: Stack:  ffff81010ac0b558 ffffffff810a9e84 0000000000000018 ffff8101059af048
Nov 20 23:30:23 *** kernel:  ffff81010610a8c0 0000000000004a57 ffff81010610a8c0 ffffffff810aa160
Nov 20 23:30:23 *** kernel:  ffff81010ac0b7d8 ffff81001aba6058 0000000000000000 ffff81010610a800
Nov 20 23:30:23 *** kernel: Call Trace:
Nov 20 23:30:23 *** kernel:  [<ffffffff810a9e84>] dispose_list+0xae/0xe0
Nov 20 23:30:23 *** kernel:  [<ffffffff810aa160>] invalidate_inodes+0xc1/0xdf
Nov 20 23:30:23 *** kernel:  [<ffffffff81099445>] generic_shutdown_super+0x39/0xd2
Nov 20 23:30:23 *** kernel:  [<ffffffff810994eb>] kill_block_super+0xd/0x1e
Nov 20 23:30:23 *** kernel:  [<ffffffff810995b6>] deactivate_super+0x6a/0x83
Nov 20 23:30:23 *** kernel:  [<ffffffff810ac1cd>] sys_umount+0x23d/0x273
Nov 20 23:30:23 *** kernel:  [<ffffffff8109abde>] sys_newstat+0x19/0x31
Nov 20 23:30:23 *** kernel:  [<ffffffff81116a90>] __up_write+0x27/0xf3
Nov 20 23:30:23 *** kernel:  [<ffffffff8100be8e>] system_call+0x7e/0x83
Nov 20 23:30:23 *** kernel: 
Nov 20 23:30:23 *** kernel: 
Nov 20 23:30:23 *** kernel: Code: 0f 0b eb fe 48 89 df e8 e7 39 04 00 48 8b 83 f8 00 00 00 48 
Nov 20 23:30:23 *** kernel: RIP  [<ffffffff810a9886>] destroy_inode+0xd/0x47
Nov 20 23:30:23 *** kernel:  RSP <ffff81001ac47dd8>
Nov 20 23:30:23 *** kernel: WARNING: at kernel/exit.c:917 do_exit()
Nov 20 23:30:23 *** kernel: 
Nov 20 23:30:23 *** kernel: Call Trace:
Nov 20 23:30:23 *** kernel:  [<ffffffff8103c55a>] do_exit+0x4f/0x768
Nov 20 23:30:23 *** kernel:  [<ffffffff8100d64d>] kernel_math_error+0x0/0x71
Nov 20 23:30:23 *** kernel:  [<ffffffff8100da73>] do_invalid_op+0x85/0x8f
Nov 20 23:30:23 *** kernel:  [<ffffffff810a9886>] destroy_inode+0xd/0x47
Nov 20 23:30:23 *** kernel:  [<ffffffff8104bd77>] bit_waitqueue+0x10/0x9f
Nov 20 23:30:23 *** kernel:  [<ffffffff8104be44>] wake_up_bit+0x11/0x22
Nov 20 23:30:23 *** kernel:  [<ffffffff810b23cf>] __writeback_single_inode+0x2a5/0x2b7
Nov 20 23:30:23 *** kernel:  [<ffffffff882cb85c>] :udf:udf_current_aext+0xe8/0x143
Nov 20 23:30:23 *** kernel:  [<ffffffff81251039>] error_exit+0x0/0x51
Nov 20 23:30:23 *** kernel:  [<ffffffff810a9886>] destroy_inode+0xd/0x47
Nov 20 23:30:23 *** kernel:  [<ffffffff810a9882>] destroy_inode+0x9/0x47
Nov 20 23:30:23 *** kernel:  [<ffffffff810a9e84>] dispose_list+0xae/0xe0
Nov 20 23:30:23 *** kernel:  [<ffffffff810aa160>] invalidate_inodes+0xc1/0xdf
Nov 20 23:30:23 *** kernel:  [<ffffffff81099445>] generic_shutdown_super+0x39/0xd2
Nov 20 23:30:23 *** kernel:  [<ffffffff810994eb>] kill_block_super+0xd/0x1e
Nov 20 23:30:23 *** kernel:  [<ffffffff810995b6>] deactivate_super+0x6a/0x83
Nov 20 23:30:23 *** kernel:  [<ffffffff810ac1cd>] sys_umount+0x23d/0x273
Nov 20 23:30:23 *** kernel:  [<ffffffff8109abde>] sys_newstat+0x19/0x31
Nov 20 23:30:23 *** kernel:  [<ffffffff81116a90>] __up_write+0x27/0xf3
Nov 20 23:30:23 *** kernel:  [<ffffffff8100be8e>] system_call+0x7e/0x83
Nov 20 23:30:23 *** kernel: 


