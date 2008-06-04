Return-Path: <linux-kernel-owner+w=401wt.eu-S1761592AbYFDSLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761592AbYFDSLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 14:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758493AbYFDSK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 14:10:58 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:49433 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757567AbYFDSK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 14:10:56 -0400
Date: Wed, 4 Jun 2008 20:10:19 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: kvm: unable to handle kernel NULL pointer dereference
Message-ID: <20080604181019.GB10897@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Avi Kivity <avi@qumranet.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080601084802.GA3146@yamamaya.is-a-geek.org> <4846716E.5000506@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4846716E.5000506@qumranet.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Tobias Diedrich wrote:
> > Hi,
> >
> > I get the following Oops when trying to start qemu-kvm
> > (Debian/unstable kvm package version 60+dfsg-1) on my system:
> >
> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> > IP: [<ffffffff8021d44f>] svm_vcpu_run+0x34/0x351
> >   
> 
> 
> kvm-60 is quite old.

Maybe, but AFAIK a kernel NULL pointer dereference should not happen
and is always a kernel bug (Even if it may be triggered only by old
userspace)?
Maybe I'm wrong about that. :)

> Can you try kvm-69?

Sure.
*updating*
*trying*
I still get an Oops:
ii  kvm            69+dfsg-1      Full virtualization on x86 hardware


BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff8021d44f>] svm_vcpu_run+0x34/0x351
PGD 7e01b067 PUD 7bc86067 PMD 0 
Oops: 0000 [1] PREEMPT 
CPU 0 
Modules linked in: zaurus cdc_ether usbnet snd_hda_intel k8temp radeon drm snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_emu10k1 snd_seq_midi snd_rawmidi snd_ac97_codec ac97_bus snd_util_mem forcedeth emu10k1_gp gameport snd_hwdep pata_amd [last unloaded: snd_hda_intel]
Pid: 11113, comm: kvm Tainted: G        W 2.6.26-rc4 #29
RIP: 0010:[<ffffffff8021d44f>]  [<ffffffff8021d44f>] svm_vcpu_run+0x34/0x351
RSP: 0018:ffff81007866fc38  EFLAGS: 00010046
RAX: ffff810076d42040 RBX: 00000000fffffffc RCX: 0000000000000000
RDX: ffff810076d42040 RSI: ffff810079b41000 RDI: ffff810076d42040
RBP: ffff81007866fc88 R08: 0000000000000002 R09: 0000000000000001
R10: ffffffff804237e5 R11: ffff81007866fc88 R12: ffff810076d42040
R13: 0000000000000000 R14: ffff810079b41000 R15: 000000000000ae80
FS:  00000000419b1950(0063) GS:ffffffff808bc000(0000) knlGS:00000000f712b6c0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000008 CR3: 0000000079b8d000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kvm (pid: 11113, threadinfo ffff81007866e000, task ffff810019db8300)
Stack:  ffff81007866fc68 ffff810076d42040 ffff810076d42040 ffff81007bc600a8
 ffff810076d42040 00000000fffffffc ffff810076d42040 0000000000000000
 ffff810079b41000 000000000000ae80 ffff81007866fcc8 ffffffff8020fa41
Call Trace:
 [<ffffffff8020fa41>] kvm_arch_vcpu_ioctl_run+0x46a/0x6df
 [<ffffffff8020ab98>] kvm_vcpu_ioctl+0xfd/0x3d0
 [<ffffffff80293df1>] ? kmem_cache_free+0x6e/0x81
 [<ffffffff8024cf89>] ? __dequeue_signal+0x1c/0x167
 [<ffffffff802a322e>] vfs_ioctl+0x2a/0x77
 [<ffffffff802a34d6>] do_vfs_ioctl+0x25b/0x270
 [<ffffffff802a352d>] sys_ioctl+0x42/0x65
 [<ffffffff8021fffb>] system_call_after_swapgs+0x7b/0x80


Code: 55 41 54 53 48 83 ec 28 48 89 7d b8 48 8b 87 50 15 00 00 48 8b 0d ba 9c 6f 00 c6 40 5c 00 48 8b 45 b8 83 b8 a0 00 00 00 00 75 0d <48> 8b 51 08 48 39 90 68 15 00 00 74 4f 8b 41 14 3b 41 10 76 1a 
RIP  [<ffffffff8021d44f>] svm_vcpu_run+0x34/0x351
 RSP <ffff81007866fc38>
CR2: 0000000000000008
---[ end trace 5f8408bfe79febf6 ]---
note: kvm[11113] exited with preempt_count 1
BUG: sleeping function called from invalid context at kernel/rwsem.c:21
in_atomic():1, irqs_disabled():0
INFO: lockdep is turned off.
Pid: 11113, comm: kvm Tainted: G      D W 2.6.26-rc4 #29

Call Trace:
 [<ffffffff8025ed42>] ? __debug_show_held_locks+0x1b/0x24
 [<ffffffff8023c1f4>] __might_sleep+0x10a/0x10c
 [<ffffffff8067fa1f>] down_read+0x1d/0x45
 [<ffffffff802624b3>] futex_wake+0x38/0x101
 [<ffffffff8026345b>] do_futex+0xb8/0x916
 [<ffffffff8025793f>] ? ktime_get_ts+0x49/0x4e
 [<ffffffff80257955>] ? ktime_get+0x11/0x42
 [<ffffffff8023aa37>] ? hrtick_start_fair+0x111/0x11e
 [<ffffffff8023a7ea>] ? wakeup_preempt_entity+0x59/0x7d
 [<ffffffff80263dae>] sys_futex+0xf5/0x113
 [<ffffffff8023fc1e>] mm_release+0x85/0x8e
 [<ffffffff8024385d>] exit_mm+0x1f/0xde
 [<ffffffff8024502a>] do_exit+0x23c/0x68a
 [<ffffffff80220ee3>] oops_begin+0x0/0x6e
 [<ffffffff802337e0>] do_page_fault+0x6a8/0x760
 [<ffffffff8068152d>] error_exit+0x0/0xa9
 [<ffffffff804237e5>] ? __up_read+0x1c/0x93
 [<ffffffff8021d44f>] ? svm_vcpu_run+0x34/0x351
 [<ffffffff8020fa41>] ? kvm_arch_vcpu_ioctl_run+0x46a/0x6df
 [<ffffffff8020ab98>] ? kvm_vcpu_ioctl+0xfd/0x3d0
 [<ffffffff80293df1>] ? kmem_cache_free+0x6e/0x81
 [<ffffffff8024cf89>] ? __dequeue_signal+0x1c/0x167
 [<ffffffff802a322e>] ? vfs_ioctl+0x2a/0x77
 [<ffffffff802a34d6>] ? do_vfs_ioctl+0x25b/0x270
 [<ffffffff802a352d>] ? sys_ioctl+0x42/0x65
 [<ffffffff8021fffb>] ? system_call_after_swapgs+0x7b/0x80

HTH,

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
