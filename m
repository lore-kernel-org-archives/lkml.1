Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbYE1Ljb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbYE1Ljb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 07:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYE1LjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 07:39:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbYE1LjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 07:39:20 -0400
Subject: Re: 2.6.26rc4 GFS2 oops.
From: Steven Whitehouse <swhiteho@redhat.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080527194420.GB14577@redhat.com>
References: <20080527194420.GB14577@redhat.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Wed, 28 May 2008 12:36:04 +0100
Message-Id: <1211974564.3635.585.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2008-05-27 at 15:44 -0400, Dave Jones wrote:
> Single node GFS2 filesystem. Run fsx. Boom.
> 
I've tried it on -nmw and it seems to run ok, and I'm currently running
it on the current upstream kernel and its done 1/2 hour so far with no
sign of a problem.

Can you give a few more details, such as the block size of the fs, the
exact command line for fsx (I was just running with defaults) and
perhaps check all the info into a Red Hat bugzilla? I know this is
upstream, but I tend to use "Fedora/rawhide" to keep tabs on such things
just so as all the bugs are in the same place,

Steve.

> BUG: unable to handle kernel paging request at ffff81002690e000
> IP: [<ffffffffa049fb51>] :gfs2:rgblk_search+0x14f/0x3b3
> PGD 8063 PUD 9063 PMD 26845163 PTE 800000002690e160
> Oops: 0000 [1] SMP DEBUG_PAGEALLOC
> CPU 3 
> Modules linked in: lock_nolock gfs2 sunrpc ipt_REJECT nf_conntrack_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 ext2 vfat fat xfs loop dm_mirror dm_log dm_mod ppdev raid1 snd_intel8x0 snd_ac97_codec ac97_bus dcdbas tuner_simple tuner_types snd_seq_dummy tda9887 tda8290 tea5767 snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device wm8775 parport_pc parport floppy cx25840 snd_pcm_oss snd_mixer_oss tuner snd_pcm ivtv sr_mod sg snd_timer snd i2c_algo_bit cdrom pcspkr i2c_i801 soundcore cx2341x snd_page_alloc v4l2_common videodev v4l1_compat iTCO_wdt tveeprom iTCO_vendor_support i2c_core e1000 e752x_edac edac_core button shpchp ata_generic ata_piix pata_acpi libata sd_mod scsi_mod raid456 async_xor async_memcpy async_tx xor raid0 ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: freq_table]
> Pid: 3016, comm: fsx Not tainted 2.6.26-0.33.rc4.fc10.x86_64 #1
> RIP: 0010:[<ffffffffa049fb51>]  [<ffffffffa049fb51>] :gfs2:rgblk_search+0x14f/0x3b3
> RSP: 0000:ffff81003241fa38  EFLAGS: 00010297
> RAX: 5555555555555555 RBX: ffff81003989f108 RCX: 0000000000000000
> RDX: ffff81002690dffb RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff81003241fa98 R08: ffff81002690dfff R09: 0000000000000000
> R10: ffff81002690e000 R11: 5555555555555555 R12: ffff81002690d018
> R13: 0000000000000002 R14: ffff81002690d018 R15: ffff81003241c180
> FS:  00007fe823bcb6f0(0000) GS:ffff81003f811af0(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff81002690e000 CR3: 00000000324a7000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process fsx (pid: 3016, threadinfo ffff81003241e000, task ffff8100331325a0)
> Stack:  ffff81003241fa58 0000000200000000 ffff81003241fabc 020281003281ec40
>  ffff81003989f0c8 0000000200000004 ffff810000000001 ffff81003241c180
>  0000000000000000 0000000000000000 ffff81003281ebf0 ffff81003241fb80
> Call Trace:
>  [<ffffffffa04a05ff>] :gfs2:try_rgrp_unlink+0x5b/0xc1
>  [<ffffffffa04a0eb7>] :gfs2:gfs2_inplace_reserve_i+0x302/0x6db
>  [<ffffffffa0497cb2>] :gfs2:gfs2_page_mkwrite+0x16f/0x31a
>  [<ffffffff81057177>] ? trace_hardirqs_on+0xf1/0x115
>  [<ffffffff812af05b>] ? _read_unlock_irq+0x2b/0x31
>  [<ffffffff81082b0e>] ? find_lock_page+0x9c/0xab
>  [<ffffffffa0497bb0>] ? :gfs2:gfs2_page_mkwrite+0x6d/0x31a
>  [<ffffffff810915f8>] __do_fault+0x1a5/0x3a8
>  [<ffffffff81093173>] handle_mm_fault+0x339/0x6f3
>  [<ffffffff812b1a9f>] ? do_page_fault+0x3f2/0x8b9
>  [<ffffffff812b1b57>] do_page_fault+0x4aa/0x8b9
>  [<ffffffff811447a1>] ? __up_write+0xf0/0xff
>  [<ffffffff810556b5>] ? lock_release_holdtime+0x1e/0x108
>  [<ffffffff812af175>] ? _spin_unlock_irqrestore+0x3f/0x47
>  [<ffffffff81057177>] ? trace_hardirqs_on+0xf1/0x115
>  [<ffffffff811447a1>] ? __up_write+0xf0/0xff
>  [<ffffffff812aed64>] ? trace_hardirqs_on_thunk+0x35/0x3a
>  [<ffffffff81057177>] ? trace_hardirqs_on+0xf1/0x115
>  [<ffffffff812af86d>] error_exit+0x0/0xa9
> 
> 
> Code: 39 c2 75 13 eb 39 44 89 c9 4c 89 e0 48 89 c2 8d 47 ff 4c 8d 44 02 01 4c 39 d2 73 3b 0f b6 3a eb ab 48 b8 55 55 55 55 55 55 55 55 <48> 23 02 48 8d 7a 08 0f 18 0f 4c 39 d8 75 0e 48 89 fa eb 04 4d 
> RIP  [<ffffffffa049fb51>] :gfs2:rgblk_search+0x14f/0x3b3
>  RSP <ffff81003241fa38>
> CR2: ffff81002690e000
> ---[ end trace cf259c4517fc15f3 ]---
> BUG: sleeping function called from invalid context at kernel/rwsem.c:21
> in_atomic():0, irqs_disabled():1
> INFO: lockdep is turned off.
> irq event stamp: 17166792
> hardirqs last  enabled at (17166791): [<ffffffff812af175>] _spin_unlock_irqrestore+0x3f/0x47
> hardirqs last disabled at (17166792): [<ffffffff812b16d3>] do_page_fault+0x26/0x8b9
> softirqs last  enabled at (17166514): [<ffffffff8103c8bb>] __do_softirq+0xe4/0xf1
> softirqs last disabled at (17166509): [<ffffffff8100d23c>] call_softirq+0x1c/0x28
> Pid: 3016, comm: fsx Tainted: G      D   2.6.26-0.33.rc4.fc10.x86_64 #1
> 
> Call Trace:
>  [<ffffffff81054fb2>] ? print_irqtrace_events+0x110/0x114
>  [<ffffffff8102ffb5>] __might_sleep+0xd9/0xdb
>  [<ffffffff812ade5d>] down_read+0x20/0x6d
>  [<ffffffff81066b32>] acct_collect+0x42/0x1a4
>  [<ffffffff8103aa6f>] do_exit+0x21b/0x774
>  [<ffffffff811ab797>] ? do_unblank_screen+0x112/0x12a
>  [<ffffffff812aff58>] oops_begin+0x0/0x90
>  [<ffffffff812b1e8a>] do_page_fault+0x7dd/0x8b9
>  [<ffffffff81011dab>] ? native_sched_clock+0x50/0x6d
>  [<ffffffff81011dab>] ? native_sched_clock+0x50/0x6d
>  [<ffffffff81056fe6>] ? mark_held_locks+0x5c/0x77
>  [<ffffffff81011dab>] ? native_sched_clock+0x50/0x6d
>  [<ffffffff81011dab>] ? native_sched_clock+0x50/0x6d
>  [<ffffffff812af86d>] error_exit+0x0/0xa9
>  [<ffffffffa049fb51>] ? :gfs2:rgblk_search+0x14f/0x3b3
>  [<ffffffffa04a05ff>] ? :gfs2:try_rgrp_unlink+0x5b/0xc1
>  [<ffffffffa04a0eb7>] ? :gfs2:gfs2_inplace_reserve_i+0x302/0x6db
>  [<ffffffffa0497cb2>] ? :gfs2:gfs2_page_mkwrite+0x16f/0x31a
>  [<ffffffff81057177>] ? trace_hardirqs_on+0xf1/0x115
>  [<ffffffff812af05b>] ? _read_unlock_irq+0x2b/0x31
>  [<ffffffff81082b0e>] ? find_lock_page+0x9c/0xab
>  [<ffffffffa0497bb0>] ? :gfs2:gfs2_page_mkwrite+0x6d/0x31a
>  [<ffffffff810915f8>] ? __do_fault+0x1a5/0x3a8
>  [<ffffffff81093173>] ? handle_mm_fault+0x339/0x6f3
>  [<ffffffff812b1a9f>] ? do_page_fault+0x3f2/0x8b9
>  [<ffffffff812b1b57>] ? do_page_fault+0x4aa/0x8b9
>  [<ffffffff811447a1>] ? __up_write+0xf0/0xff
>  [<ffffffff810556b5>] ? lock_release_holdtime+0x1e/0x108
>  [<ffffffff812af175>] ? _spin_unlock_irqrestore+0x3f/0x47
>  [<ffffffff81057177>] ? trace_hardirqs_on+0xf1/0x115
>  [<ffffffff811447a1>] ? __up_write+0xf0/0xff
>  [<ffffffff812aed64>] ? trace_hardirqs_on_thunk+0x35/0x3a
>  [<ffffffff81057177>] ? trace_hardirqs_on+0xf1/0x115
>  [<ffffffff812af86d>] ? error_exit+0x0/0xa9
> 
> 

